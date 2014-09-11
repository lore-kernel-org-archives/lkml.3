Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbaIKPyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:54:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47776 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756744AbaIKPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:54:17 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 1/7] irqchip: atmel-aic5: Add sama5d4 support
Date: Thu, 11 Sep 2014 17:54:06 +0200
Message-Id: <1410450852-1834-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sama5d4 support to irq-atmel-aic5.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
 drivers/irqchip/irq-atmel-aic5.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
index dc7d98607a89..a11aae8fb006 100644
--- a/drivers/irqchip/irq-atmel-aic5.c
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -295,6 +295,7 @@ static void __init sama5d3_aic_irq_fixup(struct device_node *root)
 
 static const struct of_device_id __initdata aic5_irq_fixups[] = {
 	{ .compatible = "atmel,sama5d3", .data = sama5d3_aic_irq_fixup },
+	{ .compatible = "atmel,sama5d4", .data = sama5d3_aic_irq_fixup },
 	{ /* sentinel */ },
 };
 
@@ -349,3 +350,12 @@ static int __init sama5d3_aic5_of_init(struct device_node *node,
 	return aic5_of_init(node, parent, NR_SAMA5D3_IRQS);
 }
 IRQCHIP_DECLARE(sama5d3_aic5, "atmel,sama5d3-aic", sama5d3_aic5_of_init);
+
+#define NR_SAMA5D4_IRQS		68
+
+static int __init sama5d4_aic5_of_init(struct device_node *node,
+				       struct device_node *parent)
+{
+	return aic5_of_init(node, parent, NR_SAMA5D4_IRQS);
+}
+IRQCHIP_DECLARE(sama5d4_aic5, "atmel,sama5d4-aic", sama5d4_aic5_of_init);
-- 
1.9.1

