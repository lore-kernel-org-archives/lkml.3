Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab3GOO5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:57:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:33376 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3GOO5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:57:32 -0400
Date: Mon, 15 Jul 2013 10:57:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Phase 2 of __cpuinit removal
Message-ID: <20130715145735.GA23381@windriver.com>
References: <20130702174402.GA21817@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130702174402.GA21817@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following to get phase two of the __cpuinit removal.

With the __cpuinit infrastructure removed earlier, this group of commits
only removes the function/data tagging that was done with the various
(now no-op) __cpuinit related prefixes.

Now that the dust has settled with yesterday's v3.11-rc1, there hopefully
shouldn't be any new users leaking back in tree, but I think we can leave
the harmless no-op stubs there for a release as a courtesy to those who
still have out of tree stuff and weren't paying attention.

Although the commits are against the recent tag to allow for minor context
refreshes for things like yesterday's v3.11-rc1~ slab content, the patches
have been largely unchanged for weeks, aside from such trivial updates. 

For detail junkies, the largely boring and mostly irrelevant history of
the patches can be viewed at:

 http://git.kernel.org/cgit/linux/kernel/git/paulg/cpuinit-delete.git

If nothing else, I guess it does at least demonstrate the level of
involvement required to shepherd such a treewide change to completion.

This is the same repository of patches that has been applied to the
end of the daily linux-next branches for the past several weeks.

The branch below represents a direct "git am" of the above patch repo
(that is similarly tagged with v3.11-rc1) to mainline's v3.11-rc1.

Thanks,
Paul.

---
The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git cpuinit_phase2

for you to fetch changes up to 0b776b062843b63cb4c9acdfc092b2581be3c2f6:

  block: delete __cpuinit usage from all block files (2013-07-14 19:36:59 -0400)

