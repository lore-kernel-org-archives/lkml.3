Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaE2Lpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:45:47 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33930 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaE2Lpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:45:45 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] mfd: menelaus: Use module_i2c_driver
Date: Thu, 29 May 2014 17:13:22 +0530
Message-Id: <1401363802-18961-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_i2c_driver simplifies the code by eliminating
boilerplate code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/menelaus.c |   23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index ad25bfa3fb02..5e2667afe2bc 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1287,29 +1287,8 @@ static struct i2c_driver menelaus_i2c_driver = {
 	.id_table	= menelaus_id,
 };
 
-static int __init menelaus_init(void)
-{
-	int res;
-
-	res = i2c_add_driver(&menelaus_i2c_driver);
-	if (res < 0) {
-		pr_err(DRIVER_NAME ": driver registration failed\n");
-		return res;
-	}
-
-	return 0;
-}
-
-static void __exit menelaus_exit(void)
-{
-	i2c_del_driver(&menelaus_i2c_driver);
-
-	/* FIXME: Shutdown menelaus parts that can be shut down */
-}
+module_i2c_driver(menelaus_i2c_driver);
 
 MODULE_AUTHOR("Texas Instruments, Inc. (and others)");
 MODULE_DESCRIPTION("I2C interface for Menelaus.");
 MODULE_LICENSE("GPL");
-
-module_init(menelaus_init);
-module_exit(menelaus_exit);
-- 
1.7.9.5

