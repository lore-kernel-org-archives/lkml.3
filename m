Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3ALRhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:37:06 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47504 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3ALRhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:37:04 -0500
Message-ID: <50F19F3D.60502@gmail.com>
Date: Sat, 12 Jan 2013 11:37:01 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "arm@kernel.org" <arm@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [GIT PULL] irqchip init infrastructure and GIC/VIC move
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Please pull for 3.9. This is the initial infrastructure and conversion
of the GIC and VIC to use it. Several people are waiting for the irqchip 
infrastructure to go in in order to convert other irqchip code over.

I've left "static asmlinkage" in on the irq handlers. There's been no 
more discussion, so I think we are in agreement. If asmlinkage defines 
the procedure call convention for assembly calls, then it still makes 
sense to have it on a static function called thru a function pointer.

Rob 

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://sources.calxeda.com/kernel/linux.git tags/gic-vic-to-irqchip

for you to fetch changes up to 9e47b8bf9815523a5816f2f83e73b13812d74014:

  irqchip: Move ARM vic.h to include/linux/irqchip/arm-vic.h (2013-01-12 10:52:16 -0600)

----------------------------------------------------------------
Initial irqchip init infrastructure and GIC and VIC clean-ups

This creates irqchip initialization infrastructure from Thomas
Petazzoni. The VIC and GIC irqchip code is moved to drivers/irqchips
and adapted to use the new infrastructure. All DT enabled platforms
using GIC and VIC are converted over to use the new irqchip_init.

----------------------------------------------------------------
Rob Herring (16):
      ARM: GIC: remove assembly ifdefs from gic.h
      ARM: GIC: remove direct use of gic_raise_softirq
      ARM: GIC: set handle_arch_irq in GIC initialization
      ARM: remove mach .handle_irq for GIC users
      irqchip: Move ARM GIC to drivers/irqchip
      ARM: use common irqchip_init for GIC init
      irqchip: Move ARM gic.h to include/linux/irqchip/arm-gic.h
      ARM: VIC: shrink down vic.h
      ARM: VIC: set handle_arch_irq in VIC initialization
      ARM: remove mach .handle_irq for VIC users
      ARM: remove unneeded vic.h includes
      ARM: samsung: remove unused tick.h
      irqchip: Move ARM VIC to drivers/irqchip
      ARM: spear: use common irqchip_init function
      ARM: picoxcell: use common irqchip_init function
      irqchip: Move ARM vic.h to include/linux/irqchip/arm-vic.h

Srinidhi Kasagar (1):
      ARM: mach-ux500: use SGI0 to wake up the other core

