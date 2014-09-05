Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbaIEPTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:19:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:17848 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211AbaIEPTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:19:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,473,1406617200"; 
   d="scan'208";a="595153074"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v3 0/3] mfd: add support for Diolan DLN-2
Date: Fri,  5 Sep 2014 18:17:56 +0300
Message-Id: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Diolan USB-I2C/GPIO Master Adapter DLN-2.
Details about device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

Changes since v2:

 * MFD driver: fix a few obsolete comments for the DLN2 I/O API

 * GPIO driver: retry the chip remove call if -EBUSY is returned, see
   the comments in dln2_do_remove for more details; also removed a
   redundant !dln2->pdev check from dln2_irq_event - we do it in
   dln2_transfer already

 * I2C driver: add I2C_FUNC_SMBUS_I2C_BLOCK support

Changes since v1:

 * rewrite the drivers as an MFD

 * rewrite the irq part of the gpio driver to use GPIOLIB_IRQCHIP

 * cleanup the I/O interface

 * various fixes and cleanps: check received message sizes before
   parsing, error handling for usb_submit_urb, check URB status, use
   single bit manipulation functions instead of bitmap_*, move
   GFP_KERNEL URB submit away from under lock

Daniel Baluta (1):
  gpio: add support for the Diolan DLN-2 USB GPIO driver

Laurentiu Palcu (1):
  i2c: add support for Diolan DLN-2 USB-I2C adapter

Octavian Purdila (1):
  mfd: add support for Diolan DLN-2 devices

 drivers/gpio/Kconfig          |  12 +
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-dln2.c      | 537 ++++++++++++++++++++++++++++++++++
 drivers/i2c/busses/Kconfig    |  10 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 301 +++++++++++++++++++
 drivers/mfd/Kconfig           |   9 +
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/dln2.c            | 653 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/dln2.h      |  61 ++++
 10 files changed, 1586 insertions(+)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
1.9.1

