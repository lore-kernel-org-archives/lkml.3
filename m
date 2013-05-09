Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3EIUyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:54:15 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42814 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3EIUyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:54:14 -0400
Date: Thu, 9 May 2013 13:54:13 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: arm-soc fixes and a few straggler patches for 3.10
Message-ID: <20130509205413.GA16897@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 8cbc95ee748741939222c3d38584a40c92bedcdd:

  Merge tag 'nfs-for-3.10-2' of git://git.linux-nfs.org/projects/trondmy/linux-nfs (2013-05-09 10:24:54 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to c58c1a4c118ba2ed49f72de9b42ef13bc8ee71e5:

  ARM: exynos: dts: Fixed vbus-gpios (2013-05-09 13:25:23 -0700)

----------------------------------------------------------------
ARM: arm-soc fixes and straggler patches for 3.10

A collection of fixes for fall out from 3.10 merge window, some build
fixes and warning cleanups and a small handful of patches that were
small and contained and made sense to still include in 3.10 (some of
these have also been in -next since the merge window opened).

Largest continous series is for OMAP, but there's a handful for other
platforms.

For i.MX, one of the patches are framebuffer fixups due to fallout during
the merge window, and the other removes some stale and broken code.

----------------------------------------------------------------
Aaro Koskinen (1):
      ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices

Arnd Bergmann (7):
      ARM: default machine descriptor for multiplatform
      ARM: tegra: Tegra114 needs CPU_FREQ_TABLE
      ARM: OMAP: build SMP code only for OMAP4/5
      ARM: imx: build CPU suspend code only when needed
      ARM: SPEAr: conditionalize l2x0 support
      ARM: SIRF: select SMP_ON_UP only on SMP builds
      ARM: ux500: always select ABX500_CORE

Christoph Fritz (1):
      omap: mux: add AM/DM37x gpios

Doug Anderson (1):
      ARM: exynos: dts: Fixed vbus-gpios

Fabio Baltieri (1):
      ARM: ux500: read the correct soc_id number

Fabio Estevam (2):
      ARM: imx: Select GENERIC_ALLOCATOR
      video: mxsfb: Adapt to new videomode API

Inderpal Singh (1):
      ARM: EXYNOS5: Fix kernel dump in AFTR idle mode

Jason Cooper (1):
      ARM: dts: don't assume boards are using twl4030 for omap3

Javier Martinez Canillas (3):
      Documentation: dt: update TI GPMC ethernet binding properties
      ARM: OMAP2+: only search for GPMC DT child nodes on probe
      ARM: OMAP2+: only WARN if a GPMC child probe function fail

Jon Hunter (2):
      Documentation: dt: update properties in TI GPMC NAND example
      ARM: dts: OMAP4: Fix ethernet IRQ for OMAP4 boards

Kevin Hilman (1):
      ARM: OMAP2+: omap_device: use late_initcall_sync

Lee Jones (1):
      ARM: ux500: Rid ignored return value of regulator_enable() compiler warning

Nishanth Menon (2):
      ARM: dts: OMAP36xx: Fix CPU OPP voltages
      ARM: dts: OMAP4460: Fix CPU OPP voltages

Olof Johansson (4):
      Merge branch 'late/fixes' into fixes
      ARM: exynos: dts: cros5250: add cyapa trackpad
      Merge tag 'omap-for-v3.10/fixes-for-merge-window-part2' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'omap-for-v3.10/dt-fixes-for-merge-window' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Peter Ujfalusi (1):
      ARM: OMAP4+: omap2plus_defconfig: Enable audio via TWL6040 as module

Philip Avinash (1):
      ARM: dts: AM33XX: Add GPMC node

Roger Quadros (1):
      ARM: OMAP3: Beagle: Fix USB Host on beagle xM Ax/Bx

Shawn Guo (1):
      ARM: imx: compile fix for hotplug.c

Tony Lindgren (4):
      ARM: OMAP2+: Fix unmet direct dependencies for SERIAL_OMAP
      Merge branch 'omap-gpmc-fixes-for-v3.10' of git://github.com/jonhunter/linux into fixes
      ARM: dts: Configure and fix the McSPI pins for 4430sdp
      ARM: OMAP2+: Remove bogus IS_ERR_OR_NULL checking from id.c

Vaibhav Hiremath (1):
      ARM: OMAP2: AM33XX: id: Add support for new AM335x PG2.1 Si

Wei Yongjun (1):
      ARM: OMAP1: DMA: fix error handling in omap1_system_dma_init()

 .../devicetree/bindings/mtd/gpmc-nand.txt          | 28 ++++-----
 Documentation/devicetree/bindings/net/gpmc-eth.txt | 56 ++++++++---------
 arch/arm/Kconfig                                   |  1 -
 arch/arm/boot/dts/am33xx.dtsi                      | 12 ++++
 arch/arm/boot/dts/cros5250-common.dtsi             |  8 +++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  2 +-
 arch/arm/boot/dts/exynos5250-snow.dts              |  2 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts              |  1 +
 arch/arm/boot/dts/omap3-evm.dts                    |  1 +
 arch/arm/boot/dts/omap3-overo.dtsi                 |  1 +
 arch/arm/boot/dts/omap3.dtsi                       |  1 -
 arch/arm/boot/dts/omap36xx.dtsi                    |  6 +-
 arch/arm/boot/dts/omap4-sdp.dts                    | 14 ++++-
 arch/arm/boot/dts/omap4-var-som.dts                |  2 +-
 arch/arm/boot/dts/omap4460.dtsi                    |  6 +-
 arch/arm/configs/omap2plus_defconfig               |  4 ++
 arch/arm/kernel/devtree.c                          |  7 +++
 arch/arm/kernel/setup.c                            | 13 +++-
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |  1 +
 arch/arm/mach-exynos/pmu.c                         |  5 +-
 arch/arm/mach-imx/Kconfig                          |  5 +-
 arch/arm/mach-imx/Makefile                         |  1 -
 arch/arm/mach-imx/common.h                         |  1 +
 arch/arm/mach-imx/headsmp.S                        |  2 +-
 arch/arm/mach-imx/hotplug.c                        |  2 +
 arch/arm/mach-imx/iram_alloc.c                     | 73 ----------------------
 arch/arm/mach-omap1/dma.c                          |  8 +--
 arch/arm/mach-omap2/Kconfig                        |  2 -
 arch/arm/mach-omap2/Makefile                       |  8 +--
 arch/arm/mach-omap2/board-omap3beagle.c            |  6 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  4 +-
 arch/arm/mach-omap2/gpmc.c                         | 38 ++++-------
 arch/arm/mach-omap2/id.c                           | 13 ++--
 arch/arm/mach-omap2/mux34xx.h                      |  6 +-
 arch/arm/mach-omap2/omap_device.c                  |  2 +-
 arch/arm/mach-omap2/soc.h                          |  2 +
 arch/arm/mach-prima2/Kconfig                       |  2 +-
 arch/arm/mach-spear/spear13xx.c                    |  2 +
 arch/arm/mach-tegra/Kconfig                        |  1 +
 arch/arm/mach-ux500/Kconfig                        |  2 +
 arch/arm/mach-ux500/board-mop500.c                 |  4 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |  2 +-
 drivers/video/Kconfig                              |  2 +-
 drivers/video/mxsfb.c                              |  8 +--
 include/linux/platform_data/imx-iram.h             | 41 ------------
 45 files changed, 173 insertions(+), 235 deletions(-)
 delete mode 100644 arch/arm/mach-imx/iram_alloc.c
 delete mode 100644 include/linux/platform_data/imx-iram.h
