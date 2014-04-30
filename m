Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaD3FBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:01:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38443 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaD3E7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:47 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-f6-5360834147c8
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 11/12] ARM: EXYNOS: Add platform driver support for Exynos
 PMU.
Date: Wed, 30 Apr 2014 14:17:36 +0900
Message-id: <1398835057-3860-12-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t8zI13H5oRgg9/3lSyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZez4cZmxYHJ0xYv5dQ2M7727GDk5JARMJPqf3mSG
	sMUkLtxbz9bFyMUhJLCMUeL+069MMEU7b+1ihEgsYpR48PoXM4TTxiTRv3AmI0gVm4CuxJP3
	c8FGiQhkS1xpvA9WxCywm1GisXEe0FwODmGBEIl1rSUgNSwCqhKNy/+xgdi8Ah4Sf3ZdYQUp
	kRBQkJgzyQYkzAkUXnj7NyuILSTgLtHQ0MMIcdAqdok/p/UgxghIfJt8iAWiVVZi0wGoZyQl
	Dq64wTKBUXgBI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJCQ79vBePOA9SHGZKBxE5ml
	RJPzgTGTVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoY18rr+JXlnu+TW27so/Towj6Ga1Plz1vYBRmH2n7IsuPdai18KZh7VpWE47XQb0JMTOeb
	mB77pz1+tYmhtyD150Gl/Af7Jr38uNVYNFpHt18kPkjp0KV9Of/nL07e2rD2fj/7c9XbTcvv
	PHvaMEtv4j8hne0SJr+n3li1VrdVq+B9Vsu9qD2rlViKMxINtZiLihMB4DA2eY8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAV3H5oRgg/mvZCyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zY8eMyY8Hk
	6IoX8+saGN97dzFyckgImEjsvLWLEcIWk7hwbz1bFyMXh5DAIkaJB69/MUM4bUwS/QtnglWx
	CehKPHk/lxnEFhHIlrjSeB+siFlgN6NEY+M8oHYODmGBEIl1rSUgNSwCqhKNy/+xgdi8Ah4S
	f3ZdYQUpkRBQkJgzyQYkzAkUXnj7NyuILSTgLtHQ0MM4gZF3ASPDKkbR1ILkguKk9FxDveLE
	3OLSvHS95PzcTYzgmHomtYNxZYPFIUYBDkYlHl6BrfHBQqyJZcWVuYcYJTiYlUR4z1cmBAvx
	piRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjDe80riDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBUak4P2H7hKnuMW9cZkke3JWp05FodmVBRGBid7jm5q8LN326
	f1Dkwn4j7usRb9fnSck+VF1arM7aK1K1v7XI8fUhps+GvW1r17oUzT7E3JO9pstG0XnD/7rW
	GTM59zdvkE/U3ZJkoH1TZEXvRum0kJcTTn4xLvyp+G86J5fb3ty7c/cJlkxvVWIpzkg01GIu
	Kk4EAK8syEDtAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies Exynos Power Management Unit (PMU) initialization
implementation in following way:

- Added platform_device support by registering static platform device.
- Added platform struct exynos_pmu_data to hold platform specific data.
- For each SoC's PMU support now we can add platform data and statically
  bind PMU configuration and SoC specific initialization function.
- Probe function will scan DT and based on matching PMU compatibility
  string initialize pmu_context which will be platform_data for driver.
- Obtain PMU regmap handle using "syscon_regmap_lookup_by_phandle" so
  that we can reduce dependency over machine header files.
- Separate each SoC's PMU initialization function and make it as part of
  platform data.
- It also removes uses of soc_is_exynosXXXX() thus making PMU implementation
  independent of "plat/cpu.h".

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
---
 arch/arm/mach-exynos/pmu.c |  280 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 224 insertions(+), 56 deletions(-)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 67116a5..030df96 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
  *
  * EXYNOS - CPU PMU(Power Management Unit) support
@@ -9,20 +9,33 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/io.h>
-#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/regmap.h>
-
-#include <plat/cpu.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/mfd/syscon.h>
 
 #include "common.h"
 #include "regs-pmu.h"
 
