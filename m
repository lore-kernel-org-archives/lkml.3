Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab3EWPZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:25:34 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54647 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3EWPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/16] mfd: 88pm860x: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:03 +0100
Message-Id: <1369322717-30429-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/mfd/88pm860x-core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 31ca555..ef6d82c 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1150,7 +1150,8 @@ static int pm860x_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	chip = kzalloc(sizeof(struct pm860x_chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev,
+			    sizeof(struct pm860x_chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 
@@ -1160,7 +1161,6 @@ static int pm860x_probe(struct i2c_client *client,
 		ret = PTR_ERR(chip->regmap);
 		dev_err(&client->dev, "Failed to allocate register map: %d\n",
 				ret);
-		kfree(chip);
 		return ret;
 	}
 	chip->client = client;
@@ -1204,7 +1204,6 @@ static int pm860x_remove(struct i2c_client *client)
 		i2c_unregister_device(chip->companion);
 	}
 	regmap_exit(chip->regmap);
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.10.4

