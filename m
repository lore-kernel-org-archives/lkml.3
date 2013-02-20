Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab3BTQ3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:29:20 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:42171 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab3BTQ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:29:18 -0500
MIME-Version: 1.0
Date: Wed, 20 Feb 2013 17:29:17 +0100
Message-ID: <CACRpkdYtzootpZB7vq-2pkBjjOCQFe3uEHejqD-fjDBs9U=idg@mail.gmail.com>
Subject: [GIT PULL] pinctrl bulk changes for v3.9
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the bulk of pin control changes for v3.9. Most of the description
is in the signed tag. They are rotated in linux-next, changes to other
subsystems are ACKed, and I tested to pull it all into the HEAD of
your tree for a tester and everything when smooth.

The most interesting change by far is how the device core grabs
pinctrl default handles avoiding the need to stick boilerplate into
driver consumers.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.9

for you to fetch changes up to ade158eb53eed40f6090e9f7ee6ee3513ec1eec4:

  pinctrl: tegra: add clfvs function to Tegra114 support (2013-02-15
20:22:39 +0100)

----------------------------------------------------------------
These are the main pinctrl changes for the v3.9 merge window:

- Grabbing of default pinctrl handles from the device core.
  These are the hunks hitting drivers/base. All is ACKed by
  Greg, after a long discussion about different alternatives.

- Some stuff also touches the MFD and ARM SoC trees, this has
  been coordinated and ACKed.

- New drivers for:

  - The Tegra 114 sub-SoC
  - Allwinner sunxi
  - New ABx500 driver and sub-SoC drivers for AB8500,
    AB8505, AB9540 and AB8540.

- Make it possible for hogged pins to enter a sleep mode,
  and make it possible for drivers to control that mode.

- Various clean-up, extensions and device tree support to
  various pin controllers.

----------------------------------------------------------------
Gabriel Fernandez (1):
      pinctrl/nomadik: add device tree support

Haojian Zhuang (4):
      pinctrl: core: get devname from pinctrl_dev
      gpio: use pinctrl device name for add range
      pinctrl: generic: add slew rate config parameter
      pinctrl: generic: rename input schmitt disable

Jingoo Han (1):
      pinctrl: samsung: remove duplicated line

John Crispin (10):
      pinctrl/lantiq: pinconf uses port instead of pin
      pinctrl/lantiq: faulty bit inversion
      pinctrl/lantiq: add pin_config_group_set support
      pinctrl/lantiq: add output pinconf parameter
      pinctrl/lantiq: the pinconf OD parameter argument was ignored
      pinctrl/lantiq: only probe available pad controllers
      pinctrl/lantiq: one of the boot leds was defined incorrectly
      pinctrl/lantiq: fix pinconfig parameters
      pinctrl/lantiq: add functionality to falcon_pinconf_dbg_show
      pinctrl/lantiq: fix pin number in ltq_pmx_gpio_request_enable

Julien Delacou (2):
      pinctrl: add sleep mode management for hogs
      pinctrl/nomadik: adopt pinctrl sleep mode management

Kukjin Kim (1):
      pinctrl: exynos: change PINCTRL_EXYNOS option

Laurent Meunier (1):
      pinctrl/pinconfig: add debug interface

Lee Jones (14):
      ARM: ux500: Provide a link from AB8500 Pinctrl to the PRCMU
      pinctrl: nomadik: Allow prcm_base to be extracted from Device Tree
      ARM: ux500: correct typo in pinctrl Device Tree node
      pinctrl/abx500: use the BIT() macro where appropriate
      pinctrl/abx500: replace incorrect return value
      pinctrl/abx500: beautify the ABX500 pin control driver
      pinctrl/abx500: destroy mutex if returning early due to error
      pinctrl/abx500: prevent error path from corrupting returning error
      pinctrl/abx500: align GPIO cluster boundaries
      pinctrl/abx500: add Device Tree support
      pinctrl/abx500: move IRQ handling to ab8500-core
      pinctrl/abx500: replace IRQ offsets with table read-in values
      ARM: ux500: remove irq_base property from platform_data
      ARM: ux500: use real AB8500 IRQ numbers instead of virtual ones

Linus Walleij (13):
      pinctrl: skip deferral of hogs
      pinctrl: add pinconf-generic defines for output
      pinctrl/nomadik: make independent of <mach/irqs.h>
      pinctrl/nomadik: simplify GPIO probe
      pinctrl: do not defer device tree hogs
      drivers/pinctrl: grab default handles from device core
      ARM: ux500: select the DB8540 pin controller
      mfd: ab8500: update header file and version detection
      gpio: delete AB8500 driver
      pinctrl/abx500: adjust offset for get_mode()
      pinctrl: exynos5440: remove erroneous __init
      Merge branch 'allwinner-sunxi' into devel
      pinctrl/abx500: use direct IRQ defines

Maxime Ripard (13):
      pinctrl: pinconf-generic: add drive strength parameter
      ARM: sunxi: Add pinctrl driver for Allwinner SoCs
      ARM: pinctrl: sunxi: Add the pinctrl pin set for sun5i
      ARM: sunxi: Add pinctrl node to the device tree
      ARM: sunxi: Add uart1 pinctrl groups
      ARM: sunxi: olinuxino: Add muxing for the uart
      ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
      ARM: sunxi: Increase the number of GPIOs available
      pinctrl: sunxi: Document sun5i pins functions
      ARM: pinctrl: sunxi: Add the pinctrl pin set for Allwinner A10
      ARM: sunxi: Add the sun4i pinctrl and gpio nodes
      ARM: sunxi: Add the pin groups for UART0 and UART1 on sun4i
      pinctrl: sunxi: add of_xlate function

