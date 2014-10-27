Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaJ0P3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:29:44 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12633 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaJ0P3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:29:32 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-8c-544e64d837b7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/8] regulator: max77802: Remove support for board files
Date: Mon, 27 Oct 2014 16:03:39 +0100
Message-id: <1414422226-10948-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xa7o3UvxCDDb+k7HYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBb3P96lNHi25UOJotNj6+xWlze
	NYfNYsb5fUwWty/zWqw9cpfd4nQ3q4OgR0tzD5vH3+fXWTz+rnrB7LFz1l12j02rOtk87lzb
	w+Yx72Sgx+Yl9R59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CV8WndNpaCe7IVh+59Y2lg3CrR
	xcjJISFgItG4bzsLhC0mceHeerYuRi4OIYGljBL7zkyCcvqYJJoWnWMCqWITMJbYvHwJWEJE
	oJNZoudgLzOIwyywmkni55VTzCBVwgIeEsc6L7GD2CwCqhKTp21iBLF5BdwlNny8DbVPTuLk
	scmsIDYnUP3r+1/BeoWAaj6/38o4gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ
	IP+6g3HpMatDjAIcjEo8vBOKfUOEWBPLiitzDzFKcDArifCeCvALEeJNSaysSi3Kjy8qzUkt
	PsTIxMEp1cCYm2mi2yaubXDu1Da7n7bpwT88ePNFlrPVfZmfcJd5tntcRN+GqVW/fZjzM4sP
	pj13P5IlkmvUe7X8ZPnO/pIzbjwXytYY8zLLi33TXS3OtujT8ZJ9c/13HNDP4pHbJnclYMUW
	45dit8LevI+VNPu19NbCdNnvyfkpZbdnGzhn8cd+aJKKO6HEUpyRaKjFXFScCACRs+6yUAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
Convert the driver to DTS-only version.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77802.c | 44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 5839c4509e1f..61d03e9f8acf 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -70,6 +70,9 @@ static unsigned int ramp_table_77802_4bit[] = {
 };
 
 struct max77802_regulator_prv {
+	struct max77686_regulator_data *regulators;
+	int num_regulators;
+
 	unsigned int opmode[MAX77802_REG_MAX];
 };
 
@@ -517,9 +520,8 @@ static struct regulator_desc regulators[] = {
 	regulator_77802_desc_n_ldo(35, 2, 1),
 };
 
-#ifdef CONFIG_OF
-static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
+static int max77802_pmic_dt_parse(struct platform_device *pdev,
+				struct max77802_regulator_prv *max77802)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *pmic_np, *regulators_np;
@@ -534,15 +536,15 @@ static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	pdata->num_regulators = ARRAY_SIZE(regulators);
+	max77802->num_regulators = ARRAY_SIZE(regulators);
 	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
-			     pdata->num_regulators, GFP_KERNEL);
+			     max77802->num_regulators, GFP_KERNEL);
 	if (!rdata) {
 		of_node_put(regulators_np);
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < pdata->num_regulators; i++) {
+	for (i = 0; i < max77802->num_regulators; i++) {
 		rmatch.name = regulators[i].name;
 		rmatch.init_data = NULL;
 		rmatch.of_node = NULL;
@@ -557,44 +559,28 @@ static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
 		rdata[i].id = regulators[i].id;
 	}
 
-	pdata->regulators = rdata;
+	max77802->regulators = rdata;
 	of_node_put(regulators_np);
 
 	return 0;
 }
-#else
-static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	return 0;
-}
-#endif /* CONFIG_OF */
 
 static int max77802_pmic_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct max77802_regulator_prv *max77802;
 	int i, ret = 0, val;
 	struct regulator_config config = { };
 
-	/* This is allocated by the MFD driver */
-	if (!pdata) {
-		dev_err(&pdev->dev, "no platform data found for regulator\n");
-		return -ENODEV;
-	}
-
 	max77802 = devm_kzalloc(&pdev->dev,
 				sizeof(struct max77802_regulator_prv),
 				GFP_KERNEL);
 	if (!max77802)
 		return -ENOMEM;
 
-	if (iodev->dev->of_node) {
-		ret = max77802_pmic_dt_parse_pdata(pdev, pdata);
-		if (ret)
-			return ret;
-	}
+	ret = max77802_pmic_dt_parse(pdev, max77802);
+	if (ret)
+		return ret;
 
 	config.dev = iodev->dev;
 	config.regmap = iodev->regmap;
@@ -603,11 +589,11 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77802_REG_MAX; i++) {
 		struct regulator_dev *rdev;
-		int id = pdata->regulators[i].id;
+		int id = max77802->regulators[i].id;
 		int shift = max77802_get_opmode_shift(id);
 
-		config.init_data = pdata->regulators[i].initdata;
-		config.of_node = pdata->regulators[i].of_node;
+		config.init_data = max77802->regulators[i].initdata;
+		config.of_node = max77802->regulators[i].of_node;
 
 		ret = regmap_read(iodev->regmap, regulators[i].enable_reg, &val);
 		val = val >> shift & MAX77802_OPMODE_MASK;
-- 
1.9.1

