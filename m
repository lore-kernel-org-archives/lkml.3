Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3HWM1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:27:16 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54216 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3HWMYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 33/40] ARM: ux500: Don't register the STMPE/SKE when booting with ATAG support
Date: Fri, 23 Aug 2013 13:23:33 +0100
Message-Id: <1377260620-18829-34-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500-stuib.c | 62 --------------------------------
 1 file changed, 62 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-stuib.c b/arch/arm/mach-ux500/board-mop500-stuib.c
index 7e1f294..b57996b 100644
--- a/arch/arm/mach-ux500/board-mop500-stuib.c
+++ b/arch/arm/mach-ux500/board-mop500-stuib.c
@@ -6,73 +6,14 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/mfd/stmpe.h>
 #include <linux/input/bu21013.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
-#include <linux/input/matrix_keypad.h>
 #include <asm/mach-types.h>
 
 #include "board-mop500.h"
 
-/* STMPE/SKE keypad use this key layout */
-static const unsigned int mop500_keymap[] = {
-	KEY(2, 5, KEY_END),
-	KEY(4, 1, KEY_POWER),
-	KEY(3, 5, KEY_VOLUMEDOWN),
-	KEY(1, 3, KEY_3),
-	KEY(5, 2, KEY_RIGHT),
-	KEY(5, 0, KEY_9),
-
-	KEY(0, 5, KEY_MENU),
-	KEY(7, 6, KEY_ENTER),
-	KEY(4, 5, KEY_0),
-	KEY(6, 7, KEY_2),
-	KEY(3, 4, KEY_UP),
-	KEY(3, 3, KEY_DOWN),
-
-	KEY(6, 4, KEY_SEND),
-	KEY(6, 2, KEY_BACK),
-	KEY(4, 2, KEY_VOLUMEUP),
-	KEY(5, 5, KEY_1),
-	KEY(4, 3, KEY_LEFT),
-	KEY(3, 2, KEY_7),
-};
-
-static const struct matrix_keymap_data mop500_keymap_data = {
-	.keymap		= mop500_keymap,
-	.keymap_size    = ARRAY_SIZE(mop500_keymap),
-};
-/*
- * STMPE1601
- */
-static struct stmpe_keypad_platform_data stmpe1601_keypad_data = {
-	.debounce_ms    = 64,
-	.scan_count     = 8,
-	.no_autorepeat  = true,
-	.keymap_data    = &mop500_keymap_data,
-};
-
-static struct stmpe_platform_data stmpe1601_data = {
-	.id		= 1,
-	.blocks		= STMPE_BLOCK_KEYPAD,
-	.irq_trigger    = IRQF_TRIGGER_FALLING,
-	.irq_base       = MOP500_STMPE1601_IRQ(0),
-	.keypad		= &stmpe1601_keypad_data,
-	.autosleep      = true,
-	.autosleep_timeout = 1024,
-};
-
-static struct i2c_board_info __initdata mop500_i2c0_devices_stuib[] = {
-	{
-		I2C_BOARD_INFO("stmpe1601", 0x40),
-		.irq = NOMADIK_GPIO_TO_IRQ(218),
-		.platform_data = &stmpe1601_data,
-		.flags = I2C_CLIENT_WAKE,
-	},
-};
-
 /*
  * BU21013 ROHM touchscreen interface on the STUIBs
  */
@@ -112,9 +53,6 @@ void __init mop500_stuib_init(void)
 	else
 		tsc_plat_device.cs_pin = GPIO_BU21013_CS;
 
-	mop500_uib_i2c_add(0, mop500_i2c0_devices_stuib,
-			ARRAY_SIZE(mop500_i2c0_devices_stuib));
-
 	mop500_uib_i2c_add(3, u8500_i2c3_devices_stuib,
 			ARRAY_SIZE(u8500_i2c3_devices_stuib));
 }
-- 
1.8.1.2

