Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaCaHSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:18:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64364 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaCaHSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:18:12 -0400
MIME-Version: 1.0
Date: Mon, 31 Mar 2014 09:18:11 +0200
Message-ID: <CACRpkdbLwRwUVZ+c4A8Y-annM-Q7W6QTJOK0RKLa9F7nLJ7o4Q@mail.gmail.com>
Subject: [GIT PULL] pin control bulk changes for v3.15
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the pin control tree has been pretty stable for some time so here is the
bulk of changes for v3.15. Mainly linear improvements and non-critical
fixes. Some details in the signed tag.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.15-1

for you to fetch changes up to 43f23a0660fa0fdc74c7b1bfc5a209883dbf8153:

  pinctrl: tegra: add some missing Tegra114 entries (2014-03-14 16:32:36 +0100)

----------------------------------------------------------------
Pin control bulk changes for the v3.15 series, no new core
functionality this time, just incremental driver updates:

- A large refactoring of the MVEBU (Marvell) driver.

- A large refactoring of the Tegra (nVidia) driver.

- GPIO interrupt including soft edges support in the
  STi driver.

- Misc updates to PFC (Renesas), AT91, ADI2 (Blackfin),
  pinctrl-single, sirf (CSR), msm (Qualcomm), Exynos (Samsung),
  sunxi (AllWinner), i.MX (Freescale), Baytrail.

----------------------------------------------------------------
Barry Song (1):
      pinctrl: sirf: update copyright years to 2014

Bjorn Andersson (1):
      pinctrl-msm: Support output-{high,low} configuration

Chao Xie (1):
      pinctrl: single: add low power mode support

Chew, Kean Ho (1):
      pinctrl-baytrail: add function mux checking in gpio pin request

Geert Uytterhoeven (5):
      pinctrl: sh-pfc: r8a7791: Add QSPI pin groups
      pinctrl: sh-pfc: r8a7790: Add QSPI pin groups
      ARM: shmobile: r8a7791 dtsi: Fix typo in msiof2 clock output name
      pinctrl: sh-pfc: r8a7790: Add alternative MSIOF pin groups
      pinctrl: sh-pfc: r8a7791: Add alternative MSIOF pin groups

Giuseppe Cavallaro (2):
      pinctrl: st: Enhance the controller to manage unavailable registers
      pinctrl: st: add pinctrl support for the STiH407 SoC

Hans de Goede (1):
      pinctrl-sunxi: Fix sun5i-a13 port F multiplexing

Ivan T. Ivanov (1):
      pinctrl-msm: Add SPI8 pin definitions

Jason Cooper (3):
      Merge tag 'tags/for-mvebu-pinctrl-cleanup' into mvebu/pinctrl
      Merge remote-tracking branch 'shesselba/for-mvebu/pinctrl-dove'
into mvebu/pinctrl
      Merge tag 'tags/for-mvebu-pinctrl-3xx' into mvebu/pinctrl

Jean-Jacques Hiblot (1):
      pinctrl: at91: use gpiolib API to mark a GPIO used as an IRQ

Josh Cartwright (1):
      pinctrl: msm: drop wake_irqs bitmap

Linus Walleij (3):
      Merge tag 'mvebu-pinctrl-3.15' of
git://git.infradead.org/linux-mvebu into pinctrl-mvebu
      Merge branch 'pinctrl-mvebu' into devel
      pinctrl: msm: fix up out-of-order merge conflict

Magnus Damm (1):
      pinctrl: sh-pfc: r8a7790: Break out USB0 OVC/VBUS

Mark Brown (1):
      pinctrl: Quiet logging about missing DT nodes when not using DT

Martin Fuzzey (1):
      pinctrl: imx: Fix pin name in debug message.

Maxime COQUELIN (1):
      pinctrl: st: Use ARRAY_SIZE instead of raw value for number of delays

Richard Genoud (1):
      pinctrl: at91: implement get_direction

Rongjun Ying (1):
      pinctrl: sirf: add pin group for USP0 for atlas6

