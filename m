Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3IFTNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:13:13 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49507 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3IFTNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:13:04 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 5/5] ARM: SoC board updates for 3.12
Date: Fri,  6 Sep 2013 12:10:05 -0700
Message-Id: <1378494605-14990-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1378494605-14990-1-git-send-email-olof@lixom.net>
References: <1378494605-14990-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Board updates for 3.12. Again, a bit of domain overlap with SoC and DT branches,
but most of this is around legacy code and board support. We've found that
platform maintainers have a hard time separating all of these out and might
move towards fewer branches for next release.

- Removal of a number of Marvell Kirkwood board files, since contents
is now common and mostly configured via DT.
- Device-tree updates for Marvell Dove, including irqchip and clocksource
setup.
- Defconfig updates. Gotta go somewhere. One new one for Renesas Lager.
- New backlight drivers for backlights used on Renesas shmobile platforms.
- Removal of Renesas leds driver.
- Shuffling of some of the new Broadcom platforms to give room for others in
the same mach directory. More in 2.13.


Conflicts:
- Add/add conflicts on Kirkwood with MBus additions. Keep both sides. We
  moved the mbusc node below the timer node but either works -- the
  ordering is already mostly random. :(

----------------------------------------------------------------

The following changes since commit 8243b621690f61b1677791b41dcc0b29a0e3f852:

  Merge tag 'soc-for-linus' into test-merge

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards-for-linus

for you to fetch changes up to 4e5f67fa538ded704c904157e3ca23ceef9c7e64:

  Merge tag 'bcm-for-3.12-late-soc' of git://github.com/broadcom/bcm11351 into next/boards

----------------------------------------------------------------

Andrew Lunn (1):
      ARM: Kirkwood: update defconfig for used i2c devices, EXT4 FS, r8169

Christian Daudt (4):
      ARM: bcm: Rename board_bcm
      ARM: mmc: fix NONREMOVABLE test in sdhci-bcm-kona
      ARM: DT: binding fixup to align with vendor-prefixes.txt (drivers)
      ARM: bcm: Make secure API call optional

Guennadi Liakhovetski (5):
      ARM: shmobile: armadillo800eva: add DMA support to MMCIF
      ARM: shmobile: lager: add MMCIF support
      ARM: shmobile: ape6evm: add MMCIF support
      ARM: shmobile: ape6evm: add SDHI interfaces
      ARM: shmobile: ape6evm: add "__initconst" annotations where needed

Jamie Lentin (1):
      ARM: kirkwood: Remove all remaining trace of DNS-320/325 platform code

Jason Cooper (2):
      ARM: kirkwood: use dts pre-processor for mv88f6281gtw-ge
      ARM: kirkwood: fix DT building and update defconfig

Julia Lawall (1):
      arch/arm/mach-kirkwood: Avoid using ARRAY_AND_SIZE(e) as a function argument

Kevin Hilman (1):
      Merge tag 'tegra-for-3.12-defconfig' of git://git.kernel.org/.../swarren/linux-tegra into next/boards

Kuninori Morimoto (2):
      ARM: shmobile: select the fixed regulator driver on BockW
      ARM: shmobile: lager: add missing __initdata

Laurent Pinchart (11):
      backlight: Add GPIO-based backlight driver
      backlight: Add Sanyo LV5207LP backlight driver
      backlight: Add ROHM BD6107 backlight driver
      ARM: mach-shmobile: mackerel: Use gpio-backlight
      sh: ecovec24: Use gpio-backlight
      sh: kfr2r09: Use lv5207lp backlight
      ARM: mach-shmobile: ag5evm: Use bd6107 backlight driver
      ARM: shmobile: armadillo800eva: Add backlight support
      ARM: shmobile: kota2: Use leds-pwm + pwm-rmob
      ARM: shmobile: sh73a0: Remove all GPIOs
      leds: Remove leds-renesas-tpu driver

Markus Mayer (4):
      ARM: bcm281xx: Turn on L2 cache.
      ARM bcm281xx: Turn on socket & network support.
      ARM: bcm281xx: Board specific reboot code
      mmc: sdhci-bcm-kona: make linker-section warning go away

Matt Porter (1):
      ARM: configs: disable DEBUG_LL in bcm_defconfig

Olof Johansson (11):
      Merge tag 'renesas-backlight-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'boards-3.12' of git://git.infradead.org/linux-mvebu into next/boards
      Merge tag 'renesas-tpu-pwm-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-boards-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-defconfig-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-boards2-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-boards-cleanup-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'boards-3.12-2' of git://git.infradead.org/linux-mvebu into next/boards
      Merge tag 'defconfig-3.12' of git://git.infradead.org/linux-mvebu into next/boards
      Merge branch 'armsoc/for-3.12/soc' of git://github.com/broadcom/bcm11351 into next/boards
      Merge tag 'bcm-for-3.12-late-soc' of git://github.com/broadcom/bcm11351 into next/boards

Sachin Kamat (2):
      mmc: sdhci-bcm-kona: Remove unneeded version.h inclusion
      mmc: sdhci-bcm-kona: Staticize sdhci_bcm_kona_card_event

Sebastian Hesselbarth (19):
      ARM: dove: add gigabit ethernet and mvmdio device tree nodes
      ARM: kirkwood: add gigabit ethernet and mvmdio device tree nodes
      ARM: orion5x: add gigabit ethernet and mvmdio device tree nodes
      ARM: dove: remove legacy mv643xx_eth setup
      ARM: kirkwood: remove redundant DT board files
      ARM: kirkwood: remove legacy clk alias for mv643xx_eth
      ARM: orion5x: remove legacy mv643xx_eth board setup
      ARM: dove: move device tree nodes to DT irqchip and clocksource
      ARM: kirkwood: move device tree nodes to DT irqchip and clocksource
      ARM: orion5x: update intc device tree node to new reg layout
      ARM: dove: convert to DT irqchip and clocksource
      ARM: kirkwood: convert to DT irqchip and clocksource
      ARM: kirkwood: remove obsolete SDIO clock gate workaround
      ARM: plat-orion: add reg offset to DT irq driver stub
      ARM: dove: update dove_defconfig with SI5351, PCI, and xHCI
      ARM: dove: add cpu device tree node
      ARM: dove: add common pinmux functions to DT
      ARM: dove: add GPIO IR receiver node to SolidRun CuBox
      ARM: dove: add initial DT file for Globalscale D2Plug

Simon Horman (7):
      ARM: shmobile: marzen: Enable ARM_APPENDED_DTB in defconfig
      ARM: shmobile: Add lager defconfig
      ARM: shmobile: ape6evm: Enable gpio-keys in defconfig
      ARM: shmobile: ape6evm: Enable gpio-leds in defconfig
      ARM: shmobile: ape6evm: support GPIO switches
      ARM: shmobile: ape6evm: Add GPIO LEDs
      ARM: shmobile: lager: enable Ether

Stephen Warren (1):
      ARM: tegra: defconfig updates

Thomas Petazzoni (6):
      ARM: mvebu: add gpio-keys and input event support in defconfig
      ARM: kirkwood: remove support for legacy booting of Dockstar
      ARM: kirkwood: remove support for legacy booting of Guruplug
      ARM: kirkwood: remove support for legacy booting of Sheevaplug
      ARM: kirkwood: remove LaCie boards that are supported through DT
      ARM: kirkwood: convert the mv88f6281gtw_ge board to DT


 arch/arm/boot/dts/Makefile                      |   2 +
 arch/arm/boot/dts/dove-cubox.dts                |  37 +-
 arch/arm/boot/dts/dove-d2plug.dts               |  69 ++++
 arch/arm/boot/dts/dove.dtsi                     | 285 +++++++++++++-
 arch/arm/boot/dts/kirkwood-cloudbox.dts         |  16 +
 arch/arm/boot/dts/kirkwood-db.dtsi              |  16 +
 arch/arm/boot/dts/kirkwood-dnskw.dtsi           |  16 +
 arch/arm/boot/dts/kirkwood-dockstar.dts         |  17 +
 arch/arm/boot/dts/kirkwood-dreamplug.dts        |  28 ++
 arch/arm/boot/dts/kirkwood-goflexnet.dts        |  16 +
 .../boot/dts/kirkwood-guruplug-server-plus.dts  |  30 ++
 arch/arm/boot/dts/kirkwood-ib62x0.dts           |  16 +
 arch/arm/boot/dts/kirkwood-iconnect.dts         |  16 +
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts   |  24 ++
 arch/arm/boot/dts/kirkwood-is2.dts              |   2 +
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts      |  16 +
 arch/arm/boot/dts/kirkwood-lsxl.dtsi            |  28 ++
 arch/arm/boot/dts/kirkwood-mplcec4.dts          |  27 ++
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts  | 125 +++++++
 .../dts/kirkwood-netgear_readynas_duo_v2.dts    |  16 +
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi      |  16 +
 arch/arm/boot/dts/kirkwood-ns2.dts              |   2 +
 arch/arm/boot/dts/kirkwood-ns2lite.dts          |   2 +
 arch/arm/boot/dts/kirkwood-ns2max.dts           |   2 +
 arch/arm/boot/dts/kirkwood-ns2mini.dts          |   2 +
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts    |  16 +
 .../boot/dts/kirkwood-sheevaplug-common.dtsi    |  16 +
 arch/arm/boot/dts/kirkwood-topkick.dts          |  16 +
 arch/arm/boot/dts/kirkwood-ts219-6281.dts       |   4 +-
 arch/arm/boot/dts/kirkwood-ts219-6282.dts       |   4 +-
 arch/arm/boot/dts/kirkwood-ts219.dtsi           |  16 +
 arch/arm/boot/dts/kirkwood.dtsi                 |  87 ++++-
 .../dts/orion5x-lacie-ethernet-disk-mini-v2.dts |  17 +
 arch/arm/boot/dts/orion5x.dtsi                  |  34 +-
 arch/arm/configs/ape6evm_defconfig              |   6 +-
 arch/arm/configs/bcm_defconfig                  |  13 +-
 arch/arm/configs/dove_defconfig                 |   4 +
 arch/arm/configs/kirkwood_defconfig             |  51 +--
 arch/arm/configs/lager_defconfig                | 120 ++++++
 arch/arm/configs/marzen_defconfig               |   1 +
 arch/arm/configs/mvebu_defconfig                |   2 +
 arch/arm/configs/tegra_defconfig                |   9 +-
 arch/arm/mach-bcm/Kconfig                       |   1 +
 arch/arm/mach-bcm/Makefile                      |   4 +-
 arch/arm/mach-bcm/bcm_kona_smc.c                |  12 +-
 arch/arm/mach-bcm/bcm_kona_smc.h                |   2 +-
 .../mach-bcm/{board_bcm.c => board_bcm281xx.c}  |  30 +-
 arch/arm/mach-bcm/kona.c                        |  65 ++++
 arch/arm/mach-bcm/kona.h                        |  17 +
 arch/arm/mach-dove/Kconfig                      |   2 +
 arch/arm/mach-dove/Makefile                     |   4 +-
 arch/arm/mach-dove/board-dt.c                   |  30 +-
 arch/arm/mach-kirkwood/Kconfig                  | 243 +-----------
 arch/arm/mach-kirkwood/Makefile                 |  36 +-
 arch/arm/mach-kirkwood/board-db88f628x-bp.c     |  24 --
 arch/arm/mach-kirkwood/board-dnskw.c            |  43 ---
 arch/arm/mach-kirkwood/board-dockstar.c         |  32 --
 arch/arm/mach-kirkwood/board-dreamplug.c        |  35 --
 arch/arm/mach-kirkwood/board-dt.c               | 117 +-----
 arch/arm/mach-kirkwood/board-goflexnet.c        |  34 --
 arch/arm/mach-kirkwood/board-guruplug.c         |  33 --
 arch/arm/mach-kirkwood/board-ib62x0.c           |  29 --
 arch/arm/mach-kirkwood/board-iconnect.c         |  24 --
 arch/arm/mach-kirkwood/board-iomega_ix2_200.c   |  34 --
 arch/arm/mach-kirkwood/board-km_kirkwood.c      |  44 ---
 arch/arm/mach-kirkwood/board-lsxl.c             |  36 --
 arch/arm/mach-kirkwood/board-mplcec4.c          |  35 --
 arch/arm/mach-kirkwood/board-mv88f6281gtw_ge.c  |  50 +++
 arch/arm/mach-kirkwood/board-ns2.c              |  35 --
 arch/arm/mach-kirkwood/board-openblocks_a6.c    |  26 --
 arch/arm/mach-kirkwood/board-readynas.c         |  27 --
 arch/arm/mach-kirkwood/board-sheevaplug.c       |  27 --
 arch/arm/mach-kirkwood/board-ts219.c            |  40 --
 arch/arm/mach-kirkwood/board-usi_topkick.c      |  29 --
 arch/arm/mach-kirkwood/common.h                 | 115 +-----
 arch/arm/mach-kirkwood/dockstar-setup.c         | 111 ------
 arch/arm/mach-kirkwood/guruplug-setup.c         | 133 -------
 arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c  | 172 ---------
 arch/arm/mach-kirkwood/netspace_v2-setup.c      | 293 ---------------
 arch/arm/mach-kirkwood/openrd-setup.c           |   3 +-
 arch/arm/mach-kirkwood/rd88f6281-setup.c        |   4 +-
 arch/arm/mach-kirkwood/sheevaplug-setup.c       | 161 --------
 arch/arm/mach-orion5x/edmini_v2-setup.c         |  11 +-
 arch/arm/mach-shmobile/Kconfig                  |   1 +
 arch/arm/mach-shmobile/board-ag5evm.c           |  65 +---
 arch/arm/mach-shmobile/board-ape6evm.c          | 145 ++++++-
 arch/arm/mach-shmobile/board-armadillo800eva.c  |  56 ++-
 arch/arm/mach-shmobile/board-kota2.c            | 169 +++++----
 arch/arm/mach-shmobile/board-lager.c            |  60 +++
 arch/arm/mach-shmobile/board-mackerel.c         |  34 +-
 arch/arm/mach-shmobile/clock-sh73a0.c           |  12 +-
 arch/arm/mach-shmobile/include/mach/sh73a0.h    | 373 +------------------
 arch/arm/plat-orion/irq.c                       |   2 +-
 arch/sh/boards/mach-ecovec24/setup.c            |  37 +-
 arch/sh/boards/mach-kfr2r09/lcd_wqvga.c         |  48 ---
 arch/sh/boards/mach-kfr2r09/setup.c             |  19 +-
 arch/sh/include/mach-kfr2r09/mach/kfr2r09.h     |   2 -
 drivers/clocksource/bcm_kona_timer.c            |   8 +-
 drivers/leds/Kconfig                            |  12 -
 drivers/leds/Makefile                           |   1 -
 drivers/leds/leds-renesas-tpu.c                 | 337 -----------------
 drivers/mmc/host/sdhci-bcm-kona.c               |  18 +-
 drivers/video/backlight/Kconfig                 |  19 +
 drivers/video/backlight/Makefile                |   3 +
 drivers/video/backlight/bd6107.c                | 213 +++++++++++
 drivers/video/backlight/gpio_backlight.c        | 133 +++++++
 drivers/video/backlight/lv5207lp.c              | 171 +++++++++
 include/linux/platform_data/bd6107.h            |  19 +
 include/linux/platform_data/gpio_backlight.h    |  21 ++
 include/linux/platform_data/leds-renesas-tpu.h  |  14 -
 include/linux/platform_data/lv5207lp.h          |  19 +
 111 files changed, 2416 insertions(+), 3040 deletions(-)
 create mode 100644 arch/arm/boot/dts/dove-d2plug.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
 create mode 100644 arch/arm/configs/lager_defconfig
 rename arch/arm/mach-bcm/{board_bcm.c => board_bcm281xx.c} (68%)
 create mode 100644 arch/arm/mach-bcm/kona.c
 create mode 100644 arch/arm/mach-bcm/kona.h
 delete mode 100644 arch/arm/mach-kirkwood/board-db88f628x-bp.c
 delete mode 100644 arch/arm/mach-kirkwood/board-dnskw.c
 delete mode 100644 arch/arm/mach-kirkwood/board-dockstar.c
 delete mode 100644 arch/arm/mach-kirkwood/board-dreamplug.c
 delete mode 100644 arch/arm/mach-kirkwood/board-goflexnet.c
 delete mode 100644 arch/arm/mach-kirkwood/board-guruplug.c
 delete mode 100644 arch/arm/mach-kirkwood/board-ib62x0.c
 delete mode 100644 arch/arm/mach-kirkwood/board-iconnect.c
 delete mode 100644 arch/arm/mach-kirkwood/board-iomega_ix2_200.c
 delete mode 100644 arch/arm/mach-kirkwood/board-km_kirkwood.c
 delete mode 100644 arch/arm/mach-kirkwood/board-lsxl.c
 delete mode 100644 arch/arm/mach-kirkwood/board-mplcec4.c
 create mode 100644 arch/arm/mach-kirkwood/board-mv88f6281gtw_ge.c
 delete mode 100644 arch/arm/mach-kirkwood/board-ns2.c
 delete mode 100644 arch/arm/mach-kirkwood/board-openblocks_a6.c
 delete mode 100644 arch/arm/mach-kirkwood/board-readynas.c
 delete mode 100644 arch/arm/mach-kirkwood/board-sheevaplug.c
 delete mode 100644 arch/arm/mach-kirkwood/board-ts219.c
 delete mode 100644 arch/arm/mach-kirkwood/board-usi_topkick.c
 delete mode 100644 arch/arm/mach-kirkwood/dockstar-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/guruplug-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/netspace_v2-setup.c
 delete mode 100644 arch/arm/mach-kirkwood/sheevaplug-setup.c
 delete mode 100644 drivers/leds/leds-renesas-tpu.c
 create mode 100644 drivers/video/backlight/bd6107.c
 create mode 100644 drivers/video/backlight/gpio_backlight.c
 create mode 100644 drivers/video/backlight/lv5207lp.c
 create mode 100644 include/linux/platform_data/bd6107.h
 create mode 100644 include/linux/platform_data/gpio_backlight.h
 delete mode 100644 include/linux/platform_data/leds-renesas-tpu.h
 create mode 100644 include/linux/platform_data/lv5207lp.h
