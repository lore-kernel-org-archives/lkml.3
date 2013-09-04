Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242Ab3IDIJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:09:58 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44668 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3IDIJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:09:53 -0400
MIME-Version: 1.0
Date: Wed, 4 Sep 2013 10:09:52 +0200
Message-ID: <CACRpkdbHOuKwJABrij1tO0nh9L1C5A98NWUpbn0fS-sH820NDQ@mail.gmail.com>
Subject: [GIT PULL] pin control changes for v3.12
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the bulk of pin control changes for the v3.12 series.
Most of the relevant information is in the tag.

I merged in v3.11-rc7 last week to get rid of a largeish conflict
within the sunxi (AllWinner) driver in linux-next and fix up the
non-trivial merge the right way. That driver had a rather large
fix adding locking late in the release cycle.

Overall the bulk changes this time is cleanups and refactorings
and not much new features, which is nice.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:

  Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.12-1

for you to fetch changes up to c9e3b2d8f75d84c7b333761471f6cef98ec4429a:

  pinctrl: sunxi: Fix off-by-one for valid offset range checking
(2013-08-30 10:37:36 +0200)

----------------------------------------------------------------
Bulk pin control changes for the v3.12 series:

- Refactorings for generic pin config handling in the core.

- Factor out a set of device tree utilities for use in all
  drivers, to parse and allocate maps from the device tree.

- Some fixes to the core such as more nitpicky locking.

- Pushed down config array iteration into the drivers.
  This patch is necessary for drivers that want to iterate
  over configs and pile up a stack of alterations to the
  same register(s), or if the driver wants to take a local
  spinlock when committing the configuration.

- A new driver for the Texas Instruments Palmas PMIC by
  Laxman Dewangan. This is used on the Tegra systems.

- A major cleanup and modernization of the PFC (Super Hitachi
  and ARM SHmobile) pin controller and subdrivers.

- Support for the A20 and A31 sunxi (AllWinner) SoCs.

- A huge pile of fixes and cleanups: Axel Lin, Jingoo Han
  Dan Carpenter, Julia Lawall and Sachin Kamat did an
  excellent job here.

----------------------------------------------------------------
Andy Shevchenko (5):
      pinctrl-baytrail: fix indentations
      pinctrl-baytrail: change lvl to level
      pinctrl-baytrail: remove redundant ptr variable
      pinctrl-baytrail: introduce to_byt_gpio() macro
      pinctrl-baytrail: fix to avoid sparse warnings

Axel Lin (17):
      pinctrl: core: Hold pinctrldev_list_mutex mutex while traversing
pinctrldev_list
      pinctrl: core: Hold pctldev->mutex mutex lock while traversing
gpio_ranges list
      Documentation: pinctrl: Fix example code for pinctrl_register
      pinctrl: core: Remove unnecessary test for desc->name
      pinctrl: SPEAr310: Pass correct of_device_id table name to
MODULE_DEVICE_TABLE
      pinctrl: rockchip: Simplify for loop iteration
      pinctrl: core: Add proper mutex lock in pinctrl_request_gpio
      pinctrl: palmas: PINCTRL_PALMAS needs to select PINMUX
      pinctrl: rockchip: Remove of_match_ptr macro for DT only driver
      pinctrl: spear: Convert to devm_ioremap_resource
      pinctrl: rockchip: Simplify pin_to_bank equation
      pinctrl: tegra: Convert to devm_ioremap_resource
      pinctrl: tz1090: Convert to devm_ioremap_resource
      pinctrl: tz1090-pdc: Convert to devm_ioremap_resource
      pinctrl: rockchip: Implement .request() and .free() callbacks
      pinctrl: pinconf-generic: Remove ti prefix in dev_err messages
      pinctrl: sunxi: Fix off-by-one for valid offset range checking

Barry Song (1):
      pinctrl: sirf: add freeze and restore entries for hibernation support

Boris BREZILLON (2):
      pinctrl: at91: choose appropriate handler for level interrupts
      pinctrl: at91: fix get_pullup/down function return

Dan Carpenter (3):
      pinctrl: abx500: fix bitwise AND test
      pinctrl: mvebu: testing the wrong variable
      pinctrl: s3c24xx: off by one in s3c24xx_eint_init()

Fabio Estevam (1):
      pinctrl: pinctrl-imx: Remove unneeded check for platform_get_resource()

