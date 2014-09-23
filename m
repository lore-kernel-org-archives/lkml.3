Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaIWRiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:38:20 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:50244 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbaIWRiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:38:15 -0400
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com, stefan@agner.ch
Subject: [PATCH v2 0/5] vf610: Add GPIO support
Date: Tue, 23 Sep 2014 19:37:52 +0200
Message-Id: <cover.1411492954.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These include the review of Linus and Bill. I also added a patch
creating the Documentation for the GPIO/PORT module (altough, the
device tree bindings are already in use and not part this patch).
Then there is a small extension to Colibri VF61 device tree, and
because of that change I refrained to add Linus Acked-By to the DTS
patch. Linus, if you agree, can you send the Ack for that patch
again?

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
  Documentation: dts: Add bindings for Vybrid GPIO/PORT module

 .../devicetree/bindings/gpio/gpio-vf610.txt        |  56 ++++
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts        |   5 +
 arch/arm/boot/dts/vf610-colibri.dtsi               |  19 ++
 arch/arm/boot/dts/vf610-twr.dts                    |   1 +
 arch/arm/boot/dts/vf610.dtsi                       |   1 +
 drivers/gpio/Kconfig                               |   7 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-vf610.c                          | 284 +++++++++++++++++++++
 drivers/pinctrl/pinctrl-imx.c                      |  63 ++++-
 drivers/pinctrl/pinctrl-imx.h                      |   8 +-
 drivers/pinctrl/pinctrl-vf610.c                    |   2 +-
 11 files changed, 438 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-vf610.txt
 create mode 100644 drivers/gpio/gpio-vf610.c

-- 
2.1.0

