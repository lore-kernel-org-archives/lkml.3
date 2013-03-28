Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3C1GjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:39:03 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:48689 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3C1GjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:39:02 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH v2 1/2] extcon: max77693: Fix return value
Date: Thu, 28 Mar 2013 11:57:32 +0530
Message-Id: <1364452053-17405-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value obtained from the function instead of hardcoding.
Silences the following warnings:
drivers/extcon/extcon-max77693.c:297 max77693_muic_set_path()
info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?
drivers/extcon/extcon-max77693.c:310 max77693_muic_set_path()
info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Changes since v1:
Include additional instances.
Compile tested.
---
 drivers/extcon/extcon-max77693.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 8f3c947..924db01 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -258,7 +258,7 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
 					  CONTROL3_ADCDBSET_MASK);
 		if (ret) {
 			dev_err(info->dev, "failed to set ADC debounce time\n");
-			return -EAGAIN;
+			return ret;
 		}
 		break;
 	default:
@@ -294,7 +294,7 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 			MAX77693_MUIC_REG_CTRL1, ctrl1, COMP_SW_MASK);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
-		return -EAGAIN;
+		return ret;
 	}
 
 	if (attached)
@@ -307,7 +307,7 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
-		return -EAGAIN;
+		return ret;
 	}
 
 	dev_info(info->dev,
@@ -1035,7 +1035,7 @@ static int max77693_muic_detect_accessory(struct max77693_muic_info *info)
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
 		mutex_unlock(&info->mutex);
-		return -EINVAL;
+		return ret;
 	}
 
 	adc = max77693_muic_get_cable_type(info, MAX77693_CABLE_GROUP_ADC,
-- 
1.7.4.1

