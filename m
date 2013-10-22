Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3JVSA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:00:59 -0400
Received: from mout.gmx.net ([212.227.17.22]:52856 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab3JVSA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:00:58 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 06/15] tpm: Remove redundant dev_set_drvdata
Date: Tue, 22 Oct 2013 20:00:31 +0200
Message-Id: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
X-Provags-ID: V03:K0:LNxCNKVrrxXRCwALW7BWMOOQTTr3qpnNRhmnhndVpFQejm8j54q
 dtjaI7cLtOsxnTWVGB65Qoum8lxsVvZYaIzVQjXC3fkg9blidwANkv0Vny3bV9uhz/Y5Hsj
 VtbpbJsk+KcQlEr4LiZ8RPXiilH1oSlSGQwUCTfOlDsZl0sngR8Z8F3z2oWTK1z1ew1d6Sw
 D6j1FE64CgObutwNzxlug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

TPM drivers should not call dev_set_drvdata (or aliases), only the core
code is allowed to call dev_set_drvdata, and it does it during
tpm_register_hardware.

These extra sets are harmless, but are an anti-pattern that many drivers
have copied.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_i2c_infineon.c |    2 --
 drivers/char/tpm/tpm_i2c_stm_st33.c |    2 --
 drivers/char/tpm/xen-tpmfront.c     |    2 --
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index b8735de..e33d8e5 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -685,7 +685,6 @@ out_vendor:
 	chip->dev->release = NULL;
 	chip->release = NULL;
 	tpm_dev.client = NULL;
-	dev_set_drvdata(chip->dev, chip);
 out_err:
 	return rc;
 }
@@ -766,7 +765,6 @@ static int tpm_tis_i2c_remove(struct i2c_client *client)
 	chip->dev->release = NULL;
 	chip->release = NULL;
 	tpm_dev.client = NULL;
-	dev_set_drvdata(chip->dev, chip);
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 5bb8e2d..1c68d93 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -746,8 +746,6 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	tpm_get_timeouts(chip);
 
-	i2c_set_clientdata(client, chip);
-
 	dev_info(chip->dev, "TPM I2C Initialized\n");
 	return 0;
 _irq_set:
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index 7a7929b..9b48370 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -386,8 +386,6 @@ static int tpmfront_probe(struct xenbus_device *dev,
 
 	tpm_get_timeouts(priv->chip);
 
-	dev_set_drvdata(&dev->dev, priv->chip);
-
 	return rv;
 }
 
-- 
1.7.5.4

