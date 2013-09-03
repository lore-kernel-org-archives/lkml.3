Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab3ICG0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:26:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39312 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3ICG0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:26:15 -0400
Message-ID: <1378189570.4621.13.camel@phoenix>
Subject: [PATCH 7/8] regulator: da9055: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: David Dajun Chen <dchen@diasemi.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 14:26:10 +0800
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
 drivers/regulator/da9055-regulator.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 3022109..9565a35 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -564,13 +564,13 @@ static int da9055_regulator_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	regulator->rdev = regulator_register(&regulator->info->reg_desc,
-					     &config);
+	regulator->rdev = devm_regulator_register(&pdev->dev,
+						  &regulator->info->reg_desc,
+						  &config);
 	if (IS_ERR(regulator->rdev)) {
 		dev_err(&pdev->dev, "Failed to register regulator %s\n",
 			regulator->info->reg_desc.name);
-		ret = PTR_ERR(regulator->rdev);
-		return ret;
+		return PTR_ERR(regulator->rdev);
 	}
 
 	/* Only LDO 5 and 6 has got the over current interrupt */
@@ -588,7 +588,7 @@ static int da9055_regulator_probe(struct platform_device *pdev)
 				dev_err(&pdev->dev,
 				"Failed to request Regulator IRQ %d: %d\n",
 				irq, ret);
-				goto err_regulator;
+				return ret;
 			}
 		}
 	}
@@ -596,24 +596,10 @@ static int da9055_regulator_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, regulator);
 
 	return 0;
-
-err_regulator:
-	regulator_unregister(regulator->rdev);
-	return ret;
-}
-
-static int da9055_regulator_remove(struct platform_device *pdev)
-{
-	struct da9055_regulator *regulator = platform_get_drvdata(pdev);
-
-	regulator_unregister(regulator->rdev);
-
-	return 0;
 }
 
 static struct platform_driver da9055_regulator_driver = {
 	.probe = da9055_regulator_probe,
-	.remove = da9055_regulator_remove,
 	.driver = {
 		.name = "da9055-regulator",
 		.owner = THIS_MODULE,
-- 
1.8.1.2



