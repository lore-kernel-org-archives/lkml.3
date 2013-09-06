Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab3IFJUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 05:20:45 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:33257 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3IFJUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 05:20:25 -0400
MIME-Version: 1.0
Date: Fri, 6 Sep 2013 11:20:25 +0200
Message-ID: <CACRpkdar99ZUEp42Kcr_f0FSfFw7Q1EbJQ0-ZEZRsauen-S7cg@mail.gmail.com>
Subject: [GIT PULL] GPIO changes for v3.12
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the bulk of GPIO changes for the v3.12 series.
Details can be found in the signed tag.

I have a feeling that some of the fixes need to be taken
into -stable so I will attempt to ask the authors of suspected
patches to indicate this to Greg in a separate mail.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.12-1

for you to fetch changes up to 65d876564e989b63b0f769e0e06b9830db97b2d9:

  gpio: return -ENOTSUPP if debounce cannot be set (2013-09-04 14:22:47 +0200)

----------------------------------------------------------------
This is the bulk of GPIO changes for the v3.12 series:

- A new driver for the TZ1090 PDC which is used on the metag
  architecture.

- A new driver for the Kontron ETX or COMexpress GPIO block.
  This is found on some ETX x86 devices.

- A new driver for the Fintek Super-I/O chips, used on
  some x86 boards.

- Added device tree probing on a few select GPIO blocks.

- Drop the Exynos support from the Samsung GPIO driver.
  The Samsung maintainers have moved over to use the
  modernized pin control driver to provide GPIO for the
  modern platforms instead.

- The usual bunch of non-critical fixes and cleanups.

----------------------------------------------------------------
Andrew Chew (1):
      gpio: palmas: Fix misreported GPIO out value

Andrew Ruder (1):
      gpio: pca953x: fix gpio input on gpio offsets >= 8

Brunner Michael (1):
      gpio: Fix bit masking in Kontron PLD GPIO driver

Christophe Leroy (1):
      gpio: max7301: Reverting "Do not force SPI speed when using OF Platform"

Daniel M. Weeks (1):
      gpio-mcp23s08: i2c: auto-select base if no DT match or platform data

Daniel Mack (2):
      gpio: pxa: remove dead code
      gpio: pxa: fix Documentation of interrupt-names property

Fabio Estevam (2):
      gpio: gpio-mxc: Use devm functions
      gpio: gpio-mxc: Include "<linux/err.h>"

Guenter Roeck (1):
      gpio: Kontron PLD gpio driver

James Hogan (3):
      gpio-tz1090: add TZ1090 gpio driver
      gpio-tz1090-pdc: add TZ1090 PDC gpio driver
      gpio-tz1090: convert to use generic irqchip

Jingoo Han (3):
      gpiolib: replace strict_strtol() with kstrtol()
      gpio: use dev_get_platdata()
      gpio: msm: Staticize local variable 'msm_gpio'

Joe Perches (1):
      MAINTAINERS: gpio: vt8500: Remove file pattern

Julia Lawall (2):
      drivers/gpio/gpio-omap.c: convert comma to semicolon
      drivers/gpio: simplify use of devm_ioremap_resource

Lars Poeschel (3):
      gpio: adnp: Fix segfault if request_threaded_irq fails
      gpio: mcp23s08: rename the device tree property
      of: add vendor prefix for Microchip Technology Inc

Laurent Pinchart (3):
      gpio-rcar: Add interrupt controller support to the DT bindings
      gpio: pcf857x: Sort headers alphabetically
      gpio: pcf857x: Remove pdata argument to pcf857x_irq_domain_init()

Laxman Dewangan (1):
      gpio: palmas: add dt support

Linus Walleij (2):
      gpio: improve error path in gpiolib
      gpio: return -ENOTSUPP if debounce cannot be set

Lothar Waßmann (1):
      gpio: gpiolib-of.c: make error message more meaningful by adding
the node name and index

Magnus Damm (1):
      gpio: em: Add pinctrl support

Mathias Nyman (1):
      gpio-lynxpoint: Fix warning about unbalanced pm_runtime_enable

Michael Brunner (1):
      gpio: Fix platform driver name in Kontron PLD GPIO driver

Peter Ujfalusi (1):
      GPIO: gpio-twl6040: Remove support for legacy (pdata) mode

Simon Guinot (1):
      gpio: add GPIO support for F71882FG and F71889F

Tomasz Figa (1):
      gpio: samsung: Drop support for Exynos SoCs

