Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaIBQP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:15:29 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33135 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbaIBQOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:14:49 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Chris Zhong <zyw@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] regulator: RK808: Add proper input supplies for rk808
Date: Tue,  2 Sep 2014 09:14:28 -0700
Message-Id: <1409674469-12123-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409674469-12123-1-git-send-email-dianders@chromium.org>
References: <1409674469-12123-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original RK808 regulator driver didn't setup input supplies
properly.  Add them.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/regulator/rk808-regulator.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 0d11df1..44f5a8d 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -108,6 +108,7 @@ static struct regulator_ops rk808_switch_ops = {
 static const struct regulator_desc rk808_reg[] = {
 	{
 		.name = "DCDC_REG1",
+		.supply_name = "vcc1",
 		.id = RK808_ID_DCDC1,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -121,6 +122,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "DCDC_REG2",
+		.supply_name = "vcc2",
 		.id = RK808_ID_DCDC2,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -134,6 +136,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "DCDC_REG3",
+		.supply_name = "vcc3",
 		.id = RK808_ID_DCDC3,
 		.ops = &rk808_switch_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -143,6 +146,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "DCDC_REG4",
+		.supply_name = "vcc4",
 		.id = RK808_ID_DCDC4,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -156,6 +160,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "LDO_REG1",
+		.supply_name = "vcc6",
 		.id = RK808_ID_LDO1,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -169,6 +174,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "LDO_REG2",
+		.supply_name = "vcc6",
 		.id = RK808_ID_LDO2,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -182,6 +188,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "LDO_REG3",
+		.supply_name = "vcc7",
 		.id = RK808_ID_LDO3,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -195,6 +202,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "LDO_REG4",
+		.supply_name = "vcc9",
 		.id = RK808_ID_LDO4,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -208,6 +216,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "LDO_REG5",
+		.supply_name = "vcc9",
 		.id = RK808_ID_LDO5,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -221,6 +230,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "LDO_REG6",
+		.supply_name = "vcc10",
 		.id = RK808_ID_LDO6,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -234,6 +244,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "LDO_REG7",
+		.supply_name = "vcc7",
 		.id = RK808_ID_LDO7,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -247,6 +258,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "LDO_REG8",
+		.supply_name = "vcc11",
 		.id = RK808_ID_LDO8,
 		.ops = &rk808_reg_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -260,6 +272,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "SWITCH_REG1",
+		.supply_name = "vcc8",
 		.id = RK808_ID_SWITCH1,
 		.ops = &rk808_switch_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -268,6 +281,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.owner = THIS_MODULE,
 	}, {
 		.name = "SWITCH_REG2",
+		.supply_name = "vcc12",
 		.id = RK808_ID_SWITCH2,
 		.ops = &rk808_switch_ops,
 		.type = REGULATOR_VOLTAGE,
@@ -364,7 +378,6 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 		if (client->dev.of_node)
 			config.of_node = pdata->of_node[i];
 
-		reg_data->supply_regulator = rk808_reg[i].name;
 		config.init_data = reg_data;
 
 		rk808_rdev = devm_regulator_register(&pdev->dev,
-- 
2.1.0.rc2.206.gedb03e5

