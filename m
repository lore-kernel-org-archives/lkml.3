Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaDETH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:07:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62287 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaDETHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:07:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 8/8] ARM: SoC: late cleanups
Date: Sat, 5 Apr 2014 20:07:24 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201404052101.19381.arnd@arndb.de>
In-Reply-To: <201404052101.19381.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404052107.24766.arnd@arndb.de>
X-Provags-ID: V02:K0:bGqMj2VlR+oJQHPJHGkcJxmarZf1UCg56BqtAb7dNNW
 56E9z2Igg/ryk9SoAfZqdUFvVaw38v0qz2fcGAFLKHK1zjvTZY
 fi1UmeFajcuvDRZwFJihLFrSNyNBiR9ouRM8WTTIvZ4LMbbVye
 +4+pXCfA8YsydmFs+kqsc48CBWqVVonrlopRrWT11A2Ft2+4uQ
 qFVv/hKoTnzzipPmXNZ0FZ0axHmvSoxxW3+tTvkrB4UM0teIB2
 ITvICoBabCQL0XIW1B9sxkpn+fC3p9YTUielL3/MN7fMVD5WIY
 IjDVxg41JZsTkYZbcQbXw7LymR9fsnAiLFvG0J7f//SYTg/QyH
 zH9wwHkI4NogSjpme3xOt+JaloHQxgUUmVVyRDaE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 86feafebbec2b510daf36ffbdbe10228ed890b00:

  ARM: dts: use macros in clock bindings for exynos5440 (2014-02-26 09:53:31 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup2-3.15

for you to fetch changes up to 9dfbff16b422a4bac7ad309847c7bc5d65653392:

  devicetree: fix newly added exynos sata bindings (2014-03-29 02:15:43 +0100)

----------------------------------------------------------------
ARM: SoC: late cleanups

These could not be part of the first cleanup branch, because they either
came too late in the cycle, or they have dependencies on other branches.
Important changes are:

* The integrator platform is almost multiplatform capable after
  some reorganization (Linus Walleij)
* Minor cleanups on Zynq (Michal Simek)
* Lots of changes for Exynos and other Samsung platforms, including
  further preparations for multiplatform support and the clocks bindings
  are rearranged.

Conflicts:
* CONFIG_UNCOMPRESS_INCLUDE now needs debug/uncompress.h for all PLAT_SAMSUNG
  platforms, which includes ARCH_EXYNOS.
* The samsung-phy binding gained support for both USB and SATA descriptions,
  which we both want.
* ZYNQ now uses MFD_SYSCON, but doesn't always want ARM_GLOBAL_TIMER
* zynq_init_machine() now registers a cpufreq device (don't know why
  this is needed, but it didn't come through arm-soc) and it calls
  zynq_slcr_init, it needs both.

----------------------------------------------------------------
Arnd Bergmann (9):
      Merge tag 'zynq-cleanup-for-3.15-v2' of git://git.xilinx.com/linux-xlnx into next/cleanup2
      Merge branches 'samsung/cleanup', 'samsung/exynos-clk' and 'samsung/exynos-clk2' into next/cleanup3
      Merge tag 'samsung-cleanup-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'samsung-dt-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'samsung-cleanup-3' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'samsung-dt-3' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'samsung-pm-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      Merge tag 'exynos-cleanup' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup3
      devicetree: fix newly added exynos sata bindings

Chanwoo Choi (5):
      ARM: dts: Add ADC's dt data to read raw data for exynos4x12
      ARM: dts: Add PMU dt data to support PMU for exynos4x12
      ARM: dts: Add GPS_ALIVE power domain for exynos4x12
      ARM: dts: Move common dt data for interrupt combiner controller for exynos4x12
      ARM: dts: Add ADC and themistor nodes for exynos4412-trats2

Heiko Stuebner (2):
      ARM: SAMSUNG: use generic uncompress.h
      ARM: SAMSUNG: remove all custom uncompress.h

Kukjin Kim (1):
      Merge branch 'v3.15-next/cleanup-samsung-2' into v3.15-next/s2r-pm-samsung-2

Linus Walleij (5):
      ARM: integrator: localize the lm.h header
      ARM: integrator: localize the impd1.h header
      ARM: integrator: merge platform.h to hardware.h
      ARM: integrator: localize the hardware.h header
      ARM: integrator: register sched_clock directly

Mark Brown (3):
      ARM: dts: Remove leftover spi0 node for smdk5250
      serial: s3c: Fix build of header without serial_core.h preinclusion
      ARM: S3C64XX: Fix build for implicit serial_s3c.h inclusion

Michal Simek (6):
      ARM: zynq: Split slcr in two parts
      ARM: zynq: Map I/O memory on clkc init
      ARM: zynq: Add and use zynq_slcr_read/write() helper functions
      ARM: zynq: Introduce zynq_slcr_unlock()
      ARM: zynq: Move of_clk_init from clock driver
      ARM: zynq: Add waituart implementation

Naveen Krishna Chatradhi (1):
      ARM: dts: add dt node for sss module for exynos5250/5420

Olof Johansson (2):
      Merge branch 'integrator/multiplatform-base' into next/cleanup2
      Merge tag 'integrator-for-v3.15-2' of git://git.kernel.org/.../linusw/linux-integrator into next/cleanup2

Sachin Kamat (9):
      ARM: EXYNOS: Add support to reserve memory for MFC-v7
      ARM: SAMSUNG: Introduce generic Exynos4 and 5 helpers
      ARM: EXYNOS: Consolidate CPU init code
      ARM: EXYNOS: Consolidate exynos4 and exynos5 machine files
      ARM: EXYNOS: Add generic compatible strings
      ARM: dts: Update Exynos DT files with generic compatible strings
      ARM: S3C24XX: Remove invalid code from hardware.h
      ARM: SAMSUNG: Remove hardware.h inclusion
      ARM: EXYNOS: Remove hardware.h file

Steffen Trumtrar (3):
      ARM: zynq: Move clock_init from slcr to common
      ARM: zynq: Hang iomapped slcr address on device_node
      ARM: zynq: Make zynq_slcr_base static

Tomasz Figa (14):
      ARM: EXYNOS: Do not resume l2x0 if not enabled before suspend
      ARM: SAMSUNG: Add soc_is_s3c2410() helper
      ARM: SAMSUNG: Save UART DIVSLOT register based on SoC type
      ARM: SAMSUNG: Use debug_ll_addr() to get UART base address
      ARM: SAMSUNG: Consolidate PM debug functions
      ARM: SAMSUNG: Move Samsung PM debug code into separate file
      ARM: SAMSUNG: Move common save/restore helpers to separate file
      ARM: SAMSUNG: Move s3c_pm_check_* prototypes to plat/pm-common.h
      ARM: EXYNOS: Fix abuse of CONFIG_PM
      ARM: EXYNOS: Remove PM initcalls and useless indirection
      ARM: EXYNOS: Stop using legacy Samsung PM code
      ARM: EXYNOS: Allow wake-up using GIC interrupts
      ARM: S5P64X0: Explicitly include linux/serial_s3c.h in mach/pm-core.h
      ARM: EXYNOS: Fix compilation error in cpuidle.c

Tushar Behera (4):
      ARM: SAMSUNG: Reorganize calls to reserve memory for MFC
      ARM: dts: Disable MDMA1 node for arndale-octa board
      ARM: dts: Keep some essential LDOs enabled for arndale-octa board
      dt-bindings: clock: Move exynos-audss-clk.h to dt-bindings/clock

Yuvaraj Kumar C D (1):
      ARM: dts: enable ahci sata and sata phy for exynos5250

 .../devicetree/bindings/ata/exynos-sata-phy.txt    |  14 --
 .../devicetree/bindings/ata/exynos-sata.txt        |  31 ++-
 .../devicetree/bindings/clock/zynq-7000.txt        |   4 +-
 .../devicetree/bindings/phy/samsung-phy.txt        |  40 ++++
 arch/arm/Kconfig.debug                             |   4 +-
 arch/arm/boot/dts/exynos4.dtsi                     |   5 +
 arch/arm/boot/dts/exynos4210-origen.dts            |   2 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |   2 +-
 arch/arm/boot/dts/exynos4210-trats.dts             |   2 +-
 arch/arm/boot/dts/exynos4210-universal_c210.dts    |   2 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |   2 +-
 arch/arm/boot/dts/exynos4212.dtsi                  |  15 +-
 arch/arm/boot/dts/exynos4412-odroidx.dts           |   2 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |   2 +-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |   2 +-
 arch/arm/boot/dts/exynos4412-tiny4412.dts          |   2 +-
 arch/arm/boot/dts/exynos4412-trats2.dts            |  23 ++-
 arch/arm/boot/dts/exynos4412.dtsi                  |  16 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |  26 +++
 arch/arm/boot/dts/exynos5250-arndale.dts           |  23 ++-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  23 ++-
 arch/arm/boot/dts/exynos5250-snow.dts              |   2 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |  30 ++-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |  17 +-
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |   2 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |  13 +-
 arch/arm/boot/dts/exynos5440-sd5v1.dts             |   2 +-
 arch/arm/boot/dts/exynos5440-ssdk5440.dts          |   2 +-
 arch/arm/boot/dts/exynos5440.dtsi                  |   2 +-
 arch/arm/boot/dts/zynq-7000.dtsi                   |  44 ++--
 arch/arm/include/debug/zynq.S                      |   3 +
 arch/arm/mach-exynos/Kconfig                       |  16 +-
 arch/arm/mach-exynos/Makefile                      |   9 +-
 arch/arm/mach-exynos/common.h                      |  17 +-
 arch/arm/mach-exynos/cpuidle.c                     |   3 +-
 arch/arm/mach-exynos/{common.c => exynos.c}        | 229 ++++++++++-----------
 arch/arm/mach-exynos/include/mach/hardware.h       |  18 --
 arch/arm/mach-exynos/include/mach/pm-core.h        |  75 -------
 arch/arm/mach-exynos/mach-exynos4-dt.c             |  59 ------
 arch/arm/mach-exynos/mach-exynos5-dt.c             |  81 --------
 arch/arm/mach-exynos/mfc.h                         |  16 ++
 arch/arm/mach-exynos/platsmp.c                     |   2 -
 arch/arm/mach-exynos/pm.c                          | 172 ++++++++++++----
 arch/arm/mach-exynos/regs-pmu.h                    |   3 +-
 arch/arm/mach-exynos/sleep.S                       |  85 ++++++++
 arch/arm/mach-integrator/core.c                    |   4 +-
 .../{include/mach/platform.h => hardware.h}        | 110 ++++------
 arch/arm/mach-integrator/impd1.c                   |   4 +-
 .../arm/mach-integrator/{include/mach => }/impd1.h |   4 -
 arch/arm/mach-integrator/include/mach/hardware.h   |  45 ----
 arch/arm/mach-integrator/integrator_ap.c           |   6 +-
 arch/arm/mach-integrator/integrator_cp.c           |  17 +-
 arch/arm/mach-integrator/leds.c                    |   4 +-
 arch/arm/mach-integrator/lm.c                      |   2 +-
 arch/arm/mach-integrator/{include/mach => }/lm.h   |   0
 arch/arm/mach-integrator/pci_v3.c                  |   4 +-
 arch/arm/mach-s3c24xx/include/mach/hardware.h      |  14 +-
 arch/arm/mach-s3c24xx/include/mach/uncompress.h    |  57 -----
 arch/arm/mach-s3c64xx/include/mach/pm-core.h       |   2 +
 arch/arm/mach-s3c64xx/include/mach/uncompress.h    |  31 ---
 arch/arm/mach-s3c64xx/pm.c                         |   1 -
 arch/arm/mach-s5p64x0/include/mach/pm-core.h       |   2 +
 arch/arm/mach-s5p64x0/include/mach/uncompress.h    |  34 ---
 arch/arm/mach-s5p64x0/pm.c                         |   1 -
 arch/arm/mach-s5pc100/include/mach/uncompress.h    |  30 ---
 arch/arm/mach-s5pv210/include/mach/uncompress.h    |  28 ---
 arch/arm/mach-zynq/Kconfig                         |   2 +
 arch/arm/mach-zynq/common.c                        |   8 +-
 arch/arm/mach-zynq/common.h                        |   2 +-
 arch/arm/mach-zynq/slcr.c                          | 104 ++++++++--
 arch/arm/plat-samsung/Makefile                     |   2 +
 arch/arm/plat-samsung/clock.c                      |   1 -
 arch/arm/plat-samsung/devs.c                       |   2 +-
 arch/arm/plat-samsung/include/plat/cpu.h           |  10 +
 arch/arm/plat-samsung/include/plat/mfc.h           |   3 -
 arch/arm/plat-samsung/include/plat/pm-common.h     | 110 ++++++++++
 arch/arm/plat-samsung/include/plat/pm.h            |  80 +------
 arch/arm/plat-samsung/include/plat/uncompress.h    | 175 ----------------
 arch/arm/plat-samsung/init.c                       |   2 -
 arch/arm/plat-samsung/pm-check.c                   |   2 +-
 arch/arm/plat-samsung/pm-common.c                  |  75 +++++++
 arch/arm/plat-samsung/pm-debug.c                   |  97 +++++++++
 arch/arm/plat-samsung/pm.c                         | 145 -------------
 arch/arm/plat-samsung/s5p-dev-mfc.c                |  17 +-
 arch/arm/plat-samsung/s5p-dev-uart.c               |   1 -
 arch/arm/plat-samsung/s5p-sleep.S                  |  43 ----
 drivers/clk/samsung/clk-exynos-audss.c             |   2 +-
 drivers/clk/versatile/clk-impd1.c                  |   6 +-
 drivers/clk/zynq/clkc.c                            |  89 +++++---
 .../dt-bindings/{clk => clock}/exynos-audss-clk.h  |   0
 include/linux/clk/zynq.h                           |   2 +-
 include/linux/serial_s3c.h                         |   2 +
 92 files changed, 1157 insertions(+), 1369 deletions(-)
