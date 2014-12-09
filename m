Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaLIVhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:37:13 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51503 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaLIVhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:37:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 5/9] ARM: SoC driver updates for 3.19
Date: Tue, 09 Dec 2014 22:36:27 +0100
Message-ID: <3846874.YrNpAixfKY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4491193.a6KEQb1tZH@wuerfel>
References: <4491193.a6KEQb1tZH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:qP9sbo7oJ3U7GyJqD2q3RHYMyeoYjWWurE3mE/5ClW4ABIQVM7G
 KNEV/S45OC/R7N5MbWy6GnGuNagwpm57ZDoTxkE6pOYcNH5SU9NSOABCcvIv92pHoL1n2dI
 jPAnUdrZISmEBaHx+JMa38cbt4IN1yACrULfH9Wqct7Dds0seQm++lzcbtZWzf2jicDNic/
 gGPMcBH5kRC626tLfwAKA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ba62a8593d15f3f353acdc8ab32c18dd40a275bb:

  ARM: at91: remove unused board.h file (2014-12-03 14:16:07 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers-for-linus

for you to fetch changes up to 5db45002576f7d60c5bf7b23e277845cd3e806be:

  Merge branch 'at91/cleanup5' into next/drivers (2014-12-08 18:29:20 +0100)

----------------------------------------------------------------
ARM: SoC driver updates for 3.19

These are changes for drivers that are intimately tied to some SoC
and for some reason could not get merged through the respective
subsystem maintainer tree.

The largest single change here this time around is the Tegra
iommu/memory controller driver, which gets updated to the new
iommu DT binding. More drivers like this are likely to follow
for the following merge window, but we should be able to do
those through the iommu maintainer.

Other notable changes are:
* reset controller drivers from the reset maintainer (socfpga, sti, berlin)
* fixes for the keystone navigator driver merged last time
* at91 rtc driver changes related to the at91 cleanups
* ARM perf driver changes from Will Deacon
* updates for the brcmstb_gisb driver

----------------------------------------------------------------
Antoine Ténart (1):
      reset: add the Berlin reset controller driver

Arnd Bergmann (13):
      Merge tag 'omap-for-v3.19/w1-and-l3-noc' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'keystone-driver-soc' of git://git.kernel.org/.../ssantosh/linux-keystone into next/drivers
      Merge tag 'at91-drivers' of git://git.kernel.org/.../nferre/linux-at91 into next/drivers
      Merge tag 'arm-perf-3.19' of git://git.kernel.org/.../will/linux into next/drivers
      Merge branch 'at91/cleanup' into next/drivers
      Merge tag 'davinci-for-v3.19/edma' of git://git.kernel.org/.../nsekhar/linux-davinci into next/drivers
      ARM: common: edma: edma_pm_resume may be unused
      Merge tag 'samsung-driver' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge tag 'arm-soc/for-3.19/brcmstb-drivers' of https://github.com/brcm/linux into next/drivers
      Merge tag 'reset-for-3.19-2' of git://git.pengutronix.de/git/pza/linux into next/drivers
      Merge tag 'tegra-for-3.19-iommu' of git://git.kernel.org/.../tegra/linux into next/drivers
      Merge branch 'brcm/stb-smp-uart' into next/drivers
      Merge branch 'at91/cleanup5' into next/drivers

Axel Lin (4):
      soc: ti: Use list_first_entry_or_null() at appropriate places
      soc: ti: knav_qmss_queue: Fix unbalanced locking ins knav_pool_create()
      soc: ti: knav_qmss_queue: Return proper error if devm_kzalloc fails
      soc: ti: knav_qmss_queue: Use list_for_each_entry_safe to prevent use after free

Boris BREZILLON (9):
      rtc: at91sam9: remove references to mach specific headers
      rtc: at91sam9: use standard readl/writel functions instead of raw versions
      rtc: at91sam9: replace devm_ioremap by devm_ioremap_resource
      rtc: at91sam9: add DT support
      rtc: at91sam9: make use of syscon/regmap to access GPBR registers
      rtc: at91sam9: rework the Kconfig description
      ARM: at91: add clk_lookup entry for RTT devices
      rtc: at91sam9: use clk API instead of relying on AT91_SLOW_CLOCK
      rtc: at91sam9: add DT bindings documentation

Daniel Mack (1):
      ARM: common: edma: add suspend resume hook

Dinh Nguyen (2):
      reset: add reset_control_status helper function
      reset: add socfpga_reset_status

Doug Anderson (1):
      clocksource: arch_timer: Allow the device tree to specify uninitialized timer registers

Florian Fainelli (1):
      bus: brcmstb_gisb: resolve section mismatch

Heiko Stübner (1):
      iommu: Improve error handling when setting bus iommu

Joerg Roedel (2):
      iommu: Do more input validation in iommu_map_sg()
      powerpc/iommu: Rename iommu_[un]map_sg functions

Keerthy (2):
      bus: omap_l3_noc: Add resume hook to restore context
      bus: omap_l3_noc: Correct returning IRQ_HANDLED unconditionally in the irq handler

Kevin Cernekee (4):
      bus: brcmstb_gisb: Make the driver buildable on MIPS
      bus: brcmstb_gisb: Introduce wrapper functions for MMIO accesses
      bus: brcmstb_gisb: Look up register offsets in a table
      bus: brcmstb_gisb: Add register offset tables for older chips

Mark Rutland (10):
      bus: cci: move away from arm_pmu framework
      arm: perf: factor out callchain code
      arm: perf: add missing pr_info newlines
      arm: perf: make PMU probing data-driven
      arm: perf: use IDR types for CPU PMUs
      arm: perf: limit size of accounting data
      arm: perf: kill get_hw_events()
      arm: perf: fold percpu_pmu into pmu_hw_events
      arm: perf: dynamically allocate cpu hardware data
      arm: perf: fold hotplug notifier into arm_pmu

Maxime Coquelin (1):
      reset: stih407: Add reset controllers DT bindings

NeilBrown (1):
      w1: omap-hdq: support device probing with device-tree

Olav Haugan (1):
      iommu: Add iommu_map_sg() function

Olof Johansson (2):
      Merge tag 'berlin-driver-3.19-1' of git://git.infradead.org/users/hesselba/linux-berlin into next/drivers
      Merge branch 'clocksource/physical-timers' into next/drivers

Pankaj Dubey (1):
      serial: samsung: Fix serial config dependencies for exynos7

Peter Griffin (2):
      reset: stih407: Add softreset, powerdown and picophy controllers
      reset: sti: Document sti-picophyreset controllers bindings.

Philipp Zabel (1):
      Merge tag 'sti-reset-for-v3.19-1' of git://git.stlinux.com/devel/kernel/linux-sti into reset/for_v3.19

Sonny Rao (1):
      clocksource: arch_timer: Fix code to use physical timers when requested

Thierry Reding (6):
      Merge branch 'core' of git://git.kernel.org/.../joro/iommu
      clk: tegra: Implement memory-controller clock
      amba: Add Kconfig file
      ARM: tegra: Move AHB Kconfig to drivers/amba
      of: Add NVIDIA Tegra memory controller binding
      memory: Add NVIDIA Tegra memory controller support

Will Deacon (1):
      ARM: perf: use pr_* instead of printk

chai wen (1):
      ARM: perf: remove useless return and check of idx in counter handling

 .../devicetree/bindings/arm/arch_timer.txt         |    8 +
 .../devicetree/bindings/bus/brcm,gisb-arb.txt      |    6 +-
 .../memory-controllers/nvidia,tegra-mc.txt         |   36 +
 .../bindings/reset/st,sti-picophyreset.txt         |   42 +
 .../devicetree/bindings/rtc/atmel,at91sam9-rtc.txt |   23 +
 Documentation/devicetree/bindings/w1/omap-hdq.txt  |   17 +
 arch/arm/Kconfig                                   |    3 -
 arch/arm/common/edma.c                             |   54 +-
 arch/arm/include/asm/arch_timer.h                  |    9 +
 arch/arm/include/asm/perf_event.h                  |    2 +-
 arch/arm/include/asm/pmu.h                         |   36 +-
 arch/arm/kernel/Makefile                           |    2 +-
 arch/arm/kernel/perf_callchain.c                   |  136 ++
 arch/arm/kernel/perf_event.c                       |  162 +-
 arch/arm/kernel/perf_event_cpu.c                   |  181 ++-
 arch/arm/kernel/perf_event_v6.c                    |   12 +-
 arch/arm/kernel/perf_event_v7.c                    |   72 +-
 arch/arm/kernel/perf_event_xscale.c                |   20 +-
 arch/arm/mach-tegra/Kconfig                        |    9 +-
 arch/arm64/Kconfig                                 |    3 -
 arch/arm64/include/asm/arch_timer.h                |    9 +
 arch/powerpc/include/asm/iommu.h                   |   17 +-
 arch/powerpc/kernel/dma-iommu.c                    |    8 +-
 arch/powerpc/kernel/iommu.c                        |   16 +-
 arch/powerpc/platforms/cell/iommu.c                |    9 +-
 drivers/Kconfig                                    |    2 +
 drivers/amba/Kconfig                               |   14 +
 drivers/bus/Kconfig                                |    2 +-
 drivers/bus/arm-cci.c                              |  552 +++++--
 drivers/bus/brcmstb_gisb.c                         |  130 +-
 drivers/bus/omap_l3_noc.c                          |   63 +-
 drivers/clk/tegra/clk-divider.c                    |   13 +
 drivers/clk/tegra/clk-tegra114.c                   |    7 +-
 drivers/clk/tegra/clk-tegra124.c                   |    7 +-
 drivers/clk/tegra/clk-tegra20.c                    |    8 +-
 drivers/clk/tegra/clk-tegra30.c                    |    7 +-
 drivers/clk/tegra/clk.h                            |    2 +
 drivers/clocksource/arm_arch_timer.c               |   13 +-
 drivers/iommu/Kconfig                              |   12 +-
 drivers/iommu/amd_iommu.c                          |    1 +
 drivers/iommu/arm-smmu.c                           |    1 +
 drivers/iommu/exynos-iommu.c                       |    1 +
 drivers/iommu/intel-iommu.c                        |    1 +
 drivers/iommu/iommu.c                              |   50 +-
 drivers/iommu/ipmmu-vmsa.c                         |    1 +
 drivers/iommu/msm_iommu.c                          |    1 +
 drivers/iommu/omap-iommu.c                         |    1 +
 drivers/iommu/shmobile-iommu.c                     |    1 +
 drivers/iommu/tegra-smmu.c                         | 1609 +++++++-------------
 drivers/memory/Kconfig                             |   12 +-
 drivers/memory/Makefile                            |    3 +-
 drivers/memory/tegra/Kconfig                       |    7 +
 drivers/memory/tegra/Makefile                      |    7 +
 drivers/memory/tegra/mc.c                          |  301 ++++
 drivers/memory/tegra/mc.h                          |   40 +
 drivers/memory/tegra/tegra114.c                    |  948 ++++++++++++
 drivers/memory/tegra/tegra124.c                    |  995 ++++++++++++
 drivers/memory/tegra/tegra30.c                     |  970 ++++++++++++
 drivers/memory/tegra30-mc.c                        |  378 -----
 drivers/reset/Makefile                             |    1 +
 drivers/reset/core.c                               |   15 +
 drivers/reset/reset-berlin.c                       |  131 ++
 drivers/reset/reset-socfpga.c                      |   15 +
 drivers/reset/sti/Kconfig                          |    4 +
 drivers/reset/sti/Makefile                         |    1 +
 drivers/reset/sti/reset-stih407.c                  |  158 ++
 drivers/rtc/Kconfig                                |   24 +-
 drivers/rtc/rtc-at91sam9.c                         |  138 +-
 drivers/soc/ti/knav_qmss.h                         |    8 +-
 drivers/soc/ti/knav_qmss_queue.c                   |   13 +-
 drivers/tty/serial/Kconfig                         |    4 +-
 drivers/w1/masters/omap_hdq.c                      |    7 +
 include/dt-bindings/clock/tegra114-car.h           |    2 +-
 include/dt-bindings/clock/tegra124-car.h           |    2 +-
 include/dt-bindings/clock/tegra20-car.h            |    2 +-
 include/dt-bindings/memory/tegra114-mc.h           |   25 +
 include/dt-bindings/memory/tegra124-mc.h           |   31 +
 include/dt-bindings/memory/tegra30-mc.h            |   24 +
 .../dt-bindings/reset-controller/stih407-resets.h  |   61 +
 include/linux/iommu.h                              |   22 +
 include/linux/reset-controller.h                   |    2 +
 include/linux/reset.h                              |    7 +
 include/soc/tegra/mc.h                             |  107 ++
 83 files changed, 5846 insertions(+), 2010 deletions(-)


