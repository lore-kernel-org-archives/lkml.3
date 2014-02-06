Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaBFGtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 01:49:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57568 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbaBFGtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 01:49:15 -0500
Message-ID: <1391669351.24190.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: rc5t583: Allow missing init_data for
 diagnostics
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 06 Feb 2014 14:49:11 +0800
In-Reply-To: <1391669261.24190.1.camel@phoenix>
References: <1391669261.24190.1.camel@phoenix>
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
 drivers/regulator/rc5t583-regulator.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index b58affb..22d6fd1 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -119,7 +119,6 @@ static int rc5t583_regulator_probe(struct platform_device *pdev)
 {
 	struct rc5t583 *rc5t583 = dev_get_drvdata(pdev->dev.parent);
 	struct rc5t583_platform_data *pdata = dev_get_platdata(rc5t583->dev);
-	struct regulator_init_data *reg_data;
 	struct regulator_config config = { };
 	struct rc5t583_regulator *reg = NULL;
 	struct rc5t583_regulator *regs;
@@ -142,12 +141,6 @@ static int rc5t583_regulator_probe(struct platform_device *pdev)
 
 
 	for (id = 0; id < RC5T583_REGULATOR_MAX; ++id) {
-		reg_data = pdata->reg_init_data[id];
-
-		/* No need to register if there is no regulator data */
-		if (!reg_data)
-			continue;
-
 		reg = &regs[id];
 		ri = &rc5t583_reg_info[id];
 		reg->reg_info = ri;
@@ -169,7 +162,7 @@ static int rc5t583_regulator_probe(struct platform_device *pdev)
 
 skip_ext_pwr_config:
 		config.dev = &pdev->dev;
-		config.init_data = reg_data;
+		config.init_data = pdata->reg_init_data[id];
 		config.driver_data = reg;
 		config.regmap = rc5t583->regmap;
 
-- 
1.8.1.2



