Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab3CUQGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:06:52 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43653 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933707Ab3CUQA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:00:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 27/46] regulator: ab8500: Update voltage handling for fixed voltage regulators
Date: Thu, 21 Mar 2013 15:59:24 +0000
Message-Id: <1363881583-15234-28-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few over-lapping methods for voltage selection operating
in the AB8500 regulator driver currently. This patch removes unused,
unnecessary variables from the regulator_info structures and provides
voltage tables for those regulators which have fixed voltages.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   92 +++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 48 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 04f78fe..7ae7416 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -142,6 +142,26 @@ static const int ldo_sdio_voltages[] = {
 	3050000,
 };
 
+static const unsigned int fixed_1200000_voltage[] = {
+	1200000,
+};
+
+static const unsigned int fixed_1800000_voltage[] = {
+	1800000,
+};
+
+static const unsigned int fixed_2000000_voltage[] = {
+	2000000,
+};
+
+static const unsigned int fixed_2050000_voltage[] = {
+	2050000,
+};
+
+static const unsigned int fixed_3300000_voltage[] = {
+	3300000,
+};
+
 static int ab8500_regulator_enable(struct regulator_dev *rdev)
 {
 	int ret;
@@ -400,7 +420,6 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
 	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
-	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.list_voltage		= regulator_list_voltage_table,
 	.set_voltage_time_sel	= ab8500_regulator_set_voltage_time_sel,
 };
@@ -409,7 +428,6 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
-	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.list_voltage		= regulator_list_voltage_table,
 };
 
@@ -521,7 +539,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2000000,
+			.volt_table	= fixed_2000000_voltage,
 			.enable_time	= 500,
 		},
 		.delay			= 500,
@@ -541,7 +559,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2000000,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -556,7 +574,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2050000,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -571,7 +589,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2050000,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -586,7 +604,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 1800000,
+			.volt_table	= fixed_1800000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -605,7 +623,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 1200000,
+			.volt_table	= fixed_1200000_voltage,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
@@ -635,8 +653,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -659,8 +675,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -683,8 +697,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
@@ -707,8 +719,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
 		.update_bank		= 0x04,
@@ -733,8 +743,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
 		},
-		.min_uV			= 1050000,
-		.max_uV			= 2790000,
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux5 register */
 		.update_bank		= 0x01,
@@ -758,8 +766,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
 		},
-		.min_uV			= 1050000,
-		.max_uV			= 2790000,
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux6 register */
 		.update_bank		= 0x01,
@@ -783,8 +789,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -813,9 +817,9 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_ADC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.delay			= 10000,
-		.fixed_uV		= 2000000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -832,8 +836,8 @@ static struct ab8500_regulator_info
 			.id             = AB9540_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
+			.volt_table	= fixed_3300000_voltage,
 		},
-		.fixed_uV               = 3300000,
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
@@ -849,8 +853,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
-		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
@@ -864,8 +868,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
@@ -879,8 +883,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
@@ -894,8 +898,8 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_AUX8,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1800000_voltage,
 		},
-		.fixed_uV		= 1800000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
@@ -912,8 +916,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1200000_voltage,
 		},
-		.fixed_uV		= 1200000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
@@ -942,8 +946,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -966,8 +968,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -990,8 +990,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
@@ -1014,8 +1012,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
 		.update_bank		= 0x04,
@@ -1040,8 +1036,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1070,9 +1064,9 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.delay			= 10000,
-		.fixed_uV		= 2000000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1089,8 +1083,8 @@ static struct ab8500_regulator_info
 			.id             = AB9540_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
+			.volt_table	= fixed_3300000_voltage,
 		},
-		.fixed_uV               = 3300000,
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
@@ -1106,8 +1100,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
-		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
@@ -1121,8 +1115,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
@@ -1136,8 +1130,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
@@ -1151,8 +1145,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1800000_voltage,
 		},
-		.fixed_uV		= 1800000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
@@ -1170,8 +1164,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1200000_voltage,
 		},
-		.fixed_uV		= 1200000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
@@ -1336,6 +1330,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -1350,6 +1345,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -1364,6 +1360,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -1396,6 +1393,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table     = fixed_1200000_voltage,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
@@ -1414,8 +1412,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages = ARRAY_SIZE(ldo_sdio_voltages),
 		},
-		.min_uV			= 1050000,
-		.max_uV			= 3050000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x88,
-- 
1.7.10.4

