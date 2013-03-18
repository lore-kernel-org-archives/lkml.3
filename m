Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab3CRVgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:36:18 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:61144 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab3CRVgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:36:14 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: regulator: Use PTR_RET function
Date: Mon, 18 Mar 2013 23:35:31 +0200
Message-Id: <1363642532-8301-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/regulator/fan53555.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 9165b0c..f0e1ae5 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -219,9 +219,7 @@ static int fan53555_regulator_register(struct fan53555_device_info *di,
 	rdesc->owner = THIS_MODULE;
 
 	di->rdev = regulator_register(&di->desc, config);
-	if (IS_ERR(di->rdev))
-		return PTR_ERR(di->rdev);
-	return 0;
+	return PTR_RET(di->rdev);
 
 }
 
-- 
1.7.9.5

