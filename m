Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3FDJje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:39:34 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49545 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3FDJfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:35:22 -0400
From: Ferruh Yigit <fery@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: ttdrivers@cypress.com, Javier Martinez Canillas <javier@dowhile0.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Simon Budig <simon.budig@kernelconcepts.de>,
        Alexander Shiyan <shc_work@mail.ru>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Ferruh Yigit <fery@cypress.com>
Subject: [PATCH v3 0/4] Input: cyttsp4 - driver for Cypress TMA4XX touchscreen devices
Date: Tue,  4 Jun 2013 12:34:40 +0300
Message-Id: <1370338484-26573-1-git-send-email-fery@cypress.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is for Cypress TrueTouch(tm) Standard Product controllers,
Generation4 devices.

This is third version of submission code, modifications:
- code re-structured to match with existing Generation3 driver code.
- common I2C code for Gen3 and Gen4 devices split and shared.

Driver consist of three modules:
- Core module: Main module, gets data from TTSP controller,
  sent MT events to Linux
- I2C module: Underlying communication with I2C bus
- SPI module: Underlying communication with SPI bus

Ferruh Yigit (4):
  Input: cyttsp - I2C driver split into two modules
  Input: cyttsp4 - Core driver for Cypress TMA4XX touchscreen devices
  Input: cyttsp4 - I2C driver for Cypress TMA4XX touchscreen devices
  Input: cyttsp4 - SPI driver for Cypress TMA4XX touchscreen devices

 drivers/input/touchscreen/Kconfig             |   30 +
 drivers/input/touchscreen/Makefile            |    5 +-
 drivers/input/touchscreen/cyttsp4_core.c      | 2173 +++++++++++++++++++++++++
 drivers/input/touchscreen/cyttsp4_core.h      |  472 ++++++
 drivers/input/touchscreen/cyttsp4_i2c.c       |   90 +
 drivers/input/touchscreen/cyttsp4_spi.c       |  205 +++
 drivers/input/touchscreen/cyttsp_core.c       |    6 +-
 drivers/input/touchscreen/cyttsp_core.h       |   11 +-
 drivers/input/touchscreen/cyttsp_i2c.c        |   50 +-
 drivers/input/touchscreen/cyttsp_i2c_common.c |   79 +
 drivers/input/touchscreen/cyttsp_spi.c        |   38 +-
 include/linux/platform_data/cyttsp4.h         |   76 +
 12 files changed, 3161 insertions(+), 74 deletions(-)
 create mode 100644 drivers/input/touchscreen/cyttsp4_core.c
 create mode 100644 drivers/input/touchscreen/cyttsp4_core.h
 create mode 100644 drivers/input/touchscreen/cyttsp4_i2c.c
 create mode 100644 drivers/input/touchscreen/cyttsp4_spi.c
 create mode 100644 drivers/input/touchscreen/cyttsp_i2c_common.c
 create mode 100644 include/linux/platform_data/cyttsp4.h

-- 
1.7.9.5

