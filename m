Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3EMKQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:16:46 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41910 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3EMKQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:16:18 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 4/4] ARM: sunxi: Remove the .map_io function declaration
Date: Mon, 13 May 2013 12:16:09 +0200
Message-Id: <1368440169-29088-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debug_ll_io_init should be enough to map the needed addresses at boot,
so remove the trivial map_io code, and let the core call
debug_ll_io_init.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/sunxi.c | 17 -----------------
 arch/arm/mach-sunxi/sunxi.h | 20 --------------------
 2 files changed, 37 deletions(-)
 delete mode 100644 arch/arm/mach-sunxi/sunxi.h

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 706ce35..d1b5bc5 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -26,8 +26,6 @@
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
 
-#include "sunxi.h"
-
 #define SUN4I_WATCHDOG_CTRL_REG		0x00
 #define SUN4I_WATCHDOG_CTRL_RESTART		(1 << 0)
 #define SUN4I_WATCHDOG_MODE_REG		0x04
@@ -81,20 +79,6 @@ static void sunxi_setup_restart(void)
 	arm_pm_restart = of_id->data;
 }
 
-static struct map_desc sunxi_io_desc[] __initdata = {
-	{
-		.virtual	= (unsigned long) SUNXI_REGS_VIRT_BASE,
-		.pfn		= __phys_to_pfn(SUNXI_REGS_PHYS_BASE),
-		.length		= SUNXI_REGS_SIZE,
-		.type		= MT_DEVICE,
-	},
-};
-
-void __init sunxi_map_io(void)
-{
-	iotable_init(sunxi_io_desc, ARRAY_SIZE(sunxi_io_desc));
-}
-
 static void __init sunxi_timer_init(void)
 {
 	sunxi_init_clocks();
@@ -116,7 +100,6 @@ static const char * const sunxi_board_dt_compat[] = {
 
 DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
 	.init_machine	= sunxi_dt_init,
-	.map_io		= sunxi_map_io,
 	.init_irq	= irqchip_init,
 	.init_time	= sunxi_timer_init,
 	.dt_compat	= sunxi_board_dt_compat,
diff --git a/arch/arm/mach-sunxi/sunxi.h b/arch/arm/mach-sunxi/sunxi.h
deleted file mode 100644
index 33b5871..0000000
--- a/arch/arm/mach-sunxi/sunxi.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Generic definitions for Allwinner SunXi SoCs
- *
- * Copyright (C) 2012 Maxime Ripard
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2.  This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#ifndef __MACH_SUNXI_H
-#define __MACH_SUNXI_H
-
-#define SUNXI_REGS_PHYS_BASE	0x01c00000
-#define SUNXI_REGS_VIRT_BASE	IOMEM(0xf1c00000)
-#define SUNXI_REGS_SIZE		(SZ_2M + SZ_1M)
-
-#endif /* __MACH_SUNXI_H */
-- 
1.8.1.2

