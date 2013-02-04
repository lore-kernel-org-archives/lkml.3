Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3BDMBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:01:13 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42460 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3BDL5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:52 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Zhenhua HUANG <zhenhua.huang@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 62/73] regulator: ab8500: Remove vusb from AB8540 regulator framework
Date: Mon,  4 Feb 2013 11:54:17 +0000
Message-Id: <1359978868-28736-63-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhenhua HUANG <zhenhua.huang@stericsson.com>

This LDO is managed by accessory module with direct register accesses.

Signed-off-by: Zhenhua HUANG <zhenhua.huang@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
---
 drivers/regulator/ab8500.c       |   17 -----------------
 include/linux/regulator/ab8500.h |    1 -
 2 files changed, 18 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index fd8af4b..7d64d2e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1463,23 +1463,6 @@ static struct ab8500_regulator_info
 		.update_val_idle	= 0x82,
 		.update_val_normal	= 0x02,
 	},
-	[AB8540_LDO_USB] = {
-		.desc = {
-			.name           = "LDO-USB",
-			.ops            = &ab8500_regulator_ops,
-			.type           = REGULATOR_VOLTAGE,
-			.id             = AB8540_LDO_USB,
-			.owner          = THIS_MODULE,
-			.n_voltages     = 1,
-		},
-		.fixed_uV               = 3300000,
-		.update_bank            = 0x03,
-		.update_reg             = 0x82,
-		.update_mask            = 0x03,
-		.update_val		= 0x01,
-		.update_val_idle	= 0x03,
-		.update_val_normal	= 0x01,
-	},
 	[AB8540_LDO_AUDIO] = {
 		.desc = {
 			.name		= "LDO-AUDIO",
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 5977c47..bb0140c 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -76,7 +76,6 @@ enum ab8540_regulator_id {
 	AB8540_LDO_AUX4,
 	AB8540_LDO_INTCORE,
 	AB8540_LDO_TVOUT,
-	AB8540_LDO_USB,
 	AB8540_LDO_AUDIO,
 	AB8540_LDO_ANAMIC1,
 	AB8540_LDO_ANAMIC2,
-- 
1.7.9.5

