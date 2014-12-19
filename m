Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaLSW3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:29:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:23058 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaLSW3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:29:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,609,1413270000"; 
   d="scan'208";a="650701661"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 0/8] Add MMA9553 driver & PM support for MMA9551
Date: Sat, 20 Dec 2014 00:57:51 +0200
Message-Id: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches includes changes for the MMA9551 and MMA9553 drivers:
- add support for Freescale MMA9553L Intelligent Pedometer Platform
(http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
- add new iio channels for CALORIES, DISTANCE and SPEED needed by the pedometer
- add IIO_CHAN_INFO_CALIBGENDER and IO_CHAN_INFO_CALIBWEIGHT needed to
configure the pedometer
- add runtime PM support for MMA9551

Irina Tirdea (8):
  iio: core: Introduce CALORIES channel type
  iio: core: Introduce DISTANCE channel type
  iio: core: Introduce SPEED channel type
  iio: core: Introduce IO_CHAN_INFO_CALIBWEIGHT
  iio: core: Introduce IIO_CHAN_INFO_CALIBGENDER
  iio: accel: mma9551: Add runtime pm support
  iio: accel: mma9551: split driver to expose mma955x api
  iio: add driver for Freescale MMA9553

 Documentation/ABI/testing/sysfs-bus-iio |   42 ++
 drivers/iio/accel/Kconfig               |   16 +
 drivers/iio/accel/Makefile              |    5 +-
 drivers/iio/accel/mma9551.c             |  488 +++---------
 drivers/iio/accel/mma9551_core.c        |  531 +++++++++++++
 drivers/iio/accel/mma9551_core.h        |   89 +++
 drivers/iio/accel/mma9553.c             | 1239 +++++++++++++++++++++++++++++++
 drivers/iio/industrialio-core.c         |    5 +
 include/linux/iio/iio.h                 |    2 +
 include/linux/iio/types.h               |    3 +
 10 files changed, 2015 insertions(+), 405 deletions(-)
 create mode 100644 drivers/iio/accel/mma9551_core.c
 create mode 100644 drivers/iio/accel/mma9551_core.h
 create mode 100644 drivers/iio/accel/mma9553.c

-- 
1.7.9.5

