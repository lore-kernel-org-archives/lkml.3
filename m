Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3C1GjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:39:06 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:58202 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3C1GjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:39:03 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH v2 2/2] extcon: max8997: Fix return value
Date: Thu, 28 Mar 2013 11:57:33 +0530
Message-Id: <1364452053-17405-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1364452053-17405-1-git-send-email-sachin.kamat@linaro.org>
References: <1364452053-17405-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value obtained from the function instead of hardcoding.
Fixes the following warnings:
drivers/extcon/extcon-max8997.c:235 max8997_muic_set_path() info:
why not propagate 'ret' from max8997_update_reg() instead of (-11)?
drivers/extcon/extcon-max8997.c:248 max8997_muic_set_path() info:
why not propagate 'ret' from max8997_update_reg() instead of (-11)?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max8997.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 69641bc..3c593e8 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -196,7 +196,7 @@ static int max8997_muic_set_debounce_time(struct max8997_muic_info *info,
 					  CONTROL3_ADCDBSET_MASK);
 		if (ret) {
 			dev_err(info->dev, "failed to set ADC debounce time\n");
-			return -EAGAIN;
+			return ret;
 		}
 		break;
 	default:
@@ -232,7 +232,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
 			MAX8997_MUIC_REG_CONTROL1, ctrl1, COMP_SW_MASK);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
-		return -EAGAIN;
+		return ret;
 	}
 
 	if (attached)
@@ -245,7 +245,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
 			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
-		return -EAGAIN;
+		return ret;
 	}
 
 	dev_info(info->dev,
@@ -397,7 +397,7 @@ static int max8997_muic_handle_jig_uart(struct max8997_muic_info *info,
 	ret = max8997_muic_set_path(info, info->path_uart, attached);
 	if (ret) {
 		dev_err(info->dev, "failed to update muic register\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	extcon_set_cable_state(info->edev, "JIG", attached);
@@ -608,7 +608,7 @@ static int max8997_muic_detect_dev(struct max8997_muic_info *info)
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
 		mutex_unlock(&info->mutex);
-		return -EINVAL;
+		return ret;
 	}
 
 	adc = max8997_muic_get_cable_type(info, MAX8997_CABLE_GROUP_ADC,
-- 
1.7.4.1

