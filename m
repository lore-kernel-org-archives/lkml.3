Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3EHNce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:32:34 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39852 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3EHNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:30:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/9] ARM: ux500: Remove duplicated assignment of ab8500_platdata
Date: Wed,  8 May 2013 14:29:01 +0100
Message-Id: <1368019749-19455-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since: "05ec260 mfd: db8500-prcmu: update resource passing", the AB8500's
platform data 'ab8500_platdata' is passed directly as an attribute to
'db8500_prcmu_pdata', so there's no requirement to assign it a second
time. In fact, it's only due to an ordering issue that the entire
'db8500_prcmu_pdata' data structure isn't completely over-written by the
assignment in u8500_init_devices().

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    6 +++---
 arch/arm/mach-ux500/cpu-db8500.c   |    4 +---
 arch/arm/mach-ux500/setup.h        |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 9bc762a..14a3598 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -623,7 +623,7 @@ static void __init mop500_init_machine(void)
 	sdi0_reg_info.gpios[0].gpio = GPIO_SDMMC_1V8_3V_SEL;
 
 	mop500_pinmaps_init();
-	parent = u8500_init_devices(&ab8500_platdata);
+	parent = u8500_init_devices();
 
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
@@ -660,7 +660,7 @@ static void __init snowball_init_machine(void)
 	sdi0_reg_info.gpios[0].gpio = SNOWBALL_SDMMC_1V8_3V_GPIO;
 
 	snowball_pinmaps_init();
-	parent = u8500_init_devices(&ab8500_platdata);
+	parent = u8500_init_devices();
 
 	for (i = 0; i < ARRAY_SIZE(snowball_platform_devs); i++)
 		snowball_platform_devs[i]->dev.parent = parent;
@@ -698,7 +698,7 @@ static void __init hrefv60_init_machine(void)
 	sdi0_reg_info.gpios[0].gpio = HREFV60_SDMMC_1V8_3V_GPIO;
 
 	hrefv60_pinmaps_init();
-	parent = u8500_init_devices(&ab8500_platdata);
+	parent = u8500_init_devices();
 
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 995928b..8c2590c 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -206,7 +206,7 @@ static struct device * __init db8500_soc_device_init(void)
 /*
  * This function is called from the board init
  */
-struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500)
+struct device * __init u8500_init_devices(void)
 {
 	struct device *parent;
 	int i;
@@ -220,8 +220,6 @@ struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500)
 	for (i = 0; i < ARRAY_SIZE(platform_devs); i++)
 		platform_devs[i]->dev.parent = parent;
 
-	db8500_prcmu_device.dev.platform_data = ab8500;
-
 	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
 
 	return parent;
diff --git a/arch/arm/mach-ux500/setup.h b/arch/arm/mach-ux500/setup.h
index bddce2b..cad3ca8 100644
--- a/arch/arm/mach-ux500/setup.h
+++ b/arch/arm/mach-ux500/setup.h
@@ -18,7 +18,7 @@
 void __init ux500_map_io(void);
 extern void __init u8500_map_io(void);
 
-extern struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500);
+extern struct device * __init u8500_init_devices(void);
 
 extern void __init ux500_init_irq(void);
 extern void __init ux500_init_late(void);
-- 
1.7.10.4

