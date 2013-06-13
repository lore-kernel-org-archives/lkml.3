Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab3FMXG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:06:56 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48020 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab3FMXGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:06:55 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] irqdomain: remove irq_domain_generate_simple()
Date: Fri, 14 Jun 2013 00:06:50 +0100
Message-Id: <1371164810-14598-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody calls it; remove the function

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
I'll merge this through the irqdomain tree

 include/linux/irqdomain.h |  8 --------
 kernel/irq/irqdomain.c    | 15 ---------------
 2 files changed, 23 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index f9e8e06..fe7c57d 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -205,14 +205,6 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
 			const u32 *intspec, unsigned int intsize,
 			irq_hw_number_t *out_hwirq, unsigned int *out_type);
 
-#if defined(CONFIG_OF_IRQ)
-extern void irq_domain_generate_simple(const struct of_device_id *match,
-					u64 phys_base, unsigned int irq_start);
-#else /* CONFIG_OF_IRQ */
-static inline void irq_domain_generate_simple(const struct of_device_id *match,
-					u64 phys_base, unsigned int irq_start) { }
-#endif /* !CONFIG_OF_IRQ */
-
 #else /* CONFIG_IRQ_DOMAIN */
 static inline void irq_dispose_mapping(unsigned int virq) { }
 #endif /* !CONFIG_IRQ_DOMAIN */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 80e9249..e47b356 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -741,18 +741,3 @@ const struct irq_domain_ops irq_domain_simple_ops = {
 	.xlate = irq_domain_xlate_onetwocell,
 };
 EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
-
-#ifdef CONFIG_OF_IRQ
-void irq_domain_generate_simple(const struct of_device_id *match,
-				u64 phys_base, unsigned int irq_start)
-{
-	struct device_node *node;
-	pr_debug("looking for phys_base=%llx, irq_start=%i\n",
-		(unsigned long long) phys_base, (int) irq_start);
-	node = of_find_matching_node_by_address(NULL, match, phys_base);
-	if (node)
-		irq_domain_add_legacy(node, 32, irq_start, 0,
-				      &irq_domain_simple_ops, NULL);
-}
-EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
-#endif
-- 
1.8.1.2

