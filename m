Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaG1VXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:23:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55576 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbaG1VRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:46 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 34/35] irq: intc: remove unnecesary of_address_to_resource() call
Date: Mon, 28 Jul 2014 16:16:22 -0500
Message-ID: <1406582183-696-35-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_iomap(), which is called from omap_init_irq_of(),
already takes care of making sure we have a valid
resource to deal with. Because of that, we can
safely remove our explicit call to of_address_to_resource().

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/irqchip/irq-omap-intc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-intc.c
index 342e0ab..371ff5e 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -363,7 +363,6 @@ void __init ti81xx_init_irq(void)
 static int __init intc_of_init(struct device_node *node,
 			     struct device_node *parent)
 {
-	struct resource res;
 	int ret;
 
 	omap_nr_pending = 3;
@@ -372,11 +371,6 @@ static int __init intc_of_init(struct device_node *node,
 	if (WARN_ON(!node))
 		return -ENODEV;
 
-	if (of_address_to_resource(node, 0, &res)) {
-		WARN(1, "unable to get intc registers\n");
-		return -EINVAL;
-	}
-
 	if (of_device_is_compatible(node, "ti,am33xx-intc")) {
 		omap_nr_irqs = 128;
 		omap_nr_pending = 4;
-- 
2.0.1.563.g66f467c

