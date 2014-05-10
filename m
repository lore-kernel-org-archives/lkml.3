Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaEJGjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:39:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33873 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaEJGir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:47 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-06-536dc964f041
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 10/11] ARM: EXYNOS: Add platform driver support for Exynos
 PMU.
Date: Sat, 10 May 2014 15:56:37 +0900
Message-id: <1399704998-13321-11-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t8zI92Uk7nBBjfWGVgsm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgyth56ytbwcTIih1z77I3MC726mLk5JAQMJHYdr6D
	GcIWk7hwbz1bFyMXh5DAMkaJ85PPssAUnfl/jAkiMZ1Rom9zBzuE08Yk8f3wX7B2NgFdiSfv
	54LZIgLZElca7zODFDEL7GaUaGycxwaSEBYIkVjX8IoVxGYRUJVYtLQfLM4r4Cmxc/90xi5G
	DqB1ChJzJtmAhDmBwl+/LmYCsYUEPCQedC8FmykhsIpdYt3y+4wQcwQkvk0+xALRKyux6QDU
	O5ISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkjg9+5gvH3A+hBjMtC4
	icxSosn5wMjJK4k3NDYzsjA1MTU2Mrc0I01YSZw36WFSkJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGdevDtpvZXX8vdfhBUUJa3kVzC77P9TJGhmLpZ1LvtbR/Pbd9U9DGpjY+7tq75vo2
	FbXBPZXrL/omvwn01r1177pRynE+72tuAnK/J/UEcnoVK17uLz13dvs8bT6Ljd+yO/42Rm7p
	yxA99HXdlfqtjGuzLN/tbhfWK7XiOP/ob2On95+rJdZKLMUZiYZazEXFiQCRmdPVkgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd2Uk7nBBqf7tSyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zYeesrW8HE
	yIodc++yNzAu9upi5OSQEDCROPP/GBOELSZx4d56ti5GLg4hgemMEn2bO9ghnDYmie+H/zKD
	VLEJ6Eo8eT8XzBYRyJa40nifGaSIWWA3o0Rj4zw2kISwQIjEuoZXrCA2i4CqxKKl/WBxXgFP
	iZ37pzN2MXIArVOQmDPJBiTMCRT++nUx2BVCAh4SD7qXMk9g5F3AyLCKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIziunknvYFzVYHGIUYCDUYmHt/BtTrAQa2JZcWXuIUYJDmYlEd4VB3OD
	hXhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfGPN5JfGGxiZmRpZGZhZGJubmpAkrifMebLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cAYNKWFbYHqB0kTyW/1XUric4q137OdN5K2ti5NfGZj+cvc
	wq4oV2z5+SXtYt1WGxy95hffc0k9OEVyfeyp8pqz5RdWT7hQmbeE8XL/LW+T+2uFTlfd/iVa
	l3Q8uPOYmaVfrlZ5U1bwx2Q5i8wT59ek/9BN2mu1jUvYxHXbs1inz5UW/tEOEkosxRmJhlrM
	RcWJADHrZO/vAgAA
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
- It also removes uses of soc_is_exynosXYZ() thus making PMU implementation
  independent of "plat/cpu.h".

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
---
 arch/arm/mach-exynos/pmu.c |  266 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 210 insertions(+), 56 deletions(-)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 67116a5..6a7fa8e 100644
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
@@ -348,81 +361,222 @@ static void exynos5_init_pmu(void)
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
+
+	if (pmu_data->powerdown_conf)
+		pmu_data->powerdown_conf(mode);
+
+	if (pmu_data->pmu_config) {
+		for (i = 0; (pmu_data->pmu_config[i].offset != PMU_TABLE_END) ; i++)
+			regmap_write(pmu_context->pmu_regmap,
+					pmu_data->pmu_config[i].offset,
+					pmu_data->pmu_config[i].val[mode]);
+	}
+
+	if (pmu_data->pmu_config_extra) {
+		for (i = 0; pmu_data->pmu_config_extra[i].offset != PMU_TABLE_END; i++)
+			regmap_write(pmu_context->pmu_regmap,
+					pmu_data->pmu_config_extra[i].offset,
+					pmu_data->pmu_config_extra[i].val[mode]);
+	}
+}
+
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
+static int exynos_pmu_probe(struct platform_device *pdev)
+{
+	struct device_node *np;
+	const struct of_device_id *match;
+	struct device *dev = &pdev->dev;
 
-	if (soc_is_exynos5250())
-		exynos5_init_pmu();
+	pmu_context = devm_kzalloc(&pdev->dev,
+			sizeof(struct exynos_pmu_context),
+			GFP_KERNEL);
+	if (pmu_context == NULL) {
+		dev_err(dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	np = of_find_matching_node_and_match(NULL,
+			exynos_pmu_of_device_ids, &match);
+	if (!np) {
+		pr_warn("%s, failed to find PMU node\n", __func__);
+		return -ENODEV;
+	}
 
-	for (i = 0; (exynos_pmu_config[i].offset != PMU_TABLE_END) ; i++)
-		regmap_write(pmu_regmap, exynos_pmu_config[i].offset,
-				exynos_pmu_config[i].val[mode]);
+	pmu_context->pmu_data = (struct exynos_pmu_data *) match->data;
+	pmu_context->pmu_regmap = syscon_regmap_lookup_by_phandle(np, NULL);
 
-	if (soc_is_exynos4412()) {
-		for (i = 0; exynos4412_pmu_config[i].offset != PMU_TABLE_END; i++)
-			regmap_write(pmu_regmap, exynos4412_pmu_config[i].offset,
-					exynos4412_pmu_config[i].val[mode]);
+	if (IS_ERR(pmu_context->pmu_regmap)) {
+		pr_err("failed to find exynos_pmu_regmap\n");
+		return PTR_ERR(pmu_context->pmu_regmap);
 	}
+
+	if (pmu_context->pmu_data->pmu_init)
+		pmu_context->pmu_data->pmu_init();
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
+	return 0;
+}
+
+static int exynos_pmu_resume(struct device *dev)
+{
+	/* ToDo: */
+	return 0;
 }
 
-static int __init exynos_pmu_init(void)
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
 	}
 
 	return 0;
+out1:
+	platform_driver_unregister(&exynos_pmu_driver);
+out:
+	return ret;
 }
-arch_initcall(exynos_pmu_init);
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

