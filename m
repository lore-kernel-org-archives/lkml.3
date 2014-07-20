Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaGTR6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:58:36 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33055 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaGTR6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:58:02 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH v7 4/4] iio: hid-sensor-magn-3d: Add support for rotation from north
Date: Sun, 20 Jul 2014 12:57:43 -0500
Message-Id: <1405879063-2292-5-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405879063-2292-1-git-send-email-reyad.attiyat@gmail.com>
References: <1405879063-2292-1-git-send-email-reyad.attiyat@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the HID usage attribute ID's and IIO channel info for rotation
from north support.

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/magnetometer/hid-sensor-magn-3d.c | 53 ++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
index 161fbd4..1e717c7 100644
--- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
+++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
@@ -35,6 +35,10 @@ enum magn_3d_channel {
 	CHANNEL_SCAN_INDEX_X,
 	CHANNEL_SCAN_INDEX_Y,
 	CHANNEL_SCAN_INDEX_Z,
+	CHANNEL_SCAN_INDEX_NORTH_MAGN_TILT_COMP,
+	CHANNEL_SCAN_INDEX_NORTH_TRUE_TILT_COMP,
+	CHANNEL_SCAN_INDEX_NORTH_MAGN,
+	CHANNEL_SCAN_INDEX_NORTH_TRUE,
 	MAGN_3D_CHANNEL_MAX,
 };
 
@@ -57,7 +61,11 @@ struct magn_3d_state {
 static const u32 magn_3d_addresses[MAGN_3D_CHANNEL_MAX] = {
 	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS,
 	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS,
-	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS
+	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS,
+	HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH,
+	HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH,
+	HID_USAGE_SENSOR_ORIENT_MAGN_NORTH,
+	HID_USAGE_SENSOR_ORIENT_TRUE_NORTH,
 };
 
 /* Channel definitions */
@@ -89,6 +97,42 @@ static const struct iio_chan_spec magn_3d_channels[] = {
 		BIT(IIO_CHAN_INFO_SCALE) |
 		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
 		BIT(IIO_CHAN_INFO_HYSTERESIS),
+	}, {
+		.type = IIO_ROT,
+		.modified = 1,
+		.channel2 = IIO_MOD_NORTH_MAGN_TILT_COMP,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
+		BIT(IIO_CHAN_INFO_SCALE) |
+		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
+		BIT(IIO_CHAN_INFO_HYSTERESIS),
+	}, {
+		.type = IIO_ROT,
+		.modified = 1,
+		.channel2 = IIO_MOD_NORTH_TRUE_TILT_COMP,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
+		BIT(IIO_CHAN_INFO_SCALE) |
+		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
+		BIT(IIO_CHAN_INFO_HYSTERESIS),
+	}, {
+		.type = IIO_ROT,
+		.modified = 1,
+		.channel2 = IIO_MOD_NORTH_MAGN,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
+		BIT(IIO_CHAN_INFO_SCALE) |
+		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
+		BIT(IIO_CHAN_INFO_HYSTERESIS),
+	}, {
+		.type = IIO_ROT,
+		.modified = 1,
+		.channel2 = IIO_MOD_NORTH_TRUE,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
+		BIT(IIO_CHAN_INFO_SCALE) |
+		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
+		BIT(IIO_CHAN_INFO_HYSTERESIS),
 	}
 };
 
@@ -242,6 +286,13 @@ static int magn_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 		offset = (usage_id - HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS)
 				+ CHANNEL_SCAN_INDEX_X;
 	break;
+	case HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH:
+	case HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH:
+	case HID_USAGE_SENSOR_ORIENT_MAGN_NORTH:
+	case HID_USAGE_SENSOR_ORIENT_TRUE_NORTH:
+		offset = (usage_id - HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH)
+				+ CHANNEL_SCAN_INDEX_NORTH_MAGN_TILT_COMP;
+	break;
 	default:
 		return -EINVAL;
 	}
-- 
1.9.3

