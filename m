Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaFPBod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 21:44:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56011 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaFPBoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 21:44:25 -0400
Message-ID: <1402883060.4707.1.camel@phoenix>
Subject: [PATCH] regulator: twl: Convert to use devm_kmemdup()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Nishanth Menon <nm@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2014 09:44:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/twl-regulator.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index fed28ab..0b4f866 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1128,7 +1128,7 @@ static int twlreg_probe(struct platform_device *pdev)
 	if (!initdata)
 		return -EINVAL;
 
-	info = kmemdup(template, sizeof(*info), GFP_KERNEL);
+	info = devm_kmemdup(&pdev->dev, template, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -1192,7 +1192,6 @@ static int twlreg_probe(struct platform_device *pdev)
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "can't register %s, %ld\n",
 				info->desc.name, PTR_ERR(rdev));
-		kfree(info);
 		return PTR_ERR(rdev);
 	}
 	platform_set_drvdata(pdev, rdev);
@@ -1212,20 +1211,10 @@ static int twlreg_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int twlreg_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-	struct twlreg_info *info = rdev->reg_data;
-
-	kfree(info);
-	return 0;
-}
-
 MODULE_ALIAS("platform:twl_reg");
 
 static struct platform_driver twlreg_driver = {
 	.probe		= twlreg_probe,
-	.remove		= twlreg_remove,
 	/* NOTE: short name, to work around driver model truncation of
 	 * "twl_regulator.12" (and friends) to "twl_regulator.1".
 	 */
-- 
1.8.3.2