Heiko Stübner (1):
      pinctrl: rockchip: include correct clk header

Jingoo Han (3):
      pinctrl: pinconf: fix comparison of different types
      pinctrl: sirf: add missing __iomem annotation
      pinctrl: sh-pfc: remove unnecessary platform_set_drvdata()

Jisheng Zhang (1):
      pinctrl: mvebu: Convert to use devm_ioremap_resource

Joe Perches (1):
      MAINTAINERS: Update sirf patterns

John Crispin (1):
      pinctrl/lantiq: add missing gphy led setup

Julia Lawall (1):
      pinctrl: nomadik: simplify use of devm_ioremap_resource

Kunihito Higashiyama (1):
      sh-pfc: r8a7790: Add MSIOF pin groups and functions

Laurent Pinchart (34):
      sh-pfc: sh7720: Remove unused input_pu range
      sh-pfc: sh7722: Remove unused input_pd and input_pu ranges
      sh-pfc: sh7723: Remove unused input_pu range
      sh-pfc: sh7724: Remove unused input_pu range
      sh-pfc: sh7757: Remove unused input_pu range
      sh-pfc: sh7785: Remove unused input_pu range
      sh-pfc: sh7786: Remove unused input_pu range
      sh-pfc: shx3: Remove unused input_pu range
      sh-pfc: Remove unused input_pd and input_pu ranges
      sh-pfc: Remove unused PORT_DATA_* macros
      sh-pfc: Remove unused macro and enum entries
      sh-pfc: Remove unneeded const keywords
      sh-pfc: Remove unused GPIO_PORT_ALL macro
      sh-pfc: Don't overallocate memory for the GPIO chip pins array
      sh-pfc: Replace pinmux_enum_id typedef with u16
      sh-pfc: Rename gpio arguments to be consistent with the rest of the code
      sh-pfc: Consolidate PFC SoC data macros
      sh-pfc: Consolidate pin definition macros
      sh-pfc: sh7734: Use the common GP port style macros
      sh-pfc: shx3: Remove shx3_ prefix from static symbols
      sh-pfc: Don't duplicate argument to PINMUX_GPIO macro
      sh-pfc: Add port numbers to the CPU_ALL_PORT macro
      sh-pfc: Pass the pin number down to the port function macro
      sh-pfc: Add pin number to struct sh_pfc_pin
      sh-pfc: Rename struct sh_pfc nr_pins field to nr_gpio_pins
      sh-pfc: Compute pin ranges automatically
      sh-pfc: Support pins not associated with a GPIO port
      sh-pfc: Remove unneeded mach/<soc>.h includes
      sh-pfc: sh7372: Replace <mach/irqs.h> with <linux/sh_intc.h>
      sh-pfc: sh73a0: Remove EXT_IRQ16L and EXT_IRQ16H macros
      sh-pfc: r8a7790: Sort pin groups and functions alphabetically
      sh-pfc: r8a7790: Add SCIF2 pin groups and functions
      sh-pfc: r8a7790: Rename DU1_DOTCLKIN to DU_DOTCLKIN1
      sh-pfc: r8a7790: Add DU pin groups and functions

Laxman Dewangan (6):
      pinctrl: add utility functions for add map/configs
      pinctrl: pinconf-generic: add generic APIs for mapping pinctrl node
      pinctrl: palmas: add pincontrol driver
      pinctrl: utils : add support to pass config type in generic util APIs
      pinctrl: tegra: use pinctrl-utils APIs for mapping
      pinctrl: utils: include export.h to avoid warnings

Linus Walleij (9):
      pinctrl: elaborate a bit on arrangements in doc
      Merge branch 'pinmux/next/pin-no-gpio' of
git://linuxtv.org/pinchartl/fbdev into devel
      Merge branch 'pinmux/next/fixes' of
git://linuxtv.org/pinchartl/fbdev into devel
      pinctrl: nomadik: delete ancient pin control API
      pinctrl: improve warning messages
      pinctrl: nomadik: shut up a warning for flags
      pinctrl: add includes and ifdefs for non-DT builds
      Merge tag 'v3.11-rc7' into devel
      pinctrl: sunxi: drop lock on error path

Mark Brown (1):
      pinctrl: palmas: Fix device name in Kconfig text

Mateusz Krawczuk (1):
      pinctrl: Add s5pv210 support to pinctrl-exynos