Uwe Kleine-König (1):
      gpio/mxc: add chained_irq_enter/exit() to mx2_gpio_irq_handler

 .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |  26 +-
 .../devicetree/bindings/gpio/gpio-palmas.txt       |  27 +
 .../devicetree/bindings/gpio/gpio-tz1090-pdc.txt   |  45 ++
 .../devicetree/bindings/gpio/gpio-tz1090.txt       |  88 +++
 .../devicetree/bindings/gpio/mrvl-gpio.txt         |   7 +-
 .../devicetree/bindings/gpio/renesas,gpio-rcar.txt |   8 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 MAINTAINERS                                        |   1 -
 drivers/gpio/Kconfig                               |  37 +
 drivers/gpio/Makefile                              |   4 +
 drivers/gpio/gpio-74x164.c                         |   2 +-
 drivers/gpio/gpio-adnp.c                           |   6 +-
 drivers/gpio/gpio-adp5520.c                        |   2 +-
 drivers/gpio/gpio-adp5588.c                        |   9 +-
 drivers/gpio/gpio-arizona.c                        |   2 +-
 drivers/gpio/gpio-da9052.c                         |   2 +-
 drivers/gpio/gpio-da9055.c                         |   2 +-
 drivers/gpio/gpio-em.c                             |  27 +-
 drivers/gpio/gpio-f7188x.c                         | 469 +++++++++++
 drivers/gpio/gpio-ich.c                            |   2 +-
 drivers/gpio/gpio-janz-ttl.c                       |   2 +-
 drivers/gpio/gpio-kempld.c                         | 219 ++++++
 drivers/gpio/gpio-lynxpoint.c                      |   1 +
 drivers/gpio/gpio-max7301.c                        |   3 +-
 drivers/gpio/gpio-max730x.c                        |   2 +-
 drivers/gpio/gpio-max732x.c                        |   8 +-
 drivers/gpio/gpio-mc33880.c                        |   2 +-
 drivers/gpio/gpio-mcp23s08.c                       |  52 +-
 drivers/gpio/gpio-msic.c                           |   2 +-
 drivers/gpio/gpio-msm-v2.c                         |   2 +-
 drivers/gpio/gpio-mvebu.c                          |   7 +-
 drivers/gpio/gpio-mxc.c                            |  41 +-
 drivers/gpio/gpio-omap.c                           |   4 +-
 drivers/gpio/gpio-palmas.c                         |  29 +-
 drivers/gpio/gpio-pca953x.c                        |   6 +-
 drivers/gpio/gpio-pcf857x.c                        |  17 +-
 drivers/gpio/gpio-pl061.c                          |   2 +-
 drivers/gpio/gpio-pxa.c                            |  13 +-
 drivers/gpio/gpio-rcar.c                           |   2 +-
 drivers/gpio/gpio-rdc321x.c                        |   2 +-
 drivers/gpio/gpio-samsung.c                        | 871 ---------------------
 drivers/gpio/gpio-spear-spics.c                    |   7 +-
 drivers/gpio/gpio-sta2x11.c                        |   2 +-
 drivers/gpio/gpio-sx150x.c                         |   2 +-
 drivers/gpio/gpio-timberdale.c                     |   4 +-
 drivers/gpio/gpio-tps65912.c                       |   2 +-
 drivers/gpio/gpio-ts5500.c                         |   2 +-
 drivers/gpio/gpio-twl4030.c                        |   6 +-
 drivers/gpio/gpio-twl6040.c                        |   6 +-
 drivers/gpio/gpio-tz1090-pdc.c                     | 243 ++++++
 drivers/gpio/gpio-tz1090.c                         | 606 ++++++++++++++
 drivers/gpio/gpio-ucb1400.c                        |   2 +-
 drivers/gpio/gpio-wm831x.c                         |   2 +-
 drivers/gpio/gpio-wm8350.c                         |   2 +-
 drivers/gpio/gpio-wm8994.c                         |   2 +-
 drivers/gpio/gpiolib-of.c                          |   3 +-
 drivers/gpio/gpiolib.c                             |  52 +-
 include/linux/platform_data/gpio-em.h              |   1 +
 58 files changed, 1967 insertions(+), 1031 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-palmas.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090-pdc.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
 create mode 100644 drivers/gpio/gpio-f7188x.c
 create mode 100644 drivers/gpio/gpio-kempld.c
 create mode 100644 drivers/gpio/gpio-tz1090-pdc.c
 create mode 100644 drivers/gpio/gpio-tz1090.c
