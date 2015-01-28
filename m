Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbbA2Kqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:46:53 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753840AbbA2I7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 157/176] x86/tsc: Change Fast TSC calibration failed from error to info
Date: Wed, 28 Jan 2015 15:29:47 +0100
Message-Id: <15d8526256d31d890b807130a74827e7fc8637f3.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Demers <alexandre.f.demers@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 520452172e6b318f3a8bd9d4fe1e25066393de25 upstream.

Many users see this message when booting without knowning that it is
of no importance and that TSC calibration may have succeeded by
another way.

As explained by Paul Bolle in
http://lkml.kernel.org/r/1348488259.1436.22.camel@x61.thuisdomein

  "Fast TSC calibration failed" should not be considered as an error
  since other calibration methods are being tried afterward. At most,
  those send a warning if they fail (not an error). So let's change
  the message from error to warning.

[ tglx: Make if pr_info. It's really not important at all ]

Fixes: c767a54ba065 x86/debug: Add KERN_<LEVEL> to bare printks, convert printks to pr_<level>
Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Link: http://lkml.kernel.org/r/1418106470-6906-1-git-send-email-alexandre.f.demers@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a7fef605b1c0..cefe57ce4ebd 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -386,7 +386,7 @@ static unsigned long quick_pit_calibrate(void)
 			goto success;
 		}
 	}
-	pr_err("Fast TSC calibration failed\n");
+	pr_info("Fast TSC calibration failed\n");
 	return 0;
 
 success:
-- 
2.2.2

