Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3KKFdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:33:53 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61226 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3KKFdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:33:03 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 5/6] ARM: SoC board updates for 3.13
Date: Sun, 10 Nov 2013 21:29:35 -0800
Message-Id: <1384147776-18735-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1384147776-18735-1-git-send-email-olof@lixom.net>
References: <1384147776-18735-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Board-related updates. This branch is getting smaller and smaller, which is
the whole idea so that's reassuring.

Right now by far most of the code is related to shmobile updates, and
they are now switching over to removal of board code and migration to
multiplatform, so we'll see their board code base shrink in the near
future too, I hope.

In addition to that is some defconfig updates, some display updates for OMAP
and a bit of new board support for Rockchip boards.


Conflicts:
* arch/arm/mach-shmobile/board-bockw.c:
  Add/add conflicts. Keep all sides of all changes. Another case of us missing
  to base things on the cleanup branch.

----------------------------------------------------------------

The following changes since commit 1b9219d9a96c0cc797079f8f8c523ae663ccec61:

  Merge branch 'next/drivers' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards-for-linus

for you to fetch changes up to 60cd8b09f1e26dec0e866085f110d1d665d53cec:

  Merge branch 'rockchip/boards' into next/boards

----------------------------------------------------------------

Archit Taneja (4):
      ARM: OMAP2+: drm: Don't build device for DMM
      ARM: OMAP2+: display: Create omapdrm device inside omap_display_init
      ARM: OMAP2+: display: Create omapvrfb and omapfb devices inside omap_display_init
      ARM: OMAP2+: display: Create omap_vout device inside omap_display_init

Guennadi Liakhovetski (9):
      ARM: shmobile: ape6evm: update MMC0, SDHI0 and SDHI1 with correct regulators
      ARM: shmobile: ape6evm: disable MMCIF Command Completion Signal
      ARM: shmobile: armadillo800eva: disable MMCIF Command Completion Signal
      ARM: shmobile: kzm9g: disable MMCIF Command Completion Signal
      ARM: shmobile: lager: disable MMCIF Command Completion Signal, add CLK_CTRL2
      ARM: shmobile: r8a73a4: add a DMAC platform device and clock for it
      ARM: shmobile: r8a7790: add I2C clocks and aliases for the DT mode
      ARM: shmobile: r8a73a4: add a clock alias for the DMAC in DT mode
      ARM: shmobile: ape6evm: add DMA support to MMCIF

Heiko Stuebner (4):
      ARM: rockchip: move shared dt properties to common source file
      ARM: rockchip: enable arm-global-timer
      ARM: rockchip: add dts for bqcurie2 tablet
      ARM: rockchip: add support for rk3188 and Radxa Rock board

Hisashi Nakamura (1):
      ARM: shmobile: Koelsch support

Kevin Hilman (4):
      Merge branch 'renesas/boards2' into next/boards
      Merge tag 'omap-for-v3.13/board-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge branch 'tegra/defconfig' into next/boards
      Merge branch 'rockchip/boards' into next/boards

Kuninori Morimoto (8):
      ARM: shmobile: bockw defconfig: add Sound support
      ARM: shmobile: bockw: enable global use of FPGA
      ARM: shmobile: bockw: add R-Car sound support (PIO)
      ARM: shmobile: bockw: add USB Function support
      ARM: shmobile: r8a7778: split r8a7778_init_irq_extpin() for DT
      ARM: shmobile: r8a7779: split r8a7779_init_irq_extpin() for DT
      ARM: shmobile: bockw: add SMSC support on reference
      ARM: shmobile: marzen: enable INTC IRQ

Laurent Pinchart (5):
      ARM: shmobile: marzen: Select DRM_RCAR_DU in defconfig
      ARM: shmobile: lager: Select DRM_RCAR_DU in defconfig
      ARM: shmobile: marzen: Add Display Unit support
      ARM: shmobile: lager: Add Display Unit support
      ARM: shmobile: lager: Fix Display Unit platform data

Magnus Damm (16):
      ARM: shmobile: Break out R-Car Gen2 setup code
      ARM: shmobile: Introduce r8a7791_add_standard_devices()
      ARM: shmobile: r8a7791 IRQC platform device support
      ARM: shmobile: r8a7791 Arch timer workaround
      ARM: shmobile: Initial r7s72100 SoC support
      ARM: shmobile: r7s72100 SCIF support
      ARM: shmobile: r8a7791 SMP support
      ARM: shmobile: Genmai support
      ARM: shmobile: Use r8a7791_add_standard_devices() on Koelsch
      ARM: shmobile: Use arch timer on Koelsch
      ARM: shmobile: Sync KZM9D DTS with KZM9D reference DTS
      ARM: shmobile: Use KZM9D without reference for multiplatform
      ARM: shmobile: Remove non-multiplatform KZM9D reference support
      ARM: shmobile: Let KZM9D multiplatform boot with KZM9D DTB
      ARM: shmobile: Remove KZM9D reference DTS
      ARM: shmobile: Use SMP on Koelsch

