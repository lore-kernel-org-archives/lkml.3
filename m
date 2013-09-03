Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539Ab3ICGWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:22:07 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51141 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759438Ab3ICGWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:22:05 -0400
Message-ID: <1378189320.4621.7.camel@phoenix>
Subject: [PATCH 4/8] regulator: as3711: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 14:22:00 +0800
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
 drivers/regulator/as3711-regulator.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index 3da6bd6..101fc2e 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -374,33 +374,16 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 		config.regmap = as3711->regmap;
 		config.of_node = of_node[id];
 
-		rdev = regulator_register(&ri->desc, &config);
+		rdev = devm_regulator_register(&pdev->dev, &ri->desc, &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev, "Failed to register regulator %s\n",
 				ri->desc.name);
-			ret = PTR_ERR(rdev);
-			goto eregreg;
+			return PTR_ERR(rdev);
 		}
 		reg->rdev = rdev;
 	}
 	platform_set_drvdata(pdev, regs);
 	return 0;
-
-eregreg:
-	while (--id >= 0)
-		regulator_unregister(regs[id].rdev);
-
-	return ret;
-}
-
-static int as3711_regulator_remove(struct platform_device *pdev)
-{
-	struct as3711_regulator *regs = platform_get_drvdata(pdev);
-	int id;
-
-	for (id = 0; id < AS3711_REGULATOR_NUM; ++id)
-		regulator_unregister(regs[id].rdev);
-	return 0;
 }
 
 static struct platform_driver as3711_regulator_driver = {
@@ -409,7 +392,6 @@ static struct platform_driver as3711_regulator_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= as3711_regulator_probe,
-	.remove		= as3711_regulator_remove,
 };
 
 static int __init as3711_regulator_init(void)
-- 
1.8.1.2



