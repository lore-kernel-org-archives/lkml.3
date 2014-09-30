Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaI3K07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:26:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25741 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaI3K00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:26:26 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-49-542a854783ae
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v8 1/2] ARM: EXYNOS: Add platform driver support for Exynos PMU
Date: Tue, 30 Sep 2014 15:51:20 +0530
Message-id: <1412072481-22370-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412072481-22370-1-git-send-email-pankaj.dubey@samsung.com>
References: <1412072481-22370-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkSte9VSvEoG2OiUXvgqtsFpseX2O1
	uLxrDpvFjPP7mCxuX+a1+HT0P6vFoq1f2C06ljFarNr1h9Hi5rPtTA5cHi3NPWweO2fdZffY
	vKTeo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDJmvmtgK9jvULFy2Wq2BsZ7pl2MnBwSAiYS
	EzvesELYYhIX7q1n62Lk4hASWMoo8adzMxtM0evTc5khEtMZJSY8mMAK4Uxgkth3BKKKTUBX
	4sl7kCpODhGBbIkf3yazgNjMArsZJd5+Futi5OAQFvCX6PpjAxJmEVCV2DPnDiNImFfAQ2L2
	gkIQU0JAQWLOJLAKTgFPif+PXrGD2EJAFX823gTbKiGwil1iY+dzNogxAhLfJh9igeiVldh0
	gBniZEmJgytusExgFF7AyLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzD0T/97NmEH470D
	1ocYBTgYlXh4OeS1QoRYE8uKK3MPMZoCbZjILCWanA+MsLySeENjMyMLUxNTYyNzSzMlcd7X
	Uj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBOWRq+o+7p3vDj4qe2vJ38OGD1tuy9hYuf
	dc3YfnSjkMBqt2sMS2tOMxd9dZ7lNkMhet+cmZHPOradvv0xpfbC6rvl81i6TFxtdqot85/C
	cWhrZ1So5THnx/YxTbfMd3le5/jUWTjjPvdfZyeWqhcd95gca76uuOj1bu0dFoF/389cmfXn
	2qp5B5VYijMSDbWYi4oTASnkrFV4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jQV33Vq0Qg0mHtSx6F1xls9j0+Bqr
	xeVdc9gsZpzfx2Rx+zKvxaej/1ktFm39wm7RsYzRYtWuP4wWN59tZ3Lg8mhp7mHz2DnrLrvH
	5iX1Hn1bVjF6fN4kF8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeY
	m2qr5OIToOuWmQN0k5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY+a7
	BraC/Q4VK5etZmtgvGfaxcjJISFgIvH69FxmCFtM4sK99WxdjFwcQgLTGSUmPJjACuFMYJLY
	d2QzG0gVm4CuxJP3EB0iAtkSP75NZgGxmQV2M0q8/SzWxcjBISzgL9H1xwYkzCKgKrFnzh1G
	kDCvgIfE7AWFIKaEgILEnElgFZwCnhL/H71iB7GFgCr+bLzJOoGRdwEjwypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4Mh6JrWDcWWDxSFGAQ5GJR5eDnmtECHWxLLiytxDjBIczEoivF/r
	gUK8KYmVValF+fFFpTmpxYcYTYFumsgsJZqcD4z6vJJ4Q2MTc1NjU0sTCxMzSyVx3gOt1oFC
	AumJJanZqakFqUUwfUwcnFINjO0WLts/TAvff0TmBpfeFFvTDR/aD5h8Op78a/thGQZ1TqYH
	ilNsmvbcFQlb736Es6m3QevIK8Gnta+slWOdUi9ebKg/uG5d3/t7q/bFMG7NqIpbx71FT+/E
	Xp3e+6uVuu8cs/Q91Hzr+JQUvpSlRparFt+YKZfss1EpU+8gk1WVbPRm/u9KIUosxRmJhlrM
	RcWJACJgRijCAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies Exynos Power Management Unit (PMU) initialization
implementation in following way:

- Added platform driver support for Exynos PMU IP.
- Added platform struct exynos_pmu_data to hold platform specific data.
- For each SoC's PMU support now we can add platform data and statically
  bind PMU configuration and SoC specific initialization function.