Max Filippov (4):
      ARM: shmobile: r8a7778: add HPB-DMAC support
      ARM: shmobile: r8a7779: add HPB-DMAC support
      ARM: shmobile: bockw: enable DMA for SDHI0
      ARM: shmobile: marzen: enable DMA for SDHI0

Olof Johansson (2):
      Merge tag 'renesas-boards-for-v3.13' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-defconfig-for-v3.13' of git://git.kernel.org/.../horms/renesas into next/boards

Pali Rohár (3):
      ARM: OMAP3: Add secure function omap_smc3() which calling instruction smc #1
      ARM: OMAP3: RX-51: ARM errata 430973 workaround
      RX-51: Add support for OMAP3 ROM Random Number Generator

Simon Horman (3):
      ARM: shmobile: Add koelsch defconfig
      Merge branch 'heads/soc2' into boards2-base
      Merge branch 'heads/soc2' into boards2-base

Stephen Warren (1):
      ARM: tegra: defconfig updates

Tony Lindgren (1):
      Merge branch 'omap-for-v3.13/n900' into omap-for-v3.13/board


 arch/arm/boot/dts/Makefile                      |   5 +-
 arch/arm/boot/dts/emev2-kzm9d-reference.dts     |  57 ---
 arch/arm/boot/dts/emev2-kzm9d.dts               |  33 +-
 arch/arm/boot/dts/r7s72100-genmai.dts           |  31 ++
 arch/arm/boot/dts/r8a7791-koelsch.dts           |  32 ++
 arch/arm/boot/dts/rk3066a-bqcurie2.dts          | 109 ++++++
 arch/arm/boot/dts/rk3066a.dtsi                  |  98 +----
 arch/arm/boot/dts/rk3188-clocks.dtsi            | 289 ++++++++++++++
 arch/arm/boot/dts/rk3188-radxarock.dts          |  80 ++++
 arch/arm/boot/dts/rk3188.dtsi                   | 253 +++++++++++++
 arch/arm/boot/dts/rk3xxx.dtsi                   | 124 +++++++
 arch/arm/configs/bockw_defconfig                |   4 +
 arch/arm/configs/koelsch_defconfig              |  54 +++
 arch/arm/configs/lager_defconfig                |   2 +
 arch/arm/configs/marzen_defconfig               |   2 +
 arch/arm/configs/tegra_defconfig                |   5 +
 arch/arm/mach-omap2/Makefile                    |   6 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c    |  19 +
 arch/arm/mach-omap2/board-rx51.c                |  12 +
 arch/arm/mach-omap2/cclock3xxx_data.c           |   1 +
 arch/arm/mach-omap2/devices.c                   |  10 +-
 arch/arm/mach-omap2/display.c                   |  28 ++
 arch/arm/mach-omap2/display.h                   |   4 +
 arch/arm/mach-omap2/drm.c                       |  24 +-
 arch/arm/mach-omap2/fb.c                        |  14 +-
 arch/arm/mach-omap2/omap-secure.c               |  76 ++++
 arch/arm/mach-omap2/omap-secure.h               |  13 +
 arch/arm/mach-omap2/omap-smc.S                  |  21 +-
 arch/arm/mach-rockchip/Kconfig                  |   2 +
 arch/arm/mach-shmobile/Kconfig                  |  34 +-
 arch/arm/mach-shmobile/Makefile                 |   7 +-
 arch/arm/mach-shmobile/Makefile.boot            |   3 +-
 arch/arm/mach-shmobile/board-ape6evm.c          |  57 ++-
 arch/arm/mach-shmobile/board-armadillo800eva.c  |   1 +
 arch/arm/mach-shmobile/board-bockw-reference.c  |  20 +
 arch/arm/mach-shmobile/board-bockw.c            | 372 ++++++++++++++++++-
 arch/arm/mach-shmobile/board-genmai.c           |  43 +++
 arch/arm/mach-shmobile/board-koelsch.c          |  47 +++
 arch/arm/mach-shmobile/board-kzm9d-reference.c  |   1 +
 arch/arm/mach-shmobile/board-kzm9g.c            |   1 +
 arch/arm/mach-shmobile/board-lager.c            |  68 ++++
 arch/arm/mach-shmobile/board-marzen-reference.c |   1 +
 arch/arm/mach-shmobile/board-marzen.c           |  74 ++++
 43 files changed, 1902 insertions(+), 235 deletions(-)
 delete mode 100644 arch/arm/boot/dts/emev2-kzm9d-reference.dts
 create mode 100644 arch/arm/boot/dts/r7s72100-genmai.dts
 create mode 100644 arch/arm/boot/dts/r8a7791-koelsch.dts
 create mode 100644 arch/arm/boot/dts/rk3066a-bqcurie2.dts
 create mode 100644 arch/arm/boot/dts/rk3188-clocks.dtsi
 create mode 100644 arch/arm/boot/dts/rk3188-radxarock.dts
 create mode 100644 arch/arm/boot/dts/rk3188.dtsi
 create mode 100644 arch/arm/boot/dts/rk3xxx.dtsi
 create mode 100644 arch/arm/configs/koelsch_defconfig
 create mode 100644 arch/arm/mach-shmobile/board-genmai.c
 create mode 100644 arch/arm/mach-shmobile/board-koelsch.c
