Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3IJM4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:56:06 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:48230 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3IJMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/38] iio: sensors-core: st: Clean-up error handling in st_sensors_read_info_raw()
Date: Tue, 10 Sep 2013 13:49:23 +0100
Message-Id: <1378817379-8238-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saving a few lines of code.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/common/st_sensors/st_sensors_core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index 148f0e5..25d4c7e 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -359,28 +359,25 @@ int st_sensors_read_info_raw(struct iio_dev *indio_dev,
 	mutex_lock(&indio_dev->mlock);
 	if (indio_dev->currentmode == INDIO_BUFFER_TRIGGERED) {
 		err = -EBUSY;
-		goto read_error;
+		goto out;
 	} else {
 		err = st_sensors_set_enable(indio_dev, true);
 		if (err < 0)
-			goto read_error;
+			goto out;
 
 		msleep((sdata->sensor->bootime * 1000) / sdata->odr);
 		err = st_sensors_read_axis_data(indio_dev, ch, val);
 		if (err < 0)
-			goto read_error;
+			goto out;
 
 		*val = *val >> ch->scan_type.shift;
 
 		err = st_sensors_set_enable(indio_dev, false);
 	}
+out:
 	mutex_unlock(&indio_dev->mlock);
 
 	return err;
-
-read_error:
-	mutex_unlock(&indio_dev->mlock);
-	return err;
 }
 EXPORT_SYMBOL(st_sensors_read_info_raw);
 
-- 
1.8.1.2

