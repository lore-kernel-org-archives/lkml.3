Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaKERFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:05:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:3821 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854AbaKERFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:05:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="602871863"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v10 0/3] add support for Diolan DLN-2
Date: Wed,  5 Nov 2014 19:04:58 +0200
Message-Id: <1415207101-16461-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Diolan USB-I2C/GPIO Master Adapter
DLN-2. Details about device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

This patch series has been rebased against the for-mfd-next branch of
the MFD tree.

Changes since v9:

 * MFD: use decimal serial no, break the run callback loop (there can
   be only one entry per id), move up the declaration of a couple of
   variables, remove a couple of redundant __packed attributes, fix a
   typo and cleanup an error message, use unsigned long instead of int
   for timeout

 * I2C: none

 * GPIO: drop a couple of cpu_to_le16() due to receiving data type
   being u8

Daniel Baluta (1):
  gpio: add support for the Diolan DLN-2 USB GPIO driver

Laurentiu Palcu (1):
  i2c: add support for Diolan DLN-2 USB-I2C adapter

Octavian Purdila (1):
  mfd: add support for Diolan DLN-2 devices

 drivers/gpio/Kconfig          |  12 +
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-dln2.c      | 553 ++++++++++++++++++++++++++++++
 drivers/i2c/busses/Kconfig    |  10 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 267 +++++++++++++++
 drivers/mfd/Kconfig           |  11 +
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/dln2.c            | 763 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/dln2.h      | 103 ++++++
 10 files changed, 1722 insertions(+)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
1.9.1

