Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaLOLZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:25:49 -0500
Received: from mail-yk0-f174.google.com ([209.85.160.174]:58896 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLOLZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:25:46 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/8] mfd: watchdog: rtc: New driver for ST's LPC IP
Date: Mon, 15 Dec 2014 11:25:30 +0000
Message-Id: <1418642738-17407-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST's Low Power Controller (LPC) controls two devices; watchdog and RTC.
Only one of the devices can be used at any one time, which is enforced
by the correlating MFD driver.

This driver set provides everything you need to choose one (and only
one) of the LPC devices to run per I/P block, of which there are two
on the enabled STiH407 h/w.

Lee Jones (8):
  ARM: multi_v7_defconfig: Enable support for ST's LPC Watchdog
  ARM: multi_v7_defconfig: Enable support for ST's LPC RTC
  mfd: bindings: Provide ST bindings for ST's LPC device
  mfd: dt-bindings: Provide human readable defines for LPC mode choosing
  mfd: Add ST's Low Power Controller driver
  watchdog: st_wdt: Add new driver for ST's LPC Watchdog
  rtc: st: add new driver for ST's LPC RTC
  ARM: STi: DT: STiH407: Add Device Tree node for the LPC

 Documentation/devicetree/bindings/mfd/st-lpc.txt |  36 +++
 arch/arm/boot/dts/stih407.dtsi                   |  20 ++
 arch/arm/configs/multi_v7_defconfig              |   2 +
 drivers/mfd/Kconfig                              |   8 +
 drivers/mfd/Makefile                             |   1 +
 drivers/mfd/st-lpc.c                             |  88 ++++++
 drivers/rtc/Kconfig                              |  13 +
 drivers/rtc/Makefile                             |   1 +
 drivers/rtc/rtc-st-lpc.c                         | 330 +++++++++++++++++++++++
 drivers/watchdog/Kconfig                         |  13 +
 drivers/watchdog/Makefile                        |   1 +
 drivers/watchdog/st_wdt.c                        | 312 +++++++++++++++++++++
 include/dt-bindings/mfd/st-lpc.h                 |  15 ++
 13 files changed, 840 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/st-lpc.txt
 create mode 100644 drivers/mfd/st-lpc.c
 create mode 100644 drivers/rtc/rtc-st-lpc.c
 create mode 100644 drivers/watchdog/st_wdt.c
 create mode 100644 include/dt-bindings/mfd/st-lpc.h

-- 
1.9.1

