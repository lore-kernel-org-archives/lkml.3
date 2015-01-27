Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbbA0SJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:09:25 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10775 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbbA0SJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:09:22 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 7/7] ARM: at91/trivial: unify functions and machine names
Date: Tue, 27 Jan 2015 19:07:26 +0100
Message-ID: <fa9df37f603459bf08a4f8fc99337874c677e2bf.1422381280.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1422381280.git.nicolas.ferre@atmel.com>
References: <cover.1422381280.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the string "(Device Tree)" after the machine name because all AT91
machines use the DT nowadays.
Also change some function names to unify following the convention:
- at91sam9xxx aren't named sam9, 9xxx but with the full name
- sama5 are the ones that don't have the at91 prefix anymore.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91rm9200.c |  8 ++++----
 arch/arm/mach-at91/at91sam9.c   | 28 ++++++++++++++--------------
 arch/arm/mach-at91/generic.h    | 16 ++++++++--------
 arch/arm/mach-at91/pm.c         |  8 ++++----
 arch/arm/mach-at91/sama5.c      |  6 +++---
 5 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index 49ae3d455bd5..8fcfb70f7124 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -43,13 +43,13 @@ static void __init at91rm9200_dt_timer_init(void)
 	at91rm9200_timer_init();
 }
 
-static void __init rm9200_dt_device_init(void)
+static void __init at91rm9200_dt_device_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
 	arm_pm_idle = at91rm9200_idle;
 	arm_pm_restart = at91rm9200_restart;
-	at91_rm9200_pm_init();
+	at91rm9200_pm_init();
 }
 
 
@@ -59,9 +59,9 @@ static const char *at91rm9200_dt_board_compat[] __initconst = {
 	NULL
 };
 
-DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
+DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200")
 	.init_time      = at91rm9200_dt_timer_init,
 	.map_io		= at91_map_io,
-	.init_machine	= rm9200_dt_device_init,
+	.init_machine	= at91rm9200_dt_device_init,
 	.dt_compat	= at91rm9200_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-at91/at91sam9.c b/arch/arm/mach-at91/at91sam9.c
index ecbe535c2ce0..56e3ba73ec40 100644
--- a/arch/arm/mach-at91/at91sam9.c
+++ b/arch/arm/mach-at91/at91sam9.c
@@ -25,12 +25,12 @@
 
 #include "generic.h"
 
-static void __init sam9_dt_device_init(void)
+static void __init at91sam9_dt_device_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
 	arm_pm_idle = at91sam9_idle;
-	at91_sam9260_pm_init();
+	at91sam9260_pm_init();
 }
 
 static const char *at91_dt_board_compat[] __initconst = {
@@ -38,22 +38,22 @@ static const char *at91_dt_board_compat[] __initconst = {
 	NULL
 };
 
-DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
+DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM9")
 	/* Maintainer: Atmel */
 	.map_io		= at91_map_io,
-	.init_machine	= sam9_dt_device_init,
+	.init_machine	= at91sam9_dt_device_init,
 	.dt_compat	= at91_dt_board_compat,
 MACHINE_END
 
-static void __init sam9g45_dt_device_init(void)
+static void __init at91sam9g45_dt_device_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
 	arm_pm_idle = at91sam9_idle;
-	at91_sam9g45_pm_init();
+	at91sam9g45_pm_init();
 }
 
