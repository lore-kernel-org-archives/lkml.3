Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3HWMYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:06 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43794 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3HWMYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/40] ARM: ux500: Disable Snowball's SMSC911x Ethernet when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:06 +0100
Message-Id: <1377260620-18829-7-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index dcd482b..062f8bf 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -33,7 +33,6 @@
 #include <linux/mfd/abx500/ab8500-codec.h>
 #include <linux/platform_data/leds-lp55xx.h>
 #include <linux/input.h>
-#include <linux/smsc911x.h>
 #include <linux/gpio_keys.h>
 #include <linux/delay.h>
 #include <linux/leds.h>
@@ -119,36 +118,6 @@ static struct ab8500_codec_platform_data ab8500_codec_pdata = {
 	.ear_cmv = EAR_CMV_0_95V
 };
 
-static struct smsc911x_platform_config snowball_sbnet_cfg = {
-	.irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_HIGH,
-	.irq_type = SMSC911X_IRQ_TYPE_PUSH_PULL,
-	.flags = SMSC911X_USE_16BIT | SMSC911X_FORCE_INTERNAL_PHY,
-	.shift = 1,
-};
-
-static struct resource sbnet_res[] = {
-	{
-		.name = "smsc911x-memory",
-		.start = (0x5000 << 16),
-		.end  =  (0x5000 << 16) + 0xffff,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = NOMADIK_GPIO_TO_IRQ(140),
-		.end = NOMADIK_GPIO_TO_IRQ(140),
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE,
-	},
-};
-
-static struct platform_device snowball_sbnet_dev = {
-	.name           = "smsc911x",
-	.num_resources  = ARRAY_SIZE(sbnet_res),
-	.resource       = sbnet_res,
-	.dev            = {
-		.platform_data = &snowball_sbnet_cfg,
-	},
-};
-
 struct ab8500_platform_data ab8500_platdata = {
 	.irq_base	= MOP500_AB8500_IRQ_BASE,
 	.regulator	= &ab8500_regulator_plat_data,
@@ -399,7 +368,6 @@ static void __init u8500_cryp1_hash1_init(struct device *parent)
 }
 
 static struct platform_device *snowball_platform_devs[] __initdata = {
-	&snowball_sbnet_dev,
 	&snowball_gpio_en_3v3_regulator_dev,
 	&u8500_cpufreq_cooling_device,
 	&sdi0_regulator,
-- 
1.8.1.2

