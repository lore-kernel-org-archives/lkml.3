Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3BDL5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:18 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39728 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab3BDL5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:12 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Zhenhua HUANG <zhenhua.huang@stericsson.com>
Subject: [PATCH 43/73] regulator: ab8500: Add VSDIO definition for the AB8540
Date: Mon,  4 Feb 2013 11:53:58 +0000
Message-Id: <1359978868-28736-44-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the definitions for VSDIO to Regulator Framework for AB8540.

Signed-off-by: Zhenhua HUANG <zhenhua.huang@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Xiao Mei ZHANG <xiaomei.zhang@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Reviewed-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
---
 drivers/regulator/ab8500.c       |   35 +++++++++++++++++++++++++++++++++++
 include/linux/regulator/ab8500.h |    1 +
 2 files changed, 36 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 1f1f361..2a08642 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -132,6 +132,17 @@ static const unsigned int ldo_vintcore_voltages[] = {
 	1350000,
 };
 
+static const int ldo_sdio_voltages[] = {
+	1160000,
+	1050000,
+	1100000,
+	1500000,
+	1800000,
+	2200000,
+	2910000,
+	3050000,
+};
+
 static int ab8500_regulator_enable(struct regulator_dev *rdev)
 {
 	int ret;
@@ -1409,6 +1420,30 @@ static struct ab8500_regulator_info
 		.update_val_idle	= 0x0c,
 		.update_val_normal	= 0x04,
 	},
+	[AB8540_LDO_SDIO] = {
+		.desc = {
+			.name		= "LDO-SDIO",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8540_LDO_SDIO,
+			.owner		= THIS_MODULE,
+			.n_voltages = ARRAY_SIZE(ldo_sdio_voltages),
+		},
+		.min_uV			= 1050000,
+		.max_uV			= 3050000,
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x88,
+		.update_mask		= 0x30,
+		.update_val		= 0x10,
+		.update_val_idle	= 0x00,
+		.update_val_normal	= 0x20,
+		.voltage_bank		= 0x03,
+		.voltage_reg		= 0x88,
+		.voltage_mask		= 0x07,
+		.voltages		= ldo_sdio_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_sdio_voltages),
+	},
 };
 
 struct ab8500_reg_init {
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index e3d4a5b..caa9f6a 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -82,6 +82,7 @@ enum ab8540_regulator_id {
 	AB8540_LDO_ANAMIC2,
 	AB8540_LDO_DMIC,
 	AB8540_LDO_ANA,
+	AB8540_LDO_SDIO,
 	AB8540_SYSCLKREQ_2,
 	AB8540_SYSCLKREQ_4,
 	AB8540_NUM_REGULATORS,
-- 
1.7.9.5

