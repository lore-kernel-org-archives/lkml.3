Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbbAPDWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:22:30 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.110]:13352 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbbAPDW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:22:29 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 22:22:29 EST
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-13.tower-194.messagelabs.com!1421378155!27647506!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201501160315.t0G3Fix5023568@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Date: Fri, 16 Jan 2015 12:13:27 +0900
Subject: [PATCH V1] regulator: da9211: fix unmatched of_node
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for fixing unmatched of_node.

Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20150115.


 drivers/regulator/da9211-regulator.c |    4 ++--
 include/linux/regulator/da9211.h     |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index c78d210..8e6957c 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -276,7 +276,7 @@ static struct da9211_pdata *da9211_parse_regulators_dt(
 			continue;
 
 		pdata->init_data[n] = da9211_matches[i].init_data;
-
+		pdata->reg_node[n] = da9211_matches[i].of_node;
 		n++;
 	}
 
@@ -364,7 +364,7 @@ static int da9211_regulator_init(struct da9211 *chip)
 		config.dev = chip->dev;
 		config.driver_data = chip;
 		config.regmap = chip->regmap;
-		config.of_node = chip->dev->of_node;
+		config.of_node = chip->pdata->reg_node[i];
 
 		chip->rdev[i] = devm_regulator_register(chip->dev,
 			&da9211_regulators[i], &config);
diff --git a/include/linux/regulator/da9211.h b/include/linux/regulator/da9211.h
index 5479394..d1d9d38 100644
--- a/include/linux/regulator/da9211.h
+++ b/include/linux/regulator/da9211.h
@@ -32,6 +32,7 @@ struct da9211_pdata {
 	 * 2 : 2 phase 2 buck
 	 */
 	int num_buck;
+	struct device_node *reg_node[DA9211_MAX_REGULATORS];
 	struct regulator_init_data *init_data[DA9211_MAX_REGULATORS];
 };
 #endif
-- 
end-of-patch for regulator: da9211: fix unmatched of_node V1

