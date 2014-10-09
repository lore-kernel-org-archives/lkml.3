Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaJITWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:22:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:3707 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaJITWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,686,1406617200"; 
   d="scan'208";a="483146899"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v7 0/4]  mfd: add support for Diolan DLN-2
Date: Thu,  9 Oct 2014 22:22:17 +0300
Message-Id: <1412882541-10934-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v6:

* MFD: make sure DLN2_HANDLE_EVENT stays 0, move a few operations out
  of the lock block, renamed one missed _rx_callback function to
  _event_callback, speed-up disconnect by checking for it in
  find_free_slot, remove the URB submit helper and simplify URB
  resubmit code, use mfd_add_hotplug_devices, change the driver name
  to dln2 (from usb-dln2), initialize disconnect_lock

* GPIO: no changes

* I2C: keep sorting in Kconfig and Makefile, add warning for transfers
  bigger then DLN2_I2C_MAX_XFER_SIZE, remove frequency code - I will
  send a separate patch that moves this to i2c core, revert to using
  tx structures for dln2_i2c_enable



Daniel Baluta (1):
  gpio: add support for the Diolan DLN-2 USB GPIO driver

Laurentiu Palcu (1):
  i2c: add support for Diolan DLN-2 USB-I2C adapter

Octavian Purdila (2):
  mfd: add support for Diolan DLN-2 devices
  gpiolib: add irq_not_threaded flag to gpio_chip

 drivers/gpio/Kconfig          |  12 +
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-dln2.c      | 555 +++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        |   2 +-
 drivers/i2c/busses/Kconfig    |  10 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 275 +++++++++++++++
 drivers/mfd/Kconfig           |   9 +
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/dln2.c            | 755 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/driver.h   |   3 +
 include/linux/mfd/dln2.h      |  67 ++++
 12 files changed, 1690 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
1.9.1

