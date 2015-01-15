Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbbAOWAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:00:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57622 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932351AbbAOWAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:00:12 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 14/17] ARM: at91: rework initialization for sama5 based boards
Date: Thu, 15 Jan 2015 22:58:17 +0100
Message-Id: <1421359100-8930-15-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed useless .map_io for sama5d3 and .init_early by moving
at91_dt_initialize() to sama5*_dt_device_init()

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/sama5d3.c | 9 ++-------
 arch/arm/mach-at91/sama5d4.c | 3 ++-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index 6f73a34cb7e4..752d1612ff1f 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -7,20 +7,17 @@
  * Licensed under GPLv2 or later.
  */
 
-#include <linux/init.h>
 #include <linux/of_platform.h>
 
 #include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-
-#include <mach/sama5d3.h>
-#include <mach/cpu.h>
 
 #include "generic.h"
 
 static void __init sama5_dt_device_init(void)
 {
 	at91_sam9260_pm_init();
+	at91_dt_initialize();
+
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
@@ -31,8 +28,6 @@ static const char *sama5_dt_board_compat[] __initconst = {
 
 DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
-	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
 	.init_machine	= sama5_dt_device_init,
 	.dt_compat	= sama5_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
index 87c71afedb57..2f1ee08dc49f 100644
--- a/arch/arm/mach-at91/sama5d4.c
+++ b/arch/arm/mach-at91/sama5d4.c
@@ -52,6 +52,8 @@ static void __init sama5d4_map_io(void)
 static void __init sama5d4_dt_device_init(void)
 {
 	at91_sam9260_pm_init();
+	at91_dt_initialize();
+
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
@@ -63,7 +65,6 @@ static const char *sama5_alt_dt_board_compat[] __initconst = {
 DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
 	.map_io		= sama5d4_map_io,
-	.init_early	= at91_dt_initialize,
 	.init_machine	= sama5d4_dt_device_init,
 	.dt_compat	= sama5_alt_dt_board_compat,
 	.l2c_aux_mask	= ~0UL,
-- 
2.1.0

