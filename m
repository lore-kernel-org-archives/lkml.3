Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3KKGoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 01:44:44 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:57274 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3KKGoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 01:44:39 -0500
MIME-Version: 1.0
Date: Mon, 11 Nov 2013 07:44:38 +0100
Message-ID: <CACRpkdYpuZec_JRAPYZHmB5qTYebKR6iBy5=RvBUUEXsuOu97Q@mail.gmail.com>
Subject: [GIT PULL] pin control bulk changes for v3.13
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the bulk of pin control changes for the v3.13 cycle.
Most explanations are in the signed tag, I merged in v3.12-rc4
at one time to get rid of pointless conflicts with upstream.

The details of the bulk of the patches are in the signed tag.

The changes hitting arch/blackfin are ACKed by the Blackfin
maintainer, and the device tree bindings are ACKed to the
extent possible by someone from the device tree maintainers
group.

All has been boiled in linux-next for a while.

Please pull them in!

Yours,
Linus Walleij

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.13-1

for you to fetch changes up to 9da8312048edcf246ac1d7ab6aa0293f252de559:

  pinctrl: imx50: add pinctrl support code for the IMX50 SoC
(2013-11-06 10:06:59 +0100)

----------------------------------------------------------------
Main pin control pull request for the v3.13 cycle:

- Blackfin ADI pin control driver, we move yet another
  architecture under this subsystem umbrella.

- Incremental updates to the Renesas Super-H PFC pin control
  driver. New subdriver for the r8a7791 SoC.

- Non-linear GPIO ranges from the gpiolib side of things,
  this enabled simplified device tree bindings by referring
  entire groups of pins on some pin controller to act as
  back-end for a certain GPIO-chip driver.

- Add the Abilis TB10x pin control driver used on the ARC
  architecture. Also the corresponding GPIO driver is merged
  through this tree, so the ARC has full support for pins
  and GPIOs after this.

- Subdrivers for Freescale i.MX1, i.MX27 and i.MX50 pin
  controller instances. The i.MX1 and i.MX27 is an entirely
  new family (silicon) of controllers whereas i.MX50 is
  a variant of the previous supported controller.

- Then the usual slew of fixes, cleanups and incremental
  updates.

----------------------------------------------------------------
Alexandre Belloni (1):
      pinctrl: at91: correct a few typos

Axel Lin (2):
      pinctrl: adi2: Convert to devm_ioremap_resource
      pinctrl: adi2: Fix dead lock in adi_gpio_direction_output

Boris BREZILLON (3):
      pinctrl: at91: fix typos
      pinctrl: at91: fix sam9x5 debounce/deglitch functions
      ARM: at91/at91-pinctrl documentation: add missing sam9x5 compatible string

Christian Ruppert (4):
      pinctrl/gpio: non-linear GPIO ranges accesible from gpiolib
      pinctrl: add TB10x pin control driver
      pinctrl: add documentation for pinctrl_get_group_pins()
      gpio: add TB10x GPIO driver

Greg Ungerer (1):
      pinctrl: imx50: add pinctrl support code for the IMX50 SoC

Guennadi Liakhovetski (1):
      sh-pfc: r8a7790: add pin definitions for the I2C3 interface

Heiko Stübner (5):
      pinctrl: rockchip: separate different sub-types more
      pinctrl: rockchip: add support for multiple bank types
      pinctrl: rockchip: remove redundant check
      pinctrl: rockchip: add rk3188 specifics
      pinctrl: rockchip: emulate both edge triggered interrupts

Hisashi Nakamura (1):
      pinctrl: sh-pfc: r8a7791 PFC support

Kuninori Morimoto (1):
      sh-pfc: r8a7778: Add SRU/SSI pin support

Laxman Dewangan (3):
      pinctrl: palmas: remove non-require function
      pinctrl: palmas: remove pin config BIAS_PULL_PIN_DEFAULT support
      pincntrl: add support for ams AS3722 pin control driver

Linus Walleij (5):
      Merge branch 'devel' into for-next
      Merge branch 'pinmux/next' of git://linuxtv.org/pinchartl/fbdev into devel
      Merge tag 'v3.12-rc4' into devel
      Merge branch 'pinmux/next/pfc' of
