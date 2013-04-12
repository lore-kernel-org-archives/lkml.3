Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3DLRZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:25:46 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:55690 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab3DLRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:25:44 -0400
Message-ID: <1365787538.8465.1.camel@phoenix>
Subject: [PATCH] regulator: rc5t583: Remove unused fields from struct
 rc5t583_regulator_info
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 13 Apr 2013 01:25:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *dev and *mfd of struct rc5t583_regulator_info are not used after convert
to use regmap, remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/rc5t583-regulator.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 9e6f786..5885b45 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -49,10 +49,6 @@ struct rc5t583_regulator_info {
 
 struct rc5t583_regulator {
 	struct rc5t583_regulator_info *reg_info;
-
-	/* Devices */
-	struct device		*dev;
-	struct rc5t583		*mfd;
 	struct regulator_dev	*rdev;
 };
 
@@ -155,8 +151,6 @@ static int rc5t583_regulator_probe(struct platform_device *pdev)
 		reg = &regs[id];
 		ri = &rc5t583_reg_info[id];
 		reg->reg_info = ri;
-		reg->mfd = rc5t583;
-		reg->dev = &pdev->dev;
 
 		if (ri->deepsleep_id == RC5T583_DS_NONE)
 			goto skip_ext_pwr_config;
-- 
1.7.10.4



