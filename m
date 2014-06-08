Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaFHOpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 10:45:49 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47816 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaFHOpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 10:45:47 -0400
Message-ID: <1402238742.32652.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: ab8500: Remove ab8500_regulator_of_probe()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 08 Jun 2014 22:45:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now this is a DT-only driver because non-devicetree probe path is removed,
so merge ab8500_regulator_of_probe() into ab8500_regulator_probe().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index c625468..88da8626 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3037,28 +3037,12 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 	return 0;
 }
 
-static int
-ab8500_regulator_of_probe(struct platform_device *pdev,
-			  struct device_node *np)
-{
-	struct of_regulator_match *match = abx500_regulator.match;
-	int err, i;
-
-	for (i = 0; i < abx500_regulator.info_size; i++) {
-		err = ab8500_regulator_register(
-			pdev, match[i].init_data, i, match[i].of_node);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *np = pdev->dev.of_node;
-	int err;
+	struct of_regulator_match *match;
+	int err, i;
 
 	if (!ab8500) {
 		dev_err(&pdev->dev, "null mfd parent\n");
@@ -3075,7 +3059,16 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 			"Error parsing regulator init data: %d\n", err);
 		return err;
 	}
-	return ab8500_regulator_of_probe(pdev, np);
+
+	match = abx500_regulator.match;
+	for (i = 0; i < abx500_regulator.info_size; i++) {
+		err = ab8500_regulator_register(pdev, match[i].init_data, i,
+						match[i].of_node);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 static int ab8500_regulator_remove(struct platform_device *pdev)
-- 
1.8.3.2



