Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbaGORWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:22:44 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:48181 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaGORWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:22:41 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 25/94] iio: hid-sensor-press: Fix return values
Date: Tue, 15 Jul 2014 20:00:40 +0300
Message-Id: <1405443709-15288-25-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Kamat <sachin.kamat@samsung.com>

IIO_CHAN_INFO_SAMP_FREQ and IIO_CHAN_INFO_HYSTERESIS cases ignored
the actual return values (which could be -EINVAL) and instead
returned IIO_VAL_INT_PLUS_MICRO always. Return the actual value
obtained from the functions. Both functions return IIO_VAL_INT_PLUS_MICRO
upon success.

Agreed with by Srinivas.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/iio/pressure/hid-sensor-press.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/pressure/hid-sensor-press.c b/drivers/iio/pressure/hid-sensor-press.c
index 1cd190c..2c0d2a4 100644
--- a/drivers/iio/pressure/hid-sensor-press.c
+++ b/drivers/iio/pressure/hid-sensor-press.c
@@ -78,7 +78,6 @@ static int press_read_raw(struct iio_dev *indio_dev,
 	struct press_state *press_state = iio_priv(indio_dev);
 	int report_id = -1;
 	u32 address;
-	int ret;
 	int ret_type;
 	s32 poll_value;
 
@@ -128,14 +127,12 @@ static int press_read_raw(struct iio_dev *indio_dev,
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		ret = hid_sensor_read_samp_freq_value(
+		ret_type = hid_sensor_read_samp_freq_value(
 				&press_state->common_attributes, val, val2);
-		ret_type = IIO_VAL_INT_PLUS_MICRO;
 		break;
 	case IIO_CHAN_INFO_HYSTERESIS:
-		ret = hid_sensor_read_raw_hyst_value(
+		ret_type = hid_sensor_read_raw_hyst_value(
 				&press_state->common_attributes, val, val2);
-		ret_type = IIO_VAL_INT_PLUS_MICRO;
 		break;
 	default:
 		ret_type = -EINVAL;
-- 
1.7.10.4