git://linuxtv.org/pinchartl/fbdev into devel
      pinctrl: at91: copy define to driver

Markus Pargmann (2):
      pinctrl: imx1 core driver
      pinctrl: imx27: imx27 pincontrol driver

Michael Opdenacker (1):
      pinctrl: remove minor dead code

Peter Chen (1):
      pinctrl: imx: fix using pin->input_val wrongly

Qipan Li (2):
      pinctrl: sirf: add lost uart0-no-stream-control pingroup for prima2
      pinctrl: sirf: add lost USP-based UART pin groups for prima2

Roel Kluin (1):
      pinctrl: dove: unset twsi option3 for gconfig as well

Rong Wang (1):
      pinctrl: sirf: add USB1/UART1 pinmux usb/uart share

Sachin Kamat (2):
      pinctrl: remove redundant of_match_ptr
      pinctrl: mvebu: remove redundant of_match_ptr

Sergei Shtylyov (1):
      sh-pfc: r8a7778: Add CAN pin groups

Shawn Guo (1):
      pinctrl: imx: update fsl,pins description in bindings doc

Sonic Zhang (7):
      pinctrl: ADI PIN control driver for the GPIO controller on bf54x
and bf60x.
      blackfin: gpio: Remove none gpio lib code.
      pinctrl: pinctrl-adi2: Add dependency to arch BLACKFIN in Kconfig.
      pinctrl: pinctrl-adi2-bf60x: remove useless and duplicated GPIO
definition for PPI2.
      blackfin: pinctrl-adi2: Enable PINCTRL framework for BF54x and BF60x.
      pinctrl: pinctrl-adi2: Remove nested lock+irqsave that resue flags.
      pinctrl: pinctrl-adi2: disable IRQ when setting value

Ulrich Hecht (1):
      sh-pfc: r8a7790: Add I2C pin groups and functions

