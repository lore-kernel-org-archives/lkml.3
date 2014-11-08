Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaKHON5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 09:13:57 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40131 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaKHONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 09:13:54 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-cc-545e251fff58
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH 0/5] iio: Add sensorhub driver
Date: Sat, 08 Nov 2014 15:13:11 +0100
Message-id: <1415455996-20871-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJMWRmVeSWpSXmKPExsVy+t/xK7ryqnEhBi0fhSz+TjrGbrFxxnpW
	iwdNq5gsTi3bz2RxtukNu8W8I+9YLC7vmsPmwO7x+9ckRo9NqzrZPPq2rGL0+LxJLoAlissm
	JTUnsyy1SN8ugStjwew+5oLXYhVTLh5lbWD8INDFyMkhIWAiMbdvMiOELSZx4d56ti5GLg4h
	gaWMEofutEI5fUwSm2ZMZwWpYhNQl2jesZgZJCEi0MgocXNxPxtIglmgg1FiUTtXFyMHh7CA
	nsTzRimQMIuAqsTJhdvZQMK8As4SU/+VgpgSAgoScybZTGDkXsDIsIpRNLU0uaA4KT3XSK84
	Mbe4NC9dLzk/dxMjJDC+7mBceszqEKMAB6MSD++LSbEhQqyJZcWVuYcYJTiYlUR4e88DhXhT
	EiurUovy44tKc1KLDzEycXBKNTCeibpR4GC8g+fCiZWvFtewBG5wvDR/XzWzZEpG0oHQyGkn
	FvsGd846uOdRUaTbaoXtSk2xYrN9ddTs92+9/OvXnZlBoWm8TA/iu2IDrB+XfjM69Xvu9byW
	foVJDSseFoU3uh9edDg0x9q/NNR381fdl0fedSevjtiwJPJrzT/PFR+3bZv1n+eVEktxRqKh
	FnNRcSIAszTCl+oBAAA=
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

>From RFC:
  Fixes after Jonathan rewiev

Karol Wrona (5):
  misc: sensorhub: Add sensorhub driver
  sensorhub: Add sensorhub bindings
  iio: sensorhub: Add sensorhub iio commons
  iio: sensorhub: Add sensorhub accelerometer sensor
  iio: sensorhub: Add sensorhub gyroscope sensor

 .../devicetree/bindings/misc/sensorhub.txt         |   46 ++
 drivers/iio/accel/Makefile                         |    2 +
 drivers/iio/accel/ssp_accel_sensor.c               |  211 +++++
 drivers/iio/common/Kconfig                         |    1 +
 drivers/iio/common/Makefile                        |    1 +
 drivers/iio/common/ssp_sensors/Kconfig             |   13 +
 drivers/iio/common/ssp_sensors/Makefile            |    5 +
 drivers/iio/common/ssp_sensors/ssp_iio.c           |   81 ++
 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h    |   59 ++
 drivers/iio/gyro/Makefile                          |    2 +
 drivers/iio/gyro/ssp_gyro_sensor.c                 |  209 +++++
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/sensorhub/Kconfig                     |   13 +
 drivers/misc/sensorhub/Makefile                    |    6 +
 drivers/misc/sensorhub/ssp.h                       |  279 +++++++
 drivers/misc/sensorhub/ssp_dev.c                   |  825 ++++++++++++++++++++
 drivers/misc/sensorhub/ssp_spi.c                   |  639 +++++++++++++++
 include/linux/iio/common/ssp_sensors.h             |   80 ++
 19 files changed, 2474 insertions(+)
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

