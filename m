Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3HWMYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:09 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:65164 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab3HWMYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/40] ARM: ux500: Purge support for Snowball user buttons when booting with ATAGs
Date: Fri, 23 Aug 2013 13:23:05 +0100
Message-Id: <1377260620-18829-6-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c | 62 --------------------------------------
 1 file changed, 62 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index e634ea5..dcd482b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -119,67 +119,6 @@ static struct ab8500_codec_platform_data ab8500_codec_pdata = {
 	.ear_cmv = EAR_CMV_0_95V
 };
 
-static struct gpio_keys_button snowball_key_array[] = {
-	{
-		.gpio           = 32,
-		.type           = EV_KEY,
-		.code           = KEY_1,
-		.desc           = "userpb",
-		.active_low     = 1,
-		.debounce_interval = 50,
-		.wakeup         = 1,
-	},
-	{
-		.gpio           = 151,
-		.type           = EV_KEY,
-		.code           = KEY_2,
-		.desc           = "extkb1",
-		.active_low     = 1,
-		.debounce_interval = 50,
-		.wakeup         = 1,
-	},
-	{
-		.gpio           = 152,
-		.type           = EV_KEY,
-		.code           = KEY_3,
-		.desc           = "extkb2",
-		.active_low     = 1,
-		.debounce_interval = 50,
-		.wakeup         = 1,
-	},
-	{
-		.gpio           = 161,
-		.type           = EV_KEY,
-		.code           = KEY_4,
-		.desc           = "extkb3",
-		.active_low     = 1,
-		.debounce_interval = 50,
-		.wakeup         = 1,
-	},
-	{
-		.gpio           = 162,
-		.type           = EV_KEY,
-		.code           = KEY_5,
-		.desc           = "extkb4",
-		.active_low     = 1,
-		.debounce_interval = 50,
-		.wakeup         = 1,
-	},
-};
-
-static struct gpio_keys_platform_data snowball_key_data = {
-	.buttons        = snowball_key_array,
-	.nbuttons       = ARRAY_SIZE(snowball_key_array),
-};
-
-static struct platform_device snowball_key_dev = {
-	.name           = "gpio-keys",
-	.id             = -1,
-	.dev            = {
-		.platform_data  = &snowball_key_data,
-	}
-};
-
 static struct smsc911x_platform_config snowball_sbnet_cfg = {
 	.irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_HIGH,
 	.irq_type = SMSC911X_IRQ_TYPE_PUSH_PULL,
@@ -460,7 +399,6 @@ static void __init u8500_cryp1_hash1_init(struct device *parent)
 }
 
 static struct platform_device *snowball_platform_devs[] __initdata = {
-	&snowball_key_dev,
 	&snowball_sbnet_dev,
 	&snowball_gpio_en_3v3_regulator_dev,
 	&u8500_cpufreq_cooling_device,
-- 
1.8.1.2

