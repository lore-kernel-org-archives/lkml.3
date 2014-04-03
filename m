Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162480AbaDCHWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:22:36 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:44097 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162438AbaDCHW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:22:28 -0400
MIME-Version: 1.0
Date: Thu, 3 Apr 2014 09:22:27 +0200
Message-ID: <CACRpkdZAsWu3SHbreHwsD+FSgm5AQpRDS-YFB7NurDE-nCC9og@mail.gmail.com>
Subject: [GIT PULL] GPIO bulk changes for v3.15
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the bulk of GPIO changes for the v3.15 merge window.

Note:

- This tree has pulled in an immutable branch with some irqchip
  infrastructure from Thomas Gleixner. This stuff is already in
  your tree coming in from tip. However as this pull request is
  based on v3.14-rc6 you will still see the commits in this pull
  request, but it should be all right. (Else beat me up as usual.)
  I tested to pull it in on top of your master and it
  LooksGoodToMe(TM)

- Some changes hit the pin control tree, but have been funneled
  through this one tree to avoid fuzz and conflicts.

A pretty big chunk of changes this time, but it has all been on rotation
in linux-next and had some testing. Of course there will be some
amount of fixes on top...

The rest of the story is in the signed tag.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.15-1

for you to fetch changes up to b22978fc33dec72e5f8e17f90eb63ea9137aafd5:

  gpio: rcar: Add helper variable dev = &pdev->dev (2014-03-28 21:54:41 +0100)

----------------------------------------------------------------
This is the bulk of GPIO changes for v3.15:

- Merged in a branch of irqchip changes from Thomas
  Gleixner: we need to have new callbacks from the
  irqchip to determine if the GPIO line will be eligible
  for IRQs, and this callback must be able to say "no".
  After some thinking I got the branch from tglx and
  have switched all current users over to use this.

- Based on tglx patches, we have added some generic
  irqchip helpers in the gpiolib core. These will
  help centralize code when GPIO drivers have simple
  chained/cascaded IRQs. Drivers will still define
  their irqchip vtables, but the gpiolib core will
  take care of irqdomain set-up, mapping from local
  offsets to Linux irqs, and reserve resources by
  marking the GPIO lines for IRQs.

- Initially the PL061 and Nomadik GPIO/pin control
  drivers have been switched over to use the new
  gpiochip-to-irqchip infrastructure with more
  drivers expected for the next kernel cycle. The
  factoring of just two drivers still makes it worth
  it so it is already a win.

- A new driver for the Synopsys DesignWare APB GPIO
  block.

- Modify the DaVinci GPIO driver to be reusable also
  for the new TI Keystone architecture.

- A new driver for the LSI ZEVIO SoCs.

- Delete the obsolte tnetv107x driver.

- Some incremental work on GPIO descriptors: have
  gpiod_direction_output() use a logical level,
  respecting assertion polarity through ACTIVE_LOW
  flags, adding gpiod_direction_output_raw() for the
  case where you want to set that very value. Add
  gpiochip_get_desc() to fetch a GPIO descriptor from
  a specific offset on a certain chip inside driver
  code.

- Switch ACPI GPIO code over to using
  gpiochip_get_desc() and get rid of gpio_to_desc().

- The ACPI GPIO event handling code has been reworked
  after encountering an actual real life implementation.

- Support for ACPI GPIO operation regions.

- Generic GPIO chips can now be assigned labels/names
  from platform data.

- We now clamp values returned from GPIO drivers to
  the boolean [0,1] range.

- Some improved documentation on how to use the polarity
  flag was added.

- The a large slew of incremental driver updates and
  non-critical fixes. Some targeted for stable.

----------------------------------------------------------------
Aaron Sierra (4):
      gpio: pca953x: Add devices to Kconfig help
      gpio: pca953x: Add NXP PCA9698
      gpio: pca953x: Add Exar XRA1202
      gpio: pca953x: Fix gpio_base may not default to -1

Alan Tull (2):
      fix build error in gpio-dwapb patch
      gpio: gpio-dwapb size-cells should be two

Alexander Holler (1):
      gpio: davinci: fix gpio selection for OF

Alexander Shiyan (6):
      gpio: davinci: Use signed type for 'irq' variable
      gpio: rc5t583: Remove redundant check
      gpio: generic: Use platform_device_id->driver_data field for driver flags
      gpio: Driver for SYSCON-based GPIOs
      gpio: twl4030: Remove redundant assignment
      gpio: samsung: Add missing "break" statement

Alexandre Courbot (3):
      gpiolib: add gpiochip_get_desc() driver function
      gpiolib: ACPI: remove gpio_to_desc() usage
      gpio: clamp returned values to the boolean range

