Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab3ICGTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:19:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:32937 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab3ICGTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:19:06 -0400
Message-ID: <1378189140.4621.3.camel@phoenix>
Subject: [PATCH 2/8] regulator: aat2870: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 14:19:00 +0800
In-Reply-To: <1378189056.4621.1.camel@phoenix>
References: <1378189056.4621.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/aat2870-regulator.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 8b58763..1ca60ac 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -176,7 +176,7 @@ static int aat2870_regulator_probe(struct platform_device *pdev)
 	config.driver_data = ri;
 	config.init_data = pdev->dev.platform_data;
 
-	rdev = regulator_register(&ri->desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, &ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "Failed to register regulator %s\n",
 			ri->desc.name);
@@ -187,21 +187,12 @@ static int aat2870_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int aat2870_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-	return 0;
-}
-
 static struct platform_driver aat2870_regulator_driver = {
 	.driver = {
 		.name	= "aat2870-regulator",
 		.owner	= THIS_MODULE,
 	},
 	.probe	= aat2870_regulator_probe,
-	.remove	= aat2870_regulator_remove,
 };
 
 static int __init aat2870_regulator_init(void)
-- 
1.8.1.2



