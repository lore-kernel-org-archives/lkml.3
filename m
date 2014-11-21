Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaKUSTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:19:42 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25284 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaKUSTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:19:40 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-24-546f823a49e2
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v2 0/5] misc: sensorhub: Add sensorhub driver
Date: Fri, 21 Nov 2014 19:19:12 +0100
Message-id: <1416593957-19788-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJMWRmVeSWpSXmKPExsVy+t/xa7pWTfkhBnc6mS3+TjrGbrFxxnpW
	iwdNq5gsTi3bz2RxtukNu8W8I+9YLC7vmsPmwO7x+9ckRo9NqzrZPPq2rGL0+LxJLoAlissm
	JTUnsyy1SN8ugStjyfpdLAWbxCvWPp7E3MC4VLCLkZNDQsBEYsLTQ6wQtpjEhXvr2boYuTiE
	BJYySjxd/YoRwuljklh1fRobSBWbgLpE847FzCAJEYFGRombi/vBEswCHYwSi9q5QGxhAVuJ
	k7v/gcVZBFQlds78zAxi8wo4S2zYvJS9i5EDaJ2CxJxJNhMYuRcwMqxiFE0tTS4oTkrPNdIr
	TswtLs1L10vOz93ECAmOrzsYlx6zOsQowMGoxMN7YVZuiBBrYllxZe4hRgkOZiUR3nLh/BAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjEwvF4vGxRyZZPWkZsmpq3OWsGn6XV4dncBuXXnBcMKf
	RuWC3awJu16zH+1+/IBvXVuva9ljq48CW825rls1nJ/Yeu3Kad/KSqaFj97djkicXfrI+2DE
	VIkYWZPcQN1LkYqrFzj08i2sWOcqdPYzn/r5u5eEXdU2xsYGXtDp3nBC6q8Sq+TuI0osxRmJ
	hlrMRcWJAEcay1bsAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for sensorhub. It is an external mcu which
manages and collects data from several sensors i.e. on Galaxy Gear 2 watch.

It contains:
- spi driver for sensorhub device
- DT binding for the device
- IIO common utils for ssp sensors (iio kfifo setup helpers, pre/post callbacks)
- IIO accelerometer driver
- IIO gyroscope driver

For now the driver supports "traditional" sensors but new ones types are
intended to be used.

It depends on:
[PATCH v4 1/1] misc: st32fwu: Add stm32 upgrade protocol handling
which is used to firmware upgrade.

>From v1:
  - Adopted to new stm32fwu v5
  - Fixed sensors' data process callbacks
  - Fixed comments style

Karol Wrona (5):
  misc: sensorhub: Add sensorhub driver
  sensorhub: Add sensorhub bindings
  iio: sensorhub: Add sensorhub iio commons
  iio: sensorhub: Add sensorhub accelerometer sensor
  iio: sensorhub: Add sensorhub gyroscope sensor

 .../devicetree/bindings/misc/sensorhub.txt         |   46 ++
 drivers/iio/accel/Makefile                         |    2 +
 drivers/iio/accel/ssp_accel_sensor.c               |  223 ++++++
 drivers/iio/common/Kconfig                         |    1 +
 drivers/iio/common/Makefile                        |    1 +
 drivers/iio/common/ssp_sensors/Kconfig             |   13 +
 drivers/iio/common/ssp_sensors/Makefile            |    5 +
 drivers/iio/common/ssp_sensors/ssp_iio.c           |   81 ++
 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h    |   59 ++
 drivers/iio/gyro/Makefile                          |    2 +
 drivers/iio/gyro/ssp_gyro_sensor.c                 |  222 ++++++
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/sensorhub/Kconfig                     |   13 +
 drivers/misc/sensorhub/Makefile                    |    6 +
 drivers/misc/sensorhub/ssp.h                       |  279 +++++++
 drivers/misc/sensorhub/ssp_dev.c                   |  828 ++++++++++++++++++++
 drivers/misc/sensorhub/ssp_spi.c                   |  653 +++++++++++++++
 include/linux/iio/common/ssp_sensors.h             |   79 ++
 19 files changed, 2515 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/sensorhub.txt
 create mode 100644 drivers/iio/accel/ssp_accel_sensor.c
 create mode 100644 drivers/iio/common/ssp_sensors/Kconfig
 create mode 100644 drivers/iio/common/ssp_sensors/Makefile
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio.c
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
 create mode 100644 drivers/iio/gyro/ssp_gyro_sensor.c
 create mode 100644 drivers/misc/sensorhub/Kconfig
 create mode 100644 drivers/misc/sensorhub/Makefile
 create mode 100644 drivers/misc/sensorhub/ssp.h
 create mode 100644 drivers/misc/sensorhub/ssp_dev.c
 create mode 100644 drivers/misc/sensorhub/ssp_spi.c
 create mode 100644 include/linux/iio/common/ssp_sensors.h

-- 
1.7.9.5

