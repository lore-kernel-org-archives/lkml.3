Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaJOOsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:48:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:46210 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaJOOsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:48:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="400686666"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v8 0/4] mfd: add support for Diolan DLN-2
Date: Wed, 15 Oct 2014 17:48:07 +0300
Message-Id: <1413384491-23703-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Diolan USB-I2C/GPIO Master Adapter
DLN-2. Details about device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

Changes since v7:

 * MFD: add results parameter to dln2_transfer to allow receiving the
   hardware result code; also fix dln2_transfer to return error only
   if the result code is > 0x80;

 * GPIO: update to the new dln2_transfer API

 * I2C: update to the new dln2_transfer API, use DECLARE_BITMAP, use
   new_cb as a variable name instead of new, update the Kconfig help
   to mentioned DLN2_I2C and DLN2_GPIO, remove i2c_setup as it is not
   useful anymore after removing the frequency code

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
 drivers/gpio/gpio-dln2.c      | 557 +++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        |   2 +-
 drivers/i2c/busses/Kconfig    |  10 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 270 +++++++++++++++
 drivers/mfd/Kconfig           |  11 +
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/dln2.c            | 756 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/driver.h   |   3 +
 include/linux/mfd/dln2.h      |  69 ++++
 12 files changed, 1692 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
1.9.1

