Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaCNB7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 21:59:14 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36882 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaCNB7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 21:59:13 -0400
Message-ID: <1394762347.8460.3.camel@phoenix>
Subject: [PATCH 2/3] regulator: bcm590xx: Remove **rdev from struct
 bcm590xx_reg
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Matt Porter <mporter@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 14 Mar 2014 09:59:07 +0800
In-Reply-To: <1394762274.8460.1.camel@phoenix>
References: <1394762274.8460.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The **rdev of 'struct bcm590xx_reg' isn't used anywhere in the driver so
remove it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/bcm590xx-regulator.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
index d12d6d6..ab08ca7 100644
--- a/drivers/regulator/bcm590xx-regulator.c
+++ b/drivers/regulator/bcm590xx-regulator.c
@@ -153,7 +153,6 @@ static struct bcm590xx_info bcm590xx_regs[] = {
 struct bcm590xx_reg {
 	struct regulator_desc *desc;
 	struct bcm590xx *mfd;
-	struct regulator_dev **rdev;
 	struct bcm590xx_info **info;
 };
 
@@ -334,13 +333,6 @@ static int bcm590xx_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	pmu->rdev = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
-			sizeof(struct regulator_dev *), GFP_KERNEL);
-	if (!pmu->rdev) {
-		dev_err(&pdev->dev, "Memory alloc fails for rdev\n");
-		return -ENOMEM;
-	}
-
 	info = bcm590xx_regs;
 
 	for (i = 0; i < BCM590XX_NUM_REGS; i++, info++) {
@@ -391,8 +383,6 @@ static int bcm590xx_probe(struct platform_device *pdev)
 				pdev->name);
 			return PTR_ERR(rdev);
 		}
-
-		pmu->rdev[i] = rdev;
 	}
 
 	return 0;
-- 
1.8.1.2



