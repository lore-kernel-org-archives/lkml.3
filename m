Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab3EGR03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:26:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218Ab3EGR0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:26:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 4/5] ARM: arm-soc: late cleanups
Date: Tue,  7 May 2013 19:26:13 +0200
Message-Id: <1367947574-2934383-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
References: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Z+tKd/FXC10JULela1Gi5EZVgvANSKHfePgRypvX4SB
 xIb35MHpwH6iNqh9y5EV8hKebbAxcDh4XyESrVecNxn+LRfHsm
 IZLYebpvccaeBWrJjYS9R7n5/8rwqAQZgNOpmAlUEey/9c+YK5
 FtpaOnpabWqAg0ENFiWNGGOiCd/ibNmorVR26Js6fM8Clmq4Z4
 6oHyMwqh9w6Oja1J/YMI7tradeKTaTri2cL/R3zKoBK0kgo7oJ
 ZpYBukkUx5N36Ou9hEOnECIowMM4hMoWzPmb2E5jKpEkng//Ee
 2LAGoyPPvyWoN4VmtA98uUczndqMz/bx7oZWVBJ3pBzrzE021d
 n0WzjrKOu+Ei4TSHRt8dpmEVbcbxdwLr0ZF0FVhDI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are cleanups and smaller changes that either depend on earlier
feature branches or came in late during the development cycle.
We normally try to get all cleanups early, so these are the exceptions:

- A follow-up on the clocksource reworks, hopefully the last time
  we need to merge clocksource subsystem changes through arm-soc.
  A first set of patches was part of the original 3.10 arm-soc cleanup
  series because of interdependencies with timer drivers now moved out
  of arch/arm.

- Migrating the SPEAr13xx platform away from using auxdata for DMA
  channel descriptions towards using information in device tree,
  based on the earlier SPEAr multiplatform series

- A few follow-ups on the Atmel SAMA5 support and other changes
  for Atmel at91 based on the larger at91 reworks.

- Moving the armada irqchip implementation to drivers/irqchip

- Several OMAP cleanups following up on the larger series already
  merged in 3.10.

There are a few more conflicts that we would like now:

Simple conflicts between unrelated add or del hunks:
- arch/arm/Kconfig
- arch/arm/mach-mvebu/Makefile
- arch/arm/mach-mvebu/armada-370-xp.c
- arch/arm/mach-spear/spear13xx.c
- drivers/irqchip/Makefile

And non-obvious ones:
- remove/modify conflict in arch/arm/mach-exynos/mach-exynos5-dt.c:
  keep the modified line
- multiple changes to arch/arm/mach-vexpress/v2m.c:
  keep of_clk_init(NULL), clocksource_of_init() and
  versatile_sched_clock_init() calls


-------------------------------------------------------------

The following changes since commit

   763e6b9 Merge tag 'dt-for-linus-2' into for-next

are available in the git repository at

   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-linus-2

you to fetch changes up to

   0592c21 Merge tag 'omap-for-v3.10/fixes-for-merge-window' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into late/cleanup


-------------------------------------------------------------

Archit Taneja (13):
      arm: omap: board-2430: use generic dpi panel's gpio handling
      arm: omap: board-devkit8000: use generic dpi panel's gpio handling
      arm: omap: board-am3517: use generic dpi panel's gpio handling
      arm: omap: board-ldp: use generic dpi panel's gpio handling
      arm: omap: board-overo: use lb035q02 dpi panel's gpio handling
      arm: omap: board-omap3evm: use sharp panel's gpio handling
      arm: omap: board-sdp3430: use sharp panel's gpio handling
      arm: omap: board-rx-51: use acx565akm panel's gpio handling
      arm: omap: board-zoom: use NEC panel's gpio handling
      arm: omap: board-omap3pandora: use tpo panel's gpio handling
      arm: omap: dss-common: use picodlp panel's gpio handling
      arm: omap boards: Remove unnecessary platform_enable/disable callbacks for VENC devices
      arm: dss-common: don't use reset_gpio from omap4_panda_dvi_device

