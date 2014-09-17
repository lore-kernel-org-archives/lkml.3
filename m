Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaIQQK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:10:26 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45349 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbaIQQKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:10:23 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 3.17-rc4 v7 1/6] ARM: remove unused do_unexp_fiq() function
Date: Wed, 17 Sep 2014 09:10:13 -0700
Message-Id: <1410970218-28847-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org>
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

do_unexp_fiq() has never been called by any code in the last 10 years,
it's about time it was removed!

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/kernel/traps.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index c8e4bb7..a447dcc 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -460,12 +460,6 @@ die_sig:
 	arm_notify_die("Oops - undefined instruction", regs, &info, 0, 6);
 }
 
-asmlinkage void do_unexp_fiq (struct pt_regs *regs)
-{
-	printk("Hmm.  Unexpected FIQ received, but trying to continue\n");
-	printk("You may have a hardware problem...\n");
-}
-
 /*
  * bad_mode handles the impossible case in the vectors.  If you see one of
  * these, then it's extremely serious, and could mean you have buggy hardware.
-- 
1.9.3

