Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3IJNbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:31:03 -0400
Received: from void.printf.net ([89.145.121.20]:42285 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3IJNbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:31:01 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.12-rc1
Date: Tue, 10 Sep 2013 14:30:52 +0100
Message-ID: <8661u8st0z.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.12-rc1

to receive the MMC merge for 3.12.  There are currently no conflicts,
and these patches have been tested in linux-next.  Thanks.


The following changes since commit bfffbea1aaeeb1eb6500c83ff9653416daa5b490:

  Merge tag 'mmc-updates-for-3.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc (2013-07-10 11:16:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.12-rc1

for you to fetch changes up to 9d731e7539713acc0ec7b67a5a91357c455d2334:

  Revert "mmc: tmio-mmc: Remove .set_pwr() callback from platform data" (2013-09-06 07:29:05 -0400)

----------------------------------------------------------------
MMC highlights for 3.12:
Core:
 - Support Allocation Units 8MB-64MB in SD3.0, previous max was 4MB.
 - The slot-gpio helper can now handle GPIO debouncing card-detect.
 - Read supported voltages from DT "voltage-ranges" property.

Drivers:
 - dw_mmc: Add support for ARC architecture, and support exynos5420.
 - mmc_spi: Support CD/RO GPIOs.
 - sh_mobile_sdhi: Add compatibility for more Renesas SoCs.
 - sh_mmcif: Add DT support for DMA channels.

----------------------------------------------------------------
Amarinder Bindra (1):
      mmc: omap_hsmmc: use the generic config for omap2plus devices

Andy Shevchenko (2):
      mmc: dw_mmc-pci: get resources from a proper BAR
      mmc: dw_mmc-pci: enable bus-mastering mode

Boris BREZILLON (1):
      mmc: atmel-mci: prepare clk before calling enable

Chris Ball (1):
      Revert "mmc: tmio-mmc: Remove .set_pwr() callback from platform data"

Doug Anderson (1):
      mmc: dw_mmc: Handle DW_MCI_QUIRK_IDMAC_DTO properly

Fabio Estevam (2):
      mmc: mxs-mmc: Use devm_clk_get()
      mmc: mxs-mmc: Check the return value from stmp_reset_block()

Felipe Balbi (1):
      mmc: omap_hsmmc: fix dependency on indirect header inclusion

Francesco Lavra (1):
      mmc: omap_hsmmc: clear status flags before starting a new command

Franck Jullien (1):
      mmc: fix null pointer use in mmc_blk_remove_req

Guennadi Liakhovetski (6):
      mmc: tmio: fix compiler warning
      mmc: SDHI: add DT compatibility strings for further SoCs
      mmc: sh_mmcif: move header include from header into .c
      mmc: sh_mmcif: add support for Device Tree DMA bindings
      mmc: sh_mmcif: revision-specific Command Completion Signal handling
      mmc: sh_mmcif: revision-specific CLK_CTRL2 handling

Haijun Zhang (3):
      mmc: core: parse voltage from device-tree
      mmc: sdhci: get voltage from sdhc host
      mmc: esdhc: add support to get voltage from device-tree

Jaehoon Chung (3):
      mmc: sd: fix the maximum au_size for SD3.0
      mmc: sdhci-s3c: fix the wrong register value, when clock is disabled
      mmc: sdhci-s3c: initialize host->quirks2 for using quirks2

Jingoo Han (3):
      mmc: mmc_test: replace strict_strtol() with kstrtol_from_user()
      mmc: dw_mmc: add missing MFD_SYSCON dependency for SOCFPGA
      mmc: dw_mmc-pltfm: include 'dw_mmc-pltfm.h'

KOBAYASHI Yoshitake (1):
      mmc: block: fix a bug of error handling in MMC driver

Laurent Pinchart (13):
      mmc: slot-gpio: Add debouncing capability to mmc_gpio_request_cd()
      mmc: mmc_spi: Support CD/RO GPIOs
      ARM: ep93xx: vision_ep9307: Use MMC CD and RO GPIO
      sh: ecovec24: Use MMC/SDHI CD and RO GPIO
      sh: ecovec24: Remove mmcif .down_pwr() callback
      sh: ecovec24: Remove MMCIF and SDHI .set_pwr() callbacks
      mmc: mmc_spi: Remove platform data .get_cd() and .get_ro() callbacks
      mmc: sh_mmcif: Remove .down_pwr() callback from platform data
      mmc: sh_mmcif: Remove .set_pwr() callback from platform data
      mmc: sh_mobile_sdhi: Remove .get_cd() callback from platform data
      mmc: sh_mobile_sdhi: Remove .set_pwr() callback from platform data
      mmc: tmio-mmc: Remove .get_cd() callback from platform data
      mmc: tmio-mmc: Remove .set_pwr() callback from platform data

Minjian Wu (1):
      mmc: core: Set data timeout for mmc bus test commands (CMD14 and CMD19).

Mischa Jonker (1):
      mmc: dw_mmc: Add support for ARC

Sachin Kamat (2):
      mmc: sdhci-bcm2835: Staticize bcm2835_sdhci_get_min_clock
      mmc: vub300: Staticize vub300_init_card

Sergei Shtylyov (1):
      mmc: tmio_mmc_dma: fix PIO fallback on SDHI

Shawn Guo (1):
      mmc: sdhci: request irq after sdhci_init() is called

Wei WANG (2):
      mmc: host: Remove a duplicate line in Makefile
      mmc: core: free mmc_card if cmd 3,9,7 fails in mmc_sd_init_card

Wei Yongjun (1):
      mmc: jz4740: fix return value check in jz4740_mmc_probe()

Yuvaraj Kumar C D (1):
      mmc: dw_mmc: exynos: Add a new compatible string for exynos5420

 .../devicetree/bindings/mmc/fsl-esdhc.txt          |  4 +
 arch/arm/mach-ep93xx/vision_ep9307.c               | 57 ++------------
 arch/sh/boards/mach-ecovec24/setup.c               | 89 ++--------------------
 drivers/mmc/card/block.c                           | 47 +++++++++++-
 drivers/mmc/card/mmc_test.c                        | 14 +---
 drivers/mmc/core/core.c                            | 44 +++++++++++
 drivers/mmc/core/host.c                            |  2 +-
 drivers/mmc/core/mmc_ops.c                         |  1 +
 drivers/mmc/core/sd.c                              | 13 ++--
 drivers/mmc/core/slot-gpio.c                       | 14 +++-
 drivers/mmc/host/Kconfig                           | 10 +--
 drivers/mmc/host/Makefile                          |  2 -
 drivers/mmc/host/atmel-mci.c                       | 34 +++++++--
 drivers/mmc/host/dw_mmc-exynos.c                   |  9 ++-
 drivers/mmc/host/dw_mmc-pci.c                      |  4 +-
 drivers/mmc/host/dw_mmc-pltfm.c                    |  1 +
 drivers/mmc/host/dw_mmc.c                          | 21 +++--
 drivers/mmc/host/jz4740_mmc.c                      |  7 +-
 drivers/mmc/host/mmc_spi.c                         | 49 ++++++------
 drivers/mmc/host/mvsdio.c                          |  3 +-
 drivers/mmc/host/mxs-mmc.c                         | 22 ++++--
 drivers/mmc/host/of_mmc_spi.c                      | 46 +++--------
 drivers/mmc/host/omap_hsmmc.c                      |  3 +-
 drivers/mmc/host/sdhci-bcm2835.c                   |  2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  2 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |  1 +
 drivers/mmc/host/sdhci-pxav3.c                     |  3 +-
 drivers/mmc/host/sdhci-s3c.c                       |  8 +-
 drivers/mmc/host/sdhci-sirf.c                      |  2 +-
 drivers/mmc/host/sdhci.c                           |  7 +-
 drivers/mmc/host/sh_mmcif.c                        | 63 ++++++++++-----
 drivers/mmc/host/sh_mobile_sdhi.c                  | 23 ++----
 drivers/mmc/host/tmio_mmc_dma.c                    |  4 +-
 drivers/mmc/host/tmio_mmc_pio.c                    | 24 ++----
 drivers/mmc/host/vub300.c                          |  2 +-
 include/linux/mfd/tmio.h                           |  1 -
 include/linux/mmc/core.h                           |  2 +
 include/linux/mmc/sdhci.h                          |  1 +
 include/linux/mmc/sh_mmcif.h                       |  6 +-
 include/linux/mmc/sh_mobile_sdhi.h                 |  2 -
 include/linux/mmc/slot-gpio.h                      |  3 +-
 include/linux/spi/mmc_spi.h                        | 19 +++--
 42 files changed, 336 insertions(+), 335 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
