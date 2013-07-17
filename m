Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3GQPh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:37:28 -0400
Received: from 15.mo1.mail-out.ovh.net ([188.165.38.232]:59343 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754176Ab3GQPh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:37:26 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 24/42] ARM: at91: move at91sam9 boards to new at91 clk implem
Date: Wed, 17 Jul 2013 17:37:13 +0200
Message-Id: <1374075433-20170-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13407497567571900524
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move at91 clk init from early_init to timer_init for all at91sam9 non dt
boards.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/board-afeb-9260v1.c  |   11 +++++++----
 arch/arm/mach-at91/board-cam60.c        |   13 ++++++++-----
 arch/arm/mach-at91/board-cpu9krea.c     |   12 ++++++++----
 arch/arm/mach-at91/board-dt-sam9.c      |    9 ++++++++-
 arch/arm/mach-at91/board-dt-sama5.c     |    9 ++++++++-
 arch/arm/mach-at91/board-flexibity.c    |   12 ++++++++----
 arch/arm/mach-at91/board-foxg20.c       |   12 +++++++-----
 arch/arm/mach-at91/board-gsia18s.c      |    8 ++------
 arch/arm/mach-at91/board-pcontrol-g20.c |    9 ++-------
 arch/arm/mach-at91/board-qil-a9260.c    |   11 +++++++----
 arch/arm/mach-at91/board-sam9-l9260.c   |   11 +++++++----
 arch/arm/mach-at91/board-sam9260ek.c    |   11 +++++++----
 arch/arm/mach-at91/board-sam9261ek.c    |   15 +++++++++------
 arch/arm/mach-at91/board-sam9263ek.c    |   11 +++++++----
 arch/arm/mach-at91/board-sam9g20ek.c    |   15 +++++++++------
 arch/arm/mach-at91/board-sam9m10g45ek.c |   11 +++++++----
 arch/arm/mach-at91/board-sam9rlek.c     |   11 +++++++----
 arch/arm/mach-at91/board-snapper9260.c  |   12 ++++++++----
 arch/arm/mach-at91/board-stamp9g20.c    |   15 +++++++++------
 arch/arm/mach-at91/stamp9g20.h          |    2 +-
 20 files changed, 136 insertions(+), 84 deletions(-)

diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
index f95e31c..c6849e1 100644
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@ -48,10 +48,13 @@
 #include "generic.h"
 
 
-static void __init afeb9260_init_early(void)
+static void __init afeb9260_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -210,10 +213,10 @@ static void __init afeb9260_board_init(void)
 
 MACHINE_START(AFEB9260, "Custom afeb9260 board")
 	/* Maintainer: Sergey Lapin <slapin@ossfans.org> */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= afeb9260_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= afeb9260_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= afeb9260_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index ade948b..75c89a0 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -46,10 +46,13 @@
 #include "generic.h"
 
 
