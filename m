Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaGIEEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:04:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59162 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGIEDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:03:43 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-d5-53bcbf1c0787
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for Exynos PMU
Date: Wed, 09 Jul 2014 09:30:54 +0530
Message-id: <1404878455-31518-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSpSu7f0+wwYI/jBbLJt1ls/i+6wu7
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rX4dPQ/q8WirUAV62e8ZrHoWMZocfPZdiYHHo+W
	5h42j81L6j36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY9G1wIJHdhWv3nxhbGDcZNLFyMkh
	IWAiMefNehYIW0ziwr31bF2MXBxCAksZJY4sn8oEU9Ty4ihUYhGjROuKKUwQzgQmiUenW8Gq
	2AR0JZ68n8sMYosIZEv0317NAlLELPCYUeLNyqOMXYwcHMIC/hLfLsmB1LAIqEp8/32RHcTm
	FfCQ2PCuhQ2kREJAQWLOJBuQMKeAp0TL9OVsILYQUMmZdRtYQUZKCGxjl9j36wQrxBwBiW+T
	D7FA9MpKbDrADHG0pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRGAen
	/z2buIPx/gHrQ4zJQOMmMkuJJucD4yivJN7Q2MzIwtTE1NjI3NKMNGElcd70R0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhjLzicueqyWatDx2uGcecRaq+d/mwoX8R+5vMJCIkNFWHbl
	Ua+2xQtrpr75c0Z+lXfhgkXzJSYU68+KLmL6uahx4+MI0107NglN2Wl58v3K72f6BT9zZK8+
	4W3nH7D27akdNy/WznM+PUVub47R9r8bmJaYPXcO5ZrfuHXHkpc363dJMT3+xx89R4mlOCPR
	UIu5qDgRAOeQ9IyZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t9jAV2Z/XuCDQ6tNbVYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYtFxzJGi5vPtjM58Hi0
	NPeweWxeUu/Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QIcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlr
	GDMWXQsseGRX8erNF8YGxk0mXYycHBICJhItL46yQdhiEhfurQeyuTiEBBYxSrSumMIE4Uxg
	knh0upUJpIpNQFfiyfu5zCC2iEC2RP/t1SwgRcwCjxkl3qw8ytjFyMEhLOAv8e2SHEgNi4Cq
	xPffF9lBbF4BD4kN71rYQEokBBQk5kyyAQlzCnhKtExfDnaEEFDJmXUbWCcw8i5gZFjFKJpa
	kFxQnJSea6RXnJhbXJqXrpecn7uJERxlz6R3MK5qsDjEKMDBqMTDq8CzJ1iINbGsuDL3EKME
	B7OSCO83N6AQb0piZVVqUX58UWlOavEhRlOgoyYyS4km5wMTQF5JvKGxibmpsamliYWJmaWS
	OO/BVutAIYH0xJLU7NTUgtQimD4mDk6pBkavgh8LtO42ij8u/zW3myt+wQYxi+7nPIwPa/f0
	ck86Pk09P/Nj3h3pA8c3awZIz+QrlrdkT79/71TZxP2+rh/Ce9+Yy527f9rFVaAo+AeX4SuJ
	2Os1/T5qnt85Ws20Zrb2XHx3SrM4ruiLUb7u3n8WcgL2dw88FLd/1T9pybItP9p91qzLrlRi
	Kc5INNRiLipOBAAY8HwlyAIAAA==
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
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/Kconfig |    1 +
 arch/arm/mach-exynos/pmu.c   |  185 +++++++++++++++++++++++++++++++++---------
 2 files changed, 146 insertions(+), 40 deletions(-)

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
index ff9d23f..5b76728 100644
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
 
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
@@ -335,7 +351,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
 	EXYNOS5_ISP_ARM_OPTION,
 };
 
-static void exynos5_init_pmu(void)
+static void exynos5_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
 	unsigned int tmp;
@@ -372,51 +388,140 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
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
+
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
+	}
+	pmu_context->dev = dev;
+
+	regmap = devm_regmap_init_mmio(dev, pmu_base_addr,
+					&pmu_regmap_config);
+	if (IS_ERR(regmap)) {
+		dev_err(dev, "regmap init failed\n");
+		return PTR_ERR(regmap);
 	}
 
+	devm_syscon_register(dev, regmap);
+
+	match = of_match_node(exynos_pmu_of_device_ids, pdev->dev.of_node);
+
+	pmu_context->pmu_data = match->data;
+
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

