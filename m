Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3BFKz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:29 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:35066 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab3BFKzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:11 -0500
X-Greylist: delayed 169149 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2013 05:55:11 EST
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 33/49] regulator: ab8500: Use regulator_list_voltage_table()
Date: Wed,  6 Feb 2013 10:53:55 +0000
Message-Id: <1360148051-7560-34-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following a recent move to regulator_list_voltage_table() for
all previous abx500 related platforms this converts all recent
platform updates over too.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   61 +++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 3ffc8b1..a8b0a3f 100644
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
 	},
 
 	/*
@@ -944,6 +937,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -955,8 +949,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_AUX2] = {
 		.desc = {
@@ -966,6 +958,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -977,8 +970,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_AUX3] = {
 		.desc = {
@@ -988,6 +979,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+			.volt_table	= ldo_vaux3_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -999,8 +991,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
 	},
 	[AB9540_LDO_AUX4] = {
 		.desc = {
@@ -1010,6 +1000,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -1023,8 +1014,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB9540_LDO_INTCORE] = {
 		.desc = {
@@ -1034,6 +1023,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1045,8 +1035,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 	},
 
 	/*
@@ -1204,8 +1192,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_AUX2] = {
 		.desc = {
@@ -1215,6 +1201,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1226,8 +1213,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_AUX3] = {
 		.desc = {
@@ -1237,6 +1222,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
+			.volt_table	= ldo_vaux3_ab8540_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -1248,8 +1234,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_ab8540_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
 	},
 	[AB8540_LDO_AUX4] = {
 		.desc = {
@@ -1259,6 +1243,7 @@ static struct ab8500_regulator_info
 			.id		= AB9540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.load_lp_uA		= 5000,
 		/* values for Vaux4Regu register */
@@ -1272,8 +1257,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x2f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8540_LDO_INTCORE] = {
 		.desc = {
@@ -1283,6 +1266,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1294,8 +1278,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 	},
 
 	/*
@@ -1405,7 +1387,8 @@ static struct ab8500_regulator_info
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8540_LDO_SDIO,
 			.owner		= THIS_MODULE,
-			.n_voltages = ARRAY_SIZE(ldo_sdio_voltages),
+			.n_voltages 	= ARRAY_SIZE(ldo_sdio_voltages),
+			.volt_table	= ldo_sdio_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -1417,8 +1400,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x88,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_sdio_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_sdio_voltages),
 	},
 };
 
-- 
1.7.9.5

