Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3BFKzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:53 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65193 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3BFKzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:25 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 48/49] regulator: ab8500: Use regulator_list_voltage_table() to look-up voltages
Date: Wed,  6 Feb 2013 10:54:10 +0000
Message-Id: <1360148051-7560-49-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator framework offers a generic regulator_list_voltage_table()
function which can directly look-up a regulator's voltage capabilities
using a table provided through the desc structure. This patch ensures
that information is available.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index ee7ce92..3b8ace5 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -926,7 +926,7 @@ static struct ab8500_regulator_info
 	 * Variable Voltage Regulators
 	 *   name, min mV, max mV,
 	 *   update bank, reg, mask, enable val
-	 *   volt bank, reg, mask, table, table length
+	 *   volt bank, reg, mask
 	 */
 	[AB8505_LDO_AUX1] = {
 		.desc = {
@@ -1139,8 +1139,6 @@ static struct ab8500_regulator_info
 		.voltage_reg		= 0x57,
 		.voltage_mask		= 0x7,
 		.voltage_shift		= 4,
-		.voltages		= ldo_vaudio_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaudio_voltages),
 	},
 	[AB8505_LDO_ANAMIC1] = {
 		.desc = {
@@ -1222,8 +1220,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x29,
 		.voltage_mask		= 0x7,
-		.voltages		= ldo_vana_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vana_voltages),
 	},
 };
 
@@ -1234,7 +1230,7 @@ static struct ab8500_regulator_info
 	 * Variable Voltage Regulators
 	 *   name, min mV, max mV,
 	 *   update bank, reg, mask, enable val
-	 *   volt bank, reg, mask, table, table length
+	 *   volt bank, reg, mask
 	 */
 	[AB9540_LDO_AUX1] = {
 		.desc = {
@@ -1477,7 +1473,7 @@ static struct ab8500_regulator_info
 	 * Variable Voltage Regulators
 	 *   name, min mV, max mV,
 	 *   update bank, reg, mask, enable val
-	 *   volt bank, reg, mask, table, table length
+	 *   volt bank, reg, mask
 	 */
 	[AB8540_LDO_AUX1] = {
 		.desc = {
@@ -1580,6 +1576,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_AUX5,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
+			.volt_table	= ldo_vaux56_ab8540_voltages,
 		},
 		.load_lp_uA		= 20000,
 		/* values for Vaux5Regu register */
@@ -1593,8 +1590,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x33,
 		.voltage_mask		= 0x3f,
-		.voltages		= ldo_vaux56_ab8540_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
 	},
 	[AB8540_LDO_AUX6] = {
 		.desc = {
@@ -1604,6 +1599,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_AUX6,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
+			.volt_table	= ldo_vaux56_ab8540_voltages,
 		},
 		.load_lp_uA		= 20000,
 		/* values for Vaux6Regu register */
@@ -1617,8 +1613,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x36,
 		.voltage_mask		= 0x3f,
-		.voltages		= ldo_vaux56_ab8540_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
 	},
 	[AB8540_LDO_INTCORE] = {
 		.desc = {
@@ -1727,6 +1721,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vdmic_voltages),
+			.volt_table	= ldo_vdmic_voltages,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
@@ -1736,8 +1731,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x83,
 		.voltage_mask		= 0xc0,
-		.voltages		= ldo_vdmic_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vdmic_voltages),
 	},
 
 	/*
-- 
1.7.9.5

