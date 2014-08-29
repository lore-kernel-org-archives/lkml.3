Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaH2WF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:05:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:5490 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaH2WFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:05:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378882430"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v2 0/3] mfd: add support for Diolan DLN-2
Date: Sat, 30 Aug 2014 01:00:51 +0300
Message-Id: <1409349654-24841-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Diolan USB-I2C/GPIO Master Adapter DLN-2.
Details about device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

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
 drivers/gpio/gpio-dln2.c      | 506 ++++++++++++++++++++++++++++++++
 drivers/i2c/busses/Kconfig    |  10 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 300 +++++++++++++++++++
 drivers/mfd/Kconfig           |   9 +
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/dln2.c            | 652 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/dln2.h      |  64 +++++
 10 files changed, 1556 insertions(+)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
1.9.1

