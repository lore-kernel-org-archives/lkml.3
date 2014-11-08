Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaKHOOE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 09:14:04 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19186 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaKHON6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 09:13:58 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-56-545e2520093e
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH 3/5] iio: sensorhub: Add sensorhub iio commons
Date: Sat, 08 Nov 2014 15:13:14 +0100
Message-id: <1415455996-20871-4-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415455996-20871-1-git-send-email-k.wrona@samsung.com>
References: <1415455996-20871-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsVy+t/xK7oKqnEhBru3y1n8nXSM3WLjjPWs
	Fg+aVjFZnFq2n8nibNMbdot5R96xWFzeNYfNgd3j969JjB6bVnWyefRtWcXo8XmTXABLFJdN
	SmpOZllqkb5dAlfGt4eXGQt+mlTMPzCTrYHxjnYXIweHhICJxJk7vF2MnECmmMSFe+vZQGwh
	gaWMEpsWFXQxcgHZfUwSJy49ZAFJsAmoSzTvWMwMkhARaGSUuLm4H6yDWaCDUWJROxeILSxg
	JzG58xFYA4uAqsSDVSvAangFnCW2zP7HBLFYQWLOJBuQMKeAi8SpuTuZIBY7S3yZ84N5AiPv
	AkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghgfRlB+PiY1aHGAU4GJV4eC1uxoYIsSaW
	FVfmHmKU4GBWEuHtPQ8U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLjh1YF67eyDt61YPklfcRS5
	XhwW/E/y1HahzUbn5ucvMb46h8Xp9em9Oyc80FvCf8jwbOaC80zrC1bpxvcVyd7bKcaTlfYy
	+vfcc3nb9r8wu3Ui68K6uiOmba3CnRy7n/tJG51r0vk47b16nNp+xqKNC7O/ru6ezXXlwImF
	mWdsU361iO2xipqoxFKckWioxVxUnAgAs6kxkAICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds common library for sensorhub iio drivers.

Change-Id: I1038cb31c051f7e8ffde696a4121518daa5af081
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/common/Kconfig                      |    1 +
 drivers/iio/common/Makefile                     |    1 +
 drivers/iio/common/ssp_sensors/Kconfig          |   13 ++++
 drivers/iio/common/ssp_sensors/Makefile         |    5 ++
 drivers/iio/common/ssp_sensors/ssp_iio.c        |   81 +++++++++++++++++++++++
 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h |   59 +++++++++++++++++
 6 files changed, 160 insertions(+)
 create mode 100644 drivers/iio/common/ssp_sensors/Kconfig
 create mode 100644 drivers/iio/common/ssp_sensors/Makefile
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio.c
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h

diff --git a/drivers/iio/common/Kconfig b/drivers/iio/common/Kconfig
index 0b6e97d..630f9d8 100644
--- a/drivers/iio/common/Kconfig
+++ b/drivers/iio/common/Kconfig
@@ -4,3 +4,4 @@
 
 source "drivers/iio/common/hid-sensors/Kconfig"
 source "drivers/iio/common/st_sensors/Kconfig"
+source "drivers/iio/common/ssp_sensors/Kconfig"
diff --git a/drivers/iio/common/Makefile b/drivers/iio/common/Makefile
index 3112df0..5119642 100644
--- a/drivers/iio/common/Makefile
+++ b/drivers/iio/common/Makefile
@@ -9,3 +9,4 @@
 # When adding new entries keep the list in alphabetical order
 obj-y += hid-sensors/
 obj-y += st_sensors/
