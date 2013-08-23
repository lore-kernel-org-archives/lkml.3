Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3HWM2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:28:07 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38966 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab3HWMYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 29/40] ARM: ux500: Stop requesting the SoC device to play 'parent' role
Date: Fri, 23 Aug 2013 13:23:29 +0100
Message-Id: <1377260620-18829-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more devices which require left to register which require
a parent. This is part of the ux500 conversion over to Device Tree only
booting.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c | 12 ------------
 arch/arm/mach-ux500/cpu-db8500.c   |  8 --------
 2 files changed, 20 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index db6908a..25c6dcd 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -80,36 +80,24 @@ struct pl022_ssp_controller ssp0_plat = {
 
 static void __init mop500_init_machine(void)
 {
-	struct device *parent = NULL;
-
 	platform_device_register(&db8500_prcmu_device);
 
-	parent = u8500_init_devices();
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
 
 static void __init snowball_init_machine(void)
 {
-	struct device *parent = NULL;
-
 	platform_device_register(&db8500_prcmu_device);
 
-	parent = u8500_init_devices();
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
 
 static void __init hrefv60_init_machine(void)
 {
-	struct device *parent = NULL;
-
 	platform_device_register(&db8500_prcmu_device);
 
-	parent = u8500_init_devices();
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 0ec6ddf..162ea03 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -136,14 +136,6 @@ static struct device * __init db8500_soc_device_init(void)
 	return ux500_soc_device_init(soc_id);
 }
 
-/*
- * This function is called from the board init
- */
-struct device * __init u8500_init_devices(void)
-{
-	return db8500_soc_device_init();
-}
-
 #ifdef CONFIG_MACH_UX500_DT
 static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires call-back bindings. */
-- 
1.8.1.2

