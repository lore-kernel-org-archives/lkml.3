Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaG1VXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:23:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59247 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbaG1VRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 23/35] arm: omap: irq: drop omap3_intc_handle_irq()
Date: Mon, 28 Jul 2014 16:16:11 -0500
Message-ID: <1406582183-696-24-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now that we're calling set_handle_irq() from
init_irq(), we can safely drop all callers to
omap3_intc_handle_irq() and its definition.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/board-3430sdp.c        | 1 -
 arch/arm/mach-omap2/board-am3517crane.c    | 1 -
 arch/arm/mach-omap2/board-am3517evm.c      | 1 -
 arch/arm/mach-omap2/board-cm-t35.c         | 2 --
 arch/arm/mach-omap2/board-cm-t3517.c       | 1 -
 arch/arm/mach-omap2/board-devkit8000.c     | 1 -
 arch/arm/mach-omap2/board-ldp.c            | 1 -
 arch/arm/mach-omap2/board-omap3beagle.c    | 1 -
 arch/arm/mach-omap2/board-omap3logic.c     | 2 --
 arch/arm/mach-omap2/board-omap3pandora.c   | 1 -
 arch/arm/mach-omap2/board-omap3stalker.c   | 1 -
 arch/arm/mach-omap2/board-omap3touchbook.c | 1 -
 arch/arm/mach-omap2/board-overo.c          | 1 -
 arch/arm/mach-omap2/board-rx51.c           | 1 -
 arch/arm/mach-omap2/common.h               | 1 -
 arch/arm/mach-omap2/irq.c                  | 5 -----
 16 files changed, 22 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index d95d0ef..d21a304 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -625,7 +625,6 @@ MACHINE_START(OMAP_3430SDP, "OMAP3430 3430SDP board")
 	.map_io		= omap3_map_io,
 	.init_early	= omap3430_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_3430sdp_init,
 	.init_late	= omap3430_init_late,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 0d499a1..212c316 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -142,7 +142,6 @@ MACHINE_START(CRANEBOARD, "AM3517/05 CRANEBOARD")
 	.map_io		= omap3_map_io,
 	.init_early	= am35xx_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= am3517_crane_init,
 	.init_late	= am35xx_init_late,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index 4f9383c..1c091b3 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -366,7 +366,6 @@ MACHINE_START(OMAP3517EVM, "OMAP3517/AM3517 EVM")
 	.map_io		= omap3_map_io,
 	.init_early	= am35xx_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= am3517_evm_init,
 	.init_late	= am35xx_init_late,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index 018353d..c6df8ee 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -766,7 +766,6 @@ MACHINE_START(CM_T35, "Compulab CM-T35")
 	.map_io		= omap3_map_io,
 	.init_early	= omap35xx_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= cm_t35_init,
 	.init_late	= omap35xx_init_late,
 	.init_time	= omap3_sync32k_timer_init,
@@ -779,7 +778,6 @@ MACHINE_START(CM_T3730, "Compulab CM-T3730")
 	.map_io		= omap3_map_io,
 	.init_early	= omap3630_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= cm_t3730_init,
 	.init_late     = omap3630_init_late,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-cm-t3517.c b/arch/arm/mach-omap2/board-cm-t3517.c
