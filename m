Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3EBHFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:05:14 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:38339 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab3EBHFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:05:04 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/5] ARM: arm-soc non-critical fixes for 3.10
Date: Wed,  1 May 2013 23:58:32 -0700
Message-Id: <1367477916-28399-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1367477916-28399-1-git-send-email-olof@lixom.net>
References: <1367477916-28399-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a collection of fixes (and some intermixed cleanups) that were
considered less important and thus not included in the later parts of
the 3.9-rc cycle.

It's a bit all over the map, contents wise. A series of ux500 fixes
and cleanups, a bunch of various fixes for OMAP and tegra, and some for
Freescale i.MX and even Qualcomm MSM.

Note that there's also a patch on this branch to globally turn off
-Wmaybe-uninitialized when building with -Os. It's been posted several
times by Arnd and no dissent was raised, but nobody seemed interested
to pick it up. So here it is, as the topmost patch.


Conflicts:

arch/arm/boot/dts/dbx5x0.dtsi: Change/add conflict with a fix from
3.9. The first reg entry should have size 0x2000, and the two new regs
(and names) should stay.

----------------------------------------------------------------

The following changes since commit 20b4fb485227404329e41ad15588afad3df23050:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-nc-for-linus

for you to fetch changes up to e74fc973b6e531fef1fce8b101ffff05ecfb774c:

  Turn off -Wmaybe-uninitialized when building with -Os

----------------------------------------------------------------

Arnd Bergmann (8):
      Merge tag 'ux500-dt-fixes' of git://git.kernel.org/.../linusw/linux-stericsson into next/fixes-non-critical
      Merge tag 'v3.9-rc1_cns3xxx_fixes' of git://git.infradead.org/users/cbou/linux-cns3xxx into next/fixes-non-critical
      Merge tag 'omap-for-v3.10/fixes-non-critical-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge tag 'tegra-for-3.10-fixes' of git://git.kernel.org/.../swarren/linux-tegra into next/fixes-non-critical
      ARM: OMAP2+: add dependencies on ARCH_MULTI_V6/V7
      ARM: tegra: call cpu_do_idle from C code
      ARM: orion5x: include linux/cpu.h
      Turn off -Wmaybe-uninitialized when building with -Os

Fabio Estevam (15):
      ARM: mach-imx: cpu: Include "common.h"
      ARM: mach-imx: mm-imx3: Staticize imx3_init_l2x0()
      ARM: mach-imx: iomux-imx31: Staticize mxc_pin_alloc_map
      ARM: mach-imx: cpu-imx5: Include "common.h"
      ARM: mach-imx: clk-pllv1: Staticize clk_pllv1_ops
      ARM: mach-imx: clk-pllv2: Staticize clk_pllv2_ops
      ARM: mach-imx: clk-gate2: Include "clk.h"
      ARM: mach-imx: irq-common: Remove imx_irq_set_priority()
      ARM: mach-imx: clk-busy: Staticize clk_busy_mux_ops
      ARM: mach-imx: clk: Include "clk.h"
      ARM: mach-imx: tzic: Staticize *tzic_base
      ARM: mach-imx: avic: Staticize *avic_base
      ARM: mach-imx: gpc: Include "common.h"
      ARM: mach-imx: src: Include "common.h
      ARM: mach-imx: mach-imx6q: Fix sparse warnings

Hiroshi Doyu (2):
      ARM: tegra: Fix unchecked return value
      memory: tegra30: Fix build error w/o PM

Joseph Lo (5):
      ARM: dts: tegra: fix the activate polarity of cd-gpio in mmc host
      ARM: tegra: don't unlock MMIO access to DBGLAR
      ARM: tegra: fix the logical detection of power on sequence of warm boot CPUs
      ARM: tegra: fix build error when THUMB2_KERNEL enabled
      ARM: tegra: fix relocation truncated error when THUMB2_KERNEL enabled

Lee Jones (16):
      ARM: ux500: Change IRQ from low-to-high edge triggered to high-to-low
      ARM: ux500: Include the PRCMU's Secure Registers in DB8500's DT
      ARM: ux500: Provide a means to obtain the SMSC9115 clock when DT is enabled
      clk: ux500: Ensure the FMSC clock is obtainable
      clk: ux500: Provide an alias for the SMSC911x Ethernet chip
      net/smsc911x: Provide common clock functionality
      mmc: mmci: Move ios_handler functionality into the driver
      ARM: ux500: Set correct MMCI regulator voltages in the ux5x0 Device Tree
      ARM: ux500: Specify the ux5x0 MMCI regulator's on/off GPIO as high-enable
      ARM: ux500: Specify which IOS regulator to use for MMCI
      ARM: ux500: Use the correct name when supplying a GPIO enable pin
      ARM: ux500: Setup correct settling time for the MMCI regulator
      ARM: ux500: Use the GPIO regulator framework for SDI0's 'en' and 'vsel'
      ARM: ux500: Remove traces of the ios_handler from platform code
      ARM: ux500: enable AB8500 GPIO for HREF
      ARM: ux500: allow Snowball access to the AB8500 GPIO pins

