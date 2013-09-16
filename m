Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3IPQDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:03:10 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46882 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3IPQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:02:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/20] iio: sensors-core: st: Clean-up error handling in st_sensors_read_axis_data()
Date: Mon, 16 Sep 2013 17:02:19 +0100
Message-Id: <1379347346-823-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of those unnecessary gotos.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/common/st_sensors/st_sensors_core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index c5fbe58..76e573b 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -331,10 +331,8 @@ static int st_sensors_read_axis_data(struct iio_dev *indio_dev,
 	unsigned int byte_for_channel = ch->scan_type.storagebits >> 3;
 
 	outdata = kmalloc(byte_for_channel, GFP_KERNEL);
-	if (!outdata) {
-		err = -EINVAL;
-		goto st_sensors_read_axis_data_error;
-	}
+	if (!outdata)
+		return -ENOMEM;
 
 	err = sdata->tf->read_multiple_byte(&sdata->tb, sdata->dev,
 				ch->address, byte_for_channel,
@@ -349,7 +347,7 @@ static int st_sensors_read_axis_data(struct iio_dev *indio_dev,
 
 st_sensors_free_memory:
 	kfree(outdata);
-st_sensors_read_axis_data_error:
+
 	return err;
 }
 
-- 
1.8.1.2

