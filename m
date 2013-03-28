Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3C1QRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:17:33 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:63466 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab3C1QM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/33] regulator: ab8500: Update voltage handling for fixed voltage regulators
Date: Thu, 28 Mar 2013 16:11:17 +0000
Message-Id: <1364487093-19551-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
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
index b9e71a5..e6f4666 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -140,6 +140,26 @@ static const int ldo_sdio_voltages[] = {
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
@@ -392,7 +412,6 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
 	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
-	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.list_voltage		= regulator_list_voltage_linear,
 };
 
@@ -400,7 +419,6 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
-	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.list_voltage		= regulator_list_voltage_linear,
 };
 
@@ -516,7 +534,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2000000,
+			.volt_table	= fixed_2000000_voltage,
 			.enable_time	= 500,
 		},
 		.load_lp_uA		= 1000,
@@ -535,8 +553,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2000000,
 			.enable_time	= 140,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -551,8 +569,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2050000,
 			.enable_time	= 500,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -567,8 +585,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 2050000,
 			.enable_time	= 500,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -583,8 +601,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 1800000,
 			.enable_time	= 420,
+			.volt_table	= fixed_1800000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -603,8 +621,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
-			.min_uV		= 1200000,
 			.enable_time	= 140,
+			.volt_table	= fixed_1200000_voltage,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
@@ -634,8 +652,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -658,8 +674,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -682,8 +696,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
@@ -706,8 +718,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
 		.update_bank		= 0x04,
@@ -732,8 +742,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
 		},
-		.min_uV			= 1050000,
-		.max_uV			= 2790000,
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux5 register */
 		.update_bank		= 0x01,
@@ -757,8 +765,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
 		},
-		.min_uV			= 1050000,
-		.max_uV			= 2790000,
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux6 register */
 		.update_bank		= 0x01,
@@ -782,8 +788,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -812,9 +816,9 @@ static struct ab8500_regulator_info
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
@@ -831,8 +835,8 @@ static struct ab8500_regulator_info
 			.id             = AB9540_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
+			.volt_table	= fixed_3300000_voltage,
 		},
-		.fixed_uV               = 3300000,
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
@@ -848,8 +852,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
-		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
@@ -863,8 +867,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
@@ -878,8 +882,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
@@ -893,8 +897,8 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_AUX8,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1800000_voltage,
 		},
-		.fixed_uV		= 1800000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
@@ -911,8 +915,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1200000_voltage,
 		},
-		.fixed_uV		= 1200000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
@@ -941,8 +945,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -965,8 +967,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x09,
@@ -989,8 +989,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x0a,
@@ -1013,8 +1011,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
 		.update_bank		= 0x04,
@@ -1039,8 +1035,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 		},
-		.min_uV			= 1100000,
-		.max_uV			= 3300000,
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1069,9 +1063,9 @@ static struct ab8500_regulator_info
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
@@ -1088,8 +1082,8 @@ static struct ab8500_regulator_info
 			.id             = AB9540_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
+			.volt_table	= fixed_3300000_voltage,
 		},
-		.fixed_uV               = 3300000,
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
 		.update_mask            = 0x03,
@@ -1105,8 +1099,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
-		.fixed_uV		= 2000000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x02,
@@ -1120,8 +1114,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x08,
@@ -1135,8 +1129,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
-		.fixed_uV		= 2050000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x10,
@@ -1150,8 +1144,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1800000_voltage,
 		},
-		.fixed_uV		= 1800000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
 		.update_mask		= 0x04,
@@ -1169,8 +1163,8 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_1200000_voltage,
 		},
-		.fixed_uV		= 1200000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
@@ -1335,6 +1329,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -1349,6 +1344,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -1363,6 +1359,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2050000_voltage,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -1395,6 +1392,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table     = fixed_1200000_voltage,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
@@ -1413,8 +1411,6 @@ static struct ab8500_regulator_info
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