Thomas Petazzoni (3):
      irqchip: add to the directories part of the IRQ subsystem in MAINTAINERS
      irqchip: add basic infrastructure
      arm: add set_handle_irq() to register the parent IRQ controller handler function

 MAINTAINERS                                        |    1 +
 arch/arm/common/Kconfig                            |   23 -----
 arch/arm/common/Makefile                           |    2 -
 arch/arm/include/asm/mach/irq.h                    |    1 +
 arch/arm/kernel/irq.c                              |   10 +++
 arch/arm/kernel/smp.c                              |    3 +-
 arch/arm/kernel/smp_twd.c                          |    1 -
 arch/arm/mach-bcm/board_bcm.c                      |   17 +---
 arch/arm/mach-cns3xxx/cns3420vb.c                  |    2 -
 arch/arm/mach-cns3xxx/core.c                       |    2 +-
 arch/arm/mach-ep93xx/adssphere.c                   |    2 -
 arch/arm/mach-ep93xx/core.c                        |    3 +-
 arch/arm/mach-ep93xx/edb93xx.c                     |    9 --
 arch/arm/mach-ep93xx/gesbc9312.c                   |    2 -
 arch/arm/mach-ep93xx/micro9.c                      |    5 --
 arch/arm/mach-ep93xx/simone.c                      |    2 -
 arch/arm/mach-ep93xx/snappercl15.c                 |    2 -
 arch/arm/mach-ep93xx/ts72xx.c                      |    2 -
 arch/arm/mach-ep93xx/vision_ep9307.c               |    2 -
 arch/arm/mach-exynos/common.c                      |   10 ++-
 arch/arm/mach-exynos/include/mach/regs-irq.h       |    2 +-
 arch/arm/mach-exynos/mach-armlex4210.c             |    2 -
 arch/arm/mach-exynos/mach-exynos4-dt.c             |    2 -
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    2 -
 arch/arm/mach-exynos/mach-nuri.c                   |    2 -
 arch/arm/mach-exynos/mach-origen.c                 |    2 -
 arch/arm/mach-exynos/mach-smdk4x12.c               |    3 -
 arch/arm/mach-exynos/mach-smdkv310.c               |    3 -
 arch/arm/mach-exynos/mach-universal_c210.c         |    2 -
 arch/arm/mach-exynos/mct.c                         |    1 -
 arch/arm/mach-exynos/platsmp.c                     |    6 +-
 arch/arm/mach-highbank/highbank.c                  |   11 +--
 arch/arm/mach-highbank/platsmp.c                   |    6 +-
 arch/arm/mach-imx/common.h                         |    1 -
 arch/arm/mach-imx/gpc.c                            |    2 +-
 arch/arm/mach-imx/mach-imx6q.c                     |   10 +--
 arch/arm/mach-imx/platsmp.c                        |    4 +-
 arch/arm/mach-msm/board-dt-8660.c                  |   16 +---
 arch/arm/mach-msm/board-dt-8960.c                  |   16 +---
 arch/arm/mach-msm/platsmp.c                        |    6 +-
 arch/arm/mach-msm/timer.c                          |    1 -
 arch/arm/mach-netx/generic.c                       |    2 +-
 arch/arm/mach-netx/nxdb500.c                       |    2 -
 arch/arm/mach-netx/nxdkn.c                         |    2 -
 arch/arm/mach-netx/nxeb500hmi.c                    |    2 -
 arch/arm/mach-nomadik/board-nhk8815.c              |    2 -
 arch/arm/mach-nomadik/cpu-8815.c                   |    2 +-
 arch/arm/mach-omap2/board-4430sdp.c                |    3 +-
 arch/arm/mach-omap2/board-generic.c                |    3 -
 arch/arm/mach-omap2/board-omap4panda.c             |    3 +-
 arch/arm/mach-omap2/omap-smp.c                     |    6 +-
 arch/arm/mach-omap2/omap-wakeupgen.c               |    3 +-
 arch/arm/mach-omap2/omap4-common.c                 |   11 +--
 arch/arm/mach-picoxcell/common.c                   |   15 +---
 arch/arm/mach-realview/core.c                      |    1 -
 arch/arm/mach-realview/platsmp.c                   |    3 -
 arch/arm/mach-realview/realview_eb.c               |    3 +-
 arch/arm/mach-realview/realview_pb1176.c           |    3 +-
 arch/arm/mach-realview/realview_pb11mp.c           |    3 +-
 arch/arm/mach-realview/realview_pba8.c             |    3 +-
 arch/arm/mach-realview/realview_pbx.c              |    3 +-
 arch/arm/mach-s3c64xx/common.c                     |    2 +-
 arch/arm/mach-s3c64xx/include/mach/regs-irq.h      |    1 -
 arch/arm/mach-s3c64xx/include/mach/tick.h          |    2 +
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    2 -
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    2 -
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    2 -
 arch/arm/mach-s3c64xx/mach-mini6410.c              |    2 -
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    2 -
 arch/arm/mach-s3c64xx/mach-real6410.c              |    2 -
 arch/arm/mach-s3c64xx/mach-smartq5.c               |    2 -
 arch/arm/mach-s3c64xx/mach-smartq7.c               |    2 -
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |    2 -
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    2 -
 arch/arm/mach-s5p64x0/include/mach/regs-irq.h      |    1 -
 arch/arm/mach-s5p64x0/include/mach/tick.h          |   29 ------
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |    2 -
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |    2 -
 arch/arm/mach-s5pc100/include/mach/regs-irq.h      |    1 -
 arch/arm/mach-s5pc100/include/mach/tick.h          |    2 +
 arch/arm/mach-s5pc100/mach-smdkc100.c              |    2 -
 arch/arm/mach-s5pv210/include/mach/regs-irq.h      |    1 -
 arch/arm/mach-s5pv210/include/mach/tick.h          |   26 ------
 arch/arm/mach-s5pv210/mach-aquila.c                |    2 -
 arch/arm/mach-s5pv210/mach-goni.c                  |    2 -
 arch/arm/mach-s5pv210/mach-smdkc110.c              |    2 -
 arch/arm/mach-s5pv210/mach-smdkv210.c              |    2 -
 arch/arm/mach-s5pv210/mach-torbreck.c              |    2 -
 arch/arm/mach-shmobile/board-ag5evm.c              |    3 +-
 arch/arm/mach-shmobile/board-kota2.c               |    3 +-
 arch/arm/mach-shmobile/board-kzm9d.c               |    2 -
 arch/arm/mach-shmobile/board-kzm9g.c               |    3 +-
 arch/arm/mach-shmobile/board-marzen.c              |    2 -
 arch/arm/mach-shmobile/intc-r8a7779.c              |    2 +-
 arch/arm/mach-shmobile/intc-sh73a0.c               |    2 +-
 arch/arm/mach-shmobile/platsmp.c                   |    3 -
 arch/arm/mach-shmobile/setup-emev2.c               |   17 +---
 arch/arm/mach-shmobile/smp-emev2.c                 |    4 +-
 arch/arm/mach-shmobile/smp-r8a7779.c               |    2 +-
 arch/arm/mach-shmobile/smp-sh73a0.c                |    2 +-
 arch/arm/mach-socfpga/platsmp.c                    |    4 +-
 arch/arm/mach-socfpga/socfpga.c                    |   14 +--
 arch/arm/mach-spear13xx/include/mach/generic.h     |    1 -
 arch/arm/mach-spear13xx/platsmp.c                  |    4 +-
 arch/arm/mach-spear13xx/spear1310.c                |    5 +-
 arch/arm/mach-spear13xx/spear1340.c                |    5 +-
 arch/arm/mach-spear13xx/spear13xx.c                |   13 +--
 arch/arm/mach-spear3xx/include/mach/generic.h      |    1 -
 arch/arm/mach-spear3xx/spear300.c                  |    5 +-
 arch/arm/mach-spear3xx/spear310.c                  |    5 +-
 arch/arm/mach-spear3xx/spear320.c                  |    5 +-
 arch/arm/mach-spear3xx/spear3xx.c                  |   16 ----
 arch/arm/mach-spear6xx/spear6xx.c                  |   16 +---
 arch/arm/mach-sunxi/sunxi.c                        |    2 -
 arch/arm/mach-tegra/board-dt-tegra20.c             |    3 -
 arch/arm/mach-tegra/board-dt-tegra30.c             |    2 -
 arch/arm/mach-tegra/common.c                       |   10 +--
 arch/arm/mach-tegra/irq.c                          |    3 +-
 arch/arm/mach-tegra/platsmp.c                      |    4 +-
 arch/arm/mach-u300/core.c                          |    3 +-
 arch/arm/mach-ux500/board-mop500.c                 |    5 --
 arch/arm/mach-ux500/cpu-db8500.c                   |    2 -
 arch/arm/mach-ux500/cpu.c                          |   10 +--
 arch/arm/mach-ux500/platsmp.c                      |    6 +-
 arch/arm/mach-versatile/core.c                     |    2 +-
 arch/arm/mach-versatile/versatile_ab.c             |    2 -
 arch/arm/mach-versatile/versatile_dt.c             |    2 -
 arch/arm/mach-versatile/versatile_pb.c             |    2 -
 arch/arm/mach-vexpress/ct-ca9x4.c                  |    4 +-
 arch/arm/mach-vexpress/platsmp.c                   |    3 -
 arch/arm/mach-vexpress/v2m.c                       |   16 +---
 arch/arm/mach-zynq/common.c                        |   17 +---
 arch/arm/plat-samsung/s5p-irq-eint.c               |    3 +-
 arch/arm/plat-samsung/s5p-irq.c                    |    3 +-
 arch/arm/plat-versatile/platsmp.c                  |    4 +-
 drivers/irqchip/Kconfig                            |   27 ++++++
 drivers/irqchip/Makefile                           |    6 +-
 arch/arm/common/gic.c => drivers/irqchip/irq-gic.c |   59 +++++++-----
 arch/arm/common/vic.c => drivers/irqchip/irq-vic.c |   95 ++++++++++++--------
 drivers/irqchip/irqchip.c                          |   30 +++++++
 drivers/irqchip/irqchip.h                          |   29 ++++++
 drivers/irqchip/spear-shirq.c                      |    5 ++
 drivers/mfd/db8500-prcmu.c                         |    2 +-
 include/asm-generic/vmlinux.lds.h                  |   12 ++-
 include/linux/irqchip.h                            |   16 ++++
 .../gic.h => include/linux/irqchip/arm-gic.h       |   15 +---
 .../vic.h => include/linux/irqchip/arm-vic.h       |   25 +-----
 147 files changed, 338 insertions(+), 607 deletions(-)
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/tick.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/tick.h
 rename arch/arm/common/gic.c => drivers/irqchip/irq-gic.c (97%)
 rename arch/arm/common/vic.c => drivers/irqchip/irq-vic.c (92%)
 create mode 100644 drivers/irqchip/irqchip.c
 create mode 100644 drivers/irqchip/irqchip.h
 create mode 100644 include/linux/irqchip.h
 rename arch/arm/include/asm/hardware/gic.h => include/linux/irqchip/arm-gic.h (77%)
 rename arch/arm/include/asm/hardware/vic.h => include/linux/irqchip/arm-vic.h (63%)
