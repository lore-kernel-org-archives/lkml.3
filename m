Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3EMOFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:05:03 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34634 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3EMOEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:04:51 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: spi-devel-general@lists.sourceforge.net
Cc: Stephen Warren <swarren@wwwdotorg.org>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] drivers: spi: convert to devm_ioremap_resource()
Date: Mon, 13 May 2013 17:04:46 +0300
Message-Id: <1368453886-6852-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert  use of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

This was found with coccinelle.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
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
1.7.9.5

