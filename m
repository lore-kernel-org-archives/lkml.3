Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaFQHkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:40:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44370 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753304AbaFQHjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:39:00 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 3/7] regulator: axp20x: add support for AXP221 regulators
Date: Tue, 17 Jun 2014 09:38:39 +0200
Message-Id: <1402990723-28138-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AXP221 regulator definitions and choose the appropriate definitions
according to the variant id passed by the MFD device.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/regulator/axp20x-regulator.c | 98 +++++++++++++++++++++++++++++++++---
 1 file changed, 90 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 9716f8e..7a30f49 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -27,6 +27,9 @@
 #define AXP20X_IO_ENABLED		0x03
 #define AXP20X_IO_DISABLED		0x07
 
+#define AXP22X_IO_ENABLED		0x04
+#define AXP22X_IO_DISABLED		0x03
+
 #define AXP20X_WORKMODE_DCDC2_MASK	BIT(2)
 #define AXP20X_WORKMODE_DCDC3_MASK	BIT(1)
 
@@ -144,6 +147,48 @@ static const struct regulator_desc axp20x_regulators[] = {
 		       AXP20X_IO_DISABLED),
 };
 
+static const struct regulator_desc axp22x_regulators[] = {
+	AXP_DESC(AXP22X, DCDC1, "vin1", 1600, 3400, 100, AXP22X_DCDC1_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(1)),
+	AXP_DESC(AXP22X, DCDC2, "vin2", 600, 1540, 20, AXP22X_DCDC2_V_OUT, 0x3f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(2)),
+	AXP_DESC(AXP22X, DCDC3, "vin3", 600, 1860, 20, AXP22X_DCDC3_V_OUT, 0x3f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(3)),
+	AXP_DESC(AXP22X, DCDC4, "vin4", 600, 1540, 20, AXP22X_DCDC4_V_OUT, 0x3f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(3)),
+	AXP_DESC(AXP22X, DCDC5, "vin5", 1000, 2550, 50, AXP22X_DCDC5_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(4)),
+	AXP_DESC(AXP22X, DC5LDO, "vin5", 700, 1400, 100, AXP22X_DC5LDO_V_OUT, 0x7,
+		    AXP22X_PWR_OUT_CTRL1, BIT(0)),
+	AXP_DESC(AXP22X, ALDO1, "aldoin", 700, 3300, 100, AXP22X_ALDO1_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(6)),
+	AXP_DESC(AXP22X, ALDO2, "aldoin", 700, 3300, 100, AXP22X_ALDO2_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL1, BIT(7)),
+	AXP_DESC(AXP22X, ALDO3, "aldoin", 700, 3300, 100, AXP22X_ALDO3_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL3, BIT(7)),
+	AXP_DESC(AXP22X, DLDO1, "dldoin", 700, 3300, 100, AXP22X_DLDO1_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(3)),
+	AXP_DESC(AXP22X, DLDO2, "dldoin", 700, 3300, 100, AXP22X_DLDO2_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(4)),
+	AXP_DESC(AXP22X, DLDO3, "dldoin", 700, 3300, 100, AXP22X_DLDO3_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(5)),
+	AXP_DESC(AXP22X, DLDO4, "dldoin", 700, 3300, 100, AXP22X_DLDO4_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(6)),
+	AXP_DESC(AXP22X, ELDO1, "eldoin", 700, 3300, 100, AXP22X_ELDO1_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(0)),
+	AXP_DESC(AXP22X, ELDO2, "eldoin", 700, 3300, 100, AXP22X_ELDO2_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(1)),
+	AXP_DESC(AXP22X, ELDO3, "eldoin", 700, 3300, 100, AXP22X_ELDO3_V_OUT, 0x1f,
+		    AXP22X_PWR_OUT_CTRL2, BIT(2)),
+	AXP_DESC_IO(AXP22X, LDO_IO0, "ldoioin", 1800, 3300, 100, AXP22X_LDO_IO0_V_OUT,
+		       0x1f, AXP20X_GPIO0_CTRL, 0x07, AXP22X_IO_ENABLED,
+		       AXP22X_IO_DISABLED),
+	AXP_DESC_IO(AXP22X, LDO_IO1, "ldoioin", 1800, 3300, 100, AXP22X_LDO_IO1_V_OUT,
+		       0x1f, AXP20X_GPIO1_CTRL, 0x07, AXP22X_IO_ENABLED,
+		       AXP22X_IO_DISABLED),
+	AXP_DESC_FIXED(AXP22X, RTC_LDO, "rtcldoin", 3000),
+};
+
 #define AXP_MATCH(_family, _name, _id) \
 	[_family##_##_id] = { \
 		.name		= #_name, \
@@ -160,6 +205,28 @@ static struct of_regulator_match axp20x_matches[] = {
 	AXP_MATCH(AXP20X, ldo5, LDO5),
 };
 
+static struct of_regulator_match axp22x_matches[] = {
+	AXP_MATCH(AXP22X, dcdc1, DCDC1),
+	AXP_MATCH(AXP22X, dcdc2, DCDC2),
+	AXP_MATCH(AXP22X, dcdc3, DCDC3),
+	AXP_MATCH(AXP22X, dcdc4, DCDC4),
+	AXP_MATCH(AXP22X, dcdc5, DCDC5),
+	AXP_MATCH(AXP22X, dc5ldo, DC5LDO),
+	AXP_MATCH(AXP22X, aldo1, ALDO1),
+	AXP_MATCH(AXP22X, aldo2, ALDO2),
+	AXP_MATCH(AXP22X, aldo3, ALDO3),
+	AXP_MATCH(AXP22X, dldo1, DLDO1),
+	AXP_MATCH(AXP22X, dldo2, DLDO2),
+	AXP_MATCH(AXP22X, dldo3, DLDO3),
+	AXP_MATCH(AXP22X, dldo4, DLDO4),
+	AXP_MATCH(AXP22X, eldo1, ELDO1),
+	AXP_MATCH(AXP22X, eldo2, ELDO2),
+	AXP_MATCH(AXP22X, eldo3, ELDO3),
+	AXP_MATCH(AXP22X, ldo_io0, LDO_IO0),
+	AXP_MATCH(AXP22X, ldo_io1, LDO_IO1),
+	AXP_MATCH(AXP22X, rtc_ldo, RTC_LDO),
+};
+
 static int axp20x_set_dcdc_freq(struct platform_device *pdev, u32 dcdcfreq)
 {
 	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
@@ -238,37 +305,52 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
 	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
 	struct regulator_config config = { };
 	struct regulator_init_data *init_data;
+	struct of_regulator_match *matches;
+	int nmatches;
+	const struct regulator_desc *regulators;
+	int nregulators;
 	int ret, i;
 	u32 workmode;
 
-	ret = axp20x_regulator_parse_dt(pdev, axp20x_matches,
-					ARRAY_SIZE(axp20x_matches));
+	if (axp20x->variant == AXP221_ID) {
+		matches = axp22x_matches;
+		nmatches = ARRAY_SIZE(axp22x_matches);
+		regulators = axp22x_regulators;
+		nregulators = AXP22X_REG_ID_MAX;
+	} else {
+		matches = axp20x_matches;
+		nmatches = ARRAY_SIZE(axp20x_matches);
+		regulators = axp20x_regulators;
+		nregulators = AXP20X_REG_ID_MAX;
+	}
+
+	ret = axp20x_regulator_parse_dt(pdev, matches, nmatches);
 	if (ret)
 		return ret;
 
 	for (i = 0; i < AXP20X_REG_ID_MAX; i++) {
-		init_data = axp20x_matches[i].init_data;
+		init_data = matches[i].init_data;
 
 		config.dev = &pdev->dev;
 		config.init_data = init_data;
 		config.regmap = axp20x->regmap;
-		config.of_node = axp20x_matches[i].of_node;
+		config.of_node = matches[i].of_node;
 
-		rdev = devm_regulator_register(&pdev->dev, &axp20x_regulators[i],
+		rdev = devm_regulator_register(&pdev->dev, &regulators[i],
 					       &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev, "Failed to register %s\n",
-				axp20x_regulators[i].name);
+				regulators[i].name);
 
 			return PTR_ERR(rdev);
 		}
 
-		ret = of_property_read_u32(axp20x_matches[i].of_node, "x-powers,dcdc-workmode",
+		ret = of_property_read_u32(matches[i].of_node, "x-powers,dcdc-workmode",
 					   &workmode);
 		if (!ret) {
 			if (axp20x_set_dcdc_workmode(rdev, i, workmode))
 				dev_err(&pdev->dev, "Failed to set workmode on %s\n",
-					axp20x_regulators[i].name);
+					regulators[i].name);
 		}
 	}
 
-- 
1.8.3.2

