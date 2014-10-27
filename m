Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaJ0Qb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:31:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:25733 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaJ0QbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:31:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,796,1406617200"; 
   d="scan'208";a="597013928"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v9 0/4] mfd: add support for Diolan DLN-2
Date: Mon, 27 Oct 2014 18:31:08 +0200
Message-Id: <1414427472-4100-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Diolan USB-I2C/GPIO Master Adapter
DLN-2. Details about device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

This patch series is against the MFD tree branch
for-mfd-next-v3.19. It does include a gpiolib patch that was merged by
Linus W but it was not yet pulled into Lee's tree.

Changes since v8:

 * common: remove result parameter from dln2_transfer as it is not yet
   used in this patch set (we will add it later with the i2c change
   freq patches); fix comments to wrap to 80 columns instead of 70

 * MFD: add two variants for dln2_transfer: dln2_trasfer_rx and
   dln2_transfer_tx; use entry instead of new_cb in
   dln2_register_event_cb; rename dln2_rx_transfer to
   dln2_transfer_complete and add comment about the URB completion,
   also move the warning about late/missing responses here;

 * GPIO: use dln2_transfer_rx and dln2_transfer_tx where possible

 * I2C: use dln2_transfer_rx and dln2_transfer_tx where possible; use
   adapter's device instead of platform's device for
   dev_err/dev_info/etc prints


Daniel Baluta (1):
  gpio: add support for the Diolan DLN-2 USB GPIO driver

Laurentiu Palcu (1):
  i2c: add support for Diolan DLN-2 USB-I2C adapter

Octavian Purdila (2):
  mfd: add support for Diolan DLN-2 devices
  gpiolib: add irq_not_threaded flag to gpio_chip

 drivers/gpio/Kconfig          |  12 +
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-dln2.c      | 553 ++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        |   2 +-
 drivers/i2c/busses/Kconfig    |  10 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 267 +++++++++++++++
 drivers/mfd/Kconfig           |  11 +
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/dln2.c            | 761 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/driver.h   |   3 +
 include/linux/mfd/dln2.h      | 103 ++++++
 12 files changed, 1724 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
1.9.1