- Separate each SoC's PMU initialization function and make it as part of
  platform data.
- It also removes uses of soc_is_exynosXYZ().

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/Kconfig |    1 +
 arch/arm/mach-exynos/pmu.c   |  171 +++++++++++++++++++++++++++++++-----------
 2 files changed, 130 insertions(+), 42 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 46f3c0d..0ca168e 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -24,6 +24,7 @@ menuconfig ARCH_EXYNOS
 	select PM_GENERIC_DOMAINS if PM_RUNTIME
 	select S5P_DEV_MFC
 	select SRAM
+	select MFD_SYSCON
 	help
 	  Support for SAMSUNG EXYNOS SoCs (EXYNOS4/5)
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index cfc62e8..1f5aaa7 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
  *
  * EXYNOS - CPU PMU(Power Management Unit) support
@@ -10,12 +10,26 @@
  */
 
 #include <linux/io.h>
-#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 
 #include "common.h"
 #include "regs-pmu.h"
 
-static const struct exynos_pmu_conf *exynos_pmu_config;
+struct exynos_pmu_data {
+	const struct exynos_pmu_conf *pmu_config;
+	const struct exynos_pmu_conf *pmu_config_extra;
+
+	void (*pmu_init)(void);
+	void (*powerdown_conf)(enum sys_powerdown);
+};
+
+struct exynos_pmu_context {
+	struct device *dev;
+	const struct exynos_pmu_data *pmu_data;
+};
+
+static struct exynos_pmu_context *pmu_context;
 
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
@@ -336,7 +350,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
 	EXYNOS5_ISP_ARM_OPTION,
 };
 
-static void exynos5_init_pmu(void)
+static void exynos5_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
 	unsigned int tmp;
@@ -344,7 +358,7 @@ static void exynos5_init_pmu(void)
 	/*
 	 * Enable both SC_FEEDBACK and SC_COUNTER
 	 */
-	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
+	for (i = 0; i < ARRAY_SIZE(exynos5_list_both_cnt_feed); i++) {
 		tmp = pmu_raw_readl(exynos5_list_both_cnt_feed[i]);
 		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
 			EXYNOS5_USE_SC_COUNTER);
@@ -361,7 +375,7 @@ static void exynos5_init_pmu(void)
 	/*
 	 * Disable WFI/WFE on XXX_OPTION
 	 */
-	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
+	for (i = 0; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe); i++) {
 		tmp = pmu_raw_readl(exynos5_list_diable_wfi_wfe[i]);
 		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
 			 EXYNOS5_OPTION_USE_STANDBYWFI);
@@ -373,51 +387,124 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
 
-	if (soc_is_exynos5250())
-		exynos5_init_pmu();
+	const struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
 
-	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
-		pmu_raw_writel(exynos_pmu_config[i].val[mode],
-				exynos_pmu_config[i].offset);
+	if (pmu_data->powerdown_conf)
+		pmu_data->powerdown_conf(mode);
 
-	if (soc_is_exynos4412()) {
-		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END ; i++)
-			pmu_raw_writel(exynos4412_pmu_config[i].val[mode],
-					exynos4412_pmu_config[i].offset);
+	if (pmu_data->pmu_config) {
+		for (i = 0; (pmu_data->pmu_config[i].offset != PMU_TABLE_END); i++)
+			pmu_raw_writel(pmu_data->pmu_config[i].val[mode],
+					pmu_data->pmu_config[i].offset);
+	}
+
+	if (pmu_data->pmu_config_extra) {
+		for (i = 0; pmu_data->pmu_config_extra[i].offset != PMU_TABLE_END; i++)
+			pmu_raw_writel(pmu_data->pmu_config_extra[i].val[mode],
+					pmu_data->pmu_config_extra[i].offset);
 	}
 }
 
