Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaFCG6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:58:48 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:46854 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaFCG6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:58:47 -0400
MIME-Version: 1.0
Date: Tue, 3 Jun 2014 08:58:46 +0200
Message-ID: <CACRpkdbk=Qysq5wQfswhw3gm1tocpijrDqxwAjt9OHME5a1ysw@mail.gmail.com>
Subject: [GIT PULL] pin control bulk changes for v3.16
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are the bulk changes for the pin control subsystem for the
v3.16 development cycle. There are some details in the signed
tag as usual.

We have refactoring work from the GPIO subsystem spilling over
but apart from that it is just standard linear development.

Please pull this in for your "next" branch.

Yours,
Linus Walleij

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.16-1

for you to fetch changes up to 29c7f1f53bfb3770bdb65a9e79064a963dd40621:

  pinctrl: sirf: fix a bad conflict resolution (2014-05-30 09:52:43 +0200)

----------------------------------------------------------------
This is the bulk of pin control changes for the v3.16
development cycle:

- Antoine Tenart made the get_group_pins() vtable entry
  optional.

- Antoine also provides an entirely new driver for the
  Marvell Berlin SoC. This is unrelated to the existing
  MVEBU hardware driver and warrants its own separate
  driver.

- Reflected from the GPIO subsystem there is a number of
  refactorings to make pin control drivers with gpiochips
  use the new gpiolib irqchip helpers. The following
  drivers were converted to use the new infrastructure:

  - ST Microelectronics STiH416 and friends

  - The Atmel AT91

  - The CSR SiRF (Prima2)

  - The Qualcomm MSM series

- Massive improvements in the Qualcomm MSM driver from
  Bjorn Andersson, Andy Gross and Kumar Gala. Among those
  new support for the IPQ8064 and MSM8x74 SoC variants.

- Support for the Freescale i.MX6 SoloX SoC variant.

- Massive improvements in the Allwinner sunxi driver from
  Boris Brezillon, Maxime Ripard and Chen-Yu Tsai.

- Renesas PFC updates from Laurent Pinchart, Kuninori
  Morimoto, Wolfram Sang and Magnus Damm.

- Cleanups and refactorings of the nVidia Tegra driver from
  Stepgen Warren.

- The Exynos driver now supports the Exynos3250 SoC.

- Intel BayTrail updates from Jin Yao, Mika Westerberg.

- The MVEBU driver now supports the Orion5x SoC
  variants, which is part of the effort of getting rid of
  the old Marvell kludges in arch/arm/mach-orion5x

- Rockchip driver updates from Heiko Stuebner.

- A ton of cleanups and janitorial patches from Axel Lin.

- Some minor fixes and improvements here and there.

----------------------------------------------------------------
Alexander Stein (3):
      pinctrl/at91: convert driver to use gpiolib irqchip
      pinctrl/at91: Fix mask creation in at91_gpio_dbg_show
      pinctrl/at91: Fix lockup when IRQ on PIOC and PIOD occurs

Andy Gross (4):
      pinctrl: qcom: Add definitions for IPQ8064
      dt: Document Qualcomm IPQ8064 pinctrl binding
      pinctrl: qcom: Correct name for pin 0
      pinctrl: msm: Add more MSM8X74 pin definitions

Anson Huang (1):
      pinctrl: add pinctrl driver for imx6sx

Antoine Tenart (4):
      pinctrl: berlin: add the core pinctrl driver for Marvell Berlin SoCs
      pinctrl: berlin: add the BG2Q pinctrl driver
      pinctrl: berlin: add the BG2 pinctrl driver
      pinctrl: berlin: add the BG2CD pinctrl driver

Antoine Ténart (2):
      pinctrl: allows not to define the get_group_pins operation
      pinctrl: sunxi: fix typo in module author address

Axel Lin (2):
      pinctrl: adi2: Statize adi_gpio_irq_domain_ops
      pinctrl: lantiq: Fix header file include guard

Barry Song (2):
      pinctrl: sirf: wrap all gpio banks into one gpio_chip
      pinctrl: sirf: fix typo for GPIO bank number

