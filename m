Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3HWMYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:03 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34661 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3HWMX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:23:59 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/40] ARM: ux500: Remove ATAG support for LP5521 Programmable Three-Channel LED driver
Date: Fri, 23 Aug 2013 13:23:03 +0100
Message-Id: <1377260620-18829-4-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c | 60 --------------------------------------
 1 file changed, 60 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 14fbee0..b090d4d 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -266,56 +266,6 @@ static struct tc3589x_platform_data mop500_tc35892_data = {
 	.irq_base	= MOP500_EGPIO_IRQ_BASE,
 };
 
-static struct lp55xx_led_config lp5521_pri_led[] = {
-       [0] = {
-	       .chan_nr = 0,
-	       .led_current = 0x2f,
-	       .max_current = 0x5f,
-       },
-       [1] = {
-	       .chan_nr = 1,
-	       .led_current = 0x2f,
-	       .max_current = 0x5f,
-       },
-       [2] = {
-	       .chan_nr = 2,
-	       .led_current = 0x2f,
-	       .max_current = 0x5f,
-       },
-};
-
-static struct lp55xx_platform_data __initdata lp5521_pri_data = {
-       .label = "lp5521_pri",
-       .led_config     = &lp5521_pri_led[0],
-       .num_channels   = 3,
-       .clock_mode     = LP55XX_CLOCK_EXT,
-};
-
-static struct lp55xx_led_config lp5521_sec_led[] = {
-       [0] = {
-	       .chan_nr = 0,
-	       .led_current = 0x2f,
-	       .max_current = 0x5f,
-       },
-       [1] = {
-	       .chan_nr = 1,
-	       .led_current = 0x2f,
-	       .max_current = 0x5f,
-       },
-       [2] = {
-	       .chan_nr = 2,
-	       .led_current = 0x2f,
-	       .max_current = 0x5f,
-       },
-};
-
-static struct lp55xx_platform_data __initdata lp5521_sec_data = {
-       .label = "lp5521_sec",
-       .led_config     = &lp5521_sec_led[0],
-       .num_channels   = 3,
-       .clock_mode     = LP55XX_CLOCK_EXT,
-};
-
 static struct i2c_board_info __initdata mop500_i2c0_devices[] = {
 	{
 		I2C_BOARD_INFO("tc3589x", 0x42),
@@ -328,16 +278,6 @@ static struct i2c_board_info __initdata mop500_i2c0_devices[] = {
 
 static struct i2c_board_info __initdata mop500_i2c2_devices[] = {
 	{
-		/* lp5521 LED driver, 1st device */
-		I2C_BOARD_INFO("lp5521", 0x33),
-		.platform_data = &lp5521_pri_data,
-	},
-	{
-		/* lp5521 LED driver, 2st device */
-		I2C_BOARD_INFO("lp5521", 0x34),
-		.platform_data = &lp5521_sec_data,
-	},
-	{
 		/* Light sensor Rohm BH1780GLI */
 		I2C_BOARD_INFO("bh1780", 0x29),
 	},
-- 
1.8.1.2

