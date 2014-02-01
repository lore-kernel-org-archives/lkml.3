Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaBAOkC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 09:40:02 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:43872 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaBAOkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 09:40:00 -0500
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Cc: ohannes Thumshirn <morbidrsa@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iio: adc: viperboard: Call platform_set_drvdata before devm_iio_device_register
Date: Sat,  1 Feb 2014 15:39:53 +0100
Message-Id: <1391265593-13986-1-git-send-email-morbidrsa@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call platform_set_drvdata before devm_iio_device_register to avoid possible
race condition when accessing driver data.

Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
---
 drivers/iio/adc/viperboard_adc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/viperboard_adc.c b/drivers/iio/adc/viperboard_adc.c
index d0add8f..7d9bd05 100644
--- a/drivers/iio/adc/viperboard_adc.c
+++ b/drivers/iio/adc/viperboard_adc.c
@@ -133,14 +133,14 @@ static int vprbrd_adc_probe(struct platform_device *pdev)
 	indio_dev->channels = vprbrd_adc_iio_channels;
 	indio_dev->num_channels = ARRAY_SIZE(vprbrd_adc_iio_channels);
 
+	platform_set_drvdata(pdev, indio_dev);
+
 	ret = devm_iio_device_register(&pdev->dev, indio_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "could not register iio (adc)");
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, indio_dev);
-
 	return 0;
 }
 
-- 
1.8.5.3

