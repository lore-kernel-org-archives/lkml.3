Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab3BDL7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:59:36 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:38195 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3BDL6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:58:06 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 68/73] regulator: ab8500: Provide DT support for additional platforms
Date: Mon,  4 Feb 2013 11:54:23 +0000
Message-Id: <1359978868-28736-69-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we use the new infrastructure to 'match' to the correct platform
when booing with Device Tree support enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   76 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 59 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index b6e8f4d..142c5fb 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2850,6 +2850,8 @@ static struct {
 	int info_size;
 	struct ab8500_reg_init *init;
 	int init_size;
+	struct of_regulator_match *match;
+	int match_size;
 } abx500_regulator;
 
 static int ab8500_regulator_init_registers(struct platform_device *pdev,
@@ -2941,18 +2943,49 @@ static struct of_regulator_match ab8500_regulator_match[] = {
 	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8500_LDO_ANA, },
 };
 
+static struct of_regulator_match ab8505_regulator_match[] = {
+	{ .name	= "ab8500_ldo_aux1",    .driver_data = (void *) AB8505_LDO_AUX1, },
+	{ .name	= "ab8500_ldo_aux2",    .driver_data = (void *) AB8505_LDO_AUX2, },
+	{ .name	= "ab8500_ldo_aux3",    .driver_data = (void *) AB8505_LDO_AUX3, },
+	{ .name	= "ab8500_ldo_aux4",    .driver_data = (void *) AB8505_LDO_AUX4, },
+	{ .name	= "ab8500_ldo_aux5",    .driver_data = (void *) AB8505_LDO_AUX5, },
+	{ .name	= "ab8500_ldo_aux6",    .driver_data = (void *) AB8505_LDO_AUX6, },
+	{ .name	= "ab8500_ldo_intcore", .driver_data = (void *) AB8505_LDO_INTCORE, },
+	{ .name	= "ab8500_ldo_adc",	.driver_data = (void *) AB8505_LDO_ADC, },
+	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8505_LDO_AUDIO, },
+	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8505_LDO_ANAMIC1, },
+	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8505_LDO_ANAMIC2, },
+	{ .name	= "ab8500_ldo_aux8",    .driver_data = (void *) AB8505_LDO_AUX8, },
+	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8505_LDO_ANA, },
+};
+
+static struct of_regulator_match ab8540_regulator_match[] = {
+	{ .name	= "ab8500_ldo_aux1",    .driver_data = (void *) AB8540_LDO_AUX1, },
+	{ .name	= "ab8500_ldo_aux2",    .driver_data = (void *) AB8540_LDO_AUX2, },
+	{ .name	= "ab8500_ldo_aux3",    .driver_data = (void *) AB8540_LDO_AUX3, },
+	{ .name	= "ab8500_ldo_aux4",    .driver_data = (void *) AB8540_LDO_AUX4, },
+	{ .name	= "ab8500_ldo_intcore", .driver_data = (void *) AB8540_LDO_INTCORE, },
+	{ .name	= "ab8500_ldo_tvout",   .driver_data = (void *) AB8540_LDO_TVOUT, },
+	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8540_LDO_AUDIO, },
+	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8540_LDO_ANAMIC1, },
+	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8540_LDO_ANAMIC2, },
+	{ .name	= "ab8500_ldo_dmic",    .driver_data = (void *) AB8540_LDO_DMIC, },
+	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8540_LDO_ANA, },
+	{ .name = "ab8500_ldo_sdio",    .driver_data = (void *) AB8540_LDO_SDIO, },
+};
+
 static struct of_regulator_match ab9540_regulator_match[] = {
-	{ .name	= "ab9540_ldo_aux1",    .driver_data = (void *) AB9540_LDO_AUX1, },
-	{ .name	= "ab9540_ldo_aux2",    .driver_data = (void *) AB9540_LDO_AUX2, },
-	{ .name	= "ab9540_ldo_aux3",    .driver_data = (void *) AB9540_LDO_AUX3, },
-	{ .name	= "ab9540_ldo_intcore", .driver_data = (void *) AB9540_LDO_INTCORE, },
-	{ .name	= "ab9540_ldo_tvout",   .driver_data = (void *) AB9540_LDO_TVOUT, },
+	{ .name = "ab9540_ldo_aux1",    .driver_data = (void *) AB9540_LDO_AUX1, },
+	{ .name = "ab9540_ldo_aux2",    .driver_data = (void *) AB9540_LDO_AUX2, },
+	{ .name = "ab9540_ldo_aux3",    .driver_data = (void *) AB9540_LDO_AUX3, },
+	{ .name = "ab9540_ldo_intcore", .driver_data = (void *) AB9540_LDO_INTCORE, },
+	{ .name = "ab9540_ldo_tvout",   .driver_data = (void *) AB9540_LDO_TVOUT, },
 	{ .name = "ab9540_ldo_usb",     .driver_data = (void *) AB9540_LDO_USB, },
 	{ .name = "ab9540_ldo_audio",   .driver_data = (void *) AB9540_LDO_AUDIO, },
-	{ .name	= "ab9540_ldo_anamic1", .driver_data = (void *) AB9540_LDO_ANAMIC1, },
-	{ .name	= "ab9540_ldo_amamic2", .driver_data = (void *) AB9540_LDO_ANAMIC2, },
-	{ .name	= "ab9540_ldo_dmic",    .driver_data = (void *) AB9540_LDO_DMIC, },
-	{ .name	= "ab9540_ldo_ana",     .driver_data = (void *) AB9540_LDO_ANA, },
+	{ .name = "ab9540_ldo_anamic1", .driver_data = (void *) AB9540_LDO_ANAMIC1, },
+	{ .name = "ab9540_ldo_amamic2", .driver_data = (void *) AB9540_LDO_ANAMIC2, },
+	{ .name = "ab9540_ldo_dmic",    .driver_data = (void *) AB9540_LDO_DMIC, },
+	{ .name = "ab9540_ldo_ana",     .driver_data = (void *) AB9540_LDO_ANA, },
 };
 
 static void abx500_get_regulator_info(struct ab8500 *ab8500)
