Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaKCIbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:31:24 -0500
Received: from down.free-electrons.com ([37.187.137.238]:51395 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127AbaKCIbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:31:10 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 3/5] irqchip: atmel-aic: add specific irq fixup function for sam9g45 and sam9rl
Date: Mon,  3 Nov 2014 09:31:02 +0100
Message-Id: <1415003464-29239-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415003464-29239-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

The at91sam9g45 and at91sam9rl SoCs embed one RTT (Real Time Timer) and one
RTC block and thus need to call both rtt and rtc fixup functions.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/irqchip/irq-atmel-aic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic.c b/drivers/irqchip/irq-atmel-aic.c
index 637d600..d7b0495 100644
--- a/drivers/irqchip/irq-atmel-aic.c
+++ b/drivers/irqchip/irq-atmel-aic.c
@@ -219,10 +219,16 @@ static void __init at91sam9260_aic_irq_fixup(struct device_node *root)
 	aic_common_rtt_irq_fixup(root);
 }
 
+static void __init at91sam9g45_aic_irq_fixup(struct device_node *root)
+{
+	aic_common_rtc_irq_fixup(root);
+	aic_common_rtt_irq_fixup(root);
+}
+
 static const struct of_device_id __initdata aic_irq_fixups[] = {
-	{ .compatible = "atmel,at91sam9g45", .data = at91sam9_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9g45", .data = at91sam9g45_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9n12", .data = at91sam9_aic_irq_fixup },
-	{ .compatible = "atmel,at91sam9rl", .data = at91sam9_aic_irq_fixup },
+	{ .compatible = "atmel,at91sam9rl", .data = at91sam9g45_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9x5", .data = at91sam9_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9260", .data = at91sam9260_aic_irq_fixup },
 	{ .compatible = "atmel,at91sam9261", .data = at91sam9260_aic_irq_fixup },
-- 
1.9.1

