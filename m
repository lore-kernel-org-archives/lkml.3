Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab3BWDvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 22:51:52 -0500
Received: from mail-ye0-f176.google.com ([209.85.213.176]:59614 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab3BWDvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 22:51:48 -0500
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 2/2] regulators: max8998.c: use dev_err() instead of printk()
Date: Sat, 23 Feb 2013 00:51:26 -0300
Message-Id: <1361591486-12663-1-git-send-email-tfarina@chromium.org>
X-Mailer: git-send-email 1.8.1.151.g32238ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch warning:

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Thiago Farina <tfarina@chromium.org>
---
 drivers/regulator/max8998.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index faeb7e8..a57a1b1 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -666,7 +666,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		/* Check if SET1 is not equal to 0 */
 		if (!pdata->buck1_set1) {
 			dev_err(&pdev->dev,
-                                "MAX8998 SET1 GPIO defined as 0 !\n");
+				"MAX8998 SET1 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set1);
 			ret = -EIO;
 			goto err_out;
@@ -674,7 +674,7 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		/* Check if SET2 is not equal to 0 */
 		if (!pdata->buck1_set2) {
 			dev_err(&pdev->dev,
-                                "MAX8998 SET2 GPIO defined as 0 !\n");
+				"MAX8998 SET2 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set2);
 			ret = -EIO;
 			goto err_out;
@@ -740,7 +740,8 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 	if (gpio_is_valid(pdata->buck2_set3)) {
 		/* Check if SET3 is not equal to 0 */
 		if (!pdata->buck2_set3) {
-			printk(KERN_ERR "MAX8998 SET3 GPIO defined as 0 !\n");
+			dev_err(&pdev->dev,
+				"MAX8998 SET3 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck2_set3);
 			ret = -EIO;
 			goto err_out;
-- 
1.8.1.151.g32238ae

