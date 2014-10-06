Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaJFJcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:32:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13221 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaJFJbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:31:55 -0400
X-AuditID: cbfee68e-f79b46d000002b74-41-543261875df7
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v9 1/2] ARM: EXYNOS: Add platform driver support for Exynos PMU
Date: Mon, 06 Oct 2014 14:56:41 +0530
Message-id: <1412587602-7763-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412587602-7763-1-git-send-email-pankaj.dubey@samsung.com>
References: <1412587602-7763-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkVrc90SjE4MpDHYveBVfZLDY9vsZq
	cXnXHDaLGef3MVncvsxr8enof1aLRVu/sFt0LGO0WLXrD6PFzWfbmRy4PFqae9g8ds66y+6x
	eUm9R9+WVYwenzfJBbBGcdmkpOZklqUW6dslcGXMfNfAVrDfoWLlstVsDYz3TLsYOTkkBEwk
	bt2Yzwhhi0lcuLeerYuRi0NIYCmjxPcNf5hhiprmv2OFSCxilDhwq4ERwpnAJHF7x3+wKjYB
	XYkn7+eC2SIC2RI/vk1mAbGZBXYzSrz9LAZiCwv4S9yYPZ29i5GDg0VAVWL9iWKQMK+Au0Rj
	fysLSFhCQEFiziQbkDCngIfEi7eHmEBsIaCS/Wtnga2VEFjHLnHu9nlWkASLgIDEt8mHoHpl
	JTYdgLpZUuLgihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIDP7T/5717WC8
	ecD6EKMAB6MSD2/EDsMQIdbEsuLK3EOMpkAbJjJLiSbnA2MsryTe0NjMyMLUxNTYyNzSTEmc
	N0HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxuDfuxpnbTyyYeax33vzFLZye4VY922N
	VTZ6v2f6qfWlIT+2uGnue3/nUTBPlJqo5ymjrdJxibmTv59fpNZ46srl4//sevhE5PjqPJeL
	n2hxfrxgs8ufm2YscaftamIT4xtVDqVN+ZqzS11/CSdTEO/XkxsvLGe5x/f6cpfcjaMh8W8Y
	Vpx61afEUpyRaKjFXFScCADAIaJ3eQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAd32RKMQg9UzlCx6F1xls9j0+Bqr
	xeVdc9gsZpzfx2Rx+zKvxaej/1ktFm39wm7RsYzRYtWuP4wWN59tZ3Lg8mhp7mHz2DnrLrvH
	5iX1Hn1bVjF6fN4kF8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeY
	m2qr5OIToOuWmQN0k5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY+a7
	BraC/Q4VK5etZmtgvGfaxcjJISFgItE0/x0rhC0mceHeerYuRi4OIYFFjBIHbjUwQjgTmCRu
	7/jPDFLFJqAr8eT9XDBbRCBb4se3ySwgNrPAbkaJt5/FQGxhAX+JG7Ons3cxcnCwCKhKrD9R
	DBLmFXCXaOxvZQEJSwgoSMyZZAMS5hTwkHjx9hATiC0EVLJ/7SzGCYy8CxgZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEx9Yz6R2MqxosDjEKcDAq8fBG7DAMEWJNLCuuzD3EKMHBrCTC
	mx5vFCLEm5JYWZValB9fVJqTWnyI0RToponMUqLJ+cC4zyuJNzQ2MTc1NrU0sTAxs1QS5z3Y
	ah0oJJCeWJKanZpakFoE08fEwSnVwGh92UCzbsUuV/lF1hKX9111SUjWnPkwZcvKi9wlqZWL
	+qUSPVTNwpmeO9j4l6YzSbCJiRbnikWZhk3pr3r46Z6bWELxobI9N3Pe/LFdOz2qY5vOodnf
	Ar/lcXy5Xp4/aWtly2nl3lU7eSPk/eY//Om6aLFAAmfz0V8FWbt3eUhx318UxDPnthJLcUai
	oRZzUXEiAMpN1LvDAgAA
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

