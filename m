Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaAUMzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:55:06 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:49739 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaAUMzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:55:01 -0500
MIME-Version: 1.0
Date: Tue, 21 Jan 2014 13:55:00 +0100
Message-ID: <CACRpkda0fbiU_QRMqJ_KjwWyLqCG-RhrQT=ytEwmrb_gfaF5LQ@mail.gmail.com>
Subject: [GIT PULL] bulk pin control changes for v3.14
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the bulk of pin control changes for v3.14. This has been queued
and tested for a while. Lots of action here, like in the GPIO tree,
embedded stuff like this is really hot now it seems. Details in the
signed tag. I'm especially happy about the Qualcomm driver as it is
used in such a huge subset of mobile handsets out there, and these
platforms in general need better upstream support.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.14-1

for you to fetch changes up to fa8cf57c923e86a693a85aff1df579245a27cbb3:

  pinctrl: sunxi: Honor GPIO output initial vaules (2014-01-20 09:19:17 +0100)

----------------------------------------------------------------
Bulk pin control changes for the v3.14 cycle:

- New driver for the Qualcomm TLMM pin controller and its
  msm8x74 subdriver.

- New driver for the Broadcom Capri BCM281xx SoC.

- New subdriver for the imx25 pin controller.

- New subdriver for the Tegra124 pin controller.

- Lock GPIO lines as IRQs for select combined pin control and
  GPIO drivers for baytrail and sirf.

- Some semi-big refactorings and extenstions to the sirf
  driver.

- Lots of patching, cleanup and fixing in the Renesas "PFC"
  driver and associated subdrivers as usual. It is settling
  down a little bit now it seems.

- Minor fixes and incremental updates here and there as usual.

----------------------------------------------------------------
Alexandre Belloni (5):
      pinctrl: at91: correct a few typos
      pinctrl: at91: initialize config parameter to 0
      pinctrl: pinconf: remove checks on ops->pin_config_get
      pinctrl: at91: implement at91_pinconf_dbg_show
      pinctrl: pinconf: remove warning: unused variable 'ops'

Antonios Vamporakis (1):
      pinctrl/lantiq: fix typo

Ashwini Ghuge (1):
      pinctrl: tegra: add pinmux controller driver for Tegra124

Axel Lin (1):
      pinctrl: msm: Fix set gpio setting

Barry Song (2):
      pinctrl: sirf: use only one irq_domain for the whole device node
      pinctrl: sirf: put gpio interrupt pin into input status automatically

Bin Shi (1):
      pinctrl: sirf: fix the pins of sdmmc5 connected with TriG

Bjorn Andersson (8):
      pinctrl: Add Qualcomm TLMM driver
      pinctrl: Add msm8x74 configuration
      pinctrl: Add documentation for pinctrl-msm8x74
      pinctrl: msm: Update Kconfig for PINCTRL_MSM8X74
      pinctrl-msm: Fix spelling misstakes and missing consts
      pinctrl-msm: Tidy up error handling
      pinctrl-msm: Remove separate allocation of bitmaps
      pinctrl-msm: Rename compatible to be more specific

Boris BREZILLON (2):
      pinctrl: at91: fix clk_unprepare and clk_disable order
      pinctrl: at91: replace clk_prepare + clk_enable by clk_prepare_enable

Chen-Yu Tsai (2):
      pinctrl: sunxi: Add Allwinner A20 clock output pin functions
      pinctrl: sunxi: Honor GPIO output initial vaules

Denis Carikli (1):
      pinctrl: pinctrl-imx: add imx25 pinctrl driver

Kuninori Morimoto (2):
      sh-pfc: r8a7790: Add SSI pin support
      sh-pfc: r8a7790: Add Audio pin support

Laszlo Papp (1):
      pinctrl: Fix some typos and grammar issues in the documentation

