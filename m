Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004Ab3BOMgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:36:18 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35094 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3BOMgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:36:17 -0500
Message-ID: <1360931766.3453.1.camel@phoenix>
Subject: [PATCH] regulator: max8925: Remove unused parameter from
 max8925_regulator_dt_init
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 15 Feb 2013 20:36:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The info parameter is not used at all, remove it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8925-regulator.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 0d5f64a..3597da8 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -246,7 +246,6 @@ static struct max8925_regulator_info max8925_regulator_info[] = {
 
 #ifdef CONFIG_OF
 static int max8925_regulator_dt_init(struct platform_device *pdev,
-				    struct max8925_regulator_info *info,
 				    struct regulator_config *config,
 				    int ridx)
 {
@@ -272,7 +271,7 @@ static int max8925_regulator_dt_init(struct platform_device *pdev,
 	return 0;
 }
 #else
-#define max8925_regulator_dt_init(w, x, y, z)	(-1)
+#define max8925_regulator_dt_init(x, y, z)	(-1)
 #endif
 
 static int max8925_regulator_probe(struct platform_device *pdev)
@@ -309,7 +308,7 @@ static int max8925_regulator_probe(struct platform_device *pdev)
 	config.dev = &pdev->dev;
 	config.driver_data = ri;
 
-	if (max8925_regulator_dt_init(pdev, ri, &config, regulator_idx))
+	if (max8925_regulator_dt_init(pdev, &config, regulator_idx))
 		if (pdata)
 			config.init_data = pdata;
 
-- 
1.7.9.5



