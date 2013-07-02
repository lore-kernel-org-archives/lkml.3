Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3GBARa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:17:30 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:52198 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab3GBAR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:17:28 -0400
MIME-Version: 1.0
Date: Tue, 2 Jul 2013 02:17:26 +0200
Message-ID: <CACRpkdbzw=PDrGb9BBfyoTgEtBTrwMbkdMfdZ3DPp5tQ0ryXPQ@mail.gmail.com>
Subject: [GIT PULL] pin control bulk changes for v3.11
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the big pin control pull request for the v3.11 cycle. A lot is going
on as this is now getting ever more accepter with embedded system on
chips. We have new archs using pin control and a batch of beautification.

I've boiled this in -next, the 0day build system and manual test
compilations. Patches touching other subsystems are ACKed.

There may be other trees dependent on this baseline so I better get it
out the door early in the merge window.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.11-1

for you to fetch changes up to 2207a4e1ca6a1bb126360b6d0c236af6664532f2:

  pinctrl: vt8500: wmt: remove redundant dev_err call in
wmt_pinctrl_probe() (2013-06-27 11:51:51 +0200)

----------------------------------------------------------------
Pin control changes for the v3.11 kernel cycle:

- A large slew of improvements of the Genric pin configuration
  support, and deployment in four different platforms:
  Rockchip, Super-H PFC, ABx500 and TZ1090. Support BIAS_BUS_HOLD,
  get device tree parsing and debugfs support into shape.

- We also have device tree support with generic naming conventions
  for the generic pin configuration.

- Delete the unused and confusing direct pinconf API. Now state
  transitions is *the* way to control pins and multiplexing.

- New drivers for Rockchip, TZ1090, and TZ1090 PDC.

- Two pin control states related to power management are now
  handled in the device core: "sleep" and "idle", removing a lot
  of boilerplate code in drivers. We do not yet know if this is
  the final word for pin PM, but it already make things a lot
  easier to handle.

- Handle sparse GPIO ranges passing a list of disparate pins, and
  utilize these in the new BayTrail (x86 Atom SoC) driver.

- Make the sunxi (AllWinner) driver handle external interrupts.

- Make it possible for pinctrl-single to handle the case where
  several pins are managed by a single register, and augment it to
  handle sleep modes.

- Cleanups and improvements for the abx500 drivers.

- Move Sirf pin control drivers to their own directory, support
  save/restore of context and add support for the SiRFatlas6 SoC.

- PMU muxing for the Dove pinctrl driver.

- Finalization and support for VF610 in the i.MX6 pinctrl driver.

- Smoothen out various Exynos rough edges.

- Generic cleanups of various kinds.

----------------------------------------------------------------
Arnd Bergmann (1):
      pinctrl: export pinctrl_pm_select_*_state

Axel Lin (1):
      pinctrl: rockchip: Add missing irq_gc_unlock() call before return error

Barry Song (2):
      pinctrl:sirf:re-arch and add support for new SiRFatlas6 SoC
      pinctrl: sirf: save the status in suspend and restore after resuming

Christian Ruppert (2):
      pinctrl: add pin list based GPIO ranges
      Fix comment on pinctrl_gpio_range.pin_base

Doug Anderson (4):
      pinctrl: exynos: Add spinlocks to irq_mask and irq_unmask
      pinctrl: exynos: reorder xyz_irq_unmask() so future patch can ack
      MAINTAINERS: Add Samsung pinctrl entries
      pinctrl: exynos: ack level-triggered interrupts before unmasking

Fabio Baltieri (1):
      spi: pl022: remove unused ret and pins_state variables

Hebbar Gururaja (1):
      pinctrl: single: adopt pinctrl sleep mode management

Heiko Stübner (11):
      pinctrl: add pinconf-generic define for a pin-default pull
      pinctrl: add function to parse generic pinconfig properties from a dt node
      pinctrl: add pinctrl driver for Rockchip SoCs
      pinctrl: clarify some dt pinconfig options
      pinctrl: handle zero found dt pinconfig properties better
      pinctrl: dynamically alloc temp array when parsing dt pinconf options
      pinctrl: rockchip: correctly handle arguments of pinconf options
      pinctrl: more clarifications for generic pull configs
      pinctrl: set unit for debounce time pinconfig to usec
      pinctrl: remove slew-rate parameter from tz1090
      pinctrl: remove bindings for pinconf options needing more thought

James Hogan (6):
      pinconf-generic: add drive strength to debugfs output
      pinconf-generic: add BIAS_BUS_HOLD pinconf
      Documentation/pinctrl.txt: fix typo "with with"
      pinctrl: fix pinconf_ops::pin_config_dbg_parse_modify kerneldoc
      pinctrl-tz1090: add TZ1090 pinctrl driver
      pinctrl-tz1090-pdc: add TZ1090 PDC pinctrl driver

