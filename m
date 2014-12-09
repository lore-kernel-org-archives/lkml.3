Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaLIG1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:27:55 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38446 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaLIG1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:27:53 -0500
From: Alexandre Demers <alexandre.f.demers@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] x86/tsc: Change Fast TSC calibration failed from error to warning
Date: Tue,  9 Dec 2014 01:27:50 -0500
Message-Id: <1418106470-6906-1-git-send-email-alexandre.f.demers@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most users see this message when booting without knowning that it is of 
mostly no importance and that TSC calibration may have succeeded by another 
way.

As explained thoroufly by Paul Bolle in 2012 
(http://lkml.iu.edu//hypermail/linux/kernel/1209.3/00224.html), 
"Fast TSC calibration failed" should not be considered as an error since 
other calibration methods are being tried afterward. At most, those send a 
warning if they fail (not an error). So let's change the message from error 
to warning.

It should also fix bug 75971: fast tsc calibration failed on ubuntu 14.04 LTS

Tested on kernel 3.18.

v2: fixed comment.

Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>

---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index b6025f9..5a22022 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -617,7 +617,7 @@ static unsigned long quick_pit_calibrate(void)
 			goto success;
 		}
 	}
-	pr_err("Fast TSC calibration failed\n");
+	pr_warn("Fast TSC calibration failed\n");
 	return 0;
 
 success:
-- 
2.1.0

