Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbbAKTKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 14:10:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:17088 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbbAKTKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 14:10:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,739,1413270000"; 
   d="scan'208";a="660161192"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 00/10] Add MMA9553 driver & PM support for MMA9551
Date: Sun, 11 Jan 2015 21:10:06 +0200
Message-Id: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches includes changes for the MMA9551 and MMA9553 drivers:
 - add support for Freescale MMA9553L Intelligent Pedometer Platform
(http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
 - add new iio channels types and modifiers needed by the pedometer
 - add runtime PM support for MMA9551

Changes in v2:
 - removed IIO_CHAN_INFO_CALIBGENDER and used extended attribute
enum interface instead
 - renamed IIO_CALORIES channel to IIO_ENERGY
 - replaced IIO_SPEED with IIO_VELOCITY and IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z
 - introduced IIO_EV_TYPE_CHANGE to use for step detector instead of
IIO_EV_TYPE_INSTANCE
 - introduce IIO_CHAN_INFO_FILTER_OUTLIERS_THRESH and
IIO_CHAN_INFO_FILTER_OUTLIERS_PERIOD
 - add kernel-doc comments to functions exported in mma9551_core.c
 - updated ABI documentation to include all exported attributes in mma9553
 - updated mma9553 driver code according to comments from Jonathan

Irina Tirdea (10):
  iio: core: Introduce ENERGY channel type
  iio: core: Introduce DISTANCE channel type
  iio: core: Introduce IIO_VELOCITY and IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z
  iio: core: Introduce IO_CHAN_INFO_CALIBWEIGHT
  iio: core: Introduce CHANGE event type
  iio: core: Remove IIO_EV_TYPE_INSTANCE
  iio: core: Introduce IIO_CHAN_INFO_FILTER_OUTLIERS_THRESH and _PERIOD
  iio: accel: mma9551: Add runtime pm support
  iio: accel: mma9551: split driver to expose mma955x api
  iio: add driver for Freescale MMA9553

 Documentation/ABI/testing/sysfs-bus-iio            |  127 +-
 drivers/iio/accel/Kconfig                          |   15 +
 drivers/iio/accel/Makefile                         |    5 +-
 drivers/iio/accel/mma9551.c                        |  489 ++------
 drivers/iio/accel/mma9551_core.c                   |  798 ++++++++++++
 drivers/iio/accel/mma9551_core.h                   |   81 ++
 drivers/iio/accel/mma9553.c                        | 1321 ++++++++++++++++++++
 drivers/iio/industrialio-core.c                    |    7 +
 drivers/iio/industrialio-event.c                   |    2 +-
 .../staging/iio/Documentation/iio_event_monitor.c  |    4 +-
 drivers/staging/iio/iio_simple_dummy.c             |    2 +-
 drivers/staging/iio/iio_simple_dummy_events.c      |    4 +-
 include/linux/iio/iio.h                            |   14 +
 include/linux/iio/types.h                          |    6 +-
 14 files changed, 2455 insertions(+), 420 deletions(-)
 create mode 100644 drivers/iio/accel/mma9551_core.c
 create mode 100644 drivers/iio/accel/mma9551_core.h
 create mode 100644 drivers/iio/accel/mma9553.c

-- 
1.9.1

