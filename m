Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab3CUQBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:01:13 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51482 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab3CUQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:01:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        "xiaomei.zhang" <xiaomei.zhang@stericsson.com>,
        Alexandre Torgue <alexandre.torgue@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 33/46] regulator: ab8500: Also check for AB8505 based platforms
Date: Thu, 21 Mar 2013 15:59:30 +0000
Message-Id: <1363881583-15234-34-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "xiaomei.zhang" <xiaomei.zhang@stericsson.com>

Ensure we initialise AB8505 external supply regulators.

Signed-off-by: Alexandre Torgue <alexandre.torgue@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Xiao Mei ZHANG <xiaomei.zhang@stericsson.com>
---
 drivers/regulator/ab8500-ext.c |    2 +-
 drivers/regulator/ab8500.c     |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index f75d4f7..ce1830f 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -414,7 +414,7 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		info->cfg = (struct ab8500_ext_regulator_cfg *)
 			pdata->ext_regulator[i].driver_data;
 
-		if (is_ab9540(ab8500)) {
+		if ((is_ab9540(ab8500)) || (is_ab8540(ab8500))) {
 			if (info->desc.id == AB8500_EXT_SUPPLY1)
 				info->desc.ops = &ab9540_ext_regulator_ops;
 			if (info->desc.id == AB8500_EXT_SUPPLY2) {
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 84393a6..c9c594d 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2842,6 +2842,9 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 	} else if (is_ab8505(ab8500)) {
 		regulator_info = ab8505_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
+	} else if (is_ab8540(ab8500)) {
+		regulator_info = ab8540_regulator_info;
+		regulator_info_size = ARRAY_SIZE(ab8540_regulator_info);
 	} else {
 		regulator_info = ab8500_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
-- 
1.7.10.4

