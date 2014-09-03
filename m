Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaICJIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:08:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44164 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756000AbaICJH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:07:57 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 4/5] irqchip: atmel-aic: rename at91sam9_aic_irq_fixup for naming consistency
Date: Wed,  3 Sep 2014 11:07:50 +0200
Message-Id: <1409735271-15353-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename at91sam9_aic_irq_fixup into at91rm9200_aic_irq_fixup to be
consistent with other fixup functions.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/irqchip/irq-atmel-aic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index 8e3b585..a755cfe 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -211,7 +211,7 @@ static const struct irq_domain_ops aic_irq_ops = {
 	.xlate	= aic_irq_domain_xlate,
 };
 
-static void __init at91sam9_aic_irq_fixup(struct device_node *root)
+static void __init at91rm9200_aic_irq_fixup(struct device_node *root)
 {
 	aic_common_rtc_irq_fixup(root);
 }
@@ -229,9 +229,9 @@ static void __init at91sam9g45_aic_irq_fixup(struct device_node *root)
 
 static const struct of_device_id __initdata aic_irq_fixups[] = {
 	{ .compatible = "atmel,at91sam9g45", .data = at91sam9g45_aic_irq_fixup },
-	{ .compatible = "atmel,at91sam9n12", .data = at91sam9_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9n12", .data = at91rm9200_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9rl", .data = at91sam9g45_aic_irq_fixup },
-	{ .compatible = "atmel,at91sam9x5", .data = at91sam9_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9x5", .data = at91rm9200_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9260", .data = at91sam9260_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9261", .data = at91sam9260_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9263", .data = at91sam9260_aic_irq_fixup },
-- 
1.9.1

