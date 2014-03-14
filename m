Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaCNCAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:00:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35863 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbaCNCAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:00:33 -0400
Message-ID: <1394762428.8460.5.camel@phoenix>
Subject: [PATCH 3/3] regulator: bcm590xx: Use array to save desc and *info
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Matt Porter <mporter@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 14 Mar 2014 10:00:28 +0800
In-Reply-To: <1394762274.8460.1.camel@phoenix>
References: <1394762274.8460.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BCM590XX_NUM_REGS is known in compile time.
Use array to save desc and *info makes the code simpler.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/bcm590xx-regulator.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
index ab08ca7..fe21855 100644
--- a/drivers/regulator/bcm590xx-regulator.c
+++ b/drivers/regulator/bcm590xx-regulator.c
@@ -151,9 +151,9 @@ static struct bcm590xx_info bcm590xx_regs[] = {
 };
 
 struct bcm590xx_reg {
-	struct regulator_desc *desc;
+	struct regulator_desc desc[BCM590XX_NUM_REGS];
 	struct bcm590xx *mfd;
-	struct bcm590xx_info **info;
+	struct bcm590xx_info *info[BCM590XX_NUM_REGS];
 };
 
 static int bcm590xx_get_vsel_register(int id)
@@ -319,20 +319,6 @@ static int bcm590xx_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pmu);
 
-	pmu->desc = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
-			sizeof(struct regulator_desc), GFP_KERNEL);
-	if (!pmu->desc) {
-		dev_err(&pdev->dev, "Memory alloc fails for desc\n");
-		return -ENOMEM;
-	}
-
-	pmu->info = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
-			sizeof(struct bcm590xx_info *), GFP_KERNEL);
-	if (!pmu->info) {
-		dev_err(&pdev->dev, "Memory alloc fails for info\n");
-		return -ENOMEM;
-	}
-
 	info = bcm590xx_regs;
 
 	for (i = 0; i < BCM590XX_NUM_REGS; i++, info++) {
-- 
1.8.1.2



