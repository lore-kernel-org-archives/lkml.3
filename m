Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaHGAXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 20:23:48 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:51025 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbaHGAXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 20:23:05 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH v3 1/2] staging: iio: accel: Add blank lines between declarations and code
Date: Wed,  6 Aug 2014 21:22:08 -0300
Message-Id: <1407370929-26949-2-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1.204.gae8bc8d
In-Reply-To: <1407370929-26949-1-git-send-email-mopsfelder@gmail.com>
References: <1407370929-26949-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing blank lines between declarations and code and
fixes lines starting by spaces, satisfying checkpatch.pl.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/iio/accel/adis16201_core.c | 5 +++--
 drivers/staging/iio/accel/adis16203_core.c | 2 ++
 drivers/staging/iio/accel/adis16204_core.c | 1 +
 drivers/staging/iio/accel/adis16209_core.c | 1 +
 drivers/staging/iio/accel/adis16240_core.c | 1 +
 drivers/staging/iio/accel/lis3l02dq_core.c | 4 ++++
 drivers/staging/iio/accel/lis3l02dq_ring.c | 1 +
 drivers/staging/iio/accel/sca3000_core.c   | 1 +
 8 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/accel/adis16201_core.c b/drivers/staging/iio/accel/adis16201_core.c
index 50ba1fa..7eae5fd 100644
--- a/drivers/staging/iio/accel/adis16201_core.c
+++ b/drivers/staging/iio/accel/adis16201_core.c
@@ -111,6 +111,7 @@ static int adis16201_write_raw(struct iio_dev *indio_dev,
 	int bits;
 	s16 val16;
 	u8 addr;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		switch (chan->type) {
@@ -131,8 +132,8 @@ static int adis16201_write_raw(struct iio_dev *indio_dev,
 }
 
 static const struct iio_chan_spec adis16201_channels[] = {
-  ADIS_SUPPLY_CHAN(ADIS16201_SUPPLY_OUT, ADIS16201_SCAN_SUPPLY, 0, 12),
-  ADIS_TEMP_CHAN(ADIS16201_TEMP_OUT, ADIS16201_SCAN_TEMP, 0, 12),
+	ADIS_SUPPLY_CHAN(ADIS16201_SUPPLY_OUT, ADIS16201_SCAN_SUPPLY, 0, 12),
+	ADIS_TEMP_CHAN(ADIS16201_TEMP_OUT, ADIS16201_SCAN_TEMP, 0, 12),
 	ADIS_ACCEL_CHAN(X, ADIS16201_XACCL_OUT, ADIS16201_SCAN_ACC_X,
 		BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
 	ADIS_ACCEL_CHAN(Y, ADIS16201_YACCL_OUT, ADIS16201_SCAN_ACC_Y,
diff --git a/drivers/staging/iio/accel/adis16203_core.c b/drivers/staging/iio/accel/adis16203_core.c
index f472137..fbbe93f 100644
--- a/drivers/staging/iio/accel/adis16203_core.c
+++ b/drivers/staging/iio/accel/adis16203_core.c
@@ -37,6 +37,7 @@ static int adis16203_write_raw(struct iio_dev *indio_dev,
 	struct adis *st = iio_priv(indio_dev);
 	/* currently only one writable parameter which keeps this simple */
 	u8 addr = adis16203_addresses[chan->scan_index];
+
 	return adis_write_reg_16(st, addr, val & 0x3FFF);
 }
 
@@ -50,6 +51,7 @@ static int adis16203_read_raw(struct iio_dev *indio_dev,
 	int bits;
 	u8 addr;
 	s16 val16;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 		return adis_single_conversion(indio_dev, chan,
diff --git a/drivers/staging/iio/accel/adis16204_core.c b/drivers/staging/iio/accel/adis16204_core.c
index 19eaebc..4c8acbc 100644
--- a/drivers/staging/iio/accel/adis16204_core.c
+++ b/drivers/staging/iio/accel/adis16204_core.c
@@ -119,6 +119,7 @@ static int adis16204_write_raw(struct iio_dev *indio_dev,
 	int bits;
 	s16 val16;
 	u8 addr;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		switch (chan->type) {
diff --git a/drivers/staging/iio/accel/adis16209_core.c b/drivers/staging/iio/accel/adis16209_core.c
index 374dc6e..b2c7aed 100644
--- a/drivers/staging/iio/accel/adis16209_core.c
+++ b/drivers/staging/iio/accel/adis16209_core.c
@@ -44,6 +44,7 @@ static int adis16209_write_raw(struct iio_dev *indio_dev,
 	int bits;
 	s16 val16;
 	u8 addr;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		switch (chan->type) {
diff --git a/drivers/staging/iio/accel/adis16240_core.c b/drivers/staging/iio/accel/adis16240_core.c
index 74ace2a..205d6d0 100644
--- a/drivers/staging/iio/accel/adis16240_core.c
+++ b/drivers/staging/iio/accel/adis16240_core.c
@@ -163,6 +163,7 @@ static int adis16240_write_raw(struct iio_dev *indio_dev,
 	int bits = 10;
 	s16 val16;
 	u8 addr;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		val16 = val & ((1 << bits) - 1);
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 898653c..f5e145c 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -212,6 +212,7 @@ static int lis3l02dq_write_thresh(struct iio_dev *indio_dev,
 				  int val, int val2)
 {
 	u16 value = val;
+
 	return lis3l02dq_spi_write_reg_s16(indio_dev,
 					   LIS3L02DQ_REG_THS_L_ADDR,
 					   value);
@@ -226,6 +227,7 @@ static int lis3l02dq_write_raw(struct iio_dev *indio_dev,
 	int ret = -EINVAL, reg;
 	u8 uval;
 	s8 sval;
+
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		if (val > 255 || val < -256)
@@ -302,6 +304,7 @@ static ssize_t lis3l02dq_read_frequency(struct device *dev,
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	int ret, len = 0;
 	s8 t;
+
 	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_CTRL_1_ADDR,
 				       (u8 *)&t);
@@ -565,6 +568,7 @@ static int lis3l02dq_read_event_config(struct iio_dev *indio_dev,
 	u8 val;
 	int ret;
 	u8 mask = (1 << (chan->channel2*2 + (dir == IIO_EV_DIR_RISING)));
+
 	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
 				       &val);
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index bf33fde..1d934ee 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -19,6 +19,7 @@ static inline u16 combine_8_to_16(u8 lower, u8 upper)
 {
 	u16 _lower = lower;
 	u16 _upper = upper;
+
 	return _lower | (_upper << 8);
 }
 
diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
index ed30e32..bc53fedb 100644
--- a/drivers/staging/iio/accel/sca3000_core.c
+++ b/drivers/staging/iio/accel/sca3000_core.c
@@ -713,6 +713,7 @@ static int sca3000_read_thresh(struct iio_dev *indio_dev,
 	int ret, i;
 	struct sca3000_state *st = iio_priv(indio_dev);
 	int num = chan->channel2;
+
 	mutex_lock(&st->lock);
 	ret = sca3000_read_ctrl_reg(st, sca3000_addresses[num][1]);
 	mutex_unlock(&st->lock);
-- 
2.1.0.rc1.204.gae8bc8d

