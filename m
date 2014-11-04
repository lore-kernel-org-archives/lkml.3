Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaKDIuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:50:14 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35376 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaKDIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:50:04 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-b5-54589339245d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 5/6] regulator: max77686: Remove support for board files
Date: Tue, 04 Nov 2014 09:49:45 +0100
Message-id: <1415090986-30623-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4NV3LyREhBrN2MFpsnLGe1WLqwyds
	Fkd/F1i8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxdojd9ktTnezOnB5/H1+ncVj56y77B6b
	VnWyedy5tofNY97JQI++LasYPT5vkgtgj+KySUnNySxLLdK3S+DK6J71kbVgvlHFpHPtjA2M
	yzS6GDk5JARMJJYfv8gGYYtJXLi3HswWEljKKPHysE8XIxeQ3cckcWfxZBaQBJuAscTm5UvY
	QBIiApsYJSb1X2EFSTALNDNJnH6fA2ILC3hIrFi+gRHEZhFQlTg49T07iM0r4C7x/cFeFoht
	chInj00G6uXg4ASqv9/NDLHYXaJp/SKWCYy8CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefn
	bmKEhN/XHYxLj1kdYhTgYFTi4V0RHxEixJpYVlyZe4hRgoNZSYR3dRVQiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA6Np79Hl9w7W7WV/rtdWy9XwhFFEtMKz5WiS6FN9e4mHfKs4O/x3r8mw9pa9
	bXzt/957k13iZjb8EWg1k1TbYlUp+mNe0E7BGVEzok7GrmHy461rLZUViboqKZXC+IFV4c8m
	+/XqjTVfE2NuJ5w+KeJx8sNX952TVwYGe3DOP3SPe9l8l31cz5RYijMSDbWYi4oTAevbxVUd	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
Simplify the driver and remove dead (unused) entries in platform_data
structure.

Convert the driver to DTS-only version. Parse all regulators at once,
not one-by-one. Remove dependency on data provided by max77686 MFD
driver. Use new DT style parsing method for regulators init data.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 91 +++++++++-----------------------------------
 1 file changed, 19 insertions(+), 72 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 28f4eab82a09..871b96bcd2d0 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -281,6 +281,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 
 #define regulator_desc_ldo(num)		{				\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
+	.regulators_node	= of_match_ptr("voltage-regulators"),	\
 	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -297,6 +299,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_lpm_ldo(num)	{				\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
+	.regulators_node	= of_match_ptr("voltage-regulators"),	\
 	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ldo_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -313,6 +317,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_ldo_low(num)		{			\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
+	.regulators_node	= of_match_ptr("voltage-regulators"),	\
 	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ldo_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -329,6 +335,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_ldo1_low(num)		{			\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
+	.regulators_node	= of_match_ptr("voltage-regulators"),	\
 	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -345,6 +353,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_buck(num)		{			\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
+	.regulators_node	= of_match_ptr("voltage-regulators"),	\
 	.id		= MAX77686_BUCK##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -360,6 +370,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_buck1(num)		{			\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
+	.regulators_node	= of_match_ptr("voltage-regulators"),	\
 	.id		= MAX77686_BUCK##num,				\
 	.ops		= &max77686_buck1_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -375,6 +387,8 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_buck_dvs(num)		{			\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
+	.regulators_node	= of_match_ptr("voltage-regulators"),	\
 	.id		= MAX77686_BUCK##num,				\
 	.ops		= &max77686_buck_dvs_ops,			\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -428,86 +442,21 @@ static const struct regulator_desc regulators[] = {
 	regulator_desc_buck(9),
 };
 
-#ifdef CONFIG_OF
-static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct device_node *pmic_np, *regulators_np;
-	struct max77686_regulator_data *rdata;
-	struct of_regulator_match rmatch;
-	unsigned int i;
-
-	pmic_np = iodev->dev->of_node;
-	regulators_np = of_get_child_by_name(pmic_np, "voltage-regulators");
-	if (!regulators_np) {
-		dev_err(&pdev->dev, "could not find regulators sub-node\n");
-		return -EINVAL;
-	}
-
-	pdata->num_regulators = ARRAY_SIZE(regulators);
-	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
-			     pdata->num_regulators, GFP_KERNEL);
-	if (!rdata) {
-		of_node_put(regulators_np);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < pdata->num_regulators; i++) {
-		rmatch.name = regulators[i].name;
-		rmatch.init_data = NULL;
-		rmatch.of_node = NULL;
-		of_regulator_match(&pdev->dev, regulators_np, &rmatch, 1);
-		rdata[i].initdata = rmatch.init_data;
-		rdata[i].of_node = rmatch.of_node;
-	}
-
-	pdata->regulators = rdata;
-	of_node_put(regulators_np);
-
-	return 0;
-}
-#else
-static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	return 0;
-}
-#endif /* CONFIG_OF */
-
 static int max77686_pmic_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct max77686_data *max77686;
-	int i, ret = 0;
+	int i;
 	struct regulator_config config = { };
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
-	if (!pdata) {
-		dev_err(&pdev->dev, "no platform data found for regulator\n");
-		return -ENODEV;
-	}
-
-	if (iodev->dev->of_node) {
-		ret = max77686_pmic_dt_parse_pdata(pdev, pdata);
-		if (ret)
-			return ret;
-	}
-
-	if (pdata->num_regulators != MAX77686_REGULATORS) {
-		dev_err(&pdev->dev,
-			"Invalid initial data for regulator's initialiation\n");
-		return -EINVAL;
-	}
-
 	max77686 = devm_kzalloc(&pdev->dev, sizeof(struct max77686_data),
 				GFP_KERNEL);
 	if (!max77686)
 		return -ENOMEM;
 
-	config.dev = &pdev->dev;
+	config.dev = iodev->dev;
 	config.regmap = iodev->regmap;
 	config.driver_data = max77686;
 	platform_set_drvdata(pdev, max77686);
@@ -516,16 +465,14 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		struct regulator_dev *rdev;
 		int id = regulators[i].id;
 
-		config.init_data = pdata->regulators[i].initdata;
-		config.of_node = pdata->regulators[i].of_node;
-
 		max77686->opmode[id] = MAX77686_NORMAL;
 		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
+			int ret = PTR_ERR(rdev);
 			dev_err(&pdev->dev,
-				"regulator init failed for %d\n", i);
-			return PTR_ERR(rdev);
+				"regulator init failed for %d: %d\n", i, ret);
+			return ret;
 		}
 	}
 
-- 
1.9.1

