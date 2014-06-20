Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967438AbaFTMDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:03:54 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41037 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967397AbaFTMDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:03:38 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 9/9] mfd: as3722: Rid driver of superfluous I2C device ID structure
Date: Fri, 20 Jun 2014 13:02:33 +0100
Message-Id: <1403265753-25851-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
References: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove unused second probe() parameter 'i2c_device_id'.

Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/as3722.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/as3722.c b/drivers/mfd/as3722.c
index 39fa554..cb2fcf9 100644
--- a/drivers/mfd/as3722.c
+++ b/drivers/mfd/as3722.c
@@ -354,8 +354,7 @@ static int as3722_i2c_of_probe(struct i2c_client *i2c,
 	return 0;
 }
 
-static int as3722_i2c_probe(struct i2c_client *i2c,
-			const struct i2c_device_id *id)
+static int as3722_i2c_probe(struct i2c_client *i2c)
 {
 	struct as3722 *as3722;
 	unsigned long irq_flags;
@@ -428,21 +427,14 @@ static const struct of_device_id as3722_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, as3722_of_match);
 
-static const struct i2c_device_id as3722_i2c_id[] = {
-	{ "as3722", 0 },
-	{},
-};
-MODULE_DEVICE_TABLE(i2c, as3722_i2c_id);
-
 static struct i2c_driver as3722_i2c_driver = {
 	.driver = {
 		.name = "as3722",
 		.owner = THIS_MODULE,
 		.of_match_table = as3722_of_match,
 	},
-	.probe = as3722_i2c_probe,
+	.probe2 = as3722_i2c_probe,
 	.remove = as3722_i2c_remove,
-	.id_table = as3722_i2c_id,
 };
 
 module_i2c_driver(as3722_i2c_driver);
-- 
1.8.3.2

