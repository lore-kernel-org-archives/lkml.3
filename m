Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaBWVok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:44:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:52290 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaBWVkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:10 -0500
Message-Id: <20140223212738.460384932@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [patch 20/26] genirq: Provide irq_is_allocated()
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=genirq-provide-irq-is-allocated.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another proper interface to replace Xen hackery. No idea why Xen needs
this, but I'm not masochistic enough to understand that mess.

Not-Yet-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 kernel/irq/irqdesc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: tip/kernel/irq/irqdesc.c
===================================================================
--- tip.orig/kernel/irq/irqdesc.c
+++ tip/kernel/irq/irqdesc.c
@@ -390,6 +390,17 @@ err:
 EXPORT_SYMBOL_GPL(__irq_alloc_descs);
 
 /**
+ * irq_is_allocated - query whether an irq desc is allocated for an irq number
+ * @irq:	irq number
+ *
+ * Returns a momentary racy snapshot of the allocation state
+ */
+bool irq_is_allocated(unsigned int irq)
+{
+	return irq < nr_irqs && test_bit(irq, allocated_irqs);
+}
+
+/**
  * irq_reserve_irqs - mark irqs allocated
  * @from:	mark from irq number
  * @cnt:	number of irqs to mark


