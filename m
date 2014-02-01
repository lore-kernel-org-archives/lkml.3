Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbaBAU2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 15:28:48 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39202 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbaBAU2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 15:28:47 -0500
Date: Sat, 1 Feb 2014 12:28:44 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC "fixes" for 3.14-rc1
Message-ID: <20140201202844.GA12650@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

See tag for branch contents. As you'll see, the commit dates are recent;
we've mostly collected these fixes in the last few days but I also had
to rebuild the branch yesterday to sort out some internal conflicts
which reset the timestamps. The changes should have been tested by each
platform maintainer already (and few of them have cross-platform impact)
so I'm personally not too concerned by it at this time.

Please pull.

Thanks!


-Olof

The following changes since commit e7651b819e90da924991d727d3c007200a18670d:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs (2014-01-30 20:08:20 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to f39aa2753724215706d150fac5cb4a989793faef:

  ARM: multi_v7_defconfig: remove redundant entries and re-enable TI_EDMA (2014-01-31 21:04:33 -0800)

----------------------------------------------------------------
ARM: SoC fixes for 3.14-rc1

Here's a set of patches for (hopefully) -rc1. Some of them are fixes,
but a good number of them also do things such as enable new drivers in
the defconfigs for platforms that have such devices, increases coverage
of the multiplatform defconfig and some DTS changes that plumbs up some
of the devices that now have bindings and driver support.

----------------------------------------------------------------
Arnaud Ebalard (1):
      ARM: mvebu: fix compilation warning on Armada 370 (i.e. non-SMP)

Barry Song (1):
      MAINTAINERS: ARM: SiRF: use regex patterns to involve all SiRF drivers

Ben Dooks (1):
      ARM: shmobile: r8a7790.dtsi: ficx i2c[0-3] clock reference

Ezequiel Garcia (1):
      ARM: kirkwood: kirkwood_pm_init() should return void

Fabio Estevam (1):
      ARM: multi_v7_defconfig: Select CONFIG_AT803X_PHY

Gregory CLEMENT (1):
      ARM: mvebu: Fix kernel hang in mvebu_soc_id_init() when of_iomap failed

Grygorii Strashko (1):
      ARM: keystone: config: fix build warning when CONFIG_DMADEVICES is not set

Linus Walleij (2):
      ARM: integrator: restore static map on the CP
      ARM: iop32x: fix power off handling for the EM7210 board

Lorenzo Pieralisi (1):
      drivers: bus: fix CCI driver kcalloc call parameters swap

Nishanth Menon (1):
      ARM: OMAP4+: move errata initialization to omap4_pm_init_early

Olof Johansson (4):
      Merge tag 'mvebu-fixes-3.13-2' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'renesas-dt-fixes2-for-v3.14' of git://git.kernel.org/.../horms/renesas into fixes
      ARM: multi_v7_defconfig: add mvebu drivers
      ARM: multi_v7_defconfig: remove redundant entries and re-enable TI_EDMA

Rob Herring (1):
      ARM: hisi: don't select SMP

Sebastian Hesselbarth (1):
      ARM: orion: provide C-style interrupt handler for MULTI_IRQ_HANDLER

Soren Brinkmann (1):
      ARM: dts: zynq: Add SDHCI nodes

Stephen Boyd (2):
      ARM: dts: msm: Add clock controller nodes and hook into uart
      ARM: msm_defconfig: Enable MSM clock drivers

Stephen Warren (2):
      ARM: multi_v7: copy most options from tegra_defconfig
      ARM: tegra: rebuild tegra_defconfig to add DEBUG_FS

Strashko, Grygorii (1):
      ARM: OMAP4460: cpuidle: Extend PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD on cpuidle

Tim Kryger (2):
      ARM: dts: bcm28155-ap: Fix Card Detection GPIO
      clocksource: kona: Add basic use of external clock

 MAINTAINERS                               |   9 +-
 arch/arm/boot/dts/bcm28155-ap.dts         |   4 +-
 arch/arm/boot/dts/qcom-msm8660-surf.dts   |  11 +++
 arch/arm/boot/dts/qcom-msm8960-cdp.dts    |  18 ++++
 arch/arm/boot/dts/qcom-msm8974.dtsi       |  24 +++++
 arch/arm/boot/dts/r8a7790.dtsi            |   8 +-
 arch/arm/boot/dts/zynq-7000.dtsi          |  20 ++++
 arch/arm/boot/dts/zynq-zc702.dts          |   4 +
 arch/arm/boot/dts/zynq-zc706.dts          |   4 +
 arch/arm/boot/dts/zynq-zed.dts            |   4 +
 arch/arm/configs/keystone_defconfig       |   1 +
 arch/arm/configs/msm_defconfig            |   4 +
 arch/arm/configs/multi_v7_defconfig       | 154 ++++++++++++++++++++++++++++--
 arch/arm/configs/tegra_defconfig          |  11 +--
 arch/arm/mach-hisi/Kconfig                |   1 -
 arch/arm/mach-integrator/integrator_cp.c  |   6 ++
 arch/arm/mach-iop32x/em7210.c             |  32 ++++++-
 arch/arm/mach-keystone/Kconfig            |   1 -
 arch/arm/mach-kirkwood/pm.c               |   4 +-
 arch/arm/mach-mvebu/mvebu-soc-id.c        |   2 +-
 arch/arm/mach-omap2/common.h              |   7 ++
 arch/arm/mach-omap2/cpuidle44xx.c         |  26 ++++-
 arch/arm/mach-omap2/io.c                  |   1 +
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |   3 +
 arch/arm/mach-omap2/omap-smp.c            |   6 +-
 arch/arm/mach-omap2/omap4-common.c        |   6 ++
 arch/arm/mach-omap2/pm44xx.c              |  15 +++
 arch/arm/plat-orion/irq.c                 |  47 +++++++++
 drivers/bus/arm-cci.c                     |   2 +-
 drivers/clocksource/bcm_kona_timer.c      |  14 ++-
 drivers/irqchip/irq-armada-370-xp.c       |   4 +-
 31 files changed, 396 insertions(+), 57 deletions(-)
