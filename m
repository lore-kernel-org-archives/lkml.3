Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab3CQVuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:50:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48867 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756529Ab3CQVuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:50:12 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 2/2] alpha: irq: remove deprecated use of IRQF_DISABLED
Date: Sun, 17 Mar 2013 21:49:56 +0000
Message-Id: <1363556996-21180-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1363556996-21180-1-git-send-email-will.deacon@arm.com>
References: <1363556996-21180-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt handlers are always invoked with interrupts disabled, so
remove all uses of the deprecated IRQF_DISABLED flag.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/alpha/include/asm/floppy.h |  2 +-
 arch/alpha/kernel/irq_alpha.c   |  1 -
 arch/alpha/kernel/sys_titan.c   | 14 +++++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/include/asm/floppy.h b/arch/alpha/include/asm/floppy.h
index 46cefbd..bae97eb 100644
--- a/arch/alpha/include/asm/floppy.h
+++ b/arch/alpha/include/asm/floppy.h
@@ -26,7 +26,7 @@
 #define fd_disable_irq()        disable_irq(FLOPPY_IRQ)
 #define fd_cacheflush(addr,size) /* nothing */
 #define fd_request_irq()        request_irq(FLOPPY_IRQ, floppy_interrupt,\
-					    IRQF_DISABLED, "floppy", NULL)
+					    0, "floppy", NULL)
 #define fd_free_irq()           free_irq(FLOPPY_IRQ, NULL)
 
 #ifdef CONFIG_PCI
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index 1216dfb..f433fc1 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -229,7 +229,6 @@ process_mcheck_info(unsigned long vector, unsigned long la_ptr,
 
 struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED,
 	.name		= "timer",
 };
 
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index 5cf4a48..a53cf03 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -280,15 +280,15 @@ titan_late_init(void)
 	 * all reported to the kernel as machine checks, so the handler
 	 * is a nop so it can be called to count the individual events.
 	 */
-	titan_request_irq(63+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(63+16, titan_intr_nop, 0,
 		    "CChip Error", NULL);
-	titan_request_irq(62+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(62+16, titan_intr_nop, 0,
 		    "PChip 0 H_Error", NULL);
-	titan_request_irq(61+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(61+16, titan_intr_nop, 0,
 		    "PChip 1 H_Error", NULL);
-	titan_request_irq(60+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(60+16, titan_intr_nop, 0,
 		    "PChip 0 C_Error", NULL);
-	titan_request_irq(59+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(59+16, titan_intr_nop, 0,
 		    "PChip 1 C_Error", NULL);
 
 	/* 
@@ -348,9 +348,9 @@ privateer_init_pci(void)
 	 * Hook a couple of extra err interrupts that the
 	 * common titan code won't.
 	 */
-	titan_request_irq(53+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(53+16, titan_intr_nop, 0,
 		    "NMI", NULL);
-	titan_request_irq(50+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(50+16, titan_intr_nop, 0,
 		    "Temperature Warning", NULL);
 
 	/*
-- 
1.8.0

