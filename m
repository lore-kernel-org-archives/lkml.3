Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbaDOLrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:47:46 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:49699 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDOLrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:47:45 -0400
Message-ID: <1397562458.24265.3.camel@phoenix>
Subject: [PATCH] regulator: tps65217: Remove *rdev[] from struct tps65217
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, AnilKumar Ch <anilkumar@ti.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 19:47:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now this driver uses devm_regulator_register() so we don't need to save rdev
pointer to tps->rdev[i] for cleanup.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65217-regulator.c | 3 ---
 include/linux/mfd/tps65217.h           | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 10b78d2..8482f6b 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -257,9 +257,6 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 				pdev->name);
 			return PTR_ERR(rdev);
 		}
-
-		/* Save regulator for cleanup */
-		tps->rdev[i] = rdev;
 	}
 	return 0;
 }
diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
index 54b5458..95d6938 100644
--- a/include/linux/mfd/tps65217.h
+++ b/include/linux/mfd/tps65217.h
@@ -254,7 +254,6 @@ struct tps65217 {
 	struct tps65217_board *pdata;
 	unsigned long id;
 	struct regulator_desc desc[TPS65217_NUM_REGULATOR];
-	struct regulator_dev *rdev[TPS65217_NUM_REGULATOR];
 	struct regmap *regmap;
 };
 
-- 
1.8.3.2



