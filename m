Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab3ICGXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:23:20 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62820 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3ICGXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:23:19 -0400
Message-ID: <1378189394.4621.9.camel@phoenix>
Subject: [PATCH 5/8] regulator: da903x: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 14:23:14 +0800
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
 drivers/regulator/da903x.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 2afa573..6de6885 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -488,7 +488,7 @@ static int da903x_regulator_probe(struct platform_device *pdev)
 	config.init_data = pdev->dev.platform_data;
 	config.driver_data = ri;
 
-	rdev = regulator_register(&ri->desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, &ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
@@ -499,21 +499,12 @@ static int da903x_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int da903x_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-	return 0;
-}
-
 static struct platform_driver da903x_regulator_driver = {
 	.driver	= {
 		.name	= "da903x-regulator",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= da903x_regulator_probe,
-	.remove		= da903x_regulator_remove,
 };
 
 static int __init da903x_regulator_init(void)
-- 
1.8.1.2



