Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaBRKqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:46:46 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:32950 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaBRKqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:46:43 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 01/15] regulator: wm8350: Do not hardcode return value
Date: Tue, 18 Feb 2014 16:10:57 +0530
Message-Id: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the error value returned by the function instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/wm8350-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index de7b9c73e3fa..7ec7c390eeda 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -361,7 +361,7 @@ static int wm8350_dcdc_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 
 	sel = regulator_map_voltage_linear(rdev, uV, uV);
 	if (sel < 0)
-		return -EINVAL;
+		return sel;
 
 	/* all DCDCs have same mV bits */
 	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_DC1_VSEL_MASK;
@@ -574,7 +574,7 @@ static int wm8350_ldo_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 
 	sel = regulator_map_voltage_linear_range(rdev, uV, uV);
 	if (sel < 0)
-		return -EINVAL;
+		return sel;
 
 	/* all LDOs have same mV bits */
 	val = wm8350_reg_read(wm8350, volt_reg) & ~WM8350_LDO1_VSEL_MASK;
-- 
1.7.9.5

