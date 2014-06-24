Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaFXIci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:32:38 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35671 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFXIcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:32:36 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, spk.linux@gmail.com,
        anilkumar@ti.com, j-keerthy@ti.com
Subject: [PATCH 1/2] regulator: tps65217: Fix build warnings
Date: Tue, 24 Jun 2014 13:59:15 +0530
Message-Id: <1403598556-22536-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdev_get_id() returns an int. Convert rid to type int to avoid the
following warnings:

drivers/regulator/tps65217-regulator.c:73:10: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
drivers/regulator/tps65217-regulator.c:87:10: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
Series compile tested.
---
 drivers/regulator/tps65217-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index f7ed20a5a8b9..d58db72a63b0 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -68,7 +68,7 @@ static const struct regulator_linear_range tps65217_uv2_ranges[] = {
 static int tps65217_pmic_enable(struct regulator_dev *dev)
 {
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int rid = rdev_get_id(dev);
+	int rid = rdev_get_id(dev);
 
 	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
@@ -82,7 +82,7 @@ static int tps65217_pmic_enable(struct regulator_dev *dev)
 static int tps65217_pmic_disable(struct regulator_dev *dev)
 {
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int rid = rdev_get_id(dev);
+	int rid = rdev_get_id(dev);
 
 	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
-- 
1.7.9.5

