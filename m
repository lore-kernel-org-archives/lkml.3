Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3KKM5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:57:07 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:61387 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3KKM45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:56:57 -0500
MIME-Version: 1.0
Date: Mon, 11 Nov 2013 13:56:55 +0100
Message-ID: <CACRpkdZYQVfxNzqhJ0nNp6B7dMhhEd+pVUfmqJkxfXqw0dh1bQ@mail.gmail.com>
Subject: [GIT PULL] GPIO bulk changes for v3.13
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the bulk of GPIO changes for the v3.13 development
cycle.

Most of the description is in the signed tag. I've got ACKs for
the things that affect other subsystems (or it's my own subsystem,
like pinctrl). Most of that pertain to an attempt from my side
to consolidate and get rid of custom GPIO implementations
in the ARM tree. I will continue doing this.

The main change this time is the new GPIO descriptor API,
background for this can be found in Corbet's summary from
this january in LWN:
http://lwn.net/Articles/533632/

I merged in -rc4 and -rc6 to get rid of some nasty conflicts
appearing during the v3.12 development cycle.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.13-1

for you to fetch changes up to 993571273275bfecb5161806796eb368db234106:

  gpio: gpio-mxs: Remove unneeded dt checks (2013-11-06 10:51:24 +0100)

----------------------------------------------------------------
GPIO bulk changes for the v3.13 development cycle

- Merged the GPIO descriptor API from Alexandre Courbot.
  This is a first step toward trying to get rid of the
  global GPIO numberspace for the future.

- Add an API so that driver can flag that a certain GPIO
  line is being used by a irqchip backend for generating
  IRQs, so that we can enforce checks, like not allowing
  users to switch that line to an output at runtime, since
  this makes no sense. Implemented corresponding calls
  in a few select drivers.

- ACPI GPIO cleanups, refactorings and switch to using the
  descriptor-based interface.

- Support for the TPS80036 Palmas GPIO variant.

- A new driver for the Broadcom Kona GPIO SoC IP block.

- Device tree support for the PCF857x driver.

