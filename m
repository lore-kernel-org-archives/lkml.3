Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaBTXvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:51:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbaBTXvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.10 33/66] iio: adis16400: Set timestamp as the last element in chan_spec
Date: Thu, 20 Feb 2014 15:51:32 -0800
Message-Id: <20140220234910.447060519@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

commit c76782d151dab7ecfdcdf9a01561c2d61d9b490f upstream.

This is necessary since timestamp is calculated as the last element
in iio_compute_scan_bytes().

Without this fix any userspace code reading the layout of the buffer via
sysfs will incorrectly interpret the data leading some nasty corruption.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/adis16400.h      |    1 +
 drivers/iio/imu/adis16400_core.c |   10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/iio/imu/adis16400.h
+++ b/drivers/iio/imu/adis16400.h
@@ -189,6 +189,7 @@ enum {
 	ADIS16300_SCAN_INCLI_X,
 	ADIS16300_SCAN_INCLI_Y,
 	ADIS16400_SCAN_ADC,
+	ADIS16400_SCAN_TIMESTAMP,
 };
 
 #ifdef CONFIG_IIO_BUFFER
--- a/drivers/iio/imu/adis16400_core.c
+++ b/drivers/iio/imu/adis16400_core.c
@@ -632,7 +632,7 @@ static const struct iio_chan_spec adis16
 	ADIS16400_MAGN_CHAN(Z, ADIS16400_ZMAGN_OUT, 14),
 	ADIS16400_TEMP_CHAN(ADIS16400_TEMP_OUT, 12),
 	ADIS16400_AUX_ADC_CHAN(ADIS16400_AUX_ADC, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(12)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static const struct iio_chan_spec adis16448_channels[] = {
@@ -659,7 +659,7 @@ static const struct iio_chan_spec adis16
 		},
 	},
 	ADIS16400_TEMP_CHAN(ADIS16448_TEMP_OUT, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(11)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static const struct iio_chan_spec adis16350_channels[] = {
@@ -677,7 +677,7 @@ static const struct iio_chan_spec adis16
 	ADIS16400_MOD_TEMP_CHAN(X, ADIS16350_XTEMP_OUT, 12),
 	ADIS16400_MOD_TEMP_CHAN(Y, ADIS16350_YTEMP_OUT, 12),
 	ADIS16400_MOD_TEMP_CHAN(Z, ADIS16350_ZTEMP_OUT, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(11)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static const struct iio_chan_spec adis16300_channels[] = {
@@ -690,7 +690,7 @@ static const struct iio_chan_spec adis16
 	ADIS16400_AUX_ADC_CHAN(ADIS16300_AUX_ADC, 12),
 	ADIS16400_INCLI_CHAN(X, ADIS16300_PITCH_OUT, 13),
 	ADIS16400_INCLI_CHAN(Y, ADIS16300_ROLL_OUT, 13),
-	IIO_CHAN_SOFT_TIMESTAMP(14)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static const struct iio_chan_spec adis16334_channels[] = {
@@ -701,7 +701,7 @@ static const struct iio_chan_spec adis16
 	ADIS16400_ACCEL_CHAN(Y, ADIS16400_YACCL_OUT, 14),
 	ADIS16400_ACCEL_CHAN(Z, ADIS16400_ZACCL_OUT, 14),
 	ADIS16400_TEMP_CHAN(ADIS16350_XTEMP_OUT, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(8)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static struct attribute *adis16400_attributes[] = {


