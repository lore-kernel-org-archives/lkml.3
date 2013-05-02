Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab3EBLwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:52:43 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:45006 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426Ab3EBLwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:52:41 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: herbert@gondor.hengli.com.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: crypto: use devm_ioremap_resource()
Date: Thu,  2 May 2013 14:00:38 +0200
Message-Id: <1367496038-4038-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace calls to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/crypto/omap-aes.c  |    7 +++----
 drivers/crypto/omap-sham.c |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 6aa425f..158215c 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1125,10 +1125,9 @@ static int omap_aes_probe(struct platform_device *pdev)
 	if (err)
 		goto err_res;
 
-	dd->io_base = devm_request_and_ioremap(dev, &res);
-	if (!dd->io_base) {
-		dev_err(dev, "can't ioremap\n");
-		err = -ENOMEM;
+	dd->io_base = devm_ioremap_resource(dev, &res);
+	if (IS_ERR(dd->io_base)) {
+		err = PTR_ERR(dd->io_base);
 		goto err_res;
 	}
 	dd->phys_base = res.start;
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 3d1611f..4d9cca6 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1686,10 +1686,9 @@ static int omap_sham_probe(struct platform_device *pdev)
 	if (err)
 		goto res_err;
 
-	dd->io_base = devm_request_and_ioremap(dev, &res);
-	if (!dd->io_base) {
-		dev_err(dev, "can't ioremap\n");
-		err = -ENOMEM;
+	dd->io_base = devm_ioremap_resource(dev, &res);
+	if (IS_ERR(dd->io_base)) {
+		err = PTR_ERR(dd->io_base);
 		goto res_err;
 	}
 	dd->phys_base = res.start;
-- 
1.7.10.4