@@ -2962,21 +2995,29 @@ static void abx500_get_regulator_info(struct ab8500 *ab8500)
 		abx500_regulator.info_size = ARRAY_SIZE(ab9540_regulator_info);
 		abx500_regulator.init = ab9540_reg_init;
 		abx500_regulator.init_size = AB9540_NUM_REGULATOR_REGISTERS;
+		abx500_regulator.match = ab9540_regulator_match;
+		abx500_regulator.match_size = ARRAY_SIZE(ab9540_regulator_match);
 	} else if (is_ab8505(ab8500)) {
 		abx500_regulator.info = ab8505_regulator_info;
 		abx500_regulator.info_size = ARRAY_SIZE(ab8505_regulator_info);
 		abx500_regulator.init = ab8505_reg_init;
 		abx500_regulator.init_size = AB8505_NUM_REGULATOR_REGISTERS;
+		abx500_regulator.match = ab8505_regulator_match;
+		abx500_regulator.match_size = ARRAY_SIZE(ab8505_regulator_match);
 	} else if (is_ab8540(ab8500)) {
 		abx500_regulator.info = ab8540_regulator_info;
 		abx500_regulator.info_size = ARRAY_SIZE(ab8540_regulator_info);
 		abx500_regulator.init = ab8540_reg_init;
 		abx500_regulator.init_size = AB8540_NUM_REGULATOR_REGISTERS;
+		abx500_regulator.match = ab8540_regulator_match;
+		abx500_regulator.match_size = ARRAY_SIZE(ab8540_regulator_match);
 	} else {
 		abx500_regulator.info = ab8500_regulator_info;
 		abx500_regulator.info_size = ARRAY_SIZE(ab8500_regulator_info);
 		abx500_regulator.init = ab8500_reg_init;
 		abx500_regulator.init_size = AB8500_NUM_REGULATOR_REGISTERS;
+		abx500_regulator.match = ab8500_regulator_match;
+		abx500_regulator.match_size = ARRAY_SIZE(ab8500_regulator_match);
 	}
 }
 
@@ -3004,29 +3045,30 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	struct ab8500_platform_data *ppdata;
 	struct ab8500_regulator_platform_data *pdata;
 	int i, err;
-	struct ab8500_reg_init *reg_init;
 
 	/* cache values needed repeatedly inside for-loops */
 
+	if (!ab8500) {
+		dev_err(&pdev->dev, "null mfd parent\n");
+		return -EINVAL;
+	}
+
 	abx500_get_regulator_info(ab8500);
 
 	if (np) {
-		err = of_regulator_match(&pdev->dev, np, match, match_size);
+		err = of_regulator_match(&pdev->dev, np,
+					 abx500_regulator.match,
+					 abx500_regulator.match_size);
 		if (err < 0) {
 			dev_err(&pdev->dev,
 				"Error parsing regulator init data: %d\n", err);
 			return err;
 		}
 
-		err = ab8500_regulator_of_probe(pdev, match, np);
+		err = ab8500_regulator_of_probe(pdev, np);
 		return err;
 	}
 
-	if (!ab8500) {
-		dev_err(&pdev->dev, "null mfd parent\n");
-		return -EINVAL;
-	}
-
 	ppdata = dev_get_platdata(ab8500->dev);
 	if (!ppdata) {
 		dev_err(&pdev->dev, "null parent pdata\n");
-- 
1.7.9.5

