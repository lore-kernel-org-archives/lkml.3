Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3BDMMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:12:46 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:39186 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab3BDL4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:22 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/73] regulator: ab8500-ext: Add suspend support
Date: Mon,  4 Feb 2013 11:53:33 +0000
Message-Id: <1359978868-28736-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
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
index 5cb7d9c..29d5cd4 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -105,6 +105,13 @@ static int ab8500_ext_regulator_enable(struct regulator_dev *rdev)
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
@@ -150,6 +157,13 @@ static int ab8500_ext_regulator_disable(struct regulator_dev *rdev)
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
@@ -214,7 +228,9 @@ static int ab8500_ext_list_voltage(struct regulator_dev *rdev,
 
 static struct regulator_ops ab8500_ext_regulator_ops = {
 	.enable			= ab8500_ext_regulator_enable,
+	.set_suspend_enable	= ab8500_ext_regulator_set_suspend_enable,
 	.disable		= ab8500_ext_regulator_disable,
+	.set_suspend_disable	= ab8500_ext_regulator_set_suspend_disable,
 	.is_enabled		= ab8500_ext_regulator_is_enabled,
 	.get_voltage		= ab8500_ext_fixed_get_voltage,
 	.list_voltage		= ab8500_ext_list_voltage,
-- 
1.7.9.5

