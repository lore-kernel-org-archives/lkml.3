Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3C0LfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:35:00 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61673 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3C0Le5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:34:57 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 2/2] extcon: max8997: Fix return value
Date: Wed, 27 Mar 2013 16:53:30 +0530
Message-Id: <1364383410-15093-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1364383410-15093-1-git-send-email-sachin.kamat@linaro.org>
References: <1364383410-15093-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value obtained from the function instead of hardcoding.
drivers/extcon/extcon-max8997.c:235 max8997_muic_set_path() info:
why not propagate 'ret' from max8997_update_reg() instead of (-11)?
drivers/extcon/extcon-max8997.c:248 max8997_muic_set_path() info:
why not propagate 'ret' from max8997_update_reg() instead of (-11)?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max8997.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 69641bc..05b76b3 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
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
-- 
1.7.4.1

