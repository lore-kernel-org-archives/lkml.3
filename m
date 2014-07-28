Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaG1V16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:27:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55555 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaG1VRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:33 -0400
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
Subject: [PATCH 01/35] arm: omap: irq: make omap_irq_base global
Date: Mon, 28 Jul 2014 16:15:49 -0500
Message-ID: <1406582183-696-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for removing the pointless
irq_banks array.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 35b8590..7b2cf9a 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -68,6 +68,7 @@ static struct omap_irq_bank {
 };
 
 static struct irq_domain *domain;
+static void __iomem *omap_irq_base;
 
 /* Structure to save interrupt controller context */
 struct omap3_intc_regs {
@@ -161,7 +162,6 @@ omap_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 static void __init omap_init_irq(u32 base, int nr_irqs,
 				 struct device_node *node)
 {
-	void __iomem *omap_irq_base;
 	unsigned long nr_of_irqs = 0;
 	unsigned int nr_banks = 0;
 	int i, j, irq_base;
-- 
2.0.1.563.g66f467c

