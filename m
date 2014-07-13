Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaGMS3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:29:49 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34324 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaGMS3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:29:42 -0400
Date: Sun, 13 Jul 2014 11:30:06 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.16-rc
Message-ID: <20140713183006.GA30422@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to cacadb4ff969a82628d47db87b5a531be466b134:

  Merge tag 'samsung-fixes-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2014-07-12 21:19:21 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.16-rc

This week's arm-soc fixes:

- Another set of OMAP fixes
  * Clock fixes
  * Restart handling
  * PHY regulators
  * SATA hwmod data for DRA7
  + Some trivial fixes and removal of a bit of dead code
- Exynos fixes
  * A bunch of clock fixes
  * Some SMP fixes
  * Exynos multi-core timer: register as clocksource and fix ftrace.
  + a few other minor fixes

There's also a couple more patches, and at91 fix for USB caused by common
clock conversion, and more MAINTAINERS entries for shmobile.

We're definitely switching to only regression fixes from here on out,
we've been a little less strict than usual up until now.

----------------------------------------------------------------
Abhilash Kesavan (1):
      ARM: EXYNOS: Fix the check for non-smp configuration

Amit Daniel Kachhap (1):
      clocksource: exynos_mct: Register the timer for stable udelay

Arun Kumar K (2):
      clk: exynos5420: Add IDs for clocks used in PD mfc
      ARM: dts: Add clock property for mfc_pd in exynos5420

Bo Shen (1):
      ARM: at91: at91sam9x5: add clocks for usb device

Doug Anderson (1):
      clocksource: exynos_mct: Fix ftrace

Enric Balletbo i Serra (1):
      ARM: dts: Fix TI CPSW Phy mode selection on IGEP COM AQUILA.

Guido Martínez (1):
      ARM: OMAP2+: Make GPMC skip disabled devices

Jaewon Kim (1):
      ARM: dts: fix pwm-cells in pwm node for exynos4

Jyri Sarha (1):
      ARM: OMAP2+: Remove non working OMAP HDMI audio initialization

Nishanth Menon (1):
      ARM: DRA7/AM43XX: fix header definition for omap44xx_restart

Olof Johansson (4):
      Merge tag 'renesas-maintainers-for-v3.17' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'samsung-fixes-2' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'omap-for-v3.16/fixes-rc4' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'samsung-fixes-3' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Peter Ujfalusi (2):
      ARM: dts: am335x-evm: Enable the McASP FIFO for audio
      ARM: dts: am335x-evmsk: Enable the McASP FIFO for audio

Prathyush K (1):
      ARM: EXYNOS: Add support for clock handling in power domain

Rajendra Nayak (1):
      ARM: dts: dra7xx-clocks: Fix the l3 and l4 clock rates

Roger Quadros (3):
      ARM: DRA7: hwmod: Fixup SATA hwmod
      ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss
      ARM: dts: dra7-evm: Make VDDA_1V8_PHY supply always on

Sachin Kamat (1):
      ARM: EXYNOS: Update secondary boot addr for secure mode

Shawn Guo (1):
      ARM: imx: fix shared gate clock

Simon Horman (1):
      ARM: shmobile: Add DT and defconfigs to MAINTAINERS

Suman Anna (2):
      ARM: OMAP3: PRM/CM: Add back macros used by TI DSP/Bridge driver
      ARM: OMAP2+: create dsp device only on OMAP3 SoCs

Tero Kristo (1):
      ARM: OMAP2+: clock/dpll: fix _dpll_test_fint arithmetics overflow

Tomasz Figa (1):
      ARM: EXYNOS: Register cpuidle device only on exynos4210 and 5250

Tony Lindgren (2):
      Merge branch 'for-v3.16-rc/clk-dt-fixes' of https://github.com/t-kristo/linux-pm into fixes-rc4
      Merge tag 'for-v3.16-rc/omap-fixes-b' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.16/fixes

Tushar Behera (1):
      ARM: dts: Update the parent for Audss clocks in Exynos5420

 .../bindings/arm/exynos/power_domain.txt           | 20 +++++++
 MAINTAINERS                                        | 14 +++++
 arch/arm/boot/dts/am335x-evm.dts                   |  4 +-
 arch/arm/boot/dts/am335x-evmsk.dts                 |  4 +-
 arch/arm/boot/dts/am335x-igep0033.dtsi             |  6 +++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  2 +
 arch/arm/boot/dts/dra7-evm.dts                     |  1 +
 arch/arm/boot/dts/dra7xx-clocks.dtsi               | 10 ++--
 arch/arm/boot/dts/exynos4.dtsi                     |  2 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |  5 +-
 arch/arm/mach-exynos/exynos.c                      |  8 ++-
 arch/arm/mach-exynos/firmware.c                    |  9 +++-
 arch/arm/mach-exynos/pm_domains.c                  | 61 +++++++++++++++++++++-
 arch/arm/mach-imx/clk-gate2.c                      | 31 ++++++++---
 arch/arm/mach-omap2/clkt_dpll.c                    |  2 +-
 arch/arm/mach-omap2/cm-regbits-34xx.h              |  3 ++
 arch/arm/mach-omap2/common.h                       |  3 +-
 arch/arm/mach-omap2/devices.c                      | 28 ----------
 arch/arm/mach-omap2/dsp.c                          | 10 ++++
 arch/arm/mach-omap2/gpmc.c                         |  2 +-
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          | 18 +++++--
 arch/arm/mach-omap2/prm-regbits-34xx.h             |  6 +++
 drivers/clk/samsung/clk-exynos5420.c               |  6 ++-
 drivers/clocksource/exynos_mct.c                   | 20 ++++++-
 include/dt-bindings/clock/exynos5420.h             |  2 +
 25 files changed, 211 insertions(+), 66 deletions(-)
