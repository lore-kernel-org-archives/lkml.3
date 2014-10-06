Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaJFL6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:58:08 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35952 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaJFL6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:58:03 -0400
MIME-Version: 1.0
Date: Mon, 6 Oct 2014 13:58:01 +0200
Message-ID: <CACRpkdb47TFJX=7kEM-D3+HB1JvBe1y+D10ohTqa5D=brp1dfQ@mail.gmail.com>
Subject: [GIT PULL] bulk pin control changes for v3.18
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the contents of the pin control development tree targeted at
the v3.18 cycle. I think there is a minor conflict in -next, but it's
agains my own GPIO tree, so will have a look at that before sending
that pull request later this merge window.

Details are in the signed tag, please pull it in!

Yours,
Linus Walleij

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.18-1

for you to fetch changes up to 2cdef8f4e1ac28adc81326758a7767c18479a95d:

  pinctrl: specify bindings for pins and groups (2014-10-02 09:41:46 +0200)

----------------------------------------------------------------
This is the bulk of pin control changes for the v3.18
development series:

- New drivers for the Freescale i.MX21, Qualcomm APQ8084
  pin controllers.

- Incremental new features on the Rockchip, atlas 6,
  OMAP, AM437x, APQ8064, prima2, AT91, Tegra, i.MX, Berlin
  and Nomadik.

- Push Freescale drivers down into their own subdirectory.

- Assorted sprays of syntax and semantic fixes.

----------------------------------------------------------------
Alexander Shiyan (1):
      pinctrl: Add i.MX21 pincontrol driver

Antoine Tenart (1):
      pinctrl: berlin: fix the dt_free_map function

Bin Shi (2):
      pinctrl: sirf: fix "quoted string split across lines"
      pinctrl: sirf: fix lots of "line over 80 characters"

Doug Anderson (1):
      pinctrl: Add mux options 3 and 4 for rockchip pinctrl

Geert Uytterhoeven (1):
      pinctrl: generic: Fix PIN_CONFIG_DRIVE_OPEN_SOURCE source/drain
doc mismatch

Georgi Djakov (3):
      pinctrl: qcom: Add APQ8084 pinctrl support
      dt: Document Qualcomm APQ8084 pinctrl binding
      pinctrl: qcom: Make the target processor value configurable

Josh Cartwright (1):
      pinctrl: qcom: use restart_notifier mechanism for ps_hold

Keerthy (1):
      pinctrl: single: AM437x: Add pinctrl compatibility

Kiran Padwal (2):
      pinctrl: Make of_device_id array const
      pinctrl: imx6sl: introduce MODULE_DEVICE_TABLE for module autoloading

Laurent Pinchart (1):
      pinctrl: sh-pfc: sh73a0: Remove unnecessary SoC data allocation

Linus Walleij (13):
      pinctrl: sh-pfc: use a saner Kconfig symbol
      pinctrl: clean up after enable refactoring
      pinctrl: imx/mxs: move freescale drivers to subdir
      pinctrl: sh-pfc: rename confusing pinmux ops variable
      pinctrl: single: fix freudian slip
      pinctrl: nomadik: use util function to reserve maps
      pinctrl: nomadik: use utils map free function
      pinctrl: nomadik: refactor DT parser to take two paths
      pinctrl: alter device tree bindings for functions
      pinctrl: abx500: use helpers for map allocation/free
      pinctrl: abx500: refactor DT parser to take two paths
      pinctrl: nomadik: improve GPIO debug prints
      pinctrl: specify bindings for pins and groups

Marek Roszko (2):
      pinctrl: at91: add drive strength configuration
      pinctrl: at91: update for drive strength options and tweaks

Naveen Krishna Chatradhi (1):
      pinctrl: samsung: use CONFIG_PINCTRL_SAMSUNG symbol in makefile

Nishanth Menon (2):
      pinctrl: bindings: Add OMAP pinctrl binding
      pinctrl: single: Add DRA7 pinctrl compatibility

