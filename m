Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbaGAJjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:39:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33573 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757775AbaGAJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 12/14] AT91: Convert the boards to the init_time callback
Date: Tue,  1 Jul 2014 11:33:25 +0200
Message-Id: <1404207208-14513-13-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the init_time callback in the at91_init_soc structure, convert
all the boards and SoC to this.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9260.c        | 6 ++++++
 arch/arm/mach-at91/at91sam9261.c        | 6 ++++++
 arch/arm/mach-at91/at91sam9263.c        | 6 ++++++
 arch/arm/mach-at91/at91sam9g45.c        | 6 ++++++
 arch/arm/mach-at91/at91sam9rl.c         | 6 ++++++
 arch/arm/mach-at91/board-afeb-9260v1.c  | 2 +-
 arch/arm/mach-at91/board-cam60.c        | 2 +-
 arch/arm/mach-at91/board-cpu9krea.c     | 2 +-
 arch/arm/mach-at91/board-flexibity.c    | 2 +-
 arch/arm/mach-at91/board-foxg20.c       | 2 +-
 arch/arm/mach-at91/board-gsia18s.c      | 2 +-
 arch/arm/mach-at91/board-pcontrol-g20.c | 2 +-
 arch/arm/mach-at91/board-sam9-l9260.c   | 2 +-
 arch/arm/mach-at91/board-sam9260ek.c    | 2 +-
 arch/arm/mach-at91/board-sam9261ek.c    | 4 ++--
 arch/arm/mach-at91/board-sam9263ek.c    | 2 +-
 arch/arm/mach-at91/board-sam9g20ek.c    | 4 ++--
 arch/arm/mach-at91/board-sam9m10g45ek.c | 2 +-
 arch/arm/mach-at91/board-sam9rlek.c     | 2 +-
 arch/arm/mach-at91/board-snapper9260.c  | 2 +-
 arch/arm/mach-at91/board-stamp9g20.c    | 4 ++--
 21 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index c3d22be73b7c..d5141af1947c 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -400,6 +400,11 @@ static unsigned int at91sam9260_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller */
 };
 
+static void __init at91sam9260_init_time(void)
+{
+	at91sam926x_pit_init();
+}
+
 AT91_SOC_START(at91sam9260)
 	.map_io = at91sam9260_map_io,
 	.default_irq_priority = at91sam9260_default_irq_priority,
@@ -408,4 +413,5 @@ AT91_SOC_START(at91sam9260)
 	.ioremap_registers = at91sam9260_ioremap_registers,
 	.register_clocks = at91sam9260_register_clocks,
 	.init = at91sam9260_initialize,
+	.init_time = at91sam9260_init_time,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index fb164a5d04a9..5416fe4d5a0b 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -363,6 +363,11 @@ static unsigned int at91sam9261_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller */
 };
 
+static void __init at91sam9261_init_time(void)
+{
+	at91sam926x_pit_init();
+}
+
 AT91_SOC_START(at91sam9261)
 	.map_io = at91sam9261_map_io,
 	.default_irq_priority = at91sam9261_default_irq_priority,
@@ -371,4 +376,5 @@ AT91_SOC_START(at91sam9261)
 	.ioremap_registers = at91sam9261_ioremap_registers,
 	.register_clocks = at91sam9261_register_clocks,
 	.init = at91sam9261_initialize,
+	.init_time = at91sam9261_init_time,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index f30290572293..20b46118338c 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -381,6 +381,11 @@ static unsigned int at91sam9263_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller (IRQ1) */
 };
 
+static void __init at91sam9263_init_time(void)
+{
+	at91sam926x_pit_init();
+}
+
 AT91_SOC_START(at91sam9263)
 	.map_io = at91sam9263_map_io,
 	.default_irq_priority = at91sam9263_default_irq_priority,
@@ -388,4 +393,5 @@ AT91_SOC_START(at91sam9263)
 	.ioremap_registers = at91sam9263_ioremap_registers,
 	.register_clocks = at91sam9263_register_clocks,
 	.init = at91sam9263_initialize,
+	.init_time = at91sam9263_init_time,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 9d3d544ac19c..924d362121ef 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -430,6 +430,11 @@ static unsigned int at91sam9g45_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller (IRQ0) */
 };
 
+static void __init at91sam9g45_init_time(void)
+{
+	at91sam926x_pit_init();
+}
+
 AT91_SOC_START(at91sam9g45)
 	.map_io = at91sam9g45_map_io,
 	.default_irq_priority = at91sam9g45_default_irq_priority,
@@ -437,4 +442,5 @@ AT91_SOC_START(at91sam9g45)
 	.ioremap_registers = at91sam9g45_ioremap_registers,
 	.register_clocks = at91sam9g45_register_clocks,
 	.init = at91sam9g45_initialize,
+	.init_time = at91sam9g45_init_time,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index a79960f57e6a..dd4a8deb5b36 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -373,6 +373,11 @@ static unsigned int at91sam9rl_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	0,	/* Advanced Interrupt Controller */
 };
 
