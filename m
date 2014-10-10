Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaJJH5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:57:16 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:40326 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaJJH5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:57:13 -0400
MIME-Version: 1.0
Date: Fri, 10 Oct 2014 09:57:12 +0200
Message-ID: <CAPDyKFopoC2RPi5BNtHhrVSZ0w82HY2+EHw-4hNy1_o_9YZX2Q@mail.gmail.com>
Subject: [GIT PULL] MMC for v.3.18
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the PR for MMC for v3.18.

I believe you will hit a conflict, which also appeared in linux-next,
for the below patch:
"ARM: dts: fix MMC2 regulators for Exynos5420 Arndale Octa board".
It should be trivial to resolve, but I am happy to help if needed.

Details about the MMC highlights are found in the signed tag. Please
pull this in!

Kind regards
Ulf Hansson


The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.linaro.org/people/ulf.hansson/mmc.git tags/mmc-v3.18-1

for you to fetch changes up to 583f958b8a23343c904ec0790c25c96f5f82d409:

  ARM: dts: fix MMC2 regulators for Exynos5420 Arndale Octa board
(2014-10-09 10:48:58 +0200)

----------------------------------------------------------------
MMC core:
 - Fix SDIO IRQ bug.
 - MMC regulator improvements.
 - Fix slot-gpio card detect bug.
 - Add support for Driver Stage Register.
 - Convert the common MMC OF parser to use GPIO descriptors.
 - Convert MMC_CAP2_NO_MULTI_READ into a callback, ->multi_io_quirk().
 - Some additional minor fixes.

MMC host:
 - mmci: Support Qualcomm specific DML layer for DMA.
 - dw_mmc: Use common MMC regulators.
 - dw_mmc: Add support for Rock-chips RK3288.
 - tmio: Enable runtime PM support.
 - tmio: Add support for R-Car Gen2 SoCs.
 - tmio: Several fixes and improvements.
 - omap_hsmmc: Removed Balaji from MAINTAINERS.
 - jz4740: add DMA and pre/post support.
 - sdhci: Add support for Intel Braswell.
 - sdhci: Several fixes and improvements.

----------------------------------------------------------------
Addy Ke (1):
      mmc: dw_mmc: add support for RK3288

Adrian Hunter (12):
      mmc: Fix use of wrong device in mmc_gpiod_free_cd()
      mmc: Fix incorrect warning when setting 0 Hz via debugfs
      mmc: sdhci: Add quirk for always getting TC with stop cmd
      mmc: sdhci-acpi: Set SDHCI_QUIRK2_STOP_WITH_TC for Intel host controllers
      mmc: sdhci-acpi: Add a HID and UID for a SD Card host controller
      mmc: sdhci-pci: Set SDHCI_QUIRK2_STOP_WITH_TC for Intel BYT host
controllers
      mmc: sdhci-pci: Add Bay Trail and Braswell SD card detect
      mmc: sdhci: Let a driver override timeout clock frequency
      mmc: sdhci-pci: Fix Braswell eMMC timeout clock frequency
      mmc: sdhci-acpi: Get UID directly from acpi_device
      mmc: sdhci-acpi: Pass HID and UID to probe_slot
      mmc: sdhci-acpi: Fix Braswell eMMC timeout clock frequency

Aisheng Dong (6):
      mmc: sdhci: add platform get_max_timeout_count hook
      mmc: sdhci-esdhc-imx: fix incorrect max timeout cout for uSDHC
      mmc: sdhci: add platform set_timeout hook
      mmc: sdhci-esdhc-imx: set the correct max timeout value for uSDHC
      mmc: sdhci: calculate timeout_clk conditionally in sdhci_add_host
      mmc: sdhci: move timeout_clk dynamically calculation code into common code

Alan Cox (1):
      mmc: sdhci: Add PCI IDs for Intel Braswell

Andrew Bresticker (2):
      mmc: dw_mmc: Add dependency on DMA
      mmc: dw_mmc: Add support for MIPS

Apelete Seketeli (2):
      mmc: jz4740: add dma infrastructure for data transfers
      mmc: jz4740: prepare next dma transfer in parallel with current transfer

Arnd Bergmann (1):
      mmc: atmel-mci: fix mismatched section on atmci_cleanup_slot

Balaji T K (1):
      MAINTAINERS: omap_hsmmc: remove myself from MAINTAINERS

