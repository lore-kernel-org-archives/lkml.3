Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaG1VYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:24:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59241 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaG1VRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:43 -0400
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
Subject: [PATCH 15/35] arm: omap: irq: drop .handle_irq and .init_irq fields
Date: Mon, 28 Jul 2014 16:16:03 -0500
Message-ID: <1406582183-696-16-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now we can safely drop those fields from our machine_desc.

While at that, also drop the now unused omap_intc_of_init()
definition.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/board-generic.c | 14 --------------
 arch/arm/mach-omap2/common.h        |  1 -
 arch/arm/mach-omap2/irq.c           |  5 -----
 3 files changed, 20 deletions(-)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 9480997..2e32939 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -52,8 +52,6 @@ DT_MACHINE_START(OMAP242X_DT, "Generic OMAP2420 (Flattened Device Tree)")
 	.reserve	= omap_reserve,
 	.map_io		= omap242x_map_io,
 	.init_early	= omap2420_init_early,
-	.init_irq	= omap_intc_of_init,
-	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= omap_generic_init,
 	.init_time	= omap2_sync32k_timer_init,
 	.dt_compat	= omap242x_boards_compat,
@@ -71,8 +69,6 @@ DT_MACHINE_START(OMAP243X_DT, "Generic OMAP2430 (Flattened Device Tree)")
 	.reserve	= omap_reserve,
 	.map_io		= omap243x_map_io,
 	.init_early	= omap2430_init_early,
-	.init_irq	= omap_intc_of_init,
-	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= omap_generic_init,
 	.init_time	= omap2_sync32k_timer_init,
 	.dt_compat	= omap243x_boards_compat,
@@ -91,8 +87,6 @@ DT_MACHINE_START(OMAP3_DT, "Generic OMAP3 (Flattened Device Tree)")
 	.reserve	= omap_reserve,
 	.map_io		= omap3_map_io,
 	.init_early	= omap3430_init_early,
-	.init_irq	= omap_intc_of_init,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
 	.init_late	= omap3_init_late,
 	.init_time	= omap3_sync32k_timer_init,
@@ -109,8 +103,6 @@ DT_MACHINE_START(OMAP36XX_DT, "Generic OMAP36xx (Flattened Device Tree)")
 	.reserve	= omap_reserve,
 	.map_io		= omap3_map_io,
 	.init_early	= omap3630_init_early,
-	.init_irq	= omap_intc_of_init,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
 	.init_late	= omap3_init_late,
 	.init_time	= omap3_sync32k_timer_init,
@@ -128,8 +120,6 @@ DT_MACHINE_START(OMAP3_GP_DT, "Generic OMAP3-GP (Flattened Device Tree)")
 	.reserve	= omap_reserve,
 	.map_io		= omap3_map_io,
 	.init_early	= omap3430_init_early,
-	.init_irq	= omap_intc_of_init,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
 	.init_late	= omap3_init_late,
 	.init_time	= omap3_secure_sync32k_timer_init,
@@ -146,8 +136,6 @@ DT_MACHINE_START(AM3517_DT, "Generic AM3517 (Flattened Device Tree)")
 	.reserve	= omap_reserve,
 	.map_io		= omap3_map_io,
 	.init_early	= am35xx_init_early,
-	.init_irq	= omap_intc_of_init,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
 	.init_late	= omap3_init_late,
 	.init_time	= omap3_gptimer_timer_init,
@@ -166,8 +154,6 @@ DT_MACHINE_START(AM33XX_DT, "Generic AM33XX (Flattened Device Tree)")
 	.reserve	= omap_reserve,
 	.map_io		= am33xx_map_io,
 	.init_early	= am33xx_init_early,
-	.init_irq	= omap_intc_of_init,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
 	.init_late	= am33xx_init_late,
 	.init_time	= omap3_gptimer_timer_init,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index bbb0623..d3a205d 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -221,7 +221,6 @@ void omap3_intc_prepare_idle(void);
 void omap3_intc_resume_idle(void);
 void omap2_intc_handle_irq(struct pt_regs *regs);
 void omap3_intc_handle_irq(struct pt_regs *regs);
-void omap_intc_of_init(void);
 void omap_gic_of_init(void);
 
 #ifdef CONFIG_CACHE_L2X0
diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 2801243..465d725 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -322,11 +322,6 @@ static int __init intc_of_init(struct device_node *node,
 
 IRQCHIP_DECLARE(omap_intc, "ti,omap2-intc", intc_of_init);
 
-void __init omap_intc_of_init(void)
-{
-	of_irq_init(&irqchip_of_match_omap_intc);
-}
-
 asmlinkage void __exception_irq_entry omap3_intc_handle_irq(struct pt_regs *regs)
 {
 	omap_intc_handle_irq(regs);
-- 
2.0.1.563.g66f467c