Arnd Bergmann (1):
      gpio: remove obsolete tnetv107x driver

Axel Lin (4):
      gpio: pl061: Select IRQ_DOMAIN rather than GENERIC_IRQ_CHIP
      gpio: clps711x: Add missing .owner to struct gpio_chip
      gpio: moxart: Avoid forward declaration
      gpio: moxart: Actually set output state in moxart_gpio_direction_output()

Bartlomiej Zolnierkiewicz (1):
      gpio: iop: fix devm_ioremap_resource() return value checking

Daniel Krueger (1):
      pch_gpio: set value before enabling output direction

David Cohen (1):
      gpio: intel-mid: comments cleanup

Fabian Vogt (1):
      gpio: New driver for LSI ZEVIO SoCs

Fabio Estevam (1):
      gpio: gpio-pl061: Use %pa to print 'resource_size_t'

Gary Servin (1):
      gpio: mcp23s08: trivial: fixed coding style issues

Geert Uytterhoeven (2):
      gpio: Spelling s/than/that/
      gpio: rcar: Add helper variable dev = &pdev->dev

Grygorii Strashko (1):
      gpio: davinci: reuse for keystone soc

James Hogan (1):
      gpio-tz1090: Replace commas with semi-colons

Jamie Iles (1):
      gpio: add a driver for the Synopsys DesignWare APB GPIO block

Jean Delvare (2):
      gpio-ts5500: Add dependency
      gpio: cs5535: Simplify dependencies

Jean-Francois Dagenais (3):
      gpio: adp5588: get value from data out when dir is out
      gpio: adp5588 - use "unsigned" for the setup and teardown callbacks
      gpio: adp5588 - add support for gpio names

Jingoo Han (2):
      gpio: pl061: Use devm_ioremap_resource()
      gpio: omap: Use devm_ioremap_resource()

Krzysztof Kozlowski (2):
      gpio: max732x: Fix I2C dummy device resource leak on probe failure
      gpio: max732x: Fix possible NULL pointer dereference on
i2c_new_dummy error

Lad, Prabhakar (1):
      devicetree: bindings: gpio-davinic: fix documentation

Linus Walleij (19):
      gpio: document how to make combined GPIO+irqchip drivers
      gpio: pl061: proper error messages
      gpio: pl061: lock IRQs when starting them
      gpio: pl061: refactor type setting
      gpio: pl061: remove confusing naming
      gpio: generic: clamp retured value to [0,1]
      gpio: zevio: depend on ARM and OF_GPIO
      gpio: remove misleading documentation
      Merge tag 'v3.14-rc6' into devel
      Merge branch 'irq/for-gpio' of git://git.kernel.org/.../tip/tip into devel
      gpio: switch drivers to use new callback
      pinctrl: coh901: move irq line locking to resource callbacks
      pinctrl: nomadik: rename secondary to latent
      pinctrl: nomadik: factor in platform data container
      gpio: add IRQ chip helpers in gpiolib
      gpio: pl061: convert driver to use gpiolib irqchip
      pinctrl: nomadik: convert driver to use gpiolib irqchip
      pinctrl: coh901: convert driver to use gpiolib irqchip
      gpio: unmap gpio irqs properly

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call

Markus Mayer (4):
      gpio: bcm281xx: Fix parameter name for GPIO_CONTROL macro
      gpio: bcm281xx: Centralize register locking
      gpio: bcm281xx: Use "unsigned gpio" consistently throughout the code
      MAINTAINERS: Add Broadcom GPIO maintainer

Mathias Nyman (1):
      gpio-lynxpoint: force gpio_get() to return "1" and "0" only

Mika Westerberg (5):
      gpiolib: Allow GPIO chips to request their own GPIOs
      gpio / ACPI: Allocate ACPI specific data directly in acpi_gpiochip_add()
      gpio / ACPI: Rename acpi_gpio_evt_pin to acpi_gpio_event
      gpio / ACPI: Rework ACPI GPIO event handling
      gpio / ACPI: Add support for ACPI GPIO operation regions

Pawel Moll (1):
      gpio: generic: Add label to platform data

Philipp Zabel (1):
      gpio: make gpiod_direction_output take a logical value

Rahul Bedarkar (1):
      GPIO: gpiolib: correct description of gpiod_direction_output

Sachin Kamat (1):
      gpio: gpiolib-of: Use PTR_ERR_OR_ZERO

Sebastian Andrzej Siewior (1):
      gpio: dwapb: correct gpio-cells in binding document

Stephen Warren (1):
      gpio: document polarity flag best practices

Thomas Gleixner (1):
      genirq: Provide irq_request/release_resources chip callbacks

