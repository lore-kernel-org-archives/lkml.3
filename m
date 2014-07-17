Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaGQUku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:40:50 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58857 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaGQUkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:40:49 -0400
Date: Fri, 18 Jul 2014 02:10:40 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] staging: iio: adis16203: Use devm_iio_device_register
Message-ID: <20140717204040.GA22788@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of iio_device_register and does away with
the call to the corressponding unregister function in the probe and
remove functions of the driver respectively.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/staging/iio/accel/adis16203_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/iio/accel/adis16203_core.c b/drivers/staging/iio/accel/adis16203_core.c
index 409a28e..5077779 100644
--- a/drivers/staging/iio/accel/adis16203_core.c
+++ b/drivers/staging/iio/accel/adis16203_core.c
@@ -175,7 +175,7 @@ static int adis16203_probe(struct spi_device *spi)
 	if (ret)
 		goto error_cleanup_buffer_trigger;
 
-	ret = iio_device_register(indio_dev);
+	ret = devm_iio_device_register(&spi->dev, indio_dev);
 	if (ret)
 		goto error_cleanup_buffer_trigger;
 
@@ -191,7 +191,6 @@ static int adis16203_remove(struct spi_device *spi)
 	struct iio_dev *indio_dev = spi_get_drvdata(spi);
 	struct adis *st = iio_priv(indio_dev);
 
-	iio_device_unregister(indio_dev);
 	adis_cleanup_buffer_and_trigger(st, indio_dev);
 
 	return 0;
-- 
1.9.1

