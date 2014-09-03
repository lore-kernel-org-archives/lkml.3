Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaICJIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:08:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44168 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756017AbaICJH5 (ORCPT
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
Subject: [PATCH 5/5] irqchip: atmel-aic: add missing entry for rm9200 irq fixups
Date: Wed,  3 Sep 2014 11:07:51 +0200
Message-Id: <1409735271-15353-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The at91rm9200 have an RTT block and thus must at91rm9200_aic_irq_fixup
has to be called when intialazing the irqchip.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/irqchip/irq-atmel-aic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index a755cfe..02ff229 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -228,6 +228,7 @@ static void __init at91sam9g45_aic_irq_fixup(struct device_node *root)
 }
 
 static const struct of_device_id __initdata aic_irq_fixups[] = {
+	{ .compatible = "atmel,at91rm9200", .data = at91rm9200_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9g45", .data = at91sam9g45_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9n12", .data = at91rm9200_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9rl", .data = at91sam9g45_aic_irq_fixup },
-- 
1.9.1

