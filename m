Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaJGVes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:34:48 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:60119 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbaJGVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:34:46 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 0/3] Pinctrl driver for Amlogic Meson SoCs
Date: Tue,  7 Oct 2014 23:32:53 +0200
Message-Id: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series introduces a driver for Amlogic Meson pinctrl and GPIOs,
adding the basic infrastructure for all the SoCs of the Meson family
and configuration data specific for the Meson8.

The last patch depends on a previous series that adds meson8 device
tree files and can be found here:

http://lwn.net/Articles/615033/

I tested the pinmux and GPIO functionalities on a Tronsmart Vega S89e
TV box and everything seems to work, however I'm not so familiar with
the pinctrl subsystem and thus any feedback is very welcome.

Beniamino Galvani (3):
  pinctrl: add driver for Amlogic Meson SoCs
  pinctrl: meson: add device tree bindings documentation
  ARM: dts: meson8: add pinctrl and gpio nodes

 .../devicetree/bindings/pinctrl/meson,pinctrl.txt  |  80 ++
 arch/arm/boot/dts/meson8-vega-s89e.dts             |  16 +-
 arch/arm/boot/dts/meson8.dtsi                      |  35 +
 arch/arm/mach-meson/Kconfig                        |   3 +
 drivers/pinctrl/Kconfig                            |   8 +
 drivers/pinctrl/Makefile                           |   1 +
 drivers/pinctrl/meson/Makefile                     |   2 +
 drivers/pinctrl/meson/pinctrl-meson.c              | 823 +++++++++++++++++++++
 drivers/pinctrl/meson/pinctrl-meson.h              | 217 ++++++
 drivers/pinctrl/meson/pinctrl-meson8.c             | 374 ++++++++++
 include/dt-bindings/gpio/meson8-gpio.h             | 155 ++++
 11 files changed, 1713 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt
 create mode 100644 drivers/pinctrl/meson/Makefile
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson.c
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson.h
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson8.c
 create mode 100644 include/dt-bindings/gpio/meson8-gpio.h

-- 
1.9.1

