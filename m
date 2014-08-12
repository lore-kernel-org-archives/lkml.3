Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaHLKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:09:59 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63538 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaHLKJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:09:57 -0400
MIME-Version: 1.0
Date: Tue, 12 Aug 2014 12:09:56 +0200
Message-ID: <CAPDyKFps+wjnT2aXiRPKs2mM1tK2KjzCHF_NnMdFyWBCaAfehQ@mail.gmail.com>
Subject: [GIT PULL] MMC for v.3.17
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Me and Chris Ball decided to try out using my MMC tree as the primary
one, to simplify handling of patches.

This PR does thus contains all the MMC patches for 3.17 rc1, no PR
from Chris this time. Please pull them in.

Some more details in the signed tag.

Kind regards
Ulf Hansson


The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.linaro.org/people/ulf.hansson/mmc.git tags/mmc-v3.17-1

for you to fetch changes up to c83c8737e3edb33f60101d2d7692675d0cb6bdf1:

  mmc: dw_mmc: modify the dt-binding for removing slot-node and
supports-highspeed (2014-08-11 11:48:39 +0200)

----------------------------------------------------------------
MMC core:
 - Forward compatibility for eMMC.
 - Fix some blacklisted cards with broken secure discard.

MMC host:
 - mmci: Add support for Qualcomm variant.
 - mmci: Fix regression for arm_variant.
 - sdhci: Various fixes and cleanups.
 - sdhci: Improve external VDD regulator support.
 - sdhci: Support for DDR50 1.8V mode for BayTrail.
 - sdhci-st: Add driver for ST SDHCI controller.
 - sh-mmcif: DMA fixes.
 - omap_hsmmc: Add support for SDIO interrupts.
 - sdhci-pci: Add support for Intel Quark X1000.
 - dw_mmc: Update the reset sequence.
 - s3cmci: port DMA code to dmaengine API.

----------------------------------------------------------------
Alexander Stein (1):
      mmc: quirks: Fixup debug message

Andreas Fenkart (5):
      mmc: omap_hsmmc: Enable SDIO interrupt
      mmc: omap_hsmmc: Extend debugfs by SDIO IRQ handling, runtime state
      mmc: omap_hsmmc: abort runtime suspend if pending sdio irq detected
      mmc: omap_hsmmc: switch default/idle pinctrl states in runtime hooks
      mmc: omap_hsmmc: Pin remux workaround to support SDIO interrupt on AM335x

Axel Lin (2):
      mmc: wmt-sdmmc: Fix settting BM_EIGHTBIT_MODE bit in wmt_mci_set_ios()
      mmc: wmt-sdmmc: Remove deprecated IRQF_DISABLED

Balaji T K (1):
      mmc: omap_hsmmc: enable wakeup event for sdio OMAP4

Ben Dooks (6):
      mmc: sh-mmcif: update to print version and bus clock rate on probe
      mmc: sh-mmcif: use devm_ for ioremap
      mmc: sh-mmcif: use devm_ for clock management
      mmc: sh-mmcif: use devm_ for irq management
      mmc: sh-mmcif: no need to call pm_runtime_suspend on error
      mmc: sh-mmcif: final error path cleanup

Chuanxiao.Dong (1):
      mmc: sdhci-pci: remove PCI PM functions in suspend/resume callback

Derek Browne (1):
      mmc: sdhci-pci: SDIO host controller support for Intel Quark X1000

Geert Uytterhoeven (4):
      mmc: tmio-mmc: Add renesas, sdhi-r8a7791 to binding documentation
      mmc: MMC_OMAP_HS should depend on HAS_DMA
      mmc: MMC_SH_MMCIF should depend on HAS_DMA
      mmc: MMC_USDHI6ROL0 should depend on HAS_DMA

Georgi Djakov (3):
      mmc: sdhci-msm: Fix the binding example
      mmc: sdhci-msm: Remove unnecessary header file inclusion
      mmc: sdhci-msm: Get COMPILE_TEST support

Jaehoon Chung (2):
      mmc: dw_mmc: Slot quirk "disable-wp" is deprecated.
      mmc: dw_mmc: modify the dt-binding for removing slot-node and
supports-highspeed

Johan Rudholm (1):
      mmc: sd: warn if card stays busy during init

Laurent Pinchart (5):
      mmc: sh_mmcif: Document DT bindings
      mmc: sh_mmcif: Fix DMA slave address configuration
      mmc: sh_mmcif: Configure DMA slave bus width
      mmc: tmio: Configure DMA slave bus width
      mmc: sdhci-pxav3: Use devm_* managed helpers

Lukas Czerner (1):
      mmc: Do not advertise secure discard if it is blacklisted

Markus Mayer (1):
      mmc: sdhci: Replace host->mmc with mmc where possible

Markus Pargmann (1):
      mmc: sdhci: Remove unused ret variables

Maurice Petallo (2):
      mmc: sdhci: Preset value not supported in Baytrail eMMC
      mmc: sdhci: add DDR50 1.8V mode support for BayTrail eMMC Controller

