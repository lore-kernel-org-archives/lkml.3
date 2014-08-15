Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaHONx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:53:27 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39263 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaHONx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:53:26 -0400
Message-ID: <1408110797.6965.1.camel@phoenix>
Subject: [PATCH] mfd: da9052-i2c: Remove duplicate test for
 I2C_FUNC_SMBUS_BYTE_DATA functionality
From: Axel Lin <axel.lin@ingics.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 15 Aug 2014 21:53:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit b42261078a91 ("regmap: i2c: fallback to SMBus if the adapter
does not support standard I2C"), regmap-i2c will check the
I2C_FUNC_SMBUS_[BYTE|WORD]_DATA functionality based on the regmap_config
setting if the adapter does not support standard I2C.

So remove the I2C_FUNC_SMBUS_BYTE_DATA functionality check in the driver code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/da9052-i2c.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 6da8ec8..ec39287 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -140,13 +140,6 @@ static int da9052_i2c_probe(struct i2c_client *client,
 	if (!da9052)
 		return -ENOMEM;
 
-	if (!i2c_check_functionality(client->adapter,
-				     I2C_FUNC_SMBUS_BYTE_DATA)) {
-		dev_info(&client->dev, "Error in %s:i2c_check_functionality\n",
-			 __func__);
-		return  -ENODEV;
-	}
-
 	da9052->dev = &client->dev;
 	da9052->chip_irq = client->irq;
 	da9052->fix_io = da9052_i2c_fix;
-- 
1.9.1



