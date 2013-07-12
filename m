Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab3GLLcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:32:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51897 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab3GLLcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:32:09 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] MFD: twl6040: Cleanup in early error handling in probe function
Date: Fri, 12 Jul 2013 13:32:04 +0200
Message-ID: <1373628724-11397-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1373628724-11397-1-git-send-email-peter.ujfalusi@ti.com>
References: <1373628724-11397-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The err: label is not needed we can just return instead of the jump there.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 3bd110e..4d8d3b7 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -533,16 +533,12 @@ static int twl6040_probe(struct i2c_client *client,
 
 	twl6040 = devm_kzalloc(&client->dev, sizeof(struct twl6040),
 			       GFP_KERNEL);
-	if (!twl6040) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (!twl6040)
+		return -ENOMEM;
 
 	twl6040->regmap = devm_regmap_init_i2c(client, &twl6040_regmap_config);
-	if (IS_ERR(twl6040->regmap)) {
-		ret = PTR_ERR(twl6040->regmap);
-		goto err;
-	}
+	if (IS_ERR(twl6040->regmap))
+		return PTR_ERR(twl6040->regmap);
 
 	i2c_set_clientdata(client, twl6040);
 
@@ -660,7 +656,7 @@ gpio_err:
 	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
 regulator_get_err:
 	i2c_set_clientdata(client, NULL);
-err:
+
 	return ret;
 }
 
-- 
1.8.2.1

