Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3BDL6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:58:19 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61632 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3BDL6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:58:12 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 71/73] regulator: ab8500: Remove the need for a 'delay' property
Date: Mon,  4 Feb 2013 11:54:26 +0000
Message-Id: <1359978868-28736-72-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator framework now has provisions to read a regulator's
start-up time via the 'enable_time' attribute. So let's remove all
'enable_time'/'delay' duplication and just stick with 'enable_time'
from now on.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 8ec5c4f..193bfda 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -63,7 +63,6 @@ struct ab8500_shared_mode {
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
  * @voltage_shift: shift to control regulator voltage
- * @delay: startup/set voltage delay in us
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
@@ -87,7 +86,6 @@ struct ab8500_regulator_info {
 	u8 voltage_reg;
 	u8 voltage_mask;
 	u8 voltage_shift;
-	unsigned int delay;
 	struct {
 		u8 voltage_limit;
 		u8 voltage_bank;
@@ -652,7 +650,7 @@ static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 {
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	return info->delay;
+	return info->desc.enable_time;
 }
 
 static struct regulator_ops ab8500_regulator_volt_mode_ops = {
@@ -829,7 +827,6 @@ static struct ab8500_regulator_info
 			.volt_table	= fixed_2000000_voltage,
 			.enable_time	= 500,
 		},
-		.delay			= 500,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1099,7 +1096,6 @@ static struct ab8500_regulator_info
 			.volt_table	= fixed_2000000_voltage,
 			.enable_time    = 10000,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1364,7 +1360,6 @@ static struct ab8500_regulator_info
 			.volt_table	= fixed_2000000_voltage,
 			.enable_time    = 10000,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1661,7 +1656,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= 1,
 			.enable_time    = 10000,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
-- 
1.7.9.5

