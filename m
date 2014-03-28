Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaC1R73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:59:29 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45103 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaC1R70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:59:26 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 01/10] genirq: generic chip: export irq_map_generic_chip function
Date: Fri, 28 Mar 2014 18:58:59 +0100
Message-Id: <1396029548-10928-2-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the generic irq map function in order to provide irq_domain ops with
generic mapping and specific of xlate function (needed by the new atmel
AIC driver).

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 include/linux/irq.h       |    2 ++
 kernel/irq/generic-chip.c |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..19b5e3b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -765,6 +765,8 @@ void irq_gc_eoi(struct irq_data *d);
 int irq_gc_set_wake(struct irq_data *d, unsigned int on);
 
 /* Setup functions for irq_chip_generic */
+int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw_irq);
 struct irq_chip_generic *
 irq_alloc_generic_chip(const char *name, int nr_ct, unsigned int irq_base,
 		       void __iomem *reg_base, irq_flow_handler_t handler);
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 452d6f2..cf80e7b 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -341,8 +341,8 @@ static struct lock_class_key irq_nested_lock_class;
 /*
  * irq_map_generic_chip - Map a generic chip for an irq domain
  */
-static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
-				irq_hw_number_t hw_irq)
+int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw_irq)
 {
 	struct irq_data *data = irq_get_irq_data(virq);
 	struct irq_domain_chip_generic *dgc = d->gc;
@@ -394,6 +394,7 @@ static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
 	irq_modify_status(virq, dgc->irq_flags_to_clear, dgc->irq_flags_to_set);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(irq_map_generic_chip);
 
 struct irq_domain_ops irq_generic_chip_ops = {
 	.map	= irq_map_generic_chip,
-- 
1.7.9.5

