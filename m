Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab3EWP0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:26:01 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41939 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759629Ab3EWPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 16/16] mfd: max8925: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:17 +0100
Message-Id: <1369322717-30429-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max8925-i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index 92bbebd..8042b32 100644
--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -170,7 +170,8 @@ static int max8925_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	chip = kzalloc(sizeof(struct max8925_chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev,
+			    sizeof(struct max8925_chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 	chip->i2c = client;
@@ -199,7 +200,6 @@ static int max8925_remove(struct i2c_client *client)
 	max8925_device_exit(chip);
 	i2c_unregister_device(chip->adc);
 	i2c_unregister_device(chip->rtc);
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.10.4

