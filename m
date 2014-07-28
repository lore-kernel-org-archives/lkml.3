Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaG1V0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:26:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37267 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaG1VRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:38 -0400
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
Subject: [PATCH 14/35] arm: omap: irq: use IRQCHIP_DECLARE macro
Date: Mon, 28 Jul 2014 16:16:02 -0500
Message-ID: <1406582183-696-15-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQCHIP_DECLARE macro is used to declare the same
of_device_id structure for irqchips, it's just
a helper. No functional changes.

Note that we're temporarily including irqchip.h
with its full path, until we move this driver
to drivers/irqchip/.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index e452411..2801243 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -26,6 +26,7 @@
 #include "soc.h"
 #include "iomap.h"
 #include "common.h"
+#include "../../drivers/irqchip/irqchip.h"
 
 /* selected INTC register offsets */
 
@@ -319,14 +320,11 @@ static int __init intc_of_init(struct device_node *node,
 	return 0;
 }
 
-static struct of_device_id irq_match[] __initdata = {
-	{ .compatible = "ti,omap2-intc", .data = intc_of_init, },
-	{ }
-};
+IRQCHIP_DECLARE(omap_intc, "ti,omap2-intc", intc_of_init);
 
 void __init omap_intc_of_init(void)
 {
-	of_irq_init(irq_match);
+	of_irq_init(&irqchip_of_match_omap_intc);
 }
 
 asmlinkage void __exception_irq_entry omap3_intc_handle_irq(struct pt_regs *regs)
-- 
2.0.1.563.g66f467c