----------------------------------------------------------------
Paul Gortmaker (28):
      alpha: delete __cpuinit usage from all users
      parisc: delete __cpuinit usage from all users
      MIPS: Delete __cpuinit/__CPUINIT usage from MIPS code
      arm: delete __cpuinit/__CPUINIT usage from all ARM users
      sparc: delete __cpuinit/__CPUINIT usage from all users
      arm64: delete __cpuinit usage from all users
      blackfin: delete __cpuinit usage from all blackfin files
      s390: delete __cpuinit usage from all s390 files
      sh: delete __cpuinit usage from all sh files
      tile: delete __cpuinit usage from all tile files
      metag: delete __cpuinit usage from all metag files
      cris: delete __cpuinit usage from all cris files
      frv: delete __cpuinit usage from all frv files
      hexagon: delete __cpuinit usage from all hexagon files
      m32r: delete __cpuinit usage from all m32r files
      openrisc: delete __cpuinit usage from all openrisc files
      xtensa: delete __cpuinit usage from all xtensa files
      score: delete __cpuinit usage from all score files
      x86: delete __cpuinit usage from all x86 files
      clocksource+irqchip: delete __cpuinit usage from all related files
      cpufreq: delete __cpuinit usage from all cpufreq files
      hwmon: delete __cpuinit usage from all hwmon files
      acpi: delete __cpuinit usage from all acpi files
      net: delete __cpuinit usage from all net files
      rcu: delete __cpuinit usage from all rcu files
      kernel: delete __cpuinit usage from all core kernel files
      drivers: delete __cpuinit usage from all remaining drivers files
      block: delete __cpuinit usage from all block files

 Documentation/cpu-hotplug.txt                 |   6 +-
 arch/alpha/kernel/smp.c                       |  10 +-
 arch/alpha/kernel/traps.c                     |   4 +-
 arch/arm/common/mcpm_platsmp.c                |   4 +-
 arch/arm/include/asm/arch_timer.h             |   2 +-
 arch/arm/kernel/head-common.S                 |   1 -
 arch/arm/kernel/head-nommu.S                  |   1 -
 arch/arm/kernel/head.S                        |   1 -
 arch/arm/kernel/hw_breakpoint.c               |   4 +-
 arch/arm/kernel/perf_event_cpu.c              |   6 +-
 arch/arm/kernel/psci_smp.c                    |   3 +-
 arch/arm/kernel/smp.c                         |  18 ++--
 arch/arm/kernel/smp_twd.c                     |   6 +-
 arch/arm/lib/delay.c                          |   2 +-
 arch/arm/mach-exynos/headsmp.S                |   2 -
 arch/arm/mach-exynos/platsmp.c                |   4 +-
 arch/arm/mach-highbank/platsmp.c              |   2 +-
 arch/arm/mach-imx/platsmp.c                   |   2 +-
 arch/arm/mach-keystone/platsmp.c              |   2 +-
 arch/arm/mach-msm/headsmp.S                   |   2 -
 arch/arm/mach-msm/platsmp.c                   |   6 +-
 arch/arm/mach-msm/timer.c                     |   4 +-
 arch/arm/mach-mvebu/coherency.c               |   2 +-
 arch/arm/mach-mvebu/headsmp.S                 |   2 -
 arch/arm/mach-mvebu/platsmp.c                 |   5 +-
 arch/arm/mach-omap2/omap-headsmp.S            |   2 -
 arch/arm/mach-omap2/omap-mpuss-lowpower.c     |   2 +-
 arch/arm/mach-omap2/omap-smp.c                |   4 +-
 arch/arm/mach-omap2/omap-wakeupgen.c          |   4 +-
 arch/arm/mach-prima2/headsmp.S                |   2 -
 arch/arm/mach-prima2/platsmp.c                |   4 +-
 arch/arm/mach-shmobile/headsmp-scu.S          |   1 -
 arch/arm/mach-shmobile/headsmp.S              |   2 -
 arch/arm/mach-shmobile/smp-emev2.c            |   2 +-
 arch/arm/mach-shmobile/smp-r8a7779.c          |   2 +-
 arch/arm/mach-shmobile/smp-sh73a0.c           |   2 +-
 arch/arm/mach-socfpga/headsmp.S               |   1 -
 arch/arm/mach-socfpga/platsmp.c               |   2 +-
 arch/arm/mach-spear/generic.h                 |   2 +-
 arch/arm/mach-spear/platsmp.c                 |   4 +-
 arch/arm/mach-sti/platsmp.c                   |   6 +-
 arch/arm/mach-tegra/platsmp.c                 |   4 +-
 arch/arm/mach-tegra/pm.c                      |   2 +-
 arch/arm/mach-ux500/platsmp.c                 |   4 +-
 arch/arm/mach-zynq/common.h                   |   2 +-
 arch/arm/mach-zynq/headsmp.S                  |   2 -
 arch/arm/mach-zynq/platsmp.c                  |   6 +-
 arch/arm/mm/proc-arm1020.S                    |   2 -
 arch/arm/mm/proc-arm1020e.S                   |   2 -
 arch/arm/mm/proc-arm1022.S                    |   2 -
 arch/arm/mm/proc-arm1026.S                    |   3 -
 arch/arm/mm/proc-arm720.S                     |   2 -
 arch/arm/mm/proc-arm740.S                     |   2 -
 arch/arm/mm/proc-arm7tdmi.S                   |   2 -
 arch/arm/mm/proc-arm920.S                     |   2 -
 arch/arm/mm/proc-arm922.S                     |   2 -
 arch/arm/mm/proc-arm925.S                     |   2 -
 arch/arm/mm/proc-arm926.S                     |   2 -
 arch/arm/mm/proc-arm940.S                     |   2 -
 arch/arm/mm/proc-arm946.S                     |   2 -
 arch/arm/mm/proc-arm9tdmi.S                   |   2 -
 arch/arm/mm/proc-fa526.S                      |   2 -
 arch/arm/mm/proc-feroceon.S                   |   2 -
 arch/arm/mm/proc-mohawk.S                     |   2 -
 arch/arm/mm/proc-sa110.S                      |   2 -
 arch/arm/mm/proc-sa1100.S                     |   2 -
 arch/arm/mm/proc-v6.S                         |   2 -
 arch/arm/mm/proc-v7-2level.S                  |   4 -
 arch/arm/mm/proc-v7-3level.S                  |   4 -
 arch/arm/mm/proc-v7.S                         |   2 -
 arch/arm/mm/proc-xsc3.S                       |   2 -
 arch/arm/mm/proc-xscale.S                     |   2 -
 arch/arm/plat-versatile/platsmp.c             |   6 +-
 arch/arm64/include/asm/arch_timer.h           |   2 +-
 arch/arm64/kernel/debug-monitors.c            |   6 +-
 arch/arm64/kernel/hw_breakpoint.c             |   4 +-
 arch/arm64/kernel/smp.c                       |   8 +-
 arch/blackfin/kernel/perf_event.c             |   2 +-
 arch/blackfin/kernel/setup.c                  |   4 +-
 arch/blackfin/mach-bf561/smp.c                |   6 +-
 arch/blackfin/mach-common/cache-c.c           |   4 +-
 arch/blackfin/mach-common/ints-priority.c     |   2 +-
 arch/blackfin/mach-common/smp.c               |  12 +--
 arch/cris/arch-v32/kernel/smp.c               |   2 +-
 arch/frv/kernel/setup.c                       |   2 +-
 arch/hexagon/kernel/setup.c                   |   2 +-
 arch/hexagon/kernel/smp.c                     |   4 +-
 arch/m32r/kernel/smpboot.c                    |   2 +-
 arch/metag/kernel/perf/perf_event.c           |   6 +-
 arch/metag/kernel/smp.c                       |  22 ++--
 arch/metag/kernel/traps.c                     |   2 +-
 arch/mips/ath79/setup.c                       |   2 +-
 arch/mips/cavium-octeon/octeon-irq.c          |  12 +--
 arch/mips/cavium-octeon/smp.c                 |   6 +-
 arch/mips/include/asm/uasm.h                  |  37 +++----
 arch/mips/kernel/bmips_vec.S                  |   4 -
 arch/mips/kernel/cevt-bcm1480.c               |   2 +-
 arch/mips/kernel/cevt-gic.c                   |   2 +-
 arch/mips/kernel/cevt-r4k.c                   |   2 +-
 arch/mips/kernel/cevt-sb1250.c                |   2 +-
 arch/mips/kernel/cevt-smtc.c                  |   2 +-
 arch/mips/kernel/cpu-bugs64.c                 |   2 +-
 arch/mips/kernel/cpu-probe.c                  |  14 +--
 arch/mips/kernel/head.S                       |   4 -
 arch/mips/kernel/smp-bmips.c                  |   6 +-
 arch/mips/kernel/smp-mt.c                     |   6 +-
 arch/mips/kernel/smp-up.c                     |   6 +-
 arch/mips/kernel/smp.c                        |   6 +-
 arch/mips/kernel/smtc.c                       |   2 +-
 arch/mips/kernel/spram.c                      |  14 +--
 arch/mips/kernel/sync-r4k.c                   |  12 +--
 arch/mips/kernel/traps.c                      |  12 +--
 arch/mips/kernel/watch.c                      |   2 +-
 arch/mips/lantiq/irq.c                        |   2 +-
 arch/mips/lib/uncached.c                      |   2 +-
 arch/mips/mm/c-octeon.c                       |   6 +-
 arch/mips/mm/c-r3k.c                          |   8 +-
 arch/mips/mm/c-r4k.c                          |  34 +++---
 arch/mips/mm/c-tx39.c                         |   2 +-
 arch/mips/mm/cache.c                          |   2 +-
 arch/mips/mm/cex-sb1.S                        |   4 -
 arch/mips/mm/page.c                           |  40 +++----
 arch/mips/mm/sc-ip22.c                        |   2 +-
 arch/mips/mm/sc-mips.c                        |   2 +-
 arch/mips/mm/sc-r5k.c                         |   2 +-
 arch/mips/mm/sc-rm7k.c                        |  12 +--
 arch/mips/mm/tlb-r3k.c                        |   2 +-
 arch/mips/mm/tlb-r4k.c                        |   4 +-
 arch/mips/mm/tlb-r8k.c                        |   4 +-
 arch/mips/mm/tlbex.c                          | 144 ++++++++++++--------------
 arch/mips/mm/uasm-micromips.c                 |  10 +-
 arch/mips/mm/uasm-mips.c                      |  10 +-
 arch/mips/mm/uasm.c                           | 106 +++++++++----------
 arch/mips/mti-malta/malta-smtc.c              |   6 +-
 arch/mips/mti-malta/malta-time.c              |   2 +-
 arch/mips/mti-sead3/sead3-time.c              |   2 +-
 arch/mips/netlogic/common/smp.c               |   4 +-
 arch/mips/netlogic/common/smpboot.S           |   4 -
 arch/mips/netlogic/common/time.c              |   2 +-
 arch/mips/netlogic/xlr/wakeup.c               |   2 +-
 arch/mips/pci/pci-ip27.c                      |   2 +-
 arch/mips/pmcs-msp71xx/msp_smtc.c             |   7 +-
 arch/mips/pmcs-msp71xx/msp_time.c             |   2 +-
 arch/mips/pnx833x/common/interrupts.c         |   2 +-
 arch/mips/powertv/time.c                      |   2 +-
 arch/mips/ralink/irq.c                        |   2 +-
 arch/mips/sgi-ip27/ip27-init.c                |   4 +-
 arch/mips/sgi-ip27/ip27-smp.c                 |   6 +-
 arch/mips/sgi-ip27/ip27-timer.c               |   6 +-
 arch/mips/sgi-ip27/ip27-xtalk.c               |   6 +-
 arch/mips/sibyte/bcm1480/smp.c                |   8 +-
 arch/mips/sibyte/sb1250/smp.c                 |   8 +-
 arch/openrisc/kernel/setup.c                  |   2 +-
 arch/parisc/kernel/firmware.c                 |  14 +--
 arch/parisc/kernel/hardware.c                 |   2 +-
 arch/parisc/kernel/processor.c                |   6 +-
 arch/parisc/kernel/smp.c                      |   8 +-
 arch/s390/kernel/cache.c                      |  15 ++-
 arch/s390/kernel/perf_cpum_cf.c               |   4 +-
 arch/s390/kernel/processor.c                  |   2 +-
 arch/s390/kernel/smp.c                        |  17 ++-
 arch/s390/kernel/sysinfo.c                    |   2 +-
 arch/s390/kernel/vtime.c                      |   6 +-
 arch/s390/mm/fault.c                          |   4 +-
 arch/score/mm/tlb-score.c                     |   2 +-
 arch/sh/kernel/cpu/init.c                     |  18 ++--
 arch/sh/kernel/cpu/sh2/probe.c                |   2 +-
 arch/sh/kernel/cpu/sh2a/probe.c               |   2 +-
 arch/sh/kernel/cpu/sh3/probe.c                |   2 +-
 arch/sh/kernel/cpu/sh4/probe.c                |   2 +-
 arch/sh/kernel/cpu/sh4a/smp-shx3.c            |   6 +-
 arch/sh/kernel/cpu/sh5/probe.c                |   2 +-
 arch/sh/kernel/perf_event.c                   |   4 +-
 arch/sh/kernel/process.c                      |   2 +-
 arch/sh/kernel/setup.c                        |   2 +-
 arch/sh/kernel/smp.c                          |   8 +-
 arch/sh/kernel/traps_32.c                     |   2 +-
 arch/sh/kernel/traps_64.c                     |   2 +-
 arch/sh/mm/tlb-sh5.c                          |   2 +-
 arch/sparc/kernel/ds.c                        |  11 +-
 arch/sparc/kernel/entry.h                     |   2 +-
 arch/sparc/kernel/hvtramp.S                   |   1 -
 arch/sparc/kernel/irq_64.c                    |   5 +-
 arch/sparc/kernel/leon_smp.c                  |  10 +-
 arch/sparc/kernel/mdesc.c                     |  34 +++---
 arch/sparc/kernel/smp_32.c                    |  20 ++--
 arch/sparc/kernel/smp_64.c                    |   9 +-
 arch/sparc/kernel/sun4d_smp.c                 |   6 +-
 arch/sparc/kernel/sun4m_smp.c                 |   6 +-
 arch/sparc/kernel/sysfs.c                     |   4 +-
 arch/sparc/kernel/trampoline_32.S             |   3 -
 arch/sparc/kernel/trampoline_64.S             |   2 -
 arch/sparc/mm/init_64.c                       |   2 +-
 arch/sparc/mm/srmmu.c                         |  12 +--
 arch/tile/kernel/irq.c                        |   2 +-
 arch/tile/kernel/messaging.c                  |   2 +-
 arch/tile/kernel/setup.c                      |  12 +--
 arch/tile/kernel/smpboot.c                    |   8 +-
 arch/tile/kernel/time.c                       |   2 +-
 arch/x86/include/asm/cpu.h                    |   2 +-
 arch/x86/include/asm/microcode.h              |   4 +-
 arch/x86/include/asm/microcode_amd.h          |   4 +-
 arch/x86/include/asm/microcode_intel.h        |   4 +-
 arch/x86/include/asm/mmconfig.h               |   4 +-
 arch/x86/include/asm/mpspec.h                 |   2 +-
 arch/x86/include/asm/numa.h                   |   6 +-
 arch/x86/include/asm/processor.h              |   2 +-
 arch/x86/include/asm/prom.h                   |   2 +-
 arch/x86/include/asm/smp.h                    |   2 +-
 arch/x86/kernel/acpi/boot.c                   |   6 +-
 arch/x86/kernel/apic/apic.c                   |  30 +++---
 arch/x86/kernel/apic/apic_numachip.c          |   2 +-
 arch/x86/kernel/apic/es7000_32.c              |   2 +-
 arch/x86/kernel/apic/numaq_32.c               |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c         |   2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c            |  14 +--
 arch/x86/kernel/cpu/amd.c                     |  33 +++---
 arch/x86/kernel/cpu/centaur.c                 |  26 ++---
 arch/x86/kernel/cpu/common.c                  |  64 ++++++------
 arch/x86/kernel/cpu/cyrix.c                   |  40 +++----
 arch/x86/kernel/cpu/hypervisor.c              |   2 +-
 arch/x86/kernel/cpu/intel.c                   |  30 +++---
 arch/x86/kernel/cpu/intel_cacheinfo.c         |  55 +++++-----
 arch/x86/kernel/cpu/mcheck/mce.c              |  23 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd.c          |  14 ++-
 arch/x86/kernel/cpu/mcheck/therm_throt.c      |   9 +-
 arch/x86/kernel/cpu/perf_event.c              |   2 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c      |   2 +-
 arch/x86/kernel/cpu/perf_event_amd_uncore.c   |  31 +++---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  20 ++--
 arch/x86/kernel/cpu/rdrand.c                  |   2 +-
 arch/x86/kernel/cpu/scattered.c               |   4 +-
 arch/x86/kernel/cpu/topology.c                |   2 +-
 arch/x86/kernel/cpu/transmeta.c               |   6 +-
 arch/x86/kernel/cpu/umc.c                     |   2 +-
 arch/x86/kernel/cpu/vmware.c                  |   2 +-
 arch/x86/kernel/cpuid.c                       |   7 +-
 arch/x86/kernel/devicetree.c                  |   2 +-
 arch/x86/kernel/head_32.S                     |   1 -
 arch/x86/kernel/i387.c                        |  10 +-
 arch/x86/kernel/irq_32.c                      |   2 +-
 arch/x86/kernel/kvm.c                         |  10 +-
 arch/x86/kernel/kvmclock.c                    |   2 +-
 arch/x86/kernel/microcode_amd_early.c         |   8 +-
 arch/x86/kernel/microcode_core.c              |   2 +-
 arch/x86/kernel/microcode_core_early.c        |   6 +-
 arch/x86/kernel/microcode_intel_early.c       |  26 ++---
 arch/x86/kernel/mmconf-fam10h_64.c            |  12 +--
 arch/x86/kernel/msr.c                         |   6 +-
 arch/x86/kernel/process.c                     |   2 +-
 arch/x86/kernel/setup.c                       |   2 +-
 arch/x86/kernel/smpboot.c                     |  28 ++---
 arch/x86/kernel/tboot.c                       |   6 +-
 arch/x86/kernel/tsc.c                         |   4 +-
 arch/x86/kernel/tsc_sync.c                    |  18 ++--
 arch/x86/kernel/vsyscall_64.c                 |   6 +-
 arch/x86/kernel/x86_init.c                    |   4 +-
 arch/x86/kernel/xsave.c                       |   4 +-
 arch/x86/mm/mmio-mod.c                        |   4 +-
 arch/x86/mm/numa.c                            |  12 +--
 arch/x86/mm/numa_emulation.c                  |  12 +--
 arch/x86/mm/setup_nx.c                        |   4 +-
 arch/x86/pci/amd_bus.c                        |   8 +-
 arch/x86/platform/ce4100/ce4100.c             |   2 +-
 arch/x86/platform/mrst/mrst.c                 |   4 +-
 arch/x86/xen/enlighten.c                      |   6 +-
 arch/x86/xen/setup.c                          |   6 +-
 arch/x86/xen/smp.c                            |  12 +--
 arch/x86/xen/spinlock.c                       |   2 +-
 arch/x86/xen/xen-ops.h                        |   2 +-
 arch/xtensa/kernel/time.c                     |   2 +-
 block/blk-iopoll.c                            |   6 +-
 block/blk-softirq.c                           |   6 +-
 drivers/acpi/acpi_processor.c                 |   2 +-
 drivers/acpi/processor_core.c                 |   8 +-
 drivers/acpi/processor_driver.c               |   8 +-
 drivers/acpi/processor_idle.c                 |   6 +-
 drivers/base/cpu.c                            |   2 +-
 drivers/base/topology.c                       |  10 +-
 drivers/clocksource/arm_arch_timer.c          |   8 +-
 drivers/clocksource/arm_global_timer.c        |   8 +-
 drivers/clocksource/dummy_timer.c             |   6 +-
 drivers/clocksource/exynos_mct.c              |   4 +-
 drivers/clocksource/metag_generic.c           |   6 +-
 drivers/clocksource/time-armada-370-xp.c      |   4 +-
 drivers/clocksource/timer-marco.c             |   4 +-
 drivers/cpufreq/cpufreq.c                     |   2 +-
 drivers/cpufreq/cpufreq_stats.c               |   2 +-
 drivers/cpufreq/dbx500-cpufreq.c              |   2 +-
 drivers/cpufreq/intel_pstate.c                |   4 +-
 drivers/cpufreq/longhaul.c                    |   6 +-
 drivers/cpufreq/longhaul.h                    |  26 ++---
 drivers/cpufreq/longrun.c                     |   6 +-
 drivers/cpufreq/omap-cpufreq.c                |   2 +-
 drivers/cpufreq/powernow-k7.c                 |   8 +-
 drivers/cpufreq/powernow-k8.c                 |   6 +-
 drivers/hwmon/coretemp.c                      |  39 ++++---
 drivers/hwmon/via-cputemp.c                   |   8 +-
 drivers/irqchip/irq-gic.c                     |   8 +-
 drivers/oprofile/timer_int.c                  |   4 +-
 drivers/xen/xen-acpi-cpuhotplug.c             |   2 +-
 include/linux/cpu.h                           |   2 +-
 include/linux/perf_event.h                    |   2 +-
 init/calibrate.c                              |  13 ++-
 kernel/cpu.c                                  |   6 +-
 kernel/events/core.c                          |   4 +-
 kernel/fork.c                                 |   2 +-
 kernel/hrtimer.c                              |   6 +-
 kernel/printk.c                               |   2 +-
 kernel/profile.c                              |   2 +-
 kernel/rcutorture.c                           |   6 +-
 kernel/rcutree.c                              |   6 +-
 kernel/rcutree.h                              |   4 +-
 kernel/rcutree_plugin.h                       |   6 +-
 kernel/relay.c                                |   2 +-
 kernel/sched/core.c                           |  12 +--
 kernel/sched/fair.c                           |   2 +-
 kernel/smp.c                                  |   2 +-
 kernel/smpboot.c                              |   2 +-
 kernel/softirq.c                              |   8 +-
 kernel/time/tick-sched.c                      |   2 +-
 kernel/timer.c                                |  10 +-
 kernel/workqueue.c                            |   4 +-
 lib/Kconfig.debug                             |   2 +-
 lib/earlycpio.c                               |   2 +-
 lib/percpu_counter.c                          |   2 +-
 mm/memcontrol.c                               |   2 +-
 mm/page-writeback.c                           |   4 +-
 mm/slab.c                                     |  10 +-
 mm/slub.c                                     |   4 +-
 mm/vmstat.c                                   |   6 +-
 net/core/flow.c                               |   4 +-
 net/iucv/iucv.c                               |   2 +-
 333 files changed, 1079 insertions(+), 1221 deletions(-)
