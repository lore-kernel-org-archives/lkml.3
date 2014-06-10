Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaFJTv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:51:58 -0400
Received: from void.printf.net ([89.145.121.20]:60735 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228AbaFJTvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:54 -0400
From: Chris Ball <chris@printf.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.16-rc1
Date: Tue, 10 Jun 2014 20:51:51 +0100
Message-ID: <86ha3so84o.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.16-rc1

to receive the MMC merge for 3.16.  These patches have been tested in
linux-next, and there are three minor conflicts which I've resolved on
my mmc-updates-for-3.16-rc1-merged branch.  Thanks.


The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.16-rc1

for you to fetch changes up to 11bc9381b277a65ea4b3fe994e658f4a78512139:

  mmc: sdhci-s3c: use mmc_of_parse and remove the card_tasklet (2014-06-04 18:59:12 -0400)

----------------------------------------------------------------
MMC highlights for 3.16:

Core:
 - support HS400 mode of eMMC 5.0, via DT bindings mmc-hs400-1_{2,8}v
 - if card init at 3.3v doesn't work, try 1.8v and 1.2v too

Drivers:
 - moxart: New driver for MOXA ART SoCs
 - rtsx_usb_sdmmc: New driver for Realtek USB card readers
 - sdhci: Large rework around IRQ/regulator handling, remove card_tasklet
 - sdhci-pci-o2micro: Add SeaBird SeaEagle SD3 support
 - sunxi: New driver for Allwinner sunxi SoCs
 - usdhi6rol0: New driver for Renesas SD/SDIO controller

----------------------------------------------------------------
Aisheng Dong (1):
      mmc: sdhci-esdhc-imx: fix mmc ddr mode regression issue

Al Cooper (1):
      mmc: sdhci: SD tuning is broken for some controllers

Alex Smith (1):
      mmc: jz4740: don't wait for PRG_DONE after stop command with R1 response

Alexander Shiyan (3):
      mmc: mxcmmc: Convert to devm-* API
      mmc: mxcmmc: Convert to SIMPLE_DEV_PM_OPS
      mmc: mxcmmc: Use mmc_regulator_get_supply() API

Alexandre Belloni (1):
      mmc: atmel: don't test host->data

Andrew Bresticker (2):
      mmc: tegra: disable UHS modes
      mmc: tegra: fix reporting of base clock frequency

Arnd Bergmann (1):
      mmc: rtsx: fix possible linking error if built-in

Axel Lin (4):
      mmc: Convert to use ATTRIBUTE_GROUPS
      mmc: sdhci-s3c: Remove unused define for NUM_GPIOS
      mmc: omap: Use DIV_ROUND_UP instead of open coded
      mmc: wmt-sdmmc: Use GFP_KERNEL instead of hard-coded value

Balaji T K (6):
      mmc: omap_hsmmc: use devm_clk_get
      mmc: omap_hsmmc: use devm_request_irq
      mmc: omap_hsmmc: use devm_request_threaded_irq
      mmc: omap_hsmmc: use devm_ioremap_resource
      mmc: omap_hsmmc: fix cmd23 multiblock read/write
      mmc: omap_hsmmc: split omap-dma header file

Daniel Willmann (1):
      mmc: mxs: fix card detection function for broken card detect

David Lanzendörfer (1):
      mmc: sunxi: Add driver for SD/MMC hosts found on Allwinner sunxi SoCs

Doug Anderson (1):
      mmc: dw_mmc: Don't print data errors

Fabio Estevam (1):
      mmc: card.h: Use NULL instead of 0 for END_FIXUP

Guennadi Liakhovetski (1):
      mmc: add a driver for the Renesas usdhi6rol0 SD/SDIO host controller

Jaehoon Chung (8):
      mmc: dw_mmc: use the mmc_of_parse() instead of local parser
      mmc: dw_mmc: replace the bus_hz checking point
      mmc: dw_mmc: remove unused member variable.
      mmc: dw_mmc: fix minor coding style.
      mmc: dw_mmc: remove unnecessary function.
      mmc: dw_mmc: remove dw_mci_of_cd_gpio/wp_gpio()
      mmc: dw_mmc: restore the card-present checking point
      mmc: sdhci-s3c: use mmc_of_parse and remove the card_tasklet

Jonas Jensen (1):
      mmc: moxart: Add MOXA ART SD/MMC driver

Markus Mayer (1):
      mmc: Delay the card_event callback into the mmc_rescan worker

Micky Ching (1):
      mmc: rtsx: add R1-no-CRC mmc command type handle

Nick Sanders (1):
      mmc: sdhci: remove mdelay in eMMC tuning

Peter Guo (1):
      mmc: sdhci-pci-o2micro: Add SeaBird SeaEagle SD3 support

Roger Tseng (1):
      mmc: Add realtek USB sdmmc host driver

Russell King (31):
      mmc: sdio_irq: rework sdio irq handling
      mmc: sdhci: clean up interrupt handling
      mmc: sdhci: clean up sdio interrupt enable handling
      mmc: sdhci: convert to new SDIO IRQ handling
      mmc: sdhci: push card_tasklet into threaded irq handler
      mmc: sdhci: allow sdio interrupts while sdhci runtime suspended
      mmc: sdhci: more efficient interrupt enable register handling
      mmc: sdhci: plug hole in disabling card detection interrupts
      mmc: sdhci: convert generic bus width setup to library function
      mmc: sdhci: convert reset into a library function
      mmc: sdhci: move FSL ESDHC reset handling quirk into esdhc code
      mmc: sdhci: avoid sync'ing the SG if there's no misalignment
      mmc: sdhci: convert ADMA descriptors to a coherent allocation
      mmc: sdhci: clean up sdhci_update_clock()/sdhci_set_clock()
      mmc: sdhci: move setting host->clock into sdhci_do_set_ios()
      mmc: sdhci: move setting mmc->actual_clock into set_clock handlers
      mmc: sdhci: convert sdhci_set_clock() into a library function
      mmc: sdhci-esdhc-imx: avoid DMA to kernel stack
      mmc: sdhci-esdhc-imx: comment runtime_pm_get_sync() in esdhc_prepare_tuning()
      mmc: sdhci-esdhc-imx: fix lockdep splat upon tuning
      mmc: sdhci: set_uhs_signaling() need not return a value
      mmc: sdhci: convert sdhci_set_uhs_signaling() into a library function
      mmc: sdhci: cache timing information locally
      mmc: sdhci: clean up sdhci_execute_tuning() decision
      mmc: sdhci-esdhc-imx: remove emulation of uhs_mode
      mmc: sdhci-of-esdhc: remove platform_suspend/platform_resume callbacks
      mmc: sdhci: remove platform_suspend/platform_resume callbacks
      mmc: sdhci-tegra: get rid of special PRESENT_STATE register handling
      mmc: sdhci: move regulator handling into sdhci_set_power()
      mmc: sdhci: move remaining power handling into sdhci_set_power()
      mmc: sdhci: track whether preset mode is currently enabled in hardware

Sachin Kamat (1):
      mmc: dw_mmc: exynos: Staticize dw_mci_exynos_pmops

Sebastian Hesselbarth (4):
      mmc: mvsdio: silence card detect notice
      mmc: mvsdio: workaround for spurious irqs
      mmc: dove: fix missing MACH_DOVE dependency
      mmc: sdhci-dove: use mmc_of_parse() and remove card_tasklet CD handler

Seungwon Jeon (13):
      mmc: clarify DDR timing mode between SD-UHS and eMMC
      mmc: mmci: clarify DDR timing mode between SD-UHS and eMMC
      mmc: omap: clarify DDR timing mode between SD-UHS and eMMC
      mmc: sh_mmcif: clarify DDR timing mode between SD-UHS and eMMC
      mmc: rtsx: clarify DDR timing mode between SD-UHS and eMMC
      mmc: dw_mmc: clarify DDR timing mode between SD-UHS and eMMC
      mmc: sdhci: clarify DDR timing mode between SD-UHS and eMMC
      mmc: drop the speed mode of card's state
      mmc: identify available device type to select
      mmc: step power class after final selection of bus mode
      mmc: rework selection of bus speed mode
      mmc: add support for HS400 mode of eMMC5.0
      mmc: core: add DT bindings for eMMC HS400 1.8/1.2V

Stefan Wahren (1):
      mmc: core: Use maximum timeout values in case TACC field is zero

Tim Kryger (2):
      mmc: core: Try other signal levels during power up
      mmc: core: Improve support for deferred regulators

Ulf Hansson (4):
      mmc: core: Invoke sdio func driver's PM callbacks from the sdio bus
      MAINTAINERS: mmc: Update email for host driver maintainer
      MAINTAINERS: mmc: Add path to git tree
      mmc: sdhci-of-esdhc: Fixup compile error

 Documentation/devicetree/bindings/mmc/mmc.txt      |    2 +
 .../devicetree/bindings/mmc/moxa,moxart-mmc.txt    |   30 +
 .../devicetree/bindings/mmc/sunxi-mmc.txt          |   43 +
 .../devicetree/bindings/mmc/synopsys-dw-mshc.txt   |    5 -
 .../devicetree/bindings/mmc/usdhi6rol0.txt         |   33 +
 MAINTAINERS                                        |    3 +-
 drivers/mmc/core/bus.c                             |    9 +-
 drivers/mmc/core/core.c                            |   52 +-
 drivers/mmc/core/debugfs.c                         |    8 +-
 drivers/mmc/core/host.c                            |    4 +
 drivers/mmc/core/mmc.c                             |  678 ++++---
 drivers/mmc/core/sd.c                              |   28 +-
 drivers/mmc/core/sd.h                              |    1 -
 drivers/mmc/core/sdio.c                            |   53 +-
 drivers/mmc/core/sdio_bus.c                        |   14 +-
 drivers/mmc/core/sdio_irq.c                        |   41 +-
 drivers/mmc/core/slot-gpio.c                       |    4 +-
 drivers/mmc/host/Kconfig                           |   31 +-
 drivers/mmc/host/Makefile                          |    4 +
 drivers/mmc/host/atmel-mci.c                       |   13 +-
 drivers/mmc/host/dw_mmc-exynos.c                   |    7 +-
 drivers/mmc/host/dw_mmc.c                          |  180 +-
 drivers/mmc/host/dw_mmc.h                          |    2 -
 drivers/mmc/host/jz4740_mmc.c                      |   11 +-
 drivers/mmc/host/mmci.c                            |    6 +-
 drivers/mmc/host/moxart-mmc.c                      |  730 ++++++++
 drivers/mmc/host/mvsdio.c                          |   20 +-
 drivers/mmc/host/mxcmmc.c                          |  140 +-
 drivers/mmc/host/mxs-mmc.c                         |    7 +
 drivers/mmc/host/omap.c                            |   10 +-
 drivers/mmc/host/omap_hsmmc.c                      |   61 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |    5 +
 drivers/mmc/host/rtsx_usb_sdmmc.c                  | 1456 +++++++++++++++
 drivers/mmc/host/sdhci-acpi.c                      |    8 +
 drivers/mmc/host/sdhci-bcm-kona.c                  |    4 +
 drivers/mmc/host/sdhci-bcm2835.c                   |    4 +
 drivers/mmc/host/sdhci-cns3xxx.c                   |   13 +-
 drivers/mmc/host/sdhci-dove.c                      |   78 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   83 +-
 drivers/mmc/host/sdhci-esdhc.h                     |    4 +-
 drivers/mmc/host/sdhci-of-arasan.c                 |    4 +
 drivers/mmc/host/sdhci-of-esdhc.c                  |   70 +-
 drivers/mmc/host/sdhci-of-hlwd.c                   |    4 +
 drivers/mmc/host/sdhci-pci-o2micro.c               |   78 +-
 drivers/mmc/host/sdhci-pci-o2micro.h               |    3 +
 drivers/mmc/host/sdhci-pci.c                       |    9 +-
 drivers/mmc/host/sdhci-pltfm.c                     |    4 +
 drivers/mmc/host/sdhci-pxav2.c                     |   14 +-
 drivers/mmc/host/sdhci-pxav3.c                     |   13 +-
 drivers/mmc/host/sdhci-s3c.c                       |  138 +-
 drivers/mmc/host/sdhci-sirf.c                      |    4 +
 drivers/mmc/host/sdhci-spear.c                     |    5 +-
 drivers/mmc/host/sdhci-tegra.c                     |   67 +-
 drivers/mmc/host/sdhci.c                           |  749 ++++----
 drivers/mmc/host/sdhci.h                           |   20 +-
 drivers/mmc/host/sh_mmcif.c                        |    9 +-
 drivers/mmc/host/sunxi-mmc.c                       | 1049 +++++++++++
 drivers/mmc/host/usdhi6rol0.c                      | 1847 ++++++++++++++++++++
 drivers/mmc/host/wmt-sdmmc.c                       |    2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    4 +-
 include/linux/mmc/card.h                           |   29 +-
 include/linux/mmc/dw_mmc.h                         |   14 -
 include/linux/mmc/host.h                           |   59 +-
 include/linux/mmc/mmc.h                            |   23 +-
 include/linux/mmc/sdhci.h                          |   15 +-
 include/linux/omap-dma.h                           |   19 +-
 include/linux/omap-dmaengine.h                     |   21 +
 67 files changed, 6668 insertions(+), 1490 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/moxa,moxart-mmc.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/sunxi-mmc.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/usdhi6rol0.txt
 create mode 100644 drivers/mmc/host/moxart-mmc.c
 create mode 100644 drivers/mmc/host/rtsx_usb_sdmmc.c
 create mode 100644 drivers/mmc/host/sunxi-mmc.c
 create mode 100644 drivers/mmc/host/usdhi6rol0.c
 create mode 100644 include/linux/omap-dmaengine.h

-- 
Chris Ball   <http://printf.net/>
