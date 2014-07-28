Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaG1V0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:26:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55565 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaG1VRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:40 -0400
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
Subject: [PATCH 08/35] arm: omap: irq: remove unnecessary base_addr argument
Date: Mon, 28 Jul 2014 16:15:56 -0500
Message-ID: <1406582183-696-9-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_intc_handle_irq now had an unnecessary
base_addr argument. Let's remove it and fix
all callers.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 88bba9e..38007b3 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -46,8 +46,6 @@
 #define INTC_PENDING_IRQ3	0x00f8
 #define INTC_ILR0		0x0100
 
-#define OMAP2_IRQ_BASE		OMAP2_L4_IO_ADDRESS(OMAP24XX_IC_BASE)
-#define OMAP3_IRQ_BASE		OMAP2_L4_IO_ADDRESS(OMAP34XX_IC_BASE)
 #define ACTIVEIRQ_MASK		0x7f	/* omap2/3 active interrupt bits */
 #define INTCPS_NR_ILR_REGS	128
 #define INTCPS_NR_MIR_REGS	3
@@ -188,7 +186,7 @@ void __init ti81xx_init_irq(void)
 	omap_init_irq(OMAP34XX_IC_BASE, 128, NULL);
 }
 
-static inline void omap_intc_handle_irq(void __iomem *base_addr, struct pt_regs *regs)
+static inline void omap_intc_handle_irq(struct pt_regs *regs)
 {
 	u32 irqnr;
 	int handled_irq = 0;
@@ -232,8 +230,7 @@ out:
 
 asmlinkage void __exception_irq_entry omap2_intc_handle_irq(struct pt_regs *regs)
 {
-	void __iomem *base_addr = OMAP2_IRQ_BASE;
-	omap_intc_handle_irq(base_addr, regs);
+	omap_intc_handle_irq(regs);
 }
 
 int __init intc_of_init(struct device_node *node,
@@ -334,7 +331,6 @@ void omap3_intc_resume_idle(void)
 
 asmlinkage void __exception_irq_entry omap3_intc_handle_irq(struct pt_regs *regs)
 {
-	void __iomem *base_addr = OMAP3_IRQ_BASE;
-	omap_intc_handle_irq(base_addr, regs);
+	omap_intc_handle_irq(regs);
 }
 #endif /* CONFIG_ARCH_OMAP3 */
-- 
2.0.1.563.g66f467c

