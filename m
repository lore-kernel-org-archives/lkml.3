Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaBWVkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:52188 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaBWVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:01 -0500
Message-Id: <20140223212736.333718121@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc <linuxppc-dev@lists.ozlabs.org>
Subject: [patch 01/26] powerpc: irq: Use generic_handle_irq
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=powerpc-irq-use-generic-handle-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc <linuxppc-dev@lists.ozlabs.org>
---
 arch/powerpc/kernel/irq.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: tip/arch/powerpc/kernel/irq.c
===================================================================
--- tip.orig/arch/powerpc/kernel/irq.c
+++ tip/arch/powerpc/kernel/irq.c
@@ -465,7 +465,6 @@ static inline void check_stack_overflow(
 
 void __do_irq(struct pt_regs *regs)
 {
-	struct irq_desc *desc;
 	unsigned int irq;
 
 	irq_enter();
@@ -487,11 +486,8 @@ void __do_irq(struct pt_regs *regs)
 	/* And finally process it */
 	if (unlikely(irq == NO_IRQ))
 		__get_cpu_var(irq_stat).spurious_irqs++;
-	else {
-		desc = irq_to_desc(irq);
-		if (likely(desc))
-			desc->handle_irq(irq, desc);
-	}
+	else
+		generic_handle_irq(irq);
 
 	trace_irq_exit(regs);
 


