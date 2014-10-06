Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaJFUSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:18:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59252 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaJFUSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:18:10 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH 5/5] regulator: Remove unnecessary ena_gpio initializations
Date: Mon,  6 Oct 2014 22:17:15 +0200
Message-Id: <1412626635-7404-6-git-send-email-mpa@pengutronix.de>
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

It is not necessary to setup config.ena_gpio with -EINVAL or similar.
This patch removes these unnecessary initializations.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/pfuze100-regulator.c | 1 -
 drivers/regulator/s5m8767.c            | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index c879dff597ee..d7455ee309bf 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -509,7 +509,6 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 		config.init_data = init_data;
 		config.driver_data = pfuze_chip;
 		config.of_node = match_of_node(i);
-		config.ena_gpio = -EINVAL;
 
 		pfuze_chip->regulators[i] =
 			devm_regulator_register(&client->dev, desc, &config);
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index d258e6613831..2c7817f12516 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -949,8 +949,6 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		config.driver_data = s5m8767;
 		config.regmap = iodev->regmap_pmic;
 		config.of_node = pdata->regulators[i].reg_node;
-		config.ena_gpio = -EINVAL;
-		config.ena_gpio_flags = 0;
 		if (gpio_is_valid(pdata->regulators[i].ext_control_gpio))
 			s5m8767_regulator_config_ext_control(s5m8767,
 					&pdata->regulators[i], &config);
-- 
2.1.0

