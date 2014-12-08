Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaLHLUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:20:00 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:42744 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbaLHLT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:19:57 -0500
MIME-Version: 1.0
Date: Mon, 8 Dec 2014 12:19:55 +0100
Message-ID: <CAPDyKFqoBmqDz5qvAZaZ-O7vhxtTnyeN_90Ngd4YodwnEBoTeg@mail.gmail.com>
Subject: [GIT PULL] MMC for v.3.19
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus <torvalds@linux-foundation.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the PR for MMC for v3.19.

Stephen Rothwell has reported about a conflict in
arch/arm/mach-omap2/board-n8x0.c between commit "ARM: OMAP2+: Prepare
to move GPMC to drivers by platform data header" from the arm-soc tree
and commit "ARM: OMAP2: MMC: include mmc-omap platform header
directly" from my mmc tree. It should be trivial to resolve, but I am
happy to help if needed.

Details about the MMC highlights are found in the signed tag. Please
pull this in!

Kind regards
Ulf Hansson


The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.linaro.org/people/ulf.hansson/mmc.git tags/mmc-v3.19-1

for you to fetch changes up to 33d73935e4abb2c75f263dd31a314db09ccf41be:

  mmc: sdhci-msm: Convert to mmc_send_tuning() (2014-12-08 09:21:06 +0100)

----------------------------------------------------------------
MMC core:
- Consolidation and cleanups.
- Some improvements regarding error handling.
- Increase maximum amount of block devices.
- Use correct OCR mask for SDIO when restoring power.
- Fix prepared requests while doing BKOPS.
- Convert to modern PM ops.
- Add mmc_send_tuning() API and convert some hosts to use it.

MMC host:
- toshsd: New Toshiba PCI SD controller driver.
- sdhci: 64-bit ADMA support.
- sdhci: Some regulator fixes.
- sdhci: HS400 support.
- sdhci: Various fixes cleanups.
- atmel-mci: Modernization and cleanups.
- atmel-mci: Runtime PM support.
- omap_hsmmc: Modernization and cleanups.
- omap_hsmmc: Fix UHS card with DDR50 support.
- dw_mmc: Support for ARM64 and Exynos 7 variant.
- dw_mmc: Add support for IMG Pistachio variant.
- dw_mmc: Various fixes and cleanups.
- mvsdio: DMA fixes.
- mxs-mmc: Modernization and cleanups.
- mxcmmc: Various fixes.

----------------------------------------------------------------
Abhilash Kesavan (1):
      mmc: dw_mmc: exynos: Add support for exynos7

Addy Ke (1):
      mmc: dw_mmc: add support for the other bit of sdio interrupt

Adrian Hunter (23):
      mmc: sdhci: Fix incorrect ADMA2 descriptor table size
      mmc: sdhci: Fix ADMA page boundary warnings
      mmc: sdhci: Fix ADMA table size warning
      mmc: sdhci: Rename two ADMA-related functions for consistency
      mmc: sdhci: Rename adma_desc to adma_table
      mmc: sdhci: Add sdhci_adma_mark_end()
      mmc: sdhci: Use 'void *' for not 'u8 *' for ADMA data
      mmc: sdhci: Parameterize ADMA sizes and alignment
      mmc: sdhci: Define maximum segments
      mmc: sdhci: Define ADMA constants
      mmc: sdhci: Define ADMA descriptor structure
      mmc: sdhci: Add 64-bit ADMA support
      mmc: sdhci-acpi: Add 64-bit DMA support
      mmc: sdhci-pci: Add 64-bit DMA support
      mmc: mmc_test: Extend "Badly aligned" tests for 8-byte alignment
      mmc: sdhci: Remove unused SDHCI_CTRL_HS_SDR200
      mmc: sdhci: Fix vqmmc error setting
      mmc: sdhci: Clear also HS400 1.2V capability if 1.2V is not supported
      mmc: sdhci: Add HS400 support to SDHCI driver
      mmc: sdhci-pci: Add SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC to BYT
      mmc: sdhci-acpi: Add SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC
      mmc: sdhci-pci: Add two host capabilities for BYT
      mmc: sdhci-acpi: Add two host capabilities for Intel

Alexandre Belloni (3):
      mmc: atmel-mci: move mach header to platform_data
      ARM: at91: remove mach/atmel-mci.h
      avr32: remove mach/atmel-mci.h

