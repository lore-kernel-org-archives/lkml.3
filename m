Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3C1QWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:22:48 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47925 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab3C1QMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/33] regulator: ab8500-ext: Add suspend support
Date: Thu, 28 Mar 2013 16:11:07 +0000
Message-Id: <1364487093-19551-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Operations regulator_suspend_enable and regulator_suspend_disable
are added.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias NILSSON <mattias.i.nilsson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/regulator/ab8500-ext.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 21b9bfb..95fe706 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -102,6 +102,13 @@ static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
 	return ret;
 }
 
+static int ab8500_ext_regulator_set_suspend_enable(struct regulator_dev *rdev)
+{
+	dev_dbg(rdev_get_dev(rdev), "suspend: ");
+
+	return ab8500_ext_regulator_enable(rdev);
+}
+
 static int disable(struct ab8500_ext_regulator_info *info, u8 *regval)
 {
 	int ret;
@@ -147,6 +154,13 @@ static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
 	return ret;
 }
 
+static int ab8500_ext_regulator_set_suspend_disable(struct regulator_dev *rdev)
+{
+	dev_dbg(rdev_get_dev(rdev), "suspend: ");
+
+	return ab8500_ext_regulator_disable(rdev);
+}
+
 static int ab8500_ext_regulator_is_enabled(struct regulator_dev *rdev)
 {
 	int ret;
@@ -275,7 +289,9 @@ static int ab8500_ext_list_voltage(struct regulator_dev *rdev,
 
 static struct regulator_ops ab8500_ext_regulator_ops = {
 	.enable			= ab8500_ext_regulator_enable,
+	.set_suspend_enable	= ab8500_ext_regulator_set_suspend_enable,
 	.disable		= ab8500_ext_regulator_disable,
+	.set_suspend_disable	= ab8500_ext_regulator_set_suspend_disable,
 	.is_enabled		= ab8500_ext_regulator_is_enabled,
 	.set_mode		= ab8500_ext_regulator_set_mode,
 	.get_mode		= ab8500_ext_regulator_get_mode,
-- 
1.7.10.4

