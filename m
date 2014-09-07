Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaIGKiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 06:38:54 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48133 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaIGKix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 06:38:53 -0400
Message-ID: <1410086329.4121.3.camel@phoenix>
Subject: [PATCH] regulator: bcm590xx: Remove unused **info field from struct
 bcm590xx_reg
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Graham Williams <graham.williams@linaro.org>,
        Matt Porter <mporter@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 07 Sep 2014 18:38:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/bcm590xx-regulator.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
index 5d1fd6f..fe6ac69 100644
--- a/drivers/regulator/bcm590xx-regulator.c
+++ b/drivers/regulator/bcm590xx-regulator.c
@@ -202,7 +202,6 @@ static struct bcm590xx_info bcm590xx_regs[] = {
 struct bcm590xx_reg {
 	struct regulator_desc *desc;
 	struct bcm590xx *mfd;
-	struct bcm590xx_info **info;
 };
 
 static int bcm590xx_get_vsel_register(int id)
@@ -389,11 +388,6 @@ static int bcm590xx_probe(struct platform_device *pdev)
 	if (!pmu->desc)
 		return -ENOMEM;
 
-	pmu->info = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
-			sizeof(struct bcm590xx_info *), GFP_KERNEL);
-	if (!pmu->info)
-		return -ENOMEM;
-
 	info = bcm590xx_regs;
 
 	for (i = 0; i < BCM590XX_NUM_REGS; i++, info++) {
@@ -403,8 +397,6 @@ static int bcm590xx_probe(struct platform_device *pdev)
 			reg_data = NULL;
 
 		/* Register the regulators */
-		pmu->info[i] = info;
-
 		pmu->desc[i].name = info->name;
 		pmu->desc[i].supply_name = info->vin_name;
 		pmu->desc[i].id = i;
-- 
1.9.1



