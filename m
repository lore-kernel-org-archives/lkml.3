Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab3ICGRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:17:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59335 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3ICGRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:17:42 -0400
Message-ID: <1378189056.4621.1.camel@phoenix>
Subject: [PATCH 1/8] regulator: 88pm8607: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 14:17:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/88pm8607.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 8a7cb1f..e006e7e 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -391,7 +391,8 @@ static int pm8607_regulator_probe(struct platform_device *pdev)
 	else
 		config.regmap = chip->regmap_companion;
 
-	info->regulator = regulator_register(&info->desc, &config);
+	info->regulator = devm_regulator_register(&pdev->dev, &info->desc,
+						  &config);
 	if (IS_ERR(info->regulator)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			info->desc.name);
@@ -402,14 +403,6 @@ static int pm8607_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int pm8607_regulator_remove(struct platform_device *pdev)
-{
-	struct pm8607_regulator_info *info = platform_get_drvdata(pdev);
-
-	regulator_unregister(info->regulator);
-	return 0;
-}
-
 static struct platform_device_id pm8607_regulator_driver_ids[] = {
 	{
 		.name	= "88pm860x-regulator",
@@ -428,7 +421,6 @@ static struct platform_driver pm8607_regulator_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= pm8607_regulator_probe,
-	.remove		= pm8607_regulator_remove,
 	.id_table	= pm8607_regulator_driver_ids,
 };
 
-- 
1.8.1.2



