Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3C0LmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:42:09 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44469 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3C0LmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:42:07 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] extcon: max77693: Fix return value
Date: Wed, 27 Mar 2013 16:53:29 +0530
Message-Id: <1364383410-15093-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value obtained from the function instead of hardcoding.
Silences the following warning:
drivers/extcon/extcon-max77693.c:297 max77693_muic_set_path()
info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?
drivers/extcon/extcon-max77693.c:310 max77693_muic_set_path()
info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max77693.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 8f3c947..894e20e 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
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
-- 
1.7.4.1