-static const char *at91_9g45_board_compat[] __initconst = {
+static const char *at91sam9g45_board_compat[] __initconst = {
 	"atmel,at91sam9g45",
 	NULL
 };
@@ -61,19 +61,19 @@ static const char *at91_9g45_board_compat[] __initconst = {
 DT_MACHINE_START(at91sam9g45_dt, "Atmel AT91SAM9G45")
 	/* Maintainer: Atmel */
 	.map_io		= at91_map_io,
-	.init_machine	= sam9g45_dt_device_init,
-	.dt_compat	= at91_9g45_board_compat,
+	.init_machine	= at91sam9g45_dt_device_init,
+	.dt_compat	= at91sam9g45_board_compat,
 MACHINE_END
 
-static void __init sam9x5_dt_device_init(void)
+static void __init at91sam9x5_dt_device_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
 	arm_pm_idle = at91sam9_idle;
-	at91_sam9x5_pm_init();
+	at91sam9x5_pm_init();
 }
 
-static const char *at91_9x5_board_compat[] __initconst = {
+static const char *at91sam9x5_board_compat[] __initconst = {
 	"atmel,at91sam9x5",
 	"atmel,at91sam9n12",
 	NULL
@@ -82,6 +82,6 @@ static const char *at91_9x5_board_compat[] __initconst = {
 DT_MACHINE_START(at91sam9x5_dt, "Atmel AT91SAM9")
 	/* Maintainer: Atmel */
 	.map_io		= at91_map_io,
-	.init_machine	= sam9x5_dt_device_init,
-	.dt_compat	= at91_9x5_board_compat,
+	.init_machine	= at91sam9x5_dt_device_init,
+	.dt_compat	= at91sam9x5_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 9c6e5b9f87ff..a6e726a6e0b5 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -30,15 +30,15 @@ extern void at91_ioremap_matrix(u32 base_addr);
 
 
 #ifdef CONFIG_PM
-extern void __init at91_rm9200_pm_init(void);
-extern void __init at91_sam9260_pm_init(void);
-extern void __init at91_sam9g45_pm_init(void);
-extern void __init at91_sam9x5_pm_init(void);
+extern void __init at91rm9200_pm_init(void);
+extern void __init at91sam9260_pm_init(void);
+extern void __init at91sam9g45_pm_init(void);
+extern void __init at91sam9x5_pm_init(void);
 #else
-void __init at91_rm9200_pm_init(void) { }
-void __init at91_sam9260_pm_init(void) { }
-void __init at91_sam9g45_pm_init(void) { }
-void __init at91_sam9x5_pm_init(void) { }
+void __init at91rm9200_pm_init(void) { }
+void __init at91sam9260_pm_init(void) { }
+void __init at91sam9g45_pm_init(void) { }
+void __init at91sam9x5_pm_init(void) { }
 #endif
 
 #endif /* _AT91_GENERIC_H */
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 25bb93db8208..af8d8afc2e12 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -319,7 +319,7 @@ static void __init at91_pm_init(void)
 	suspend_set_ops(&at91_pm_ops);
 }
 
-void __init at91_rm9200_pm_init(void)
+void __init at91rm9200_pm_init(void)
 {
 	at91_dt_ramc();
 
@@ -334,7 +334,7 @@ void __init at91_rm9200_pm_init(void)
 	at91_pm_init();
 }
 
-void __init at91_sam9260_pm_init(void)
+void __init at91sam9260_pm_init(void)
 {
 	at91_dt_ramc();
 	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
@@ -342,7 +342,7 @@ void __init at91_sam9260_pm_init(void)
 	return at91_pm_init();
 }
 
-void __init at91_sam9g45_pm_init(void)
+void __init at91sam9g45_pm_init(void)
 {
 	at91_dt_ramc();
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP;
@@ -350,7 +350,7 @@ void __init at91_sam9g45_pm_init(void)
 	return at91_pm_init();
 }
 
-void __init at91_sam9x5_pm_init(void)
+void __init at91sam9x5_pm_init(void)
 {
 	at91_dt_ramc();
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
diff --git a/arch/arm/mach-at91/sama5.c b/arch/arm/mach-at91/sama5.c
index 0feccbfd0eb6..228814aa5ca1 100644
--- a/arch/arm/mach-at91/sama5.c
+++ b/arch/arm/mach-at91/sama5.c
@@ -31,7 +31,7 @@
 static void __init sama5_dt_device_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-	at91_sam9x5_pm_init();
+	at91sam9x5_pm_init();
 }
 
 static const char *sama5_dt_board_compat[] __initconst = {
@@ -39,7 +39,7 @@ static const char *sama5_dt_board_compat[] __initconst = {
 	NULL
 };
 
-DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
+DT_MACHINE_START(sama5_dt, "Atmel SAMA5")
 	/* Maintainer: Atmel */
 	.map_io		= at91_map_io,
 	.init_machine	= sama5_dt_device_init,
@@ -84,7 +84,7 @@ static const char *sama5_alt_dt_board_compat[] __initconst = {
 	NULL
 };
 
-DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
+DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5")
 	/* Maintainer: Atmel */
 	.map_io		= sama5_alt_map_io,
 	.init_machine	= sama5_dt_device_init,
-- 
2.1.3

