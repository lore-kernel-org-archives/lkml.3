Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab3C1QOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:14:10 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:46685 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab3C1QMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/33] regulator: ab8500: Use regulator_list_voltage_table() to look-up voltages
Date: Thu, 28 Mar 2013 16:11:30 +0000
Message-Id: <1364487093-19551-31-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
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
index 7892a51..bb574bf 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -937,7 +937,7 @@ static struct ab8500_regulator_info
 	 * Variable Voltage Regulators
 	 *   name, min mV, max mV,
 	 *   update bank, reg, mask, enable val
-	 *   volt bank, reg, mask, table, table length
+	 *   volt bank, reg, mask
 	 */
 	[AB8505_LDO_AUX1] = {
 		.desc = {
@@ -1151,8 +1151,6 @@ static struct ab8500_regulator_info
 		.voltage_reg		= 0x57,
 		.voltage_mask		= 0x7,
 		.voltage_shift		= 4,
-		.voltages		= ldo_vaudio_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaudio_voltages),
 	},
 	[AB8505_LDO_ANAMIC1] = {
 		.desc = {
@@ -1234,8 +1232,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x29,
 		.voltage_mask		= 0x7,
-		.voltages		= ldo_vana_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vana_voltages),
 	},
 };
 
@@ -1246,7 +1242,7 @@ static struct ab8500_regulator_info
 	 * Variable Voltage Regulators
 	 *   name, min mV, max mV,
 	 *   update bank, reg, mask, enable val
-	 *   volt bank, reg, mask, table, table length
+	 *   volt bank, reg, mask
 	 */
 	[AB9540_LDO_AUX1] = {
 		.desc = {
@@ -1489,7 +1485,7 @@ static struct ab8500_regulator_info
 	 * Variable Voltage Regulators
 	 *   name, min mV, max mV,
 	 *   update bank, reg, mask, enable val
-	 *   volt bank, reg, mask, table, table length
+	 *   volt bank, reg, mask
 	 */
 	[AB8540_LDO_AUX1] = {
 		.desc = {
@@ -1592,6 +1588,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_AUX5,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
+			.volt_table	= ldo_vaux56_ab8540_voltages,
 		},
 		.load_lp_uA		= 20000,
 		/* values for Vaux5Regu register */
@@ -1605,8 +1602,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x33,
 		.voltage_mask		= 0x3f,
-		.voltages		= ldo_vaux56_ab8540_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
 	},
 	[AB8540_LDO_AUX6] = {
 		.desc = {
@@ -1616,6 +1611,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_AUX6,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
+			.volt_table	= ldo_vaux56_ab8540_voltages,
 		},
 		.load_lp_uA		= 20000,
 		/* values for Vaux6Regu register */
@@ -1629,8 +1625,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x36,
 		.voltage_mask		= 0x3f,
-		.voltages		= ldo_vaux56_ab8540_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux56_ab8540_voltages),
 	},
 	[AB8540_LDO_INTCORE] = {
 		.desc = {
@@ -1743,6 +1737,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vdmic_voltages),
+			.volt_table	= ldo_vdmic_voltages,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
@@ -1752,8 +1747,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x83,
 		.voltage_mask		= 0xc0,
-		.voltages		= ldo_vdmic_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vdmic_voltages),
 	},
 
 	/*
-- 
1.7.10.4

