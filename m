Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab3DAP0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:26:31 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:52159 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3DAP0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:26:30 -0400
Message-ID: <1364829984.17176.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: lp8788: Remove lp8788_dldo_id and
 lp8788_aldo_id arrays
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 23:26:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The id for DLDOx matches the entries in enum lp8788_ldo_id and it's easy to
calculate the id for ALDOx. Thus remove lp8788_dldo_id and lp8788_aldo_id
arrays.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8788-ldo.c |   32 ++------------------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index fcba90a..c29aeae 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -156,34 +156,6 @@ static const int lp8788_aldo7_vtbl[] = {
 	1200000, 1300000, 1400000, 1500000, 1600000, 1700000, 1800000, 1800000,
 };
 
-static enum lp8788_ldo_id lp8788_dldo_id[] = {
-	DLDO1,
-	DLDO2,
-	DLDO3,
-	DLDO4,
-	DLDO5,
-	DLDO6,
-	DLDO7,
-	DLDO8,
-	DLDO9,
-	DLDO10,
-	DLDO11,
-	DLDO12,
-};
-
-static enum lp8788_ldo_id lp8788_aldo_id[] = {
-	ALDO1,
-	ALDO2,
-	ALDO3,
-	ALDO4,
-	ALDO5,
-	ALDO6,
-	ALDO7,
-	ALDO8,
-	ALDO9,
-	ALDO10,
-};
-
 static int lp8788_ldo_enable_time(struct regulator_dev *rdev)
 {
 	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
@@ -566,7 +538,7 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ldo->lp = lp;
-	ret = lp8788_config_ldo_enable_mode(pdev, ldo, lp8788_dldo_id[id]);
+	ret = lp8788_config_ldo_enable_mode(pdev, ldo, id);
 	if (ret)
 		return ret;
 
@@ -627,7 +599,7 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ldo->lp = lp;
-	ret = lp8788_config_ldo_enable_mode(pdev, ldo, lp8788_aldo_id[id]);
+	ret = lp8788_config_ldo_enable_mode(pdev, ldo, id + ALDO1);
 	if (ret)
 		return ret;
 
-- 
1.7.10.4