Benoit Taine (1):
      pinctrl: pinconf-generic: Use kmemdup instead of kmalloc + memcpy

Bjorn Andersson (4):
      pinctrl: msm: Make number of functions variable
      pinctrl: msm: Add documentation for pinctrl-apq8064 binding
      pinctrl: msm: Add definitions for the APQ8064 platform
      pinctrl: msm: Add missing sdc1 and sdc3 groups

Boris BREZILLON (8):
      pinctrl: sunxi: check clk_prepare_enable return value
      pinctrl: sunxi: disable clk when failing to probe pin controller
      pinctrl: sunxi: add PL and PM pin definitions
      pinctrl: sunxi: support multiple pin controller
      pinctrl: sunxi: define A31 R_PIO pin functions
      pinctrl: sunxi: add reset control support
      ARM: sunxi: update the default ARCH_NR_GPIO for sunxi arch
      pinctrl: sunxi: list all pinctrl compatible strings

Chen-Yu Tsai (2):
      pinctrl: sunxi: fix pin numbers passed to register offset helpers
      pinctrl: sunxi: create irq/pin mapping during init

Fabio Estevam (1):
      pinctrl: pinctrl-imx: Print the mux_mode field in hex format

Heiko Stübner (9):
      pinctrl: rockchip: return a complete config in pinconf_get
      pinctrl: rockchip: implement PIN_CONFIG_OUTPUT handling
      pinctrl: rockchip: do not require 2nd register area
      pinctrl: rockchip: use regmaps instead of raw mappings
      pinctrl: rockchip: rockchip_pinctrl in rockchip_get_bank_data
      pinctrl: rockchip: let pmu registers be supplied by a syscon
      pinctrl: rockchip: only map bank0-pull-region when pmu regmap missing
      pinctrl: rockchip: base regmap supplied by a syscon
      dt-bindings: adapt rockchip-pinctrl doc to changed bindings

Ivan T. Ivanov (1):
      pinctrl: Enable "power-source" to be extracted from DT files

Jin Yao (2):
      pinctrl: baytrail: Add back Baytrail-T ACPI ID
      pinctrl: baytrail: Register GPIO chip after chip->to_irq is set

Jingoo Han (1):
      pinctrl: berlin: Use devm_ioremap_resource()

Kumar Gala (1):
      pinctrl: qcom: ipq8064: Fix naming convention

Kuninori Morimoto (2):
      sh-pfc: r8a7791: Add SSI pin support
      sh-pfc: r8a7791: Add Audio pin support

Laurent Pinchart (2):
      pinctrl: sh-pfc: r8a7791: Split the DU sync and cde/disp groups
      pinctrl: sh-pfc: Don't set the pinmux_irq irq field for multiplatform

Linus Walleij (8):
      pinctrl: st: switch IRQ locking to resource callbacks
      pinctrl: st: use gpiolib irqchip helpers
      pinctrl: sirf: rename inlined accessor
      pinctrl: sirf: switch driver to use gpiolib irqchip helpers
      Merge tag 'sunxi-pinctrl-for-3.16' of
https://github.com/mripard/linux into devel
      pinctrl: msm: switch to using generic GPIO irqchip helpers
      pinctrl: sirf: switch to using allocated state container
      pinctrl: sirf: fix a bad conflict resolution

Magnus Damm (3):
      pinctrl: sh-pfc: r8a7740: Allow Multiplatform Build
      pinctrl: sh-pfc: sh73a0: Allow Multiplatform Build
      pinctrl: sh-pfc: r8a73a4: Allow Multiplatform Build

Maxime COQUELIN (2):
      pinctrl: st: Use const qualifier when required
      pinctrl: st: Use ARRAY_SIZE for STiH415 data

Maxime Ripard (18):
      pinctrl: sunxi: Add const qualifier to the pin descriptor
      pinctrl: sunxi: Drop unused structure members
      pinctrl: sunxi: Move the Allwinner pinctrl driver to its own directory
      pinctrl: sunxi: Replace hardcoded pin defines by a macro
      pinctrl: sunxi: Switch to devm_ioremap_resource
      pinctrl: sunxi: Libraryse the driver
      pinctrl: sunxi: Move Allwinner A10 pinctrl driver to a driver of its own
      pinctrl: sunxi: Move Allwinner A10s pinctrl driver to a driver of its own
      pinctrl: sunxi: Move Allwinner A13 pinctrl driver to a driver of its own
      pinctrl: sunxi: Move Allwinner A31 pinctrl driver to a driver of its own
      pinctrl: sunxi: Move Allwinner A31 special pins driver to a
