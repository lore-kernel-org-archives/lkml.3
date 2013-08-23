Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3HWMYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:24:52 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:32957 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab3HWMYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:24:49 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/40] ARM: ux500: Purge DB8500 PRCMU registration when not booting with DT
Date: Fri, 23 Aug 2013 13:23:30 +0100
Message-Id: <1377260620-18829-31-git-send-email-lee.jones@linaro.org>
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
 arch/arm/mach-ux500/board-mop500.c   |  6 ------
 arch/arm/mach-ux500/devices-db8500.c | 36 ------------------------------------
 arch/arm/mach-ux500/devices-db8500.h |  1 -
 3 files changed, 43 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 25c6dcd..3086192 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -80,24 +80,18 @@ struct pl022_ssp_controller ssp0_plat = {
 
 static void __init mop500_init_machine(void)
 {
-	platform_device_register(&db8500_prcmu_device);
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
 
 static void __init snowball_init_machine(void)
 {
-	platform_device_register(&db8500_prcmu_device);
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
 
 static void __init hrefv60_init_machine(void)
 {
-	platform_device_register(&db8500_prcmu_device);
-
 	/* This board has full regulator constraints */
 	regulator_has_full_constraints();
 }
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 1b2faba..c59f89d 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -26,39 +26,3 @@ struct prcmu_pdata db8500_prcmu_pdata = {
 	.version_offset	= DB8500_PRCMU_FW_VERSION_OFFSET,
 	.legacy_offset	= DB8500_PRCMU_LEGACY_OFFSET,
 };
-
-static struct resource db8500_prcmu_res[] = {
-	{
-		.name  = "prcmu",
-		.start = U8500_PRCMU_BASE,
-		.end   = U8500_PRCMU_BASE + SZ_8K - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.name  = "prcmu-tcdm",
-		.start = U8500_PRCMU_TCDM_BASE,
-		.end   = U8500_PRCMU_TCDM_BASE + SZ_4K - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.name  = "irq",
-		.start = IRQ_DB8500_PRCMU1,
-		.end   = IRQ_DB8500_PRCMU1,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name  = "prcmu-tcpm",
-		.start = U8500_PRCMU_TCPM_BASE,
-		.end   = U8500_PRCMU_TCPM_BASE + SZ_32K - 1,
-		.flags = IORESOURCE_MEM,
-	},
-};
-
-struct platform_device db8500_prcmu_device = {
-	.name			= "db8500-prcmu",
-	.resource		= db8500_prcmu_res,
-	.num_resources		= ARRAY_SIZE(db8500_prcmu_res),
-	.dev = {
-		.platform_data = &db8500_prcmu_pdata,
-	},
-};
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index fc4048f..6d59218 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -16,6 +16,5 @@ struct platform_device;
 
 extern struct ab8500_platform_data ab8500_platdata;
 extern struct prcmu_pdata db8500_prcmu_pdata;
-extern struct platform_device db8500_prcmu_device;
 
 #endif
-- 
1.8.1.2