Maxime Ripard (3):
      pinctrl: sunxi: Fix inconsistent indentation
      pinctrl: sunxi: Add Allwinner A31 pins set
      pinctrl: sunxi: Add Allwinner A20 pins set

Phil Edworthy (1):
      sh-pfc: r8a7779: Add I2C pin groups

Qipan Li (1):
      pinctrl: sirf: add lost atlas6 uart0-no-stream-control pingroup

Rongjun Ying (1):
      pinctrl: sirf: fix the checkpatch issue about indentation

Russell King - ARM Linux (1):
      pinctrl: shut up a couple of pinctrl warnings

Sachin Kamat (4):
      pinctrl: sunxi: Fix incorrect NULL check
      pinctrl: st: Convert to use devm_ioremap_resource
      pinctrl: st: Staticize local symbols
      Documentation: pinctrl: Fix example code

Sascha Hauer (6):
      pinctrl: imx: make error messages more informative
      pinctrl: imx: Catch no fsl,pins property
      pinctrl: imx: do not fail when parsing a group fails
      pinctrl: imx: do not fail when parsing a function fails
      pinctrl: imx: Use struct type for pins
      pinctrl: imx: Fix compilation with DEBUG enabled

Shawn Guo (1):
      pinctrl: imx: work around select input quirk

Sherman Yin (1):
      pinctrl: Pass all configs to driver on pin_config_set()

Shinobu Uehara (2):
      sh-pfc: r8a7790: Add USB pin groups and functions
      sh-pfc: r8a7790: Add VIN pin groups and functions

Shinya Kuribayashi (9):
      sh-pfc: r8a7790: Rename I2C SDA/SCL pins
      sh-pfc: r8a7790: Remove trailing '_TANS' string from RTS/CTS pins
      sh-pfc: r8a7790: Remove deprecated Ethernet MII/RMII pins
      sh-pfc: r8a7790: Remove deprecated RDS pins
      sh-pfc: r8a7790: Remove deprecated SPV_EVEN pin
      sh-pfc: r8a7790: Swap SCIFA2_RXD_B and HRX0_C configurations
      sh-pfc: r8a7790: Add TCLK1 pin configuration support
      sh-pfc: r8a7790: Add SCIF2 pins configuration support
      sh-pfc: r8a7790: Fix miscellaneous pinmux configuration tables mistakes

Sonic Zhang (1):
      pinctrl: pinmux: Don't free pins requested by other devices in
pinmux_disable_setting.

Stephen Warren (3):
      pinctrl: clean up pinconfig-generic documentation
      pinctrl: add generic pins and functions properties
      gpio: clean up gpio-ranges documentation

Thomas Langer (1):
      pinctrl/lantiq: add missing pin definition to falcon pinctrl driver

Tomasz Figa (1):
      pinctrl: samsung: Parse pin groups before calling pinctrl_register()

Tony Lindgren (1):
      pinctrl: Remove duplicate code in pinctrl_pm_select_state functions