Peter Griffin (3):
      mmc: core: Fix DT documentation of eMMC high-speed DDR 1.8/1.2V bindings
      mmc: sdhci-st: Intial support for ST SDHCI controller
      mmc: sdhci-st: ST Microelectronics SDHCI binding documentation.

Romain Izard (1):
      mmc: Allow forward compatibility for eMMC

Roman Peniaev (1):
      mmc: mxs: fix card detection in case of 'broken-cd' flag set

Russell King (1):
      mmc: sdhci: avoid double-delay while transitioning to 1.8V

Sachin Kamat (1):
      mmc: moxart: Remove unneeded version.h inclusion

Sonny Rao (1):
      mmc: dw_mmc: change to use recommended reset procedure

Srinivas Kandagatla (12):
      mmc: mmci: use NSEC_PER_SEC macro
      mmc: mmci: Add Qualcomm specific register defines.
      mmc: mmci: Add enough delay between writes to CMD register.
      mmc: mmci: Add Qcom datactrl register variant
      mmc: mmci: add ddrmode mask to variant data
      mmc: mmci: add 8bit bus support in variant data
      mmc: mmci: add edge support to data and command out in variant data.
      mmc: mmci: Add support to data commands via variant structure.
      mmc: mmci: add f_max to variant structure
      mmc: mmci: add explicit clk control
      mmc: mmci: Add Qcom specific rx_fifocnt logic.
      mmc: mmci: Add Qualcomm Id to amba id table

Thierry Reding (1):
      mmc: tegra: Do not include asm/gpio.h

Tim Kryger (2):
      mmc: sdhci: Use mmc core regulator infrastucture
      mmc: sdhci: Improve external VDD regulator support

Ulf Hansson (5):
      mmc: core: Remove redundant runtime_idle callback
      mmc: sdhci: Remove blank line
      mmc: mmci: Remove redundant check of status for DATA irq
      mmc: mmci: Move all CMD irq handling to mmci_cmd_irq()
      mmc: mmci: Reverse IRQ handling for the arm_variant

Vasily Khoruzhick (2):
      mmc: s3cmci: Move to clk_prepare_enable/clk_disable_unprepare
      mmc: s3cmci: port DMA code to dmaengine API

 .../devicetree/bindings/mmc/exynos-dw-mshc.txt     |  17 +-
 .../devicetree/bindings/mmc/k3-dw-mshc.txt         |  12 +-
 Documentation/devicetree/bindings/mmc/mmc.txt      |   4 +-
 .../devicetree/bindings/mmc/renesas,mmcif.txt      |  32 +++
 .../devicetree/bindings/mmc/sdhci-msm.txt          |   8 +-
 Documentation/devicetree/bindings/mmc/sdhci-st.txt |  33 +++
 .../devicetree/bindings/mmc/synopsys-dw-mshc.txt   |  12 +-
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |  54 ++++
 Documentation/devicetree/bindings/mmc/tmio_mmc.txt |   1 +
 drivers/mmc/card/block.c                           |   6 +-
 drivers/mmc/core/bus.c                             |  10 +-
 drivers/mmc/core/core.c                            |   3 +-
 drivers/mmc/core/mmc.c                             |  11 +-
 drivers/mmc/core/quirks.c                          |   2 +-
 drivers/mmc/core/sd_ops.c                          |   3 +
 drivers/mmc/host/Kconfig                           |  28 +-
 drivers/mmc/host/Makefile                          |   1 +
 drivers/mmc/host/dw_mmc.c                          |  98 +++++--
 drivers/mmc/host/dw_mmc.h                          |   5 +
 drivers/mmc/host/mmci.c                            | 168 ++++++++++--
 drivers/mmc/host/mmci.h                            |  20 ++
 drivers/mmc/host/moxart-mmc.c                      |   1 -
 drivers/mmc/host/mxs-mmc.c                         |   3 +-
 drivers/mmc/host/omap_hsmmc.c                      | 283 +++++++++++++++++++--
 drivers/mmc/host/s3cmci.c                          | 186 ++++----------
 drivers/mmc/host/s3cmci.h                          |   4 +-
 drivers/mmc/host/sdhci-acpi.c                      |   4 +-
 drivers/mmc/host/sdhci-msm.c                       |   1 -
 drivers/mmc/host/sdhci-pci.c                       |  38 +--
 drivers/mmc/host/sdhci-pci.h                       |   1 +
 drivers/mmc/host/sdhci-pxav3.c                     |  13 +-
 drivers/mmc/host/sdhci-st.c                        | 176 +++++++++++++
 drivers/mmc/host/sdhci-tegra.c                     |   2 -
 drivers/mmc/host/sdhci.c                           | 144 +++++------
 drivers/mmc/host/sh_mmcif.c                        |  96 +++----
 drivers/mmc/host/tmio_mmc_dma.c                    |   2 +
 drivers/mmc/host/wmt-sdmmc.c                       |  33 ++-
 include/linux/mmc/dw_mmc.h                         |   2 +
 include/linux/mmc/sdhci.h                          |   3 -
 include/linux/platform_data/mmc-omap.h             |   1 +
 40 files changed, 1050 insertions(+), 471 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/renesas,mmcif.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-st.txt
 create mode 100644 drivers/mmc/host/sdhci-st.c
