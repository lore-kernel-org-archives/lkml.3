Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaBLKKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:10:04 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:58086 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBLKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:09:59 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, b.brezillon@overkiz.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v4 0/8] Device Tree support for the at91sam9261ek
Date: Wed, 12 Feb 2014 11:06:39 +0100
Message-Id: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set aims at bringing a device tree support for the sam9261.
It's mostly based on the sam9263 and sam9x5 stuff.

Changes since V3:
* Added support for the touchscreen
* Added support for the spi dataflash
* Activated the TCB by default
* Reworked the patch organization to reduce the number of patchs
* changed the default bootargs (no mem description, UBI on mtdpart 5)
* Changed the xlate implementation of the at91 pinctrl driver to lock the GPIOs
  for IRQs instead of requesting them (needed for the touchscreen driver)
* some stylistic changes

Changes since V2:
* removed the smc driver from the serie. It'll be posted in an independent
  serie later.
* removed the DM9000 support (it'll come with the smc driver)
* the sam9261 now supports the Common Clock Framework (CCF). Note: to enable
  the CCF you must remove from the kernel config the platforms that don't
  support it.
* Added basic DT binding for the bus matrix
* Added support for USB host
* Added support for USB gadget
* in dts(i), replaced interrupt-parent with interrupts-extended
* changed the nand partition plan (same as for the sama5d3)
* removed 'mem' parameter in command line
* re-ordered dt-nodes in ascending address order.
* split the lcd support patch in 2 parts (SOC and board)


Change since V1:
* changed the DT representation to use address translation and separate the
  timings' configuration from the device properties by adding a "simple-bus"
  inetrmediate node.
* moved the smc driver from drivers/bus to drivers/memmory
* smc driver now accepts timings in nanoseconds as well as raw register values
* smc driver can clip the timings if they're out of bound and dump them to the
  console
* DM9000 timings are now described in nanosecs (for the virtue of example)

supported features are:
* working with the Common Clock Framework and the old at91 clock implementation
* dbgu
* lcdc
* usb host
* usb gadget,
* spi dataflash
* nand flash
* touchscreen
* leds
* user buttons

In the TODO list:
* dm9000 (ethernet)
* audio
* mmc

This serie relies on the following patchs:
usb: at91-udc: fix irq and iomem resource retrieval
ARM: at91: prepare sam9 dt boards transition to common

Jean-Jacques

Jean-Jacques Hiblot (8):
  at91: dt: Adds support for the bus matrix declaration in the DT
  at91: pinctrl: don't request GPIOs used for interrupts but lock them
    as IRQ
  at91: dt: Add at91sam9261 dt SoC support
  at91: dt: defconfig: Added the sam9261 to the list of DT-enabled SOCs
  at91: dt: sam9261: Device Tree support for the at91sam9261ek
  at91: updated the at91_dt_defconfig with support for the ADS7846
  ARM: at91: prepare common clk transition for sam9261 SoC
  ARM: at91: move sam9261 SoC to common clk

 arch/arm/boot/dts/Makefile          |   2 +
 arch/arm/boot/dts/at91sam9261.dtsi  | 740 ++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9261ek.dts | 204 ++++++++++
 arch/arm/configs/at91_dt_defconfig  |   2 +
 arch/arm/mach-at91/Kconfig          |   1 -
 arch/arm/mach-at91/at91sam9261.c    |  25 +-
 arch/arm/mach-at91/setup.c          |  23 ++
 drivers/pinctrl/pinctrl-at91.c      |   5 +-
 8 files changed, 996 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts

-- 
1.8.5.3

