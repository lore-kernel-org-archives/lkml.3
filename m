Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384Ab3DCCav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:30:51 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60590 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760771Ab3DCCat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:30:49 -0400
Message-ID: <1364956243.1328.1.camel@phoenix>
Subject: [PATCH 1/4] regulator: ab8500: Remove set_voltage_time_sel and
 delay to fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 03 Apr 2013 10:30:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The delay field is removed from struct ab8500_regulator_info in commit 29234928
"regulator: ab8500: Remove set_voltage_time_sel and delay setting".

In additional, current delay setting does not make sense at all.
ab8500_regulator_mode_ops is for fixed voltage only, which does not need
set_voltage_time_sel. All ab8540_aux3_regulator_volt_mode_ops users do not have
delay settings so set_voltage_time_sel actually returns 0.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index ef12d3d..abdfbd4 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -633,15 +633,6 @@ static int ab8540_aux3_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
-					     unsigned int old_sel,
-					     unsigned int new_sel)
-{
-	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-
-	return info->delay;
-}
-
 static struct regulator_ops ab8500_regulator_volt_mode_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
@@ -664,7 +655,6 @@ static struct regulator_ops ab8540_aux3_regulator_volt_mode_ops = {
 	.get_voltage_sel = ab8540_aux3_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8540_aux3_regulator_set_voltage_sel,
 	.list_voltage	= regulator_list_voltage_table,
-	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
 static struct regulator_ops ab8500_regulator_volt_ops = {
@@ -674,7 +664,6 @@ static struct regulator_ops ab8500_regulator_volt_ops = {
 	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
 	.list_voltage	= regulator_list_voltage_table,
-	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
 static struct regulator_ops ab8500_regulator_mode_ops = {
@@ -1092,7 +1081,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1357,7 +1345,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1606,7 +1593,6 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
-- 
1.7.10.4



