Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaJFUSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:18:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59244 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaJFUSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:18:01 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH 2/5] regulator: Set ena_gpio_valid in regulator drivers
Date: Mon,  6 Oct 2014 22:17:12 +0200
Message-Id: <1412626635-7404-3-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the new field ena_gpio_valid for all drivers which set a
valid ena_gpio.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/arizona-ldo1.c       | 1 +
 drivers/regulator/da9055-regulator.c   | 1 +
 drivers/regulator/fixed.c              | 4 +++-
 drivers/regulator/gpio-regulator.c     | 4 +++-
 drivers/regulator/lp8788-ldo.c         | 2 ++
 drivers/regulator/max8952.c            | 1 +
 drivers/regulator/s2mps11.c            | 1 +
 drivers/regulator/s5m8767.c            | 1 +
 drivers/regulator/tps65090-regulator.c | 1 +
 drivers/regulator/wm8994-regulator.c   | 1 +
 10 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 4c9db589f6c1..48c33be3f297 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -264,6 +264,7 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	}
 
 	config.ena_gpio = arizona->pdata.ldoena;
+	config.ena_gpio_valid = true;
 
 	if (arizona->pdata.ldo1)
 		config.init_data = arizona->pdata.ldo1;
diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 9516317e1a9f..f5ccd27bb672 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -456,6 +456,7 @@ static int da9055_gpio_init(struct da9055_regulator *regulator,
 		int gpio_mux = pdata->gpio_ren[id];
 
 		config->ena_gpio = pdata->ena_gpio[id];
+		config->ena_gpio_valid = true;
 		config->ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
 		config->ena_gpio_invert = 1;
 
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 354105eff1f8..731f4315292c 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -157,8 +157,10 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	drvdata->desc.fixed_uV = config->microvolts;
 
-	if (config->gpio >= 0)
+	if (config->gpio >= 0) {
 		cfg.ena_gpio = config->gpio;
+		cfg.ena_gpio_valid = true;
+	}
 	cfg.ena_gpio_invert = !config->enable_high;
 	if (config->enabled_at_boot) {
 		if (config->enable_high)
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 989b23b377c0..681c604d4917 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -322,8 +322,10 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 	cfg.driver_data = drvdata;
 	cfg.of_node = np;
 
-	if (config->enable_gpio >= 0)
+	if (config->enable_gpio >= 0) {
 		cfg.ena_gpio = config->enable_gpio;
+		cfg.ena_gpio_valid = true;
+	}
 	cfg.ena_gpio_invert = !config->enable_high;
 	if (config->enabled_at_boot) {
 		if (config->enable_high)
diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index b9a29a29933f..3e9d027f66fb 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -535,6 +535,7 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 
 	if (ldo->en_pin) {
 		cfg.ena_gpio = ldo->en_pin->gpio;
+		cfg.ena_gpio_valid = true;
 		cfg.ena_gpio_flags = ldo->en_pin->init_state;
 	}
 
@@ -585,6 +586,7 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 
 	if (ldo->en_pin) {
 		cfg.ena_gpio = ldo->en_pin->gpio;
+		cfg.ena_gpio_valid = true;
 		cfg.ena_gpio_flags = ldo->en_pin->init_state;
 	}
 
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index f7f9efcfedb7..b56eec51fa10 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -225,6 +225,7 @@ static int max8952_pmic_probe(struct i2c_client *client,
 	config.of_node = client->dev.of_node;
 
 	config.ena_gpio = pdata->gpio_en;
+	config.ena_gpio_valid = true;
 	if (pdata->reg_data->constraints.boot_on)
 		config.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 
diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index b16c53a8272f..4d78477b9f57 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -986,6 +986,7 @@ common_reg:
 			config.of_node = rdata[i].of_node;
 		}
 		config.ena_gpio = s2mps11->ext_control_gpio[i];
+		config.ena_gpio_valid = true;
 
 		regulator = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 0ab5cbeeb797..d258e6613831 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -466,6 +466,7 @@ static void s5m8767_regulator_config_ext_control(struct s5m8767_info *s5m8767,
 	}
 
 	config->ena_gpio = rdata->ext_control_gpio;
+	config->ena_gpio_valid = true;
 	config->ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
 }
 
diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index d5df1e9ad1da..ba87da6e494b 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -312,6 +312,7 @@ static void tps65090_configure_regulator_config(
 			gpio_flag = GPIOF_OUT_INIT_HIGH;
 
 		config->ena_gpio = tps_pdata->gpio;
+		config->ena_gpio_valid = true;
 		config->ena_gpio_flags = gpio_flag;
 	}
 }
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index c24346db8a71..dc7e80ab984e 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -149,6 +149,7 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 		config.ena_gpio = pdata->ldo[id].enable;
 	else if (wm8994->dev->of_node)
 		config.ena_gpio = wm8994->pdata.ldo[id].enable;
+	config.ena_gpio_valid = true;
 
 	/* Use default constraints if none set up */
 	if (!pdata || !pdata->ldo[id].init_data || wm8994->dev->of_node) {
-- 
2.1.0

