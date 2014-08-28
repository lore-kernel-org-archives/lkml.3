Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaH1OgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:36:23 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:49392 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaH1OgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:36:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wsa@the-dreams.de,
        grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH 8/8] mfd: as3722: Rid driver of superfluous I2C device ID structure
Date: Thu, 28 Aug 2014 15:35:38 +0100
Message-Id: <1409236538-21274-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
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
1.9.1

