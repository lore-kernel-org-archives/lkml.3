Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbbAQSQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 13:16:30 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:53537 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbAQSQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 13:16:27 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, Carlo Caione <carlo@caione.org>
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v4 0/3] Amlogic Meson pinctrl driver
Date: Sat, 17 Jan 2015 19:15:13 +0100
Message-Id: <1421518516-26976-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series adds a pinctrl driver for Amlogic Meson, providing common
code for all the SoCs of the family and configuration data specific
for Meson8.

DT binding documentation for the driver has already been merged and is
not included in the series. The first patch is for the pinctrl/devel
tree, the others for Carlo's meson tree.

Thanks,
Beniamino

Changes since v3 [ https://lkml.org/lkml/2014/11/16/171 ]
 - add 'static' to meson8 structs and arrays
 - use ERR_CAST() to avoid sparse warning in meson_map_resource()
 - declare group list as 'const char * const *'

Changes since v2 [ https://lkml.org/lkml/2014/10/14/423 ]
 - move modifications to mach-meson Kconfig to a separate patch
 - use regmap_mmio
 - use generic gpio xlate function
 - don't hardcode gpio base number
 - use gpiochip_add_pin_range()
 - add kerneldoc documentation
 - use plain module_platform_driver() instead of postcore_initcall
 - avoid unneeded copies of platform data

Changes since v1 [ https://lkml.org/lkml/2014/10/7/712 ]
 - added missing checks of return values
 - indentation fixes
 - added missing definitions of groups and functions for Meson8

Beniamino Galvani (3):
  pinctrl: add driver for Amlogic Meson SoCs
  ARM: meson: select PINCTRL_MESON and ARCH_REQUIRE_GPIOLIB
  ARM: dts: meson8: add pinctrl node

 arch/arm/boot/dts/meson8.dtsi          |   68 ++
 arch/arm/mach-meson/Kconfig            |    3 +
 drivers/pinctrl/Kconfig                |    8 +
 drivers/pinctrl/Makefile               |    1 +
 drivers/pinctrl/meson/Makefile         |    2 +
 drivers/pinctrl/meson/pinctrl-meson.c  |  761 ++++++++++++++++++++++
 drivers/pinctrl/meson/pinctrl-meson.h  |  209 ++++++
 drivers/pinctrl/meson/pinctrl-meson8.c | 1089 ++++++++++++++++++++++++++++++++
 include/dt-bindings/gpio/meson8-gpio.h |  157 +++++
 9 files changed, 2298 insertions(+)
 create mode 100644 drivers/pinctrl/meson/Makefile
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson.c
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson.h
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson8.c
 create mode 100644 include/dt-bindings/gpio/meson8-gpio.h

-- 
2.1.4

