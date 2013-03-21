Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab3CUQBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:01:10 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:38747 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab3CUQBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:01:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 29/46] regulator: ab8500: Use regulator_list_voltage_table()
Date: Thu, 21 Mar 2013 15:59:26 +0000
Message-Id: <1363881583-15234-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following a recent move to regulator_list_voltage_table() for
all previous abx500 related platforms this converts all recent
platform updates over too.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   62 ++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 7ae7416..22bac57 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -98,7 +98,7 @@ static const unsigned int ldo_vaux3_voltages[] = {
 	2910000,
 };
 
-static const int ldo_vaux56_voltages[] = {
+static const unsigned int ldo_vaux56_voltages[] = {
 	1800000,
 	1050000,
 	1100000,
@@ -109,7 +109,7 @@ static const int ldo_vaux56_voltages[] = {
 	2790000,
 };
 
-static const int ldo_vaux3_ab8540_voltages[] = {
+static const unsigned int ldo_vaux3_ab8540_voltages[] = {
 	1200000,
 	1500000,
 	1800000,
@@ -131,7 +131,7 @@ static const unsigned int ldo_vintcore_voltages[] = {
 	1350000,
 };
 
-static const int ldo_sdio_voltages[] = {
+static const unsigned int ldo_sdio_voltages[] = {
 	1160000,
 	1050000,
 	1100000,
@@ -652,6 +652,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -663,8 +664,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8505_LDO_AUX2] = {
 		.desc = {
@@ -674,6 +673,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -685,8 +685,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8505_LDO_AUX3] = {
 		.desc = {
@@ -696,6 +694,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+			.volt_table	= ldo_vaux3_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -707,8 +706,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
 	},
 	[AB8505_LDO_AUX4] = {
 		.desc = {
@@ -718,6 +715,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -731,8 +729,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8505_LDO_AUX5] = {
 		.desc = {
@@ -742,6 +738,7 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_AUX5,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
+			.volt_table	= ldo_vaux56_voltages,
 		},
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux5 register */
@@ -754,8 +751,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x55,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux56_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_voltages),
 	},
 	[AB8505_LDO_AUX6] = {
 		.desc = {
@@ -765,6 +760,7 @@ static struct ab8500_regulator_info
 			.id		= AB8505_LDO_AUX6,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_voltages),
+			.volt_table	= ldo_vaux56_voltages,
 		},
 		.load_lp_uA		= 2000,
 		/* values for CtrlVaux6 register */
@@ -777,8 +773,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x56,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux56_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_voltages),
 	},
 	[AB8505_LDO_INTCORE] = {
 		.desc = {
@@ -788,6 +782,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -799,8 +794,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 		.voltage_shift		= 3,
 	},
 
@@ -945,6 +938,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -956,8 +950,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_AUX2] = {
 		.desc = {
@@ -967,6 +959,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -978,8 +971,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_AUX3] = {
 		.desc = {
@@ -989,6 +980,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+			.volt_table	= ldo_vaux3_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1000,8 +992,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
 	},
 	[AB9540_LDO_AUX4] = {
 		.desc = {
@@ -1011,6 +1001,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -1024,8 +1015,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_INTCORE] = {
 		.desc = {
@@ -1035,6 +1024,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1046,8 +1036,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 		.voltage_shift		= 3,
 	},
 
@@ -1193,6 +1181,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1204,8 +1193,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_AUX2] = {
 		.desc = {
@@ -1215,6 +1202,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1226,8 +1214,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_AUX3] = {
 		.desc = {
@@ -1237,6 +1223,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
+			.volt_table	= ldo_vaux3_ab8540_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1248,8 +1235,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_ab8540_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
 	},
 	[AB8540_LDO_AUX4] = {
 		.desc = {
@@ -1259,6 +1244,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -1272,8 +1258,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_INTCORE] = {
 		.desc = {
@@ -1283,6 +1267,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1294,8 +1279,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 		.voltage_shift		= 3,
 	},
 
@@ -1410,7 +1393,8 @@ static struct ab8500_regulator_info
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8540_LDO_SDIO,
 			.owner		= THIS_MODULE,
-			.n_voltages = ARRAY_SIZE(ldo_sdio_voltages),
+			.n_voltages 	= ARRAY_SIZE(ldo_sdio_voltages),
+			.volt_table	= ldo_sdio_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1422,8 +1406,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x88,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_sdio_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_sdio_voltages),
 	},
 };
 
-- 
1.7.10.4

