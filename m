Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaFXIcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:32:43 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59074 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFXIck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:32:40 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, spk.linux@gmail.com,
        anilkumar@ti.com, j-keerthy@ti.com
Subject: [PATCH 2/2] regulator: tps65218: Fix build warnings
Date: Tue, 24 Jun 2014 13:59:16 +0530
Message-Id: <1403598556-22536-2-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403598556-22536-1-git-send-email-sachin.kamat@samsung.com>
References: <1403598556-22536-1-git-send-email-sachin.kamat@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdev_get_id() returns an int. Convert rid to type int to avoid the
following warnings:
drivers/regulator/tps65218-regulator.c:132:10: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
drivers/regulator/tps65218-regulator.c:146:10: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/regulator/tps65218-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index 69b4b7750410..8b24404be0bd 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -127,7 +127,7 @@ static int tps65218_pmic_set_voltage_sel(struct regulator_dev *dev,
 static int tps65218_pmic_enable(struct regulator_dev *dev)
 {
 	struct tps65218 *tps = rdev_get_drvdata(dev);
-	unsigned int rid = rdev_get_id(dev);
+	int rid = rdev_get_id(dev);
 
 	if (rid < TPS65218_DCDC_1 || rid > TPS65218_LDO_1)
 		return -EINVAL;
@@ -141,7 +141,7 @@ static int tps65218_pmic_enable(struct regulator_dev *dev)
 static int tps65218_pmic_disable(struct regulator_dev *dev)
 {
 	struct tps65218 *tps = rdev_get_drvdata(dev);
-	unsigned int rid = rdev_get_id(dev);
+	int rid = rdev_get_id(dev);
 
 	if (rid < TPS65218_DCDC_1 || rid > TPS65218_LDO_1)
 		return -EINVAL;
-- 
1.7.9.5

