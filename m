Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaKHOPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 09:15:19 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19186 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaKHONz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 09:13:55 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-54-545e251fe022
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH 1/5] misc: sensorhub: Add sensorhub driver
Date: Sat, 08 Nov 2014 15:13:12 +0100
Message-id: <1415455996-20871-2-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415455996-20871-1-git-send-email-k.wrona@samsung.com>
References: <1415455996-20871-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t/xK7ryqnEhBq8v61j8nXSM3WLjjPWs
	Fg+aVjFZnFq2n8nibNMbdot5R96xWFzeNYfNgd3j969JjB6bVnWyefRtWcXo8XmTXABLFJdN
	SmpOZllqkb5dAlfGrab9bAUL5jFXtL39y9rAOO0iUxcjB4eEgInE8wXOXYycQKaYxIV769lA
	bCGBpYwSk/dUdzFyAdl9TBKbZkxnBUmwCahLNO9YzAySEBFoZJS4ubgfrINZoINRYlE7F8hQ
	YQEriaNT2EHCLAKqEh1rN4DZvALOEiseNrFD7FWQmDPJBiTMKeAicWruTiaIvc4SX+b8YJ7A
	yLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkgofdnBuPiY1SFGAQ5GJR5ei5uxIUKs
	iWXFlbmHGCU4mJVEeHvPA4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwCl3UnnuzPbxifbeLp86J
	FJcXwS1N8sK6lUqt+448OyN6i3Hecd+zM1afWCg9V+RTX/IKP6MO+WrPSUs+m4XvuFlxVKWW
	u2O1wbVvQiYzCucmLZ3K7b+zaPVi01aXvNcMbEfF7YICnn9tFdS0O9F3n+2w8ROGKsmzrXsX
	eynfPdTfu+y12C8pJZbijERDLeai4kQAeS7hWgMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sensorhub  is MCU dedicated to collect data and manage several sensors.
Sensorhub is a spi device which provides a layer for IIO devices. It provides
some data parsing and common mechanism for sensorhub sensors.

Adds common sensorhub library for sensorhub driver and iio drivers
which uses sensorhub MCU to communicate with sensors.

Change-Id: I4f066e9f3f477d4f6faabd4507be98e32f79e344
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/Kconfig                   |    1 +
 drivers/misc/Makefile                  |    1 +
 drivers/misc/sensorhub/Kconfig         |   13 +
 drivers/misc/sensorhub/Makefile        |    6 +
 drivers/misc/sensorhub/ssp.h           |  279 +++++++++++
 drivers/misc/sensorhub/ssp_dev.c       |  825 ++++++++++++++++++++++++++++++++
 drivers/misc/sensorhub/ssp_spi.c       |  639 +++++++++++++++++++++++++
 include/linux/iio/common/ssp_sensors.h |   80 ++++
 8 files changed, 1844 insertions(+)
 create mode 100644 drivers/misc/sensorhub/Kconfig
 create mode 100644 drivers/misc/sensorhub/Makefile
 create mode 100644 drivers/misc/sensorhub/ssp.h
 create mode 100644 drivers/misc/sensorhub/ssp_dev.c
 create mode 100644 drivers/misc/sensorhub/ssp_spi.c
 create mode 100644 include/linux/iio/common/ssp_sensors.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b2e68c1..89001ce 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -529,4 +529,5 @@ source "drivers/misc/genwqe/Kconfig"
 source "drivers/misc/echo/Kconfig"
 source "drivers/misc/cxl/Kconfig"
 source "drivers/misc/stm32fwu/Kconfig"
+source "drivers/misc/sensorhub/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 88c8999..27d0881 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_ECHO)		+= echo/
 obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
 obj-$(CONFIG_CXL_BASE)		+= cxl/
 obj-$(CONFIG_STM32_UPGRADE_PROTOCOL)	+= stm32fwu/
