Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbaGYVOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 17:14:24 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64023 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaGYVOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:14:22 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: jic23@kernel.org, srinivas.pandruvada@linux.intel.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH v2] iio: hid-sensor-magn-3d: Fix build warning
Date: Fri, 25 Jul 2014 16:14:17 -0500
Message-Id: <1406322857-12391-1-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build warning, sizeof() called on dynamically
sized pointer, by removing the call and the dependent
function parameter. It is not needed or used in this
driver, when pushing values to an iio buffer.

Changes from v1
- Fix mistake in varible name

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 drivers/iio/magnetometer/hid-sensor-magn-3d.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
index 3ec777a..1e717c7 100644
--- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
+++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
@@ -246,8 +246,7 @@ static const struct iio_info magn_3d_info = {
 };
 
 /* Function to push data to buffer */
-static void hid_sensor_push_data(struct iio_dev *indio_dev, const void *data,
-	int len)
+static void hid_sensor_push_data(struct iio_dev *indio_dev, const void *data)
 {
 	dev_dbg(&indio_dev->dev, "hid_sensor_push_data\n");
 	iio_push_to_buffers(indio_dev, data);
@@ -263,9 +262,7 @@ static int magn_3d_proc_event(struct hid_sensor_hub_device *hsdev,
 
 	dev_dbg(&indio_dev->dev, "magn_3d_proc_event\n");
 	if (atomic_read(&magn_state->common_attributes.data_ready))
-		hid_sensor_push_data(indio_dev,
-				magn_state->iio_vals,
-				sizeof(magn_state->iio_vals));
+		hid_sensor_push_data(indio_dev, magn_state->iio_vals);
 
 	return 0;
 }
-- 
1.9.3

