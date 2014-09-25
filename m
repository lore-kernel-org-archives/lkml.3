Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaIYQhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:37:24 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:60538 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIYQhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:37:23 -0400
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com,
        l.stach@pengutronix.de, stefan@agner.ch
Subject: [PATCH v3 0/5] vf610: Add GPIO support
Date: Thu, 25 Sep 2014 18:37:04 +0200
Message-Id: <cover.1411662961.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 3rd version of the GPIO support for Vybrid now also includes
the wakeup support which was part of the suspend/resume patchset
I sent earlier this week.

Changes in v3:
- Configure the pin completely on imx_pmx_gpio_request_enable
- Drop the GPIO_CONTROL flag in favor of using the existing
  SHARE_MUX_CONF_REG flag
- Extend GPIO driver to also include wakeup support
- Cleanup includes in GPIO driver file
- Add brackets in PORT_PCR define
- Use platform_get_irq in favor of irq_of_parse_and_map
- Use device_initcall instead of subsys_initicall

Changes in v2:
- Use bit operations in GPIO driver
- Use VF610_ prefix for GPIOS_PER_PORT define
- Drop irq in drivers struct
- Use arch/subsys_initicall for GPIO/pinctrl driver
- Fix log message title
- Add documentation for GPIO/PORT module bindings
- Extended GPIO device tree bindings for Colibri VF61

Stefan Agner (5):
  pinctrl: imx: detect uninitialized pins
  pinctrl: imx: add gpio pinmux support for vf610
  gpio: vf610: add gpiolib/IRQ chip driver for Vybrid
  ARM: dts: vf610: use new GPIO support
  Documentation: dts: add bindings for Vybrid GPIO/PORT module

 .../devicetree/bindings/gpio/gpio-vf610.txt        |  56 ++++
 arch/arm/boot/dts/vf610-colibri.dtsi               |   9 +
 arch/arm/boot/dts/vf610-twr.dts                    |   1 +
 arch/arm/boot/dts/vf610.dtsi                       |   1 +
 drivers/gpio/Kconfig                               |   7 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-vf610.c                          | 295 +++++++++++++++++++++
 drivers/pinctrl/pinctrl-imx.c                      |  81 +++++-
 drivers/pinctrl/pinctrl-imx.h                      |   7 +-
 drivers/pinctrl/pinctrl-vf610.c                    |   2 +-
 10 files changed, 451 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-vf610.txt
 create mode 100644 drivers/gpio/gpio-vf610.c

-- 
2.1.0