- A set of ARM GPIO refactorings with the goal of getting
  rid of a bunch of custom GPIO implementations from the
  arch/arm/* tree:

  - Move the IOP GPIO driver to the GPIO subsystem and
    fix all users to use the gpiolib API for accessing
    GPIOs. Delete the old custom GPIO implementation.

  - Delete the unused custom PXA GPIO implemention.

  - Convert all users of the IXP4 custom GPIO
    implementation to use gpiolib and delete the custom
    implementation.

  - Delete the custom Gemini GPIO implementation, also
    completely unused.

- Various cleanups and renamings.

----------------------------------------------------------------
Alexandre Courbot (7):
      gpiolib: factorize gpiod_get/set functions
      gpiolib: export descriptor-based GPIO interface
      gpiolib: port of_ functions to use gpiod
      gpiolib: add gpiod_get() and gpiod_put() functions
      gpiolib: devres: fix devm_gpiod_get_index()
      gpiolib: make GPIO_DEVRES depend on GPIOLIB
      gpiolib: devres: add missing headers

Charles Keepax (2):
      gpio: arizona: Add wm8997 support to probe
      gpio: arizona: Use the of_node from the Arizona device

David Cohen (4):
      gpio: langwell: add Intel Merrifield support
      gpio: rename gpio-langwell to gpio-intel-mid
      gpio-intel-mid: update prefixes and names from langwell to intel-mid
      MAINTAINERS: GPIO-INTEL-MID: add maintainer

Fabio Estevam (1):
      gpio: gpio-mxs: Remove unneeded dt checks

George Cherian (3):
      gpio: pcf857x: change to devm_request_threaded_irq
      gpio: pcf857x: remove the irq_demux_work and gpio->irq
      gpio: pcf857x: call the gpio user handler iff gpio_to_irq is done

Graeme Smecher (1):
      gpio: pca953x: Don't flip bits on PCA957x GPIO expanders when
probing them.

Ian Molton (1):
      emev2: GPIOLIB: Enable support for OF

Javier Martinez Canillas (1):
      gpio/omap: use gpiolib API to mark a GPIO used as an IRQ

Jean Delvare (1):
      gpio: ucb1400: Can be built as a module

Jingoo Han (1):
      gpio: bt8xx: remove unnecessary pci_set_drvdata()

Laurent Pinchart (1):
      gpio: pcf857x: Add OF support

Laxman Dewangan (1):
      gpio: palmas: add support for TPS80036

Linus Walleij (42):
      gpio: pcf857x: only use set_irq_flags() on ARM
      ARM: plat-iop: move the GPIO driver to drivers/gpio
      ARM: iop32x: request and issue reset using gpio
      ARM: iop32x: read N2100 power key using gpiolib
      gpio: decouple the IOP GPIO driver from platform
      ARM: plat-iop: remove custom complex GPIO implementation
      ARM: plat-iop: instantiate GPIO from platform device
      gpio: iop: use readl/writel accessors
      ARM: plat-iop: pass physical base for GPIO
      gpio: bcm-kona: only use set_irq_flags() on ARM
      Merge branch 'iop-cleanup' into devel
      ARM: mmp: delete the custom GPIO header
      ARM: pxa: delete the custom GPIO header
      Merge branch 'pxa-cleanup' into devel
      ARM: ixp4xx: convert remaining users to use gpiolib
      input: misc: ixp4-beeper: switch to use gpiolib
      input: misc: ixp4-beeper: use gpiolib strictly
      ptp: switch to use gpiolib
      staging: media/lirc: switch to use gpiolib
      ARM: ixp4: delete irq_to_gpio
      ARM: ixp4xx: stop broadcasting the custom GPIO API
      Merge branch 'ixp4-cleanup' into devel
      ARM: w90x900: delete <mach/gpio.h>
      ARM: gemini: delete <mach/gpio.h>
      gpio: tc3589x: drop references to "virtual" IRQ
      gpio: adnp: rename "virq" to "child_irq"
      gpio: bcm_kona: rename confusing variables
      gpio: em: drop references to "virtual" IRQ
      gpio: intel-mid: drop references to "virtual" IRQ
      gpio: lynxpoint: drop references to "virtual" IRQ
      gpio: mpc8xxx: drop references to "virtual" IRQ
      gpio: pl061: drop references to "virtual" IRQ
      gpio: rcar: drop references to "virtual" IRQ
      gpio: stmpe: drop references to "virtual" IRQ, fix bug
      gpio: ep93xx: get rid of bogus __raw* accessors
      gpio: add API to be strict about GPIO IRQ usage
      pinctrl: nomadik: mark GPIO lines used for IRQ
      pinctrl: coh901: mark GPIO lines used for IRQ
      Merge tag 'v3.12-rc4' into devel
      Fixup "MAINTAINERS: GPIO-INTEL-MID: add maintainer"
      Merge tag 'v3.12-rc6' into devel
      gpio: provide stubs for devres gpio functions

Mark Brown (2):
      gpiolib: Provide helper macros for logging of GPIO events
      gpiolib: Include GPIO label in log messages for GPIOs

Markus Mayer (3):
      gpio: bcm281xx: Add GPIO driver
      gpio: bcm281xx: Fix nested interrupt handler issue
      gpio: bcm281xx: Don't print addresses of GPIO area in probe()

Mika Westerberg (5):
      gpiolib / ACPI: move acpi_gpiochip_free_interrupts next to the
request function
      gpiolib / ACPI: convert to gpiod interfaces
      gpiolib / ACPI: add ACPI support for gpiod_get_index()
      gpiolib / ACPI: allow passing GPIOF_ACTIVE_LOW for GpioInt resources
      gpiolib / ACPI: document the GPIO descriptor based interface

Rob Herring (1):
      gpio: pl061: don't depend on CONFIG_ARM

Sachin Kamat (8):
      gpio: gpio-74x164: Remove redundant spi_set_drvdata
      gpio: gpio-74x164: Remove redundant of_match_ptr
      gpio: gpio-mc33880: Remove redundant spi_set_drvdata
      gpio: adnp: Remove redundant of_match_ptr
      gpio: clps711x: Remove redundant of_match_ptr
      gpio: twl4030: Remove redundant of_match_ptr
      gpio: lpc32xx: Include linux/of.h header
      gpio: rcar: Include linux/of.h header

Stephen Rothwell (2):
      gpiolib: include gpio/consumer.h in of_gpio.h for desc_to_gpio()
      gpiolib: provide a declaration of seq_file in gpio/driver.h

Stephen Warren (1):
      gpio: tegra: use new gpio_lock_as_irq() API

Wei Yongjun (1):
      gpio: bcm-kona: add missing .owner to struct gpio_chip

Zhang Rui (1):
      gpiolib-acpi: convert acpi_evaluate_object() to
acpi_execute_simple_method()

 Documentation/acpi/enumeration.txt                 |  26 +-
 .../devicetree/bindings/gpio/gpio-bcm-kona.txt     |  52 ++
 .../devicetree/bindings/gpio/gpio-pcf857x.txt      |  71 ++
 MAINTAINERS                                        |   6 +
 arch/arm/Kconfig                                   |   7 +-
 arch/arm/include/asm/hardware/iop3xx-gpio.h        |  75 --
 arch/arm/include/asm/hardware/iop3xx.h             |  12 -
 arch/arm/mach-gemini/gpio.c                        |   2 +-
 arch/arm/mach-gemini/include/mach/gpio.h           |  20 -
 arch/arm/mach-iop32x/em7210.c                      |   2 +
 arch/arm/mach-iop32x/glantank.c                    |   2 +
 arch/arm/mach-iop32x/gpio-iop32x.h                 |  10 +
 arch/arm/mach-iop32x/include/mach/gpio.h           |   6 -
 arch/arm/mach-iop32x/include/mach/iop32x.h         |   1 -
 arch/arm/mach-iop32x/iq31244.c                     |   2 +
 arch/arm/mach-iop32x/iq80321.c                     |   2 +
 arch/arm/mach-iop32x/n2100.c                       |  47 +-
 arch/arm/mach-iop33x/include/mach/gpio.h           |   6 -
 arch/arm/mach-iop33x/include/mach/iop33x.h         |   1 -
 arch/arm/mach-iop33x/iq80331.c                     |   7 +
 arch/arm/mach-iop33x/iq80332.c                     |   7 +
 arch/arm/mach-ixp4xx/common.c                      |  49 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c               |  65 +-
 arch/arm/mach-ixp4xx/include/mach/platform.h       |  39 -
 arch/arm/mach-ixp4xx/ixdp425-setup.c               |   8 +-
 arch/arm/mach-ixp4xx/nas100d-setup.c               |  49 +-
 arch/arm/mach-ixp4xx/nslu2-setup.c                 |  17 +-
 arch/arm/mach-mmp/include/mach/gpio.h              |   8 -
 arch/arm/mach-pxa/include/mach/gpio.h              |  32 -
 arch/arm/mach-w90x900/include/mach/gpio.h          |  30 -
 arch/arm/plat-iop/Makefile                         |   2 -
 drivers/gpio/Kconfig                               |  35 +-
 drivers/gpio/Makefile                              |   4 +-
 drivers/gpio/devres.c                              |  85 +++
 drivers/gpio/gpio-74x164.c                         |   5 +-
 drivers/gpio/gpio-adnp.c                           |   8 +-
 drivers/gpio/gpio-arizona.c                        |   4 +
 drivers/gpio/gpio-bcm-kona.c                       | 640 ++++++++++++++++
 drivers/gpio/gpio-bt8xx.c                          |   2 -
 drivers/gpio/gpio-clps711x.c                       |   2 +-
 drivers/gpio/gpio-em.c                             |  13 +-
 drivers/gpio/gpio-ep93xx.c                         |  18 +-
 drivers/gpio/gpio-intel-mid.c                      | 471 ++++++++++++
 .../arm/plat-iop/gpio.c => drivers/gpio/gpio-iop.c |  67 +-
 drivers/gpio/gpio-langwell.c                       | 397 ----------
 drivers/gpio/gpio-lpc32xx.c                        |   1 +
 drivers/gpio/gpio-lynxpoint.c                      |  19 +-
 drivers/gpio/gpio-mc33880.c                        |   3 -
 drivers/gpio/gpio-mpc8xxx.c                        |   8 +-
 drivers/gpio/gpio-mxs.c                            |  32 +-
 drivers/gpio/gpio-omap.c                           |  20 +-
 drivers/gpio/gpio-palmas.c                         | 104 ++-
 drivers/gpio/gpio-pca953x.c                        |  11 -
 drivers/gpio/gpio-pcf857x.c                        | 105 ++-
 drivers/gpio/gpio-pl061.c                          |  10 +-
 drivers/gpio/gpio-rcar.c                           |  13 +-
 drivers/gpio/gpio-stmpe.c                          |  25 +-
 drivers/gpio/gpio-tc3589x.c                        |  36 +-
 drivers/gpio/gpio-tegra.c                          |  18 +
 drivers/gpio/gpio-twl4030.c                        |   2 +-
 drivers/gpio/gpiolib-acpi.c                        | 138 ++--
 drivers/gpio/gpiolib-of.c                          |  28 +-
 drivers/gpio/gpiolib.c                             | 828 +++++++++++++++------
 drivers/input/misc/ixp4xx-beeper.c                 |  25 +-
 drivers/pinctrl/pinctrl-coh901.c                   |   5 +
 drivers/pinctrl/pinctrl-nomadik.c                  |   5 +
 drivers/ptp/ptp_ixp46x.c                           |   9 +-
 drivers/staging/media/lirc/lirc_serial.c           |  16 +-
 include/asm-generic/gpio.h                         | 225 ++----
 include/linux/acpi_gpio.h                          |  31 +-
 include/linux/gpio.h                               |  57 +-
 include/linux/gpio/consumer.h                      | 253 +++++++
 include/linux/gpio/driver.h                        | 184 +++++
 include/linux/of_gpio.h                            |  29 +-
 74 files changed, 3199 insertions(+), 1455 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-bcm-kona.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
 delete mode 100644 arch/arm/include/asm/hardware/iop3xx-gpio.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/gpio.h
 create mode 100644 arch/arm/mach-iop32x/gpio-iop32x.h
 delete mode 100644 arch/arm/mach-iop32x/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-iop33x/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-w90x900/include/mach/gpio.h
 create mode 100644 drivers/gpio/gpio-bcm-kona.c
 create mode 100644 drivers/gpio/gpio-intel-mid.c
 rename arch/arm/plat-iop/gpio.c => drivers/gpio/gpio-iop.c (56%)
 delete mode 100644 drivers/gpio/gpio-langwell.c
 create mode 100644 include/linux/gpio/consumer.h
 create mode 100644 include/linux/gpio/driver.h
