Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaBUTti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:49:38 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39724 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753357AbaBUTth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:49:37 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 0/9] Device tree support for the at91sam9rlek
Date: Fri, 21 Feb 2014 20:48:49 +0100
Message-Id: <1393012138-17255-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds DT support for the at91sam9rl SoC, then the at91sam9rl-ek
evaluation board.

While the at91sam9rl dtsi should be almost complete (still missing LCD and
touchscreen bits). The at91sam9rlek DT now support the following tested
features:
 - MMC
 - dbgu
 - usart1
 - watchdog
 - nand
 - leds
 - buttons
 - common clock framework

Next:
 - spi
 - dataflash
 - i2c
 - lcd
 - touchscreen
 - usb gadget
 - audio

Changes since v2:
 - split the first patch in two, first one for the code, second one for DT
 - DT list entries are bracketed individually
 - stopped using unit-address when there is not reg property

Alexandre Belloni (8):
  ARM: at91: prepare at91sam9rl DT transition
  ARM: at91: Add at91sam9rl DT SoC support
  ARM: at91/defconfig: Add the sam9rl to the list of DT-enabled SOCs
  ARM: at91: dt: sam9rl: Device Tree for the at91sam9rlek
  ARM: at91: prepare common clk transition for sam9rl SoCs
  ARM: at91/dt: define at91sam9rl clocks
  ARM: at91/dt: define main clk frequency of at91sam9rlek
  ARM: at91: switch sam9rl to common clock framework

Boris BREZILLON (1):
  ARM: at91: prepare sam9 dt boards transition to common clk

 arch/arm/boot/dts/Makefile         |   2 +
 arch/arm/boot/dts/at91sam9rl.dtsi  | 849 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9rlek.dts | 157 +++++++
 arch/arm/configs/at91_dt_defconfig |   1 +
 arch/arm/mach-at91/Kconfig         |   1 -
 arch/arm/mach-at91/at91sam9rl.c    |  22 +-
 arch/arm/mach-at91/board-dt-sam9.c |  11 +-
 7 files changed, 1040 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9rl.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9rlek.dts

-- 
1.8.3.2

