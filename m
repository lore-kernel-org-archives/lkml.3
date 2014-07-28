Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaG1VZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:25:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55567 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbaG1VRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:41 -0400
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
Subject: [PATCH 27/35] arm: omap: irq: introduce omap_nr_pending
Date: Mon, 28 Jul 2014 16:16:15 -0500
Message-ID: <1406582183-696-28-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that variable will tell us how many INTC_PENDING_IRQn
registers we have. It'll be used on a following patch
to cleanup omap_intc_handle_irq() a bit.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 44d9cf4..583a1c7 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -70,6 +70,7 @@ static struct omap_intc_regs intc_context;
 
 static struct irq_domain *domain;
 static void __iomem *omap_irq_base;
+static int omap_nr_pending = 3;
 static int omap_nr_irqs = 96;
 
 /* INTC bank register get/set */
@@ -276,6 +277,7 @@ out:
 void __init omap2_init_irq(void)
 {
 	omap_nr_irqs = 96;
+	omap_nr_pending = 3;
 	omap_init_irq(OMAP24XX_IC_BASE, NULL);
 	set_handle_irq(omap_intc_handle_irq);
 }
@@ -283,6 +285,7 @@ void __init omap2_init_irq(void)
 void __init omap3_init_irq(void)
 {
 	omap_nr_irqs = 96;
+	omap_nr_pending = 3;
 	omap_init_irq(OMAP34XX_IC_BASE, NULL);
 	set_handle_irq(omap_intc_handle_irq);
 }
@@ -290,6 +293,7 @@ void __init omap3_init_irq(void)
 void __init ti81xx_init_irq(void)
 {
 	omap_nr_irqs = 96;
+	omap_nr_pending = 4;
 	omap_init_irq(OMAP34XX_IC_BASE, NULL);
 	set_handle_irq(omap_intc_handle_irq);
 }
@@ -299,6 +303,7 @@ static int __init intc_of_init(struct device_node *node,
 {
 	struct resource res;
 
+	omap_nr_pending = 3;
 	omap_nr_irqs = 96;
 
 	if (WARN_ON(!node))
@@ -309,8 +314,10 @@ static int __init intc_of_init(struct device_node *node,
 		return -EINVAL;
 	}
 
-	if (of_device_is_compatible(node, "ti,am33xx-intc"))
+	if (of_device_is_compatible(node, "ti,am33xx-intc")) {
 		omap_nr_irqs = 128;
+		omap_nr_pending = 4;
+	}
 
 	omap_init_irq(res.start, of_node_get(node));
 
-- 
2.0.1.563.g66f467c

