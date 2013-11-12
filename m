Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3KLRpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:45:47 -0500
Received: from mout.gmx.net ([212.227.17.20]:53124 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab3KLRpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:45:43 -0500
From: Andreas Werner <wernerandy@gmx.de>
To: wsa@the-dreams.de
Cc: jacmet@sunsite.dk, marex@denx.de, baohua.song@csr.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        wernerandy@gmx.de
Subject: [PATCH] I2C: busses: Do not print error message in syslog if no ACK received
Date: Tue, 12 Nov 2013 18:45:36 +0100
Message-Id: <1384278336-3694-1-git-send-email-wernerandy@gmx.de>
X-Mailer: git-send-email 1.8.4
X-Provags-ID: V03:K0:YzlqrK9yqvyeSfxIj1m1oVft2jNGsIcOwLUNzoAKUtv7xXcs7Z9
 OonCrcNtPJANNwOk4CKplkSa49+iHnWwk5MNXT9wrudgxpSxj3mUsDJ+q0uVo8MiNFOo+yC
 Np3CiT8XKbNf3SdVzpSVgDOd1u/AIE/S6fIS7p8urSvYYfO29F1IN270wRJJ45JDWvN8eSl
 Pajmf0zj9x/ENe2YU4G9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the i2c-eg20t driver and call i2cdetect or probe on the bus,
the driver will print a lot of error messages if there was no ACK
received.

i2cdetect normally print a table with all the available devices. If there
is no device on the address, the table will be empty.
Currently with the i2c-eg20t driver, the table is not visible because
the error messages destroy the table.

Error message: pch_i2c_getack return -71

This patch prevent the driver to print the messages to syslog if debug is not set.

Tested on Intel Atom E6xx and Eg20t Chipset.

Signed-off-by: Andreas Werner <wernerandy@gmx.de>
---
 drivers/i2c/busses/i2c-eg20t.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 0f37529..b10c651 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -322,7 +322,7 @@ static s32 pch_i2c_getack(struct i2c_algo_pch_data *adap)
 	reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
 
 	if (reg_val != 0) {
-		pch_err(adap, "return%d\n", -EPROTO);
+		pch_dbg(adap, "return%d\n", -EPROTO);
 		return -EPROTO;
 	}
 
-- 
1.8.4