-static void __init cam60_init_early(void)
+static void __init cam60_timer_init(void)
 {
-	/* Initialize processor: 10 MHz crystal */
-	at91_initialize(10000000);
+	/* Initialize processor: 18.432 MHz crystal */
+	at91_clk_init(10000000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -187,10 +190,10 @@ static void __init cam60_board_init(void)
 
 MACHINE_START(CAM60, "KwikByte CAM60")
 	/* Maintainer: KwikByte */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= cam60_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= cam60_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= cam60_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index 008527e..a88d8ec 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -49,10 +49,14 @@
 #include "sam9_smc.h"
 #include "generic.h"
 
-static void __init cpu9krea_init_early(void)
+
+static void __init cpu9krea_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -374,10 +378,10 @@ MACHINE_START(CPUAT9260, "Eukrea CPU9260")
 MACHINE_START(CPUAT9G20, "Eukrea CPU9G20")
 #endif
 	/* Maintainer: Eric Benard - EUKREA Electromatique */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= cpu9krea_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= cpu9krea_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= cpu9krea_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 8db3013..a7ea21f 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/clk-provider.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -26,6 +27,12 @@
 #include "generic.h"
 
 
+static void __init at91sam_dt_timer_init(void)
+{
+	of_clk_init(NULL);
+	at91sam926x_pit_init();
+}
+
 static const struct of_device_id irq_of_match[] __initconst = {
 
 	{ .compatible = "atmel,at91rm9200-aic", .data = at91_aic_of_init },
@@ -49,7 +56,7 @@ static const char *at91_dt_board_compat[] __initdata = {
 
 DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91sam_dt_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91_dt_initialize,
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index ad95f6a..7ad3d96 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -16,6 +16,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/phy.h>
+#include <linux/clk-provider.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -27,6 +28,12 @@
 #include "generic.h"
 
 
+static void __init at91sama5_dt_timer_init(void)
+{
+	of_clk_init(NULL);
+	at91sam926x_pit_init();
+}
+
 static const struct of_device_id irq_of_match[] __initconst = {
 
 	{ .compatible = "atmel,sama5d3-aic", .data = at91_aic5_of_init },
@@ -77,7 +84,7 @@ static const char *sama5_dt_board_compat[] __initdata = {
 
 DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= at91sama5_dt_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic5_handle_irq,
 	.init_early	= at91_dt_initialize,
diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index 737c085..f64b47a 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -38,10 +38,14 @@
 #include "board.h"
 #include "generic.h"
 
-static void __init flexibity_init_early(void)
+
+static void __init flexibity_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /* USB Host port */
@@ -159,10 +163,10 @@ static void __init flexibity_board_init(void)
 
 MACHINE_START(FLEXIBITY, "Flexibity Connect")
 	/* Maintainer: Maxim Osipov */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= flexibity_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= flexibity_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= flexibity_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
index c20a870..c4caeb3 100644
--- a/arch/arm/mach-at91/board-foxg20.c
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -57,11 +57,13 @@
  * For more info visit: http://www.acmesystems.it/foxg20
  */
 
-
-static void __init foxg20_init_early(void)
+static void __init foxg20_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -262,10 +264,10 @@ static void __init foxg20_board_init(void)
 
 MACHINE_START(ACMENETUSFOXG20, "Acme Systems srl FOX Board G20")
 	/* Maintainer: Sergio Tanzilli */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= foxg20_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= foxg20_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= foxg20_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
index c1d61d2..4ed7ef4 100644
--- a/arch/arm/mach-at91/board-gsia18s.c
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -39,10 +39,6 @@
 #include "gsia18s.h"
 #include "stamp9g20.h"
 
-static void __init gsia18s_init_early(void)
-{
-	stamp9g20_init_early();
-}
 
 /*
  * Two USB Host ports
@@ -574,10 +570,10 @@ static void __init gsia18s_board_init(void)
 }
 
 MACHINE_START(GSIA18S, "GS_IA18_S")
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= stamp9g20_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= gsia18s_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= gsia18s_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
index 65c0d6b..6602e14 100644
--- a/arch/arm/mach-at91/board-pcontrol-g20.c
+++ b/arch/arm/mach-at91/board-pcontrol-g20.c
@@ -38,11 +38,6 @@
 #include "stamp9g20.h"
 
 
-static void __init pcontrol_g20_init_early(void)
-{
-	stamp9g20_init_early();
-}
-
 static struct sam9_smc_config __initdata pcontrol_smc_config[2] = { {
 	.ncs_read_setup		= 16,
 	.nrd_setup		= 18,
@@ -217,10 +212,10 @@ static void __init pcontrol_g20_board_init(void)
 
 MACHINE_START(PCONTROL_G20, "PControl G20")
 	/* Maintainer: pgsellmann@portner-elektronik.at */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= stamp9g20_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= pcontrol_g20_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= pcontrol_g20_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-qil-a9260.c b/arch/arm/mach-at91/board-qil-a9260.c
index aa3bc9b..b7a9976 100644
--- a/arch/arm/mach-at91/board-qil-a9260.c
+++ b/arch/arm/mach-at91/board-qil-a9260.c
@@ -49,10 +49,13 @@
 #include "generic.h"
 
 
-static void __init ek_init_early(void)
+static void __init ek_timer_init(void)
 {
 	/* Initialize processor: 12.000 MHz crystal */
-	at91_initialize(12000000);
+	at91_clk_init(12000000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -257,10 +260,10 @@ static void __init ek_board_init(void)
 
 MACHINE_START(QIL_A9260, "CALAO QIL_A9260")
 	/* Maintainer: calao-systems */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index 43ee4dc..f078f94 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -45,10 +45,13 @@
 #include "generic.h"
 
 
-static void __init ek_init_early(void)
+static void __init ek_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -218,10 +221,10 @@ static void __init ek_board_init(void)
 
 MACHINE_START(SAM9_L9260, "Olimex SAM9-L9260")
 	/* Maintainer: Olimex */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 0b153c8..2737a5c 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -51,10 +51,13 @@
 #include "generic.h"
 
 
-static void __init ek_init_early(void)
+static void __init ek_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -343,10 +346,10 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9260EK, "Atmel AT91SAM9260-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 473546b..212210e 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -55,10 +55,13 @@
 #include "generic.h"
 
 
-static void __init ek_init_early(void)
+static void __init ek_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -602,20 +605,20 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9261EK, "Atmel AT91SAM9261-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
 
 MACHINE_START(AT91SAM9G10EK, "Atmel AT91SAM9G10-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 8b4942c..c427d62 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -54,10 +54,13 @@
 #include "generic.h"
 
 
-static void __init ek_init_early(void)
+static void __init ek_timer_init(void)
 {
 	/* Initialize processor: 16.367 MHz crystal */
-	at91_initialize(16367660);
+	at91_clk_init(16367660);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -443,10 +446,10 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9263EK, "Atmel AT91SAM9263-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
index f9cd1f2..10abb59 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -64,10 +64,13 @@ static int inline ek_have_2mmc(void)
 }
 
 
-static void __init ek_init_early(void)
+static void __init ek_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -409,20 +412,20 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9G20EK, "Atmel AT91SAM9G20-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
 
 MACHINE_START(AT91SAM9G20EK_2MMC, "Atmel AT91SAM9G20-EK 2 MMC Slot Mod")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index ef39078..4125b82 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -52,10 +52,13 @@
 #include "generic.h"
 
 
-static void __init ek_init_early(void)
+static void __init ek_timer_init(void)
 {
 	/* Initialize processor: 12.000 MHz crystal */
-	at91_initialize(12000000);
+	at91_clk_init(12000000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -502,10 +505,10 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9M10G45EK, "Atmel AT91SAM9M10G45-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index 604eecf..1490d91 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -40,10 +40,13 @@
 #include "generic.h"
 
 
-static void __init ek_init_early(void)
+static void __init ek_timer_init(void)
 {
 	/* Initialize processor: 12.000 MHz crystal */
-	at91_initialize(12000000);
+	at91_clk_init(12000000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -320,10 +323,10 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91SAM9RLEK, "Atmel AT91SAM9RL-EK")
 	/* Maintainer: Atmel */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index 3aaa978..afe48fd 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -41,9 +41,13 @@
 
 #define SNAPPER9260_IO_EXP_GPIO(x)	(NR_BUILTIN_GPIO + (x))
 
-static void __init snapper9260_init_early(void)
+static void __init snapper9260_timer_init(void)
 {
-	at91_initialize(18432000);
+	/* Initialize processor: 18.432 MHz crystal */
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 static struct at91_usbh_data __initdata snapper9260_usbh_data = {
@@ -177,10 +181,10 @@ static void __init snapper9260_board_init(void)
 }
 
 MACHINE_START(SNAPPER_9260, "Bluewater Systems Snapper 9260/9G20 module")
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= snapper9260_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= snapper9260_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= snapper9260_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
index 869cbec..e4cee53 100644
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -33,10 +33,13 @@
 #include "generic.h"
 
 
-void __init stamp9g20_init_early(void)
+void __init stamp9g20_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init sam9 PIT timer */
+	at91sam926x_pit_init();
 }
 
 /*
@@ -273,20 +276,20 @@ static void __init stamp9g20evb_board_init(void)
 
 MACHINE_START(PORTUXG20, "taskit PortuxG20")
 	/* Maintainer: taskit GmbH */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= stamp9g20_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= stamp9g20_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= portuxg20_board_init,
 MACHINE_END
 
 MACHINE_START(STAMP9G20, "taskit Stamp9G20")
 	/* Maintainer: taskit GmbH */
-	.init_time	= at91sam926x_pit_init,
+	.init_time	= stamp9g20_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= stamp9g20_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= stamp9g20evb_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/stamp9g20.h b/arch/arm/mach-at91/stamp9g20.h
index f62c0ab..26a37b5 100644
--- a/arch/arm/mach-at91/stamp9g20.h
+++ b/arch/arm/mach-at91/stamp9g20.h
@@ -1,7 +1,7 @@
 #ifndef __MACH_STAMP9G20_H
 #define __MACH_STAMP9G20_H
 
-void stamp9g20_init_early(void);
+void stamp9g20_timer_init(void);
 void stamp9g20_board_init(void);
 
 #endif
-- 
1.7.9.5

