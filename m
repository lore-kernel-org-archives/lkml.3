Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaAZCUo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 21:20:44 -0500
Received: from void.printf.net ([89.145.121.20]:60702 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaAZCUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 21:20:42 -0500
From: Chris Ball <chris@printf.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.14-rc1
Date: Sun, 26 Jan 2014 02:20:40 +0000
Message-ID: <867g9n1o1z.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a new email address for me, but you still have a signed path
to it.  (This pull request updates MAINTAINERS with the new address.)

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.14-rc1

to receive the MMC merge for 3.14.  These patches have been tested in
linux-next, and there's a trivial MAINTAINERS conflict with the
resolution below.  Thanks.

diff --cc MAINTAINERS
index 1912139,518bf71..0000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -1406,9 -1371,7 +1406,10 @@@ T:	git git://git.xilinx.com/linux-xlnx.
  S:	Supported
  F:	arch/arm/mach-zynq/
  F:	drivers/cpuidle/cpuidle-zynq.c
 +N:	zynq
 +N:	xilinx
 +F:	drivers/clocksource/cadence_ttc_timer.c
+ F:	drivers/mmc/host/sdhci-of-arasan.c
  
  ARM SMMU DRIVER
  M:	Will Deacon <will.deacon@arm.com>


The following changes since commit 0e4b0743bbe5807535ba1b0389281f9a4c1b2bb7:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2013-11-26 11:18:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.14-rc1

for you to fetch changes up to 945be38caa287b177b8c17ffaae7754cab6a658f:

  mmc: sdhci-pci: Fix possibility of chip->fixes being null (2014-01-23 10:52:53 -0500)

----------------------------------------------------------------
MMC highlights for 3.14:

Core:
 - Avoid get_cd() on cards marked nonremovable.

Drivers:
 - arasan: New driver for controllers found in e.g. Xilinx Zynq SoC.
 - dwmmc: Support Hisilicon K3 SoC controllers.
 - esdhc-imx: Support for HS200 mode, DDR modes on MX6, runtime PM.
 - sdhci-pci: Support O2Micro/BayHubTech controllers used in laptops
   like Lenovo ThinkPad W540, Dell Latitude E5440, Dell Latitude E6540.
 - tegra: Support Tegra124 SoCs.

----------------------------------------------------------------
Adam Lee (2):
      mmc: sdhci-pci: break out definitions to header file
      mmc: sdhci-pci: add support of O2Micro/BayHubTech SD hosts

Adrian Hunter (3):
      mmc: sdhci: Allow for long command timeouts
      mmc: sdhci-pci: Fix BYT sd card getting stuck in runtime suspend
      mmc: sdhci-pci: Fix possibility of chip->fixes being null

Aisheng Dong (1):
      mmc: sdhci: fix lockdep error in tuning routine

Alexandre Belloni (1):
      mmc: atmel-mci: add vmmc-supply support

Bing Zhao (1):
      mmc: sdio: add a quirk for broken SDIO_CCCR_INTx polling

Chris Ball (1):
      MAINTAINERS: mmc: Update Chris Ball's email address.

Chuansheng Liu (1):
      mmc: sdhci: Setting the host->mrq to NULL before executing tuning

David Cohen (2):
      mmc: sdhci: add quirk for broken HS200 support
      mmc: sdhci-pci: add broken HS200 quirk for Intel Merrifield

Dong Aisheng (13):
      mmc: sdhci: clear auto cmd setting bits for no data cmds
      mmc: sdhci-esdhc-imx: add SDHCI_TRANSFER_MODE read function
      mmc: sdhci-esdhc-imx: fix cpas over write issue
      mmc: sdhci-esdhc-imx: add MMC_CAP_1_8V_DDR for mx6
      mmc: core: mmc DDR mode should not depend on UHS_DDR50
      mmc: sdhci-esdhc-imx: add eMMC HS200 mode support
      mmc: sdhci-pltfm: export pltfm suspend/resume api
      mmc: sdhci-esdhc-imx: tuning bits should not be cleared during reset
      mmc: esdhc-imx: clearing SDHCI_CTRL_EXEC_TUNING should not affect other bits
      mmc: sdhci-esdhc-imx: fix runtime pm unbalance issue
      mmc: sdhci-esdhc-imx: add runtime pm support
      mmc: sdhci-esdhc-imx: fix access hardirq-unsafe lock in atomic context
      mmc: sdhci-esdhc-imx: fix warning during module remove function

Fabio Estevam (1):
      mmc: sdhci-esdhc-imx: Use NULL instead of zero

Guennadi Liakhovetski (1):
      mmc: tmio: remove myself as a maintainer

Kuninori Morimoto (6):
      mmc: tmio: don't overwrite caps2
      mmc: tmio: use -EPROBE_DEFER if driver can't find regulator
      mmc: tmio: bus_shift become tmio_mmc_data member
      mmc: tmio: add new TMIO_MMC_HAVE_HIGH_REG flags
      mmc: SDHI: add SoC specific workaround via HW version
      mmc: tmio: fixup compile error

Laurent Pinchart (5):
      mmc: sh_mobile_sdhi: Convert to clk_prepare/unprepare
      mmc: sh_mmcif: Factorize DMA channel request and configuration code
      mmc: sh_mmcif: Fix compilation warning on 64-bit platforms
      mmc: sdhi: Enable driver compilation with COMPILE_TEST
      mmc: sh_mmcif: Enable driver compilation with COMPILE_TEST

Ludovic Desroches (1):
      mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

Mika Westerberg (1):
      mmc: sdhci-acpi: add new ACPI ID

Ray Jui (1):
      mmc: fix host release issue after discard operation

Sascha Hauer (6):
      mmc: Do not call get_cd for non removable cards
      mmc: mxs: use standard flag for non-removable status
      mmc: mxs: use standard flag for broken card detection
      mmc: mxs: use standard flag for cd inverted
      mmc: mxs: use mmc_gpio_get_ro for detecting read-only status
      mmc: mxs: use mmc_of_parse to parse devicetree properties

Soren Brinkmann (1):
      mmc: arasan: Add driver for Arasan SDHCI

Stephen Warren (1):
      mmc: tegra: add support for Tegra124

Wei Yongjun (1):
      mmc: dw_mmc: fix sparse non static symbol warning

Wolfram Sang (1):
      mmc: core: sd: implement proper support for sd3.0 au sizes

Zhangfei Gao (4):
      mmc: dw_mmc: use slot-gpio to handle cd pin
      mmc: dw_mmc: add dw_mmc-k3 for k3 platform
      mmc: dw_mmc: fix dw_mci_get_cd
      mmc: dw_mmc: k3: remove clk_table

 .../devicetree/bindings/mmc/arasan,sdhci.txt       |  27 ++
 .../devicetree/bindings/mmc/k3-dw-mshc.txt         |  46 +++
 MAINTAINERS                                        |   6 +-
 drivers/mmc/card/block.c                           |   7 +-
 drivers/mmc/core/core.c                            |   3 +-
 drivers/mmc/core/mmc.c                             |   8 +-
 drivers/mmc/core/quirks.c                          |   8 +
 drivers/mmc/core/sd.c                              |  37 ++-
 drivers/mmc/core/sdio_irq.c                        |  11 +
 drivers/mmc/host/Kconfig                           |  28 +-
 drivers/mmc/host/Makefile                          |   3 +
 drivers/mmc/host/atmel-mci.c                       |  20 +-
 drivers/mmc/host/dw_mmc-k3.c                       |  95 ++++++
 drivers/mmc/host/dw_mmc.c                          |  54 +++-
 drivers/mmc/host/mxs-mmc.c                         |  60 ++--
 drivers/mmc/host/sdhci-acpi.c                      |   2 +
 drivers/mmc/host/sdhci-esdhc-imx.c                 | 122 ++++++--
 drivers/mmc/host/sdhci-of-arasan.c                 | 224 ++++++++++++++
 drivers/mmc/host/sdhci-pci-o2micro.c               | 321 +++++++++++++++++++++
 drivers/mmc/host/sdhci-pci-o2micro.h               |  72 +++++
 drivers/mmc/host/sdhci-pci.c                       | 191 ++++--------
 drivers/mmc/host/sdhci-pci.h                       |  78 +++++
 drivers/mmc/host/sdhci-pltfm.c                     |   6 +-
 drivers/mmc/host/sdhci-pltfm.h                     |   2 +
 drivers/mmc/host/sdhci-tegra.c                     |   1 +
 drivers/mmc/host/sdhci.c                           |  44 ++-
 drivers/mmc/host/sh_mmcif.c                        | 100 +++----
 drivers/mmc/host/sh_mobile_sdhi.c                  |  23 +-
 drivers/mmc/host/tmio_mmc.c                        |   9 +
 drivers/mmc/host/tmio_mmc.h                        |  17 +-
 drivers/mmc/host/tmio_mmc_dma.c                    |   2 +-
 drivers/mmc/host/tmio_mmc_pio.c                    |  38 +--
 include/linux/mfd/tmio.h                           |   8 +
 include/linux/mmc/card.h                           |   8 +-
 include/linux/mmc/sdhci.h                          |   2 +
 include/linux/mmc/tmio.h                           |   1 +
 36 files changed, 1343 insertions(+), 341 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/k3-dw-mshc.txt
 create mode 100644 drivers/mmc/host/dw_mmc-k3.c
 create mode 100644 drivers/mmc/host/sdhci-of-arasan.c
 create mode 100644 drivers/mmc/host/sdhci-pci-o2micro.c
 create mode 100644 drivers/mmc/host/sdhci-pci-o2micro.h
 create mode 100644 drivers/mmc/host/sdhci-pci.h

-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
