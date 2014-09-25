Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaIYQKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:10:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:36518 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbaIYQKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,598,1406617200"; 
   d="scan'208";a="596818033"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v6 0/4] mfd: add support for Diolan DLN-2
Date: Thu, 25 Sep 2014 19:07:30 +0300
Message-Id: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Diolan USB-I2C/GPIO Master Adapter
DLN-2. Details about device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

Changes since v5:

* MFD: use enum for handles, fix a couple of miss spells, rename a few
  fields for clarity, rework the disconnect mechanism, fix a couple of
  missing newlines in printks, use straight list_for_each instead of
  RCU versions in the update sides, used busnum << 8 | devnum as id in
  mfd_add_devices()

* GPIO: renamed pin_dir to output_enabled, disable GPIO if we failed
  getting the direction, don't set platform's driver owner field

* I2C: update Documentation/ABI for the added sysfs attributed, stored
  the port number in the dln2_i2c structure, used a temporary pointer
  to the tx/rx struct for readability, don't set platform's driver
  owner field

Daniel Baluta (1):
  gpio: add support for the Diolan DLN-2 USB GPIO driver

Laurentiu Palcu (1):
  i2c: add support for Diolan DLN-2 USB-I2C adapter

Octavian Purdila (2):
  mfd: add support for Diolan DLN-2 devices
  gpiolib: add irq_not_threaded flag to gpio_chip

 .../ABI/testing/sysfs-bus-i2c-busses-dln2          |   5 +
 drivers/gpio/Kconfig                               |  12 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-dln2.c                           | 556 +++++++++++++++
 drivers/gpio/gpiolib.c                             |   2 +-
 drivers/i2c/busses/Kconfig                         |  10 +
 drivers/i2c/busses/Makefile                        |   1 +
 drivers/i2c/busses/i2c-dln2.c                      | 378 +++++++++++
 drivers/mfd/Kconfig                                |   9 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/dln2.c                                 | 752 +++++++++++++++++++++
 include/linux/gpio/driver.h                        |   3 +
 include/linux/mfd/dln2.h                           |  67 ++
 13 files changed, 1796 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-busses-dln2
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
1.9.1

