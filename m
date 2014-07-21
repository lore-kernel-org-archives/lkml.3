Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaGUISj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:18:39 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50165 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaGUISe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:18:34 -0400
Date: Mon, 21 Jul 2014 13:48:28 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] staging: iio: ad5930: Use devm_iio_device_register
Message-ID: <20140721081827.GA3080@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of iio_device_register and does away with
the call to the coressponding unregister function in the remove function
of the driver. The remove function is no longer required and is
completely removed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/staging/iio/frequency/ad5930.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/iio/frequency/ad5930.c b/drivers/staging/iio/frequency/ad5930.c
index a4aeee6..662cfb9 100644
--- a/drivers/staging/iio/frequency/ad5930.c
+++ b/drivers/staging/iio/frequency/ad5930.c
@@ -106,7 +106,7 @@ static int ad5930_probe(struct spi_device *spi)
 	idev->info = &ad5930_info;
 	idev->modes = INDIO_DIRECT_MODE;
 
-	ret = iio_device_register(idev);
+	ret = devm_iio_device_register(&spi->dev, idev);
 	if (ret)
 		return ret;
 	spi->max_speed_hz = 2000000;
@@ -117,20 +117,12 @@ static int ad5930_probe(struct spi_device *spi)
 	return 0;
 }
 
-static int ad5930_remove(struct spi_device *spi)
-{
-	iio_device_unregister(spi_get_drvdata(spi));
-
-	return 0;
-}
-
 static struct spi_driver ad5930_driver = {
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
 	},
 	.probe = ad5930_probe,
-	.remove = ad5930_remove,
 };
 module_spi_driver(ad5930_driver);
 
-- 
1.9.1

