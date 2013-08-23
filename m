Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3HWMe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:34:57 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44766 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab3HWMX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:23:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/40] ARM: ux500: Remove TPS61052 High Power White LED Driver ATAG support
Date: Fri, 23 Aug 2013 13:23:02 +0100
Message-Id: <1377260620-18829-3-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 4fe6aa0..14fbee0 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -242,15 +242,6 @@ static struct platform_device u8500_cpufreq_cooling_device = {
 };
 
 /*
- * TPS61052
- */
-
-static struct tps6105x_platform_data mop500_tps61052_data = {
-	.mode = TPS6105X_MODE_VOLTAGE,
-	.regulator_data = &tps61052_regulator,
-};
-
-/*
  * TC35892
  */
 
@@ -331,11 +322,6 @@ static struct i2c_board_info __initdata mop500_i2c0_devices[] = {
 		.irq		= NOMADIK_GPIO_TO_IRQ(217),
 		.platform_data  = &mop500_tc35892_data,
 	},
-	/* I2C0 devices only available prior to HREFv60 */
-	{
-		I2C_BOARD_INFO("tps61052", 0x33),
-		.platform_data  = &mop500_tps61052_data,
-	},
 };
 
 #define NUM_PRE_V60_I2C0_DEVICES 1
-- 
1.8.1.2

