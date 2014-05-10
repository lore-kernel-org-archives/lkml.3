Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbaEJHBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:01:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35401 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaEJG7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:59:55 -0400
X-AuditID: cbfee61b-b7f766d00000646c-f5-536dce691c1e
From: y@samsung.com
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v3 2/6] ARM: EXYNOS: Remove i2c sys configuration related code
Date: Sat, 10 May 2014 16:18:03 +0900
Message-id: <1399706287-13919-3-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399706287-13919-1-git-send-email-y@samsung.com>
References: <1399706287-13919-1-git-send-email-y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t9jAd3Mc7nBBl82i1n8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLA4cHi3NPWwev39NYvTYvKTeo2/LKkaP
	z5vkAlijuGxSUnMyy1KL9O0SuDJmrb7JVPBQq+LMQ68GxmtKXYycHBICJhI3G66yQ9hiEhfu
	rWfrYuTiEBJYxCixYvtlKKeNSWL1622MXYwcHGwCwhJTD2iBNIgIZEtcabzPDFLDLNDHKNH5
	5hcbSEJYwE+ib8UzsKksAqoSyzbsALN5BWwlJnTfZgeZIyGgIDFnkg1ImFPATuLatmYWEFsI
	qGTK0cOMExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDqxn0jsYVzVYHGIU4GBU
	4uEtfJsTLMSaWFZcmXuIUYKDWUmEd8XB3GAh3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOF
	BNITS1KzU1MLUotgskwcnFINjFs7Ig2iFJ4IGIhaOjTf+3bz/OYoOZPMIy2lKyZOjrNNFJ3/
	OfZDtt35Bc6uT5+EN2UHXZt99L5OwkyPEtk7BybMYiquW71ji/1X1q/rQvYcaRE8U9axLeRX
	2O1fj6NZ7oaq9zsduyLc/uNYpoGH3VGfF6v+bT3Ke1VpWyP/jTeCjh9P+F1aUaDEUpyRaKjF
	XFScCABi3qjyKAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Dubey <pankaj.dubey@samsung.com>

Since all these code has been moved into i2c driver, now we can
safely remove them from machine files.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c           |   38 +------------------------------
 arch/arm/mach-exynos/include/mach/map.h |    3 ---
 arch/arm/mach-exynos/pm.c               |   10 --------
 arch/arm/mach-exynos/regs-sys.h         |   22 ------------------
 4 files changed, 1 insertion(+), 72 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/regs-sys.h

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 59eb1f1..09063ee 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -29,11 +29,11 @@
 #include <asm/memory.h>
 
 #include <plat/cpu.h>
+#include <mach/map.h>
 
 #include "common.h"
 #include "mfc.h"
 #include "regs-pmu.h"
-#include "regs-sys.h"
 
 #define L2_AUX_VAL 0x7C470001
 #define L2_AUX_MASK 0xC200ffff
