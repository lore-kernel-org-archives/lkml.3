Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3HWMY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:59 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34513 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab3HWMY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 34/40] ARM: ux500: Remove BU21013 ROHM TS support when booting with only ATAGs
Date: Fri, 23 Aug 2013 13:23:34 +0100
Message-Id: <1377260620-18829-35-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's time to remove all ATAG support from ux500 and rely solely on
Device Tree booting. This patch is part of that endeavour.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-stuib.c | 44 --------------------------------
 1 file changed, 44 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-stuib.c b/arch/arm/mach-ux500/board-mop500-stuib.c
index b57996b..7fa3021 100644
--- a/arch/arm/mach-ux500/board-mop500-stuib.c
+++ b/arch/arm/mach-ux500/board-mop500-stuib.c
@@ -6,53 +6,9 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/input/bu21013.h>
-#include <linux/gpio.h>
-#include <linux/interrupt.h>
-#include <linux/i2c.h>
-#include <asm/mach-types.h>
 
 #include "board-mop500.h"
 
-/*
- * BU21013 ROHM touchscreen interface on the STUIBs
- */
-
-#define TOUCH_GPIO_PIN  84
-
-#define TOUCH_XMAX	384
-#define TOUCH_YMAX	704
-
-#define PRCMU_CLOCK_OCR		0x1CC
-#define TSC_EXT_CLOCK_9_6MHZ	0x840000
-
-static struct bu21013_platform_device tsc_plat_device = {
-	.touch_pin = TOUCH_GPIO_PIN,
-	.touch_x_max = TOUCH_XMAX,
-	.touch_y_max = TOUCH_YMAX,
-	.ext_clk = false,
-	.x_flip = false,
-	.y_flip = true,
-};
-
-static struct i2c_board_info __initdata u8500_i2c3_devices_stuib[] = {
-	{
-		I2C_BOARD_INFO("bu21013_tp", 0x5C),
-		.platform_data = &tsc_plat_device,
-	},
-	{
-		I2C_BOARD_INFO("bu21013_tp", 0x5D),
-		.platform_data = &tsc_plat_device,
-	},
-};
-
 void __init mop500_stuib_init(void)
 {
-	if (machine_is_hrefv60())
-		tsc_plat_device.cs_pin = HREFV60_TOUCH_RST_GPIO;
-	else
-		tsc_plat_device.cs_pin = GPIO_BU21013_CS;
-
-	mop500_uib_i2c_add(3, u8500_i2c3_devices_stuib,
-			ARRAY_SIZE(u8500_i2c3_devices_stuib));
 }
-- 
1.8.1.2

