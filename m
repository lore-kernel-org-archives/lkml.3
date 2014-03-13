Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaCMIHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:07:21 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:61405 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaCMIHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:07:14 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] power: bq24190: Remove gratuitous dummy function
Date: Thu, 13 Mar 2014 09:07:10 +0100
Message-Id: <1394698031-1313-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Check for OF support using IS_ENABLED(CONFIG_OF). This will enable the
compiler to eliminate dead code if OF support is disabled. With that in
place, the dummy implementation of bq24190_setup_dt() for non-DT setups
can be removed as the compiler will automatically discard the function
when appropriate.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/power/bq24190_charger.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/power/bq24190_charger.c b/drivers/power/bq24190_charger.c
index ad3ff8fbfbbb..f5b21c0d0ba3 100644
--- a/drivers/power/bq24190_charger.c
+++ b/drivers/power/bq24190_charger.c
@@ -1312,7 +1312,6 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_OF
 static int bq24190_setup_dt(struct bq24190_dev_info *bdi)
 {
 	bdi->irq = irq_of_parse_and_map(bdi->dev->of_node, 0);
@@ -1321,12 +1320,6 @@ static int bq24190_setup_dt(struct bq24190_dev_info *bdi)
 
 	return 0;
 }
-#else
-static int bq24190_setup_dt(struct bq24190_dev_info *bdi)
-{
-	return -1;
-}
-#endif
 
 static int bq24190_setup_pdata(struct bq24190_dev_info *bdi,
 		struct bq24190_platform_data *pdata)
@@ -1388,7 +1381,7 @@ static int bq24190_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, bdi);
 
-	if (dev->of_node)
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
 		ret = bq24190_setup_dt(bdi);
 	else
 		ret = bq24190_setup_pdata(bdi, pdata);
-- 
1.8.4.2

