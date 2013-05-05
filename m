Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3EEIiL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 04:38:11 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59478 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3EEIiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 04:38:08 -0400
From: chenlibo.3@gmail.com
To: grant.likely@linaro.org, rob.herring@calxeda.com
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Libo Chen <libo.chen@huawei.com>
Subject: [PATCH] bestcomm: no need to free when kzalloc fail
Date: Sun,  5 May 2013 01:38:24 -0700
Message-Id: <1367743104-3448-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <libo.chen@huawei.com>

There is no need to free bcom_eng if kzalloc fail

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/dma/bestcomm/bestcomm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/bestcomm/bestcomm.c b/drivers/dma/bestcomm/bestcomm.c
index a8c2e29..300ee2d 100644
--- a/drivers/dma/bestcomm/bestcomm.c
+++ b/drivers/dma/bestcomm/bestcomm.c
@@ -400,7 +400,7 @@ static int mpc52xx_bcom_probe(struct platform_device *op)
 		printk(KERN_ERR DRIVER_NAME ": "
 			"Can't allocate state structure\n");
 		rv = -ENOMEM;
-		goto error_sramclean;
+		goto error_kzalloc;
 	}
 
 	/* Save the node */
@@ -449,6 +449,7 @@ error_release:
 	release_mem_region(res_bcom.start, sizeof(struct mpc52xx_sdma));
 error_sramclean:
 	kfree(bcom_eng);
+error_kzalloc:
 	bcom_sram_cleanup();
 error_ofput:
 	of_node_put(op->dev.of_node);
-- 
1.8.1.2