Patrice Chotard (5):
      pinctrl: add abx500 pinctrl driver core
      pinctrl/abx500: add AB8500 sub-driver
      pinctrl/abx500: add AB8505 sub-driver
      pinctrl/abx500: add AB9540 sub-driver
      pinctrl/abx500: add AB8540 sub-driver

Pritesh Raithatha (2):
      pinctrl: tegra: add support for rcv-sel and drive type
      pinctrl: tegra114: add pinctrl driver for NVIDIA's Tegra114 SoC

Rhyland Klein (1):
      pinctrl: tegra: add clfvs function to Tegra114 support

Sachin Kamat (1):
      pinctrl: core: Make pinctrl_release static

 .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |   60 +
 .../bindings/pinctrl/nvidia,tegra114-pinmux.txt    |  120 +
 .../devicetree/bindings/pinctrl/ste,nomadik.txt    |  140 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/pinctrl.txt                          |   18 +-
 arch/arm/Kconfig                                   |    2 +-
 arch/arm/boot/dts/dbx5x0.dtsi                      |   10 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   30 +
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts          |    2 +
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   23 +
 arch/arm/mach-exynos/Kconfig                       |    2 +-
 arch/arm/mach-sunxi/Kconfig                        |    1 +
 arch/arm/mach-ux500/Kconfig                        |    6 +
 arch/arm/mach-ux500/board-mop500.c                 |   20 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |    2 +-
 .../mach-ux500/include/mach/irqs-board-mop500.h    |   10 +-
 drivers/base/Makefile                              |    1 +
 drivers/base/dd.c                                  |    7 +
 drivers/base/pinctrl.c                             |   69 +
 drivers/gpio/Kconfig                               |    6 -
 drivers/gpio/Makefile                              |    1 -
 drivers/gpio/gpio-ab8500.c                         |  520 ----
 drivers/gpio/gpiolib-of.c                          |    2 +-
 drivers/pinctrl/Kconfig                            |   36 +-
 drivers/pinctrl/Makefile                           |    9 +-
 drivers/pinctrl/core.c                             |  118 +-
 drivers/pinctrl/core.h                             |   29 +
 drivers/pinctrl/devicetree.c                       |    5 +
 drivers/pinctrl/pinconf-generic.c                  |    4 +-
 drivers/pinctrl/pinconf.c                          |  207 ++
 drivers/pinctrl/pinctrl-ab8500.c                   |  484 ++++
 drivers/pinctrl/pinctrl-ab8505.c                   |  380 +++
 drivers/pinctrl/pinctrl-ab8540.c                   |  407 +++
 drivers/pinctrl/pinctrl-ab9540.c                   |  485 ++++
 drivers/pinctrl/pinctrl-abx500.c                   | 1012 +++++++
 drivers/pinctrl/pinctrl-abx500.h                   |  234 ++
 drivers/pinctrl/pinctrl-exynos5440.c               |   10 +-
 drivers/pinctrl/pinctrl-falcon.c                   |   38 +-
 drivers/pinctrl/pinctrl-lantiq.c                   |   56 +-
 drivers/pinctrl/pinctrl-lantiq.h                   |    1 +
 drivers/pinctrl/pinctrl-nomadik.c                  |  390 ++-
 drivers/pinctrl/pinctrl-samsung.c                  |    1 -
 drivers/pinctrl/pinctrl-sunxi.c                    | 1505 +++++++++++
 drivers/pinctrl/pinctrl-sunxi.h                    |  478 ++++
 drivers/pinctrl/pinctrl-tegra.c                    |   14 +
 drivers/pinctrl/pinctrl-tegra.h                    |   16 +
 drivers/pinctrl/pinctrl-tegra114.c                 | 2769 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-tegra20.c                  |    6 +
 drivers/pinctrl/pinctrl-tegra30.c                  |    4 +
 drivers/pinctrl/pinctrl-xway.c                     |   60 +-
 include/linux/device.h                             |    7 +
 include/linux/mfd/abx500/ab8500-gpio.h             |   16 +-
 include/linux/mfd/abx500/ab8500.h                  |  279 +-
 include/linux/pinctrl/devinfo.h                    |   45 +
 include/linux/pinctrl/pinconf-generic.h            |   16 +-
 include/linux/pinctrl/pinctrl.h                    |    1 +
 56 files changed, 9424 insertions(+), 751 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/nvidia,tegra114-pinmux.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
 create mode 100644 drivers/base/pinctrl.c
 delete mode 100644 drivers/gpio/gpio-ab8500.c
 create mode 100644 drivers/pinctrl/pinctrl-ab8500.c
 create mode 100644 drivers/pinctrl/pinctrl-ab8505.c
 create mode 100644 drivers/pinctrl/pinctrl-ab8540.c
 create mode 100644 drivers/pinctrl/pinctrl-ab9540.c
 create mode 100644 drivers/pinctrl/pinctrl-abx500.c
 create mode 100644 drivers/pinctrl/pinctrl-abx500.h
 create mode 100644 drivers/pinctrl/pinctrl-sunxi.c
 create mode 100644 drivers/pinctrl/pinctrl-sunxi.h
 create mode 100644 drivers/pinctrl/pinctrl-tegra114.c
 create mode 100644 include/linux/pinctrl/devinfo.h
