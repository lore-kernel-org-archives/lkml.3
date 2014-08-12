Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaHLBlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 21:41:21 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33725 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHLBlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 21:41:20 -0400
Message-ID: <1407807670.8958.3.camel@phoenix>
Subject: [PATCH] regulator: tps65023: Remove duplicate test for
 I2C_FUNC_SMBUS_BYTE_DATA functionality
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>
Date: Tue, 12 Aug 2014 09:41:10 +0800
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
 drivers/regulator/tps65023-regulator.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 3ef67a8..7380af8 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -211,9 +211,6 @@ static int tps_65023_probe(struct i2c_client *client,
 	int i;
 	int error;
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
-		return -EIO;
-
 	/**
 	 * init_data points to array of regulator_init structures
 	 * coming from the board-evm file.
-- 
1.9.1



