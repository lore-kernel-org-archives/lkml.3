Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab3LAG0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 01:26:41 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49315 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3LAG0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 01:26:38 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>
Subject: [PATCH 00/11] ARM: support for ICP DAS LP-8x4x
Date: Sun,  1 Dec 2013 10:26:13 +0400
Message-Id: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ICP DAS calls LP-8x4x 'programmable automation controller'. It is
an industrial computer based on PXA270 SoC. They ship it with a 2.6.19
kernel and proprietary kernel module and userspace library to access its
industrial IO.

This patch series allows to boot the device with a modern kernel. It adds
support for:
* FPGA irq chip
* MMC card interface on PXA270
* USB 1.1 port on PXA270
* 2 NOR flash devices
* VGA interface on PXA270
* 2 onboard ethernet Davicom DM9000 devices
* 3 serial UART ports on PXA270
* DS1302 RTC
* 512kiB SRAM with double battery-backup
* 3 built-in 16550 serial UART ports
* industrial IO parallel bus
* serial interface for digital and analog industrial IO modules on
  parallel bus (any I-870xx series)
* digital and analog industrial IO modules for parallel bus:
  * I-8024 (analog output)
  * I-8041 (digital output)
  * I-8042 (digital input-output)

Sergei Ianovich (11):
  resolve PXA<->8250 serial device address conflict
  arm: pxa27x: support ICP DAS LP-8x4x
  rtc: support DS1302 RTC on ICP DAS LP-8x4x
  mtd: support BB SRAM on ICP DAS LP-8x4x
  serial: support for 16550 serial ports on LP-8x4x
  misc: support for LP-8x4x custom parallel bus
  misc: support for serial slots in LP-8x4x
  misc: support for parallel slots in LP-8x4x
  misc: support for I-8041 in LP-8x4x
  misc: support for I-8042 in LP-8x4x
  misc: support for I-8024 in LP-8x4x

 Documentation/misc-devices/lp8x4x_bus.txt |   74 +
 arch/arm/configs/lp8x4x_defconfig         | 2324 +++++++++++++++++++++++++++++
 arch/arm/mach-pxa/Kconfig                 |    8 +
 arch/arm/mach-pxa/Makefile                |    1 +
 arch/arm/mach-pxa/include/mach/lp8x4x.h   |   95 ++
 arch/arm/mach-pxa/lp8x4x.c                |  557 +++++++
 drivers/misc/Kconfig                      |   12 +
 drivers/misc/Makefile                     |    1 +
 drivers/misc/lp8x4x_bus.c                 |  581 ++++++++
 drivers/mtd/devices/Kconfig               |   13 +
 drivers/mtd/devices/Makefile              |    1 +
 drivers/mtd/devices/lp8x4x_sram.c         |  229 +++
 drivers/rtc/Kconfig                       |    2 +-
 drivers/rtc/rtc-ds1302.c                  |   85 ++
 drivers/tty/serial/8250/8250_lp8x4x.c     |  181 +++
 drivers/tty/serial/8250/Kconfig           |   11 +
 drivers/tty/serial/8250/Makefile          |    1 +
 drivers/tty/serial/Kconfig                |   19 +
 drivers/tty/serial/pxa.c                  |   22 +-
 19 files changed, 4212 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/misc-devices/lp8x4x_bus.txt
 create mode 100644 arch/arm/configs/lp8x4x_defconfig
 create mode 100644 arch/arm/mach-pxa/include/mach/lp8x4x.h
 create mode 100644 arch/arm/mach-pxa/lp8x4x.c
 create mode 100644 drivers/misc/lp8x4x_bus.c
 create mode 100644 drivers/mtd/devices/lp8x4x_sram.c
 create mode 100644 drivers/tty/serial/8250/8250_lp8x4x.c

-- 
1.8.4.2