@@ -42,11 +42,6 @@ static struct regmap *exynos_pmu_regmap;
 
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
-		.virtual	= (unsigned long)S3C_VA_SYS,
-		.pfn		= __phys_to_pfn(EXYNOS4_PA_SYSCON),
-		.length		= SZ_64K,
-		.type		= MT_DEVICE,
-	}, {
 		.virtual	= (unsigned long)S3C_VA_TIMER,
 		.pfn		= __phys_to_pfn(EXYNOS4_PA_TIMER),
 		.length		= SZ_16K,
@@ -116,11 +111,6 @@ static struct map_desc exynos4_iodesc[] __initdata = {
 
 static struct map_desc exynos5_iodesc[] __initdata = {
 	{
-		.virtual	= (unsigned long)S3C_VA_SYS,
-		.pfn		= __phys_to_pfn(EXYNOS5_PA_SYSCON),
-		.length		= SZ_64K,
-		.type		= MT_DEVICE,
-	}, {
 		.virtual	= (unsigned long)S3C_VA_TIMER,
 		.pfn		= __phys_to_pfn(EXYNOS5_PA_TIMER),
 		.length		= SZ_16K,
@@ -293,32 +283,6 @@ void __init exynos_map_pmu(void)
 
 static void __init exynos_dt_machine_init(void)
 {
-	struct device_node *i2c_np;
-	const char *i2c_compat = "samsung,s3c2440-i2c";
-	unsigned int tmp;
-	int id;
-
-	/*
-	 * Exynos5's legacy i2c controller and new high speed i2c
-	 * controller have muxed interrupt sources. By default the
-	 * interrupts for 4-channel HS-I2C controller are enabled.
-	 * If node for first four channels of legacy i2c controller
-	 * are available then re-configure the interrupts via the
-	 * system register.
-	 */
-	if (soc_is_exynos5()) {
-		for_each_compatible_node(i2c_np, NULL, i2c_compat) {
-			if (of_device_is_available(i2c_np)) {
-				id = of_alias_get_id(i2c_np, "i2c");
-				if (id < 4) {
-					tmp = readl(EXYNOS5_SYS_I2C_CFG);
-					writel(tmp & ~(0x1 << id),
-							EXYNOS5_SYS_I2C_CFG);
-				}
-			}
-		}
-	}
-
 	exynos_map_pmu();
 
 	if (!soc_is_exynos5440())
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 34eee6e..bd4a320 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -25,9 +25,6 @@
 
 #define EXYNOS_PA_CHIPID		0x10000000
 
-#define EXYNOS4_PA_SYSCON		0x10010000
-#define EXYNOS5_PA_SYSCON		0x10050100
-
 #define EXYNOS4_PA_CMU			0x10030000
 #define EXYNOS5_PA_CMU			0x10010000
 
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index a7a1b7f..59e5604 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -37,7 +37,6 @@
 
 #include "common.h"
 #include "regs-pmu.h"
-#include "regs-sys.h"
 #include "exynos-pmu.h"
 
 static struct regmap *pmu_regmap;
@@ -52,10 +51,6 @@ struct exynos_wkup_irq {
 	u32 mask;
 };
 
-static struct sleep_save exynos5_sys_save[] = {
-	SAVE_ITEM(EXYNOS5_SYS_I2C_CFG),
-};
-
 static struct sleep_save exynos_core_save[] = {
 	/* SROM side */
 	SAVE_ITEM(S5P_SROM_BW),
@@ -211,7 +206,6 @@ static void exynos_pm_prepare(void)
 	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
 	if (soc_is_exynos5250()) {
-		s3c_pm_do_save(exynos5_sys_save, ARRAY_SIZE(exynos5_sys_save));
 		/* Disable USE_RETENTION of JPEG_MEM_OPTION */
 		regmap_read(pmu_regmap, EXYNOS5_JPEG_MEM_OPTION, &tmp);
 		tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
@@ -296,10 +290,6 @@ static void exynos_pm_resume(void)
 	regmap_write(pmu_regmap, S5P_PAD_RET_EBIA_OPTION, (1 << 28));
 	regmap_write(pmu_regmap, S5P_PAD_RET_EBIB_OPTION, (1 << 28));
 
-	if (soc_is_exynos5250())
-		s3c_pm_do_restore(exynos5_sys_save,
-			ARRAY_SIZE(exynos5_sys_save));
-
 	s3c_pm_do_restore_core(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
 	if (!soc_is_exynos5250())
diff --git a/arch/arm/mach-exynos/regs-sys.h b/arch/arm/mach-exynos/regs-sys.h
deleted file mode 100644
index 84332b0..0000000
--- a/arch/arm/mach-exynos/regs-sys.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright (c) 2014 Samsung Electronics Co., Ltd.
- *             http://www.samsung.com
- *
- * EXYNOS - system register definition
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_ARCH_REGS_SYS_H
-#define __ASM_ARCH_REGS_SYS_H __FILE__
-
-#include <mach/map.h>
-
-#define S5P_SYSREG(x)                          (S3C_VA_SYS + (x))
-
-/* For EXYNOS5 */
-#define EXYNOS5_SYS_I2C_CFG                    S5P_SYSREG(0x0234)
-
-#endif /* __ASM_ARCH_REGS_SYS_H */
-- 
1.7.10.4

