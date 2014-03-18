Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaCRK3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:29:33 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64812 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaCRK33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:29:29 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 2/4] regulator: max8660: Silence checkpatch warnings
Date: Tue, 18 Mar 2014 15:53:02 +0530
Message-Id: <1395138184-25287-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395138184-25287-1-git-send-email-sachin.kamat@linaro.org>
References: <1395138184-25287-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following type of error/warnings:
ERROR: that open brace { should be on the previous line
WARNING: Missing a blank line after declarations

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8660.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index bbbe53b1b5bf..aabfb3b2407c 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -85,11 +85,12 @@ struct max8660 {
 
 static int max8660_write(struct max8660 *max8660, u8 reg, u8 mask, u8 val)
 {
-	static const u8 max8660_addresses[MAX8660_N_REGS] =
-	  { 0x10, 0x12, 0x20, 0x23, 0x24, 0x29, 0x2a, 0x32, 0x33, 0x39, 0x80 };
+	static const u8 max8660_addresses[MAX8660_N_REGS] = {
+	  0x10, 0x12, 0x20, 0x23, 0x24, 0x29, 0x2a, 0x32, 0x33, 0x39, 0x80 };
 
 	int ret;
 	u8 reg_val = (max8660->shadow_regs[reg] & mask) | val;
+
 	dev_vdbg(&max8660->client->dev, "Writing reg %02x with %02x\n",
 			max8660_addresses[reg], reg_val);
 
@@ -111,6 +112,7 @@ static int max8660_dcdc_is_enabled(struct regulator_dev *rdev)
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
 	u8 val = max8660->shadow_regs[MAX8660_OVER1];
 	u8 mask = (rdev_get_id(rdev) == MAX8660_V3) ? 1 : 4;
+
 	return !!(val & mask);
 }
 
@@ -118,6 +120,7 @@ static int max8660_dcdc_enable(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
 	u8 bit = (rdev_get_id(rdev) == MAX8660_V3) ? 1 : 4;
+
 	return max8660_write(max8660, MAX8660_OVER1, 0xff, bit);
 }
 
@@ -125,15 +128,16 @@ static int max8660_dcdc_disable(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
 	u8 mask = (rdev_get_id(rdev) == MAX8660_V3) ? ~1 : ~4;
+
 	return max8660_write(max8660, MAX8660_OVER1, mask, 0);
 }
 
 static int max8660_dcdc_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
-
 	u8 reg = (rdev_get_id(rdev) == MAX8660_V3) ? MAX8660_ADTV2 : MAX8660_SDTV2;
 	u8 selector = max8660->shadow_regs[reg];
+
 	return selector;
 }
 
@@ -206,6 +210,7 @@ static int max8660_ldo67_is_enabled(struct regulator_dev *rdev)
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
 	u8 val = max8660->shadow_regs[MAX8660_OVER2];
 	u8 mask = (rdev_get_id(rdev) == MAX8660_V6) ? 2 : 4;
+
 	return !!(val & mask);
 }
 
@@ -213,6 +218,7 @@ static int max8660_ldo67_enable(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
 	u8 bit = (rdev_get_id(rdev) == MAX8660_V6) ? 2 : 4;
+
 	return max8660_write(max8660, MAX8660_OVER2, 0xff, bit);
 }
 
@@ -220,15 +226,16 @@ static int max8660_ldo67_disable(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
 	u8 mask = (rdev_get_id(rdev) == MAX8660_V6) ? ~2 : ~4;
+
 	return max8660_write(max8660, MAX8660_OVER2, mask, 0);
 }
 
 static int max8660_ldo67_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8660 *max8660 = rdev_get_drvdata(rdev);
-
 	u8 shift = (rdev_get_id(rdev) == MAX8660_V6) ? 0 : 4;
 	u8 selector = (max8660->shadow_regs[MAX8660_L12VCR] >> shift) & 0xf;
+
 	return selector;
 }
 
-- 
1.7.9.5

