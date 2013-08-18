Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3HRCok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:44:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57482 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab3HRCnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:49 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 12/14] crypto: omap-aes: Convert kzalloc to devm_kzalloc
Date: Sat, 17 Aug 2013 21:42:33 -0500
Message-ID: <1376793755-30478-13-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc instead of kzalloc. With this change, there is no need to
call kfree in error/exit paths.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index cbeaaf4..6a4ac4a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1147,7 +1147,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	int err = -ENOMEM, i, j, irq = -1;
 	u32 reg;
 
-	dd = kzalloc(sizeof(struct omap_aes_dev), GFP_KERNEL);
+	dd = devm_kzalloc(dev, sizeof(struct omap_aes_dev), GFP_KERNEL);
 	if (dd == NULL) {
 		dev_err(dev, "unable to alloc data struct.\n");
 		goto err_data;
@@ -1241,7 +1241,6 @@ err_irq:
 	tasklet_kill(&dd->queue_task);
 	pm_runtime_disable(dev);
 err_res:
-	kfree(dd);
 	dd = NULL;
 err_data:
 	dev_err(dev, "initialization failed.\n");
@@ -1269,7 +1268,6 @@ static int omap_aes_remove(struct platform_device *pdev)
 	tasklet_kill(&dd->queue_task);
 	omap_aes_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
-	kfree(dd);
 	dd = NULL;
 
 	return 0;
-- 
1.7.9.5

