Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3IPQG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:06:26 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45216 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3IPQCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:02:49 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/20] iio: sensors-core: st: Clean-up error handling in st_sensors_init_sensor()
Date: Mon, 16 Sep 2013 17:02:18 +0100
Message-Id: <1379347346-823-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strip out all those unnecessary gotos and just return the error right away.

Aids to simplicity and reduces code.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/common/st_sensors/st_sensors_core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index 2672630..c5fbe58 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -241,29 +241,28 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
 
 	err = st_sensors_set_enable(indio_dev, false);
 	if (err < 0)
-		goto init_error;
+		return err;
 
 	if (sdata->current_fullscale) {
 		err = st_sensors_set_fullscale(indio_dev,
 					       sdata->current_fullscale->num);
 		if (err < 0)
-			goto init_error;
+			return err;
 	} else
 		dev_info(&indio_dev->dev, "Full-scale not possible\n");
 
 	err = st_sensors_set_odr(indio_dev, sdata->odr);
 	if (err < 0)
-		goto init_error;
+		return err;
 
 	/* set BDU */
 	err = st_sensors_write_data_with_mask(indio_dev,
 			sdata->sensor->bdu.addr, sdata->sensor->bdu.mask, true);
 	if (err < 0)
-		goto init_error;
+		return err;
 
 	err = st_sensors_set_axis_enable(indio_dev, ST_SENSORS_ENABLE_ALL_AXIS);
 
-init_error:
 	return err;
 }
 EXPORT_SYMBOL(st_sensors_init_sensor);
-- 
1.8.1.2

