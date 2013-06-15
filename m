Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3FOOX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:23:26 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1041 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3FOOXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:23:22 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7545
From: Lars-Peter Clausen <lars@metafoo.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Peter Huewe <peter.huewe@infineon.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] tpm: tpm_i2c_infinion: Don't modify i2c_client->driver
Date: Sat, 15 Jun 2013 16:23:24 +0200
Message-Id: <1371306204-7547-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C client driver is not supposed to modify the client's driver pointer,
this is handled by the I2C core.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/char/tpm/tpm_i2c_infineon.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 37d5dcc..dbc7042 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -74,7 +74,6 @@ struct tpm_inf_dev {
 };
 
 static struct tpm_inf_dev tpm_dev;
-static struct i2c_driver tpm_tis_i2c_driver;
 
 /*
  * iic_tpm_read() - read from TPM register
@@ -744,11 +743,9 @@ static int tpm_tis_i2c_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	client->driver = &tpm_tis_i2c_driver;
 	tpm_dev.client = client;
 	rc = tpm_tis_i2c_init(&client->dev);
 	if (rc != 0) {
-		client->driver = NULL;
 		tpm_dev.client = NULL;
 		rc = -ENODEV;
 	}
-- 
1.8.0

