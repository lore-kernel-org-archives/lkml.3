Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664Ab3GPRiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:38:05 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:53804 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589Ab3GPRez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:34:55 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [RFC PATCH 01/10] alpha: Don't if-out dp264_device_interrupt.
Date: Tue, 16 Jul 2013 10:34:09 -0700
Message-Id: <1373996058-13399-2-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code as written is correct, and will be used by QEMU emulation.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/sys_dp264.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index 5bf401f..6c35159 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -190,9 +190,6 @@ static struct irq_chip clipper_irq_type = {
 static void
 dp264_device_interrupt(unsigned long vector)
 {
-#if 1
-	printk("dp264_device_interrupt: NOT IMPLEMENTED YET!!\n");
-#else
 	unsigned long pld;
 	unsigned int i;
 
@@ -210,12 +207,7 @@ dp264_device_interrupt(unsigned long vector)
 			isa_device_interrupt(vector);
 		else
 			handle_irq(16 + i);
-#if 0
-		TSUNAMI_cchip->dir0.csr = 1UL << i; mb();
-		tmp = TSUNAMI_cchip->dir0.csr;
-#endif
 	}
-#endif
 }
 
 static void 
-- 
1.8.1.4