Alim Akhtar (1):
      mmc: dw_mmc: add support for ARM64

Andreas Fenkart (10):
      ARM: OMAP2: MMC: include mmc-omap platform header directly
      ARM: OMAP1/2+: MMC: separate platform data for mmc and mmc hs driver
      mmc: omap_hsmmc: remove unused fields in platform_data
      mmc: omap_hsmmc: remove un-initialized callbacks from platform data
      mmc: omap_hsmmc: remove never read power_saving field in omap2_hsmmc_info
      mmc: omap_hsmmc: remove unused get_context_loss_count callback
      mmc: omap_hsmmc: remove unnecessary omap_hsmmc_slot_data indirection
      mmc: omap_hsmmc: pass mmc_priv struct to gpio init / free
      mmc: omap_hsmmc: Remove unnecessary callbacks from platform data
      mmc: omap_hsmmc: remove unused slot_id parameter

Andrew Bresticker (1):
      mmc: dw_mmc: Add support for IMG Pistachio

Andrew Gabbasov (5):
      mmc: sdhci: Balance vmmc regulator_disable()
      mmc: sdhci: fix error conditions for controller reset
      mmc: core: Initialize SET_BLOCK_COUNT request fields
      mmc: core: Add debug message for SET_BLOCK_COUNT result
      mmc: core: Fix error paths and messages in mmc_init_card

Andrew Lunn (1):
      mmc: mvsdio: Work around broken TX DMA

Baruch Siach (1):
      mmc: block: add newline to sysfs display of force_ro

Ben Hutchings (1):
      mmc: block: Increase max_devices

Bhuvanesh Surachari (1):
      mmc: queue: Improve error handling during allocation of bounce buffers

Dan Carpenter (2):
      mmc: core: silence a shift wrapping warning
      mmc: toshsd: move dereference below check for NULL

Dirk Behme (1):
      mmc: sdhci-esdhc-imx: don't exit in case of no pinctrl states

Doug Anderson (3):
      mmc: dw_mmc: Change signal voltage error to dev_dbg()
      mmc: dw_mmc: rockchip: Don't recalc the clock when it goes off
      mmc: dw_mmc: Remove old card detect infrastructure

Fabio Estevam (5):
      mmc: mxs-mmc: Register the irq with the device name
      mmc: mxs-mmc: Simplify PM hooks
      mmc: mxs-mmc: No need to do NULL check on 'iores'
      mmc: mxs-mmc: Propagate the real error
      mmc: mxs-mmc: Check for clk_prepare_enable() error

Gwendal Grignou (1):
      mmc: core: Report firmware version for eMMC 5.0 devices.

James Hogan (1):
      mmc: dw_mmc: avoid write to CDTHRCTL on older versions

Johan Rudholm (2):
      mmc: core: use mmc_send_status to check hw_reset
      mmc: core: consistent handling of initial values

Mark Brown (1):
      mmc: sdhci-s3c: Check if clk_set_rate() succeeds

Matteo Facchinetti (2):
      mmc: mxcmmc: fix race condition when dma finish a data transfer
      mmc: mxcmmc: fix the default value for available voltages into
mxcmci_probe

Mike Looijmans (2):
      mmc: sdhci-of-arasan: Use signed formatting in error messages
      mmc: sdhci-of-arasan: Omit superfluous error messages

Minda Chen (1):
      mmc: core: add core-level function for sending tuning commands

NeilBrown (2):
      mmc: core: use card->ocr when negotiating voltage setting in
mmc_sdio_power_restore
      mmc: core: reset sdio card properly on resume.

Ondrej Zary (1):
      mmc: add Toshiba PCI SD controller driver

Peter Guo (1):
      mmc: sdhci-pci-o2micro: Fix Dell E5440 issue

Prabu Thangamuthu (1):
      mmc: dw_mmc: Add IDMAC 64-bit address mode support

