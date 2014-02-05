Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaBESgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:36:16 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53903 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaBESgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:36:14 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Cc: broonie@kernel.org, lgirdwood@gmail.com, badarkhe.manish@gmail.com
Subject: [PATCH V2] regulator: tps6507x: Use "IS_ENABLED" for DT code.
Date: Thu,  6 Feb 2014 00:06:00 +0530
Message-Id: <1391625360-1827-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of "#ifdef CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
option for DT code to avoid if-deffery in code.
Also, modify code as per coding style.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
Changes since V1:
1. fix build break when CONFIG_OF is not set.

:100644 100644 162a0fa... 862cc81... M	drivers/regulator/tps6507x-regulator.c
 drivers/regulator/tps6507x-regulator.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 162a0fa..862cc81 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -359,7 +359,6 @@ static struct regulator_ops tps6507x_pmic_ops = {
 	.map_voltage = regulator_map_voltage_ascend,
 };
 
-#ifdef CONFIG_OF
 static struct of_regulator_match tps6507x_matches[] = {
 	{ .name = "VDCDC1"},
 	{ .name = "VDCDC2"},
@@ -424,15 +423,7 @@ static struct tps6507x_board *tps6507x_parse_dt_reg_data(
 
 	return tps_board;
 }
-#else
-static inline struct tps6507x_board *tps6507x_parse_dt_reg_data(
-			struct platform_device *pdev,
-			struct of_regulator_match **tps6507x_reg_matches)
-{
-	*tps6507x_reg_matches = NULL;
-	return NULL;
-}
-#endif
+
 static int tps6507x_pmic_probe(struct platform_device *pdev)
 {
 	struct tps6507x_dev *tps6507x_dev = dev_get_drvdata(pdev->dev.parent);
@@ -453,9 +444,10 @@ static int tps6507x_pmic_probe(struct platform_device *pdev)
 	 */
 
 	tps_board = dev_get_platdata(tps6507x_dev->dev);
-	if (!tps_board && tps6507x_dev->dev->of_node)
+	if (IS_ENABLED(CONFIG_OF) && !tps_board &&
+		tps6507x_dev->dev->of_node)
 		tps_board = tps6507x_parse_dt_reg_data(pdev,
-						&tps6507x_reg_matches);
+				&tps6507x_reg_matches);
 	if (!tps_board)
 		return -EINVAL;
 
@@ -481,7 +473,7 @@ static int tps6507x_pmic_probe(struct platform_device *pdev)
 		tps->info[i] = info;
 		if (init_data->driver_data) {
 			struct tps6507x_reg_platform_data *data =
-							init_data->driver_data;
+					init_data->driver_data;
 			tps->info[i]->defdcdc_default = data->defdcdc_default;
 		}
 
-- 
1.7.10.4

