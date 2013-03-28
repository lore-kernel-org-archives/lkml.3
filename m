Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3C1QOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:14:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44551 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab3C1QMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:52 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 29/33] regulator: ab8500: Remove the need for a 'delay' property
Date: Thu, 28 Mar 2013 16:11:29 +0000
Message-Id: <1364487093-19551-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator framework now has provisions to read a regulator's
start-up time via the 'enable_time' attribute. So let's remove all
'enable_time'/'delay' duplication and just stick with 'enable_time'
from now on.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 8a9cd45..7892a51 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -654,7 +654,7 @@ static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 {
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
 
-	return info->delay;
+	return info->desc.enable_time;
 }
 
 static struct regulator_ops ab8500_regulator_volt_mode_ops = {
@@ -1108,7 +1108,6 @@ static struct ab8500_regulator_info
 			.volt_table	= fixed_2000000_voltage,
 			.enable_time	= 10000,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1374,7 +1373,6 @@ static struct ab8500_regulator_info
 			.volt_table	= fixed_2000000_voltage,
 			.enable_time	= 10000,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
@@ -1672,7 +1670,6 @@ static struct ab8500_regulator_info
 			.n_voltages	= 1,
 			.enable_time	= 10000,
 		},
-		.delay			= 10000,
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
-- 
1.7.10.4