Wei Yongjun (5):
      pinctrl: tb10x: fix the error handling in tb10x_pinctrl_probe()
      pinctrl: tb10x: use module_platform_driver to simplify the code
      gpio: tb10x: use module_platform_driver to simplify the code
      gpio: tb10x: fix return value check in tb10x_gpio_probe()
      pinctrl: imx1: fix return value check in imx1_pinctrl_core_probe()

 .../devicetree/bindings/gpio/abilis,tb10x-gpio.txt |   36 +
 Documentation/devicetree/bindings/gpio/gpio.txt    |   40 +-
 .../bindings/pinctrl/abilis,tb10x-iomux.txt        |   80 +
 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |    2 +-
 .../bindings/pinctrl/fsl,imx-pinctrl.txt           |   37 +-
 .../bindings/pinctrl/fsl,imx27-pinctrl.txt         |   99 +
 .../devicetree/bindings/pinctrl/pinctrl-palmas.txt |    2 +-
 .../bindings/pinctrl/rockchip,pinctrl.txt          |   46 +-
 Documentation/pinctrl.txt                          |    7 +-
 arch/arm/boot/dts/atlas6.dtsi                      |   12 +
 arch/arm/boot/dts/prima2.dtsi                      |   42 +
 arch/blackfin/Kconfig                              |   11 +
 arch/blackfin/include/asm/gpio.h                   |  157 +-
 arch/blackfin/include/asm/portmux.h                |   19 +-
 arch/blackfin/kernel/Makefile                      |    3 +-
 arch/blackfin/mach-bf548/include/mach/portmux.h    |    2 -
 arch/blackfin/mach-bf609/include/mach/portmux.h    |    2 -
 drivers/gpio/Kconfig                               |    4 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-tb10x.c                          |  328 ++
 drivers/gpio/gpiolib-of.c                          |   63 +-
 drivers/gpio/gpiolib.c                             |   47 +
 drivers/pinctrl/Kconfig                            |   54 +
 drivers/pinctrl/Makefile                           |    8 +
 drivers/pinctrl/core.c                             |   14 +
 drivers/pinctrl/mvebu/pinctrl-armada-370.c         |    2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c          |    2 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c               |    4 +-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c           |    2 +-
 drivers/pinctrl/pinctrl-adi2-bf54x.c               |  592 +++
 drivers/pinctrl/pinctrl-adi2-bf60x.c               |  521 +++
 drivers/pinctrl/pinctrl-adi2.c                     | 1164 ++++++
 drivers/pinctrl/pinctrl-adi2.h                     |   75 +
 drivers/pinctrl/pinctrl-as3722.c                   |  630 +++
 drivers/pinctrl/pinctrl-at91.c                     |   37 +-
 drivers/pinctrl/pinctrl-exynos5440.c               |    2 +-
 drivers/pinctrl/pinctrl-imx.c                      |    6 +-
 drivers/pinctrl/pinctrl-imx1-core.c                |  653 +++
 drivers/pinctrl/pinctrl-imx1.h                     |   73 +
 drivers/pinctrl/pinctrl-imx27.c                    |  477 +++
 drivers/pinctrl/pinctrl-imx35.c                    |    2 +-
 drivers/pinctrl/pinctrl-imx50.c                    |  426 ++
 drivers/pinctrl/pinctrl-imx51.c                    |    2 +-
 drivers/pinctrl/pinctrl-imx53.c                    |    2 +-
 drivers/pinctrl/pinctrl-imx6dl.c                   |    2 +-
 drivers/pinctrl/pinctrl-imx6q.c                    |    2 +-
 drivers/pinctrl/pinctrl-imx6sl.c                   |    2 +-
 drivers/pinctrl/pinctrl-palmas.c                   |   20 -
 drivers/pinctrl/pinctrl-rockchip.c                 |  292 +-
 drivers/pinctrl/pinctrl-samsung.c                  |    2 +-
 drivers/pinctrl/pinctrl-tb10x.c                    |  875 ++++
 drivers/pinctrl/pinctrl-vf610.c                    |    2 +-
 drivers/pinctrl/pinmux.c                           |    4 +-
 drivers/pinctrl/sh-pfc/Kconfig                     |    5 +
 drivers/pinctrl/sh-pfc/Makefile                    |    1 +
 drivers/pinctrl/sh-pfc/core.c                      |    9 +
 drivers/pinctrl/sh-pfc/core.h                      |    1 +
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |  180 +
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c               |  110 +
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               | 4214 ++++++++++++++++++++
 drivers/pinctrl/sirf/pinctrl-atlas6.c              |   56 +
 drivers/pinctrl/sirf/pinctrl-prima2.c              |  115 +
 drivers/pinctrl/sirf/pinctrl-sirf.c                |    8 +-
 drivers/pinctrl/sirf/pinctrl-sirf.h                |    6 +-
 drivers/pinctrl/spear/pinctrl-plgpio.c             |    2 +-
 include/asm-generic/gpio.h                         |   10 +
 include/dt-bindings/pinctrl/at91.h                 |    2 +-
 include/linux/gpio.h                               |   10 +
 include/linux/pinctrl/pinctrl.h                    |    3 +
 include/linux/platform_data/pinctrl-adi2.h         |   40 +
 70 files changed, 11459 insertions(+), 302 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/abilis,tb10x-iomux.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/fsl,imx27-pinctrl.txt
 create mode 100644 drivers/gpio/gpio-tb10x.c
 create mode 100644 drivers/pinctrl/pinctrl-adi2-bf54x.c
 create mode 100644 drivers/pinctrl/pinctrl-adi2-bf60x.c
 create mode 100644 drivers/pinctrl/pinctrl-adi2.c
 create mode 100644 drivers/pinctrl/pinctrl-adi2.h
 create mode 100644 drivers/pinctrl/pinctrl-as3722.c
 create mode 100644 drivers/pinctrl/pinctrl-imx1-core.c
 create mode 100644 drivers/pinctrl/pinctrl-imx1.h
 create mode 100644 drivers/pinctrl/pinctrl-imx27.c
 create mode 100644 drivers/pinctrl/pinctrl-imx50.c
 create mode 100644 drivers/pinctrl/pinctrl-tb10x.c
 create mode 100644 drivers/pinctrl/sh-pfc/pfc-r8a7791.c
 create mode 100644 include/linux/platform_data/pinctrl-adi2.h
