Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbaBUN3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:29:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47179 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbaBUMvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 091/121] iio: adis16400: Set timestamp as the last element in chan_spec
Date: Fri, 21 Feb 2014 12:48:35 +0000
Message-Id: <1392986945-9693-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/imu/adis16400.h      |  1 +
 drivers/iio/imu/adis16400_core.c | 10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/imu/adis16400.h b/drivers/iio/imu/adis16400.h
index 2f8f9d6..0916bf6 100644
--- a/drivers/iio/imu/adis16400.h
+++ b/drivers/iio/imu/adis16400.h
@@ -189,6 +189,7 @@ enum {
 	ADIS16300_SCAN_INCLI_X,
 	ADIS16300_SCAN_INCLI_Y,
 	ADIS16400_SCAN_ADC,
+	ADIS16400_SCAN_TIMESTAMP,
 };
 
 #ifdef CONFIG_IIO_BUFFER
diff --git a/drivers/iio/imu/adis16400_core.c b/drivers/iio/imu/adis16400_core.c
index e58c529..d6ece2d 100644
--- a/drivers/iio/imu/adis16400_core.c
+++ b/drivers/iio/imu/adis16400_core.c
@@ -632,7 +632,7 @@ static const struct iio_chan_spec adis16400_channels[] = {
 	ADIS16400_MAGN_CHAN(Z, ADIS16400_ZMAGN_OUT, 14),
 	ADIS16400_TEMP_CHAN(ADIS16400_TEMP_OUT, 12),
 	ADIS16400_AUX_ADC_CHAN(ADIS16400_AUX_ADC, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(12)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static const struct iio_chan_spec adis16448_channels[] = {
@@ -659,7 +659,7 @@ static const struct iio_chan_spec adis16448_channels[] = {
 		},
 	},
 	ADIS16400_TEMP_CHAN(ADIS16448_TEMP_OUT, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(11)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static const struct iio_chan_spec adis16350_channels[] = {
@@ -677,7 +677,7 @@ static const struct iio_chan_spec adis16350_channels[] = {
 	ADIS16400_MOD_TEMP_CHAN(X, ADIS16350_XTEMP_OUT, 12),
 	ADIS16400_MOD_TEMP_CHAN(Y, ADIS16350_YTEMP_OUT, 12),
 	ADIS16400_MOD_TEMP_CHAN(Z, ADIS16350_ZTEMP_OUT, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(11)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static const struct iio_chan_spec adis16300_channels[] = {
@@ -690,7 +690,7 @@ static const struct iio_chan_spec adis16300_channels[] = {
 	ADIS16400_AUX_ADC_CHAN(ADIS16300_AUX_ADC, 12),
 	ADIS16400_INCLI_CHAN(X, ADIS16300_PITCH_OUT, 13),
 	ADIS16400_INCLI_CHAN(Y, ADIS16300_ROLL_OUT, 13),
-	IIO_CHAN_SOFT_TIMESTAMP(14)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static const struct iio_chan_spec adis16334_channels[] = {
@@ -701,7 +701,7 @@ static const struct iio_chan_spec adis16334_channels[] = {
 	ADIS16400_ACCEL_CHAN(Y, ADIS16400_YACCL_OUT, 14),
 	ADIS16400_ACCEL_CHAN(Z, ADIS16400_ZACCL_OUT, 14),
 	ADIS16400_TEMP_CHAN(ADIS16350_XTEMP_OUT, 12),
-	IIO_CHAN_SOFT_TIMESTAMP(8)
+	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
 };
 
 static struct attribute *adis16400_attributes[] = {
-- 
1.9.0