Laurent Pinchart (12):
      sh-pfc: r8a7791: Fix DU pin groups organisation
      sh-pfc: Share common PORTCR macro definition
      sh-pfc: Turn unsigned indices into unsigned int
      sh-pfc: Terminate gpios array by -1
      sh-pfc: sh73a0: Add missing IRQ15
      sh-pfc: sh73a0: Sort IRQ entries by IRQ number
      sh-pfc: Rename sh_pfc window field to windows
      sh-pfc: Support GPIO to IRQ mapping specified IRQ resources
      pinctrl: sh-pfc: Constify enum_ids and var_field_width compound literals
      pinctrl: sh-pfc: Constify IRQ GPIOs arrays
      pinctrl: sh-pfc: sh: Constify pins and cfg_regs arrays
      pinctrl: sh-pfc: ARM: Constify pins and cfg_regs arrays

Laxman Dewangan (1):
      pinctrl: tegra: Add devicetree binding document for Tegra124

Linus Walleij (8):
      pinctrl: nomadik: always display IRQ in debugfs
      pinctrl: provide documentation pointer
      pinctrl: baytrail: lock IRQs when starting them
      pinctrl: make the MSM SoC driver depend on OF
      pinctrl: make the MSM SoC driver depend on OF
      Merge branch 'pinmux/next/pfc' of
git://linuxtv.org/pinchartl/fbdev into devel
      pinctrl: sirf: lock IRQs when starting them
      pinctrl: capri: add dependency on OF

Mallikarjun Kasoju (1):
      pinctrl: as3722: Set pin to output mode for some function

Markus Pargmann (1):
      pinctrl: imx1-core populate subdevices

Mathias Nyman (1):
      pinctrl-baytrail: show pin label with the reset of the gpio debug data

Qipan Li (1):
      pinctrl: sirf: add lost usp1_uart_nostreamctrl group for atlas6

Rongjun Ying (1):
      pinctrl: sirf: add pin group for USP0 with only RX or TX frame sync

Shawn Guo (1):
      pinctrl: imx: drop redundant OF dependency

Sherman Yin (5):
      pinctrl: Adds slew-rate, input-enable/disable
      pinctrl: Add void * to pinctrl_pin_desc
      pinctrl: Add pinctrl binding for Broadcom Capri SoCs
      ARM: pinctrl: Add Broadcom Capri pinctrl driver
      ARM: bcm11351: Enable pinctrl for Broadcom Capri SoCs

Srinivas Kandagatla (1):
      pinctrl: st: Fix a typo in probe

Takashi Yoshii (1):
      sh-pfc: r8a7791: Fix msiof groups to follow GROUP

Tomi Valkeinen (3):
      pinctrl: single: fix DT bindings documentation
      pinctrl: single: fix pcs_disable with bits_per_mux
      pinctrl: single: fix infinite loop caused by bad mask

