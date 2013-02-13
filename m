Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab3BMTwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:52:42 -0500
Received: from mail-gh0-f170.google.com ([209.85.160.170]:59681 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3BMTwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:52:40 -0500
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH] regulator: max77686: Reuse rdev_get_id() function.
Date: Wed, 13 Feb 2013 17:52:26 -0200
Message-Id: <1360785146-10323-1-git-send-email-tfarina@chromium.org>
X-Mailer: git-send-email 1.8.1.151.g32238ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfarina@chromium.org>
---
 drivers/regulator/max77686.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index cca18a3..e4586ee 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -75,13 +75,14 @@ static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
 {
 	unsigned int val;
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+        int id = rdev_get_id(rdev);
 
-	if (rdev->desc->id == MAX77686_BUCK1)
+	if (id == MAX77686_BUCK1)
 		val = 0x1;
 	else
 		val = 0x1 << MAX77686_OPMODE_BUCK234_SHIFT;
 
-	max77686->opmode[rdev->desc->id] = val;
+	max77686->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
 				  val);
@@ -93,9 +94,10 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 {
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
 	unsigned int val;
+        int id = rdev_get_id(rdev);
 
 	/* BUCK[5-9] doesn't support this feature */
-	if (rdev->desc->id >= MAX77686_BUCK5)
+	if (id >= MAX77686_BUCK5)
 		return 0;
 
 	switch (mode) {
@@ -111,7 +113,7 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	max77686->opmode[rdev->desc->id] = val;
+	max77686->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
 				  val);
@@ -140,7 +142,7 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	max77686->opmode[rdev->desc->id] = val;
+	max77686->opmode[rdev_get_id(rdev)] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
 				  val);
@@ -152,7 +154,7 @@ static int max77686_enable(struct regulator_dev *rdev)
 
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
-				  max77686->opmode[rdev->desc->id]);
+				  max77686->opmode[rdev_get_id(rdev)]);
 }
 
 static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
-- 
1.8.1.151.g32238ae

