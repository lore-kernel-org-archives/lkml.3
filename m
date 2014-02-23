Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaBWVkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:52364 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaBWVkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:15 -0500
Message-Id: <20140223212738.099977064@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        ia64 <linux-ia64@vger.kernel.org>
Subject: [patch 17/26] ia64: Use the core irq stats function
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=ia64-use-core-irq-stats-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: ia64 <linux-ia64@vger.kernel.org>

---
 arch/ia64/kernel/irq_ia64.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: tip/arch/ia64/kernel/irq_ia64.c
===================================================================
--- tip.orig/arch/ia64/kernel/irq_ia64.c
+++ tip/arch/ia64/kernel/irq_ia64.c
@@ -489,14 +489,13 @@ ia64_handle_irq (ia64_vector vector, str
 	ia64_srlz_d();
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		int irq = local_vector_to_irq(vector);
-		struct irq_desc *desc = irq_to_desc(irq);
 
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_incr_irqs_this_cpu(irq, desc);
+			kstat_incr_irq_this_cpu(irq);
 		} else if (unlikely(IS_RESCHEDULE(vector))) {
 			scheduler_ipi();
-			kstat_incr_irqs_this_cpu(irq, desc);
+			kstat_incr_irq_this_cpu(irq);
 		} else {
 			ia64_setreg(_IA64_REG_CR_TPR, vector);
 			ia64_srlz_d();
@@ -549,13 +548,12 @@ void ia64_process_pending_intr(void)
 	  */
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		int irq = local_vector_to_irq(vector);
-		struct irq_desc *desc = irq_to_desc(irq);
 
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_incr_irqs_this_cpu(irq, desc);
+			kstat_incr_irq_this_cpu(irq);
 		} else if (unlikely(IS_RESCHEDULE(vector))) {
-			kstat_incr_irqs_this_cpu(irq, desc);
+			kstat_incr_irq_this_cpu(irq);
 		} else {
 			struct pt_regs *old_regs = set_irq_regs(NULL);
 