driver of its own
      pinctrl: sunxi: Move Allwinner A20 pinctrl driver to a driver of its own
      pinctrl: sunxi: Introduce per-driver Kconfig options
      pinctrl: sunxi: Move the reset handling functions out of the core
      pinctrl: sunxi: Enable the pinctrl Kconfig options by default
      pinctrl: sunxi: Fix recursive dependency
      pinctrl: sunxi: Fix multiple registration issue
      pinctrl: sunxi: depend on RESET_CONTROLLER

Mika Westerberg (1):
      pinctrl: baytrail: Add pull type, strength and open drain to
debugfs output

Stephen Warren (5):
      pinctrl: tegra: remove redundant data table fields
      pinctrl: tegra: remove fsafe from data tables
      pinctrl: tegra: reduce size of data table fields
      pinctrl: tegra: print better error messages
      pinctrl: tegra: add missing kerneldoc

Thomas Petazzoni (1):
      pinctrl: mvebu: new driver for Orion platforms

Tomasz Figa (1):
      pinctrl: exynos: Add driver data for Exynos3250

Uwe Kleine-König (1):
      pinctrl: msm8x74: make Kconfig dependency more strict

Wolfram Sang (2):
      pinctrl: pfc: r8a7790: add i2c0 muxing
      pinctrl: pfc: r8a7790: add mux data for IIC(B) cores

 .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |    9 +-
 .../bindings/pinctrl/fsl,imx6sx-pinctrl.txt        |   36 +
 .../bindings/pinctrl/marvell,orion-pinctrl.txt     |   91 +
 .../bindings/pinctrl/pinctrl-bindings.txt          |    1 +
 .../bindings/pinctrl/qcom,apq8064-pinctrl.txt      |   88 +
 .../bindings/pinctrl/qcom,ipq8064-pinctrl.txt      |   95 +
 .../bindings/pinctrl/qcom,msm8974-pinctrl.txt      |   22 +-
 .../bindings/pinctrl/rockchip,pinctrl.txt          |   28 +-
 arch/arm/Kconfig                                   |    2 +-
 drivers/acpi/acpi_lpss.c                           |    1 +
 drivers/pinctrl/Kconfig                            |   39 +-
 drivers/pinctrl/Makefile                           |    6 +-
 drivers/pinctrl/berlin/Kconfig                     |   20 +
 drivers/pinctrl/berlin/Makefile                    |    4 +
 drivers/pinctrl/berlin/berlin-bg2.c                |  274 ++
 drivers/pinctrl/berlin/berlin-bg2cd.c              |  217 ++
 drivers/pinctrl/berlin/berlin-bg2q.c               |  436 +++
 drivers/pinctrl/berlin/berlin.c                    |  348 ++
 drivers/pinctrl/berlin/berlin.h                    |   61 +
 drivers/pinctrl/core.c                             |   17 +-
 drivers/pinctrl/mvebu/Kconfig                      |    4 +
 drivers/pinctrl/mvebu/Makefile                     |    1 +
 drivers/pinctrl/mvebu/pinctrl-orion.c              |  261 ++
 drivers/pinctrl/pinconf-generic.c                  |    4 +-
 drivers/pinctrl/pinctrl-adi2.c                     |    2 +-
 drivers/pinctrl/pinctrl-apq8064.c                  |  613 ++++
 drivers/pinctrl/pinctrl-at91.c                     |  129 +-
 drivers/pinctrl/pinctrl-baytrail.c                 |   68 +-
 drivers/pinctrl/pinctrl-exynos.c                   |   67 +
 drivers/pinctrl/pinctrl-imx.c                      |    2 +-
 drivers/pinctrl/pinctrl-imx6sx.c                   |  407 +++
 drivers/pinctrl/pinctrl-ipq8064.c                  |  653 ++++
 drivers/pinctrl/pinctrl-lantiq.h                   |    1 +
 drivers/pinctrl/pinctrl-msm.c                      |  103 +-
 drivers/pinctrl/pinctrl-msm.h                      |    3 +-
 drivers/pinctrl/pinctrl-msm8x74.c                  |  680 +++-
 drivers/pinctrl/pinctrl-rockchip.c                 |  221 +-
 drivers/pinctrl/pinctrl-samsung.c                  |    2 +
 drivers/pinctrl/pinctrl-samsung.h                  |    1 +
 drivers/pinctrl/pinctrl-st.c                       |  130 +-
 drivers/pinctrl/pinctrl-sunxi-pins.h               | 3863 --------------------
 drivers/pinctrl/pinctrl-sunxi.h                    |  548 ---
 drivers/pinctrl/pinctrl-tegra.c                    |   49 +-
 drivers/pinctrl/pinctrl-tegra.h                    |  133 +-
 drivers/pinctrl/pinctrl-tegra114.c                 |  412 +--
 drivers/pinctrl/pinctrl-tegra124.c                 |  520 ++-
 drivers/pinctrl/pinctrl-tegra20.c                  |  244 +-
 drivers/pinctrl/pinctrl-tegra30.c                  |  551 ++-
 drivers/pinctrl/pinmux.c                           |   23 +-
 drivers/pinctrl/sh-pfc/pfc-r8a73a4.c               |    3 +
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c               |    2 +
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c               |  138 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               |  412 ++-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |    2 +
 drivers/pinctrl/sh-pfc/sh_pfc.h                    |    5 +
 drivers/pinctrl/sirf/pinctrl-sirf.c                |  350 +-
 drivers/pinctrl/sunxi/Kconfig                      |   36 +
 drivers/pinctrl/sunxi/Makefile                     |   10 +
 drivers/pinctrl/sunxi/pinctrl-sun4i-a10.c          | 1039 ++++++
 drivers/pinctrl/sunxi/pinctrl-sun5i-a10s.c         |  690 ++++
 drivers/pinctrl/sunxi/pinctrl-sun5i-a13.c          |  411 +++
 drivers/pinctrl/sunxi/pinctrl-sun6i-a31-r.c        |  141 +
 drivers/pinctrl/sunxi/pinctrl-sun6i-a31.c          |  865 +++++
 drivers/pinctrl/sunxi/pinctrl-sun7i-a20.c          | 1065 ++++++
 drivers/pinctrl/{ => sunxi}/pinctrl-sunxi.c        |  145 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.h              |  258 ++
 66 files changed, 10872 insertions(+), 6190 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/pinctrl/fsl,imx6sx-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/marvell,orion-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt
 create mode 100644 drivers/pinctrl/berlin/Kconfig
 create mode 100644 drivers/pinctrl/berlin/Makefile
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2.c
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2cd.c
 create mode 100644 drivers/pinctrl/berlin/berlin-bg2q.c
 create mode 100644 drivers/pinctrl/berlin/berlin.c
 create mode 100644 drivers/pinctrl/berlin/berlin.h
 create mode 100644 drivers/pinctrl/mvebu/pinctrl-orion.c
 create mode 100644 drivers/pinctrl/pinctrl-apq8064.c
 create mode 100644 drivers/pinctrl/pinctrl-imx6sx.c
 create mode 100644 drivers/pinctrl/pinctrl-ipq8064.c
 delete mode 100644 drivers/pinctrl/pinctrl-sunxi-pins.h
 delete mode 100644 drivers/pinctrl/pinctrl-sunxi.h
 create mode 100644 drivers/pinctrl/sunxi/Kconfig
 create mode 100644 drivers/pinctrl/sunxi/Makefile
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun4i-a10.c
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun5i-a10s.c
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun5i-a13.c
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun6i-a31-r.c
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun6i-a31.c
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun7i-a20.c
 rename drivers/pinctrl/{ => sunxi}/pinctrl-sunxi.c (87%)
 create mode 100644 drivers/pinctrl/sunxi/pinctrl-sunxi.h
