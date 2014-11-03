Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaKCIbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:31:32 -0500
Received: from down.free-electrons.com ([37.187.137.238]:51407 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbaKCIbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:31:11 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 5/5] irqchip: atmel-aic: add missing entry for rm9200 irq fixups
Date: Mon,  3 Nov 2014 09:31:04 +0100
Message-Id: <1415003464-29239-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

The at91rm9200 have an RTT block and thus must at91rm9200_aic_irq_fixup
has to be called when intialazing the irqchip.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/irqchip/irq-atmel-aic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index 6f011b4..a6398a5 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -226,6 +226,7 @@ static void __init at91sam9g45_aic_irq_fixup(struct device_node *root)
 }
 
 static const struct of_device_id __initdata aic_irq_fixups[] = {
+	{ .compatible = "atmel,at91rm9200", .data = at91rm9200_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9g45", .data = at91sam9g45_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9n12", .data = at91rm9200_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9rl", .data = at91sam9g45_aic_irq_fixup },
-- 
1.9.1

