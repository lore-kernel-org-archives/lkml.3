Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3GIVyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 17:54:55 -0400
Received: from void.printf.net ([89.145.121.20]:40814 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab3GIVyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 17:54:50 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.11-rc1
Date: Tue, 09 Jul 2013 22:54:49 +0100
Message-ID: <864nc31jrq.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.11-rc1

to receive the MMC merge for 3.11.  There are currently no conflicts,
and these patches have been tested in linux-next.  Thanks.


The following changes since commit 4a29b5591faf25555fdf2b717594d50f70c15066:

  mmc: omap_hsmmc: Skip platform_get_resource_byname() for dt case (2013-05-26 14:23:11 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.11-rc1

for you to fetch changes up to 01ebea1b411aafc8eab440bf1d2037f01bbed99b:

  mmc: bcm281xx SDHCI driver (2013-07-05 13:00:31 -0400)

----------------------------------------------------------------
MMC highlights for 3.11:

Core:
 - Add support for eMMC 5.1 devices.
 - Add MMC_CAP_AGGRESSIVE_PM capability for aggressive power management
   of eMMC/SD between requests, using runtime PM.
 - Add an ioctl to perform the eMMC 4.5 Sanitize command; sample code at:
   git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git

Drivers:
 - dw_mmc: Add support for Rockchip's Cortex-A9 SoCs.
 - dw_mmc: Add support for Altera SoCFPGAs.
 - sdhci-esdhc-imx: Add support for 8-bit bus width, non-removable cards.
 - sdhci-bcm-kona: New driver for Broadcom Kona (281xx) SoCs.
 - sdhi/tmio: Add DT DMA support.

----------------------------------------------------------------
Adrian Hunter (6):
      mmc: sdhci: add ability to stay runtime-resumed if the card is powered up
      mmc: sdhci-acpi: support runtime PM for ACPI HID 80860F14 SD cards
      mmc: sdhci-pci: support runtime PM for BYT SD cards
      mmc: sdhci-pci: add support for eMMC hardware reset for BYT eMMC.
      mmc: sdhci-acpi: add support for eMMC hardware reset for HID 80860F14
      mmc: sdhci-pci: add another device id

Al Cooper (1):
      mmc: sdhci-pltfm: Allow drivers to set quirks2 from platform data

Andy Shevchenko (3):
      mmc: dw_mmc-pltfm: don't check resource with devm_ioremap_resource
      mmc: dw_mmc: eliminate useless usage of ret
      mmc: dw_mmc-pci: convert to use pcim_* and devm_*

Arnd Bergmann (1):
      mmc: sirf: fix sdhci_pltfm_init sequence

Barry Song (1):
      mmc: sdhci-sirf: let device core setup the default pin configuration

Christian Daudt (3):
      mmc: sdhci: Add size for caller in init+register
      mmc: sdhci: add card_event callback to sdhci
      mmc: bcm281xx SDHCI driver

Daniel Drake (1):
      sdhci-pxav3: Fix runtime PM initialization

Dinh Nguyen (1):
      mmc: dw_mmc: Add support DW SD/MMC driver on SOCFPGA

Doug Anderson (2):
      mmc: dw_mmc: Handle late vmmc regulators with EPROBE_DEFER
      mmc: dw_mmc: Add the ability to set the ciu clock frequency

Fabio Estevam (1):
      mmc: mxs-mmc: Let device core handle pinctrl

Fredrik Soderstedt (2):
      mmc: core: Only execute tuning for SDR50 and SDR104
      mmc: core: Fix select power class after resume

Giuseppe CAVALLARO (2):
      mmc: sdhci: fix caps2 for HS200
      mmc: sdhci: fix ctrl_2 on super-speed selection

Guennadi Liakhovetski (7):
      mmc: sdhi/tmio: make DMA filter implementation specific
      mmc: sdhi/tmio: switch to using dmaengine_slave_config()
      mmc: sdhi/tmio: add DT DMA support
      mmc: tmio: postpone controller reset during resume
      mmc: sh_mmcif: don't clear masked interrupts
      mmc: tmio: fix unbalanced power-on calls with clock-gating enabled
      mmc: tmio: reset the controller after power-up

Heiko Stübner (3):
      mmc: dw_mmc-pltfm: remove static from dw_mci_pltfm_remove
      mmc: dw_mmc-pltfm: move probe and remove below dt match table
      mmc: dw_mmc-pltfm: add Rockchip variant

Jaehoon Chung (1):
      mmc: dw_mmc: change the macro name from DTO to DRTO

Jingoo Han (3):
      mmc: atmel-mci: add CONFIG_PM_SLEEP to suspend/resume functions
      mmc: remove unnecessary platform_set_drvdata()
      mmc: host: use platform_{get,set}_drvdata()

Joonyoung Shim (1):
      mmc: dw_mmc: clear IDSTS register when initialize IDMAC

Lars-Peter Clausen (4):
      mmc: jz4740: Use clk_prepare_enable/clk_disable_unprepare
      mmc: jz4740: Use SIMPLE_DEV_PM_OPS
      mmc: jz4740: Use slot-gpio helpers
      mmc: jz4740: Use managed resources

Lucas Stach (2):
      mmc: sdhci-esdhc: calculate sdclk divider from controller clock
      mmc: esdhc-imx: parse max-frequency from devicetree

Luciano Coelho (1):
      mmc: omap: remove unnecessary #if 0's

Maya Erez (1):
      mmc: card: Adding support for sanitize in eMMC 4.5

Nicolas Ferre (1):
      mmc: atmel-mci: remove include <mach/cpu.h>

Oded Gabbay (2):
      mmc: esdhc: Add support for 8-bit bus width and non-removable card
      mmc: esdhc: Fix bug when writing to SDHCI_HOST_CONTROL register

Paul Cercueil (2):
      mmc: jz4740: Remove duplicated code.
      mmc: jz4740: Fix handling of read errors.

Paul Taysom (1):
      mmc: reordered shutdown sequence in mmc_bld_remove_req

Romain Izard (1):
      mmc: core: production year for eMMC 4.41 and later

Shawn Guo (1):
      mmc: sdhci: improve card removal check in sdhci_card_event()

Simon Baatz (7):
      mmc: return mmc_of_parse() errors to caller
      mmc: sh_mmcif: handle mmc_of_parse() errors during probe
      mmc: tmio-mmc: handle mmc_of_parse() errors during probe
      mmc: mxcmmc: handle mmc_of_parse() errors during probe
      mmc: sdhci-pxav3: handle mmc_of_parse() errors during probe
      mmc: tegra: handle mmc_of_parse() errors during probe
      mmc: mvsdio: use standard MMC device-tree binding parser mmc_of_parse()

Ulf Hansson (19):
      mmc: core: Re-use code for MMC_CAP2_DETECT_ON_ERR in polling mode
      mmc: core: Stop bkops for eMMC only from mmc suspend
      mmc: core: Add bus_ops for runtime pm callbacks
      mmc: block: Enable runtime pm for mmc blkdevice
      mmc: core: Support aggressive power management for (e)MMC/SD
      mmc: core: Restructure and simplify code for mmc sleep|awake
      mmc: core: Remove unnecessary check for the remove callback
      mmc: core: Validate suspend prerequisites for SDIO at SUSPEND_PREPARE
      mmc: core: Push common suspend|resume code into each bus_ops
      mmc: core: Initiate suspend|resume from mmc bus instead of mmc host
      mmc: core: Handle card shutdown from mmc_bus
      mmc: core: Extend shutdown sequence to handle bus operations
      mmc: core: Add shutdown callback for SD bus_ops
      mmc: core: Handle both poweroff notification types for eMMC
      mmc: core: Add shutdown callback for (e)MMC bus_ops
      mmc: core: Enable power_off_notify for eMMC shutdown sequence
      mmc: core: Invent MMC_CAP2_FULL_PWR_CYCLE
      mmc: core: Add DT-bindings for MMC_CAP2_FULL_PWR_CYCLE
      mmc: core: Fixup Oops for SDIO shutdown

Wei Yongjun (4):
      mmc: dw_mmc: fix error return code in dw_mci_probe()
      mmc: mxs-mmc: fix error return code in mxs_mmc_probe()
      mmc: sdhci-acpi: fix error return code in sdhci_acpi_add_own_cd()
      mmc: sh_mobile_sdhi: fix error return code in sh_mobile_sdhi_probe()

Yaniv Gardi (1):
      mmc: card: fixing an false identification of SANITIZE command

Yuvaraj Kumar C D (1):
      mmc: core: Update the ext-csd.rev check for eMMC5.1

 Documentation/devicetree/bindings/mmc/mmc.txt      |   1 +
 .../devicetree/bindings/mmc/rockchip-dw-mshc.txt   |  23 ++
 .../devicetree/bindings/mmc/synopsis-dw-mshc.txt   |  20 ++
 arch/arm/configs/bcm_defconfig                     |   7 +
 drivers/mmc/card/block.c                           | 130 +++++---
 drivers/mmc/card/mmc_test.c                        |   5 +
 drivers/mmc/card/queue.c                           |   2 +-
 drivers/mmc/core/bus.c                             |  52 ++-
 drivers/mmc/core/core.c                            | 200 ++++--------
 drivers/mmc/core/core.h                            |   7 +-
 drivers/mmc/core/debugfs.c                         |   8 +-
 drivers/mmc/core/host.c                            |  32 +-
 drivers/mmc/core/mmc.c                             | 249 +++++++++++----
 drivers/mmc/core/mmc_ops.c                         |  36 +--
 drivers/mmc/core/mmc_ops.h                         |   1 -
 drivers/mmc/core/sd.c                              |  68 +++-
 drivers/mmc/core/sdio.c                            |  76 ++++-
 drivers/mmc/host/Kconfig                           |  19 ++
 drivers/mmc/host/Makefile                          |   2 +
 drivers/mmc/host/android-goldfish.c                |   2 -
 drivers/mmc/host/atmel-mci.c                       |  14 +-
 drivers/mmc/host/au1xmmc.c                         |   1 -
 drivers/mmc/host/bfin_sdh.c                        |   2 -
 drivers/mmc/host/cb710-mmc.c                       |   2 +-
 drivers/mmc/host/cb710-mmc.h                       |   2 +-
 drivers/mmc/host/davinci_mmc.c                     |   1 -
 drivers/mmc/host/dw_mmc-exynos.c                   |   2 -
 drivers/mmc/host/dw_mmc-pci.c                      |  58 +---
 drivers/mmc/host/dw_mmc-pltfm.c                    |  73 +++--
 drivers/mmc/host/dw_mmc-socfpga.c                  | 140 +++++++++
 drivers/mmc/host/dw_mmc.c                          |  65 ++--
 drivers/mmc/host/dw_mmc.h                          |   3 +-
 drivers/mmc/host/jz4740_mmc.c                      | 180 +++--------
 drivers/mmc/host/mvsdio.c                          |  74 +++--
 drivers/mmc/host/mxcmmc.c                          |   6 +-
 drivers/mmc/host/mxs-mmc.c                         |  11 +-
 drivers/mmc/host/omap.c                            |  18 --
 drivers/mmc/host/omap_hsmmc.c                      |   2 -
 drivers/mmc/host/pxamci.c                          |   2 -
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   2 -
 drivers/mmc/host/sdhci-acpi.c                      |  96 +++++-
 drivers/mmc/host/sdhci-bcm-kona.c                  | 348 +++++++++++++++++++++
 drivers/mmc/host/sdhci-bcm2835.c                   |   2 +-
 drivers/mmc/host/sdhci-cns3xxx.c                   |   2 +-
 drivers/mmc/host/sdhci-dove.c                      |   2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  30 +-
 drivers/mmc/host/sdhci-esdhc.h                     |  16 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |  63 +++-
 drivers/mmc/host/sdhci-of-hlwd.c                   |   2 +-
 drivers/mmc/host/sdhci-pci.c                       |  43 ++-
 drivers/mmc/host/sdhci-pltfm.c                     |  23 +-
 drivers/mmc/host/sdhci-pltfm.h                     |  14 +-
 drivers/mmc/host/sdhci-pxav2.c                     |   4 +-
 drivers/mmc/host/sdhci-pxav3.c                     |  18 +-
 drivers/mmc/host/sdhci-s3c.c                       |   1 -
 drivers/mmc/host/sdhci-sirf.c                      |  59 ++--
 drivers/mmc/host/sdhci-spear.c                     |   2 -
 drivers/mmc/host/sdhci-tegra.c                     |  11 +-
 drivers/mmc/host/sdhci.c                           |  63 +++-
 drivers/mmc/host/sdhci.h                           |   1 +
 drivers/mmc/host/sh_mmcif.c                        |  12 +-
 drivers/mmc/host/sh_mobile_sdhi.c                  |  34 +-
 drivers/mmc/host/tmio_mmc.c                        |   2 -
 drivers/mmc/host/tmio_mmc.h                        |  21 +-
 drivers/mmc/host/tmio_mmc_dma.c                    |  48 ++-
 drivers/mmc/host/tmio_mmc_pio.c                    |  40 ++-
 drivers/mmc/host/wmt-sdmmc.c                       |   2 -
 include/linux/mfd/tmio.h                           |   5 +
 include/linux/mmc/card.h                           |  11 +-
 include/linux/mmc/core.h                           |   5 +
 include/linux/mmc/host.h                           |  12 +-
 include/linux/mmc/sdhci.h                          |   6 +-
 include/linux/platform_data/mmc-esdhc-imx.h        |   1 +
 73 files changed, 1807 insertions(+), 790 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
 create mode 100644 drivers/mmc/host/dw_mmc-socfpga.c
 create mode 100644 drivers/mmc/host/sdhci-bcm-kona.c

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