Arnd Bergmann (16):
      spi: pl022: use generic DMA slave configuration if possible
      serial: pl011: use generic DMA slave configuration if possible
      Merge branch 'spear/multiplatform' into spear/dma
      ARM: SPEAr13xx: Pass generic DW DMAC platform data from DT
      ARM: make machine_desc->init_time default to clocksource_of_init
      ARM: at91: suspend both memory controllers on at91sam9263
      ata: arasan: remove the need for platform_data
      Merge branch 'spear/multiplatform' into late/cleanup
      Merge branch 'spear/dwdma' into late/cleanup
      serial: amba-pl011: fix !CONFIG_DMA_ENGINE case
      ARM: OMAP: remove unused variable
      Merge tag 'at91-soc' of git://github.com/at91linux/linux-at91 into late/cleanup
      ARM: SPEAr: conditionalize SMP code
      Merge branch 'late/clksrc' into late/cleanup
      Merge tag 'omap-for-v3.10/fixes-for-merge-window' of git://git.kernel.org/.../tmlind/linux-omap into late/cleanup
      Merge tag 'cleanup-for-linus-2' into for-next

Haojian Zhuang (1):
      devtree: add binding documentation for sp804

Kishon Vijay Abraham I (1):
      ARM: OMAP4: change the device names in usb_bind_phy

Ludovic Desroches (3):
      ARM: at91: dts: set #dma-cells to the correct value
      ARM: at91: dts: add i2c dma support
      ARM: at91: dts: add MCI DMA support

Nicolas Ferre (2):
      ARM: at91: change "Unknown" qualifier SoC subtype handling
      ARM: at91/sama5d34ek.dts: remove not needed compatibility string

Olof Johansson (7):
      Merge tag 'clksrc-cleanup-for-3.10-part2' of git://sources.calxeda.com/kernel/linux into late/clksrc
      Merge tag 'irqchip-3.10' of git://git.infradead.org/users/jcooper/linux into late/cleanup
      Merge branch 'omap/fixes-non-critical' into late/cleanup
      Merge branch 'omap/boards' into late/cleanup
      Merge tag 'omap-for-v3.10/dss-signed' of git://git.kernel.org/.../tmlind/linux-omap into late/cleanup
      Merge branch 'at91/soc' into late/cleanup
      Merge tag 'at91-soc' of git://github.com/at91linux/linux-at91 into late/cleanup

Peter Ujfalusi (1):
      ARM: OMAP: zoom: Use pwm stack for lcd and keyboard backlight

Rob Herring (13):
      ARM: sched_clock: allow changing to higher frequency counter
      ARM: make sched_clock just call a function pointer
      ARM: arch_timer: use full 64-bit counter for sched_clock
      ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
      OF: add empty of_device_is_available for !OF
      ARM: timer-sp: convert to use CLKSRC_OF init
      ARM: highbank: use OF init for sp804 timer
      ARM: vexpress: remove sp804 OF init
      ARM: dts: vexpress: disable CA9 core tile sp804 timer
      ARM: vexpress: remove extra timer-sp control register clearing
      ARM: versatile: add versatile dtbs to dtbs target
      ARM: versatile: use OF init for sp804 timer
      ARM: integrator-cp: convert use CLKSRC_OF for timer init

Stephen Boyd (1):
      ARM: arch_timer: Silence debug preempt warnings

Thomas Petazzoni (4):
      ARM: mvebu: move L2 cache initialization in init_early()
      irqchip: move IRQ driver for Armada 370/XP
      irqchip: armada-370-xp: move IRQ handler to avoid forward declaration
      irqchip: armada-370-xp: slightly cleanup irq controller driver

Tomi Valkeinen (1):
      arm: omap: board-cm-t35: use generic dpi panel's gpio handling

Tony Lindgren (1):
      Merge branch '3.10-lo/board-cleanup' of git://gitorious.org/linux-omap-dss2/linux into omap-for-v3.10/dss

