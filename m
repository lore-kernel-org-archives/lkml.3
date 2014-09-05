Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaIEBRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:17:45 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53139 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaIEBRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:17:44 -0400
Message-ID: <1409879861.5208.4.camel@phoenix>
Subject: [PATCH] regulator: max77802: Remove duplicate rdev_get_id() call
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 05 Sep 2014 09:17:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max77802.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 967e109..d89792b 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -134,7 +134,7 @@ static int max77802_ldo_set_suspend_mode_logic1(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	max77802->opmode[rdev_get_id(rdev)] = val;
+	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
 }
@@ -167,7 +167,7 @@ static int max77802_ldo_set_suspend_mode_logic2(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	max77802->opmode[rdev_get_id(rdev)] = val;
+	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
 }
-- 
1.9.1