index 4eb5e6f..8a2c167 100644
--- a/arch/arm/mach-omap2/board-cm-t3517.c
+++ b/arch/arm/mach-omap2/board-cm-t3517.c
@@ -329,7 +329,6 @@ MACHINE_START(CM_T3517, "Compulab CM-T3517")
 	.map_io		= omap3_map_io,
 	.init_early	= am35xx_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= cm_t3517_init,
 	.init_late	= am35xx_init_late,
 	.init_time	= omap3_gptimer_timer_init,
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index cdc4fb9..d8e4f34 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -647,7 +647,6 @@ MACHINE_START(DEVKIT8000, "OMAP3 Devkit8000")
 	.map_io		= omap3_map_io,
 	.init_early	= omap35xx_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= devkit8000_init,
 	.init_late	= omap35xx_init_late,
 	.init_time	= omap3_secure_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index 44a59c3..c2975af 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -422,7 +422,6 @@ MACHINE_START(OMAP_LDP, "OMAP LDP board")
 	.map_io		= omap3_map_io,
 	.init_early	= omap3430_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_ldp_init,
 	.init_late	= omap3430_init_late,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index e2e5203..81de1c6 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -588,7 +588,6 @@ MACHINE_START(OMAP3_BEAGLE, "OMAP3 Beagle Board")
 	.map_io		= omap3_map_io,
 	.init_early	= omap3_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3_beagle_init,
 	.init_late	= omap3_init_late,
 	.init_time	= omap3_secure_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index bab51e6..6049f60 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -230,7 +230,6 @@ MACHINE_START(OMAP3_TORPEDO, "Logic OMAP3 Torpedo board")
 	.map_io		= omap3_map_io,
 	.init_early	= omap35xx_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3logic_init,
 	.init_late	= omap35xx_init_late,
 	.init_time	= omap3_sync32k_timer_init,
@@ -243,7 +242,6 @@ MACHINE_START(OMAP3530_LV_SOM, "OMAP Logic 3530 LV SOM board")
 	.map_io		= omap3_map_io,
 	.init_early	= omap35xx_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3logic_init,
 	.init_late	= omap35xx_init_late,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index cf18340..f322016 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -624,7 +624,6 @@ MACHINE_START(OMAP3_PANDORA, "Pandora Handheld Console")
 	.map_io		= omap3_map_io,
 	.init_early	= omap35xx_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3pandora_init,
 	.init_late	= omap35xx_init_late,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index a2e035e..6311f4b 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -426,7 +426,6 @@ MACHINE_START(SBC3530, "OMAP3 STALKER")
 	.map_io			= omap3_map_io,
 	.init_early		= omap35xx_init_early,
 	.init_irq		= omap3_init_irq,
-	.handle_irq		= omap3_intc_handle_irq,
 	.init_machine		= omap3_stalker_init,
 	.init_late		= omap35xx_init_late,
 	.init_time		= omap3_secure_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 7da48bc..d454508 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -388,7 +388,6 @@ MACHINE_START(TOUCHBOOK, "OMAP3 touchbook Board")
 	.map_io		= omap3_map_io,
 	.init_early	= omap3430_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3_touchbook_init,
 	.init_late	= omap3430_init_late,
 	.init_time	= omap3_secure_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index f6d3841..2dae6cc 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -564,7 +564,6 @@ MACHINE_START(OVERO, "Gumstix Overo")
 	.map_io		= omap3_map_io,
 	.init_early	= omap35xx_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= overo_init,
 	.init_late	= omap35xx_init_late,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index db168c9..2d1e5a6 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -134,7 +134,6 @@ MACHINE_START(NOKIA_RX51, "Nokia RX-51 board")
 	.map_io		= omap3_map_io,
 	.init_early	= omap3430_init_early,
 	.init_irq	= omap3_init_irq,
-	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= rx51_init,
 	.init_late	= omap3430_init_late,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index d3a205d..bc3208b 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -220,7 +220,6 @@ void omap3_intc_suspend(void);
 void omap3_intc_prepare_idle(void);
 void omap3_intc_resume_idle(void);
 void omap2_intc_handle_irq(struct pt_regs *regs);
-void omap3_intc_handle_irq(struct pt_regs *regs);
 void omap_gic_of_init(void);
 
 #ifdef CONFIG_CACHE_L2X0
diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 994009c..4dfeac6 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -326,8 +326,3 @@ static int __init intc_of_init(struct device_node *node,
 IRQCHIP_DECLARE(omap2_intc, "ti,omap2-intc", intc_of_init);
 IRQCHIP_DECLARE(omap3_intc, "ti,omap3-intc", intc_of_init);
 IRQCHIP_DECLARE(am33xx_intc, "ti,am33xx-intc", intc_of_init);
-
-asmlinkage void __exception_irq_entry omap3_intc_handle_irq(struct pt_regs *regs)
-{
-	omap_intc_handle_irq(regs);
-}
-- 
2.0.1.563.g66f467c

