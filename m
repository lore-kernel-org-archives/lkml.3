Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab3EBMFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:05:40 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39885 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3EBMFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:05:39 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: swarren@wwwdotorg.org, broonie@kernel.org, grant.likely@linaro.org
Cc: linux-rpi-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: spi: bmc2835: use devm_ioremap_resource()
Date: Thu,  2 May 2013 14:13:30 +0200
Message-Id: <1367496810-5400-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/spi/spi-bcm2835.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 89c0b50..a4185e4 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -331,10 +331,9 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 		goto out_master_put;
 	}
 
-	bs->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!bs->regs) {
-		dev_err(&pdev->dev, "could not request/map memory region\n");
-		err = -ENODEV;
+	bs->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(bs->regs)) {
+		err = PTR_ERR(bs->regs);
 		goto out_master_put;
 	}
 
-- 
1.7.10.4

