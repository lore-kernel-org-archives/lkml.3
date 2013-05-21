Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3EUSok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:44:40 -0400
Received: from sauhun.de ([89.238.76.85]:60785 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3EUSoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:44:39 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/mfd: Remove obsolete cleanup for clientdata
Date: Tue, 21 May 2013 20:45:41 +0200
Message-Id: <1369161945-26671-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369161945-26671-1-git-send-email-wsa@the-dreams.de>
References: <1369161945-26671-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit or error. This is obsolete meanwhile, the core will do it.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/mfd/twl6040.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 492ee2c..eec7de2 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -558,13 +558,13 @@ static int twl6040_probe(struct i2c_client *client,
 				 twl6040->supplies);
 	if (ret != 0) {
 		dev_err(&client->dev, "Failed to get supplies: %d\n", ret);
-		goto regulator_get_err;
+		goto err;
 	}
 
 	ret = regulator_bulk_enable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
 	if (ret != 0) {
 		dev_err(&client->dev, "Failed to enable supplies: %d\n", ret);
-		goto regulator_get_err;
+		goto err;
 	}
 
 	twl6040->dev = &client->dev;
@@ -688,8 +688,6 @@ readyirq_err:
 	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
 gpio_err:
 	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
-regulator_get_err:
-	i2c_set_clientdata(client, NULL);
 err:
 	return ret;
 }
@@ -706,7 +704,6 @@ static int twl6040_remove(struct i2c_client *client)
 	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
 
 	mfd_remove_devices(&client->dev);
-	i2c_set_clientdata(client, NULL);
 
 	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
 
-- 
1.7.10.4