Valentine Barshak (9):
      pinctrl: sh-pfc: pfc-r8a7790: Rename VIN pin groups
      pinctrl: sh-pfc: pfc-r8a7790: Group VIN0 HSYNC and VSYNC together
      pinctrl: sh-pfc: pfc-r8a7790: Reorganize VIN0 data pins
      pinctrl: sh-pfc: pfc-r8a7790: Add missing VIN1 pins
      pinctrl: sh-pfc: pfc-r8a7790: Add VIN2 and VIN3 pins
      pinctrl: sh-pfc: r8a7790: Fix vsync value in the vin3_sync_mux array
      pinctrl: sh-pfc: r8a7791: Group USB PWEN and OVC pins together
      pinctrl: sh-pfc: r8a7791: Add VIN pins
      pinctrl: sh-pfc: r8a7791: Add I2C pins

 .../bindings/pinctrl/brcm,capri-pinctrl.txt        |  461 +++
 .../bindings/pinctrl/fsl,imx25-pinctrl.txt         |   23 +
 .../bindings/pinctrl/fsl,imx27-pinctrl.txt         |   22 +
 .../bindings/pinctrl/nvidia,tegra124-pinmux.txt    |  144 +
 .../bindings/pinctrl/pinctrl-bindings.txt          |    3 +
 .../devicetree/bindings/pinctrl/pinctrl-single.txt |    2 +-
 .../bindings/pinctrl/qcom,msm8974-pinctrl.txt      |   92 +
 .../bindings/pinctrl/renesas,pfc-pinctrl.txt       |   14 +
 Documentation/pinctrl.txt                          |   43 +-
 arch/arm/boot/dts/bcm11351.dtsi                    |    4 +
 arch/arm/configs/bcm_defconfig                     |    1 +
 arch/arm/mach-bcm/Kconfig                          |    1 +
 drivers/pinctrl/Kconfig                            |   48 +-
 drivers/pinctrl/Makefile                           |    5 +
 drivers/pinctrl/pinconf-generic.c                  |    4 +
 drivers/pinctrl/pinconf.c                          |   22 +-
 drivers/pinctrl/pinctrl-as3722.c                   |   20 +
 drivers/pinctrl/pinctrl-at91.c                     |   48 +-
 drivers/pinctrl/pinctrl-baytrail.c                 |   30 +-
 drivers/pinctrl/pinctrl-capri.c                    | 1454 +++++++++
 drivers/pinctrl/pinctrl-imx1-core.c                |    7 +
 drivers/pinctrl/pinctrl-imx25.c                    |  351 +++
 drivers/pinctrl/pinctrl-msm.c                      |  990 ++++++
 drivers/pinctrl/pinctrl-msm.h                      |  122 +
 drivers/pinctrl/pinctrl-msm8x74.c                  |  636 ++++
 drivers/pinctrl/pinctrl-nomadik.c                  |    6 +-
 drivers/pinctrl/pinctrl-single.c                   |   18 +-
 drivers/pinctrl/pinctrl-st.c                       |    8 +-
 drivers/pinctrl/pinctrl-sunxi-pins.h               |    2 +
 drivers/pinctrl/pinctrl-sunxi.c                    |   13 +-
 drivers/pinctrl/pinctrl-tegra124.c                 | 3137 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-xway.c                     |    4 +-
 drivers/pinctrl/sh-pfc/core.c                      |   76 +-
 drivers/pinctrl/sh-pfc/core.h                      |    4 +-
 drivers/pinctrl/sh-pfc/gpio.c                      |   24 +-
 drivers/pinctrl/sh-pfc/pfc-r8a73a4.c               |   17 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c               |   15 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c               |    4 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c               |    2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c               |  752 ++++-
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               |  655 +++-
 drivers/pinctrl/sh-pfc/pfc-sh7203.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7372.c                |   15 +-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |   66 +-
 drivers/pinctrl/sh-pfc/pfc-sh7720.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7722.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7723.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7724.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7757.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7785.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-sh7786.c                |    2 +-
 drivers/pinctrl/sh-pfc/pfc-shx3.c                  |    2 +-
 drivers/pinctrl/sh-pfc/sh_pfc.h                    |   16 +-
 drivers/pinctrl/sirf/pinctrl-atlas6.c              |   24 +
 drivers/pinctrl/sirf/pinctrl-prima2.c              |   48 +-
 drivers/pinctrl/sirf/pinctrl-sirf.c                |   51 +-
 include/linux/mfd/as3722.h                         |    1 +
 include/linux/pinctrl/pinconf-generic.h            |   10 +-
 include/linux/pinctrl/pinctrl.h                    |    2 +
 62 files changed, 9208 insertions(+), 333 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/fsl,imx25-pinctrl.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-capri.c
 create mode 100644 drivers/pinctrl/pinctrl-imx25.c
 create mode 100644 drivers/pinctrl/pinctrl-msm.c
 create mode 100644 drivers/pinctrl/pinctrl-msm.h
 create mode 100644 drivers/pinctrl/pinctrl-msm8x74.c
 create mode 100644 drivers/pinctrl/pinctrl-tegra124.c