Bartlomiej Zolnierkiewicz (2):
      mmc: sdhci-s3c: fix runtime PM handling on sdhci_add_host() failure
      ARM: dts: fix MMC2 regulators for Exynos5420 Arndale Octa board

Behan Webster (1):
      mmc, sdhci, bcm-kona, LLVMLinux: Remove use of __initconst

Chanho Min (1):
      mmc: sdhci: handle busy-end interrupt during command

Chen-Yu Tsai (1):
      mmc: sunxi: Declare ERASE capability

Chuanxiao Dong (1):
      mmc: core: resolve divded by zero panic

Chuanxiao.Dong (3):
      mmc: sdhci: fix the wrong type of curr
      mmc: core: Fix sequence for I/O voltage in DDR mode for eMMC
      mmc: sdhci: check 1.2v IO capability for SDHC host

Doug Anderson (3):
      mmc: dw_mmc: Make sure we don't get stuck when we get an error
      mmc: dw_mmc: Support voltage changes
      mmc: dw_mmc: Pass back errors from mmc_of_parse()

Fabio Estevam (1):
      sdhci: Make sdhci_disable_irq_wakeups() static

Fu Zhonghui (1):
      mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread

Gao, Yunpeng (3):
      mmc: sdhci-pci: enable runtime pm for Intel Merrifield platform
      mmc: sdhci-acpi: add probe_slot method for emmc/sd/sdio
      mmc: sdhci-pci: disable preset register for Baytrail and Merrifield

Geert Uytterhoeven (1):
      mmc: tmio-mmc: Add support for SDHI on new R-Car Gen2 SoCs

Grégory Soutadé (3):
      mmc: Move code that manages user area and gp partitions into functions
      mmc: Replace "enhanced_area_en" attribute by "partition_setting_completed"
      mmc: Checks EXT_CSD_PARTITION_SETTING_COMPLETED before
partitions computation

Hans-Christian Egtvedt (1):
      mmc: include linux/types.h for bool definition in atmel-mci.h

Javier Martinez Canillas (1):
      mmc: core: Use regulator_get_voltage() if OCR mask is empty.

Joe Perches (1):
      mmc: Convert pr_warning to pr_warn

Johan Rudholm (1):
      mmc: block: change stop errors to info

Kuninori Morimoto (11):
      mmc: tmio: care about DMA tx/rx addr offset
      mmc: tmio: remove Renesas specific #ifdef
      mmc: tmio: remove SCLKEN bit setting from tmio_mmc_set_clock()
      mmc: Add .multi_io_quirk callback for multi I/O HW bug
      mmc: use .multi_io_quirk on omap_hsmmc
      mmc: use .multi_io_quirk on tmio_mmc
      mmc: use .multi_io_quirk on sh_mobile
      ARM: shmobile: remove MMC_CAP2_NO_MULTI_READ from koelsch
      ARM: shmobile: remove MMC_CAP2_NO_MULTI_READ from lager
      mmc: remove MMC_CAP2_NO_MULTI_READ flags
      mmc: tmio: enable odd number size access

Linus Walleij (5):
      mmc: slot-gpio: switch to use flags when getting GPIO
      mmc: slot-gpio: add gpiod variant to get wp GPIO
      mmc: host: switch OF parser to use gpio descriptors
      mmc: mmci: augment driver to handle gpio descriptors
      mmc: core: restore detect line inversion semantics

Matthieu CASTET (2):
      sdhci : handle busy timeout irq
      sdhci : recompute timeout_clk when needed

Minda Chen (1):
      mmc: sdhci-sirf: fix 8bit width enable by overwriting set_bus_width

Nicolas Ferre (1):
      mmc: atmel-mci: add 0x600 IP version

Pawel Moll (1):
      mmc: sdhci-pltfm: Do not use parent as the host's device

Peter Griffin (6):
      mmc: remove .owner field for drivers using module_platform_driver
      mmc: dw_mmc-pci: Remove superflous #else condition on CONFIG_PM_SLEEP
      mmc: dw_mmc-pltfm: Remove superflous #else condition on CONFIG_PM_SLEEP
      mmc: sdhci-pci: Use SET_RUNTIME_PM_OPS macro to set runtime pm callbacks
      mmc: sdhci-acpi.c: Use SET_RUNTIME_PM_OPS macro to set runtime
pm callbacks
      mmc: sdhci-pxav3: set_uhs_signaling is initialized twice differently

Pramod Gurav (2):
      mmc: atmel-mci: Switch to using managed resource in probe
      mmc: atmel-mci: Release mmc resources on failure in probe

