Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3BFLBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:01:53 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40871 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3BFKzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:07 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 29/49] regulator: ab8500-ext: Add support for AB9540 regulators
Date: Wed,  6 Feb 2013 10:53:51 +0000
Message-Id: <1360148051-7560-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Add the support for ab9540 external regulators.

Signed-off-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/regulator/ab8500-ext.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index f3ec867..e5e6453 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -298,6 +298,16 @@ static struct regulator_ops ab8500_ext_regulator_ops = {
 	.list_voltage		= ab8500_ext_list_voltage,
 };
 
+static struct regulator_ops ab9540_ext_regulator_ops = {
+	.enable			= ab8500_ext_regulator_enable,
+	.disable		= ab8500_ext_regulator_disable,
+	.is_enabled		= ab8500_ext_regulator_is_enabled,
+	.set_mode		= ab8500_ext_regulator_set_mode,
+	.get_mode		= ab8500_ext_regulator_get_mode,
+	.get_voltage		= ab8500_ext_fixed_get_voltage,
+	.list_voltage		= ab8500_ext_list_voltage,
+};
+
 static struct ab8500_ext_regulator_info
 		ab8500_ext_regulator_info[AB8500_NUM_EXT_REGULATORS] = {
 	[AB8500_EXT_SUPPLY1] = {
@@ -406,6 +416,20 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		info->cfg = (struct ab8500_ext_regulator_cfg *)
 			pdata->ext_regulator[i].driver_data;
 
+		if (is_ab9540(ab8500)) {
+			if (info->desc.id == AB8500_EXT_SUPPLY1) {
+				info->desc.ops = &ab9540_ext_regulator_ops;
+				info->fixed_uV = 4500000;
+			}
+			if (info->desc.id == AB8500_EXT_SUPPLY2)
+				info->desc.ops = &ab9540_ext_regulator_ops;
+
+			if (info->desc.id == AB8500_EXT_SUPPLY3) {
+				info->desc.ops = &ab9540_ext_regulator_ops;
+				info->fixed_uV = 3300000;
+			}
+		}
+
 		/* register regulator with framework */
 		info->rdev = regulator_register(&info->desc, &pdev->dev,
 				&pdata->ext_regulator[i], info, NULL);
-- 
1.7.9.5

