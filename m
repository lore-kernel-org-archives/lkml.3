Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab3BXUE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 15:04:29 -0500
Received: from void.printf.net ([89.145.121.20]:35894 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172Ab3BXUE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 15:04:27 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.9-rc1
Date: Sun, 24 Feb 2013 15:04:22 -0500
Message-ID: <87r4k5bhrt.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.9-rc1

to receive the MMC merge for 3.9.  There are currently no conflicts,
and these patches have been tested in linux-next.  Thanks.


The following changes since commit 7810cc1e7721220f1ed2a23ca95113d6434f6dcd:

  digsig: Fix memory leakage in digsig_verify_rsa() (2013-02-01 15:59:33 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.9-rc1

for you to fetch changes up to 0e786102949d7461859c6ce9f39c2c8d28e42db3:

  mmc: tegra: assume CONFIG_OF, remove platform data (2013-02-24 14:37:26 -0500)

----------------------------------------------------------------
MMC highlights for 3.9:

Core:
 - Support for packed commands in eMMC 4.5.  (This requires a host
   capability to be turned on.  It increases write throughput by 20%+,
   but may also increase average write latency; more testing needed.)
 - Add DT bindings for capability flags.
 - Add mmc_of_parse() for shared DT parsing between drivers.

Drivers:
 - android-goldfish: New MMC driver for the Android Goldfish emulator.
 - mvsdio: Add DT bindings, pinctrl, use slot-gpio for card detection.
 - omap_hsmmc: Fix boot hangs with RPMB partitions.
 - sdhci-bcm2835: New driver for controller used by Raspberry Pi.
 - sdhci-esdhc-imx: Add 8-bit data, auto CMD23 support, use slot-gpio.
 - sh_mmcif: Add support for eMMC DDR, bundled MMCIF IRQs.
 - tmio_mmc: Add DT bindings, support for vccq regulator.

----------------------------------------------------------------
Andy Shevchenko (1):
      mmc: sdhci: introduce sdhci_update_clock helper to re-enable clock

Balaji T K (2):
      mmc: core: expose RPMB partition only for CMD23 capable hosts
      mmc: MAINTAINERS update for omap_hsmmc

Doug Anderson (5):
      mmc: dw_mmc: Add "disable-wp" device tree property
      ARM: dts: Add disable-wp for sd card slot on smdk5250
      mmc: dw_mmc: exynos: Remove code for wp-gpios
      mmc: dw_mmc: Handle wp-gpios from device tree
      mmc: dw_mmc: Remove DW_MCI_QUIRK_NO_WRITE_PROTECT

Fabio Estevam (4):
      mmc: mxs-mmc: Add MODULE_ALIAS()
      mmc: mxs-mmc: Fix warning due to incorrect type
      mmc: sdhci-esdhc-imx: Remove unused variables
      mmc: sdhci: Fix parameter of sdhci_do_start_signal_voltage_switch()

Guennadi Liakhovetski (20):
      mmc: sh_mmcif: fix missing and consolidate IO completion timeouts
      mmc: sh_mmcif: (cosmetic) simplify boolean return blocks
      mmc: sh_mmcif: fix a race, causing an Oops on SMP
      mmc: sh_mmcif: reset error code for any opcode
      mmc: sh_mmcif: reset DMA completion immediately before starting DMA
      mmc: sh_mmcif: fix I/O errors
      mmc: sh_mmcif: simplify IRQ processing
      mmc: fix DT binding documentation SDHCI left-over
      mmc: sdhi, tmio: only check flags in tmio-mmc driver proper
      mmc: detailed definition of CD and WP MMC line polarities in DT
      mmc: provide a standard MMC device-tree binding parser centrally
      mmc: (cosmetic) remove "extern" from function declarations
      mmc: sh_mmcif: use mmc_of_parse() to parse standard MMC DT bindings
      mmc: tmio-mmc: define device-tree bindings
      mmc: tmio-mmc: parse device-tree bindings
      mmc: sh_mobile_sdhi: remove unused .pdata field
      mmc: sh_mobile_sdhi: use managed resource allocations
      mmc: tmio: remove unused and deprecated symbols
      mmc: tmio: add support for the VccQ regulator
      mmc: add DT bindings for more MMC capability flags

Jaehoon Chung (1):
      mmc: core: fix indentation

Johan Rudholm (5):
      mmc: sd: Simplify by using mmc_host_uhs
      mmc: core: Add mmc_power_cycle
      mmc: core: Add card_busy to host_ops
      mmc: core: Break out start_signal_voltage_switch
      mmc: core: Fixup signal voltage switch

Kevin Liu (6):
      mmc: sdhci: disable interrupt before free_irq
      mmc: sdhci: add IRQ wake up support
      mmc: sdhci-pxav3: add IRQ wake up support
      mmc: sdhci: update signal voltage switch code
      mmc: sdhci: enhance preset value function
      mmc: sdhci-pxav3: add pm runtime support

Konstantin Dorfman (1):
      mmc: fix async request mechanism for sequential read scenarios

Lars-Peter Clausen (1):
      mmc: sdhci-pltfm: Add a common clk API implementation of get_timeout_clock

Marek Szyprowski (2):
      mmc: use regulator_can_change_voltage() instead of regulator_count_voltages
      mmc: sdhci: check voltage range only on regulators aware of voltage value

Maya Erez (1):
      mmc: core: move the cache disabling operation to mmc_suspend

Mike Lockwood (1):
      mmc: goldfish: emulated MMC device

Roger Tseng (1):
      mmc: rtsx: remove driving adjustment

Roland Stigge (1):
      mmc: mmc_spi: Fix return value evaluation of irq_of_parse_and_map()

Sascha Hauer (2):
      mmc: sdhci: rename platform_8bit_width to platform_bus_width
      mmc: sdhci-esdhc-imx: support 8bit mode

Seungwon Jeon (6):
      mmc: queue: exclude asynchronous transfer for special request
      MAINTAINERS: mmc: add maintainer entry for dw_mmc driver
      mmc: core: fix permanent sleep of mmcqd during card removal
      mmc: block: don't start new request when the card is removed
      mmc: add packed command feature of eMMC4.5
      mmc: support packed write command for eMMC4.5 devices

Shawn Guo (12):
      mmc: sdhci: query card presence from cd-gpio before asking SDHCI
      mmc: slot-gpio: use devm_* managed functions to ease users
      mmc: remove unncessary mmc_gpio_free_cd() call from slot-gpio users
      mmc: sdhci-esdhc-imx: use slot-gpio helpers for CD and WP
      mmc: sdhci-esdhc-imx: remove ESDHC_CD_GPIO handling from IO accessory
      mmc: sdhci-esdhc-imx: fix host version read
      mmc: sdhci-esdhc-imx: remove D3CD check from SDHCI_HOST_CONTROL write
      mmc: sdhci-esdhc-imx: name esdhc specific definitions with ESDHC_ prefix
      mmc: sdhci-esdhc-imx: separate transfer mode from command write for usdhc
      mmc: sdhci-esdhc-imx: manually reset MIX_CTRL for usdhc
      mmc: sdhci-esdhc-imx: Auto CMD23 support for usdhc
      mmc: dt: bus-width can be an optional property

Shinya Kuribayashi (1):
      mmc: sh_mmcif: add support for bundled MMCIF IRQs

Stephen Warren (3):
      mmc: add BCM2835 driver
      mmc: bcm2835: set SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK
      mmc: tegra: assume CONFIG_OF, remove platform data

Subhash Jadavani (2):
      mmc: sdio: fix resume failure due to lack of CMD52 reset
      mmc: sdio: print correct UHS mode during card detection

Sujit Reddy Thumma (1):
      mmc: sdio: Fix SDIO 3.0 UHS-I initialization sequence

Teppei Kamijou (7):
      mmc: sh_mmcif: force to fail CMD52 immediately
      mmc: sh_mmcif: ensure run-time suspend call is processed before suspend
      mmc: sh_mmcif: Add support for eMMC Dual Data Rate
      mmc: sh_mmcif: Use msecs_to_jiffies() for host->timeout
      mmc: sh_mmcif: Avoid unnecessary mmc_delay() at mmc_card_sleepawake()
      mmc: sh_mmcif: Terminate DMA transactions when detecting timeout or error
      mmc: sh_mmcif: report all errors

Thomas Petazzoni (4):
      mmc: mvsdio: use slot-gpio infrastructure for write protect gpio
      mmc: mvsdio: use slot-gpio for card detect gpio
      mmc: mvsdio: implement a Device Tree binding
      mmc: mvsdio: add pinctrl integration

Tony Prisk (1):
      mmc: vt8500: Remove erroneous __exitp in wmt_mci_driver

Zhang, YiX X (1):
      mmc: correct the EXCEPTION_EVENTS_STATUS value in comment

 .../devicetree/bindings/mmc/brcm,bcm2835-sdhci.txt |  18 +
 Documentation/devicetree/bindings/mmc/mmc.txt      |  34 +-
 .../devicetree/bindings/mmc/orion-sdio.txt         |  17 +
 .../devicetree/bindings/mmc/synopsis-dw-mshc.txt   |  12 +-
 Documentation/devicetree/bindings/mmc/tmio_mmc.txt |  20 +
 MAINTAINERS                                        |  10 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   1 +
 drivers/mmc/card/block.c                           | 491 +++++++++++++++++-
 drivers/mmc/card/queue.c                           | 128 ++++-
 drivers/mmc/card/queue.h                           |  25 +
 drivers/mmc/core/bus.c                             |   1 +
 drivers/mmc/core/core.c                            | 246 ++++++++-
 drivers/mmc/core/core.h                            |   6 +-
 drivers/mmc/core/host.c                            | 123 +++++
 drivers/mmc/core/mmc.c                             |  46 +-
 drivers/mmc/core/mmc_ops.c                         |   1 +
 drivers/mmc/core/sd.c                              |  44 +-
 drivers/mmc/core/sdio.c                            |  54 +-
 drivers/mmc/core/slot-gpio.c                       |  57 ++-
 drivers/mmc/host/Kconfig                           |  18 +
 drivers/mmc/host/Makefile                          |   2 +
 drivers/mmc/host/android-goldfish.c                | 570 +++++++++++++++++++++
 drivers/mmc/host/dw_mmc-exynos.c                   |  10 -
 drivers/mmc/host/dw_mmc.c                          |  69 ++-
 drivers/mmc/host/mvsdio.c                          | 131 +++--
 drivers/mmc/host/mxs-mmc.c                         |   3 +-
 drivers/mmc/host/of_mmc_spi.c                      |   2 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   5 -
 drivers/mmc/host/sdhci-bcm2835.c                   | 210 ++++++++
 drivers/mmc/host/sdhci-esdhc-imx.c                 | 230 +++++----
 drivers/mmc/host/sdhci-pci.c                       |   4 +-
 drivers/mmc/host/sdhci-pltfm.c                     |   8 +
 drivers/mmc/host/sdhci-pltfm.h                     |   2 +
 drivers/mmc/host/sdhci-pxav2.c                     |  11 +-
 drivers/mmc/host/sdhci-pxav3.c                     | 117 ++++-
 drivers/mmc/host/sdhci-s3c.c                       |   8 +-
 drivers/mmc/host/sdhci-tegra.c                     | 123 ++---
 drivers/mmc/host/sdhci.c                           | 448 ++++++++--------
 drivers/mmc/host/sdhci.h                           |  14 +-
 drivers/mmc/host/sh_mmcif.c                        | 281 +++++-----
 drivers/mmc/host/sh_mobile_sdhi.c                  |  96 ++--
 drivers/mmc/host/tmio_mmc_pio.c                    |  87 +++-
 drivers/mmc/host/wmt-sdmmc.c                       |   2 +-
 include/linux/mfd/tmio.h                           |  18 -
 include/linux/mmc/card.h                           |  22 +-
 include/linux/mmc/core.h                           |   7 +-
 include/linux/mmc/dw_mmc.h                         |   6 +-
 include/linux/mmc/host.h                           |  61 ++-
 include/linux/mmc/mmc.h                            |  15 +-
 include/linux/mmc/sdhci.h                          |   1 +
 include/linux/mmc/sh_mobile_sdhi.h                 |   2 -
 include/linux/platform_data/mmc-esdhc-imx.h        |   1 +
 include/linux/platform_data/mmc-sdhci-tegra.h      |  28 -
 53 files changed, 3064 insertions(+), 882 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/brcm,bcm2835-sdhci.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/orion-sdio.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/tmio_mmc.txt
 create mode 100644 drivers/mmc/host/android-goldfish.c
 create mode 100644 drivers/mmc/host/sdhci-bcm2835.c
 delete mode 100644 include/linux/platform_data/mmc-sdhci-tegra.h

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
