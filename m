Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3BFKzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:08 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62638 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3BFKy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:54:56 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/49] regulator: ab8500: Remove USB regulator
Date: Wed,  6 Feb 2013 10:53:35 +0000
Message-Id: <1360148051-7560-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

The USB regulator is controlled by hardware. The software support
was only needed for early hardware (ED) which is no longer supported.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c       |   20 --------------------
 include/linux/regulator/ab8500.h |    1 -
 2 files changed, 21 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 1d73067..48dd0ed 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -494,25 +494,6 @@ static struct ab8500_regulator_info
 		.update_val_idle	= 0x82,
 		.update_val_normal	= 0x02,
 	},
-	[AB8500_LDO_USB] = {
-		.desc = {
-			.name           = "LDO-USB",
-			.ops            = &ab8500_regulator_fixed_ops,
-			.type           = REGULATOR_VOLTAGE,
-			.id             = AB8500_LDO_USB,
-			.owner          = THIS_MODULE,
-			.n_voltages     = 1,
-			.min_uV		= 3300000,
-		},
-		.update_bank            = 0x03,
-		.update_reg             = 0x82,
-		.update_mask            = 0x03,
-		.update_val_enable      = 0x01,
-	},
-
-	/*
-	 * Regulators with fixed voltage and normal mode
-	 */
 	[AB8500_LDO_AUDIO] = {
 		.desc = {
 			.name		= "LDO-AUDIO",
@@ -913,7 +894,6 @@ static struct of_regulator_match ab8500_regulator_matches[] = {
 	{ .name	= "ab8500_ldo_aux3",    .driver_data = (void *) AB8500_LDO_AUX3, },
 	{ .name	= "ab8500_ldo_intcore", .driver_data = (void *) AB8500_LDO_INTCORE, },
 	{ .name	= "ab8500_ldo_tvout",   .driver_data = (void *) AB8500_LDO_TVOUT, },
-	{ .name = "ab8500_ldo_usb",     .driver_data = (void *) AB8500_LDO_USB, },
 	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8500_LDO_AUDIO, },
 	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8500_LDO_ANAMIC1, },
 	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8500_LDO_ANAMIC2, },
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 0a58db2..9a2da6a 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -19,7 +19,6 @@ enum ab8500_regulator_id {
 	AB8500_LDO_AUX3,
 	AB8500_LDO_INTCORE,
 	AB8500_LDO_TVOUT,
-	AB8500_LDO_USB,
 	AB8500_LDO_AUDIO,
 	AB8500_LDO_ANAMIC1,
 	AB8500_LDO_ANAMIC2,
-- 
1.7.9.5

