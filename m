Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3L1DCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 22:02:42 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36490 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3L1DCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 22:02:41 -0500
Message-ID: <1388199755.8941.0.camel@phoenix>
Subject: [PATCH] regulator: tps65910: Simplify setting enable_mask for
 regulators
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Markus Pargmann <mpa@pengutronix.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 28 Dec 2013 11:02:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BBCH_BBCHEN_MASK is equivalent to TPS65910_SUPPLY_STATE_ENABLED.
So all regulators have the same enable_mask setting.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65910-regulator.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 979ea0a..f50dd84 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1207,21 +1207,7 @@ static int tps65910_probe(struct platform_device *pdev)
 		pmic->desc[i].type = REGULATOR_VOLTAGE;
 		pmic->desc[i].owner = THIS_MODULE;
 		pmic->desc[i].enable_reg = pmic->get_ctrl_reg(i);
-
-		switch (i) {
-		case TPS65910_REG_VBB:
-			if (tps65910_chip_id(tps65910) == TPS65910)
-				pmic->desc[i].enable_mask = BBCH_BBCHEN_MASK;
-			else
-				pmic->desc[i].enable_mask =
-					TPS65910_SUPPLY_STATE_ENABLED;
-			break;
-
-		default:
-			pmic->desc[i].enable_mask =
-				TPS65910_SUPPLY_STATE_ENABLED;
-			break;
-		}
+		pmic->desc[i].enable_mask = TPS65910_SUPPLY_STATE_ENABLED;
 
 		config.dev = tps65910->dev;
 		config.init_data = reg_data;
-- 
1.8.1.2



