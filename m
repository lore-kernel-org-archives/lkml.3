Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3C1QM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:28 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41675 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab3C1QMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 08/33] regulator: ab8500: Remove USB regulator
Date: Thu, 28 Mar 2013 16:11:08 +0000
Message-Id: <1364487093-19551-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB regulator is controlled by hardware. The software support
was only needed for early hardware (ED) which is no longer supported.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c       |   20 --------------------
 include/linux/regulator/ab8500.h |    1 -
 2 files changed, 21 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 4974688..4d88a60 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -488,25 +488,6 @@ static struct ab8500_regulator_info
 		.update_val_idle	= 0x82,
 		.update_val_normal	= 0x02,
 	},
-
-	/*
-	 * Regulators with fixed voltage and normal mode
-	 */
-	[AB8500_LDO_USB] = {
-		.desc = {
-			.name           = "LDO-USB",
-			.ops            = &ab8500_regulator_ops,
-			.type           = REGULATOR_VOLTAGE,
-			.id             = AB8500_LDO_USB,
-			.owner          = THIS_MODULE,
-			.n_voltages     = 1,
-			.min_uV		= 3300000,
-			.enable_time	= 150,
-		},
-		.update_bank            = 0x03,
-		.update_reg             = 0x82,
-		.update_mask            = 0x03,
-	},
 	[AB8500_LDO_AUDIO] = {
 		.desc = {
 			.name		= "LDO-AUDIO",
@@ -862,7 +843,6 @@ static struct of_regulator_match ab8500_regulator_matches[] = {
 	{ .name	= "ab8500_ldo_aux3",    .driver_data = (void *) AB8500_LDO_AUX3, },
 	{ .name	= "ab8500_ldo_intcore", .driver_data = (void *) AB8500_LDO_INTCORE, },
 	{ .name	= "ab8500_ldo_tvout",   .driver_data = (void *) AB8500_LDO_TVOUT, },
-	{ .name = "ab8500_ldo_usb",     .driver_data = (void *) AB8500_LDO_USB, },
 	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8500_LDO_AUDIO, },
 	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8500_LDO_ANAMIC1, },
 	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8500_LDO_ANAMIC2, },
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index cf496e9..b86e089 100644
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
1.7.10.4

