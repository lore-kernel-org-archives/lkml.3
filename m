Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaJFURy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:17:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59235 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJFURx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:17:53 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH 4/5] regulator: Use gpio_is_valid
Date: Mon,  6 Oct 2014 22:17:14 +0200
Message-Id: <1412626635-7404-5-git-send-email-mpa@pengutronix.de>
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

Use gpio_is_valid instead of custom check.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/fixed.c            | 2 +-
 drivers/regulator/gpio-regulator.c   | 2 +-
 drivers/regulator/wm8994-regulator.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 731f4315292c..35b00a288667 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -157,7 +157,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	drvdata->desc.fixed_uV = config->microvolts;
 
-	if (config->gpio >= 0) {
+	if (gpio_is_valid(config->gpio)) {
 		cfg.ena_gpio = config->gpio;
 		cfg.ena_gpio_valid = true;
 	}
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 681c604d4917..52d50aa9ab4b 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -322,7 +322,7 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 	cfg.driver_data = drvdata;
 	cfg.of_node = np;
 
-	if (config->enable_gpio >= 0) {
+	if (gpio_is_valid(config->enable_gpio)) {
 		cfg.ena_gpio = config->enable_gpio;
 		cfg.ena_gpio_valid = true;
 	}
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index dc7e80ab984e..8f2df50225a9 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -158,7 +158,7 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 
 		ldo->init_data = wm8994_ldo_default[id];
 		ldo->init_data.consumer_supplies = &ldo->supply;
-		if (!config.ena_gpio)
+		if (!gpio_is_valid(config.ena_gpio))
 			ldo->init_data.constraints.valid_ops_mask = 0;
 	} else {
 		ldo->init_data = *pdata->ldo[id].init_data;
-- 
2.1.0