Robert Jarzmik (1):
      mmc: pxamci: prepare and unprepare the clocks

Roger Tseng (4):
      mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response
      mmc: rtsx_usb_sdmmc: fix incorrect last byte in R2 response
      mmc: core: Add new power_mode MMC_POWER_UNDEFINED
      mmc: rtsx_pci: Set power related cap2 macros

Sascha Hauer (1):
      mmc: implement Driver Stage Register handling

Sergei Shtylyov (1):
      mmc: tmio: prevent endless loop in tmio_mmc_set_clock()

Shinobu Uehara (5):
      mmc: tmio: clear error IRQ status
      mmc: tmio: control multiple block transfer mode
      mmc: tmio: add TMIO_MMC_SDIO_STATUS_QUIRK
      mmc: tmio: check ILL_FUNC instead of CBSY
      mmc: tmio: add actual clock support as option

Srinivas Kandagatla (3):
      mmc: mmci: Add qcom dml support to the driver.
      mmc: mmci: Add sdio enable mask in variant data
      mmc: mmci: rename sdio flag in vendor data to st_sdio

Stephen Boyd (2):
      mmc: sdhci-msm: Make tuning block table endian agnostic
      mmc: Consolidate emmc tuning blocks

Stephen Warren (1):
      mmc: don't request CD IRQ until mmc_start_host()

Tim Kryger (1):
      mmc: core: Remove fixed voltage regulator logic

Tobias Klauser (1):
      mmc: dw_mmc: Remove unused function for !CONFIG_OF

Ulf Hansson (13):
      mmc: tmio: Keep host active while SDIO IRQ is enabled
      mmc: tmio: Keep host active while serving requests
      mmc: tmio: Extract bus_width modifications to a separate function
      mmc: tmio: Restructure ->set_ios() and adapt ->probe() to it
      mmc: tmio: Handle clock gating from runtime PM functions
      mmc: tmio: Mask all IRQs when inactive
      mmc: tmio: Make runtime PM callbacks available for CONFIG_PM
      mmc: sdhi: Make runtime PM callbacks available for CONFIG_PM
      mmc: tmio_mmc: Enable runtime PM support
      mmc: sdhi: Fixup system PM suspend lock-up
      mmc: tmio_mmc: Fixup system PM suspend lock-up
      mmc: tmio: Remove library functions for system PM
      mmc: card: Prevent partition scan for the eMMC boot areas

Wei Yongjun (1):
      mmc: au1xmmc: fix error return code in au1xmmc_probe()

Xiang Wang (1):
      mmc: sdhci-pxav3: fix error handling of sdhci_add_host

Yi Sun (2):
      mmc: Correct the value of MMC_NUM_PHY_PARTITION
      mmc: sdhci: execute tuning when device is not busy

Yuvaraj CD (1):
      mmc: dw_mmc: use mmc_regulator_get_supply to handle regulators

