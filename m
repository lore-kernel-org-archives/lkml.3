Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3IYJY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:24:26 -0400
Received: from ozlabs.org ([203.10.76.45]:39014 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab3IYJYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:24:25 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <linuxppc-dev@ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>, mpm@selenic.com,
        herbert@gondor.hengli.com.au
Subject: [PATCH 1/2] hwrng: Use KBUILD_MODNAME in pseries-rng.c
Date: Wed, 25 Sep 2013 19:24:16 +1000
Message-Id: <1380101057-29903-1-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 drivers/char/hw_random/pseries-rng.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index 5f11979..9dbeed3 100644
--- a/drivers/char/hw_random/pseries-rng.c
+++ b/drivers/char/hw_random/pseries-rng.c
@@ -21,7 +21,6 @@
 #include <linux/hw_random.h>
 #include <asm/vio.h>
 
-#define MODULE_NAME "pseries-rng"
 
 static int pseries_rng_data_read(struct hwrng *rng, u32 *data)
 {
@@ -47,7 +46,7 @@ static unsigned long pseries_rng_get_desired_dma(struct vio_dev *vdev)
 };
 
 static struct hwrng pseries_rng = {
-	.name		= MODULE_NAME,
+	.name		= KBUILD_MODNAME,
 	.data_read	= pseries_rng_data_read,
 };
 
@@ -70,7 +69,7 @@ static struct vio_device_id pseries_rng_driver_ids[] = {
 MODULE_DEVICE_TABLE(vio, pseries_rng_driver_ids);
 
 static struct vio_driver pseries_rng_driver = {
-	.name = MODULE_NAME,
+	.name = KBUILD_MODNAME,
 	.probe = pseries_rng_probe,
 	.remove = pseries_rng_remove,
 	.get_desired_dma = pseries_rng_get_desired_dma,
-- 
1.8.1.2