Sebastian Hesselbarth (9):
      mmc: sdhci-pxav2: Drop unused struct sdhci_pxa
      mmc: sdhci-pxav3: Respect MMC_DDR52 timing on uhs signaling
      mmc: sdhci-pxav3: Move private driver data to driver source
      mmc: sdhci-pxav3: Remove unused clk_enable from sdhci_pxa
      mmc: sdhci-pxav3: Remove checks for mandatory host clock
      mmc: sdhci-pxav3: Move I/O clock to private data
      mmc: sdhci-pxav3: Try to get named I/O clock first
      mmc: sdhci-pxav3: Get optional core clock
      mmc: sdhci-pxav3: Document clocks and additional clock-names property

Sonny Rao (1):
      mmc: dw_mmc: Reset DMA before enabling IDMAC

Srinivas Kandagatla (2):
      mmc: core: fix prepared requests while doing bkops
      mmc: mmci: fix mmci_post_request

Timo Kokkonen (1):
      mmc: host: atmel-mci: Add support for non-removable slots

Tomeu Vizoso (1):
      mmc: sunxi: Remove unused includes of linux/clk-private.h

Ulf Hansson (26):
      mmc: core: Remove superfluous ifdefs for SDIO bus' PM callbacks
      mmc: core: Don't export the to_sdio_driver macro
      mmc: core: Convert the mmc_driver to use the modern PM ops
      mmc: core: Convert mmc_driver to device_driver
      mmc: msm_sdcc: Use platform_set|get_drvdata
      mmc: block: Use dev_set|get_drvdata()
      mmc: core: Remove unused mmc_list_to_card() macro
      mmc: core: Remove mmc_free_ext_csd()
      mmc: core: Remove duplicated definition of mmc_send_ext_csd()
      mmc: core: Remove redundant check while selecting powerclass
      mmc: core: Remove redundant check of max_dtr while selecting timings
      mmc: core: Remove unnecessary 'out of memory' message
      mmc: core: Add helper function for EXT_CSD support
      mmc: core: Fetch and decode EXT_CSD from mmc_read_ext_csd()
      mmc: core: Let's callers of from mmc_get_ext_csd() do error handling
      mmc: core: Don't panic when fetching EXT_CSD
      mmc: core: Export mmc_get_ext_csd()
      mmc: block: Use mmc_get_ext_csd() instead of mmc_send_ext_csd()
      mmc: core: Use mmc_get_ext_csd() instead of mmc_send_ext_csd()
      mmc: core: Remove the redundant mmc_send_ext_csd() API
      mmc: core: Don't handle buffers on stack while fetching CXD registers
      mmc: core: Convert to use kzalloc() for CXD register buffers
      mmc: omap_hsmmc: Fix UHS card with DDR50 support
      mmc: core: Let mmc_send_tuning() to take struct mmc_host* as parameter
      mmc: sdhci-esdhc-imx: Convert to mmc_send_tuning()
      mmc: sdhci-msm: Convert to mmc_send_tuning()

Vincent Wan (3):
      mmc: sdhci: Add a quirk for AMD SDHC transfer mode register need
to be cleared for cmd without data
      mmc: sdhci-pci: enable the clear transfer mode register quirk
for AMD sdhci
      mmc: sdhci-pci: enable sdhci doesn't support hs200 quirk for AMD sdhci

Vincent Yang (1):
      mmc: core: hold SD Clock before CMD11 during Signal

Wenyou Yang (2):
      mmc: atmel-mci: add runtime pm support
      mmc: atmel-mci: adopt pinctrl support

