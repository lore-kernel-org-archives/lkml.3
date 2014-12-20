Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaLTOuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 09:50:23 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51336 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaLTOuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 09:50:21 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: accel: sca3000_core.c:  Remove unused function
Date: Sat, 20 Dec 2014 15:53:07 +0100
Message-Id: <1419087187-4250-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function sca3000_check_status() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/iio/accel/sca3000_core.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
index e4e5639..655e34c 100644
--- a/drivers/staging/iio/accel/sca3000_core.c
+++ b/drivers/staging/iio/accel/sca3000_core.c
@@ -223,33 +223,6 @@ error_ret:
 	return ret;
 }
 
-#ifdef SCA3000_DEBUG
-/**
- * sca3000_check_status() check the status register
- *
- * Only used for debugging purposes
- **/
-static int sca3000_check_status(struct device *dev)
-{
-	int ret;
-	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
-	struct sca3000_state *st = iio_priv(indio_dev);
-
-	mutex_lock(&st->lock);
-	ret = sca3000_read_data_short(st, SCA3000_REG_ADDR_STATUS, 1);
-	if (ret < 0)
-		goto error_ret;
-	if (st->rx[0] & SCA3000_EEPROM_CS_ERROR)
-		dev_err(dev, "eeprom error\n");
-	if (st->rx[0] & SCA3000_SPI_FRAME_ERROR)
-		dev_err(dev, "Previous SPI Frame was corrupt\n");
-
-error_ret:
-	mutex_unlock(&st->lock);
-	return ret;
-}
-#endif /* SCA3000_DEBUG */
-
 /**
  * sca3000_show_rev() - sysfs interface to read the chip revision number
  **/
-- 
1.7.10.4

