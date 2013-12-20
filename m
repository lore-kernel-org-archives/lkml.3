Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161009Ab3LTNnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:43:37 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:38034 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab3LTNng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:43:36 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: tps51632-regulator: Fix spelling
Date: Fri, 20 Dec 2013 11:43:21 -0200
Message-Id: <1387547001-32564-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the 'VOLATGE' spell error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/tps51632-regulator.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index 3486be9..b3764f5 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -70,16 +70,16 @@
 #define TPS51632_POWER_STATE_SINGLE_PHASE_CCM	0x1
 #define TPS51632_POWER_STATE_SINGLE_PHASE_DCM	0x2
 
-#define TPS51632_MIN_VOLATGE			500000
-#define TPS51632_MAX_VOLATGE			1520000
-#define TPS51632_VOLATGE_STEP_10mV		10000
-#define TPS51632_VOLATGE_STEP_20mV		20000
+#define TPS51632_MIN_VOLTAGE			500000
+#define TPS51632_MAX_VOLTAGE			1520000
+#define TPS51632_VOLTAGE_STEP_10mV		10000
+#define TPS51632_VOLTAGE_STEP_20mV		20000
 #define TPS51632_MAX_VSEL			0x7F
 #define TPS51632_MIN_VSEL			0x19
 #define TPS51632_DEFAULT_RAMP_DELAY		6000
 #define TPS51632_VOLT_VSEL(uV)					\
-		(DIV_ROUND_UP(uV - TPS51632_MIN_VOLATGE,	\
-			TPS51632_VOLATGE_STEP_10mV) +		\
+		(DIV_ROUND_UP(uV - TPS51632_MIN_VOLTAGE,	\
+			TPS51632_VOLTAGE_STEP_10mV) +		\
 			TPS51632_MIN_VSEL)
 
 /* TPS51632 chip information */
@@ -243,9 +243,9 @@ static struct tps51632_regulator_platform_data *
 	pdata->dvfs_step_20mV = of_property_read_bool(np, "ti,dvfs-step-20mV");
 
 	pdata->base_voltage_uV = pdata->reg_init_data->constraints.min_uV ? :
-					TPS51632_MIN_VOLATGE;
+					TPS51632_MIN_VOLTAGE;
 	pdata->max_voltage_uV = pdata->reg_init_data->constraints.max_uV ? :
-					TPS51632_MAX_VOLATGE;
+					TPS51632_MAX_VOLTAGE;
 	return pdata;
 }
 #else
@@ -284,15 +284,15 @@ static int tps51632_probe(struct i2c_client *client,
 	}
 
 	if (pdata->enable_pwm_dvfs) {
-		if ((pdata->base_voltage_uV < TPS51632_MIN_VOLATGE) ||
-		    (pdata->base_voltage_uV > TPS51632_MAX_VOLATGE)) {
+		if ((pdata->base_voltage_uV < TPS51632_MIN_VOLTAGE) ||
+		    (pdata->base_voltage_uV > TPS51632_MAX_VOLTAGE)) {
 			dev_err(&client->dev, "Invalid base_voltage_uV setting\n");
 			return -EINVAL;
 		}
 
 		if ((pdata->max_voltage_uV) &&
-		    ((pdata->max_voltage_uV < TPS51632_MIN_VOLATGE) ||
-		     (pdata->max_voltage_uV > TPS51632_MAX_VOLATGE))) {
+		    ((pdata->max_voltage_uV < TPS51632_MIN_VOLTAGE) ||
+		     (pdata->max_voltage_uV > TPS51632_MAX_VOLTAGE))) {
 			dev_err(&client->dev, "Invalid max_voltage_uV setting\n");
 			return -EINVAL;
 		}
@@ -308,8 +308,8 @@ static int tps51632_probe(struct i2c_client *client,
 	tps->desc.name = client->name;
 	tps->desc.id = 0;
 	tps->desc.ramp_delay = TPS51632_DEFAULT_RAMP_DELAY;
-	tps->desc.min_uV = TPS51632_MIN_VOLATGE;
-	tps->desc.uV_step = TPS51632_VOLATGE_STEP_10mV;
+	tps->desc.min_uV = TPS51632_MIN_VOLTAGE;
+	tps->desc.uV_step = TPS51632_VOLTAGE_STEP_10mV;
 	tps->desc.linear_min_sel = TPS51632_MIN_VSEL;
 	tps->desc.n_voltages = TPS51632_MAX_VSEL + 1;
 	tps->desc.ops = &tps51632_dcdc_ops;
-- 
1.8.1.2