Thomas Petazzoni (1):
      gpio: mvebu: use chained_irq_{enter,exit} for GIC compatibility

Vincent Donnefort (3):
      gpio: ich: Add blink capability option
      gpio: ich: Add support for multiple register addresses
      gpio: ich: Add output levels cache support

 .../bindings/gpio/cirrus,clps711x-mctrl-gpio.txt   |  17 +
 .../devicetree/bindings/gpio/gpio-davinci.txt      |  25 +-
 .../devicetree/bindings/gpio/gpio-zevio.txt        |  16 +
 Documentation/devicetree/bindings/gpio/gpio.txt    |  60 ++-
 .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |  60 +++
 Documentation/gpio/consumer.txt                    |   1 +
 Documentation/gpio/driver.txt                      |  35 ++
 MAINTAINERS                                        |   7 +
 drivers/gpio/Kconfig                               |  40 +-
 drivers/gpio/Makefile                              |   4 +-
 drivers/gpio/gpio-adnp.c                           |  15 +-
 drivers/gpio/gpio-adp5588.c                        |  16 +-
 drivers/gpio/gpio-bcm-kona.c                       | 109 +++--
 drivers/gpio/gpio-clps711x.c                       |   1 +
 drivers/gpio/gpio-davinci.c                        |  75 +++-
 drivers/gpio/gpio-dwapb.c                          | 438 +++++++++++++++++++
 drivers/gpio/gpio-em.c                             |  14 +-
 drivers/gpio/gpio-generic.c                        |  20 +-
 drivers/gpio/gpio-ich.c                            |  70 ++-
 drivers/gpio/gpio-intel-mid.c                      |  22 +-
 drivers/gpio/gpio-iop.c                            |   2 +
 drivers/gpio/gpio-lynxpoint.c                      |  16 +-
 drivers/gpio/gpio-max732x.c                        |   9 +
 drivers/gpio/gpio-mcp23s08.c                       |  36 +-
 drivers/gpio/gpio-moxart.c                         |  40 +-
 drivers/gpio/gpio-mvebu.c                          |   7 +
 drivers/gpio/gpio-mxs.c                            |   3 +-
 drivers/gpio/gpio-omap.c                           |  20 +-
 drivers/gpio/gpio-pca953x.c                        |  10 +-
 drivers/gpio/gpio-pch.c                            |   8 +-
 drivers/gpio/gpio-pl061.c                          | 108 ++---
 drivers/gpio/gpio-rc5t583.c                        |   2 +-
 drivers/gpio/gpio-rcar.c                           |  32 +-
 drivers/gpio/gpio-samsung.c                        |   1 +
 drivers/gpio/gpio-syscon.c                         | 191 +++++++++
 drivers/gpio/gpio-tnetv107x.c                      | 206 ---------
 drivers/gpio/gpio-twl4030.c                        |   6 +-
 drivers/gpio/gpio-tz1090.c                         |  28 +-
 drivers/gpio/gpio-zevio.c                          | 220 ++++++++++
 drivers/gpio/gpiolib-acpi.c                        | 474 +++++++++++++++------
 drivers/gpio/gpiolib-of.c                          |   3 +-
 drivers/gpio/gpiolib.c                             | 417 +++++++++++++++---
 drivers/gpio/gpiolib.h                             |   3 +
 drivers/pinctrl/Kconfig                            |   4 +
 drivers/pinctrl/pinctrl-adi2.c                     |   1 +
 drivers/pinctrl/pinctrl-baytrail.c                 |  14 +-
 drivers/pinctrl/pinctrl-coh901.c                   | 186 +++-----
 drivers/pinctrl/pinctrl-msm.c                      |  11 +-
 drivers/pinctrl/pinctrl-nomadik.c                  | 159 +++----
 drivers/pinctrl/sirf/pinctrl-sirf.c                |  14 +-
 include/asm-generic/gpio.h                         |   2 +-
 include/linux/basic_mmio_gpio.h                    |   1 +
 include/linux/gpio/consumer.h                      |  15 +-
 include/linux/gpio/driver.h                        |  48 +++
 include/linux/i2c/adp5588.h                        |   4 +-
 include/linux/irq.h                                |   6 +
 include/linux/platform_data/gpio-davinci.h         |   4 -
 kernel/irq/manage.c                                |  28 +-
 58 files changed, 2423 insertions(+), 961 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/gpio/cirrus,clps711x-mctrl-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-zevio.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
 create mode 100644 drivers/gpio/gpio-dwapb.c
 create mode 100644 drivers/gpio/gpio-syscon.c
 delete mode 100644 drivers/gpio/gpio-tnetv107x.c
 create mode 100644 drivers/gpio/gpio-zevio.c