addy ke (1):
      mmc: dw_mmc: move rockchip related code to a separate file

 Documentation/devicetree/bindings/mmc/mmc.txt      |   2 +
 .../devicetree/bindings/mmc/rockchip-dw-mshc.txt   |   6 +-
 Documentation/devicetree/bindings/mmc/tmio_mmc.txt |   3 +
 MAINTAINERS                                        |   3 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |   3 +-
 arch/arm/mach-shmobile/board-koelsch.c             |   3 -
 arch/arm/mach-shmobile/board-lager.c               |   2 -
 drivers/mmc/card/block.c                           |  21 +-
 drivers/mmc/card/queue.c                           |   6 +-
 drivers/mmc/card/sdio_uart.c                       |   9 +-
 drivers/mmc/core/core.c                            |  48 ++--
 drivers/mmc/core/host.c                            |  96 ++++---
 drivers/mmc/core/mmc.c                             | 263 +++++++++++-------
 drivers/mmc/core/mmc_ops.c                         |  24 +-
 drivers/mmc/core/mmc_ops.h                         |   1 +
 drivers/mmc/core/sd.c                              |  41 +--
 drivers/mmc/core/sdio.c                            |  19 +-
 drivers/mmc/core/sdio_bus.c                        |   4 +-
 drivers/mmc/core/sdio_irq.c                        |  11 +-
 drivers/mmc/core/slot-gpio.c                       |  70 ++++-
 drivers/mmc/host/Kconfig                           |  23 +-
 drivers/mmc/host/Makefile                          |   2 +
 drivers/mmc/host/atmel-mci.c                       |  55 ++--
 drivers/mmc/host/au1xmmc.c                         |   5 +-
 drivers/mmc/host/dw_mmc-pci.c                      |   3 -
 drivers/mmc/host/dw_mmc-pltfm.c                    |  10 +-
 drivers/mmc/host/dw_mmc-rockchip.c                 | 136 ++++++++++
 drivers/mmc/host/dw_mmc.c                          | 297 +++++++++++++++------
 drivers/mmc/host/dw_mmc.h                          |   5 +-
 drivers/mmc/host/jz4740_mmc.c                      | 269 ++++++++++++++++++-
 drivers/mmc/host/mmc_spi.c                         |   1 +
 drivers/mmc/host/mmci.c                            | 115 +++++---
 drivers/mmc/host/mmci_qcom_dml.c                   | 177 ++++++++++++
 drivers/mmc/host/mmci_qcom_dml.h                   |  31 +++
 drivers/mmc/host/moxart-mmc.c                      |   1 -
 drivers/mmc/host/mxcmmc.c                          |   1 -
 drivers/mmc/host/mxs-mmc.c                         |   1 -
 drivers/mmc/host/omap.c                            |   1 -
 drivers/mmc/host/omap_hsmmc.c                      |  15 +-
 drivers/mmc/host/pxamci.c                          |   5 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   9 +-
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |   9 +-
 drivers/mmc/host/s3cmci.c                          |   4 +-
 drivers/mmc/host/sdhci-acpi.c                      | 111 +++++---
 drivers/mmc/host/sdhci-bcm-kona.c                  |   3 +-
 drivers/mmc/host/sdhci-bcm2835.c                   |   1 -
 drivers/mmc/host/sdhci-cns3xxx.c                   |   1 -
 drivers/mmc/host/sdhci-dove.c                      |   1 -
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  21 +-
 drivers/mmc/host/sdhci-msm.c                       |  27 +-
 drivers/mmc/host/sdhci-of-arasan.c                 |   1 -
 drivers/mmc/host/sdhci-of-esdhc.c                  |   1 -
 drivers/mmc/host/sdhci-of-hlwd.c                   |   1 -
 drivers/mmc/host/sdhci-pci.c                       |  70 ++++-
 drivers/mmc/host/sdhci-pci.h                       |   7 +
 drivers/mmc/host/sdhci-pltfm.c                     |  10 +-
 drivers/mmc/host/sdhci-pxav2.c                     |   1 -
 drivers/mmc/host/sdhci-pxav3.c                     |   8 +-
 drivers/mmc/host/sdhci-s3c.c                       |   5 +-
 drivers/mmc/host/sdhci-sirf.c                      |  26 +-
 drivers/mmc/host/sdhci-spear.c                     |   1 -
 drivers/mmc/host/sdhci-tegra.c                     |   1 -
 drivers/mmc/host/sdhci.c                           | 155 +++++++----
 drivers/mmc/host/sdhci.h                           |   4 +
 drivers/mmc/host/sh_mmcif.c                        |   1 -
 drivers/mmc/host/sh_mobile_sdhi.c                  |  53 +++-
 drivers/mmc/host/sunxi-mmc.c                       |   4 +-
 drivers/mmc/host/tifm_sd.c                         |   4 +-
 drivers/mmc/host/tmio_mmc.c                        |   7 +-
 drivers/mmc/host/tmio_mmc.h                        |  31 +--
 drivers/mmc/host/tmio_mmc_dma.c                    |   8 +-
 drivers/mmc/host/tmio_mmc_pio.c                    | 294 ++++++++++++--------
 drivers/mmc/host/wbsd.c                            |  21 +-
 include/linux/atmel-mci.h                          |   2 +
 include/linux/mfd/tmio.h                           |  25 ++
 include/linux/mmc/card.h                           |  10 +-
 include/linux/mmc/dw_mmc.h                         |   4 +-
 include/linux/mmc/host.h                           |  12 +-
 include/linux/mmc/mmc.h                            |   7 +
 include/linux/mmc/sdhci.h                          |   3 +
 include/linux/mmc/slot-gpio.h                      |   5 +-
 81 files changed, 2007 insertions(+), 750 deletions(-)
 create mode 100644 drivers/mmc/host/dw_mmc-rockchip.c
 create mode 100644 drivers/mmc/host/mmci_qcom_dml.c
 create mode 100644 drivers/mmc/host/mmci_qcom_dml.h
