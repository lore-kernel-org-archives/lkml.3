Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaLIVbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:31:49 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:58483 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLIVbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:31:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 3/9] ARM: SoC cleanups for 3.19
Date: Tue, 09 Dec 2014 22:30:33 +0100
Message-ID: <2717417.VGWlWGOuHy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4491193.a6KEQb1tZH@wuerfel>
References: <4491193.a6KEQb1tZH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:b50xRUgAAjyQCqVDgmTsjbbg2En25YGZZb6LZe8gm+nn6xYYaxe
 1NPVWNM/wNc+m2QhqdxJCrMsoynxoFb5Zqn9Z2te9zDIdXfDnVueoxU4nPhsjs6EHOQV850
 ZUoA0OHwrITJSZvVC0cHUZpCWdN50x+OsssRvK1j+TH8kfO61CAhsMZ7GaKjC/7efeeI8g8
 0hX+CyLRIDBi7QslI2jFg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ba62a8593d15f3f353acdc8ab32c18dd40a275bb:

  ARM: at91: remove unused board.h file (2014-12-03 14:16:07 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-linus

for you to fetch changes up to ef1dfa7332e9205b532da1c2d286757ce511cd1d:

  Merge tag 'at91-cleanup5' of git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91 into next/cleanup (2014-12-04 19:11:03 +0100)

----------------------------------------------------------------
ARM: SoC cleanups for 3.19

The remaining cleanups for 3.19 are to a large part result of
devicetree conversion nearing completion on two other platforms
besides AT91:

* Like AT91, Renesas shmobile is in the process to migrate to DT and
  multiplatform, but using a different approach of doing it one
  SoC at a time. For 3.19, the r8a7791 platform and associated\
  "Koelsch" board are considered complete and we remove the non-DT
  non-multiplatform support for this.

* The ARM Versatile Express has supported DT and multiplatform
  for a long time, but we have still kept the legacy board files
  around, because not all drivers were fully working before. We
  have finally taken the last step to remove the board files.

Other changes in this branch are preparation for the later branches
or just unrelated to the more interesting changes:
* The dts files for arm64 get moved into per-vendor directories for
  a clearer structure.
* Some dead code removal (zynq, exynos, davinci, imx)
* Using pr_*() macros more consistently instead of printk(KERN_*)
  in some platform code.

----------------------------------------------------------------
Arnd Bergmann (13):
      Merge tag 'renesas-boards-cleanups2-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-dt-du-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-dt-cleanups-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-koelsch-board-removal-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'at91-cleanup2' of git://git.kernel.org/.../nferre/linux-at91 into next/cleanup
      Merge tag 'davinci-for-v3.19/cleanup' of git://git.kernel.org/.../nsekhar/linux-davinci into next/cleanup
      Merge tag 'renesas-soc-cleanups2-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'samsung-cleanup-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'imx-cleanup-3.19' of git://git.kernel.org/.../shawnguo/linux into next/cleanup
      Merge tag 'at91-cleanup3' of git://git.kernel.org/.../nferre/linux-at91 into next/cleanup
      Merge tag 'at91-cleanup4' of git://git.kernel.org/.../nferre/linux-at91 into next/cleanup
      Merge tag 'zynq-cleanup-for-3.19' of https://github.com/Xilinx/linux-xlnx into next/cleanup
      Merge tag 'at91-cleanup5' of git://git.kernel.org/.../nferre/linux-at91 into next/cleanup

Boris Brezillon (1):
      ARM: at91: remove useless init_time for DT-only SoCs

Dmitry Voytik (3):
      ARM: imx6q: drop unnecessary semicolon
      ARM: imx: simplify clk_pllv3_prepare()
      ARM: imx: refactor mxc_iomux_mode()

Fabio Estevam (4):
      ARM: dts: imx6qdl-sabresd: Use IMX6QDL_CLK_CKO define
      ARM: dts: imx6qdl-gw5x: Remove unneeded 'fsl,mode' property
      ARM: dts: imx6qdl-rex: Remove unneeded 'fsl,mode' property
      ARM: dts: imx6qdl-sabresd: Fix the microphone route

Geert Uytterhoeven (24):
      ARM: dts: Sort SHMOBILE dtbs alphabetically
      ARM: shmobile: r7s72100: Remove r7s72100-genmai.dtb for ARCH_SHMOBILE_LEGACY
      ARM: shmobile: emev2 dtsi: Use generic names for device nodes
      ARM: shmobile: emev2 dtsi: Add uart* labels for easier referencing
      ARM: shmobile: genmai dts: Add chosen/stdout-path
      ARM: shmobile: ape6evm-reference dts: Add chosen/stdout-path
      ARM: shmobile: armadillo800eva dts: Add chosen/stdout-path
      ARM: shmobile: bockw-reference dts: Add chosen/stdout-path
      ARM: shmobile: marzen dts: Add chosen/stdout-path
      ARM: shmobile: lager dts: Add chosen/stdout-path
      ARM: shmobile: henninger dts: Add chosen/stdout-path
      ARM: shmobile: koelsch dts: Add chosen/stdout-path
      ARM: shmobile: alt dts: Add chosen/stdout-path
      ARM: shmobile: kzm9g-reference dts: Add chosen/stdout-path
      ARM: shmobile: kzm9d dts: Add chosen/stdout-path
      ARM: shmobile: r8a7778: Remove wrapper r8a7778_init_delay()
      ARM: shmobile: sh73a0: Remove wrapper sh73a0_init_delay()
      MAINTAINERS: Remove reference to shmobile / koelsch_defconfig
      ARM: dts: koelsch: Stop building r8a7791-koelsch.dtb in legacy builds
      ARM: shmobile: koelsch dts: Drop console= bootargs parameter
      ARM: shmobile: sh73a0: Spelling/grammar s/entity map/identity mapping/
      ARM: shmobile: sh7372: Spelling/grammar s/entity map/identity mapping/
      ARM: shmobile: r8a7779: Spelling/grammar s/entity/identity/, s/map/mapping/
      ARM: imx: Remove unneeded .map_io initialization

Jingchang Lu (1):
      ARM: imx: clean up machine mxc_arch_reset_init_dt reset init

Joe Perches (1):
      ARM: davinci: Use standard logging styles

Krzysztof Kozlowski (3):
      ARM: EXYNOS: Move code from hotplug.c to platsmp.c
      ARM: EXYNOS: Remove unneeded __ref annotation for cpu_die function
      ARM: EXYNOS: Fix CPU idle clock down after CPU off

Laurent Pinchart (15):
      ARM: shmobile: Remove FSF address from copyright headers
      ARM: shmobile: r8a7779: Add DU node to device tree
      ARM: shmobile: r8a7790: Add DU node to device tree
      ARM: shmobile: r8a7791: Add DU node to device tree
      ARM: shmobile: dts: Add common file for AA104XD12 panel
      ARM: shmobile: marzen: Enable DU device in DT
      ARM: shmobile: lager-reference: Remove DU platform device
      ARM: shmobile: lager: Enable DU device in DT
      ARM: shmobile: koelsch-reference: Remove DU platform device
      ARM: shmobile: koelsch: Enable DU device in DT
      ARM: shmobile: marzen-reference: Don't include legacy clock.h
      ARM: shmobile: Remove shmobile_clk_workaround() implementation
      ARM: shmobile: koelsch: Remove legacy C board code
      ARM: shmobile: r8a7791: Remove legacy code
      ARM: shmobile: koelsch: Remove reference board code

Michal Simek (1):
      ARM: zynq: Remove secondary_startup() declaration from header

Olof Johansson (8):
      Merge tag 'dts-subdirs-for-arm-soc-v3.19' of git://git.kernel.org/.../rric/linux into next/cleanup
      Merge tag 'samsung-cleanup' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'renesas-kconfig-cleanups-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-boards-cleanups-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-soc-cleanups-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'renesas-cleanup-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'at91-cleanup' of git://git.kernel.org/.../nferre/linux-at91 into next/cleanup
      ARM: at91: fix build breakage due to legacy board removals

Pankaj Dubey (1):
      ARM: EXYNOS: Remove unused static iomapping

Paul Bolle (1):
      ARM: shmobile: Remove ARCH_HAS_OPP completely

Pawel Moll (2):
      ARM: vexpress: Remove non-DT code
      ARM: vexpress: Enable regulator framework when MMCI is in use

Rasmus Villemoes (1):
      ARM: davinci: Remove redundant casts

Robert Richter (6):
      dts, arm64: Add dtbs_install make target
      dts, kbuild: Factor out dtbs install rules to Makefile.dtbinst
      dts, arm/arm64: Remove dtbs build rules in sub-makes
      dts, kbuild: Implement support for dtb vendor subdirs
      dts, arm64: Move dts files to vendor subdirs
      dts, arm: Remove $(MACHINE) variable from dtbs make recipes

Simon Horman (3):
      ARM: shmobile: r8a73a4: Remove spurious dma-multiplexer base addresses
      ARM: shmobile: armadillo800eva: Sort includes
      Merge tag 'renesas-dt-cleanups-for-v3.19' into koelsch-board-removal-for-v3.19.base

Soren Brinkmann (1):
      ARM: zynq: Actually remove hotplug.c

Ulrich Hecht (3):
      ARM: shmobile: r7s72100: sort dtsi file by address
      ARM: shmobile: kzm9d: sort dts file by address
      ARM: shmobile: r8a73a4: sort dtsi file by address


 MAINTAINERS                                        |   1 -
 arch/arm/Kconfig                                   |   2 +
 arch/arm/Makefile                                  |   8 +-
 arch/arm/boot/dts/Makefile                         |  27 +-
 arch/arm/boot/dts/emev2-kzm9d.dts                  |  63 +--
 arch/arm/boot/dts/emev2.dtsi                       |  12 +-
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi              |   1 -
 arch/arm/boot/dts/imx6qdl-gw53xx.dtsi              |   1 -
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi              |   2 -
 arch/arm/boot/dts/imx6qdl-rex.dtsi                 |   1 -
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |   8 +-
 arch/arm/boot/dts/r7s72100-genmai.dts              |   3 +-
 arch/arm/boot/dts/r7s72100.dtsi                    | 202 ++++----
 arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts    |   3 +-
 arch/arm/boot/dts/r8a73a4.dtsi                     | 232 ++++-----
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts      |   1 +
 arch/arm/boot/dts/r8a7778-bockw-reference.dts      |   3 +-
 arch/arm/boot/dts/r8a7779-marzen.dts               |  84 ++++
 arch/arm/boot/dts/r8a7779.dtsi                     |  24 +
 arch/arm/boot/dts/r8a7790-lager.dts                |  54 ++-
 arch/arm/boot/dts/r8a7790.dtsi                     |  90 ++++
 arch/arm/boot/dts/r8a7791-henninger.dts            |   1 +
 arch/arm/boot/dts/r8a7791-koelsch.dts              |  19 +-
 arch/arm/boot/dts/r8a7791.dtsi                     |  69 +++
 arch/arm/boot/dts/r8a7794-alt.dts                  |   1 +
 arch/arm/boot/dts/r8a77xx-aa104xd12-panel.dtsi     |  41 ++
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts       |   1 +
 arch/arm/configs/koelsch_defconfig                 | 113 -----
 arch/arm/configs/shmobile_defconfig                |   1 -
 arch/arm/mach-at91/at91sam9g45.c                   |   1 +
 arch/arm/mach-at91/at91sam9rl.c                    |   1 +
 arch/arm/mach-davinci/board-da830-evm.c            |  89 ++--
 arch/arm/mach-davinci/board-da850-evm.c            |   9 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |  10 +-
 arch/arm/mach-davinci/board-mityomapl138.c         |  45 +-
 arch/arm/mach-davinci/board-neuros-osd2.c          |   5 +-
 arch/arm/mach-davinci/clock.c                      |   2 +-
 arch/arm/mach-davinci/mux.c                        |  15 +-
 arch/arm/mach-davinci/time.c                       |  13 +-
 arch/arm/mach-exynos/Makefile                      |   3 -
 arch/arm/mach-exynos/common.h                      |   2 -
 arch/arm/mach-exynos/exynos.c                      |  50 --
 arch/arm/mach-exynos/hotplug.c                     |  91 ----
 arch/arm/mach-exynos/include/mach/map.h            |  23 -
 arch/arm/mach-exynos/platsmp.c                     | 113 +++++
 arch/arm/mach-exynos/regs-pmu.h                    |   3 +
 arch/arm/mach-imx/clk-imx6q.c                      |   2 +-
 arch/arm/mach-imx/clk-pllv3.c                      |   7 +-
 arch/arm/mach-imx/common.h                         |   1 -
 arch/arm/mach-imx/imx25-dt.c                       |   9 -
 arch/arm/mach-imx/imx27-dt.c                       |   3 -
 arch/arm/mach-imx/imx31-dt.c                       |   9 -
 arch/arm/mach-imx/imx35-dt.c                       |  10 -
 arch/arm/mach-imx/iomux-imx31.c                    |   8 +-
 arch/arm/mach-imx/iomux-mx3.h                      |   2 +-
 arch/arm/mach-imx/mach-imx50.c                     |   9 -
 arch/arm/mach-imx/mach-imx51.c                     |   2 -
 arch/arm/mach-imx/mach-imx53.c                     |   2 -
 arch/arm/mach-imx/mach-imx6q.c                     |   3 -
 arch/arm/mach-imx/mach-imx6sl.c                    |   4 -
 arch/arm/mach-imx/mach-imx6sx.c                    |   4 -
 arch/arm/mach-imx/mach-vf610.c                     |  10 -
 arch/arm/mach-imx/system.c                         |  15 -
 arch/arm/mach-shmobile/Kconfig                     |  20 -
 arch/arm/mach-shmobile/Makefile                    |   5 +-
 arch/arm/mach-shmobile/Makefile.boot               |   1 -
 arch/arm/mach-shmobile/board-ape6evm-reference.c   |   4 -
 arch/arm/mach-shmobile/board-ape6evm.c             |   4 -
 arch/arm/mach-shmobile/board-armadillo800eva.c     |  45 +-
 arch/arm/mach-shmobile/board-bockw-reference.c     |   4 -
 arch/arm/mach-shmobile/board-bockw.c               |   4 -
 arch/arm/mach-shmobile/board-koelsch-reference.c   | 117 -----
 arch/arm/mach-shmobile/board-koelsch.c             | 527 ---------------------
 arch/arm/mach-shmobile/board-kzm9g-reference.c     |   4 -
 arch/arm/mach-shmobile/board-kzm9g.c               |   4 -
 arch/arm/mach-shmobile/board-lager-reference.c     |  84 ----
 arch/arm/mach-shmobile/board-lager.c               |   4 -
 arch/arm/mach-shmobile/board-mackerel.c            |   4 -
 arch/arm/mach-shmobile/board-marzen-reference.c    |   5 -
 arch/arm/mach-shmobile/board-marzen.c              |   4 -
 arch/arm/mach-shmobile/clock-r8a73a4.c             |   4 -
 arch/arm/mach-shmobile/clock-r8a7740.c             |   4 -
 arch/arm/mach-shmobile/clock-r8a7778.c             |   4 -
 arch/arm/mach-shmobile/clock-r8a7779.c             |   4 -
 arch/arm/mach-shmobile/clock-r8a7790.c             |   4 -
 arch/arm/mach-shmobile/clock-r8a7791.c             | 342 -------------
 arch/arm/mach-shmobile/clock-sh7372.c              |   4 -
 arch/arm/mach-shmobile/clock-sh73a0.c              |   4 -
 arch/arm/mach-shmobile/clock.c                     |  36 +-
 arch/arm/mach-shmobile/clock.h                     |  14 -
 arch/arm/mach-shmobile/console.c                   |   4 -
 arch/arm/mach-shmobile/headsmp-scu.S               |   5 -
 arch/arm/mach-shmobile/intc-sh7372.c               |   4 -
 arch/arm/mach-shmobile/intc-sh73a0.c               |   4 -
 arch/arm/mach-shmobile/r8a7740.h                   |   4 -
 arch/arm/mach-shmobile/r8a7778.h                   |   5 -
 arch/arm/mach-shmobile/r8a7791.h                   |   3 -
 arch/arm/mach-shmobile/setup-emev2.c               |   4 -
 arch/arm/mach-shmobile/setup-r7s72100.c            |   4 -
 arch/arm/mach-shmobile/setup-r8a73a4.c             |   4 -
 arch/arm/mach-shmobile/setup-r8a7740.c             |   4 -
 arch/arm/mach-shmobile/setup-r8a7778.c             |  11 +-
 arch/arm/mach-shmobile/setup-r8a7779.c             |  10 +-
 arch/arm/mach-shmobile/setup-r8a7790.c             |   4 -
 arch/arm/mach-shmobile/setup-r8a7791.c             | 185 +-------
 arch/arm/mach-shmobile/setup-rcar-gen2.c           |   4 -
 arch/arm/mach-shmobile/setup-sh7372.c              |   6 +-
 arch/arm/mach-shmobile/setup-sh73a0.c              |  15 +-
 arch/arm/mach-shmobile/sh73a0.h                    |   1 -
 arch/arm/mach-shmobile/sleep-sh7372.S              |   5 -
 arch/arm/mach-shmobile/smp-emev2.c                 |   4 -
 arch/arm/mach-shmobile/smp-r8a7779.c               |   4 -
 arch/arm/mach-shmobile/smp-sh73a0.c                |   4 -
 arch/arm/mach-shmobile/timer.c                     |   5 -
 arch/arm/mach-vexpress/Kconfig                     |   4 +-
 arch/arm/mach-vexpress/Makefile                    |   3 +-
 arch/arm/mach-vexpress/core.h                      |   7 -
 arch/arm/mach-vexpress/ct-ca9x4.c                  | 212 ---------
 arch/arm/mach-vexpress/include/mach/ct-ca9x4.h     |  47 --
 arch/arm/mach-vexpress/include/mach/hardware.h     |   1 -
 arch/arm/mach-vexpress/include/mach/irqs.h         |   6 -
 arch/arm/mach-vexpress/include/mach/motherboard.h  |  88 ----
 arch/arm/mach-vexpress/platsmp.c                   |  42 --
 arch/arm/mach-vexpress/v2m.c                       | 374 ---------------
 arch/arm/mach-zynq/Makefile                        |   2 -
 arch/arm/mach-zynq/common.h                        |   1 -
 arch/arm/mach-zynq/hotplug.c                       |  14 -
 arch/arm/plat-samsung/include/plat/map-s5p.h       |  21 -
 arch/arm/plat-versatile/Kconfig                    |   2 +-
 arch/arm64/Makefile                                |  10 +-
 arch/arm64/boot/dts/Makefile                       |  15 +-
 arch/arm64/boot/dts/apm/Makefile                   |   5 +
 arch/arm64/boot/dts/{ => apm}/apm-mustang.dts      |   0
 arch/arm64/boot/dts/{ => apm}/apm-storm.dtsi       |   0
 arch/arm64/boot/dts/arm/Makefile                   |   6 +
 arch/arm64/boot/dts/{ => arm}/foundation-v8.dts    |   0
 arch/arm64/boot/dts/{ => arm}/rtsm_ve-aemv8a.dts   |   0
 .../boot/dts/{ => arm}/rtsm_ve-motherboard.dtsi    |   0
 arch/arm64/boot/dts/cavium/Makefile                |   5 +
 arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dts  |   0
 arch/arm64/boot/dts/{ => cavium}/thunder-88xx.dtsi |   0
 drivers/clk/versatile/Makefile                     |   1 -
 drivers/clk/versatile/clk-vexpress-osc.c           |   7 -
 drivers/clk/versatile/clk-vexpress.c               |  86 ----
 drivers/misc/vexpress-syscfg.c                     |  60 +--
 include/linux/vexpress.h                           |  19 -
 scripts/Kbuild.include                             |   6 +
 scripts/Makefile.dtbinst                           |  51 ++
 scripts/Makefile.lib                               |  12 -
 149 files changed, 1004 insertions(+), 3309 deletions(-)

