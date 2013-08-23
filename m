Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab3HWMYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:19 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59171 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3HWMYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/40] ARM: ux500: Prevent CODEC platform data from being passed when booting ATAGs
Date: Fri, 23 Aug 2013 13:23:12 +0100
Message-Id: <1377260620-18829-13-git-send-email-lee.jones@linaro.org>
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
index fec8733..f185e53 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -29,7 +29,6 @@
 #include <linux/mfd/tc3589x.h>
 #include <linux/mfd/tps6105x.h>
 #include <linux/mfd/abx500/ab8500-gpio.h>
-#include <linux/mfd/abx500/ab8500-codec.h>
 #include <linux/platform_data/leds-lp55xx.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
@@ -56,23 +55,10 @@ static struct abx500_gpio_platform_data ab8500_gpio_pdata = {
 	.gpio_base		= MOP500_AB8500_PIN_GPIO(1),
 };
 
-/* ab8500-codec */
-static struct ab8500_codec_platform_data ab8500_codec_pdata = {
-	.amics =  {
-		.mic1_type = AMIC_TYPE_DIFFERENTIAL,
-		.mic2_type = AMIC_TYPE_DIFFERENTIAL,
-		.mic1a_micbias = AMIC_MICBIAS_VAMIC1,
-		.mic1b_micbias = AMIC_MICBIAS_VAMIC1,
-		.mic2_micbias = AMIC_MICBIAS_VAMIC2
-	},
-	.ear_cmv = EAR_CMV_0_95V
-};
-
 struct ab8500_platform_data ab8500_platdata = {
 	.irq_base	= MOP500_AB8500_IRQ_BASE,
 	.regulator	= &ab8500_regulator_plat_data,
 	.gpio		= &ab8500_gpio_pdata,
-	.codec		= &ab8500_codec_pdata,
 };
 
 /*
-- 
1.8.1.2