Linus Walleij (1):
      ARM: u300: fix ages old copy/paste bug

Mac Lin (1):
      ARM: cns3xxx: remove unused virtual address and iotable defines

Olof Johansson (2):
      Merge tag 'imx-noncritical-fixes-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/fixes-non-critical
      Merge tag 'msm-fix-3.10' of git://git.kernel.org/.../davidb/linux-msm into next/fixes-non-critical

Paul Bolle (4):
      ARM: OMAP: fix typo "CONFIG_SMC91x_MODULE"
      ARM: OMAP1: remove "config MACH_OMAP_HTCWIZARD"
      ARM: OMAP2+: fix typo "CONFIG_BRIDGE_DVFS"
      ARM: cpuimx27 and mbimx27: prepend CONFIG_ to Kconfig macro

Paul Walmsley (1):
      ARM: OMAP2+: powerdomain: avoid testing whether an unsigned char is less than 0

Pawel Moll (1):
      ARM: vexpress: Remove A9 PMU compatible values for non-A9 platforms

Peter De Schrijver (1):
      clk: tegra: No 7.1 super clk dividers on Tegra20

Rajendra Nayak (3):
      ARM: OMAP5: clock: No Freqsel on OMAP5 devices too
      ARM: OMAP2+: hwmod: Remove unused _HWMOD_WAKEUP_ENABLED flag
      ARM: OMAP: dpll: enable bypass clock only when attempting dpll bypass

Santosh Shilimkar (6):
      ARM: OMAP5: Update SOC id detection code for ES2
      ARM: OMAP5: timer: Update the clocksource name as per clock data
      ARM: OMAP5: prm: Allow prm init to succeed
      ARM: OMAP5: Update SAR RAM base address
      ARM: OMAP5: Update SAR memory layout for WakeupGen
      ARM: OMAP5: Make errata i688 workaround available

Stephen Boyd (1):
      ARM: msm: Fix uncompess.h tx underrun check

Stephen Warren (4):
      ARM: tegra: add CPU errata WARs to Tegra reset handler
      ARM: tegra: remove save/restore of CPU diag register
      ARM: tegra: fix ignored return value of regulator_enable
      ARM: tegra: solve adr range issue with THUMB2_KERNEL enabled

Tero Kristo (1):
      ARM: OMAP5: Reuse prm read_inst/write_inst

Thierry Reding (2):
      ARM: tegra: Export tegra_powergate_sequence_power_up()
      ARM: tegra: powergate: Don't error out if new state == old state

Tony Lindgren (2):
      Merge tag 'omap-devel-b-for-3.10' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.10/fixes-non-critical
      Merge branch 'for_3.10/omap5_generic_updates' of git://git.kernel.org/.../ssantosh/linux into omap-for-v3.10/fixes-non-critical

