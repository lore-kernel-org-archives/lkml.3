Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab3CZINX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:13:23 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38352 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab3CZINU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:13:20 -0400
Message-ID: <1364285594.27005.2.camel@phoenix>
Subject: [PATCH v2] regulator: ab8500: Don't update is_enabled flag in error
 paths
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 16:13:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoid setting is_enabled flag to wrong status if enable/disable fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2: Just make the coding style consist with rest of the code.

 drivers/regulator/ab8500.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 12e2740..4a70323 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -117,9 +117,11 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
 		info->update_mask, info->update_val);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set enable bits for regulator\n");
+		return ret;
+	}
 
 	info->is_enabled = true;
 
@@ -144,9 +146,11 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
 		info->update_mask, 0x0);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set disable bits for regulator\n");
+		return ret;
+	}
 
 	info->is_enabled = false;
 
-- 
1.7.10.4



