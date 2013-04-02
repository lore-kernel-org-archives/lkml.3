Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365Ab3DBM4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:56:23 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:38601 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760030Ab3DBM4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:56:22 -0400
Message-ID: <1364907376.9803.1.camel@phoenix>
Subject: [PATCH] regulator: ab8500-ext: Don't update info->is_enabled if
 write to register fails
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Apr 2013 20:56:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500-ext.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 21b9bfb..7923e82 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -72,9 +72,11 @@ static int enable(struct ab8500_ext_regulator_info *info, u8 *regval)
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
 		info->update_mask, *regval);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set enable bits for regulator\n");
+		return ret;
+	}
 
 	info->is_enabled = true;
 
@@ -117,9 +119,11 @@ static int disable(struct ab8500_ext_regulator_info *info, u8 *regval)
 	ret = abx500_mask_and_set_register_interruptible(info->dev,
 		info->update_bank, info->update_reg,
 		info->update_mask, *regval);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(rdev_get_dev(info->rdev),
 			"couldn't set disable bits for regulator\n");
+		return ret;
+	}
 
 	info->is_enabled = false;
 
-- 
1.7.10.4



