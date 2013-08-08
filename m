Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab3HHKCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:02:33 -0400
Received: from svenfoo.org ([82.94.215.22]:55455 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934100Ab3HHKCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:02:32 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, fengguang.wu@intel.com, Daniel Mack <zonque@gmail.com>
Subject: [PATCH] regulators: max8660: fix build warnings
Date: Thu,  8 Aug 2013 12:02:18 +0200
Message-Id: <1375956138-12677-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a build warning for !CONFIG_OF and a cast from void* to
unsigned int which is invalid on 64bit machines.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/regulator/max8660.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 7e6177e..aa8d823 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -364,7 +364,7 @@ static int max8660_pdata_from_dt(struct device *dev,
 #else
 static inline int max8660_pdata_from_dt(struct device *dev,
 					struct device_node **of_node,
-					struct max8660_platform_data **pdata)
+					struct max8660_platform_data *pdata)
 {
 	return 0;
 }
@@ -380,7 +380,7 @@ static int max8660_probe(struct i2c_client *client,
 	struct max8660 *max8660;
 	int boot_on, i, id, ret = -EINVAL;
 	struct device_node *of_node[MAX8660_V_END];
-	unsigned int type;
+	unsigned long type;
 
 	if (dev->of_node && !pdata) {
 		const struct of_device_id *id;
@@ -395,7 +395,7 @@ static int max8660_probe(struct i2c_client *client,
 			return ret;
 
 		pdata = &pdata_of;
-		type = (unsigned int) id->data;
+		type = (unsigned long) id->data;
 	} else {
 		type = i2c_id->driver_data;
 		memset(of_node, 0, sizeof(of_node));
-- 
1.8.3.1

