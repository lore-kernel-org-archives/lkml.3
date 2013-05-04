Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab3EDOHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 10:07:31 -0400
Received: from void.printf.net ([89.145.121.20]:34346 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070Ab3EDOH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 10:07:29 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.10-rc1
Date: Sat, 04 May 2013 10:07:24 -0400
Message-ID: <87vc6y6dpf.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.10-rc1

to receive the MMC merge for 3.10.  There are currently no conflicts,
and these patches have been tested in linux-next.  Thanks.


  The following changes since commit 908ab9368866e6edf0edebdd546adefd5f3128f9:

  ARM: dts: tegra: fix the activate polarity of cd-gpio in mmc host (2013-03-11 14:25:10 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.10-rc1

for you to fetch changes up to e4404fab2e0b70287a471a1e760c9338ce683fde:

  mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE (2013-04-23 15:05:57 -0400)

----------------------------------------------------------------
MMC highlights for 3.10:

Core:
 - Introduce MMC_CAP2_NO_PRESCAN_POWERUP to allow skipping mmc_power_up()
   at boot/initialization time if it's already happened, for performance
   (faster boot time) reasons.
 - Fix a bit width test failure that resulted in old eMMC cards being put
   into 1-bit mode when 4-bit mode was available.
 - Expose fwrev/hwrev for MMCv4 parts.
 - Improve card removal logic in the case where the card's removed slowly;
   we were missing card removal events if the card retained contact with
   the slot pads for long enough to reply to a CMD13 while being removed.

Drivers:
 - davinci_mmc: Support using PIO instead of DMA.
 - dw_mmc: Add support for Exynos4412.
 - mxcmmc: DT support, use slot-gpio API.
 - mxs-mmc: Add broken-cd/cd-inverted/non-removable DT property support.
 - sdhci-sirf: New sdhci-pltfm driver for CSR SiRF SoCs:
    SiRFprimaII: unicore ARM Cortex-A9
    SiRFatlas6: unicore ARM Cortex-A9
    SiRFmarco: dual core ARM Cortex-A9 SMP
 - sdhci-tegra: Add support for Tegra114 platforms, use mmc_of_parse().

----------------------------------------------------------------
Aaron Lu (1):
      mmc: sdio: bind acpi with sdio function device

Adrian Hunter (3):
      Revert "mmc: core: wait while adding MMC host to ensure root mounts successfully"
      mmc: core: fix performance regression initializing MMC host controllers
      mmc: core: fix init controller performance regression, updated patch

Alexander Shiyan (1):
      mmc: mxcmmc: Fix bug when card is present during boot

Alexandru Gheorghiu (1):
      mmc: wmt-sdmmc: Use resource_size()

Anatolij Gustschin (5):
      mmc: mxcmmc: fix race conditions for host->req and host->data access
      mmc: mxcmmc: add mpc512x SDHC support
      mmc: mxcmmc: use slot-gpio API for write-protect detection
      mmc: mxcmmc: constify mxcmci_devtype
      mmc: mxcmmc: enable DMA support on mpc512x

Arnd Bergmann (1):
      mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE

Barry Song (1):
      mmc: sdhci-sirf: add mmc host sdhci-pltfm based driver for SiRF SoCs

Bernie Thompson (1):
      mmc: core: Add in support to expose PRV for v4 MMCs

Chris Ball (2):
      Merge tag 'tegra-for-3.10-fixes-for-mmc' of git://git.kernel.org/.../swarren/linux-tegra into mmc-next
      mmc: sdhci: Don't ignore regulator_enable() return value

Chunhe Lan (1):
      mmc: sdhci-pltfm: Fix timeout on t4240's sdhci controller

Dongjin Kim (1):
      mmc: dw_mmc: Add MSHC compatible for Exynos4412

Hector Palacios (1):
      mmc: mxs-mmc: add broken-cd property

Hyeonsu Kim (1):
      mmc: dw_mmc: fixed a wrong UHS_REG 16 bit clear

Jaehoon Chung (2):
      mmc: dw_mmc: return the result of mmc_add_host()
      mmc: dw_mmc: control the power-enable register

James Hogan (2):
      mmc: dw_mmc: setpower on MMC_POWER_{UP,OFF}
      mmc: dw_mmc: move host->data_offset init earlier

Jan Luebbe (1):
      mmc: omap_hsmmc: support deferred probing for GPIOs

Jingoo Han (4):
      mmc: sdhci-s3c: Use devm_clk_get()
      mmc: davinci_mmc: use module_platform_driver_probe()
      mmc: mvsdio: use module_platform_driver_probe()
      mmc: sdhci-spear: add CONFIG_PM_SLEEP to suspend/resume functions

Johan Hovold (1):
      mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload

Joseph Lo (1):
      mmc: tegra: use mmc_of_parse to get the support of standard MMC DT bindings

Kevin Liu (6):
      mmc: core: enhance card removal judgement for slow removal
      mmc: sdhci: add get_cd() implementation
      mmc: sdhci-pxav3: transfer sdhci_pltfm_data as args to sdhci_pltfm_init
      mmc: sdhci-pxav3: remove cd-broken quirk for permanently present card
      mmc: sdhci-pxav3: enhance device tree parser code
      mmc: sdhci-pxav3: controller should use SDCLK for timeout calculation

Kyoungil Kim (1):
      mmc: dw_mmc: empty FIFO after data transfer over interrupt in pio mode

Lars-Peter Clausen (3):
      mmc: sdhci_pltfm: Constify sdhci_pltfm_data
      mmc: sdhci-pltfm: Constify the ops field of sdhci_pltfm_data struct
      mmc: sdhci: Constify sdhci_ops structs where possible

Li Fei (1):
      mmc: core: call pm_runtime_put_noidle in pm_runtime_get_sync failed case

Manjunathappa, Prakash (1):
      mmc: davinci_mmc: allow driver to work without DMA resource

Marc Kleine-Budde (2):
      mmc: mxs-mmc: add cd-inverted property
      mmc: mxs-mmc: add non-removable property

Markos Chandras (3):
      mmc: dw_mmc: Don't loop when handling an interrupt
      mmc: dw_mmc: Avoid adding the number of transmitted bytes twice
      mmc: dw_mmc: Handle unaligned data submission correctly

Markus Pargmann (1):
      mmc: mxcmmc: DT support

Philip Rakity (1):
      mmc: core: Fix bit width test failing on old eMMC cards

Rhyland Klein (2):
      mmc: sdhci-tegra: cleanup ifdefs
      mmc: sdhci-tegra: add basic support for Tegra114

Sachin Kamat (4):
      mmc: dw_mmc: Make dw_mci_exynos_probe static
      mmc: dw_mmc: exynos: Remove unnecessary use of of_match_ptr()
      mmc: dw_mmc: Check return value of regulator_enable
      mmc: dw_mmc: Use pr_info instead of printk

Sergey Yanovich (1):
      mmc: core: wait while adding MMC host to ensure root mounts successfully

Seungwon Jeon (2):
      mmc: block: fix the host's claim-release in special request
      mmc: dw_mmc: fix fifo access for 64-bit

Silviu-Mihai Popescu (1):
      mmc: android-goldfish: use resource_size()

Terry Barnaby (1):
      mmc: atmel-mci: pio hang on block errors

Thomas Abraham (2):
      mmc: sdhci-s3c: let device core setup the default pin configuration
      mmc: dw_mmc: let device core setup the default pin configuration

Thomas Petazzoni (2):
      mmc: mvsdio: fix non-DT probing of GPIOs
      mmc: mvsdio: use dev_*() API instead of pr_*() API

Wei WANG (1):
      mmc: rtsx_pci_sdmmc: Don't execute power up sequence repeatedly

Wei Yongjun (1):
      mmc: wmt-sdmmc: remove unused variable in wmt_complete_data_request()

 .../devicetree/bindings/mmc/fsl-imx-mmc.txt        |  24 ++
 .../devicetree/bindings/mmc/samsung-sdhci.txt      |  35 +--
 .../devicetree/bindings/mmc/sdhci-sirf.txt         |  18 ++
 Documentation/mmc/mmc-dev-attrs.txt                |   1 +
 MAINTAINERS                                        |   1 +
 arch/arm/configs/at91sam9g45_defconfig             |   1 -
 arch/avr32/configs/favr-32_defconfig               |   1 -
 arch/avr32/configs/merisc_defconfig                |   1 -
 arch/powerpc/boot/dts/mpc5121.dtsi                 |   2 +
 drivers/mmc/card/block.c                           |  10 +-
 drivers/mmc/card/queue.c                           |   3 -
 drivers/mmc/card/queue.h                           |   2 +
 drivers/mmc/core/core.c                            |  18 +-
 drivers/mmc/core/mmc.c                             |   5 +-
 drivers/mmc/core/sdio.c                            |   4 +-
 drivers/mmc/core/sdio_bus.c                        |  23 +-
 drivers/mmc/host/Kconfig                           |  31 +--
 drivers/mmc/host/Makefile                          |   1 +
 drivers/mmc/host/android-goldfish.c                |   2 +-
 drivers/mmc/host/atmel-mci.c                       |  16 +-
 drivers/mmc/host/davinci_mmc.c                     |  23 +-
 drivers/mmc/host/dw_mmc-exynos.c                   |  54 +---
 drivers/mmc/host/dw_mmc.c                          | 153 ++++++-----
 drivers/mmc/host/dw_mmc.h                          |   3 -
 drivers/mmc/host/mvsdio.c                          |  54 ++--
 drivers/mmc/host/mxcmmc.c                          | 296 +++++++++++++++------
 drivers/mmc/host/mxs-mmc.c                         |  15 +-
 drivers/mmc/host/omap_hsmmc.c                      |  14 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  10 +
 drivers/mmc/host/sdhci-acpi.c                      |   2 +
 drivers/mmc/host/sdhci-bcm2835.c                   |   4 +-
 drivers/mmc/host/sdhci-cns3xxx.c                   |   4 +-
 drivers/mmc/host/sdhci-dove.c                      |   4 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   4 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   4 +-
 drivers/mmc/host/sdhci-of-hlwd.c                   |   4 +-
 drivers/mmc/host/sdhci-pci.c                       |   4 +-
 drivers/mmc/host/sdhci-pltfm.c                     |   7 +-
 drivers/mmc/host/sdhci-pltfm.h                     |   6 +-
 drivers/mmc/host/sdhci-pxav2.c                     |   2 +-
 drivers/mmc/host/sdhci-pxav3.c                     |  49 ++--
 drivers/mmc/host/sdhci-s3c.c                       |  88 +-----
 drivers/mmc/host/sdhci-sirf.c                      | 193 ++++++++++++++
 drivers/mmc/host/sdhci-spear.c                     |   4 +-
 drivers/mmc/host/sdhci-tegra.c                     | 124 ++-------
 drivers/mmc/host/sdhci.c                           |  39 ++-
 drivers/mmc/host/wmt-sdmmc.c                       |   4 +-
 include/linux/mmc/card.h                           |   1 +
 include/linux/mmc/host.h                           |   3 +
 49 files changed, 824 insertions(+), 547 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/fsl-imx-mmc.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-sirf.txt
 create mode 100644 drivers/mmc/host/sdhci-sirf.c

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
