Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579Ab3EWPZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:25:44 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:63639 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3EWPZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/16] mfd: adp5520: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:08 +0100
Message-Id: <1369322717-30429-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/adp5520.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 0d2eba0..28346ad 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -223,7 +223,7 @@ static int adp5520_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -244,7 +244,7 @@ static int adp5520_probe(struct i2c_client *client,
 		if (ret) {
 			dev_err(&client->dev, "failed to request irq %d\n",
 					chip->irq);
-			goto out_free_chip;
+			return ret;
 		}
 	}
 
@@ -302,9 +302,6 @@ out_free_irq:
 	if (chip->irq)
 		free_irq(chip->irq, chip);
 
-out_free_chip:
-	kfree(chip);
-
 	return ret;
 }
 
@@ -317,7 +314,6 @@ static int adp5520_remove(struct i2c_client *client)
 
 	adp5520_remove_subdevs(chip);
 	adp5520_write(chip->dev, ADP5520_MODE_STATUS, 0);
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.10.4

