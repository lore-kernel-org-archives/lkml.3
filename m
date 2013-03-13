Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3CMJXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:23:16 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39067 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3CMJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:23:15 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, sachin.kamat@linaro.org, patches@linaro.org,
        chanho61.park@samsung.com, kgene.kim@samsung.com
Subject: [PATCH 1/1] irqchip: exynos-combiner: Fix checkpatch warnings
Date: Wed, 13 Mar 2013 14:42:24 +0530
Message-Id: <1363165944-7480-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following warnings:
WARNING: line over 80 characters
WARNING: Prefer pr_warn(... to pr_warning(...

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/irqchip/exynos-combiner.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index e8501db..66b1bf5 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -229,13 +229,15 @@ void __init combiner_init(void __iomem *combiner_base,
 	irq_base = irq_alloc_descs(COMBINER_IRQ(0, 0), 1, nr_irq, 0);
 	if (IS_ERR_VALUE(irq_base)) {
 		irq_base = COMBINER_IRQ(0, 0);
-		pr_warning("%s: irq desc alloc failed. Continuing with %d as linux irq base\n", __func__, irq_base);
+		pr_warn("%s: irq desc alloc failed. "
+			"Continuing with %d as linux irq base\n",
+			__func__, irq_base);
 	}
 
 	combiner_irq_domain = irq_domain_add_legacy(np, nr_irq, irq_base, 0,
 				&combiner_irq_domain_ops, &combiner_data);
 	if (WARN_ON(!combiner_irq_domain)) {
-		pr_warning("%s: irq domain init failed\n", __func__);
+		pr_warn("%s: irq domain init failed\n", __func__);
 		return;
 	}
 
-- 
1.7.4.1