Jingchang Lu (2):
      pinctrl: imx: add VF610 support to imx pinctrl framework
      pinctrl: add VF610 pinctrl driver

Jingoo Han (4):
      pinctrl: coh901: remove unnecessary platform_set_drvdata()
      pinctrl: mxs: remove unnecessary platform_set_drvdata()
      pinctrl: sirf: remove unnecessary platform_set_drvdata()
      pinctrl: u300: remove unnecessary platform_set_drvdata()

Laurent Navet (1):
      drivers: pinctrl: vt8500: use devm_ioremap_resource()

Laurent Pinchart (4):
      sh-pfc: Remove support for platform data
      sh-pfc: Add DT support
      sh-pfc: Add pinconf support to DT bindings
      sh-pfc: Guard DT parsing with #ifdef CONFIG_OF

Linus Walleij (9):
      pinctrl: sink pinctrldev_list_mutex
      drivers: pinctrl sleep and idle states in the core
      tty: serial: modify PL011 driver to use pinctrl PM helpers
      i2c: nomadik: use pinctrl PM helpers
      spi: pl022: use pinctrl PM helpers
      pinctrl: move the pm state stubs
      pinctrl: update GPIO range doc
      pinctrl: establish pull-up/pull-down terminology
      pinctrl: rip out the direct pinconf API

Manjunathappa, Prakash (2):
      pinctrl: pinctrl-single: enhance to configure multiple pins of
different modules
      pinctrl: pinctrl-single: pin names for pinctrl-single.bits

Mathias Nyman (1):
      pinctrl: add Intel BayTrail GPIO/pinctrl support

Maxime Ripard (5):
      pinctrl: sunxi: Search the description array by pin id
      pinctrl: sunxi: Add external interrupts support
      pinctrl: sunxi: Add external interrupt functions
      pinctrl: sunxi: Move the pins definitions to a separate header
      pinctrl: sunxi: Add Allwinner A10s pins

Mugunthan V N (2):
      drivers: net: cpsw: use pinctrl PM helpers
      drivers: net: davinci_mdio: use pinctrl PM helpers

Patrice Chotard (11):
      pinctrl: abx500: suppress unused mutex
      pinctrl: abx500: fix abx500_config_pull_updown
      pinctrl: abx500: allow to set pull up
      pinctrl: abx500: fix abx500_gpio_dbg_show_one() to show pull up/down
      pinctrl: abx500: fix build warning
      pinctrl: abx500: Add device tree support
      pinctrl: abx500: fix abx500_pin_config_set()
      pinctrl: abx500: fix abx500_gpio_get()
      pinctrl: abx500: factorize code
      pinctrl: abx500: suppress hardcoded value
      pinctrl: abx500: rework error path

Sachin Kamat (5):
      pinctrl: bcm2835: Staticize bcm2835_gpio_pins
      pinctrl: nomadik: Staticize local symbols
      pinctrl: spear/plgpio: Staticize spear310_o2p
      pinctrl: Staticize local symbols
      pinctrl: samsung: Staticize drvdata_list

Sebastian Hesselbarth (1):
      pinctrl: dove: add PMU functions to pinctrl

Shawn Guo (1):
      pinctrl: enable build of pinctrl-imx6sl driver

Thomas Abraham (1):
      pinctrl: exynos5440: fix issues reported by prevent tool

Wei Yongjun (2):
      pinctrl: core: fix missing unlock on error in
pinctrl_find_gpio_range_from_pin()
      pinctrl: vt8500: wmt: remove redundant dev_err call in wmt_pinctrl_probe()

