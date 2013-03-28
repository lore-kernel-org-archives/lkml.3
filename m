Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3C1QMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51850 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab3C1QMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:39 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Alexandre Torgue <alexandre.torgue@stericsson.com>
Subject: [PATCH 22/33] regulator: ab8500: Also check for AB8505 based platforms
Date: Thu, 28 Mar 2013 16:11:22 +0000
Message-Id: <1364487093-19551-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 993e9e4..412a9ac 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -419,7 +419,7 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		config.init_data = &pdata->ext_regulator[i];
 		config.driver_data = info;
 
-		if (is_ab9540(ab8500) &&
+		if ((is_ab9540(ab8500) || is_ab8540(ab8500)) &&
 		    ((info->desc.id == AB8500_EXT_SUPPLY1) ||
 		     (info->desc.id == AB8500_EXT_SUPPLY2) ||
 		     (info->desc.id == AB8500_EXT_SUPPLY3)))
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 90f5263..be8351a 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2841,6 +2841,9 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
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