Wolfram Sang (1):
      drivers/pinctrl: don't check resource with devm_ioremap_resource

 Documentation/devicetree/bindings/gpio/gpio.txt    |   55 +-
 .../bindings/pinctrl/pinctrl-bindings.txt          |   41 +-
 .../devicetree/bindings/pinctrl/pinctrl-palmas.txt |   96 +
 .../bindings/pinctrl/samsung-pinctrl.txt           |    3 +-
 Documentation/pinctrl.txt                          |  101 +-
 MAINTAINERS                                        |    2 +-
 arch/arm/boot/dts/atlas6.dtsi                      |    6 +
 drivers/pinctrl/Kconfig                            |   15 +-
 drivers/pinctrl/Makefile                           |    3 +-
 drivers/pinctrl/core.c                             |   71 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c              |   39 +-
 drivers/pinctrl/pinconf-generic.c                  |   96 +
 drivers/pinctrl/pinconf.c                          |   73 +-
 drivers/pinctrl/pinctrl-abx500.c                   |  193 +-
 drivers/pinctrl/pinctrl-at91.c                     |   68 +-
 drivers/pinctrl/pinctrl-baytrail.c                 |   41 +-
 drivers/pinctrl/pinctrl-bcm2835.c                  |   43 +-
 drivers/pinctrl/pinctrl-exynos.c                   |   58 +
 drivers/pinctrl/pinctrl-exynos5440.c               |  113 +-
 drivers/pinctrl/pinctrl-falcon.c                   |   70 +-
 drivers/pinctrl/pinctrl-imx.c                      |  179 +-
 drivers/pinctrl/pinctrl-imx.h                      |   36 +-
 drivers/pinctrl/pinctrl-mxs.c                      |   91 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |  427 +----
 drivers/pinctrl/pinctrl-palmas.c                   | 1095 +++++++++++
 drivers/pinctrl/pinctrl-rockchip.c                 |  102 +-
 drivers/pinctrl/pinctrl-s3c24xx.c                  |    2 +-
 drivers/pinctrl/pinctrl-samsung.c                  |   29 +-
 drivers/pinctrl/pinctrl-samsung.h                  |    1 +
 drivers/pinctrl/pinctrl-single.c                   |   33 +-
 drivers/pinctrl/pinctrl-st.c                       |   27 +-
 drivers/pinctrl/pinctrl-sunxi-pins.h               | 1848 ++++++++++++++++++-
 drivers/pinctrl/pinctrl-sunxi.c                    |   99 +-
 drivers/pinctrl/pinctrl-tegra.c                    |  221 +--
 drivers/pinctrl/pinctrl-tz1090-pdc.c               |  157 +-
 drivers/pinctrl/pinctrl-tz1090.c                   |  162 +-
 drivers/pinctrl/pinctrl-u300.c                     |   21 +-
 drivers/pinctrl/pinctrl-utils.c                    |  142 ++
 drivers/pinctrl/pinctrl-utils.h                    |   43 +
 drivers/pinctrl/pinctrl-xway.c                     |  149 +-
 drivers/pinctrl/pinmux.c                           |   51 +-
 drivers/pinctrl/sh-pfc/core.c                      |  101 +-
 drivers/pinctrl/sh-pfc/core.h                      |   10 +-
 drivers/pinctrl/sh-pfc/gpio.c                      |   45 +-
 drivers/pinctrl/sh-pfc/pfc-r8a73a4.c               |  158 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c               |   48 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |   55 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c               |  168 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c               | 1934 ++++++++++++--------
 drivers/pinctrl/sh-pfc/pfc-sh7203.c                |  202 +-
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |  246 ++-
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                |  285 ++-
 drivers/pinctrl/sh-pfc/pfc-sh7372.c                |   57 +-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |  172 +-
 drivers/pinctrl/sh-pfc/pfc-sh7720.c                |  701 ++++---
 drivers/pinctrl/sh-pfc/pfc-sh7722.c                |  747 ++++----
 drivers/pinctrl/sh-pfc/pfc-sh7723.c                |  381 ++--
 drivers/pinctrl/sh-pfc/pfc-sh7724.c                | 1093 ++++++-----
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |   60 +-
 drivers/pinctrl/sh-pfc/pfc-sh7757.c                |  709 ++++---
 drivers/pinctrl/sh-pfc/pfc-sh7785.c                |  700 ++++---
 drivers/pinctrl/sh-pfc/pfc-sh7786.c                |  383 ++--
 drivers/pinctrl/sh-pfc/pfc-shx3.c                  |  423 ++---
 drivers/pinctrl/sh-pfc/pinctrl.c                   |   91 +-
 drivers/pinctrl/sh-pfc/sh_pfc.h                    |  277 +--
 drivers/pinctrl/sirf/pinctrl-atlas6.c              |    4 +
 drivers/pinctrl/sirf/pinctrl-sirf.c                |   10 +-
 drivers/pinctrl/spear/pinctrl-spear.c              |   13 +-
 drivers/pinctrl/spear/pinctrl-spear310.c           |    2 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c               |   54 +-
 include/linux/mfd/palmas.h                         |   35 +-
 include/linux/pinctrl/pinconf-generic.h            |   33 +
 include/linux/pinctrl/pinconf.h                    |    6 +-
 include/linux/platform_data/pinctrl-nomadik.h      |   24 -
 74 files changed, 9437 insertions(+), 5892 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-palmas.txt
 create mode 100644 drivers/pinctrl/pinctrl-palmas.c
 create mode 100644 drivers/pinctrl/pinctrl-utils.c
 create mode 100644 drivers/pinctrl/pinctrl-utils.h
