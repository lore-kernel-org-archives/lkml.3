Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaINL70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 07:59:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34197 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaINL7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 07:59:15 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 3.17-rc4 v6 1/6] ARM: remove unused do_unexp_fiq() function
Date: Sun, 14 Sep 2014 12:57:10 +0100
Message-Id: <1410695835-10496-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410695835-10496-1-git-send-email-daniel.thompson@linaro.org>
References: <1410695835-10496-1-git-send-email-daniel.thompson@linaro.org>
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