Sebastian Hesselbarth (22):
      pinctrl: mvebu: count unnamed controls and allocate name buffer
      pinctrl: mvebu: remove obsolete per-control name buffer allocation
      pinctrl: mvebu: identify generic controls by name
      pinctrl: mvebu: remove passing mvebu_mpp_ctrl to callbacks
      pinctrl: mvebu: add common mpp reg helper to mvebu pinctrl include
      pinctrl: mvebu: dove: provide generic mpp callbacks
      pinctrl: mvebu: kirkwood: provide generic mpp callbacks
      pinctrl: mvebu: armada-370: provide generic mpp callbacks
      pinctrl: mvebu: armada-xp: provide generic mpp callbacks
      pinctrl: mvebu: move resource allocation to SoC specific drivers
      pinctrl: mvebu: remove common get/set functions
      pinctrl: mvebu: dove: consolidate auto-numbered pmu mpp ranges
      pinctrl: mvebu: dove: reuse mpp_{set,get} in pmu callbacks
      devicetree: bindings: add missing Marvell Dove SoC documentation
      devicetree: bindings: update MVEBU pinctrl binding documentation
      pinctrl: mvebu: dove: request additional resources
      pinctrl: mvebu: dove: request syscon regmap for global registers
      pinctrl: mvebu: dove: use remapped mpp base registers
      pinctrl: mvebu: dove: use remapped mpp4 register
      pinctrl: mvebu: dove: use remapped pmu_mpp registers
      pinctrl: mvebu: dove: use global register regmap
      pinctrl: mvebu: silence WARN to dev_warn

Sonic Zhang (4):
      pinctrl: Move pint PM storage structure out of blackfin architecture.
      pinctrl-adi2: change irq_base from usigned int to int
      pinctrl-adi2: fix coding style issue
      pinctrl: pinctrl-adi: combine multiple groups of one function together

Srinivas Kandagatla (3):
      pinctrl: st: Add Interrupt support
      pinctrl: st: Add software edge trigger interrupt support
      pinctrl: st: Fix error check for of_irq_to_resource usage

Stephen Boyd (8):
      devicetree: bindings: Make msm8974-pinctrl documentation match code
      pinctrl: msm: Silence recursive lockdep warning
      pinctrl: msm: Check for ngpios > MAX_NR_GPIO
      pinctrl: msm: Drop unused includes
      pinctrl: msm: Drop OF_IRQ dependency
      pinctrl: msm: Replace lookup tables with math
      pinctrl: msm: Remove impossible WARN_ON()s
      pinctrl: msm: Simplify msm_config_reg() and callers

Stephen Warren (6):
      pinctrl: tegra: fix some typos and inconsistencies
      pinctrl: tegra: init Tegra20/30 at module_init time
      pinctrl: tegra: dynamically calculate function list of groups
      pinctrl: tegra: consistency cleanup
      pinctrl: tegra: fix some mistakes in Tegra124
      pinctrl: tegra: add some missing Tegra114 entries

Thomas Petazzoni (3):
      pinctrl: mvebu: remove MPP_REG_CTRL macro
      pinctrl: mvebu: add pin-muxing driver for the Marvell Armada 375
      pinctrl: mvebu: add pin-muxing driver for the Marvell Armada 380/385

Ulf Hansson (2):
      pinctrl: nomadik: Silence compiler warn for !CONFIG_PM
      pinctrl: nomadik: Convert to modern pm_ops

Wolfram Sang (1):
      pinctrl: pfc: r8a7791: add mux data for IIC(B) cores

