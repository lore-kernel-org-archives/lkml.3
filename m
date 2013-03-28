Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab3C1QSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:18:52 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:60620 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3C1QMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Michel JAOUEN <michel.jaouen@stericsson.com>
Subject: [PATCH 15/33] regulator: ab8500-ext: Add support for AB9540 regulators
Date: Thu, 28 Mar 2013 16:11:15 +0000
Message-Id: <1364487093-19551-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the support for ab9540 external regulators.

Signed-off-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/regulator/ab8500-ext.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index c73d544..993e9e4 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -299,6 +299,16 @@ static struct regulator_ops ab8500_ext_regulator_ops = {
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
@@ -409,6 +419,12 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		config.init_data = &pdata->ext_regulator[i];
 		config.driver_data = info;
 
+		if (is_ab9540(ab8500) &&
+		    ((info->desc.id == AB8500_EXT_SUPPLY1) ||
+		     (info->desc.id == AB8500_EXT_SUPPLY2) ||
+		     (info->desc.id == AB8500_EXT_SUPPLY3)))
+			info->desc.ops = &ab9540_ext_regulator_ops;
+
 		/* register regulator with framework */
 		info->rdev = regulator_register(&info->desc, &config);
 
-- 
1.7.10.4

