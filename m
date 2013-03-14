Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3CNJTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:19:00 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:38891 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3CNJS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:18:59 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: spi: Use PTR_RET function
Date: Thu, 14 Mar 2013 11:18:18 +0200
Message-Id: <1363252698-29500-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls to IS_ERR and PTR_ERR with PTR_RET function.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/spi/spidev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 2e0655d..911e9e0 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -603,7 +603,7 @@ static int spidev_probe(struct spi_device *spi)
 		dev = device_create(spidev_class, &spi->dev, spidev->devt,
 				    spidev, "spidev%d.%d",
 				    spi->master->bus_num, spi->chip_select);
-		status = IS_ERR(dev) ? PTR_ERR(dev) : 0;
+		status = PTR_RET(dev);
 	} else {
 		dev_dbg(&spi->dev, "no minor number available!\n");
 		status = -ENODEV;
-- 
1.7.9.5