Vaibhav Hiremath (1):
      ARM: OMAP2+: Fix mismerge for timer.c between ff931c82 and da4a686a

 .../devicetree/bindings/arm/primecell.txt          |  19 ++-
 .../devicetree/bindings/ata/pata-arasan.txt        |  22 ++++
 Documentation/devicetree/bindings/serial/pl011.txt |  17 +++
 .../devicetree/bindings/spi/spi_pl022.txt          |  36 ++++++
 .../devicetree/bindings/timer/arm,sp804.txt        |  29 +++++
 arch/arm/Kconfig                                   |   1 +
 arch/arm/boot/dts/Makefile                         |   2 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   5 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |   9 ++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  15 +++
 arch/arm/boot/dts/integratorcp.dts                 |   6 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |  19 ++-
 arch/arm/boot/dts/sama5d34ek.dts                   |   2 +-
 arch/arm/boot/dts/spear1340.dtsi                   |   3 +
 arch/arm/boot/dts/spear13xx.dtsi                   |  25 +++-
 arch/arm/boot/dts/versatile-ab.dts                 |  12 ++
 arch/arm/boot/dts/vexpress-v2p-ca9.dts             |   1 +
 arch/arm/common/timer-sp.c                         | 140 ++++++++++++++++++---
 arch/arm/include/asm/arch_timer.h                  |  13 +-
 arch/arm/include/asm/hardware/timer-sp.h           |  16 ++-
 arch/arm/include/asm/sched_clock.h                 |   2 +
 arch/arm/kernel/arch_timer.c                       |  29 ++---
 arch/arm/kernel/sched_clock.c                      |  15 ++-
 arch/arm/kernel/time.c                             |   7 +-
 arch/arm/mach-at91/cpuidle.c                       |   2 +
 arch/arm/mach-at91/include/mach/cpu.h              |   9 +-
 arch/arm/mach-at91/pm.c                            |   2 +
 arch/arm/mach-at91/pm.h                            |  30 ++++-
 arch/arm/mach-at91/setup.c                         |  22 ++--
 arch/arm/mach-highbank/highbank.c                  |  24 +---
 arch/arm/mach-integrator/integrator_cp.c           |  34 -----
 arch/arm/mach-mvebu/Makefile                       |   2 +-
 arch/arm/mach-mvebu/armada-370-xp.c                |   9 +-
 arch/arm/mach-omap2/board-2430sdp.c                |  43 +------
 arch/arm/mach-omap2/board-3430sdp.c                |  53 +++-----
 arch/arm/mach-omap2/board-4430sdp.c                |   2 +-
 arch/arm/mach-omap2/board-am3517evm.c              |  74 +----------
 arch/arm/mach-omap2/board-cm-t35.c                 |  60 ++-------
 arch/arm/mach-omap2/board-devkit8000.c             |  27 +---
 arch/arm/mach-omap2/board-ldp.c                    |  61 ++-------
 arch/arm/mach-omap2/board-omap3evm.c               |  70 +++--------
 arch/arm/mach-omap2/board-omap3pandora.c           |   7 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |  11 --
 arch/arm/mach-omap2/board-omap4panda.c             |   2 +-
 arch/arm/mach-omap2/board-overo.c                  |  58 +++------
 arch/arm/mach-omap2/board-rx51-video.c             |  26 ++--
 arch/arm/mach-omap2/board-zoom-display.c           |  38 ++----
 arch/arm/mach-omap2/dss-common.c                   |  54 +++-----
 arch/arm/mach-omap2/timer.c                        |   7 +-
 arch/arm/mach-shmobile/board-kzm9d.c               |   1 -
 arch/arm/mach-shmobile/setup-emev2.c               |   1 -
 arch/arm/mach-shmobile/setup-r8a7740.c             |   1 -
 arch/arm/mach-shmobile/setup-sh7372.c              |   1 -
 arch/arm/mach-shmobile/setup-sh73a0.c              |   1 -
 arch/arm/mach-shmobile/timer.c                     |   7 +-
 arch/arm/mach-spear/Makefile                       |   6 +-
 arch/arm/mach-spear/generic.h                      |   5 -
 arch/arm/mach-spear/include/mach/spear.h           |   2 -
 arch/arm/mach-spear/spear1310.c                    |  30 +----
 arch/arm/mach-spear/spear1340.c                    |  32 +----
 arch/arm/mach-spear/spear13xx-dma.h                | 128 -------------------
 arch/arm/mach-spear/spear13xx.c                    |  60 +--------
 arch/arm/mach-versatile/core.c                     |  26 ++--
 arch/arm/mach-versatile/versatile_dt.c             |   1 -
 arch/arm/mach-vexpress/v2m.c                       |  25 +---
 arch/arm/mach-virt/virt.c                          |   9 --
 arch/arm64/include/asm/arch_timer.h                |   5 +
 arch/arm64/kernel/time.c                           |   6 +-
 drivers/ata/pata_arasan_cf.c                       |  37 +++---
 drivers/clocksource/Kconfig                        |   1 +
 drivers/clocksource/arm_arch_timer.c               |  33 +++--
 drivers/clocksource/exynos_mct.c                   |   1 -
 drivers/irqchip/Makefile                           |   1 +
 .../irqchip}/irq-armada-370-xp.c                   | 106 ++++++++--------
 drivers/spi/spi-pl022.c                            |  43 ++++++-
 drivers/tty/serial/amba-pl011.c                    |  64 ++++++----
 include/clocksource/arm_arch_timer.h               |   6 -
 include/linux/of.h                                 |   5 +
 include/linux/pata_arasan_cf_data.h                |   2 -
 79 files changed, 777 insertions(+), 1041 deletions(-)
