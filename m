Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaFYOIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:08:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54289 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbaFYOIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:08:07 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-16-53aad7c45a55
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 4/5] ARM: EXYNOS: Add platform driver support for Exynos PMU
Date: Wed, 25 Jun 2014 19:33:51 +0530
Message-id: <1403705032-14835-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSp3vk+qpgg71HrCyWTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/VotFW4Eq1s94zWLRsYzR4uaz7UwOPB4t
	zT1sHpuX1Hv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxrxfb9kKXrtUdOx+ydLAuMyyi5GT
	Q0LAROLgpnVMELaYxIV769m6GDk4hASWMkqsE4IpubzgJWMXIxdQeDqjxIvdH9ghnAlMEpd/
	trCAVLEJ6Eo8eT+XGcQWEciW6L+9mgWkiFngMaPEm5VHGUESwgL+EptmTQVrYBFQlVg68QtY
	nFfAQ+LWxglMIJslBBQk5kyyAQlzCnhKfJr5nR3EFgIq+TpzPzPITAmBXewSu05sYIKYIyDx
	bfIhFoheWYlNB5ghrpaUOLjiBssERuEFjAyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MQLj
	4PS/Z707GG8fsD7EmAw0biKzlGhyPjCO8kriDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBcc3WXsXmJ5v2btyhtyXDmyPnZu/JS7Zfvnoaq94p7EuN
	uXYw+06sBTcr76cVs/iMyqwCV7jqPXBukr9j7/Rlkf2XnVaXvhbI/jA6aX9tZRSn+9cjDVff
	vxXUKW7lO+EbsWjCz8e6K7dFNEtzsHB9zulXfOPucblaolg3uzewJ2hZrs6/ja+FlViKMxIN
	tZiLihMB9CMzSpkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd0j11cFGzT+0LdYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYtFxzJGi5vPtjM58Hi0
	NPeweWxeUu/Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QIcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlr
	GDPm/XrLVvDapaJj90uWBsZlll2MnBwSAiYSlxe8ZISwxSQu3FvP1sXIxSEkMJ1R4sXuD+wQ
	zgQmics/W1hAqtgEdCWevJ/LDGKLCGRL9N9ezQJSxCzwmFHizcqjYKOEBfwlNs2aCtbAIqAq
	sXTiF7A4r4CHxK2NE5i6GDmA1ilIzJlkAxLmFPCU+DTzOzuILQRU8nXmfuYJjLwLGBlWMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgRH2jOpHYwrGywOMQpwMCrx8F6YvTJYiDWxrLgy9xCj
	BAezkgiv+/5VwUK8KYmVValF+fFFpTmpxYcYTYGOmsgsJZqcD0wCeSXxhsYm5qbGppYmFiZm
	lkrivAdarQOFBNITS1KzU1MLUotg+pg4OKUaGK1seP3fsn6sOt6jMPu27OXC4JQOl5VlRx9t
	KDt8RWZS+FOPv23H9jas9L9Q9dq0val794Wcx7Pbk05vWLLpZPW6H8s2VCXppxbtvHTg2ZML
	rz9w/2qYekfM3sPJy3HG5SqTBzeXMyeEOK7W+LFzkn6PIMP61FMrH+w6x7PoqX3FOU6mVzYf
	1qxQYinOSDTUYi4qTgQAvu1tRMoCAAA=
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
 arch/arm/mach-exynos/pmu.c   |  201 +++++++++++++++++++++++++++++++++---------
 2 files changed, 161 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index d58995c9..c4320e6 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -25,6 +25,7 @@ config ARCH_EXYNOS
 	select PM_GENERIC_DOMAINS if PM_RUNTIME
 	select S5P_DEV_MFC
 	select SRAM
+	select MFD_SYSCON
 	help
 	  Support for SAMSUNG EXYNOS SoCs (EXYNOS4/5)
 
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index a6f034c..c80a648 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
  *
  * EXYNOS - CPU PMU(Power Management Unit) support
@@ -9,13 +9,32 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <linux/io.h>
-#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
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
+	struct exynos_pmu_data *pmu_data;
+};
+
+static void __iomem *pmu_base_addr;
+static struct exynos_pmu_context *pmu_context;
 
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	/* { .offset = offset, .val = { AFTR, LPA, SLEEP } */
@@ -93,7 +112,7 @@ static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
 	{ PMU_TABLE_END,},
 };
 