-static const struct exynos_pmu_conf *exynos_pmu_config;
-static struct regmap *pmu_regmap;
+struct exynos_pmu_data {
+	const struct exynos_pmu_conf *pmu_config;
+	const struct exynos_pmu_conf *pmu_config_extra;
+	void (*pmu_init)(void);
+	void (*powerdown_conf)(enum sys_powerdown);
+};
+
+struct exynos_pmu_context {
+	struct device *dev;
+	struct exynos_pmu_data *pmu_data;
+	struct regmap	*pmu_regmap;
+};
+
+static struct exynos_pmu_context	*pmu_context;
 
 static const struct exynos_pmu_conf exynos4210_pmu_config[] = {
-	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
+	/* { .offset = address, .val = { AFTR, LPA, SLEEP } */
 	{ S5P_ARM_CORE0_LOWPWR,			{ 0x0, 0x0, 0x2 } },
 	{ S5P_DIS_IRQ_CORE0,			{ 0x0, 0x0, 0x0 } },
 	{ S5P_DIS_IRQ_CENTRAL0,			{ 0x0, 0x0, 0x0 } },
@@ -216,7 +229,7 @@ static const struct exynos_pmu_conf exynos4412_pmu_config[] = {
 };
 
 static const struct exynos_pmu_conf exynos5250_pmu_config[] = {
-	/* { .reg = address, .val = { AFTR, LPA, SLEEP } */
+	/* { .offset = address, .val = { AFTR, LPA, SLEEP } */
 	{ EXYNOS5_ARM_CORE0_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
 	{ EXYNOS5_DIS_IRQ_ARM_CORE0_LOCAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
 	{ EXYNOS5_DIS_IRQ_ARM_CORE0_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
@@ -339,7 +352,7 @@ static unsigned int const exynos5_list_diable_wfi_wfe[] = {
 	EXYNOS5_ISP_ARM_OPTION,
 };
 
-static void exynos5_init_pmu(void)
+void exynos5_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
 	unsigned int tmp;
@@ -348,81 +361,236 @@ static void exynos5_init_pmu(void)
 	 * Enable both SC_FEEDBACK and SC_COUNTER
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_both_cnt_feed) ; i++) {
-		regmap_read(pmu_regmap, exynos5_list_both_cnt_feed[i], &tmp);
+		regmap_read(pmu_context->pmu_regmap,
+				exynos5_list_both_cnt_feed[i], &tmp);
 		tmp |= (EXYNOS5_USE_SC_FEEDBACK |
 			EXYNOS5_USE_SC_COUNTER);
-		regmap_write(pmu_regmap, exynos5_list_both_cnt_feed[i], tmp);
+		regmap_write(pmu_context->pmu_regmap,
+				exynos5_list_both_cnt_feed[i], tmp);
 	}
 
 	/*
 	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
 	 */
-	regmap_read(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
+	regmap_read(pmu_context->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, &tmp);
 	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
-	regmap_write(pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
+	regmap_write(pmu_context->pmu_regmap, EXYNOS5_ARM_COMMON_OPTION, tmp);
 
 	/*
 	 * Disable WFI/WFE on XXX_OPTION
 	 */
 	for (i = 0 ; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe) ; i++) {
-		tmp = regmap_read(pmu_regmap, exynos5_list_diable_wfi_wfe[i],
-				&tmp);
+		tmp = regmap_read(pmu_context->pmu_regmap,
+				exynos5_list_diable_wfi_wfe[i], &tmp);
 		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
 			 EXYNOS5_OPTION_USE_STANDBYWFI);
-		regmap_write(pmu_regmap, exynos5_list_diable_wfi_wfe[i], tmp);
+		regmap_write(pmu_context->pmu_regmap,
+				exynos5_list_diable_wfi_wfe[i], tmp);
 	}
 }
 
 void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 {
 	unsigned int i;
+	struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
 
-	if (soc_is_exynos5250())
-		exynos5_init_pmu();
+	if (pmu_data->powerdown_conf)
+		pmu_data->powerdown_conf(mode);
 
-	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
-		regmap_write(pmu_regmap, exynos_pmu_config[i].offset,
-				exynos_pmu_config[i].val[mode]);
+	if (pmu_data->pmu_config) {
+		for (i = 0; (pmu_data->pmu_config[i].offset != PMU_TABLE_END) ; i++)
+			regmap_write(pmu_context->pmu_regmap,
+					pmu_data->pmu_config[i].offset,
+					pmu_data->pmu_config[i].val[mode]);
+	}
 
-	if (soc_is_exynos4412()) {
-		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END; i++)
-			regmap_write(pmu_regmap, exynos4412_pmu_config[i].offset,
-					exynos4412_pmu_config[i].val[mode]);
+	if (pmu_data->pmu_config_extra) {
+		for (i = 0; pmu_data->pmu_config_extra[i].offset != PMU_TABLE_END; i++)
+			regmap_write(pmu_context->pmu_regmap,
+					pmu_data->pmu_config_extra[i].offset,
+					pmu_data->pmu_config_extra[i].val[mode]);
 	}
 }
 
-static int __init exynos_pmu_init(void)
+static void exynos5250_pmu_init(void)
+{
+	unsigned int tmp;
+	struct regmap *pmu_regmap = pmu_context->pmu_regmap;
+	/*
+	 * When SYS_WDTRESET is set, watchdog timer reset request
+	 * is ignored by power management unit.
+	 */
+	regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, &tmp);
+	tmp &= ~EXYNOS5_SYS_WDTRESET;
+	regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, tmp);
+
+	regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, &tmp);
+	tmp &= ~EXYNOS5_SYS_WDTRESET;
+	regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, tmp);
+}
+
+static struct exynos_pmu_data exynos4210_pmu_data = {
+	.pmu_config	= exynos4210_pmu_config,
+};
+
+static struct exynos_pmu_data exynos4x12_pmu_data = {
+	.pmu_config	= exynos4x12_pmu_config,
+};
+
+static struct exynos_pmu_data exynos4412_pmu_data = {
+	.pmu_config		= exynos4x12_pmu_config,
+	.pmu_config_extra	= exynos4412_pmu_config,
+};
+
+static struct exynos_pmu_data exynos5250_pmu_data = {
+	.pmu_config	= exynos5250_pmu_config,
+	.pmu_init	= exynos5250_pmu_init,
+	.powerdown_conf	= exynos5_powerdown_conf,
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
+		.data = (void *)&exynos4x12_pmu_data,
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
+static int exynos_pmu_data_init(struct device_node *np)
 {
-	unsigned int value;
-
-	exynos_pmu_config = exynos4210_pmu_config;
-	pmu_regmap = get_exynos_pmuregmap();
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
-		regmap_read(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, &value);
-		value &= ~EXYNOS5_SYS_WDTRESET;
-		regmap_write(pmu_regmap, EXYNOS5_AUTO_WDTRESET_DISABLE, value);
-
-		regmap_read(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, &value);
-		value &= ~EXYNOS5_SYS_WDTRESET;
-		regmap_write(pmu_regmap, EXYNOS5_MASK_WDTRESET_REQUEST, value);
-
-		exynos_pmu_config = exynos5250_pmu_config;
-		pr_info("EXYNOS5250 PMU Initialize\n");
-	} else {
-		pr_info("EXYNOS: PMU not supported\n");
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos_pmu_of_device_ids, np);
+	if (!match) {
+		pr_err("fail to get matching of_match struct\n");
+		return -EINVAL;
+	}
+
+	pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;
+	pmu_context->pmu_regmap = syscon_regmap_lookup_by_phandle(np,
+			"samsung,syscon-phandle");
+
+	if (IS_ERR(pmu_context->pmu_regmap)) {
+		pr_err("failed to find exynos_pmu_regmap\n");
+		return PTR_ERR(pmu_context->pmu_regmap);
 	}
 
+	if (pmu_context->pmu_data->pmu_init)
+		pmu_context->pmu_data->pmu_init();
+
+	return 0;
+};
+
+static int exynos_pmu_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct device_node *np;
+	struct device *dev = &pdev->dev;
+
+	pmu_context = devm_kzalloc(&pdev->dev,
+			sizeof(struct exynos_pmu_context),
+			GFP_KERNEL);
+	if (pmu_context == NULL) {
+		dev_err(dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	for_each_matching_node_and_match(np, exynos_pmu_of_device_ids, NULL) {
+		ret = exynos_pmu_data_init(np);
+		if (ret < 0)
+			return ret;
+		break;
+	}
+
+	pmu_context->dev = dev;
+
+	platform_set_drvdata(pdev, pmu_context);
+
+	pr_info("Exynos PMU Driver probe done!!!\n");
+	return 0;
+}
+
+static int exynos_pmu_suspend(struct device *dev)
+{
+	/* ToDo: */
 	return 0;
 }
-arch_initcall(exynos_pmu_init);
+
+static int exynos_pmu_resume(struct device *dev)
+{
+	/* ToDo: */
+	return 0;
+}
+
+static const struct dev_pm_ops exynos_pmu_pm = {
+	.suspend = exynos_pmu_suspend,
+	.resume = exynos_pmu_resume,
+};
+
+static int exynos_pmu_remove(struct platform_device *pdev)
+{
+	/* nothing to do here */
+	return 0;
+}
+
+static struct platform_device *exynos_pmu_pdev;
+
+static struct platform_driver exynos_pmu_driver = {
+	.driver  = {
+		.name   = "exynos-pmu",
+		.owner	= THIS_MODULE,
+		.pm	= &exynos_pmu_pm,
+	},
+	.probe = exynos_pmu_probe,
+	.remove = exynos_pmu_remove,
+};
+
+static int __init exynos_pmu_of_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&exynos_pmu_driver);
+	if (ret < 0)
+		goto out;
+
+	exynos_pmu_pdev = platform_device_register_simple("exynos-pmu", -1,
+			NULL, 0);
+
+	if (IS_ERR(exynos_pmu_pdev)) {
+		ret = PTR_ERR(exynos_pmu_pdev);
+		goto out1;
+	}
+
+	return 0;
+out1:
+	platform_driver_unregister(&exynos_pmu_driver);
+out:
+	return ret;
+}
+arch_initcall(exynos_pmu_of_init);
+
+static void __exit exynos_pmu_exit(void)
+{
+	platform_device_unregister(exynos_pmu_pdev);
+	platform_driver_unregister(&exynos_pmu_driver);
+}
+module_exit(exynos_pmu_exit);
+
+MODULE_AUTHOR("Pankaj Dubey <pankaj.dubey@samsung.com");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("EXYNOS Power Management Unit Driver");
-- 
1.7.10.4