Young-Gun Jang (1):
      pinctrl: exynos: add exynos5260 SoC specific data

 .../devicetree/bindings/arm/marvell,dove.txt       |   22 +
 .../pinctrl/marvell,armada-370-pinctrl.txt         |    1 +
 .../pinctrl/marvell,armada-375-pinctrl.txt         |   82 ++
 .../pinctrl/marvell,armada-38x-pinctrl.txt         |   80 ++
 .../bindings/pinctrl/marvell,armada-xp-pinctrl.txt |    1 +
 .../bindings/pinctrl/marvell,dove-pinctrl.txt      |    1 +
 .../bindings/pinctrl/marvell,kirkwood-pinctrl.txt  |    1 +
 .../bindings/pinctrl/marvell,mvebu-pinctrl.txt     |    2 +-
 .../devicetree/bindings/pinctrl/pinctrl-single.txt |    7 +
 .../devicetree/bindings/pinctrl/pinctrl-st.txt     |   73 +-
 .../bindings/pinctrl/qcom,msm8974-pinctrl.txt      |   14 +-
 .../bindings/pinctrl/samsung-pinctrl.txt           |    1 +
 arch/arm/boot/dts/r8a7791.dtsi                     |    2 +-
 arch/blackfin/include/asm/irq.h                    |    9 -
 drivers/pinctrl/Kconfig                            |    2 +-
 drivers/pinctrl/devicetree.c                       |    4 +-
 drivers/pinctrl/mvebu/Kconfig                      |    9 +
 drivers/pinctrl/mvebu/Makefile                     |    2 +
 drivers/pinctrl/mvebu/pinctrl-armada-370.c         |   20 +-
 drivers/pinctrl/mvebu/pinctrl-armada-375.c         |  459 +++++++
 drivers/pinctrl/mvebu/pinctrl-armada-38x.c         |  462 +++++++
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c          |   24 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c               |  404 +++---
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c           |   25 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c              |  122 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.h              |   55 +-
 drivers/pinctrl/pinctrl-adi2-bf54x.c               |  138 +--
 drivers/pinctrl/pinctrl-adi2-bf60x.c               |  128 +-
 drivers/pinctrl/pinctrl-adi2.c                     |   31 +-
 drivers/pinctrl/pinctrl-adi2.h                     |    8 +-
 drivers/pinctrl/pinctrl-at91.c                     |   39 +
 drivers/pinctrl/pinctrl-baytrail.c                 |   42 +-
 drivers/pinctrl/pinctrl-exynos.c                   |   82 ++
 drivers/pinctrl/pinctrl-imx.c                      |    2 +-
 drivers/pinctrl/pinctrl-msm.c                      |  113 +-
 drivers/pinctrl/pinctrl-msm.h                      |    5 +-
 drivers/pinctrl/pinctrl-msm8x74.c                  |   14 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |   19 +-
 drivers/pinctrl/pinctrl-samsung.c                  |    2 +
 drivers/pinctrl/pinctrl-samsung.h                  |    1 +
 drivers/pinctrl/pinctrl-single.c                   |    3 +
 drivers/pinctrl/pinctrl-st.c                       |  462 ++++++-
 drivers/pinctrl/pinctrl-sunxi-pins.h               |   12 +-
 drivers/pinctrl/pinctrl-tegra.c                    |   38 +
 drivers/pinctrl/pinctrl-tegra.h                    |    4 +-
 drivers/pinctrl/pinctrl-tegra114.c                 | 1100 ++---------------
 drivers/pinctrl/pinctrl-tegra124.c                 | 1243 ++-----------------
 drivers/pinctrl/pinctrl-tegra20.c                  |  640 +---------
 drivers/pinctrl/pinctrl-tegra30.c                  | 1287 +-------------------
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c               |  171 +++
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               |  596 +++++++++
 drivers/pinctrl/sirf/pinctrl-atlas6.c              |   46 +-
 drivers/pinctrl/sirf/pinctrl-prima2.c              |    3 +-
 drivers/pinctrl/sirf/pinctrl-sirf.c                |    3 +-
 54 files changed, 3439 insertions(+), 4677 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,dove.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/marvell,armada-375-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/marvell,armada-38x-pinctrl.txt
 create mode 100644 drivers/pinctrl/mvebu/pinctrl-armada-375.c
 create mode 100644 drivers/pinctrl/mvebu/pinctrl-armada-38x.c
