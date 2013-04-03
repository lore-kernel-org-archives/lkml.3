Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060Ab3DCWF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 18:05:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33688 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab3DCWFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 18:05:25 -0400
Message-ID: <1365026717.10047.0.camel@phoenix>
Subject: [PATCH] regulator: ab8500: Remove
 ab8500_regulator_set_voltage_time_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 04 Apr 2013 06:05:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users of ab8500_regulator_volt_mode_ops and ab8500_regulator_volt_ops
do not set info->desc.enable_time, thus set_voltage_time_sel() always returns 0.
Remove it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index a8552a5..517305e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -648,15 +648,6 @@ static int ab8540_aux3_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
-					     unsigned int old_sel,
-					     unsigned int new_sel)
-{
-	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-
-	return info->desc.enable_time;
-}
-
 static struct regulator_ops ab8500_regulator_volt_mode_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
@@ -679,7 +670,6 @@ static struct regulator_ops ab8540_aux3_regulator_volt_mode_ops = {
 	.get_voltage_sel = ab8540_aux3_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8540_aux3_regulator_set_voltage_sel,
 	.list_voltage	= regulator_list_voltage_table,
-	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
 static struct regulator_ops ab8500_regulator_volt_ops = {
@@ -689,7 +679,6 @@ static struct regulator_ops ab8500_regulator_volt_ops = {
 	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
 	.list_voltage	= regulator_list_voltage_table,
-	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
 static struct regulator_ops ab8500_regulator_mode_ops = {
-- 
1.7.10.4



