Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaLET4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:56:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33516 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaLET4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:56:08 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-4f-54820dd586c5
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v3 0/5] iio: common: ssp_sensors: Add sensorhub driver
Date: Fri, 05 Dec 2014 20:54:45 +0100
Message-id: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t/xK7pXeZtCDP7skbXYOGM9q8WDplVM
	FqeW7Wey2PX/DbPF2aY37Bbzjrxjsbi8aw6bxZ51W5gcODx2zrrL7vHhY5zHplWdbB59W1Yx
	enzeJBfAGsVlk5Kak1mWWqRvl8CVcXTKBaaCfWIV6/oWMjUwLhTsYuTkkBAwkThxbQkLhC0m
	ceHeerYuRi4OIYGljBIN13+xgSSEBPqYJL5d9gOx2QTUJZp3LGYGKRIRaGGUePFzFyuIwyyw
	hlHizNkJ7CBVwgJuEmvaTzGC2CwCqhK7Vi5kArF5BZwktk7/D7SOA2idgsScSTYTGLkXMDKs
	YhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJly87GBcfszrEKMDBqMTDe8G6MUSINbGsuDL3
	EKMEB7OSCG/ybKAQb0piZVVqUX58UWlOavEhRiYOTqkGxtUvX8retVbeWpJ58cWi6Y6O78qk
	l2m86BeLmLGbr+F1gyCzzuJVT0pnL49ynJJnvsLI33nKhInVnMkxix+e5OovvZjoHBawOpU5
	zHb9PqbU6f/bTAwndeQHTF962NDm8DJ3cx89NR3Vt+VdT6MjSuckCnsa3zx74acY/x/O0KxF
	KZsFmp2KlViKMxINtZiLihMBydZtFPUBAAA=
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

>From v1:
  - Adopted to new stm32fwu v5
  - Fixed sensors' data process callbacks
  - Fixed comments style

>From v2:
  - Fixes after Hartmut Knaack review
  - Sensorhub driver was moved from misc to iio after the discussion with Arnd
    and Jonathan
  - Firmware upgrade is not supported in this patchset. I hope it will be
    applied when it will find its own place in the tree.



Karol Wrona (5):
  iio: common: ssp_sensors: Add sensorhub driver
  iio: sensorhub: Add sensorhub bindings
  iio: common: ssp_sensors: Add sensorhub iio commons
  iio: common: ssp_sensors: Add sensorhub accelerometer sensor
  iio: common: ssp_sensors: Add sensorhub gyroscope sensor

 .../devicetree/bindings/iio/sensorhub.txt          |   46 ++
 drivers/iio/accel/Makefile                         |    1 +
 drivers/iio/accel/ssp_accel_sensor.c               |  203 ++++++
 drivers/iio/common/Kconfig                         |    1 +
 drivers/iio/common/Makefile                        |    1 +
 drivers/iio/common/ssp_sensors/Kconfig             |   24 +
 drivers/iio/common/ssp_sensors/Makefile            |    6 +
 drivers/iio/common/ssp_sensors/ssp.h               |  254 +++++++
 drivers/iio/common/ssp_sensors/ssp_dev.c           |  693 ++++++++++++++++++++
 drivers/iio/common/ssp_sensors/ssp_iio.c           |   82 +++
 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h    |   56 ++
 drivers/iio/common/ssp_sensors/ssp_spi.c           |  644 ++++++++++++++++++
 drivers/iio/gyro/Makefile                          |    2 +
 drivers/iio/gyro/ssp_gyro_sensor.c                 |  202 ++++++
 include/linux/iio/common/ssp_sensors.h             |   80 +++
 15 files changed, 2295 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/sensorhub.txt
 create mode 100644 drivers/iio/accel/ssp_accel_sensor.c
 create mode 100644 drivers/iio/common/ssp_sensors/Kconfig
 create mode 100644 drivers/iio/common/ssp_sensors/Makefile
 create mode 100644 drivers/iio/common/ssp_sensors/ssp.h
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_dev.c
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio.c
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_spi.c
 create mode 100644 drivers/iio/gyro/ssp_gyro_sensor.c
 create mode 100644 include/linux/iio/common/ssp_sensors.h

-- 
1.7.9.5

