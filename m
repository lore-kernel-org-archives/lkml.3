Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaJPTsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:48:16 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:36808 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaJPTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:48:12 -0400
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com,
        l.stach@pengutronix.de, stefan@agner.ch
Subject: [PATCH v5 0/4] vf610: Add GPIO support
Date: Thu, 16 Oct 2014 21:47:56 +0200
Message-Id: <cover.1413488264.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebased version on top of Linus Walleij's gpio branch.

Shawn, on Friday, Sep 26th you wrote that you applied patch 3/4
(ARM: dts: vf610: use new GPIO support), however it did not yet
appear on your dt tree so far, but newer patches already did.
Maybe I'm wrong here, but can you check?

Since 3rd version of the GPIO support for Vybrid now also includes
the wakeup support which was part of the suspend/resume patchset
I sent earlier this week.

Changes in v5:
- Rebased on gpio devel branch

Changes in v4:
- Rebased on pinctrl devel branch (which has one patch already applied
  hence is not part of this version now)

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

Stefan Agner (4):
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
 drivers/pinctrl/freescale/pinctrl-imx.c            |  72 +++++
 8 files changed, 442 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-vf610.txt
 create mode 100644 drivers/gpio/gpio-vf610.c

-- 
2.1.2