Vaibhav Hiremath (2):
      ARM: OMAP2+: AM33xx: hwmod: Add missing sysc definition to wdt1 entry
      ARM: OMAP2+: am335x: Change the wdt1 func clk src to per_32k clk


 Makefile                                      |  2 +-
 arch/arm/boot/dts/dbx5x0.dtsi                 |  7 ++-
 arch/arm/boot/dts/href.dtsi                   |  1 +
 arch/arm/boot/dts/hrefprev60.dts              | 10 ++++-
 arch/arm/boot/dts/snowball.dts                |  4 ++
 arch/arm/boot/dts/stuib.dtsi                  |  2 +-
 arch/arm/boot/dts/tegra20-colibri-512.dtsi    |  2 +-
 arch/arm/boot/dts/tegra20-harmony.dts         |  4 +-
 arch/arm/boot/dts/tegra20-paz00.dts           |  2 +-
 arch/arm/boot/dts/tegra20-seaboard.dts        |  2 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi       |  2 +-
 arch/arm/boot/dts/tegra20-trimslice.dts       |  2 +-
 arch/arm/boot/dts/tegra20-ventana.dts         |  2 +-
 arch/arm/boot/dts/tegra20-whistler.dts        |  1 +
 arch/arm/boot/dts/tegra30-beaver.dts          |  2 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi         |  2 +-
 arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts   |  2 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts    |  2 +-
 arch/arm/boot/dts/vexpress-v2p-ca5s.dts       |  2 +-
 arch/arm/mach-cns3xxx/core.c                  | 10 -----
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h  | 27 ------------
 arch/arm/mach-imx/avic.c                      |  2 +-
 arch/arm/mach-imx/clk-busy.c                  |  2 +-
 arch/arm/mach-imx/clk-gate2.c                 |  1 +
 arch/arm/mach-imx/clk-pllv1.c                 |  2 +-
 arch/arm/mach-imx/clk-pllv2.c                 |  2 +-
 arch/arm/mach-imx/clk.c                       |  1 +
 arch/arm/mach-imx/cpu-imx5.c                  |  1 +
 arch/arm/mach-imx/cpu.c                       |  1 +
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c  |  4 +-
 arch/arm/mach-imx/gpc.c                       |  1 +
 arch/arm/mach-imx/iomux-imx31.c               |  2 +-
 arch/arm/mach-imx/irq-common.c                | 19 --------
 arch/arm/mach-imx/mach-cpuimx27.c             |  4 +-
 arch/arm/mach-imx/mach-imx6q.c                |  4 +-
 arch/arm/mach-imx/mm-imx3.c                   |  2 +-
 arch/arm/mach-imx/src.c                       |  1 +
 arch/arm/mach-imx/tzic.c                      |  2 +-
 arch/arm/mach-msm/include/mach/uncompress.h   |  2 +-
 arch/arm/mach-omap1/Kconfig                   |  6 ---
 arch/arm/mach-omap2/Kconfig                   |  7 ++-
 arch/arm/mach-omap2/board-2430sdp.c           |  2 +-
 arch/arm/mach-omap2/board-h4.c                |  2 +-
 arch/arm/mach-omap2/cclock33xx_data.c         |  8 ++++
 arch/arm/mach-omap2/dpll3xxx.c                | 30 ++++++-------
 arch/arm/mach-omap2/dsp.c                     |  4 +-
 arch/arm/mach-omap2/id.c                      | 12 +++--
 arch/arm/mach-omap2/io.c                      |  9 ++++
 arch/arm/mach-omap2/omap4-common.c            | 10 ++++-
 arch/arm/mach-omap2/omap4-sar-layout.h        | 14 +++---
 arch/arm/mach-omap2/omap54xx.h                |  1 +
 arch/arm/mach-omap2/omap_hwmod.c              |  4 --
 arch/arm/mach-omap2/omap_hwmod.h              |  6 +--
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c    | 15 +++++++
 arch/arm/mach-omap2/powerdomain.c             | 18 ++++----
 arch/arm/mach-omap2/prm44xx.c                 |  6 +--
 arch/arm/mach-omap2/soc.h                     |  2 +
 arch/arm/mach-omap2/timer.c                   |  5 ++-
 arch/arm/mach-orion5x/common.c                |  1 +
 arch/arm/mach-tegra/board-harmony-pcie.c      |  7 ++-
 arch/arm/mach-tegra/cpuidle-tegra30.c         |  4 --
 arch/arm/mach-tegra/headsmp.S                 |  3 --
 arch/arm/mach-tegra/platsmp.c                 |  5 ++-
 arch/arm/mach-tegra/pm.c                      | 24 +++-------
 arch/arm/mach-tegra/powergate.c               |  4 +-
 arch/arm/mach-tegra/reset-handler.S           | 49 +++++++++++++++++----
 arch/arm/mach-tegra/sleep-tegra20.S           |  2 +-
 arch/arm/mach-tegra/sleep-tegra30.S           |  4 +-
 arch/arm/mach-tegra/sleep.h                   |  2 +-
 arch/arm/mach-u300/include/mach/u300-regs.h   |  2 +-
 arch/arm/mach-ux500/board-mop500-regulators.c | 14 ++++++
 arch/arm/mach-ux500/board-mop500-regulators.h |  1 +
 arch/arm/mach-ux500/board-mop500-sdi.c        | 51 ----------------------
 arch/arm/mach-ux500/board-mop500.c            | 45 +++++++++++++++++++
 arch/arm/mach-ux500/cpu-db8500.c              |  1 +
 drivers/clk/tegra/clk-tegra20.c               | 36 +--------------
 drivers/clk/ux500/u8500_clk.c                 |  3 +-
 drivers/mmc/host/mmci.c                       |  9 ++++
 drivers/net/ethernet/smsc/smsc911x.c          | 29 +++++++++++-
 79 files changed, 321 insertions(+), 279 deletions(-)