-static int __init exynos_pmu_init(void)
+static void exynos5250_pmu_init(void)
 {
 	unsigned int value;
+	/*
+	 * When SYS_WDTRESET is set, watchdog timer reset request
+	 * is ignored by power management unit.
+	 */
+	value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
+
+	value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
+}
+
+static const struct exynos_pmu_data exynos4210_pmu_data = {
+	.pmu_config	= exynos4210_pmu_config,
+};
+
+static const struct exynos_pmu_data exynos4212_pmu_data = {
+	.pmu_config	= exynos4x12_pmu_config,
+};
+
+static const struct exynos_pmu_data exynos4412_pmu_data = {
+	.pmu_config		= exynos4x12_pmu_config,
+	.pmu_config_extra	= exynos4412_pmu_config,
+};
+
+static const struct exynos_pmu_data exynos5250_pmu_data = {
+	.pmu_config	= exynos5250_pmu_config,
+	.pmu_init	= exynos5250_pmu_init,
+	.powerdown_conf	= exynos5_powerdown_conf,
+};
+
+/*
+ * PMU platform driver and devicetree bindings.
+ */
+static const struct of_device_id exynos_pmu_of_device_ids[] = {
+	{
+		.compatible = "samsung,exynos4210-pmu",
+		.data = &exynos4210_pmu_data,
+	}, {
+		.compatible = "samsung,exynos4212-pmu",
+		.data = &exynos4212_pmu_data,
+	}, {
+		.compatible = "samsung,exynos4412-pmu",
+		.data = &exynos4412_pmu_data,
+	}, {
+		.compatible = "samsung,exynos5250-pmu",
+		.data = &exynos5250_pmu_data,
+	},
+	{ /*sentinel*/ },
+};
 
-	exynos_pmu_config = exynos4210_pmu_config;
-
-	if (soc_is_exynos4210()) {
-		exynos_pmu_config = exynos4210_pmu_config;
-		pr_info("EXYNOS4210 PMU Initialize\n");
-	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
-		exynos_pmu_config = exynos4x12_pmu_config;
-		pr_info("EXYNOS4x12 PMU Initialize\n");
-	} else if (soc_is_exynos5250()) {
-		/*
-		 * When SYS_WDTRESET is set, watchdog timer reset request
-		 * is ignored by power management unit.
-		 */
-		value = pmu_raw_readl(EXYNOS5_AUTO_WDTRESET_DISABLE);
-		value &= ~EXYNOS5_SYS_WDTRESET;
-		pmu_raw_writel(value, EXYNOS5_AUTO_WDTRESET_DISABLE);
-
-		value = pmu_raw_readl(EXYNOS5_MASK_WDTRESET_REQUEST);
-		value &= ~EXYNOS5_SYS_WDTRESET;
-		pmu_raw_writel(value, EXYNOS5_MASK_WDTRESET_REQUEST);
-
-		exynos_pmu_config = exynos5250_pmu_config;
-		pr_info("EXYNOS5250 PMU Initialize\n");
-	} else {
-		pr_info("EXYNOS: PMU not supported\n");
+static int exynos_pmu_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pmu_base_addr = devm_ioremap_resource(dev, res);
+	if (IS_ERR(pmu_base_addr))
+		return PTR_ERR(pmu_base_addr);
+
+	pmu_context = devm_kzalloc(&pdev->dev,
+			sizeof(struct exynos_pmu_context),
+			GFP_KERNEL);
+	if (!pmu_context) {
+		dev_err(dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
 	}
+	pmu_context->dev = dev;
+
+	match = of_match_node(exynos_pmu_of_device_ids, dev->of_node);
+
+	pmu_context->pmu_data = match->data;
 
+	if (pmu_context->pmu_data->pmu_init)
+		pmu_context->pmu_data->pmu_init();
+
+	platform_set_drvdata(pdev, pmu_context);
+
+	dev_dbg(dev, "Exynos PMU Driver probe done\n");
 	return 0;
 }
-arch_initcall(exynos_pmu_init);
+
+static struct platform_driver exynos_pmu_driver = {
+	.driver  = {
+		.name   = "exynos-pmu",
+		.owner	= THIS_MODULE,
+		.of_match_table = exynos_pmu_of_device_ids,
+	},
+	.probe = exynos_pmu_probe,
+};
+
+static int __init exynos_pmu_init(void)
+{
+	return platform_driver_register(&exynos_pmu_driver);
+
+}
+postcore_initcall(exynos_pmu_init);
-- 
1.7.9.5