+obj-$(CONFIG_SENSORS_SAMSUNG_SSP)	+= sensorhub/
diff --git a/drivers/misc/sensorhub/Kconfig b/drivers/misc/sensorhub/Kconfig
new file mode 100644
index 0000000..a77dc1f
--- /dev/null
+++ b/drivers/misc/sensorhub/Kconfig
@@ -0,0 +1,13 @@
+#
+# sensor drivers configuration
+#
+config SENSORS_SAMSUNG_SSP
+	tristate "Samsung Sensorhub driver"
+	depends on SPI
+	select STM32_UPGRADE_PROTOCOL
+	help
+	  SSP driver for sensor hub.
+	  If you say yes here you get ssp support for
+	  sensor hub.
+	  To compile this driver as a module, choose M here: the
+	  module will be called ssp_dev.
diff --git a/drivers/misc/sensorhub/Makefile b/drivers/misc/sensorhub/Makefile
new file mode 100644
index 0000000..c40ed72
--- /dev/null
+++ b/drivers/misc/sensorhub/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the sensor drivers.
+#
+
+obj-$(CONFIG_SENSORS_SAMSUNG_SSP)		+= ssp_dev.o ssp_spi.o
+
diff --git a/drivers/misc/sensorhub/ssp.h b/drivers/misc/sensorhub/ssp.h
new file mode 100644
index 0000000..e19ad21
--- /dev/null
+++ b/drivers/misc/sensorhub/ssp.h
@@ -0,0 +1,279 @@
+/*
+ *  Copyright (C) 2011, Samsung Electronics Co. Ltd. All Rights Reserved.
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
+#ifndef __SSP_SENSORHUB_H__
+#define __SSP_SENSORHUB_H__
+
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/iio/common/ssp_sensors.h>
+#include <linux/iio/iio.h>
+#include <linux/spi/spi.h>
+
+#define SSP_DEVICE_ID		0x55
+
+#ifdef SSP_DBG
+#define ssp_dbg(format, ...) pr_info("[SSP] "format, ##__VA_ARGS__)
+#else
+#define ssp_dbg(format, ...)
+#endif
+
+#define SSP_SW_RESET_TIME		3000
+/* Sensor polling in ms */
+#define SSP_DEFUALT_POLLING_DELAY	200
+#define SSP_DEFAULT_RETRIES		3
+#define SSP_DATA_PACKET_SIZE		960
+
+enum {
+	SSP_KERNEL_BINARY = 0,
+	SSP_KERNEL_CRASHED_BINARY,
+};
+
+enum {
+	SSP_INITIALIZATION_STATE = 0,
+	SSP_NO_SENSOR_STATE,
+	SSP_ADD_SENSOR_STATE,
+	SSP_RUNNING_SENSOR_STATE,
+};
+
+/* Firmware download STATE */
+enum {
+	SSP_FW_DL_STATE_FAIL = -1,
+	SSP_FW_DL_STATE_NONE = 0,
+	SSP_FW_DL_STATE_NEED_TO_SCHEDULE,
+	SSP_FW_DL_STATE_SCHEDULED,
+	SSP_FW_DL_STATE_DOWNLOADING,
+	SSP_FW_DL_STATE_SYNC,
+	SSP_FW_DL_STATE_DONE,
+};
+
+#define SSP_INVALID_REVISION			99999
+#define SSP_INVALID_REVISION2			0xffffff
+
+/* AP -> SSP Instruction */
+#define SSP_MSG2SSP_INST_BYPASS_SENSOR_ADD	0xa1
+#define SSP_MSG2SSP_INST_BYPASS_SENSOR_REMOVE	0xa2
+#define SSP_MSG2SSP_INST_REMOVE_ALL		0xa3
+#define SSP_MSG2SSP_INST_CHANGE_DELAY		0xa4
+#define SSP_MSG2SSP_INST_LIBRARY_ADD		0xb1
+#define SSP_MSG2SSP_INST_LIBRARY_REMOVE		0xb2
+#define SSP_MSG2SSP_INST_LIB_NOTI		0xb4
+#define SSP_MSG2SSP_INST_LIB_DATA		0xc1
+
+#define SSP_MSG2SSP_AP_MCU_SET_GYRO_CAL		0xcd
+#define SSP_MSG2SSP_AP_MCU_SET_ACCEL_CAL	0xce
+#define SSP_MSG2SSP_AP_STATUS_SHUTDOWN		0xd0
+#define SSP_MSG2SSP_AP_STATUS_WAKEUP		0xd1
+#define SSP_MSG2SSP_AP_STATUS_SLEEP		0xd2
+#define SSP_MSG2SSP_AP_STATUS_RESUME		0xd3
+#define SSP_MSG2SSP_AP_STATUS_SUSPEND		0xd4
+#define SSP_MSG2SSP_AP_STATUS_RESET		0xd5
+#define SSP_MSG2SSP_AP_STATUS_POW_CONNECTED	0xd6
+#define SSP_MSG2SSP_AP_STATUS_POW_DISCONNECTED	0xd7
+#define SSP_MSG2SSP_AP_TEMPHUMIDITY_CAL_DONE	0xda
+#define SSP_MSG2SSP_AP_MCU_SET_DUMPMODE		0xdb
+#define SSP_MSG2SSP_AP_MCU_DUMP_CHECK		0xdc
+#define SSP_MSG2SSP_AP_MCU_BATCH_FLUSH		0xdd
+#define SSP_MSG2SSP_AP_MCU_BATCH_COUNT		0xdf
+
+#define SSP_MSG2SSP_AP_WHOAMI				0x0f
+#define SSP_MSG2SSP_AP_FIRMWARE_REV			0xf0
+#define SSP_MSG2SSP_AP_SENSOR_FORMATION			0xf1
+#define SSP_MSG2SSP_AP_SENSOR_PROXTHRESHOLD		0xf2
+#define SSP_MSG2SSP_AP_SENSOR_BARCODE_EMUL		0xf3
+#define SSP_MSG2SSP_AP_SENSOR_SCANNING			0xf4
+#define SSP_MSG2SSP_AP_SET_MAGNETIC_HWOFFSET		0xf5
+#define SSP_MSG2SSP_AP_GET_MAGNETIC_HWOFFSET		0xf6
+#define SSP_MSG2SSP_AP_SENSOR_GESTURE_CURRENT		0xf7
+#define SSP_MSG2SSP_AP_GET_THERM			0xf8
+#define SSP_MSG2SSP_AP_GET_BIG_DATA			0xf9
+#define SSP_MSG2SSP_AP_SET_BIG_DATA			0xfa
+#define SSP_MSG2SSP_AP_START_BIG_DATA			0xfb
+#define SSP_MSG2SSP_AP_SET_MAGNETIC_STATIC_MATRIX	0xfd
+#define SSP_MSG2SSP_AP_SENSOR_TILT			0xea
+#define SSP_MSG2SSP_AP_MCU_SET_TIME			0xfe
+#define SSP_MSG2SSP_AP_MCU_GET_TIME			0xff
+
+#define SSP_MSG2SSP_AP_FUSEROM				0x01
+/* voice data */
+#define SSP_TYPE_WAKE_UP_VOICE_SERVICE			0x01
+#define SSP_TYPE_WAKE_UP_VOICE_SOUND_SOURCE_AM		0x01
+#define SSP_TYPE_WAKE_UP_VOICE_SOUND_SOURCE_GRAMMER	0x02
+
+/* Factory Test */
+#define SSP_ACCELEROMETER_FACTORY			0x80
+#define SSP_GYROSCOPE_FACTORY				0x81
+#define SSP_GEOMAGNETIC_FACTORY				0x82
+#define SSP_PRESSURE_FACTORY				0x85
+#define SSP_GESTURE_FACTORY				0x86
+#define SSP_TEMPHUMIDITY_CRC_FACTORY			0x88
+#define SSP_GYROSCOPE_TEMP_FACTORY			0x8a
+#define SSP_GYROSCOPE_DPS_FACTORY			0x8b
+#define SSP_MCU_FACTORY					0x8c
+#define SSP_MCU_SLEEP_FACTORY				0x8d
+
+/* SSP -> AP ACK about write CMD */
+#define SSP_MSG_ACK		0x80	/* ACK from SSP to AP */
+#define SSP_MSG_NAK		0x70	/* NAK from SSP to AP */
+
+/* Accelerometer sensor*/
+/* 16bits */
+/* FIXME rev min max for others */
+#define SSP_MAX_ACCEL_1G	16384
+#define SSP_MAX_ACCEL_2G	32767
+#define SSP_MIN_ACCEL_2G	-32768
+#define SSP_MAX_ACCEL_4G	65536
+
+#define SSP_MAX_GYRO	32767
+#define SSP_MIN_GYRO	-32768
+
+struct ssp_sensorhub_info {
+	char *fw_name;
+	char *fw_crashed_name;
+	unsigned int fw_rev;
+	const u8 * const mag_table;
+	const unsigned int mag_length;
+};
+
+/* ssp_msg options bit*/
+#define SSP_RW		0
+#define SSP_INDEX	3
+
+enum {
+	SSP_AP2HUB_READ = 0,
+	SSP_AP2HUB_WRITE,
+	SSP_HUB2AP_WRITE,
+	SSP_AP2HUB_READY,
+	SSP_AP2HUB_RETURN
+};
+
+enum {
+	SSP_BIG_TYPE_DUMP = 0,
+	SSP_BIG_TYPE_READ_LIB,
+	SSP_BIG_TYPE_VOICE_NET,
+	SSP_BIG_TYPE_VOICE_GRAM,
+	SSP_BIG_TYPE_VOICE_PCM,
+	SSP_BIG_TYPE_TEMP,
+	SSP_BIG_TYPE_MAX,
+};
+
+/**
+ * struct ssp_data - ssp platformdata structure
+ * @spi:		spi device
+ * @sensorhub_info:	info about sensorhub board specific features
+ * @wdt_timer:		watchdog timer
+ * @work_wdt:		watchdog work
+ * @work_firmware:	firmware upgrade work queue
+ * @work_refresh:	refresh worqueue for reset request from MCU
+ * @shut_down:		shut down flag
+ * @mcu_dump_mode:	mcu dump mode for debug
+ * @time_syncing:	time syncing indication flag
+ * @timestamp:		previous time in ns calculated for time syncing
+ * @check_status:	status table for each sensor
+ * @com_fail_cnt:	communication fail count
+ * @reset_cnt:		reset count
+ * @time_out_cnt:	timeout count
+ * @available_sensors:	available sensors seen by sensorhub (bit array)
+ * @cur_firm_rev:	cached current firmware revision
+ * @last_resume_state:	last AP resume/suspend state used to handle
+ * the PM state of ssp
+ * @last_ap_state:	(obsolete) sleep notification for MCU
+ * @sensor_enable:	sensor enable mask
+ * @delay_buf:		data acquisition intervals table
+ * @batch_latency_buf:	jet unknown but existing in communication protocol
+ * @batch_opt_buf:	jet unknown but existing in communication protocol
+ * @accel_position:	jet unknown but existing in communication protocol
+ * @mag_position:	jet unknown but existing in communication protocol
+ * @fw_dl_state:	firmware download state
+ * @comm_lock:		lock protecting the handshake
+ * @pending_lock:	lock protecting pending list and completion
+ * @mcu_reset:		mcu reset line
+ * @ap_mcu_gpio:	ap to mcu gpio line
+ * @mcu_ap_gpio:	mcu to ap gpio line
+ * @pending_list:	pending list for messages queued to be sent/read
+ * @sensor_devs:	registered IIO devices table
+ * @enable_refcount:	enable reference count for wdt timer (watchdog)
+ */
+struct ssp_data {
+	struct spi_device *spi;
+	struct ssp_sensorhub_info *sensorhub_info;
+	struct timer_list wdt_timer;
+	struct work_struct work_wdt;
+	struct delayed_work work_firmware;
+	struct delayed_work work_refresh;
+
+	bool shut_down;
+	bool mcu_dump_mode;
+	bool time_syncing;
+	int64_t timestamp;
+
+	int check_status[SSP_SENSOR_MAX];
+
+	unsigned int com_fail_cnt;
+	unsigned int reset_cnt;
+	unsigned int time_out_cnt;
+
+	unsigned int available_sensors;
+	unsigned int cur_firm_rev;
+
+	char last_resume_state;
+	char last_ap_state;
+
+	unsigned int sensor_enable;
+	u32 delay_buf[SSP_SENSOR_MAX];
+	s32 batch_latency_buf[SSP_SENSOR_MAX];
+	s8 batch_opt_buf[SSP_SENSOR_MAX];
+
+	int accel_position;
+	int mag_position;
+	int fw_dl_state;
+
+	struct mutex comm_lock;
+	struct mutex pending_lock;
+
+	int mcu_reset;
+	int ap_mcu_gpio;
+	int mcu_ap_gpio;
+
+	struct list_head pending_list;
+
+	struct iio_dev *sensor_devs[SSP_SENSOR_MAX];
+	atomic_t enable_refcount;
+};
+
+void ssp_clean_pending_list(struct ssp_data *data);
+
+int ssp_command(struct ssp_data *data, char command, int arg);
+
+int ssp_send_instruction(struct ssp_data *, u8 inst, u8 sensor_type,
+			 u8 *send_buf, u8 length);
+
+int ssp_irq_msg(struct ssp_data *data);
+
+int ssp_get_chipid(struct ssp_data *data);
+
+int ssp_get_fuserom_data(struct ssp_data *data);
+
+int ssp_set_sensor_position(struct ssp_data *data);
+
+int ssp_set_magnetic_matrix(struct ssp_data *data);
+
+unsigned int ssp_get_sensor_scanning_info(struct ssp_data *data);
+
+unsigned int ssp_get_firmware_rev(struct ssp_data *data);
+
+int ssp_queue_ssp_refresh_task(struct ssp_data *data, int delay);
+
+#endif /* __SSP_SENSORHUB_H__ */
diff --git a/drivers/misc/sensorhub/ssp_dev.c b/drivers/misc/sensorhub/ssp_dev.c
new file mode 100644
index 0000000..e41501c
--- /dev/null
+++ b/drivers/misc/sensorhub/ssp_dev.c
@@ -0,0 +1,825 @@
+/*
+*  Copyright (C) 2012, Samsung Electronics Co. Ltd. All Rights Reserved.
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
+#include <linux/firmware.h>
+#include <linux/iio/iio.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/of_platform.h>
+#include <linux/stm32fwu.h>
+#include "ssp.h"
+
+#define SSP_WDT_TIME		10000
+#define LIMIT_RESET_CNT		20
+#define LIMIT_TIMEOUT_CNT	3
+
+/* It is possible that it is max clk rate for version 1.0 of bootcode */
+#define BOOT_SPI_HZ	400000
+
+static const u8 magnitude_table[] = {110, 85, 171, 71, 203, 195, 0, 67, 208,
+	56, 175, 244, 206, 213, 0, 92, 250, 0, 55, 48, 189, 252, 171, 243, 13,
+	45, 250};
+
+static const struct ssp_sensorhub_info rinato_info = {
+	.fw_name = "ssp_B2.fw",
+	.fw_crashed_name = "ssp_crashed.fw",
+	.fw_rev = 14052300,
+	.mag_table = magnitude_table,
+	.mag_length = ARRAY_SIZE(magnitude_table),
+};
+
+static const struct ssp_sensorhub_info thermostat_info = {
+	.fw_name = "thermostat_B2.fw",
+	.fw_crashed_name = "ssp_crashed.fw",
+	.fw_rev = 14080600,
+	.mag_table = magnitude_table,
+	.mag_length = ARRAY_SIZE(magnitude_table),
+};
+
+static void start_reset_sequence(struct ssp_data *data)
+{
+	int i;
+
+	dev_info(&data->spi->dev, "%s\n", __func__);
+
+	gpio_set_value(data->mcu_reset, 0);
+	usleep_range(4000, 4100);
+	gpio_set_value(data->mcu_reset, 1);
+	msleep(45);
+
+	for (i = 0; i < 9; i++) {
+		gpio_set_value(data->mcu_reset, 0);
+		usleep_range(4000, 4100);
+		gpio_set_value(data->mcu_reset, 1);
+		usleep_range(15000, 15500);
+	}
+}
+
+static void ssp_toggle_mcu_reset(struct ssp_data *data)
+{
+	gpio_set_value(data->mcu_reset, 0);
+	usleep_range(1000, 1200);
+	gpio_set_value(data->mcu_reset, 1);
+	msleep(50);
+}
+
+static void sync_available_sensors(struct ssp_data *data)
+{
+	int i, ret;
+
+	for (i = 0; i < SSP_SENSOR_MAX; ++i) {
+		if ((data->available_sensors << i)  == 1)
+			ret = ssp_enable_sensor(data, i, data->delay_buf[i]);
+			if (ret < 0)
+				continue;
+	}
+
+	ret  = ssp_command(data, SSP_MSG2SSP_AP_MCU_SET_DUMPMODE,
+			    data->mcu_dump_mode);
+	if (ret < 0) {
+		pr_err("[SSP]: %s - SSP_MSG2SSP_AP_MCU_SET_DUMPMODE failed\n",
+		       __func__);
+	}
+}
+
+static void ssp_enable_mcu(struct ssp_data *data, bool enable)
+{
+	dev_info(&data->spi->dev, "Enable = %d, old enable = %d\n", enable,
+		 data->shut_down);
+
+	if (enable && data->shut_down) {
+		data->shut_down = false;
+		enable_irq(data->spi->irq);
+		enable_irq_wake(data->spi->irq);
+	} else if (!enable && !data->shut_down) {
+		data->shut_down = true;
+		disable_irq(data->spi->irq);
+		disable_irq_wake(data->spi->irq);
+	} else {
+		dev_err(&data->spi->dev,
+			"Error / enable = %d, old enable = %d\n", enable,
+			data->shut_down);
+	}
+}
+
+static int ssp_forced_to_download(struct ssp_data *data, int bin_type)
+{
+	int ret = 0, retry = 3;
+	unsigned int speed;
+	struct stm32fwu_fw *fwu;
+	const struct firmware *fw = NULL;
+
+	ssp_dbg("%s, mcu binany update!\n", __func__);
+
+	ssp_enable_mcu(data, false);
+
+	data->fw_dl_state = SSP_FW_DL_STATE_DOWNLOADING;
+	dev_info(&data->spi->dev, "%s, DL state = %d\n", __func__,
+		 data->fw_dl_state);
+
+	speed = data->spi->max_speed_hz;
+	data->spi->max_speed_hz = BOOT_SPI_HZ;
+	ret = spi_setup(data->spi);
+	if (ret < 0) {
+		dev_err(&data->spi->dev, "failed to setup spi for ssp_boot\n");
+		goto _err_begin;
+	}
+
+	dev_info(&data->spi->dev, "ssp_load_fw start\n");
+
+	ret = request_firmware(&fw, data->sensorhub_info->fw_name,
+			       &data->spi->dev);
+	if (ret < 0)
+		goto _err_begin;
+
+	fwu = stm32fwu_init(&data->spi->dev, STM32_SPI, fw->data, fw->size);
+	if (fwu == NULL) {
+		dev_err(&data->spi->dev, "stm32fw init  fail\n");
+		goto _err_fw;
+	}
+
+	start_reset_sequence(data);
+
+	ret = stm32fwu_send_sync(fwu);
+	if (ret < 0) {
+		dev_err(&data->spi->dev, "send sync failed with %d\n", ret);
+		return ret;
+	}
+
+	do {
+		dev_info(&data->spi->dev, "%d try\n", 3 - retry);
+		ret = stm32fwu_update(fwu);
+	} while (retry-- > 0 && ret < 0);
+
+	data->spi->max_speed_hz = speed;
+	ret = spi_setup(data->spi);
+	if (ret < 0) {
+		dev_err(&data->spi->dev, "failed to setup spi for ssp_norm\n");
+		goto _err_fwu;
+	}
+
+	if (ret < 0)
+		goto _err_fwu;
+
+	data->fw_dl_state = SSP_FW_DL_STATE_SYNC;
+	dev_info(&data->spi->dev, "%s, DL state = %d\n", __func__,
+		 data->fw_dl_state);
+
+	ssp_enable_mcu(data, true);
+
+	data->fw_dl_state = SSP_FW_DL_STATE_DONE;
+	dev_info(&data->spi->dev, "%s, DL state = %d\n", __func__,
+		 data->fw_dl_state);
+
+_err_fwu:
+	stm32fwu_destroy(fwu);
+_err_fw:
+	release_firmware(fw);
+_err_begin:
+	if (ret < 0) {
+		data->fw_dl_state = SSP_FW_DL_STATE_FAIL;
+		dev_err(&data->spi->dev,
+			"%s - update_mcu_bin failed!\n", __func__);
+	}
+
+	return ret;
+}
+
+/* This function is the first one which communicates with the mcu so it is
+ * possible that the first attempt will fail */
+static int ssp_check_fwbl(struct ssp_data *data)
+{
+	int retries = 0;
+
+	while (retries++ < 5) {
+		data->cur_firm_rev = ssp_get_firmware_rev(data);
+		if (data->cur_firm_rev == SSP_INVALID_REVISION
+			|| data->cur_firm_rev == SSP_INVALID_REVISION2
+			|| data->cur_firm_rev < 0) {
+			dev_warn(&data->spi->dev,
+				 "Invalid revision, trying %d time\n", retries);
+		} else
+			break;
+	}
+
+	if (data->cur_firm_rev == SSP_INVALID_REVISION
+		|| data->cur_firm_rev == SSP_INVALID_REVISION2) {
+		dev_err(&data->spi->dev, "SSP_INVALID_REVISION\n");
+		return SSP_FW_DL_STATE_NEED_TO_SCHEDULE;
+
+	} else {
+		if (data->cur_firm_rev != data->sensorhub_info->fw_rev) {
+			dev_info(&data->spi->dev,
+				 "MCU Firm Rev : Old = %8u, New = %8u\n",
+				 data->cur_firm_rev,
+				 data->sensorhub_info->fw_rev);
+
+			return SSP_FW_DL_STATE_NEED_TO_SCHEDULE;
+		}
+		dev_info(&data->spi->dev,
+			 "MCU Firm Rev : Old = %8u, New = %8u\n",
+			 data->cur_firm_rev,
+			 data->sensorhub_info->fw_rev);
+	}
+
+	return SSP_FW_DL_STATE_NONE;
+}
+
+static void reset_mcu(struct ssp_data *data)
+{
+	ssp_enable_mcu(data, false);
+	ssp_clean_pending_list(data);
+	ssp_toggle_mcu_reset(data);
+	ssp_enable_mcu(data, true);
+}
+
+static void wdt_work_func(struct work_struct *work)
+{
+	struct ssp_data *data = container_of(work, struct ssp_data, work_wdt);
+
+	dev_err(&data->spi->dev, "%s - Sensor state: 0x%x, RC: %u, CC: %u\n",
+		__func__, data->available_sensors, data->reset_cnt,
+		data->com_fail_cnt);
+
+	reset_mcu(data);
+	data->com_fail_cnt = 0;
+	data->time_out_cnt = 0;
+}
+
+static void wdt_timer_func(unsigned long ptr)
+{
+	struct ssp_data *data = (struct ssp_data *)ptr;
+
+	switch (data->fw_dl_state) {
+	case SSP_FW_DL_STATE_FAIL:
+	case SSP_FW_DL_STATE_DOWNLOADING:
+	case SSP_FW_DL_STATE_SYNC:
+		goto _mod;
+	}
+
+	if (data->time_out_cnt > LIMIT_TIMEOUT_CNT
+	    || data->com_fail_cnt > LIMIT_RESET_CNT)
+		queue_work(system_power_efficient_wq, &data->work_wdt);
+_mod:
+	mod_timer(&data->wdt_timer, jiffies + msecs_to_jiffies(SSP_WDT_TIME));
+}
+
+static void enable_wdt_timer(struct ssp_data *data)
+{
+	mod_timer(&data->wdt_timer, jiffies + msecs_to_jiffies(SSP_WDT_TIME));
+}
+
+static void disable_wdt_timer(struct ssp_data *data)
+{
+	del_timer_sync(&data->wdt_timer);
+	cancel_work_sync(&data->work_wdt);
+}
+
+/**
+ * ssp_get_sensor_delay() - gets sensor data acquisition period
+ * @data:	sensorhub structure
+ * @type:	SSP sensor type
+ *
+ * Returns acquisition period in ms
+ */
+u32 ssp_get_sensor_delay(struct ssp_data *data, enum ssp_sensor_type type)
+{
+	return data->delay_buf[type];
+}
+EXPORT_SYMBOL(ssp_get_sensor_delay);
+
+/**
+ * ssp_enable_sensor() - enables data acquisition for sensor
+ * @data:	sensorhub structure
+ * @type:	SSP sensor type
+ * @delay:	delay in ms
+ *
+ * Returns 0 or negative value in case of error
+ */
+int ssp_enable_sensor(struct ssp_data *data, enum ssp_sensor_type type,
+		       u32 delay)
+{
+	int ret = 0;
+	struct {
+		__le32 a;
+		__le32 b;
+		u8 c;
+	} __attribute__((__packed__)) to_send;
+
+	to_send.a = cpu_to_le32(delay);
+	to_send.b = cpu_to_le32(data->batch_latency_buf[type]);
+	to_send.c = data->batch_opt_buf[type];
+
+	switch (data->check_status[type]) {
+	case SSP_INITIALIZATION_STATE:
+		/* do calibration step */
+	case SSP_ADD_SENSOR_STATE:
+		ret = ssp_send_instruction(data,
+					   SSP_MSG2SSP_INST_BYPASS_SENSOR_ADD,
+					   type,
+					   (char *)&to_send, sizeof(to_send));
+		if (ret < 0) {
+			dev_err(&data->spi->dev, "Enabling sensor failed\n");
+			data->check_status[type] = SSP_NO_SENSOR_STATE;
+			goto derror;
+		}
+
+		data->sensor_enable |= 1 << type;
+		data->check_status[type] = SSP_RUNNING_SENSOR_STATE;
+		break;
+	case SSP_RUNNING_SENSOR_STATE:
+		ret = ssp_send_instruction(data,
+					   SSP_MSG2SSP_INST_CHANGE_DELAY, type,
+				       (char *)&to_send, sizeof(to_send));
+		if (ret < 0) {
+			dev_err(&data->spi->dev,
+				"Changing delay sensor failed\n");
+			goto derror;
+		}
+		break;
+	default:
+		data->check_status[type] = SSP_ADD_SENSOR_STATE;
+		break;
+	}
+
+	data->delay_buf[type] = delay;
+
+	if (atomic_inc_return(&data->enable_refcount) == 1)
+		enable_wdt_timer(data);
+
+	return 0;
+
+derror:
+	return -EIO;
+}
+EXPORT_SYMBOL(ssp_enable_sensor);
+
+/**
+ * ssp_change_delay() - changes data acquisition for sensor
+ * @data:	sensorhub structure
+ * @type:	SSP sensor type
+ * @delay:	delay in ms
+ *
+ * Returns 0 or negative value in case of error
+ */
+int ssp_change_delay(struct ssp_data *data, enum ssp_sensor_type type,
+		     u32 delay)
+{
+	int ret = 0;
+	struct {
+		__le32 a;
+		__le32 b;
+		u8 c;
+	} __attribute__((__packed__)) to_send;
+
+	to_send.a = cpu_to_le32(delay);
+	to_send.b = cpu_to_le32(data->batch_latency_buf[type]);
+	to_send.c = data->batch_opt_buf[type];
+
+	ret = ssp_send_instruction(data, SSP_MSG2SSP_INST_CHANGE_DELAY, type,
+			       (char *)&to_send, sizeof(to_send));
+	if (ret < 0) {
+		dev_err(&data->spi->dev,
+			"Changing delay sensor failed\n");
+		return ret;
+	}
+
+	data->delay_buf[type] = delay;
+
+	return ret;
+}
+EXPORT_SYMBOL(ssp_change_delay);
+
+/**
+ * ssp_disable_sensor() - disables sensor
+ *
+ * @data:	sensorhub structure
+ * @type:	SSP sensor type
+ *
+ * Returns 0 or negative value in case of error
+ */
+int ssp_disable_sensor(struct ssp_data *data, enum ssp_sensor_type type)
+{
+	int ret = 0;
+	__le32 command;
+
+	if (data->sensor_enable & (1 << type)) {
+		command  = cpu_to_le32(data->delay_buf[type]);
+		ret = ssp_send_instruction(data,
+					  SSP_MSG2SSP_INST_BYPASS_SENSOR_REMOVE,
+				       type, (char *)&command, sizeof(__le32));
+		if (ret < 0) {
+			dev_err(&data->spi->dev, "Remove sensor fail\n");
+			return ret;
+		}
+
+		data->sensor_enable &= (~(1 << type));
+	}
+
+	data->check_status[type] = SSP_ADD_SENSOR_STATE;
+
+	if (atomic_dec_and_test(&data->enable_refcount))
+		disable_wdt_timer(data);
+
+	return ret;
+}
+EXPORT_SYMBOL(ssp_disable_sensor);
+
+static irqreturn_t sensordata_irq_thread_fn(int irq, void *dev_id)
+{
+	struct ssp_data *data = dev_id;
+
+	ssp_irq_msg(data);
+
+	return IRQ_HANDLED;
+}
+
+static int ssp_initialize_mcu(struct ssp_data *data)
+{
+	int ret;
+
+	ssp_clean_pending_list(data);
+
+	ret = ssp_get_chipid(data);
+	if (ret != SSP_DEVICE_ID) {
+		dev_err(&data->spi->dev, "%s - MCU %s ret = %d\n", __func__,
+		       ret < 0 ? "is not working" : "identyfication failed",
+		       ret);
+		return ret >= 0 ? -ENODEV : ret;
+	}
+
+	dev_info(&data->spi->dev, "MCU device ID = %d, reading ID = %d\n",
+		 SSP_DEVICE_ID, ret);
+
+	ret = ssp_set_sensor_position(data);
+	if (ret < 0) {
+		dev_err(&data->spi->dev, "ssp_set_sensor_position failed\n");
+		return ret;
+	}
+
+	ret = ssp_set_magnetic_matrix(data);
+	if (ret < 0)
+		dev_err(&data->spi->dev,
+			"%s - ssp_set_magnetic_matrix failed\n", __func__);
+
+	data->available_sensors = ssp_get_sensor_scanning_info(data);
+	if (data->available_sensors == 0) {
+		dev_err(&data->spi->dev,
+			"%s - ssp_get_sensor_scanning_info failed\n", __func__);
+		return -EIO;
+	}
+
+	data->cur_firm_rev = ssp_get_firmware_rev(data);
+	dev_info(&data->spi->dev, "MCU Firm Rev : New = %8u\n",
+		 data->cur_firm_rev);
+
+	return ssp_command(data, SSP_MSG2SSP_AP_MCU_DUMP_CHECK, 0);
+}
+
+static void ssp_refresh_task(struct work_struct *work)
+{
+	struct ssp_data *data = container_of((struct delayed_work *)work,
+			struct ssp_data, work_refresh);
+
+	dev_info(&data->spi->dev, "refreshing\n");
+
+	data->reset_cnt++;
+
+	if (ssp_initialize_mcu(data) > 0) {
+		sync_available_sensors(data);
+		if (data->last_ap_state != 0)
+			ssp_command(data, data->last_ap_state, 0);
+
+		if (data->last_resume_state != 0)
+			ssp_command(data, data->last_resume_state, 0);
+
+		data->time_out_cnt = 0;
+		data->com_fail_cnt = 0;
+	}
+}
+
+int ssp_queue_ssp_refresh_task(struct ssp_data *data, int delay)
+{
+	cancel_delayed_work_sync(&data->work_refresh);
+
+	return queue_delayed_work(system_power_efficient_wq,
+				  &data->work_refresh,
+				  msecs_to_jiffies(delay));
+}
+
+static void work_function_firmware_update(struct work_struct *work)
+{
+	int ret;
+	struct ssp_data *data = container_of((struct delayed_work *)work,
+				struct ssp_data, work_firmware);
+
+	dev_info(&data->spi->dev, "%s, is called\n", __func__);
+
+	ret = ssp_forced_to_download(data, SSP_KERNEL_BINARY);
+	if (ret < 0) {
+		dev_err(&data->spi->dev,
+			 "%s, ssp_forced_to_download failed!\n",
+			__func__);
+		return;
+	}
+
+	ssp_queue_ssp_refresh_task(data, SSP_SW_RESET_TIME);
+
+	dev_info(&data->spi->dev, "%s done\n", __func__);
+}
+
+#ifdef CONFIG_OF
+static struct of_device_id ssp_of_match[] = {
+	{
+		.compatible	= "samsung,sensorhub-rinato",
+		.data		= &rinato_info,
+	}, {
+		.compatible	= "samsung,sensorhub-thermostat",
+		.data		= &thermostat_info,
+	},
+};
+MODULE_DEVICE_TABLE(of, ssp_of_match);
+
+static struct ssp_data *ssp_parse_dt(struct device *dev)
+{
+	int ret;
+	struct ssp_data *pdata;
+	struct device_node *node = dev->of_node;
+	const struct of_device_id *match;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	pdata->mcu_ap_gpio = of_get_named_gpio(node, "mcu-ap-gpio", 0);
+	if (pdata->mcu_ap_gpio < 0)
+		goto err_free_pd;
+
+	pdata->ap_mcu_gpio = of_get_named_gpio(node, "ap-mcu-gpio", 0);
+	if (pdata->ap_mcu_gpio < 0)
+		goto err_free_pd;
+
+	pdata->mcu_reset = of_get_named_gpio(node, "mcu-reset", 0);
+	if (pdata->mcu_reset < 0)
+		goto err_free_pd;
+
+	ret = devm_gpio_request_one(dev, pdata->ap_mcu_gpio,
+				    GPIOF_OUT_INIT_HIGH, "ap-mcu-gpio");
+	if (ret)
+		goto err_free_pd;
+
+	ret = devm_gpio_request_one(dev, pdata->mcu_reset,
+				    GPIOF_OUT_INIT_HIGH, "mcu-reset");
+	if (ret)
+		goto err_ap_mcu;
+
+	match = of_match_node(ssp_of_match, node);
+	if (!match)
+		goto err_mcu_reset;
+
+	pdata->sensorhub_info = (struct ssp_sensorhub_info *) match->data;
+
+	ret = of_platform_populate(node, NULL, NULL, dev);
+	if (ret < 0) {
+		dev_err(dev, "of_platform_populate fail\n");
+		goto err_mcu_reset;
+	}
+
+	return pdata;
+
+err_mcu_reset:
+	devm_gpio_free(dev, pdata->mcu_reset);
+err_ap_mcu:
+	devm_gpio_free(dev, pdata->ap_mcu_gpio);
+err_free_pd:
+	devm_kfree(dev, pdata);
+	return NULL;
+}
+#else
+static struct ssp_data *ssp_parse_dt(struct platform_device *pdev)
+{
+	return NULL;
+}
+#endif
+
+/**
+ * ssp_register_consumer() - registers iio consumer in ssp framework
+ *
+ * @indio_dev:	consumer iio device
+ * @type:	ssp sensor type
+ */
+void ssp_register_consumer(struct iio_dev *indio_dev, enum ssp_sensor_type type)
+{
+	/*TODO 3rd level device - hide it*/
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	data->sensor_devs[type] = indio_dev;
+}
+EXPORT_SYMBOL(ssp_register_consumer);
+
+static int ssp_probe(struct spi_device *spi)
+{
+	int ret, i;
+	struct ssp_data *data;
+
+	data = spi->dev.platform_data;
+	if (!data) {
+		data = ssp_parse_dt(&spi->dev);
+		if (!data) {
+			dev_err(&spi->dev,
+				"%s:Failed to find platform data\n", __func__);
+			return -ENODEV;
+		}
+	}
+
+	spi->mode = SPI_MODE_1;
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		dev_err(&spi->dev, "Failed to setup spi\n");
+		goto err_setup;
+	}
+
+	data->fw_dl_state = SSP_FW_DL_STATE_NONE;
+	data->spi = spi;
+	spi_set_drvdata(spi, data);
+
+	mutex_init(&data->comm_lock);
+	mutex_init(&data->pending_lock);
+
+	for (i = 0; i < SSP_SENSOR_MAX; ++i) {
+		data->delay_buf[i] = SSP_DEFUALT_POLLING_DELAY;
+		data->batch_latency_buf[i] = 0;
+		data->batch_opt_buf[i] = 0;
+		data->check_status[i] = SSP_INITIALIZATION_STATE;
+	}
+
+	data->delay_buf[SSP_BIO_HRM_LIB] = 100;
+
+	data->time_syncing = true;
+
+	INIT_LIST_HEAD(&data->pending_list);
+
+	atomic_set(&data->enable_refcount, 0);
+
+	INIT_DELAYED_WORK(&data->work_firmware, work_function_firmware_update);
+	INIT_WORK(&data->work_wdt, wdt_work_func);
+	INIT_DELAYED_WORK(&data->work_refresh, ssp_refresh_task);
+
+	setup_timer(&data->wdt_timer, wdt_timer_func, (unsigned long)data);
+
+	ret = request_threaded_irq(data->spi->irq, NULL,
+				   sensordata_irq_thread_fn,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   "SSP_Int", data);
+	if (ret < 0) {
+		dev_err(&spi->dev, "Irq request fail\n");
+		goto err_setup_irq;
+	}
+
+	/* Let's start with enabled one so irq balance could be ok */
+	data->shut_down = false;
+
+	/* just to avoid unbalanced irq set wake up */
+	enable_irq_wake(data->spi->irq);
+
+	data->fw_dl_state = ssp_check_fwbl(data);
+	if (data->fw_dl_state == SSP_FW_DL_STATE_NONE) {
+		ret = ssp_initialize_mcu(data);
+		if (ret < 0) {
+			dev_err(&spi->dev, "Initialize_mcu failed\n");
+			goto err_read_reg;
+		}
+	}
+
+	if (data->fw_dl_state == SSP_FW_DL_STATE_NEED_TO_SCHEDULE) {
+		dev_info(&spi->dev, "Firmware update is scheduled\n");
+		queue_delayed_work(system_power_efficient_wq,
+				&data->work_firmware, msecs_to_jiffies(1000));
+		data->fw_dl_state = SSP_FW_DL_STATE_SCHEDULED;
+	} else if (data->fw_dl_state == SSP_FW_DL_STATE_FAIL) {
+		data->shut_down = true;
+	}
+
+	return 0;
+
+err_read_reg:
+	free_irq(data->spi->irq, data);
+err_setup_irq:
+	mutex_destroy(&data->pending_lock);
+	mutex_destroy(&data->comm_lock);
+err_setup:
+	dev_err(&spi->dev, "Probe failed!\n");
+
+	return ret;
+}
+
+static int ssp_remove(struct spi_device *spi)
+{
+	struct ssp_data *data = spi_get_drvdata(spi);
+
+	if (data->fw_dl_state >= SSP_FW_DL_STATE_SCHEDULED &&
+		data->fw_dl_state < SSP_FW_DL_STATE_DONE) {
+		dev_err(&data->spi->dev,
+			"cancel_delayed_work_sync state = %d\n",
+			data->fw_dl_state);
+		cancel_delayed_work_sync(&data->work_firmware);
+	}
+
+	if (ssp_command(data, SSP_MSG2SSP_AP_STATUS_SHUTDOWN, 0) < 0)
+		dev_err(&data->spi->dev, "SSP_MSG2SSP_AP_STATUS_SHUTDOWN failed\n");
+
+	ssp_enable_mcu(data, false);
+	disable_wdt_timer(data);
+
+	ssp_clean_pending_list(data);
+
+	free_irq(data->spi->irq, data);
+
+	del_timer_sync(&data->wdt_timer);
+	cancel_work_sync(&data->work_wdt);
+
+	mutex_destroy(&data->comm_lock);
+	mutex_destroy(&data->pending_lock);
+
+#ifdef CONFIG_OF
+	of_platform_depopulate(&spi->dev);
+#endif
+
+	return 0;
+}
+
+static int ssp_suspend(struct device *dev)
+{
+	int ret = 0;
+	struct ssp_data *data = spi_get_drvdata(to_spi_device(dev));
+
+	data->last_resume_state = SSP_MSG2SSP_AP_STATUS_SUSPEND;
+
+	if (atomic_read(&data->enable_refcount) > 0)
+		disable_wdt_timer(data);
+
+	if (ssp_command(data, SSP_MSG2SSP_AP_STATUS_SUSPEND, 0) < 0)
+		dev_err(&data->spi->dev,
+			"%s SSP_MSG2SSP_AP_STATUS_SUSPEND failed\n", __func__);
+
+	data->time_syncing = false;
+	disable_irq(data->spi->irq);
+
+	return ret;
+}
+
+static int ssp_resume(struct device *dev)
+{
+	int ret = 0;
+	struct ssp_data *data = spi_get_drvdata(to_spi_device(dev));
+
+	enable_irq(data->spi->irq);
+
+	if (atomic_read(&data->enable_refcount) > 0)
+		enable_wdt_timer(data);
+
+	if (ssp_command(data, SSP_MSG2SSP_AP_STATUS_RESUME, 0) < 0)
+		dev_err(&data->spi->dev,
+			"%s SSP_MSG2SSP_AP_STATUS_RESUME failed\n", __func__);
+
+	data->last_resume_state = SSP_MSG2SSP_AP_STATUS_RESUME;
+
+	return ret;
+}
+
+static const struct dev_pm_ops ssp_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ssp_suspend, ssp_resume)
+};
+
+static struct spi_driver ssp_driver = {
+	.probe = ssp_probe,
+	.remove = ssp_remove,
+	.driver = {
+		.pm = &ssp_pm_ops,
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(ssp_of_match),
+		.name = "sensorhub"
+	},
+};
+
+module_spi_driver(ssp_driver);
+
+MODULE_DESCRIPTION("ssp sensorhub driver");
+MODULE_AUTHOR("Samsung Electronics");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/sensorhub/ssp_spi.c b/drivers/misc/sensorhub/ssp_spi.c
new file mode 100644
index 0000000..e055b7d
--- /dev/null
+++ b/drivers/misc/sensorhub/ssp_spi.c
@@ -0,0 +1,639 @@
+/*
+ *  Copyright (C) 2012, Samsung Electronics Co. Ltd. All Rights Reserved.
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
+#include "ssp.h"
+
+#define SSP_DEV (&data->spi->dev)
+#define GET_MESSAGE_TYPE(data) (data & (3 << SSP_RW))
+
+/* SSP -> AP Instruction
+ * They tell what packet type can be expected. In the future there will
+ * be less of them. BYPASS means common sensor packets with accel, gyro,
+ * hrm etc. data. LIBRARY and META are mock-up's for now. */
+#define MSG2AP_INST_BYPASS_DATA		0x37
+#define MSG2AP_INST_LIBRARY_DATA	0x01
+#define MSG2AP_INST_DEBUG_DATA		0x03
+#define MSG2AP_INST_BIG_DATA		0x04
+#define MSG2AP_INST_META_DATA		0x05
+#define MSG2AP_INST_TIME_SYNC		0x06
+#define MSG2AP_INST_RESET		0x07
+
+#define UNINPLEMENTED -1
+
+struct ssp_msg_header {
+	u8 cmd;
+	__le16 length;
+	__le16 options;
+	__le32 data;
+} __attribute__((__packed__));
+
+struct ssp_msg {
+	u16 length;
+	u16 options;
+	struct list_head list;
+	struct completion *done;
+	struct ssp_msg_header *h;
+	char *buffer;
+};
+
+static const int offset_map[SSP_SENSOR_MAX] = {
+	[SSP_ACCELEROMETER_SENSOR] =		SSP_ACCELEROMETER_SIZE +
+		SSP_TIME_SIZE,
+	[SSP_GYROSCOPE_SENSOR] =		SSP_GYROSCOPE_SIZE+
+		SSP_TIME_SIZE,
+	[SSP_GEOMAGNETIC_UNCALIB_SENSOR] =	UNINPLEMENTED,
+	[SSP_GEOMAGNETIC_RAW] =			UNINPLEMENTED,
+	[SSP_GEOMAGNETIC_SENSOR] =		UNINPLEMENTED,
+	[SSP_PRESSURE_SENSOR] =			UNINPLEMENTED,
+	[SSP_GESTURE_SENSOR] =			UNINPLEMENTED,
+	[SSP_PROXIMITY_SENSOR] =		UNINPLEMENTED,
+	[SSP_TEMPERATURE_HUMIDITY_SENSOR] =	UNINPLEMENTED,
+	[SSP_LIGHT_SENSOR] =			UNINPLEMENTED,
+	[SSP_PROXIMITY_RAW] =			UNINPLEMENTED,
+	[SSP_ORIENTATION_SENSOR] =		UNINPLEMENTED,
+	[SSP_STEP_DETECTOR] =			UNINPLEMENTED,
+	[SSP_SIG_MOTION_SENSOR] =		UNINPLEMENTED,
+	[SSP_GYRO_UNCALIB_SENSOR] =		UNINPLEMENTED,
+	[SSP_GAME_ROTATION_VECTOR] =		UNINPLEMENTED,
+	[SSP_ROTATION_VECTOR] =			UNINPLEMENTED,
+	[SSP_STEP_COUNTER] =			UNINPLEMENTED ,
+	[SSP_BIO_HRM_RAW] =			SSP_BIO_HRM_RAW_SIZE +
+		SSP_TIME_SIZE,
+	[SSP_BIO_HRM_RAW_FAC] =			SSP_BIO_HRM_RAW_FAC_SIZE +
+		SSP_TIME_SIZE,
+	[SSP_BIO_HRM_LIB] =			SSP_BIO_HRM_LIB_SIZE +
+		SSP_TIME_SIZE,
+};
+
+#define SSP_HEADER_SIZE		(sizeof(struct ssp_msg_header))
+#define SSP_HEADER_SIZE_ALIGNED	(ALIGN(SSP_HEADER_SIZE, 4))
+
+static struct ssp_msg *create_msg(u8 cmd, u16 len, u16 opt, u32 data)
+{
+	struct ssp_msg_header h;
+	struct ssp_msg *msg;
+
+	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
+	if (!msg)
+		return NULL;
+
+	h.cmd = cmd;
+	h.length = cpu_to_le16(len);
+	h.options = cpu_to_le16(opt);
+	h.data = cpu_to_le32(data);
+
+	msg->buffer = kzalloc(SSP_HEADER_SIZE_ALIGNED + len,
+			      GFP_KERNEL | GFP_DMA);
+	if (msg->buffer == NULL) {
+		kfree(msg);
+		return NULL;
+	}
+
+	msg->length = len;
+	msg->options = opt;
+
+	memcpy(msg->buffer, &h, SSP_HEADER_SIZE);
+
+	return msg;
+}
+
+static inline void fill_buffer(struct ssp_msg *m, unsigned int offset,
+			       const void *src, unsigned int len)
+{
+	memcpy(&m->buffer[SSP_HEADER_SIZE_ALIGNED + offset], src, len);
+}
+
+static inline void get_buffer(struct ssp_msg *m, unsigned int offset,
+			      void *dest, unsigned int len)
+{
+	memcpy(dest, &m->buffer[SSP_HEADER_SIZE_ALIGNED + offset],  len);
+}
+
+#define GET_BUFFER_AT_INDEX(m, index) \
+	(m->buffer[SSP_HEADER_SIZE_ALIGNED + index])
+#define SET_BUFFER_AT_INDEX(m, index, val) \
+	(m->buffer[SSP_HEADER_SIZE_ALIGNED + index] = val)
+
+static void clean_msg(struct ssp_msg *m)
+{
+	kfree(m->buffer);
+	kfree(m);
+}
+
+static int print_mcu_debug(char *data_frame, int *data_index,
+			   int received_len)
+{
+	int length = data_frame[(*data_index)++];
+
+	if (length > received_len - *data_index || length <= 0) {
+		ssp_dbg("[SSP]: MSG From MCU-invalid debug length(%d/%d)\n",
+			length, received_len);
+		return length ? length : -1;
+	}
+
+	ssp_dbg("[SSP]: MSG From MCU - %s\n", &data_frame[*data_index]);
+
+	*data_index += length;
+
+	return 0;
+}
+
+/* It was designed that way - additional lines to some kind of handshake,
+ * please do not ask why - only the firmware guy can know it */
+static int check_lines(struct ssp_data *data, bool state)
+{
+	int delay_cnt = 0, status = 0;
+
+	gpio_set_value_cansleep(data->ap_mcu_gpio, state);
+
+	while (gpio_get_value_cansleep(data->mcu_ap_gpio) != state) {
+
+		usleep_range(3000, 3500);
+
+		if (data->shut_down || delay_cnt++ > 500) {
+			dev_err(SSP_DEV, "%s:timeout, hw ack wait fail %d\n",
+				__func__, state);
+
+			if (!state) {
+				gpio_set_value_cansleep(data->ap_mcu_gpio, 1);
+				status = -1;
+			} else
+				status = -2;
+
+			break;
+		}
+	}
+
+	return status;
+}
+
+static int do_transfer(struct ssp_data *data, struct ssp_msg *msg,
+		       struct completion *done, int timeout)
+{
+	int status = 0;
+	/*check if this is a short one way message or the whole transfer has
+	 * second part after an interrupt */
+	const bool use_no_irq = msg->length == 0;
+
+	if (data->shut_down)
+		return -EPERM;
+
+	msg->done = done;
+
+	mutex_lock(&data->comm_lock);
+
+	status = check_lines(data, false);
+	if (status < 0) {
+		status = -ETIMEDOUT;
+		goto _error_locked;
+	}
+
+	status = spi_write(data->spi, msg->buffer, SSP_HEADER_SIZE);
+	if (status < 0) {
+		gpio_set_value_cansleep(data->ap_mcu_gpio, 1);
+		dev_err(SSP_DEV, "%s spi_write fail\n", __func__);
+		goto _error_locked;
+	}
+
+	if (!use_no_irq) {
+		mutex_lock(&data->pending_lock);
+		list_add_tail(&msg->list, &data->pending_list);
+		mutex_unlock(&data->pending_lock);
+	}
+
+	status = check_lines(data, true);
+	if (status < 0) {
+		status = -ETIMEDOUT;
+		if (!use_no_irq) {
+			mutex_lock(&data->pending_lock);
+			list_del(&msg->list);
+			mutex_unlock(&data->pending_lock);
+		}
+		goto _error_locked;
+	}
+
+	mutex_unlock(&data->comm_lock);
+
+	if (use_no_irq)
+		return status;
+
+	if (done != NULL)
+		if (wait_for_completion_timeout(done,
+					msecs_to_jiffies(timeout)) == 0) {
+			mutex_lock(&data->pending_lock);
+			list_del(&msg->list);
+			mutex_unlock(&data->pending_lock);
+
+			status = -ETIMEDOUT;
+			data->time_out_cnt++;
+		}
+
+	return status;
+
+_error_locked:
+	mutex_unlock(&data->comm_lock);
+	data->time_out_cnt++;
+	return status;
+}
+
+static inline int ssp_spi_sync_command(struct ssp_data *data,
+				       struct ssp_msg *msg)
+{
+	return do_transfer(data, msg, NULL, 0);
+}
+
+static int ssp_spi_sync(struct ssp_data *data, struct ssp_msg *msg,
+			int timeout)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	if (WARN_ON(!msg->length))
+		return -EPERM;
+
+	return do_transfer(data, msg, &done, timeout);
+}
+
+static int handle_big_data(struct ssp_data *data, char *dataframe,
+			   int *idx) {
+	/* mock-up, it will be changed with adding another sensor types */
+	*idx += 8;
+	return 0;
+}
+
+static int parse_dataframe(struct ssp_data *data, char *dataframe,
+			   int len)
+{
+	int idx, sd, ret = 0;
+	u16 length = 0;
+	struct timespec ts;
+	struct ssp_sensor_data *sdata;
+	struct iio_dev **indio_devs = data->sensor_devs;
+
+	getnstimeofday(&ts);
+
+	for (idx = 0; idx < len;) {
+		switch (dataframe[idx++]) {
+		case MSG2AP_INST_BYPASS_DATA:
+			sd = dataframe[idx++];
+			if (sd < 0 || sd >= SSP_SENSOR_MAX) {
+				dev_err(SSP_DEV,
+					"Mcu data frame1 error %d\n", sd);
+				return -1;
+			}
+
+			if (indio_devs[sd] != NULL) {
+				sdata = iio_priv(indio_devs[sd]);
+				if (sdata->process_data)
+					sdata->process_data(
+							    indio_devs[sd],
+							    &dataframe[idx],
+							    data->timestamp);
+			}
+			idx += offset_map[sd];
+			break;
+		case MSG2AP_INST_DEBUG_DATA:
+			sd = print_mcu_debug(dataframe, &idx, len);
+			if (sd) {
+				dev_err(SSP_DEV,
+					"Mcu data frame3 error %d\n", sd);
+				return -1;
+			}
+			break;
+		case MSG2AP_INST_LIBRARY_DATA:
+			idx += length;
+			break;
+		case MSG2AP_INST_BIG_DATA:
+			handle_big_data(data, dataframe, &idx);
+			break;
+		case MSG2AP_INST_TIME_SYNC:
+			data->time_syncing = true;
+			break;
+		case MSG2AP_INST_RESET:
+			ssp_queue_ssp_refresh_task(data, 0);
+			break;
+		}
+	}
+
+	if (data->time_syncing)
+		data->timestamp = ts.tv_sec * 1000000000ULL + ts.tv_nsec;
+
+	return ret;
+}
+
+/* threaded irq */
+int ssp_irq_msg(struct ssp_data *data)
+{
+	bool found = false;
+	char *buffer;
+	__le16 *temp_buf;
+	u8 msg_type = 0;
+	int ret = 0;
+	u16 length, msg_options;
+	struct ssp_msg *msg, *n;
+
+	temp_buf = kmalloc(4, GFP_KERNEL | GFP_DMA);
+	if (temp_buf == NULL)
+		return -ENOMEM;
+
+	ret = spi_read(data->spi, temp_buf, 4);
+	if (ret < 0) {
+		dev_err(SSP_DEV, "header read fail\n");
+		kfree(temp_buf);
+		return ret;
+	}
+
+	length = le16_to_cpu(temp_buf[1]);
+	msg_options = le16_to_cpu(temp_buf[0]);
+
+	kfree(temp_buf);
+
+	if (length == 0) {
+		dev_err(SSP_DEV, "length received from mcu is 0\n");
+		return -EINVAL;
+	}
+
+	msg_type = GET_MESSAGE_TYPE(msg_options);
+
+	switch (msg_type) {
+	case SSP_AP2HUB_READ:
+	case SSP_AP2HUB_WRITE:
+		/* this is a small list, a few elements - the packets can be
+		 * received with no order */
+		mutex_lock(&data->pending_lock);
+		list_for_each_entry_safe(msg, n, &data->pending_list, list) {
+			if (msg->options == msg_options) {
+				list_del(&msg->list);
+				found = true;
+				break;
+			}
+		}
+
+		if (!found) {
+			/* here can be implemented dead messages handling
+			 * but the slave should not send such ones - it is to
+			 * check but let's handle this */
+			buffer = kmalloc(length, GFP_KERNEL | GFP_DMA);
+			if (!buffer) {
+				ret = -ENOMEM;
+				goto _unlock;
+			}
+
+			ret = spi_read(data->spi, buffer, length);
+			dev_err(SSP_DEV, "No match error %x\n",
+				msg_options);
+			ret = -EIO; /* got dead packet so it is always an
+					error */
+			kfree(buffer);
+			goto _unlock;
+		}
+
+		if (msg_type == SSP_AP2HUB_READ)
+			ret = spi_read(data->spi,
+				       &msg->buffer[SSP_HEADER_SIZE_ALIGNED],
+				       msg->length);
+
+		if (msg_type == SSP_AP2HUB_WRITE) {
+			ret = spi_write(data->spi,
+					&msg->buffer[SSP_HEADER_SIZE_ALIGNED],
+					msg->length);
+			if (msg_options & SSP_AP2HUB_RETURN) {
+				msg->options =
+					SSP_AP2HUB_READ | SSP_AP2HUB_RETURN;
+				msg->length = 1;
+
+				list_add_tail(&msg->list,
+					      &data->pending_list);
+				goto _unlock;
+			}
+		}
+
+		if (msg->done)
+			if (!completion_done(msg->done))
+				complete(msg->done);
+_unlock:
+		mutex_unlock(&data->pending_lock);
+		break;
+	case SSP_HUB2AP_WRITE:
+		buffer = kzalloc(length, GFP_KERNEL | GFP_DMA);
+		if (buffer == NULL)
+			return  -ENOMEM;
+
+		ret = spi_read(data->spi, buffer, length);
+		if (ret < 0) {
+			dev_err(SSP_DEV, "spi read fail\n");
+			kfree(buffer);
+			break;
+		}
+
+		parse_dataframe(data, buffer, length);
+
+		kfree(buffer);
+		break;
+
+	default:
+		dev_err(SSP_DEV, "unknown msg type\n");
+		break;
+	}
+
+	return ret;
+}
+
+void ssp_clean_pending_list(struct ssp_data *data)
+{
+	struct ssp_msg *msg, *n;
+
+	mutex_lock(&data->pending_lock);
+	list_for_each_entry_safe(msg, n, &data->pending_list, list) {
+		list_del(&msg->list);
+
+		if (msg->done)
+			if (!completion_done(msg->done))
+				complete(msg->done);
+	}
+	mutex_unlock(&data->pending_lock);
+}
+
+int ssp_command(struct ssp_data *data, char command, int arg)
+{
+	int ret;
+	struct ssp_msg *msg;
+
+	msg = create_msg(command, 0, SSP_AP2HUB_WRITE, arg);
+	if (!msg)
+		return -ENOMEM;
+
+	ssp_dbg("%s - command 0x%x %d\n", __func__, command, arg);
+
+	ret = ssp_spi_sync_command(data, msg);
+	clean_msg(msg);
+
+	return ret;
+}
+
+int ssp_send_instruction(struct ssp_data *data, u8 inst, u8 sensor_type,
+			 u8 *send_buf, u8 length)
+{
+	int ret;
+	struct ssp_msg *msg;
+
+	if (data->fw_dl_state == SSP_FW_DL_STATE_DOWNLOADING) {
+		dev_err(SSP_DEV, "%s - Skip Inst! DL state = %d\n",
+			__func__, data->fw_dl_state);
+		return -EBUSY;
+	} else if ((!(data->available_sensors & (1 << sensor_type)))
+		   && (inst <= SSP_MSG2SSP_INST_CHANGE_DELAY)) {
+		dev_err(SSP_DEV, "%s - Bypass Inst Skip! - %u\n",
+			__func__, sensor_type);
+		return -EIO; /* just fail */
+	}
+
+	msg = create_msg(inst, length + 2, SSP_AP2HUB_WRITE, 0);
+	if (!msg)
+		return -ENOMEM;
+
+	fill_buffer(msg, 0, &sensor_type, 1);
+	fill_buffer(msg, 1, send_buf, length);
+
+	ssp_dbg("%s - Inst = 0x%x, Sensor Type = 0x%x, data = %u\n",
+		__func__, inst, sensor_type, send_buf[1]);
+
+	ret = ssp_spi_sync(data, msg, 1000);
+	clean_msg(msg);
+
+	return ret;
+}
+
+int ssp_get_chipid(struct ssp_data *data)
+{
+	int ret;
+	char buffer = 0;
+	struct ssp_msg *msg;
+
+	msg = create_msg(SSP_MSG2SSP_AP_WHOAMI, 1, SSP_AP2HUB_READ, 0);
+	if (!msg)
+		return -ENOMEM;
+
+
+	ret = ssp_spi_sync(data, msg, 1000);
+
+	buffer = GET_BUFFER_AT_INDEX(msg, 0);
+
+	clean_msg(msg);
+
+	return ret < 0 ? ret : buffer;
+}
+
+int ssp_set_sensor_position(struct ssp_data *data)
+{
+	int ret = 0;
+
+	struct ssp_msg *msg = create_msg(SSP_MSG2SSP_AP_SENSOR_FORMATION, 3,
+					 SSP_AP2HUB_WRITE, 0);
+	if (!msg)
+		return -ENOMEM;
+
+	/* this needs some calrification with the protocol, default they will
+	 * be 0 so it is ok */
+	SET_BUFFER_AT_INDEX(msg, 0, data->accel_position);
+	SET_BUFFER_AT_INDEX(msg, 1, data->accel_position);
+	SET_BUFFER_AT_INDEX(msg, 2, data->mag_position);
+
+	ret = ssp_spi_sync(data, msg, 1000);
+	if (ret < 0) {
+		dev_err(SSP_DEV, "%s -fail to ssp_set_sensor_position %d\n",
+			__func__, ret);
+	} else {
+		dev_info(SSP_DEV,
+			 "Sensor Posision A : %u, G : %u, M: %u, P: %u\n",
+			 data->accel_position, data->accel_position,
+			 data->mag_position, 0);
+	}
+
+	clean_msg(msg);
+
+	return ret;
+}
+
+int ssp_set_magnetic_matrix(struct ssp_data *data)
+{
+	int ret;
+	struct ssp_msg *msg =
+		create_msg(SSP_MSG2SSP_AP_SET_MAGNETIC_STATIC_MATRIX,
+			   data->sensorhub_info->mag_length,
+			   SSP_AP2HUB_WRITE,
+			   0);
+	if (!msg)
+		return -ENOMEM;
+
+	fill_buffer(msg, 0, data->sensorhub_info->mag_table,
+		    data->sensorhub_info->mag_length);
+
+	ret = ssp_spi_sync(data, msg, 1000);
+	clean_msg(msg);
+
+	return ret;
+}
+
+unsigned int ssp_get_sensor_scanning_info(struct ssp_data *data)
+{
+	int ret;
+	__le32 result;
+	u32 cpu_result = 0;
+
+	struct ssp_msg *msg = create_msg(SSP_MSG2SSP_AP_SENSOR_SCANNING, 4,
+					 SSP_AP2HUB_READ, 0);
+	if (!msg)
+		return 0;
+
+	ret = ssp_spi_sync(data, msg, 1000);
+	if (ret < 0) {
+		dev_err(SSP_DEV, "%s - spi read fail %d\n", __func__, ret);
+		goto _exit;
+	}
+
+	get_buffer(msg, 0, &result, 4);
+	cpu_result = le32_to_cpu(result);
+
+	dev_info(SSP_DEV, "%s state: 0x%08x\n", __func__, cpu_result);
+
+_exit:
+	clean_msg(msg);
+	return cpu_result;
+}
+
+unsigned int ssp_get_firmware_rev(struct ssp_data *data)
+{
+	int ret;
+	__le32 result;
+
+	struct ssp_msg *msg = create_msg(SSP_MSG2SSP_AP_FIRMWARE_REV, 4,
+					 SSP_AP2HUB_READ, 0);
+	if (!msg)
+		return  SSP_INVALID_REVISION;
+
+	ret = ssp_spi_sync(data, msg, 1000);
+	get_buffer(msg, 0, &result, 4);
+	if (ret  < 0) {
+		dev_err(SSP_DEV, "%s - transfer fail %d\n", __func__, ret);
+		ret = SSP_INVALID_REVISION;
+		goto _exit;
+	}
+
+	ret = le32_to_cpu(result);
+
+_exit:
+	clean_msg(msg);
+	return ret;
+}
diff --git a/include/linux/iio/common/ssp_sensors.h b/include/linux/iio/common/ssp_sensors.h
new file mode 100644
index 0000000..322c767
--- /dev/null
+++ b/include/linux/iio/common/ssp_sensors.h
@@ -0,0 +1,80 @@
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
+#ifndef _SSP_SENSORS_H_
+#define _SSP_SENSORS_H_
+
+#include <linux/iio/iio.h>
+
+#define SSP_TIME_SIZE	4
+
+#define SSP_ACCELEROMETER_SIZE			6
+#define SSP_GYROSCOPE_SIZE			6
+#define	SSP_BIO_HRM_RAW_SIZE			8
+#define	SSP_BIO_HRM_RAW_FAC_SIZE		36
+#define	SSP_BIO_HRM_LIB_SIZE			8
+
+/**
+ * enum ssp_sensor_tyoe - SSP sensor type
+ */
+enum ssp_sensor_type {
+	SSP_ACCELEROMETER_SENSOR = 0,
+	SSP_GYROSCOPE_SENSOR,
+	SSP_GEOMAGNETIC_UNCALIB_SENSOR,
+	SSP_GEOMAGNETIC_RAW,
+	SSP_GEOMAGNETIC_SENSOR,
+	SSP_PRESSURE_SENSOR,
+	SSP_GESTURE_SENSOR,
+	SSP_PROXIMITY_SENSOR,
+	SSP_TEMPERATURE_HUMIDITY_SENSOR,
+	SSP_LIGHT_SENSOR,
+	SSP_PROXIMITY_RAW,
+	SSP_ORIENTATION_SENSOR,
+	SSP_STEP_DETECTOR,
+	SSP_SIG_MOTION_SENSOR,
+	SSP_GYRO_UNCALIB_SENSOR,
+	SSP_GAME_ROTATION_VECTOR,
+	SSP_ROTATION_VECTOR,
+	SSP_STEP_COUNTER,
+	SSP_BIO_HRM_RAW,
+	SSP_BIO_HRM_RAW_FAC,
+	SSP_BIO_HRM_LIB,
+	SSP_SENSOR_MAX,
+};
+
+struct ssp_data;
+
+/**
+ * struct ssp_sensor_data - Sensor object
+ * @process_data:	Callback to feed sensor data.
+ * @type:		Used sensor type.
+ */
+struct ssp_sensor_data {
+	int (*process_data)(struct iio_dev *indio_dev, void *buf,
+			    int64_t timestamp);
+	enum ssp_sensor_type type;
+};
+
+void ssp_register_consumer(struct iio_dev *indio_dev, enum ssp_sensor_type);
+
+int ssp_enable_sensor(struct ssp_data *data, enum ssp_sensor_type type,
+		       u32 delay);
+
+int ssp_disable_sensor(struct ssp_data *data, enum ssp_sensor_type type);
+
+u32 ssp_get_sensor_delay(struct ssp_data *data, enum ssp_sensor_type);
+
+int ssp_change_delay(struct ssp_data *data, enum ssp_sensor_type type,
+		     u32 delay);
+#endif /* _SSP_SENSORS_H_ */
-- 
1.7.9.5

