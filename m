Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099Ab3GWSDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:03:43 -0400
Received: from sauhun.de ([89.238.76.85]:58757 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933643Ab3GWSDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:03:42 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-rpi-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: [PATCH 17/27] drivers/spi: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:50 +0200
Message-Id: <1374602524-3398-18-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/spi/spi-bcm2835.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index a4185e4..7604c52 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -325,12 +325,6 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	init_completion(&bs->done);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "could not get memory resource\n");
-		err = -ENODEV;
-		goto out_master_put;
-	}
-
 	bs->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(bs->regs)) {
 		err = PTR_ERR(bs->regs);
-- 
1.7.10.4

