Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3C0Jsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:48:36 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59259 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3C0Jse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:48:34 -0400
Message-ID: <1364377709.13084.1.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: ab8500: Remove set_voltage_time_sel and
 delay setting
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 17:48:29 +0800
In-Reply-To: <1364377642.13084.0.camel@phoenix>
References: <1364377642.13084.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data sheet does not specify time delay for voltage selection,
thus remove set_voltage_time_sel and delay setting.

Note, currently set_voltage_time_sel callback returns 0 due to missing
delay settings.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 1a38524..d0d9e83 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -42,7 +42,6 @@
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
  * @voltage_shift: shift to control regulator voltage
- * @delay: startup/set voltage delay in us
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
@@ -60,7 +59,6 @@ struct ab8500_regulator_info {
 	u8 voltage_reg;
 	u8 voltage_mask;
 	u8 voltage_shift;
-	unsigned int delay;
 };
 
 /* voltage tables for the vauxn/vintcore supplies */
@@ -333,15 +331,6 @@ static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
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
@@ -352,7 +341,6 @@ static struct regulator_ops ab8500_regulator_volt_mode_ops = {
 	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.set_voltage_sel	= ab8500_regulator_set_voltage_sel,
 	.list_voltage		= regulator_list_voltage_table,
-	.set_voltage_time_sel	= ab8500_regulator_set_voltage_time_sel,
 };
 
 static struct regulator_ops ab8500_regulator_mode_ops = {
@@ -488,7 +476,6 @@ static struct ab8500_regulator_info
 			.min_uV		= 2000000,
 			.enable_time	= 10000,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
-- 
1.7.10.4