Pramod Gurav (10):
      pinctrl: qcom: remove gpiochip in failure cases
      pinctrl: msm: Add ps_hold function in pinctrl-apq8064 binding
documentation
      pinctrl: qcom: Add support for reset for apq8064
      pinctrl: sirf: Remove gpiochip on failure cases
      pinctrl: adi2: Remove duplicate gpiochip_remove_pin_ranges
      pinctrl: at91: Switch to using managed clk_get
      pinctrl: lantiq: Release gpiochip resources in fail case
      pinctrl: at91: Fix failure path in at91_gpio_probe path
      pinctrl: at91: Fix error handling while doing gpiochio_irqchip_add
      pinctrl: st: remove gpiochip in failure cases

Rongjun Ying (3):
      pinctrl: atlas6: take mclk pin out of i2s pingroup
      pinctrl: atlas6: Add I2S external clock input pingroup
      pinctrl: prima2: add I2S 2ch, 6ch, nodin, mclk groups

Sean Paul (1):
      pinctrl: tegra: Add MIPI pad control

Stefan Agner (1):
      pinctrl: imx: detect uninitialized pins

Wenyou Yang (1):
      pinctrl: at91: disable PD or PU before enabling PU or PD

 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |   22 +-
 .../bindings/pinctrl/nvidia,tegra124-pinmux.txt    |   14 +-
 .../bindings/pinctrl/pinctrl-bindings.txt          |   50 +-
 .../bindings/pinctrl/qcom,apq8064-pinctrl.txt      |    2 +-
 .../bindings/pinctrl/qcom,apq8084-pinctrl.txt      |  179 +++
 .../bindings/pinctrl/rockchip,pinctrl.txt          |    6 +-
 .../bindings/pinctrl/ti,omap-pinctrl.txt           |   13 +
 Documentation/pinctrl.txt                          |   14 +-
 arch/arm/mach-at91/include/mach/at91_pio.h         |    6 +
 drivers/pinctrl/Kconfig                            |  103 +-
 drivers/pinctrl/Makefile                           |   23 +-
 drivers/pinctrl/berlin/berlin.c                    |   29 +-
 drivers/pinctrl/freescale/Kconfig                  |  108 ++
 drivers/pinctrl/freescale/Makefile                 |   19 +
 drivers/pinctrl/{ => freescale}/pinctrl-imx.c      |   17 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx.h      |    7 +-
 .../pinctrl/{ => freescale}/pinctrl-imx1-core.c    |    8 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx1.c     |    0
 drivers/pinctrl/{ => freescale}/pinctrl-imx1.h     |    0
 drivers/pinctrl/freescale/pinctrl-imx21.c          |  342 ++++++
 drivers/pinctrl/{ => freescale}/pinctrl-imx23.c    |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx25.c    |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx27.c    |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx28.c    |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx35.c    |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx50.c    |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx51.c    |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx53.c    |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx6dl.c   |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx6q.c    |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx6sl.c   |    3 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx6sx.c   |    2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-mxs.c      |    8 +-
 drivers/pinctrl/{ => freescale}/pinctrl-mxs.h      |    0
 drivers/pinctrl/{ => freescale}/pinctrl-vf610.c    |    2 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c              |    6 +-
 drivers/pinctrl/nomadik/pinctrl-abx500.c           |   99 +-
 drivers/pinctrl/nomadik/pinctrl-nomadik.c          |  142 +--
 drivers/pinctrl/pinctrl-adi2.c                     |    7 +-
 drivers/pinctrl/pinctrl-as3722.c                   |    4 +-
 drivers/pinctrl/pinctrl-at91.c                     |  212 +++-
 drivers/pinctrl/pinctrl-bcm281xx.c                 |    8 +-
 drivers/pinctrl/pinctrl-bcm2835.c                  |    4 +-
 drivers/pinctrl/pinctrl-lantiq.c                   |    8 +-
 drivers/pinctrl/pinctrl-palmas.c                   |    5 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |    6 +-
 drivers/pinctrl/pinctrl-single.c                   |   18 +-
 drivers/pinctrl/pinctrl-st.c                       |    7 +-
 drivers/pinctrl/pinctrl-tb10x.c                    |    4 +-
 drivers/pinctrl/pinctrl-tegra-xusb.c               |    8 +-
 drivers/pinctrl/pinctrl-tegra.c                    |    7 +-
 drivers/pinctrl/pinctrl-tegra114.c                 |    2 +-
 drivers/pinctrl/pinctrl-tegra124.c                 |   69 +-
 drivers/pinctrl/pinctrl-tegra20.c                  |    2 +-
 drivers/pinctrl/pinctrl-tegra30.c                  |    2 +-
 drivers/pinctrl/pinctrl-tz1090-pdc.c               |    7 +-
 drivers/pinctrl/pinctrl-tz1090.c                   |    6 +-
 drivers/pinctrl/pinctrl-u300.c                     |    6 +-
 drivers/pinctrl/pinctrl-xway.c                     |    2 +
 drivers/pinctrl/pinmux.c                           |   10 +-
 drivers/pinctrl/qcom/Kconfig                       |    8 +
 drivers/pinctrl/qcom/Makefile                      |    1 +
 drivers/pinctrl/qcom/pinctrl-apq8064.c             |    9 +-
 drivers/pinctrl/qcom/pinctrl-apq8084.c             | 1245 ++++++++++++++++++++
 drivers/pinctrl/qcom/pinctrl-ipq8064.c             |    2 +
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   49 +-
 drivers/pinctrl/qcom/pinctrl-msm.h                 |    3 +
 drivers/pinctrl/qcom/pinctrl-msm8960.c             |    2 +
 drivers/pinctrl/qcom/pinctrl-msm8x74.c             |    2 +
 drivers/pinctrl/samsung/pinctrl-exynos5440.c       |    7 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |    7 +-
 drivers/pinctrl/sh-pfc/core.c                      |   10 +-
 drivers/pinctrl/sh-pfc/core.h                      |    1 -
 drivers/pinctrl/sh-pfc/pfc-r8a73a4.c               |    4 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c               |    4 +-
 drivers/pinctrl/sh-pfc/pfc-sh7372.c                |    4 +-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |   23 +-
 drivers/pinctrl/sh-pfc/pinctrl.c                   |    6 +-
 drivers/pinctrl/sh-pfc/sh_pfc.h                    |    1 -
 drivers/pinctrl/sirf/pinctrl-atlas6.c              |  129 +-
 drivers/pinctrl/sirf/pinctrl-prima2.c              |  173 ++-
 drivers/pinctrl/sirf/pinctrl-sirf.c                |   72 +-
 drivers/pinctrl/spear/pinctrl-spear.c              |    4 +-
 drivers/pinctrl/spear/pinctrl-spear1310.c          |    2 +-
 drivers/pinctrl/spear/pinctrl-spear1340.c          |    2 +-
 drivers/pinctrl/spear/pinctrl-spear300.c           |    2 +-
 drivers/pinctrl/spear/pinctrl-spear310.c           |    2 +-
 drivers/pinctrl/spear/pinctrl-spear320.c           |    2 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |    8 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c               |    8 +-
 include/dt-bindings/pinctrl/at91.h                 |    5 +
 include/dt-bindings/pinctrl/rockchip.h             |    2 +
 include/linux/pinctrl/pinconf-generic.h            |    2 +-
 include/linux/pinctrl/pinmux.h                     |    7 +-
 94 files changed, 2841 insertions(+), 615 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt
 create mode 100644 drivers/pinctrl/freescale/Kconfig
 create mode 100644 drivers/pinctrl/freescale/Makefile
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx.c (97%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx.h (96%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx1-core.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx1.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx1.h (100%)
 create mode 100644 drivers/pinctrl/freescale/pinctrl-imx21.c
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx23.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx25.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx27.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx28.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx35.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx50.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx51.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx53.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx6dl.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx6q.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx6sl.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx6sx.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-mxs.c (98%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-mxs.h (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-vf610.c (99%)
 create mode 100644 drivers/pinctrl/qcom/pinctrl-apq8084.c