+obj-y += ssp_sensors/
diff --git a/drivers/iio/common/ssp_sensors/Kconfig b/drivers/iio/common/ssp_sensors/Kconfig
new file mode 100644
index 0000000..3c10f6f
--- /dev/null
+++ b/drivers/iio/common/ssp_sensors/Kconfig
@@ -0,0 +1,13 @@
+#
+# SSP Sensor common modules
+#
+menu "SSP Sensor IIO Common"
+
+config SSP_SENSOR_IIO
+	tristate "Commons for all SSP Sensor IIO drivers"
+	depends on SENSORS_SAMSUNG_SSP
+	select IIO_BUFFER
+	help
+	  Say yes here to build commons for SSP sensors.
+
+endmenu
diff --git a/drivers/iio/common/ssp_sensors/Makefile b/drivers/iio/common/ssp_sensors/Makefile
new file mode 100644
index 0000000..f39f109
--- /dev/null
+++ b/drivers/iio/common/ssp_sensors/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the SSP sensor common modules.
+#
+
+obj-$(CONFIG_SSP_SENSOR_IIO) += ssp_iio.o
diff --git a/drivers/iio/common/ssp_sensors/ssp_iio.c b/drivers/iio/common/ssp_sensors/ssp_iio.c
new file mode 100644
index 0000000..bbe9e5e
--- /dev/null
+++ b/drivers/iio/common/ssp_sensors/ssp_iio.c
@@ -0,0 +1,81 @@
+/*
+ *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#include <linux/iio/common/ssp_sensors.h>
+#include <linux/iio/kfifo_buf.h>
+#include "ssp_iio_sensor.h"
+
+/**
+ * ssp_common_buffer_postenable() - generic postenable callback for ssp buffer
+ *
+ * @indio_dev:		iio device
+ *
+ * Returns 0 or negative value in case of error
+ */
+int ssp_common_buffer_postenable(struct iio_dev *indio_dev)
+{
+	struct ssp_sensor_data *c = iio_priv(indio_dev);
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	return ssp_enable_sensor(data, c->type,
+				ssp_get_sensor_delay(data, c->type));
+}
+EXPORT_SYMBOL(ssp_common_buffer_postenable);
+
+/**
+ * ssp_common_buffer_predisable() - generic predisable callback for ssp buffer
+ *
+ * @indio_dev:		iio device
+ *
+ * Returns 0 or negative value in case of error
+ */
+int ssp_common_buffer_predisable(struct iio_dev *indio_dev)
+{
+	struct ssp_sensor_data *c = iio_priv(indio_dev);
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	return ssp_disable_sensor(data, c->type);
+}
+EXPORT_SYMBOL(ssp_common_buffer_predisable);
+
+/**
+ * ssp_common_setup_buffer() - creates iio kfifo and registers the buffer for device
+ *
+ * @indio_dev:		iio device
+ *
+ * Returns 0 or negative value in case of error
+ */
+int ssp_common_setup_buffer(struct iio_dev *indio_dev,
+			    const struct iio_buffer_setup_ops *ops)
+{
+	int ret;
+	struct iio_buffer *buffer;
+
+	buffer = iio_kfifo_allocate(indio_dev);
+	if (!buffer)
+		return -ENOMEM;
+
+	iio_device_attach_buffer(indio_dev, buffer);
+
+	indio_dev->setup_ops = ops;
+
+	ret = iio_buffer_register(indio_dev, indio_dev->channels,
+				  indio_dev->num_channels);
+	if (ret)
+		iio_kfifo_free(buffer);
+
+	return ret;
+}
+EXPORT_SYMBOL(ssp_common_setup_buffer);
diff --git a/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
new file mode 100644
index 0000000..bf4a6ad
--- /dev/null
+++ b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
@@ -0,0 +1,59 @@
+#ifndef __SSP_IIO_SENSOR_H__
+#define __SSP_IIO_SENSOR_H__
+
+#define SSP_CHANNEL_AG(_type, _mod, _index) \
+{ \
+		.type = _type,\
+		.modified = 1,\
+		.channel2 = _mod,\
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SAMP_FREQ),\
+		.scan_index = _index,\
+		.scan_type = {\
+			.sign = 's',\
+			.realbits = 16,\
+			.storagebits = 16,\
+			.shift = 0,\
+			.endianness = IIO_LE,\
+		},\
+}
+
+#define SSP_DIVISOR	1000000ULL
+#define SSP_MS_PER_S	1000
+#define SSP_DIVIDEND	(SSP_DIVISOR * SSP_MS_PER_S)
+
+int ssp_common_buffer_postenable(struct iio_dev *indio_dev);
+
+int ssp_common_buffer_predisable(struct iio_dev *indio_dev);
+
+int ssp_common_setup_buffer(struct iio_dev *indio_dev,
+			    const struct iio_buffer_setup_ops *ops);
+
+/* Converts time in ms to frequency */
+static inline void ssp_convert_to_freq(u32 time, int *integer_part,
+				       int *fractional)
+{
+	unsigned int value;
+
+	if (time == 0) {
+		*fractional = 0;
+		*integer_part = 0;
+		return;
+	}
+
+	value = SSP_DIVIDEND / time;
+	*fractional = value % SSP_DIVISOR;
+	*integer_part = value / SSP_DIVISOR;
+}
+
+/* Converts frequency to time in ms*/
+static inline int ssp_convert_to_time(int integer_part, int fractional)
+{
+	u64 value;
+
+	value = integer_part * SSP_DIVISOR + fractional;
+	if (value == 0)
+		return 0;
+
+	return  div_u64(SSP_DIVIDEND, value);
+}
+#endif /* __SSP_IIO_SENSOR_H__ */
-- 
1.7.9.5

