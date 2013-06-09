Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3FIQgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:36:15 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56922 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3FIQgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:36:14 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/6] Add support for Allwinner A10s SoCs
Date: Sun,  9 Jun 2013 18:36:01 +0200
Message-Id: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patch serie reworks a bit the pinctrl driver and adds the necessary
bits needed to support the Allwinner A10s SoC.

This SoC is a bit in between the A10 and A13. Notable differences with
the A13 is the addition of an HDMI controller and of the EMAC.

For the time being (ie until we find a proper datasheet for this SoCs),
the clock definition is taken from the A10 one.

This patches depends on the "Add external interrupt support for Allwinner SoCs"
patch serie.

Thanks,
Maxime

Maxime Ripard (6):
  ARM: sunxi: Add Allwinner A10s machine compatible
  pinctrl: sunxi: Move the pins definitions to a separate header
  pinctrl: sunxi: Add Allwinner A10s pins
  ARM: sunxi: dt: Add Allwinner A10s DTSI
  ARM: sunxi: Add Olimex A10s-Olinuxino-micro device tree
  ARM: multi_v7: Enable Allwinner EMAC in multi_v7_defconfig

 Documentation/arm/sunxi/README                   |    4 +
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts |   75 +
 arch/arm/boot/dts/sun5i-a10s.dtsi                |  286 +++
 arch/arm/configs/multi_v7_defconfig              |    2 +
 arch/arm/mach-sunxi/sunxi.c                      |    1 +
 drivers/pinctrl/pinctrl-sunxi-pins.h             | 2023 ++++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.c                  | 1362 +--------------
 7 files changed, 2393 insertions(+), 1360 deletions(-)
 create mode 100644 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
 create mode 100644 arch/arm/boot/dts/sun5i-a10s.dtsi
 create mode 100644 drivers/pinctrl/pinctrl-sunxi-pins.h

-- 
1.8.3

