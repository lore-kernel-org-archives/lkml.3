Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaLQQpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:45:43 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:53375 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaLQQpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:45:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        linux@roeck-us.net, arnd@arndb.de
Subject: [PATCH v2 0/8] watchdog: rtc: New driver(s) for ST's LPC IP
Date: Wed, 17 Dec 2014 16:45:19 +0000
Message-Id: <1418834727-1602-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST's Low Power Controller (LPC) controls two devices; watchdog and RTC.
Only one of the devices can be used at any one time, which is enforced
by a Device Tree property.

This driver set provides everything you need to choose one (and only
one) of the LPC devices to run per I/P block, of which there are two
on the enabled STiH407 h/w.

v1 => v2:
  Suggestions fixed up:
    Arnd: No need for a separate MFD driver.  If you return -ENODEV
          really_probe() will continue looking for an suitable alternative.
    
    David: Power Management improvements.

    Guenter: Use Watchdog Framework's maximum timeout checker and only request
             clock rate once during .probe(), as the clock rate will not
             change.

Lee Jones (8):
  mfd: dt-bindings: Provide human readable defines for LPC mode choosing
  ARM: multi_v7_defconfig: Enable support for ST's LPC Watchdog
  ARM: multi_v7_defconfig: Enable support for ST's LPC RTC
  ARM: STi: DT: STiH407: Add Device Tree node for the LPC
  watchdog: bindings: Provide ST bindings for ST's LPC Watchdog device
  watchdog: st_wdt: Add new driver for ST's LPC Watchdog
  rtc: bindings: Provide ST bindings for ST's LPC RTC device
  rtc: st: add new driver for ST's LPC RTC

 .../devicetree/bindings/rtc/rtc-st-lpc.txt         |  25 ++
 .../devicetree/bindings/watchdog/st_lpc_wdt.txt    |  38 +++
 arch/arm/boot/dts/stih407.dtsi                     |  20 ++
 arch/arm/configs/multi_v7_defconfig                |   2 +
 drivers/rtc/Kconfig                                |  13 +
 drivers/rtc/Makefile                               |   1 +
 drivers/rtc/rtc-st-lpc.c                           | 354 +++++++++++++++++++++
 drivers/watchdog/Kconfig                           |  13 +
 drivers/watchdog/Makefile                          |   1 +
 drivers/watchdog/st_wdt.c                          | 329 +++++++++++++++++++
 include/dt-bindings/mfd/st-lpc.h                   |  15 +
 11 files changed, 811 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/rtc-st-lpc.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/st_lpc_wdt.txt
 create mode 100644 drivers/rtc/rtc-st-lpc.c
 create mode 100644 drivers/watchdog/st_wdt.c
 create mode 100644 include/dt-bindings/mfd/st-lpc.h

-- 
1.9.1