-static const struct exynos_pmu_conf exynos4x12_pmu_config[] = {
+static const struct exynos_pmu_conf exynos4212_pmu_config[] = {
 	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
 	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
 	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
@@ -335,7 +354,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
 	EXYNOS5_ISP_ARM_OPTION,
 };
 
-static void exynos5_init_pmu(void)
+static void exynos5_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
 	unsigned int tmp;
@@ -372,51 +391,151 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
 
-	if (soc_is_exynos5250())
-		exynos5_init_pmu();
+	struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
+
+	if (!pmu_data)
+		return;
 
-	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
-		__raw_writel(exynos_pmu_config[i].val[mode],
-				pmu_base_addr + exynos_pmu_config[i].offset);
+	if (pmu_data->powerdown_conf)
+		pmu_data->powerdown_conf(mode);
 
-	if (soc_is_exynos4412()) {
-		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END ; i++)
-			__raw_writel(exynos4412_pmu_config[i].val[mode],
-				pmu_base_addr + exynos4412_pmu_config[i].offset);
+	if (pmu_data->pmu_config) {
+		for (i = 0; (pmu_data->pmu_config[i].offset != PMU_TABLE_END) ; i++)
+			__raw_writel(pmu_data->pmu_config[i].val[mode],
+					pmu_base_addr + pmu_data->pmu_config[i].offset);
+	}
+
+	if (pmu_data->pmu_config_extra) {
+		for (i = 0; pmu_data->pmu_config_extra[i].offset != PMU_TABLE_END; i++)
+			__raw_writel(pmu_data->pmu_config_extra[i].val[mode],
+					pmu_base_addr + pmu_data->pmu_config_extra[i].offset);
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
+	value = __raw_readl(pmu_base_addr + EXYNOS5_AUTO_WDTRESET_DISABLE);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	__raw_writel(value, pmu_base_addr + EXYNOS5_AUTO_WDTRESET_DISABLE);
+
+	value = __raw_readl(pmu_base_addr + EXYNOS5_MASK_WDTRESET_REQUEST);
+	value &= ~EXYNOS5_SYS_WDTRESET;
+	__raw_writel(value, pmu_base_addr + EXYNOS5_MASK_WDTRESET_REQUEST);
+}
+
+static struct exynos_pmu_data exynos4210_pmu_data = {
+	.pmu_config	= exynos4210_pmu_config,
+};
+
+static struct exynos_pmu_data exynos4212_pmu_data = {
+	.pmu_config	= exynos4212_pmu_config,
+};
+
+static struct exynos_pmu_data exynos4412_pmu_data = {
+	.pmu_config		= exynos4212_pmu_config,
+	.pmu_config_extra	= exynos4412_pmu_config,
+};
+
+static struct exynos_pmu_data exynos5250_pmu_data = {
+	.pmu_config	= exynos5250_pmu_config,
+	.pmu_init	= exynos5250_pmu_init,
+	.powerdown_conf	= exynos5_powerdown_conf,
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
-		value = __raw_readl(pmu_base_addr + EXYNOS5_AUTO_WDTRESET_DISABLE);
-		value &= ~EXYNOS5_SYS_WDTRESET;
-		__raw_writel(value, pmu_base_addr + EXYNOS5_AUTO_WDTRESET_DISABLE);
-
-		value = __raw_readl(pmu_base_addr + EXYNOS5_MASK_WDTRESET_REQUEST);
-		value &= ~EXYNOS5_SYS_WDTRESET;
-		__raw_writel(value, pmu_base_addr + EXYNOS5_MASK_WDTRESET_REQUEST);
-
-		exynos_pmu_config = exynos5250_pmu_config;
-		pr_info("EXYNOS5250 PMU Initialize\n");
-	} else {
-		pr_info("EXYNOS: PMU not supported\n");
+static struct regmap_config pmu_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
+/*
+ * PMU platform driver and devicetree bindings.
+ */
+static struct of_device_id exynos_pmu_of_device_ids[] = {
+	{
+		.compatible = "samsung,exynos4210-pmu",
+		.data = (void *)&exynos4210_pmu_data,
+	},
+	{
+		.compatible = "samsung,exynos4212-pmu",
+		.data = (void *)&exynos4212_pmu_data,
+	},
+	{
+		.compatible = "samsung,exynos4412-pmu",
+		.data = (void *)&exynos4412_pmu_data,
+	},
+	{
+		.compatible = "samsung,exynos5250-pmu",
+		.data = (void *)&exynos5250_pmu_data,
+	},
+	{},
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
+	if (!res)
+		return -ENOENT;
+
+	pmu_base_addr = devm_ioremap(dev, res->start, resource_size(res));
+	if (IS_ERR(pmu_base_addr))
+		return PTR_ERR(pmu_base_addr);
+
+	pmu_context = devm_kzalloc(&pdev->dev,
+			sizeof(struct exynos_pmu_context),
+			GFP_KERNEL);
+
+	if (pmu_context == NULL) {
+		dev_err(dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
+	}
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
+	pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;
+
+	if (pmu_context->pmu_data && pmu_context->pmu_data->pmu_init)
+		pmu_context->pmu_data->pmu_init();
+
+	pmu_context->dev = dev;
+
+	platform_set_drvdata(pdev, pmu_context);
+
+	pr_info("Exynos PMU Driver probe done!!!\n");
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

