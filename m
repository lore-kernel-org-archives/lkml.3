Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935Ab3BWFBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 00:01:05 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:33423 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3BWFBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 00:01:01 -0500
X-Greylist: delayed 4085 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2013 00:01:01 EST
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH] regulators: max8998.c: use dev_err() instead of printk()
Date: Sat, 23 Feb 2013 00:52:35 -0300
Message-Id: <1361591555-12729-1-git-send-email-tfarina@chromium.org>
X-Mailer: git-send-email 1.8.1.151.g32238ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch warning:

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Thiago Farina <tfarina@chromium.org>
---
 drivers/regulator/max8998.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index b588f07..a57a1b1 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -665,14 +665,16 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 	    gpio_is_valid(pdata->buck1_set2)) {
 		/* Check if SET1 is not equal to 0 */
 		if (!pdata->buck1_set1) {
-			printk(KERN_ERR "MAX8998 SET1 GPIO defined as 0 !\n");
+			dev_err(&pdev->dev,
+				"MAX8998 SET1 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set1);
 			ret = -EIO;
 			goto err_out;
 		}
 		/* Check if SET2 is not equal to 0 */
 		if (!pdata->buck1_set2) {
-			printk(KERN_ERR "MAX8998 SET2 GPIO defined as 0 !\n");
+			dev_err(&pdev->dev,
+				"MAX8998 SET2 GPIO defined as 0 !\n");
 			WARN_ON(!pdata->buck1_set2);
 			ret = -EIO;
 			goto err_out;
@@ -738,7 +740,8 @@ static int max8998_pmic_probe(struct platform_device *pdev)
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

