Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab3CZH61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:58:27 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37709 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab3CZH60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:58:26 -0400
Message-ID: <1364284700.27005.1.camel@phoenix>
Subject: [PATCH] regulator: ab8500: Don't update is_enabled flag in error
 paths
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 15:58:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoid setting is_enabled flag to wrong status if enable/disable fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 12e2740..5e7e84b 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -121,7 +121,8 @@ static int ab8500_regulator_enable(struct regulator_dev *rdev)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set enable bits for regulator\n");
 
-	info->is_enabled = true;
+	if (ret == 0)
+		info->is_enabled = true;
 
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-enable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
@@ -148,7 +149,8 @@ static int ab8500_regulator_disable(struct regulator_dev *rdev)
 		dev_err(rdev_get_dev(rdev),
 			"couldn't set disable bits for regulator\n");
 
-	info->is_enabled = false;
+	if (ret == 0)
+		info->is_enabled = false;
 
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-disable (bank, reg, mask, value): 0x%x, 0x%x, 0x%x, 0x%x\n",
-- 
1.7.10.4



