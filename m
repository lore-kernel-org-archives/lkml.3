Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab3ICGYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:24:53 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51264 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3ICGYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:24:51 -0400
Message-ID: <1378189486.4621.11.camel@phoenix>
Subject: [PATCH 6/8] regulator: da9052: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: David Dajun Chen <dchen@diasemi.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 14:24:46 +0800
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
 drivers/regulator/da9052-regulator.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 96b569a..25d3e47 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -389,8 +389,9 @@ static int da9052_regulator_probe(struct platform_device *pdev)
 #endif
 	}
 
-	regulator->rdev = regulator_register(&regulator->info->reg_desc,
-					     &config);
+	regulator->rdev = devm_regulator_register(&pdev->dev,
+						  &regulator->info->reg_desc,
+						  &config);
 	if (IS_ERR(regulator->rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			regulator->info->reg_desc.name);
@@ -402,17 +403,8 @@ static int da9052_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int da9052_regulator_remove(struct platform_device *pdev)
-{
-	struct da9052_regulator *regulator = platform_get_drvdata(pdev);
-
-	regulator_unregister(regulator->rdev);
-	return 0;
-}
-
 static struct platform_driver da9052_regulator_driver = {
 	.probe = da9052_regulator_probe,
-	.remove = da9052_regulator_remove,
 	.driver = {
 		.name = "da9052-regulator",
 		.owner = THIS_MODULE,
-- 
1.8.1.2