ludovic.desroches@atmel.com (5):
      mmc: atmel-mci: remove compat for non DT board when requesting dma chan
      mmc: atmel-mci: remove useless DMA stuff for non-dt devices
      mmc: atmel-mci: remove __init/__exit attributes
      mmc: atmel-mci: stop using specific initcall
      mmc: atmel-mci: use probe deferring if dma controller is not ready yet

 .../devicetree/bindings/mmc/exynos-dw-mshc.txt     |   4 +
 .../devicetree/bindings/mmc/img-dw-mshc.txt        |  29 +
 .../devicetree/bindings/mmc/sdhci-pxa.txt          |   7 +
 arch/arm/mach-at91/at91sam9g45_devices.c           |   2 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   2 +
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   4 +-
 arch/arm/mach-omap2/hsmmc.c                        | 158 ++---
 arch/arm/mach-omap2/hsmmc.h                        |   9 +-
 arch/arm/mach-omap2/mmc.h                          |  10 -
 arch/arm/mach-omap2/omap4-common.c                 |   1 -
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   4 +-
 .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |   8 +-
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |   1 -
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   8 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   4 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |   4 +-
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |   4 +-
 arch/avr32/mach-at32ap/at32ap700x.c                |   2 +-
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h    |  17 -
 drivers/mmc/card/block.c                           |  83 ++-
 drivers/mmc/card/mmc_test.c                        |  28 +-
 drivers/mmc/card/queue.c                           |  16 +-
 drivers/mmc/core/bus.c                             |  55 +-
 drivers/mmc/core/core.c                            | 111 ++--
 drivers/mmc/core/core.h                            |   1 +
 drivers/mmc/core/debugfs.c                         |   9 +-
 drivers/mmc/core/mmc.c                             | 184 +++---
 drivers/mmc/core/mmc_ops.c                         | 130 +++-
 drivers/mmc/core/mmc_ops.h                         |   2 +-
 drivers/mmc/core/sdio.c                            |  10 +-
 drivers/mmc/core/sdio_bus.c                        |  16 +-
 drivers/mmc/host/Kconfig                           |   7 +-
 drivers/mmc/host/Makefile                          |   1 +
 drivers/mmc/host/atmel-mci.c                       | 207 +++---
 drivers/mmc/host/dw_mmc-exynos.c                   |  91 ++-
 drivers/mmc/host/dw_mmc-pltfm.c                    |   6 +
 drivers/mmc/host/dw_mmc-rockchip.c                 |  13 +
 drivers/mmc/host/dw_mmc.c                          | 346 +++++-----
 drivers/mmc/host/dw_mmc.h                          |  15 +-
 drivers/mmc/host/mmci.c                            |   7 +
 drivers/mmc/host/msm_sdcc.c                        |   6 +-
 drivers/mmc/host/mvsdio.c                          |   7 +-
 drivers/mmc/host/mxcmmc.c                          |  25 +-
 drivers/mmc/host/mxs-mmc.c                         |  26 +-
 drivers/mmc/host/omap_hsmmc.c                      | 286 ++++----
 drivers/mmc/host/sdhci-acpi.c                      |  52 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  78 +--
 drivers/mmc/host/sdhci-msm.c                       |  50 +-
 drivers/mmc/host/sdhci-of-arasan.c                 |   5 +-
 drivers/mmc/host/sdhci-pci-o2micro.c               |   2 -
 drivers/mmc/host/sdhci-pci.c                       |  56 +-
 drivers/mmc/host/sdhci-pxav2.c                     |  15 +-
 drivers/mmc/host/sdhci-pxav3.c                     |  60 +-
 drivers/mmc/host/sdhci-s3c.c                       |   8 +-
 drivers/mmc/host/sdhci.c                           | 273 +++++---
 drivers/mmc/host/sdhci.h                           |  45 +-
 drivers/mmc/host/sunxi-mmc.c                       |   1 -
 drivers/mmc/host/toshsd.c                          | 717 +++++++++++++++++++++
 drivers/mmc/host/toshsd.h                          | 176 +++++
 include/linux/atmel-mci.h                          |   2 +
 include/linux/mmc/card.h                           |  23 +-
 include/linux/mmc/core.h                           |   3 +-
 include/linux/mmc/dw_mmc.h                         |   7 +-
 include/linux/mmc/host.h                           |   1 +
 include/linux/mmc/mmc.h                            |   3 +
 include/linux/mmc/sdhci.h                          |  18 +-
 include/linux/mmc/sdio_func.h                      |   2 -
 include/linux/platform_data/hsmmc-omap.h           |  90 +++
 .../linux/platform_data/mmc-atmel-mci.h            |  13 +-
 include/linux/platform_data/mmc-omap.h             |  27 -
 include/linux/platform_data/pxa_sdhci.h            |   5 -
 71 files changed, 2459 insertions(+), 1239 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/img-dw-mshc.txt
 delete mode 100644 arch/avr32/mach-at32ap/include/mach/atmel-mci.h
 create mode 100644 drivers/mmc/host/toshsd.c
 create mode 100644 drivers/mmc/host/toshsd.h
 create mode 100644 include/linux/platform_data/hsmmc-omap.h
 rename arch/arm/mach-at91/include/mach/atmel-mci.h =>
include/linux/platform_data/mmc-atmel-mci.h (52%)