Wolfram Sang (2):
      drivers/pinctrl: don't check resource with devm_ioremap_resource
      drivers/pinctrl/spear: don't check resource with devm_ioremap_resource

 .../bindings/pinctrl/fsl,vf610-pinctrl.txt         |   41 +
 .../bindings/pinctrl/img,tz1090-pdc-pinctrl.txt    |  127 ++
 .../bindings/pinctrl/img,tz1090-pinctrl.txt        |  227 +++
 .../bindings/pinctrl/marvell,dove-pinctrl.txt      |   49 +-
 .../bindings/pinctrl/pinctrl-bindings.txt          |   48 +
 .../devicetree/bindings/pinctrl/pinctrl-single.txt |    3 +-
 .../bindings/pinctrl/renesas,pfc-pinctrl.txt       |  153 ++
 .../bindings/pinctrl/rockchip,pinctrl.txt          |   97 +
 .../devicetree/bindings/pinctrl/ste,abx500.txt     |  352 ++++
 Documentation/pinctrl.txt                          |   39 +-
 MAINTAINERS                                        |   10 +
 drivers/base/pinctrl.c                             |   19 +
 drivers/i2c/busses/i2c-nomadik.c                   |   90 +-
 drivers/net/ethernet/ti/cpsw.c                     |   11 +
 drivers/net/ethernet/ti/davinci_mdio.c             |   10 +
 drivers/pinctrl/Kconfig                            |   38 +
 drivers/pinctrl/Makefile                           |    8 +-
 drivers/pinctrl/core.c                             |  171 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c               |  244 ++-
 drivers/pinctrl/pinconf-generic.c                  |  104 +-
 drivers/pinctrl/pinconf.c                          |  174 --
 drivers/pinctrl/pinconf.h                          |    6 +
 drivers/pinctrl/pinctrl-abx500.c                   |  481 ++++-
 drivers/pinctrl/pinctrl-at91.c                     |    7 +-
 drivers/pinctrl/pinctrl-baytrail.c                 |  543 +++++
 drivers/pinctrl/pinctrl-bcm2835.c                  |    2 +-
 drivers/pinctrl/pinctrl-coh901.c                   |    1 -
 drivers/pinctrl/pinctrl-exynos.c                   |   86 +-
 drivers/pinctrl/pinctrl-exynos5440.c               |   13 +-
 drivers/pinctrl/pinctrl-imx.c                      |   53 +-
 drivers/pinctrl/pinctrl-imx.h                      |    4 +
 drivers/pinctrl/pinctrl-mxs.c                      |    2 -
 drivers/pinctrl/pinctrl-nomadik.c                  |    6 +-
 drivers/pinctrl/pinctrl-rockchip.c                 | 1394 +++++++++++++
 drivers/pinctrl/pinctrl-samsung.c                  |    2 +-
 drivers/pinctrl/pinctrl-single.c                   |  242 ++-
 drivers/pinctrl/pinctrl-sunxi-pins.h               | 2023 +++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.c                    | 1520 ++------------
 drivers/pinctrl/pinctrl-sunxi.h                    |   68 +
 drivers/pinctrl/pinctrl-tz1090-pdc.c               | 1024 ++++++++++
 drivers/pinctrl/pinctrl-tz1090.c                   | 2072 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-u300.c                     |    1 -
 drivers/pinctrl/pinctrl-vf610.c                    |  338 ++++
 drivers/pinctrl/sh-pfc/core.c                      |   65 +-
 drivers/pinctrl/sh-pfc/pinctrl.c                   |  205 ++
 drivers/pinctrl/sirf/Makefile                      |    5 +
 drivers/pinctrl/sirf/pinctrl-atlas6.c              |  947 +++++++++
 .../{pinctrl-sirf.c => sirf/pinctrl-prima2.c}      |  949 +--------
 drivers/pinctrl/sirf/pinctrl-sirf.c                |  929 +++++++++
 drivers/pinctrl/sirf/pinctrl-sirf.h                |  116 ++
 drivers/pinctrl/spear/pinctrl-plgpio.c             |    9 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c               |    8 +-
 drivers/spi/spi-pl022.c                            |   70 +-
 drivers/tty/serial/amba-pl011.c                    |   42 +-
 include/dt-bindings/pinctrl/rockchip.h             |   32 +
 include/linux/pinctrl/consumer.h                   |   77 +-
 include/linux/pinctrl/devinfo.h                    |    4 +
 include/linux/pinctrl/pinconf-generic.h            |   25 +-
 include/linux/pinctrl/pinconf.h                    |    2 +-
 include/linux/pinctrl/pinctrl.h                    |    4 +-
 60 files changed, 12447 insertions(+), 2945 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/pinctrl/fsl,vf610-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/renesas,pfc-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ste,abx500.txt
 create mode 100644 drivers/pinctrl/pinctrl-baytrail.c
 create mode 100644 drivers/pinctrl/pinctrl-rockchip.c
 create mode 100644 drivers/pinctrl/pinctrl-sunxi-pins.h
 create mode 100644 drivers/pinctrl/pinctrl-tz1090-pdc.c
 create mode 100644 drivers/pinctrl/pinctrl-tz1090.c
 create mode 100644 drivers/pinctrl/pinctrl-vf610.c
 create mode 100644 drivers/pinctrl/sirf/Makefile
 create mode 100644 drivers/pinctrl/sirf/pinctrl-atlas6.c
 rename drivers/pinctrl/{pinctrl-sirf.c => sirf/pinctrl-prima2.c} (50%)
 create mode 100644 drivers/pinctrl/sirf/pinctrl-sirf.c
 create mode 100644 drivers/pinctrl/sirf/pinctrl-sirf.h
 create mode 100644 include/dt-bindings/pinctrl/rockchip.h