+static void __init at91sam9rl_init_time(void)
+{
+	at91sam926x_pit_init();
+}
+
 AT91_SOC_START(at91sam9rl)
 	.map_io = at91sam9rl_map_io,
 	.default_irq_priority = at91sam9rl_default_irq_priority,
@@ -382,4 +387,5 @@ AT91_SOC_START(at91sam9rl)
 	.register_clocks = at91sam9rl_register_clocks,
 #endif
 	.init = at91sam9rl_initialize,
+	.init_time = at91sam9rl_init_time,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
index 597c649170aa..afadbcb8f45d 100644
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@ -211,7 +211,7 @@ static void __init afeb9260_board_init(void)
 
 MACHINE_START(AFEB9260, "Custom afeb9260 board")
 	/* Maintainer: Sergey Lapin <slapin@ossfans.org> */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= afeb9260_init_early,
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index a30502c8d379..731dcb368c3d 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -188,7 +188,7 @@ static void __init cam60_board_init(void)
 
 MACHINE_START(CAM60, "KwikByte CAM60")
 	/* Maintainer: KwikByte */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= cam60_init_early,
diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index 2037f78c84e7..1e4d221c4a74 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -375,7 +375,7 @@ MACHINE_START(CPUAT9260, "Eukrea CPU9260")
 MACHINE_START(CPUAT9G20, "Eukrea CPU9G20")
 #endif
 	/* Maintainer: Eric Benard - EUKREA Electromatique */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= cpu9krea_init_early,
diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index 68f1ab6bd08f..6f1ca9a02697 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -160,7 +160,7 @@ static void __init flexibity_board_init(void)
 
 MACHINE_START(FLEXIBITY, "Flexibity Connect")
 	/* Maintainer: Maxim Osipov */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= flexibity_init_early,
diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
index 8b22c60bb238..ec290b6ed9d8 100644
--- a/arch/arm/mach-at91/board-foxg20.c
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -263,7 +263,7 @@ static void __init foxg20_board_init(void)
 
 MACHINE_START(ACMENETUSFOXG20, "Acme Systems srl FOX Board G20")
 	/* Maintainer: Sergio Tanzilli */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= foxg20_init_early,
diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
index b729dd1271bf..bf5cc55c7db6 100644
--- a/arch/arm/mach-at91/board-gsia18s.c
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -576,7 +576,7 @@ static void __init gsia18s_board_init(void)
 }
 
 MACHINE_START(GSIA18S, "GS_IA18_S")
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= gsia18s_init_early,
diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
index b48d95ec5152..9c26b94ce448 100644
--- a/arch/arm/mach-at91/board-pcontrol-g20.c
+++ b/arch/arm/mach-at91/board-pcontrol-g20.c
@@ -219,7 +219,7 @@ static void __init pcontrol_g20_board_init(void)
 
 MACHINE_START(PCONTROL_G20, "PControl G20")
 	/* Maintainer: pgsellmann@portner-elektronik.at */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= pcontrol_g20_init_early,
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index d24dda67e2d3..2d6259c947e1 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -219,7 +219,7 @@ static void __init ek_board_init(void)
 
 MACHINE_START(SAM9_L9260, "Olimex SAM9-L9260")
 	/* Maintainer: Olimex */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 65dea12d685e..3c7e278999af 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -344,7 +344,7 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9260EK, "Atmel AT91SAM9260-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 4637432de08f..52c2863124c7 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -603,7 +603,7 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9261EK, "Atmel AT91SAM9261-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
@@ -613,7 +613,7 @@ MACHINE_END
 
 MACHINE_START(AT91SAM9G10EK, "Atmel AT91SAM9G10-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index cd2726ee5add..4e2b6a60ce3e 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -444,7 +444,7 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9263EK, "Atmel AT91SAM9263-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
index e1be6e25b380..49f075213451 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -410,7 +410,7 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9G20EK, "Atmel AT91SAM9G20-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
@@ -420,7 +420,7 @@ MACHINE_END
 
 MACHINE_START(AT91SAM9G20EK_2MMC, "Atmel AT91SAM9G20-EK 2 MMC Slot Mod")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 1ea61328f30d..d5ae482849b7 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -493,7 +493,7 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9M10G45EK, "Atmel AT91SAM9M10G45-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index b64648b4a1fc..61e9c02ac798 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -323,7 +323,7 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9RLEK, "Atmel AT91SAM9RL-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index 1b870e6def0c..8123cae14987 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -178,7 +178,7 @@ static void __init snapper9260_board_init(void)
 }
 
 MACHINE_START(SNAPPER_9260, "Bluewater Systems Snapper 9260/9G20 module")
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= snapper9260_init_early,
diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
index 3b575036ff96..e825641a1dee 100644
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -275,7 +275,7 @@ static void __init stamp9g20evb_board_init(void)
 
 MACHINE_START(PORTUXG20, "taskit PortuxG20")
 	/* Maintainer: taskit GmbH */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= stamp9g20_init_early,
@@ -285,7 +285,7 @@ MACHINE_END
 
 MACHINE_START(STAMP9G20, "taskit Stamp9G20")
 	/* Maintainer: taskit GmbH */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91_init_time,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= stamp9g20_init_early,
-- 
2.0.0

