Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbaEFIfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:35:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20376 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934412AbaEFIdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:33:18 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-90-53689e4af33a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Russell King <linux@arm.linux.org.uk>, linux-i2c@vger.kernel.org
Subject: [PATCH v2 2/6] ARM: EXYNOS: Move SYS_I2C_CFG register save/restore to
 i2c driver
Date: Tue, 06 May 2014 17:51:18 +0900
Message-id: <1399366282-4191-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+Zga73vIxgg/4VjBZ/Jx1jt+hdcJXN
	YtPja6wWHX+/MFpc3jWHzWLG+X1MFrcv81os2vqF3WL9jNcsFitPzGJ24PJoae5h8/j9axKj
	x+Yl9R59W1Yxepw89YTF4/MmuQC2KC6blNSczLLUIn27BK6M5lsnWAvW6lYc/3mJuYFxnWoX
	IyeHhICJxLqpH5khbDGJC/fWs3UxcnEICSxjlPg5/ykrTNGs/xNYIBLTGSVOfu+DctqYJF4v
	OsoCUsUmoCvx5P1csFEiAtkSVxrvM4MUMQucZZT4cuAsO0hCWCBa4vupLUxdjBwcLAKqEr9X
	+IOEeQXcJTY1nWEFCUsIKEjMmWQDEuYU8JB4c+0t2BFCQCU77t8Gu05CYB+7xJfrs9hAEiwC
	AhLfJh9igeiVldh0AOobSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMj
	JBZ6dzDePmB9iDEZaNxEZinR5HxgLOWVxBsamxlZmJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA+Pp3pKNDR7hH88JftMyi9x7p9s6/Zqz7cpbUZNMikwtsrr3
	iCSd6NjdmL/p69Gk9ZPN7fqs2f5znSw7obxU8/XeR/kZf/Y6qJpVbVDvf7xEdbrU3LivAbE3
	AzefUNA7f0z2muh6iWI3o8bLyhUF3u/3Hbv99/7HSc57pC7dsClxZduqkr3uw28lluKMREMt
	5qLiRAAaIEPwmwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQV2veRnBBhO/W1j8nXSM3aJ3wVU2
	i02Pr7FadPz9wmhxedccNosZ5/cxWdy+zGuxaOsXdov1M16zWKw8MYvZgcujpbmHzeP3r0mM
	HpuX1Hv0bVnF6HHy1BMWj8+b5ALYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAG
	EtYxZjTfOsFasFa34vjPS8wNjOtUuxg5OSQETCRm/Z/AAmGLSVy4t56ti5GLQ0hgOqPEye99
	LBBOG5PE60VHwarYBHQlnryfywxiiwhkS1xpvM8MUsQscJZR4suBs+wgCWGBaInvp7YwdTFy
	cLAIqEr8XuEPEuYVcJfY1HSGFSQsIaAgMWeSDUiYU8BD4s21t6wgthBQyY77t9kmMPIuYGRY
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcac+kdzCuarA4xCjAwajEw3tiZXqwEGtiWXFl
	7iFGCQ5mJRHe+vyMYCHelMTKqtSi/Pii0pzU4kOMyUA3TWSWEk3OByaBvJJ4Q2MTMyNLIzML
	IxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgzL20v4mVo87apeXJq4CpC2P9Tx/m
	k47JULJNNtl20PhxSKV/QPirVT/6zaIl/T0z5pyyvC/3p9w3O1H3QeF3IYV092VOndorHP0y
	Jxe0v37l/fpGWkluaYai/rsdJX+KpNpfijwSn7E3VKja7Ghg/vqIA1ONStS/RyTwz/Jd9zl/
	F9uuWlclluKMREMt5qLiRAA0YWcA+AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's move SYS_I2C_CFG register save/restore during s2r into i2c driver.
This will help in removing static iodesc based mapping from exynos.c.
Also will help in removing SoC specific checks in pm.c making it
more independent of such macros.

CC: Wolfram Sang <wsa@the-dreams.de>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-i2c@vger.kernel.org
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c           |   12 +-----------
 arch/arm/mach-exynos/include/mach/map.h |    3 ---
 arch/arm/mach-exynos/pm.c               |   10 ----------
 arch/arm/mach-exynos/regs-sys.h         |   22 ----------------------
 drivers/i2c/busses/i2c-s3c2410.c        |    8 ++++++++
 5 files changed, 9 insertions(+), 46 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/regs-sys.h

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 54ae2e1..09063ee 100644
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
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 0420150..2095a01 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -133,6 +133,7 @@ struct s3c24xx_i2c {
 	struct notifier_block	freq_transition;
 #endif
 	struct regmap		*sysreg;
+	unsigned int		syc_cfg;
 };
 
 static struct platform_device_id s3c24xx_driver_ids[] = {
@@ -1293,6 +1294,9 @@ static int s3c24xx_i2c_suspend_noirq(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
 
+	if (i2c->sysreg)
+		regmap_read(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, &i2c->syc_cfg);
+
 	i2c->suspended = 1;
 
 	return 0;
@@ -1304,6 +1308,10 @@ static int s3c24xx_i2c_resume(struct device *dev)
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
 
 	i2c->suspended = 0;
+
+	if (i2c->sysreg)
+		regmap_write(i2c->sysreg, i2c->syc_cfg, EXYNOS5_SYS_I2C_CFG);
+
 	clk_prepare_enable(i2c->clk);
 	s3c24xx_i2c_init(i2c);
 	clk_disable_unprepare(i2c->clk);
-- 
1.7.10.4

