Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3ITEPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 00:15:25 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33507 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3ITEPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 00:15:24 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] regulator: tps6524x: Remove redundant spi_set_drvdata
Date: Fri, 20 Sep 2013 09:45:35 +0530
Message-Id: <1379650535-17223-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver core sets driver data to NULL upon failure or remove.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps6524x-regulator.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 62e8d28..8b9ee39 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -588,7 +588,6 @@ static int pmic_remove(struct spi_device *spi)
 		regulator_unregister(hw->rdev[i]);
 		hw->rdev[i] = NULL;
 	}
-	spi_set_drvdata(spi, NULL);
 	return 0;
 }
 
-- 
1.7.9.5

