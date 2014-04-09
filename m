Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbaDICz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:55:59 -0400
Received: from void.printf.net ([89.145.121.20]:38357 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbaDICz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:55:57 -0400
From: Chris Ball <chris@printf.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.15-rc1
Date: Wed, 09 Apr 2014 03:55:55 +0100
Message-ID: <86bnwbus78.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.15-rc1

to receive the MMC merge for 3.15.  These patches have been tested in
linux-next, and there are currently no conflicts.  There's a MAINTAINERS
update to add Ulf Hansson as MMC co-maintainer.  Thanks.
  
The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.15-rc1

for you to fetch changes up to c67480173f72e883235dd0ad09d90156c8f87600:

  mmc: sdhci-acpi: Intel SDIO has broken card detect (2014-04-07 21:27:14 -0400)

----------------------------------------------------------------
MMC highlights for 3.15:

Core:
 - CONFIG_MMC_UNSAFE_RESUME=y is now default behavior.
 - DT bindings for SDHCI UHS, eMMC HS200, high-speed DDR, at 1.8/1.2V.
 - Add GPIO descriptor based slot-gpio card detect API.

Drivers:
 - dw_mmc: Refactor SOCFPGA support as a variant inside dw_mmc-pltfm.c.
 - mmci: Support HW busy detection on ux500.
 - omap: Support MMC_ERASE.
 - omap_hsmmc: Support MMC_PM_KEEP_POWER, MMC_PM_WAKE_SDIO_IRQ, (a)cmd23.
 - rtsx: Support pre-req/post-req async.
 - sdhci: Add support for Realtek RTS5250 controllers.
 - sdhci-acpi: Add support for 80860F16, fix 80860F14/SDIO card detect.
 - sdhci-msm: Add new driver for Qualcomm SDHCI chipset support.
 - sdhci-pxav3: Add support for Marvell Armada 380 and 385 SoCs.

----------------------------------------------------------------
Adrian Hunter (7):
      mmc: slot-gpio: Record GPIO descriptors instead of GPIO numbers
      mmc: slot-gpio: Split out CD IRQ request into a separate function
      mmc: slot-gpio: Add GPIO descriptor based CD GPIO API
      mmc: sdhci-acpi: Fix broken card detect for ACPI HID 80860F14
      mmc: sdhci-acpi: Add device id 80860F16
      mmc: sdhci: Allow for irq being shared
      mmc: sdhci-acpi: Intel SDIO has broken card detect

Arend van Spriel (1):
      sdhci: only reprogram retuning timer when flag is set

Balaji T K (14):
      mmc: omap_hsmmc: use devm_regulator API
      mmc: omap_hsmmc: handle vcc and vcc_aux independently
      regulator: add pbias regulator support
      mmc: omap_hsmmc: adapt hsmmc to use pbias regulator
      ARM: dts: add pbias dt node
      ARM: OMAP: enable SYSCON and REGULATOR_PBIAS in omap2plus_defconfig
      mmc: omap_hsmmc: remove pbias workaround
      mmc: omap_hsmmc: fix return error code for of_get_hsmmc_pdata
      mmc: omap_hsmmc: remove redundant reset done
      mmc: omap_hsmmc: save clock rate to use in interrupt context
      mmc: omap_hsmmc: fix request done for sbc error case
      mmc: omap_hsmmc: split dma setup
      mmc: omap_hsmmc: add cmd23 support
      mmc: omap_hsmmc: add autocmd23 support

Chris Ball (1):
      Revert "dts: socfpga: Add support for SD/MMC on the SOCFPGA platform"

Christian Daudt (1):
      mmc: rename ARCH_BCM to ARCH_BCM_MOBILE

Dan Carpenter (1):
      mmc: omap_hsmmc: remove a duplicative test

Daniel Mack (1):
      mmc: omap_hsmmc: support more DT properties

Dinh Nguyen (3):
      mmc: dw_mmc-socfpga: Remove the SOCFPGA specific platform for dw_mmc
      mmc: dw_mmc: Add support for SOCFPGA's platform specific implementation
      dts: socfpga: Add support for SD/MMC on the SOCFPGA platform

Felipe Balbi (1):
      mmc: dw_mmc: fix possible build error

Georgi Djakov (3):
      mmc: sdhci-msm: Qualcomm SDHCI binding documentation
      mmc: sdhci-msm: Initial support for Qualcomm chipsets
      mmc: sdhci-msm: Add platform_execute_tuning implementation

Jaehoon Chung (1):
      mmc: core: Add DT bindings for eMMC HS200 1.8/1.2V

Jarkko Nikula (7):
      mmc: omap: Fix NULL pointer dereference due uninitialized cover_tasklet
      mmc: omap: Convert to devm_kzalloc
      mmc: omap: Remove duplicate host->irq assignment
      mmc: omap: Remove mem_res field from struct mmc_omap_host
      mmc: omap: Convert to devm_ioremap_resource
      mmc: omap: Remove always set use_dma flag from struct mmc_omap_host
      mmc: omap: Add erase capability

Kuninori Morimoto (5):
      mmc: sdhi: tidyup sh_mobile_sdhi_of_match position
      mmc: sdhi: update sh_mobile_sdhi_of_data for r8a7778
      mmc: sdhi: update sh_mobile_sdhi_of_data for r8a7779
      mmc: sdhi: update sh_mobile_sdhi_of_data for r8a7790
      mmc: sdhi: update sh_mobile_sdhi_of_data for r8a7791

Marcin Wojtas (1):
      mmc: sdhci-pxav3: add support for the Armada 38x SDHCI controller

Micky Ching (4):
      mmc: sdhci: add support for realtek rts5250
      mmc: rtsx: fix card poweroff bug
      mmc: rtsx: modify phase searching method for tuning
      mmc: rtsx: add support for pre_req and post_req

Nishanth Menon (2):
      mmc: omap_hsmmc: Add support for quirky omap3 hsmmc controller
      ARM: dts: omap3-ldp: fix mmc configuration

Russell King (6):
      mmc: sdhci-bcm-kona: fix build errors when built-in
      mmc: sdhci-spear: fix error handling paths for DT
      mmc: sdhci-spear: fix platform_data usage
      mmc: sdhci-spear: simplify resource handling
      mmc: sdhci-spear: remove support for power gpio
      mmc: sdhci-spear: use generic card detection gpio support

Sachin Kamat (10):
      mmc: ushc: Fix incorrect parameter in sizeof
      mmc: wmt-sdmmc: Fix NULL pointer dereference
      mmc: sdhci-spear: Fix NULL pointer dereference
      mmc: davinci: Remove redundant of_match_ptr
      mmc: dw_mmc: Remove redundant of_match_ptr
      mmc: sdhci-dove: Remove redundant of_match_ptr
      mmc: dw_mmc: Add missing description
      mmc: msm: Cleanup mmc-msm_sdcc.h header
      mmc: mvsdio: Cleanup mmc-mvsdio.h header
      mmc: dw_mmc: Fix NULL pointer dereference

Tim Kryger (1):
      mmc: sdhci-bcm-kona: Add basic use of clocks

Tomasz Figa (6):
      mmc: sdhci-s3c: Use shifts to divide by powers of two
      mmc: sdhci-s3c: Cache bus clock rates
      mmc: sdhci-s3c: Use correct condition to check for clock presence
      mmc: sdhci-s3c: Simplify min/max clock calculation
      mmc: sdhci-s3c: Fix handling of bus clock switching
      mmc: sdhci-s3c: Do not allow frequencies higher than requested

Ulf Hansson (26):
      mmc: sh_mobile_sdhi: Use modern PM macros to define pm callbacks
      mmc: tmio_mmc: Convert from legacy to modern PM ops
      mmc: tmio: Adapt to proper PM configs for exported functions
      mmc: core: Use MMC_UNSAFE_RESUME as default behavior
      mmc: core: Remove unnecessary validations for bus_ops callbacks
      mmc: card: Remove host cap MMC_CAP2_SANITIZE
      mmc: core: Remove unused host cap MMC_CAP2_BROKEN_VOLTAGE
      mmc: core: Remove support for MMC_CAP2_NO_SLEEP_CMD
      mmc: core: Use mmc_flush_cache() during mmc suspend
      mmc: core: Enable MMC_CAP2_CACHE_CTRL as default
      mmc: core: Add DT bindings for SD card's UHS bus speed modes
      mmc: core: Add DT bindings for eMMC high-speed DDR 1.8/1.2V
      MAINTAINERS: Add maintainer for the mmc subsystem
      mmc: core: Rename max_discard_to to max_busy_timeout
      mmc: core: Rename cmd_timeout_ms to busy_timeout
      mmc: core: Add ignore_crc flag to __mmc_switch
      mmc: core: Minor simplifications to __mmc_switch
      mmc: core: Fixup busy detection for mmc switch operations
      mmc: core: Use generic CMD6 time while switching to eMMC HS200 mode
      mmc: core: Respect host's max_busy_timeout when sending sleep cmd
      mmc: block: Use R1 responses for stop cmds for read requests
      mmc: block: Implement card_busy_detect() for busy detection
      mmc: block: Respect hw busy detection in card_busy_detect()
      mmc: block: Fixup busy detection while invoking stop cmd at recovery
      mmc: mmci: Handle CMD irq before DATA irq
      mmc: mmci: Enable support for busy detection for ux500 variant

 Documentation/devicetree/bindings/mmc/mmc.txt      |   9 +
 .../devicetree/bindings/mmc/sdhci-msm.txt          |  55 ++
 .../devicetree/bindings/mmc/sdhci-pxa.txt          |  17 +-
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   1 +
 .../bindings/regulator/pbias-regulator.txt         |  27 +
 MAINTAINERS                                        |   1 +
 arch/arm/boot/dts/dra7.dtsi                        |  17 +
 arch/arm/boot/dts/omap2430.dtsi                    |  17 +
 arch/arm/boot/dts/omap3-ldp.dts                    |  23 +
 arch/arm/boot/dts/omap3.dtsi                       |  17 +
 arch/arm/boot/dts/omap4.dtsi                       |  17 +
 arch/arm/boot/dts/omap5.dtsi                       |  17 +
 arch/arm/configs/omap2plus_defconfig               |   2 +
 drivers/mfd/rtsx_pcr.c                             | 132 +++--
 drivers/mmc/card/block.c                           | 181 +++---
 drivers/mmc/core/Kconfig                           |  15 -
 drivers/mmc/core/bus.c                             |  12 +-
 drivers/mmc/core/core.c                            |  87 +--
 drivers/mmc/core/host.c                            |  18 +
 drivers/mmc/core/mmc.c                             |  65 +--
 drivers/mmc/core/mmc_ops.c                         |  64 ++-
 drivers/mmc/core/sd.c                              |  23 +-
 drivers/mmc/core/slot-gpio.c                       | 180 ++++--
 drivers/mmc/host/Kconfig                           |  23 +-
 drivers/mmc/host/Makefile                          |   2 +-
 drivers/mmc/host/davinci_mmc.c                     |   4 +-
 drivers/mmc/host/dw_mmc-k3.c                       |   2 +
 drivers/mmc/host/dw_mmc-pltfm.c                    |  12 +-
 drivers/mmc/host/dw_mmc-socfpga.c                  | 138 -----
 drivers/mmc/host/dw_mmc.c                          |   2 +-
 drivers/mmc/host/dw_mmc.h                          |   3 +-
 drivers/mmc/host/mmci.c                            |  54 +-
 drivers/mmc/host/mmci.h                            |   2 +
 drivers/mmc/host/omap.c                            |  93 ++--
 drivers/mmc/host/omap_hsmmc.c                      | 242 +++++---
 drivers/mmc/host/rtsx_pci_sdmmc.c                  | 529 +++++++++++++-----
 drivers/mmc/host/sdhci-acpi.c                      |  80 +--
 drivers/mmc/host/sdhci-bcm-kona.c                  |  39 +-
 drivers/mmc/host/sdhci-dove.c                      |   2 +-
 drivers/mmc/host/sdhci-msm.c                       | 618 +++++++++++++++++++++
 drivers/mmc/host/sdhci-pci.c                       |  20 +
 drivers/mmc/host/sdhci-pxav3.c                     |  68 +++
 drivers/mmc/host/sdhci-s3c.c                       | 170 +++---
 drivers/mmc/host/sdhci-spear.c                     | 199 ++-----
 drivers/mmc/host/sdhci.c                           |  24 +-
 drivers/mmc/host/sh_mobile_sdhi.c                  |  50 +-
 drivers/mmc/host/tmio_mmc.c                        |  30 +-
 drivers/mmc/host/tmio_mmc.h                        |   7 +-
 drivers/mmc/host/tmio_mmc_pio.c                    |   7 +-
 drivers/mmc/host/ushc.c                            |   2 +-
 drivers/mmc/host/wmt-sdmmc.c                       |   4 +-
 drivers/regulator/Kconfig                          |   9 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/pbias-regulator.c                | 255 +++++++++
 include/linux/mfd/rtsx_common.h                    |   1 +
 include/linux/mfd/rtsx_pci.h                       |   8 +-
 include/linux/mmc/core.h                           |   4 +-
 include/linux/mmc/host.h                           |  13 +-
 include/linux/mmc/sdhci-spear.h                    |   8 -
 include/linux/mmc/sdhci.h                          |   2 +
 include/linux/mmc/slot-gpio.h                      |   6 +
 include/linux/platform_data/mmc-msm_sdcc.h         |   7 +-
 include/linux/platform_data/mmc-mvsdio.h           |   6 +-
 63 files changed, 2577 insertions(+), 1166 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/pbias-regulator.txt
 delete mode 100644 drivers/mmc/host/dw_mmc-socfpga.c
 create mode 100644 drivers/mmc/host/sdhci-msm.c
 create mode 100644 drivers/regulator/pbias-regulator.c

-- 
Chris Ball   <http://printf.net/>
