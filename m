Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaGAJf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:35:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33614 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932151AbaGAJfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:17 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 06/14] AT91: dt: Remove init_time definitions
Date: Tue,  1 Jul 2014 11:33:19 +0200
Message-Id: <1404207208-14513-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current AT91 DT boards have a completely generic init_time definition.
Remove them from the machine declaration.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/board-dt-sam9.c  | 11 -----------
 arch/arm/mach-at91/board-dt-sama5.c | 10 ----------
 2 files changed, 21 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index a9fcdadfd929..3f80ceb3f444 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -14,7 +14,6 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/clk-provider.h>
-#include <linux/clocksource.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -26,15 +25,6 @@
 #include "board.h"
 #include "generic.h"
 
-
-static void __init sam9_dt_timer_init(void)
-{
-#if defined(CONFIG_COMMON_CLK)
-	of_clk_init(NULL);
-#endif
-	clocksource_of_init();
-}
-
 static const struct of_device_id irq_of_match[] __initconst = {
 
 	{ .compatible = "atmel,at91rm9200-aic", .data = at91_aic_of_init },
@@ -53,7 +43,6 @@ static const char *at91_dt_board_compat[] __initdata = {
 
 DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	/* Maintainer: Atmel */
-	.init_time	= sam9_dt_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91_dt_initialize,
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index c07dd2395f36..030f4b65f449 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -17,7 +17,6 @@
 #include <linux/of_platform.h>
 #include <linux/phy.h>
 #include <linux/clk-provider.h>
-#include <linux/clocksource.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -28,14 +27,6 @@
 #include "at91_aic.h"
 #include "generic.h"
 
-static void __init sama5_dt_timer_init(void)
-{
-#if defined(CONFIG_COMMON_CLK)
-	of_clk_init(NULL);
-#endif
-	clocksource_of_init();
-}
-
 static const struct of_device_id irq_of_match[] __initconst = {
 
 	{ .compatible = "atmel,sama5d3-aic", .data = at91_aic5_of_init },
@@ -81,7 +72,6 @@ static const char *sama5_dt_board_compat[] __initdata = {
 
 DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
-	.init_time	= sama5_dt_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic5_handle_irq,
 	.init_early	= at91_dt_initialize,
-- 
2.0.0

