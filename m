Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866AbaEGPvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:51:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:48549 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbaEGPn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:57 -0400
Message-Id: <20140507154336.566531793@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [patch 13/32] ia64: Remove unused check_irq_used()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=ia64-remove-unused-check-irq-used.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just stumbled over it when staring into ia64 irq handling.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/include/asm/hw_irq.h |    1 -
 arch/ia64/kernel/irq_ia64.c    |    8 --------
 2 files changed, 9 deletions(-)

Index: tip/arch/ia64/include/asm/hw_irq.h
===================================================================
--- tip.orig/arch/ia64/include/asm/hw_irq.h
+++ tip/arch/ia64/include/asm/hw_irq.h
@@ -132,7 +132,6 @@ extern int reserve_irq_vector (int vecto
 extern void __setup_vector_irq(int cpu);
 extern void ia64_send_ipi (int cpu, int vector, int delivery_mode, int redirect);
 extern void ia64_native_register_percpu_irq (ia64_vector vec, struct irqaction *action);
-extern int check_irq_used (int irq);
 extern void destroy_and_reserve_irq (unsigned int irq);
 
 #if defined(CONFIG_SMP) && (defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_DIG))
Index: tip/arch/ia64/kernel/irq_ia64.c
===================================================================
--- tip.orig/arch/ia64/kernel/irq_ia64.c
+++ tip/arch/ia64/kernel/irq_ia64.c
@@ -93,14 +93,6 @@ static int irq_status[NR_IRQS] = {
 	[0 ... NR_IRQS -1] = IRQ_UNUSED
 };
 
-int check_irq_used(int irq)
-{
-	if (irq_status[irq] == IRQ_USED)
-		return 1;
-
-	return -1;
-}
-
 static inline int find_unassigned_irq(void)
 {
 	int irq;


