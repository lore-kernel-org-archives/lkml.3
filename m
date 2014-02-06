Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbaBFGrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 01:47:52 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37261 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaBFGrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 01:47:48 -0500
Message-ID: <1391669261.24190.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: as3711: Allow missing init_data for
 diagnostics
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 06 Feb 2014 14:47:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator core supports this to allow the configuration to be inspected
at runtime even if no software management is enabled.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/as3711-regulator.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index c77a584..67fd548 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -221,7 +221,6 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 {
 	struct as3711_regulator_pdata *pdata = dev_get_platdata(&pdev->dev);
 	struct as3711 *as3711 = dev_get_drvdata(pdev->dev.parent);
-	struct regulator_init_data *reg_data;
 	struct regulator_config config = {.dev = &pdev->dev,};
 	struct as3711_regulator *reg = NULL;
 	struct as3711_regulator *regs;
@@ -252,16 +251,10 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 	}
 
 	for (id = 0, ri = as3711_reg_info; id < AS3711_REGULATOR_NUM; ++id, ri++) {
-		reg_data = pdata->init_data[id];
-
-		/* No need to register if there is no regulator data */
-		if (!reg_data)
-			continue;
-
 		reg = &regs[id];
 		reg->reg_info = ri;
 
-		config.init_data = reg_data;
+		config.init_data = pdata->init_data[id];
 		config.driver_data = reg;
 		config.regmap = as3711->regmap;
 		config.of_node = of_node[id];
-- 
1.8.1.2



