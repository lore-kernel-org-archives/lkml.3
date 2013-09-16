Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3IPFbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 01:31:39 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:56941 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3IPFbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 01:31:37 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, tglx@linutronix.de, thomas.ab@samsung.com,
        Chander Kashyap <chander.kashyap@linaro.org>
Subject: [PATCH] irqchip: exynos-combiner: remove hard-coded irq_base value
Date: Mon, 16 Sep 2013 11:01:22 +0530
Message-Id: <1379309482-19779-1-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass '0' in place of hardcoded "irq_base" value as "first_irq" parameter to
"irq_domain_add_simple" in order to use linear irq domain.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
---
 drivers/irqchip/exynos-combiner.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index 4c68265..b4ed356 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -206,8 +206,7 @@ static unsigned int combiner_lookup_irq(int group)
 
 static void __init combiner_init(void __iomem *combiner_base,
 				 struct device_node *np,
-				 unsigned int max_nr,
-				 int irq_base)
+				 unsigned int max_nr)
 {
 	int i, irq;
 	unsigned int nr_irq;
@@ -221,7 +220,7 @@ static void __init combiner_init(void __iomem *combiner_base,
 		return;
 	}
 
-	combiner_irq_domain = irq_domain_add_simple(np, nr_irq, irq_base,
+	combiner_irq_domain = irq_domain_add_simple(np, nr_irq, 0,
 				&combiner_irq_domain_ops, combiner_data);
 	if (WARN_ON(!combiner_irq_domain)) {
 		pr_warning("%s: irq domain init failed\n", __func__);
@@ -248,7 +247,6 @@ static int __init combiner_of_init(struct device_node *np,
 {
 	void __iomem *combiner_base;
 	unsigned int max_nr = 20;
-	int irq_base = -1;
 
 	combiner_base = of_iomap(np, 0);
 	if (!combiner_base) {
@@ -262,14 +260,7 @@ static int __init combiner_of_init(struct device_node *np,
 			__func__, max_nr);
 	}
 
-	/* 
-	 * FIXME: This is a hardwired COMBINER_IRQ(0,0). Once all devices
-	 * get their IRQ from DT, remove this in order to get dynamic
-	 * allocation.
-	 */
-	irq_base = 160;
-
-	combiner_init(combiner_base, np, max_nr, irq_base);
+	combiner_init(combiner_base, np, max_nr);
 
 	return 0;
 }
-- 
1.7.9.5

