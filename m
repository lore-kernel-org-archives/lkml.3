Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3HKPZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 11:25:40 -0400
Received: from mout.gmx.net ([212.227.15.18]:54247 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab3HKPZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 11:25:39 -0400
From: Andreas Werner <wernerandy@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Andreas Werner <wernerandy@gmx.de>
Subject: [PATCH] Staging: imx-drm: imx-tve.c Fixed 80 character line coding style issue
Date: Sun, 11 Aug 2013 17:25:32 +0200
Message-Id: <1376234732-30062-1-git-send-email-wernerandy@gmx.de>
X-Mailer: git-send-email 1.8.3.4
X-Provags-ID: V03:K0:KcLpe0oTPys3RhAjKeDoK0CWyhvgJLRBVaQqLvOOPlLRTU8jB/j
 g68spZFmZrO67dpS8/+IXISX0YA3chEOGOZDmatZSLTm8iMvAdsAZPwqcyGbsFlwNaFXKB6
 KcT+E8WN4kuxBOw3ytXzjKO/XoQsDCY94ctom39T9wYduKBPGd771YL1uZFQNEElmjvuJd8
 Rcl3YHMDU6etZjO8ZxB6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue of 80 character per line.

Signed-off-by: Andreas Werner <wernerandy@gmx.de>
---
 drivers/staging/imx-drm/imx-tve.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index a56797d..82c5f12 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -164,7 +164,10 @@ static void tve_enable(struct imx_tve *tve)
 		regmap_write(tve->regmap, TVE_INT_CONT_REG, 0);
 	else
 		regmap_write(tve->regmap, TVE_INT_CONT_REG,
-			     TVE_CD_SM_IEN | TVE_CD_LM_IEN | TVE_CD_MON_END_IEN);
+			     TVE_CD_SM_IEN |
+			     TVE_CD_LM_IEN |
+			     TVE_CD_MON_END_IEN);
+
 	spin_unlock_irqrestore(&tve->enable_lock, flags);
 }
 
@@ -465,7 +468,9 @@ static int clk_tve_di_set_rate(struct clk_hw *hw, unsigned long rate,
 	else
 		val = TVE_DAC_FULL_RATE;
 
-	ret = regmap_update_bits(tve->regmap, TVE_COM_CONF_REG, TVE_DAC_SAMP_RATE_MASK, val);
+	ret = regmap_update_bits(tve->regmap, TVE_COM_CONF_REG,
+				 TVE_DAC_SAMP_RATE_MASK, val);
+
 	if (ret < 0) {
 		dev_err(tve->dev, "failed to set divider: %d\n", ret);
 		return ret;
@@ -609,13 +614,17 @@ static int imx_tve_probe(struct platform_device *pdev)
 	}
 
 	if (tve->mode == TVE_MODE_VGA) {
-		ret = of_property_read_u32(np, "fsl,hsync-pin", &tve->hsync_pin);
+		ret = of_property_read_u32(np, "fsl,hsync-pin",
+					   &tve->hsync_pin);
+
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get vsync pin\n");
 			return ret;
 		}
 
-		ret |= of_property_read_u32(np, "fsl,vsync-pin", &tve->vsync_pin);
+		ret |= of_property_read_u32(np, "fsl,vsync-pin",
+					    &tve->vsync_pin);
+
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get vsync pin\n");
 			return ret;
-- 
1.8.3.4

