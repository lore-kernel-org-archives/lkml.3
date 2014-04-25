Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaDYCwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 22:52:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46097 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaDYCww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 22:52:52 -0400
Date: Fri, 25 Apr 2014 10:52:29 +0800
From: Jimmy Li <coder.liss@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH]staging:iio:ad2s1200 fix missing parenthesis in a for
 statment.
Message-ID: <20140425025229.GA12200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jimmy Li <coder.liss@gmail.com>
---
 drivers/staging/iio/resolver/ad2s1200.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/resolver/ad2s1200.c b/drivers/staging/iio/resolver/ad2s1200.c
index e2b4820..017d2f8 100644
--- a/drivers/staging/iio/resolver/ad2s1200.c
+++ b/drivers/staging/iio/resolver/ad2s1200.c
@@ -107,7 +107,7 @@ static int ad2s1200_probe(struct spi_device *spi)
 	int pn, ret = 0;
 	unsigned short *pins = spi->dev.platform_data;
 
-	for (pn = 0; pn < AD2S1200_PN; pn++)
+	for (pn = 0; pn < AD2S1200_PN; pn++) {
 		ret = devm_gpio_request_one(&spi->dev, pins[pn], GPIOF_DIR_OUT,
 					    DRV_NAME);
 		if (ret) {
@@ -115,6 +115,7 @@ static int ad2s1200_probe(struct spi_device *spi)
 							pins[pn]);
 			return ret;
 		}
+	}
 	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*st));
 	if (!indio_dev)
 		return -ENOMEM;
-- 
1.7.9.5

