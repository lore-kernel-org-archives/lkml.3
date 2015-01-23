Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbbAWKAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:00:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbbAWKAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:00:51 -0500
Date: Fri, 23 Jan 2015 02:00:40 -0800
From: tip-bot for Alexandre Demers <tipbot@zytor.com>
Message-ID: <tip-520452172e6b318f3a8bd9d4fe1e25066393de25@git.kernel.org>
Cc: hpa@zytor.com, alexandre.f.demers@gmail.com, tglx@linutronix.de,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Reply-To: alexandre.f.demers@gmail.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1418106470-6906-1-git-send-email-alexandre.f.demers@gmail.com>
References: <1418106470-6906-1-git-send-email-alexandre.f.demers@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/tsc:
  Change Fast TSC calibration failed from error to info
Git-Commit-ID: 520452172e6b318f3a8bd9d4fe1e25066393de25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  520452172e6b318f3a8bd9d4fe1e25066393de25
Gitweb:     http://git.kernel.org/tip/520452172e6b318f3a8bd9d4fe1e25066393de25
Author:     Alexandre Demers <alexandre.f.demers@gmail.com>
AuthorDate: Tue, 9 Dec 2014 01:27:50 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jan 2015 10:53:52 +0100

x86/tsc: Change Fast TSC calibration failed from error to info

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1418106470-6906-1-git-send-email-alexandre.f.demers@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index b7e50bb..5054497 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -617,7 +617,7 @@ static unsigned long quick_pit_calibrate(void)
 			goto success;
 		}
 	}
-	pr_err("Fast TSC calibration failed\n");
+	pr_info("Fast TSC calibration failed\n");
 	return 0;
 
 success:
