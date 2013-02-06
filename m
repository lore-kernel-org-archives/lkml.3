Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3BFKzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:04 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52669 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab3BFKyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:54 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/49] regulator: ab8500-ext: Add suspend support
Date: Wed,  6 Feb 2013 10:53:34 +0000
Message-Id: <1360148051-7560-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
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
index 303c02c..3af40fd 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -104,6 +104,13 @@ static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
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
@@ -149,6 +156,13 @@ static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
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
@@ -274,7 +288,9 @@ static int ab8500_ext_list_voltage(struct regulator_dev *rdev,
 
 static struct regulator_ops ab8500_ext_regulator_ops = {
 	.enable			= ab8500_ext_regulator_enable,
+	.set_suspend_enable	= ab8500_ext_regulator_set_suspend_enable,
 	.disable		= ab8500_ext_regulator_disable,
+	.set_suspend_disable	= ab8500_ext_regulator_set_suspend_disable,
 	.is_enabled		= ab8500_ext_regulator_is_enabled,
 	.set_mode		= ab8500_ext_regulator_set_mode,
 	.get_mode		= ab8500_ext_regulator_get_mode,
-- 
1.7.9.5

