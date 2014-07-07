Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaGGFWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:22:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31499 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaGGFWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:22:20 -0400
X-AuditID: cbfee690-b7fb56d000003439-41-53ba2e8a3189
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v6 3/4] ARM: EXYNOS: Add platform driver support for Exynos PMU
Date: Mon, 07 Jul 2014 10:49:35 +0530
Message-id: <1404710376-16448-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSrduttyvY4M4OJotlk+6yWXzf9YXd
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81p8Ovqf1WLRVqCK9TNes1h0LGO0uPlsO5MDj0dL
	cw+bx+Yl9R59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVMX/Rf7aC9XYVW5tbmBoYW026GDk5
	JARMJPo/7GeCsMUkLtxbz9bFyMUhJLCUUaJh+xFWmKK3zf3MEIlFjBLbX91jhHAmMElsvD0F
	rJ1NQFfiyfu5zCC2iEC2RP/t1SwgRcwCjxkl3qw8ygiSEBbwl3jTegVsLIuAqsTaTZfZQGxe
	AQ+JKd+/AcU5gNYpSMyZZAMS5hTwlJj8ej9YiRBQydulf6BO3cYucWejCMQYAYlvkw+xQLTK
	Smw6wAxRIilxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBEbC6X/PJuxg
	vHfA+hBjMtC4icxSosn5wEjKK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQZG3wN16lvKKk7733ngf0i7cEvkE3PZU50fK9y4CtwueEnv1PKuvbJQ
	ue4Fs+fBHvXMgJsN/F1Jjat3dK/se2vuX2d2/6HY/UjH06mPVMvvPv4q8CT2QWeVwBN+r75n
	ydZtB/XPWm9TMXOuzzjO8fNHgsuMxdcKA1fr3z56mz3QfUGA9EwV6zolluKMREMt5qLiRAA0
	pR44mgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAd0uvV3BBrPXmFosm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBaLtgJVrJ/xmsWiYxmjxc1n25kceDxa
	mnvYPDYvqffo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoMOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1
	jBnzF/1nK1hvV7G1uYWpgbHVpIuRk0NCwETibXM/M4QtJnHh3nq2LkYuDiGBRYwS21/dY4Rw
	JjBJbLw9hQmkik1AV+LJ+7lgHSIC2RL9t1ezgBQxCzxmlHiz8igjSEJYwF/iTesVVhCbRUBV
	Yu2my2wgNq+Ah8SU79+A4hxA6xQk5kyyAQlzCnhKTH69H6xECKjk7dI/TBMYeRcwMqxiFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECI60Z1I7GFc2WBxiFOBgVOLhPbBqZ7AQa2JZcWXuIUYJ
	DmYlEd4zbkAh3pTEyqrUovz4otKc1OJDjKZAR01klhJNzgcmgbySeENjE3NTY1NLEwsTM0sl
	cd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYxHH/FUzv6z5KvHz7rFml3il58I7zpVba3jGXht
	u+5CZ38T/qULIrgvN/j0y8u/W9S3LIQ3RCh6r7DewzSVpTdPs5+VtL8v8sr467d8i/8iUXvf
	btprc9xlo7jAlV7O68GzK48xG5opRbXuCC1S9v5/sD3GOLWa9VYJQ/FFX52bj5Qk9RoYXyqx
	FGckGmoxFxUnAgCo38RdygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies Exynos Power Management Unit (PMU) initialization
implementation in following way:

- Added platform driver support and probe function where Exynos PMU
  driver will register itself as syscon provider with syscon framework.
- Added platform struct exynos_pmu_data to hold platform specific data.
- For each SoC's PMU support now we can add platform data and statically
  bind PMU configuration and SoC specific initialization function.
- Separate each SoC's PMU initialization function and make it as part of
  platform data.
- It also removes uses of soc_is_exynosXYZ().

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/Kconfig |    1 +
 arch/arm/mach-exynos/pmu.c   |  188 +++++++++++++++++++++++++++++++++---------
 2 files changed, 149 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 8f9b66c..a2944ac 100644
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
index 4a04d55..2b16a2d 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
  *
  * EXYNOS - CPU PMU(Power Management Unit) support
@@ -10,12 +10,28 @@
  */
 
 #include <linux/io.h>
-#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
 
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
 
 static inline void pmu_raw_writel(u32 val, u32 offset)
 {
@@ -345,7 +361,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
 	EXYNOS5_ISP_ARM_OPTION,
 };
 
-static void exynos5_init_pmu(void)
+static void exynos5_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
 	unsigned int tmp;
@@ -382,51 +398,143 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
 
-	if (soc_is_exynos5250())
-		exynos5_init_pmu();
+	const struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
+
+	if (!pmu_data)
+		return;
 
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
+		for (i = 0; (pmu_data->pmu_config[i].offset != PMU_TABLE_END) ; i++)
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
+static const struct regmap_config pmu_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
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
+	struct regmap *regmap;
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
+	regmap = devm_regmap_init_mmio(dev, pmu_base_addr,
+					&pmu_regmap_config);
+	if (IS_ERR(regmap)) {
+		dev_err(dev, "regmap init failed\n");
+		return PTR_ERR(regmap);
+	}
+
+	devm_syscon_register(dev, regmap);
 
+	match = of_match_node(exynos_pmu_of_device_ids, pdev->dev.of_node);
+
+	pmu_context->pmu_data = match->data;
+
+	if (pmu_context->pmu_data && pmu_context->pmu_data->pmu_init)
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

