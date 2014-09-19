Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbaISUXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:23:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:11041 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbaISUXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:23:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,556,1406617200"; 
   d="scan'208";a="594021709"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v5 0/4] mfd: add support for Diolan DLN-2
Date: Fri, 19 Sep 2014 23:22:41 +0300
Message-Id: <1411158165-25794-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Diolan USB-I2C/GPIO Master Adapter
DLN-2. Details about device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

Changes since v4:

* Add a new gpiolib chip flag to allow blocking chips with non threaded
  IRQ handlers

* MFD: set GPLv2 as license, fix a couple of coding style issues, add
  code to stop I/O after USB disconnect and prevent further I/O,
  simplify the DNL2 platform data

* GPIO: add modalias, set GPLv2 as license, rework pin direction
  caching, use irq_find_mapping in dln2_irq_unmask, allocate irq work
  based on the number of pins read from the device, flush irq work at
  remove time, use RCU to iterate and run the callback list

* I2C: add modalias, set GPLv2 as license, allocate the RX/TX buf
  separately to avoid cache line sharing issue, don't truncate i2c
  reads, use u32 instead of uint32_t, attach the sysfs freq attribute
  to the i2c adapter device instead of the platform device (and also
  use device attribute groups), simplify dln2_i2c_read a bit


Daniel Baluta (1):
  gpio: add support for the Diolan DLN-2 USB GPIO driver

Laurentiu Palcu (1):
  i2c: add support for Diolan DLN-2 USB-I2C adapter

Octavian Purdila (2):
  mfd: add support for Diolan DLN-2 devices
  gpiolib: add irq_not_threaded flag to gpio_chip

 drivers/gpio/Kconfig          |  12 +
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-dln2.c      | 554 ++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        |   2 +-
 drivers/i2c/busses/Kconfig    |  10 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 383 +++++++++++++++++++++
 drivers/mfd/Kconfig           |   9 +
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/dln2.c            | 758 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/driver.h   |   3 +
 include/linux/mfd/dln2.h      |  67 ++++
 12 files changed, 1800 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
1.9.1

