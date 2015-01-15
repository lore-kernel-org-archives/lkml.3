Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbbAOWAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:00:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57609 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932332AbbAOWAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:00:02 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 12/17] ARM: at91: rework initialization for rm9200 based boards
Date: Thu, 15 Jan 2015 22:58:15 +0100
Message-Id: <1421359100-8930-13-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove useless .map_io and .init_early by moving at91_dt_initialize() to
rm9200_dt_device_init().

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91rm9200.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index a3c0dd612d77..6992cc9ce902 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -8,21 +8,12 @@
  *
  * Licensed under GPLv2 or later.
  */
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/gpio.h>
 #include <linux/of.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/clk-provider.h>
-#include <linux/clk/at91_pmc.h>
 
-#include <asm/setup.h>
-#include <asm/irq.h>
+#include <asm/io.h>
 #include <asm/mach/arch.h>
-#include <asm/mach/irq.h>
-#include <asm/mach/map.h>
 #include <asm/system_misc.h>
 
 #include <mach/at91_st.h>
@@ -30,7 +21,6 @@
 
 #include "generic.h"
 
-
 static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
 	/*
@@ -51,6 +41,7 @@ static void __init rm9200_dt_device_init(void)
 	arm_pm_idle = at91rm9200_idle;
 	arm_pm_restart = at91rm9200_restart;
 	at91_rm9200_pm_init();
+	at91_dt_initialize();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
@@ -62,8 +53,6 @@ static const char *at91rm9200_dt_board_compat[] __initdata = {
 
 DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
 	.init_time      = at91rm9200_dt_timer_init,
-	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
 	.init_machine	= rm9200_dt_device_init,
 	.dt_compat	= at91rm9200_dt_board_compat,
 MACHINE_END
-- 
2.1.0

