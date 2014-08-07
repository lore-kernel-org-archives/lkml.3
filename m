Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbaHGFIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:08:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:50749 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbaHGFIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:08:36 -0400
Message-ID: <1407388101.3073.124.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 07 Aug 2014 15:08:21 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

First an apology ... a lot of the stuff in there was only very recently
committed. This is not the normal process. I'm at fault here, my only
excuse is having been insanely swamped with other things. That's one of
the reasons for co-opting Michael as co-maintainer, to help with
avoiding that sort of trainwreck in the future.

The redeeming thing (if any) is that most of the patches were actually
reviewed on patchwork for a while, went through several iterations, and
in some cases fairly well tested in other places. Additionally the bulk
of the "new" stuff is fairly platform specific with little risk of
negatively impacting integration with other things.

There's the VFIO bit that doesn't fit in that category, but I gave Alex
the heads up already, he will probably send you some additional bits on
top of it before the end of this week.

Now for the content: This is the powerpc new goodies for 3.17. The short
story:

The biggest bit is Michael removing all of pre-POWER4 processor support
from the 64-bit kernel. POWER3 and rs64. This gets rid of a ton of old
cruft that has been bitrotting in a long while. It was broken for quite
a few versions already and nobody noticed. Nobody uses those machines
anymore. While at it, he cleaned up a bunch of old dusty cabinets,
getting rid of a skeletton or two.

Then, we have some base VFIO support for KVM, which allows assigning of
PCI devices to KVM guests, support for large 64-bit BARs on "powernv"
platforms, support for HMI (Hardware Management Interrupts) on those
same platforms, some sparse-vmemmap improvements (for memory hotplug),

There is the usual batch of Freescale embedded updates (summary in the
merge commit) and fixes here or there, I think that's it for the
highlights.

Cheers,
Ben.

The following changes since commit 6f5405bc2ee0102bb3856e2cdea64ff415db2e0c:

  powerpc: use _GLOBAL_TOC for memmove (2014-07-22 15:56:04 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 537e5400a0a05c4efe70e7b372c19cfcd0179362:

  powerpc/eeh: Export eeh_iommu_group_to_pe() (2014-08-07 13:00:02 +1000)

----------------------------------------------------------------
Alexey Kardashevskiy (4):
      powerpc/powernv: Use it_page_shift for TCE invalidation
      powerpc/powernv: Use it_page_shift in TCE build
      powerpc/powernv: Add a page size parameter to pnv_pci_setup_iommu_table()
      powerpc/iommu: Fix comments with it_page_shift

Andrey Utkin (1):
      powerpc/mm/numa: Fix break placement

Andy Fleming (1):
      powerpc/e6500: Add support for hardware threads

Anton Blanchard (3):
      powerpc/pseries: Use jump labels for hcall tracepoints
      powerpc/pseries: Optimise hcall tracepoints
      powernv: Add OPAL tracepoints

Benjamin Herrenschmidt (5):
      Merge branch 'merge' into next
      Merge branch 'merge' into next
      Add Michael Ellerman as powerpc co-maintainer
      Merge remote-tracking branch 'scott/next' into next
      powerpc/eeh: Add missing #ifdef CONFIG_IOMMU_API

Bharat Bhushan (1):
      booke/powerpc: define wimge shift mask to fix compilation error

Brian W Hart (1):
      powerpc/powernv: Update dev->dma_mask in pci_set_dma_mask() path

Chunhe Lan (2):
      t4240/dts: Enable third elo3 DMA engine support
      powerpc/85xx: Add T4240RDB board support

Gavin Shan (17):
      powerpc/eeh: Avoid event on passed PE
      powerpc/eeh: EEH support for VFIO PCI device
      drivers/vfio: EEH support for VFIO PCI device
      powerpc/powernv: Fix IOMMU table for VFIO dev
      powerpc/eeh: Fetch IOMMU table in reliable way
      powerpc/eeh: Refactor EEH flag accessors
      powerpc/eeh: Selectively enable IO for error log
      powerpc/eeh: Reduce lines of log dump
      powerpc/eeh: Replace pr_warning() with pr_warn()
      powerpc/eeh: Make diag-data not endian dependent
      powerpc/eeh: Aux PE data for error log
      powerpc/powernv: Allow to freeze PE
      powerpc/powernv: Split ioda_eeh_get_state()
      powerpc/powernv: Handle compound PE
      powerpc/powernv: Handle compound PE for EEH
      powerpc/powernv: Handle compound PE in config accessors
      powerpc/eeh: Export eeh_iommu_group_to_pe()

Guo Chao (1):
      powerpc/powernv: Enable M64 aperatus for PHB3

Himangi Saraogi (2):
      powerpc/mpic_msgr: Use kcalloc and correct the argument to sizeof
      powerpc/fsl-pci: Correct use of ! and &

Laurentiu TUDOR (1):
      powerpc/85xx: drop hypervisor specific board compatibles

Laurentiu Tudor (1):
      powerpc/booke64: wrap tlb lock and search in htw miss with FTR_SMT

Li Zhong (4):
      powerpc: implement vmemmap_list_free()
      powerpc: implement vmemmap_remove_mapping() for BOOK3S
      powerpc: implement vmemmap_free()
      powerpc: start loop at section start of start in vmemmap_populated()

Lucas Tanure (1):
      powerpc: Fix wrong defintion in boot/io.h

Madhusudanan Kandasamy (1):
      powerpc: Fail remap_4k_pfn() if PFN doesn't fit inside PTE

Mahesh Salgaonkar (4):
      powerpc/book3s: Add basic infrastructure to handle HMI in Linux.
      powerpc/powernv: Invoke opal call to handle hmi.
      powerpc/book3s: handle HMIs for cpus in nap mode.
      powerpc/book3s: Fix endianess issue for HMI handling on napping cpus.

Marcelo Tosatti (1):
      MAINTAINERS: Update PPC 8xx entry

Michael Ellerman (32):
      powerpc/perf: Fix MMCR2 handling for EBB
      powerpc: Use standard macros for sys_sigpending() & sys_old_getrlimit()
      powerpc: Drop support for pre-POWER4 cpus
      powerpc: Remove STAB code
      powerpc: Remove MMU_FTR_SLB
      powerpc: Pull out ksp_vsid logic into a helper
      powerpc: Remove CONFIG_POWER3
      powerpc: Remove oprofile RS64 support
      powerpc: Remove power3 from comments
      powerpc: Remove CONFIG_POWER4
      powerpc: Remove CLASSIC_PPC
      powerpc: Move bad_stack() below the fwnmi_data_area
      powerpc: Update comments in irqflags.h
      powerpc: Document register clobbering in EXCEPTION_COMMON()
      powerpc: Remove misleading DISABLE_INTS
      powerpc: Add machine_early_initcall()
      powerpc/powernv: Switch powernv drivers to use machine_xxx_initcall()
      powerpc/pseries: Switch pseries drivers to use machine_xxx_initcall()
      powerpc: Document how we set AIL on guest kernels
      selftests/powerpc: Don't ignore errors from sub Makefiles
      selftests/powerpc: Fix parse_proc_maps()
      selftests/powerpc: Move core_busy_loop() into asm
      selftests/powerpc: Add test of L3 bank handling
      selftests/powerpc: Count instructions under scheduler pressure
      selftests/powerpc: Count more instructions & use decimal
      selftests/powerpc: Dump MMCR2 as part of the EBB HW state
      selftests/powerpc: Add cycles test with MMCR2 handling
      selftests/powerpc: Add a routine for retrieving an AUXV entry
      selftests/powerpc: Add test of per-event excludes
      powerpc/perf: Clear all MMCR settings before calling compute_mmcr()
      powerpc/perf: Pass the struct perf_events down to compute_mmcr()
      powerpc/perf: Add per-event excludes on Power8

Mike Qiu (2):
      powerpc/eeh: sysfs entries lost
      powerpc/eeh: Wrong place to call pci_get_slot()

Paul Mackerras (1):
      powerpc: Reduce scariness of interrupt frames in stack traces

Priyanka Jain (1):
      powerpc/85xx: Add binding for CPLD

Scott Wood (10):
      powerpc/e6500: hw tablewalk: clear TID in kernel indirect entries
      powerpc/e6500: hw tablewalk: fix recursive tlb lock on cpu 0
      powerpc/e500mc: Fix wrong value of MCSR_L2MMU_MHIT
      MAINTAINERS: Update Linux for Freescale PowerPC
      pcmcia: Remove m8xx_pcmcia driver
      powerpc/8xx: Remove empty asm/mpc8xx.h
      powerpc/booke: Define MSR bits the same way as reg.h
      powerpc/e6500: Work around erratum A-008139
      memory: Freescale CoreNet Coherency Fabric error reporting driver
      powerpc/64e: Add __ref to early_alloc_pgtable()

Shengzhou Liu (4):
      powerpc/defconfig: update RTC support
      powerpc/fsl-booke: Add support for T2080/T2081 SoC
      powerpc/fsl-booke: Add initial T208x QDS board support
      powerpc/t2080rdb: Add T2080RDB board support

Thomas Falcon (1):
      powerpc: Fix endianness of flash_block_list in rtas_flash

Tyrel Datwyler (1):
      powerpc/pci: Reorder pci bus/bridge unregistration during PHB removal

Vaidyanathan Srinivasan (2):
      powerpc/cpufreq: Add pr_warn() on OPAL firmware failures
      powerpc/cpuidle: Fix parsing of idle state flags from device-tree

Valentin Longchamp (1):
      powerpc/mpc85xx: fix fsl/p2041-post.dtsi clockgen mux2

Vasant Hegde (1):
      powerpc/powernv: Change BUG_ON to WARN_ON in elog code

Wladislav Wiebe (1):
      powerpc/traps/e500: fix misleading error output

 .../devicetree/bindings/powerpc/fsl/board.txt      |   16 +
 Documentation/vfio.txt                             |   87 +-
 MAINTAINERS                                        |    4 +-
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi        |    1 +
 arch/powerpc/boot/dts/fsl/t2080si-post.dtsi        |   69 ++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        |  435 ++++++++
 arch/powerpc/boot/dts/fsl/t208xsi-pre.dtsi         |   99 ++
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    1 +
 arch/powerpc/boot/dts/fsl/t4240si-pre.dtsi         |    1 +
 arch/powerpc/boot/dts/t2080qds.dts                 |   57 +
 arch/powerpc/boot/dts/t2080rdb.dts                 |   57 +
 arch/powerpc/boot/dts/t2081qds.dts                 |   46 +
 arch/powerpc/boot/dts/t208xqds.dtsi                |  239 ++++
 arch/powerpc/boot/dts/t208xrdb.dtsi                |  184 +++
 arch/powerpc/boot/dts/t4240rdb.dts                 |  186 ++++
 arch/powerpc/boot/io.h                             |    2 +-
 arch/powerpc/configs/corenet32_smp_defconfig       |    4 +-
 arch/powerpc/configs/corenet64_smp_defconfig       |    5 +
 arch/powerpc/configs/mpc85xx_defconfig             |    3 +
 arch/powerpc/configs/mpc85xx_smp_defconfig         |    3 +
 arch/powerpc/include/asm/cputable.h                |   31 +-
 arch/powerpc/include/asm/eeh.h                     |   62 +-
 arch/powerpc/include/asm/exception-64s.h           |   14 +-
 arch/powerpc/include/asm/fs_pd.h                   |    1 -
 arch/powerpc/include/asm/hardirq.h                 |    1 +
 arch/powerpc/include/asm/hw_irq.h                  |    1 +
 arch/powerpc/include/asm/irqflags.h                |    8 +-
 arch/powerpc/include/asm/jump_label.h              |    9 +
 arch/powerpc/include/asm/kvm_asm.h                 |    1 +
 arch/powerpc/include/asm/machdep.h                 |    5 +
 arch/powerpc/include/asm/mmu-hash64.h              |   22 -
 arch/powerpc/include/asm/mmu.h                     |    8 +-
 arch/powerpc/include/asm/mmu_context.h             |    6 +-
 arch/powerpc/include/asm/mpc85xx.h                 |    2 +
 arch/powerpc/include/asm/mpc8xx.h                  |   12 -
 arch/powerpc/include/asm/opal.h                    |  194 ++--
 arch/powerpc/include/asm/oprofile_impl.h           |    1 -
 arch/powerpc/include/asm/paca.h                    |    5 +-
 arch/powerpc/include/asm/perf_event_server.h       |    5 +-
 arch/powerpc/include/asm/ppc-opcode.h              |    9 +
 arch/powerpc/include/asm/pte-fsl-booke.h           |    2 +
 arch/powerpc/include/asm/pte-hash64-64k.h          |    5 +-
 arch/powerpc/include/asm/reg.h                     |    2 +-
 arch/powerpc/include/asm/reg_booke.h               |   57 +-
 arch/powerpc/include/asm/systbl.h                  |    4 +-
 arch/powerpc/include/asm/trace.h                   |   45 +
 arch/powerpc/kernel/asm-offsets.c                  |    2 -
 arch/powerpc/kernel/cputable.c                     |   94 +-
 arch/powerpc/kernel/eeh.c                          |  366 +++++-
 arch/powerpc/kernel/eeh_cache.c                    |    9 +-
 arch/powerpc/kernel/eeh_dev.c                      |    3 +-
 arch/powerpc/kernel/eeh_driver.c                   |   16 +-
 arch/powerpc/kernel/eeh_pe.c                       |   86 +-
 arch/powerpc/kernel/entry_64.S                     |   13 +-
 arch/powerpc/kernel/exceptions-64s.S               |  361 +++---
 arch/powerpc/kernel/head_64.S                      |   30 +-
 arch/powerpc/kernel/idle_power7.S                  |   69 +-
 arch/powerpc/kernel/iommu.c                        |    4 +-
 arch/powerpc/kernel/irq.c                          |   14 +
 arch/powerpc/kernel/process.c                      |   34 +-
 arch/powerpc/kernel/prom.c                         |   11 +-
 arch/powerpc/kernel/rtas_flash.c                   |    6 +-
 arch/powerpc/kernel/setup-common.c                 |    6 +-
 arch/powerpc/kernel/setup_64.c                     |   15 +-
 arch/powerpc/kernel/systbl.S                       |    3 -
 arch/powerpc/kernel/traps.c                        |   26 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |    6 +
 arch/powerpc/lib/copyuser_64.S                     |    3 +-
 arch/powerpc/mm/Makefile                           |    4 +-
 arch/powerpc/mm/hash_utils_64.c                    |   26 +-
 arch/powerpc/mm/init_64.c                          |  132 ++-
 arch/powerpc/mm/mmu_context_hash32.c               |    2 +-
 arch/powerpc/mm/numa.c                             |    2 +-
 arch/powerpc/mm/pgtable_32.c                       |    2 +-
 arch/powerpc/mm/pgtable_64.c                       |    2 +-
 arch/powerpc/mm/ppc_mmu_32.c                       |    2 +-
 arch/powerpc/mm/stab.c                             |  286 -----
 arch/powerpc/mm/tlb_low_64e.S                      |   69 +-
 arch/powerpc/oprofile/Makefile                     |    2 +-
 arch/powerpc/oprofile/common.c                     |    3 -
 arch/powerpc/oprofile/op_model_rs64.c              |  222 ----
 arch/powerpc/perf/core-book3s.c                    |   73 +-
 arch/powerpc/perf/mpc7450-pmu.c                    |    5 +-
 arch/powerpc/perf/power4-pmu.c                     |    2 +-
 arch/powerpc/perf/power5+-pmu.c                    |    2 +-
 arch/powerpc/perf/power5-pmu.c                     |    2 +-
 arch/powerpc/perf/power6-pmu.c                     |    2 +-
 arch/powerpc/perf/power7-pmu.c                     |    2 +-
 arch/powerpc/perf/power8-pmu.c                     |   27 +-
 arch/powerpc/perf/ppc970-pmu.c                     |    2 +-
 arch/powerpc/platforms/85xx/Kconfig                |    2 +-
 arch/powerpc/platforms/85xx/corenet_generic.c      |   53 +-
 arch/powerpc/platforms/85xx/smp.c                  |   44 +
 arch/powerpc/platforms/8xx/m8xx_setup.c            |    3 -
 arch/powerpc/platforms/8xx/mpc885ads_setup.c       |   62 --
 arch/powerpc/platforms/8xx/tqm8xx_setup.c          |    1 -
 arch/powerpc/platforms/Kconfig.cputype             |   18 +-
 arch/powerpc/platforms/powermac/Kconfig            |    2 +-
 arch/powerpc/platforms/powermac/feature.c          |   42 +-
 arch/powerpc/platforms/powernv/Makefile            |    3 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c          |  393 ++++---
 arch/powerpc/platforms/powernv/eeh-powernv.c       |   55 +-
 arch/powerpc/platforms/powernv/opal-async.c        |    3 +-
 arch/powerpc/platforms/powernv/opal-elog.c         |    4 +-
 arch/powerpc/platforms/powernv/opal-hmi.c          |  188 ++++
 arch/powerpc/platforms/powernv/opal-lpc.c          |    2 +-
 .../powerpc/platforms/powernv/opal-memory-errors.c |    3 +-
 arch/powerpc/platforms/powernv/opal-tracepoints.c  |   84 ++
 arch/powerpc/platforms/powernv/opal-wrappers.S     |  117 +-
 arch/powerpc/platforms/powernv/opal-xscom.c        |    2 +-
 arch/powerpc/platforms/powernv/opal.c              |   52 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  499 ++++++++-
 arch/powerpc/platforms/powernv/pci-p5ioc2.c        |    3 +-
 arch/powerpc/platforms/powernv/pci.c               |  169 ++-
 arch/powerpc/platforms/powernv/pci.h               |   25 +-
 arch/powerpc/platforms/powernv/rng.c               |    2 +-
 arch/powerpc/platforms/powernv/setup.c             |    2 +
 arch/powerpc/platforms/pseries/dtl.c               |    3 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   40 +-
 arch/powerpc/platforms/pseries/hvCall.S            |  172 ++-
 arch/powerpc/platforms/pseries/hvCall_inst.c       |    3 +-
 arch/powerpc/platforms/pseries/lpar.c              |   30 +-
 arch/powerpc/platforms/pseries/mobility.c          |    3 +-
 arch/powerpc/platforms/pseries/msi.c               |    4 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |    4 +-
 arch/powerpc/platforms/pseries/power.c             |    5 +-
 arch/powerpc/platforms/pseries/ras.c               |    2 +-
 arch/powerpc/platforms/pseries/reconfig.c          |    5 +-
 arch/powerpc/platforms/pseries/rng.c               |    2 +-
 arch/powerpc/platforms/pseries/setup.c             |    2 +-
 arch/powerpc/platforms/pseries/suspend.c           |    5 +-
 arch/powerpc/sysdev/fsl_pci.c                      |    4 +-
 arch/powerpc/sysdev/micropatch.c                   |    1 -
 arch/powerpc/sysdev/mpic_msgr.c                    |    2 +-
 arch/powerpc/xmon/xmon.c                           |   34 +-
 drivers/cpufreq/powernv-cpufreq.c                  |   18 +-
 drivers/cpuidle/cpuidle-powernv.c                  |   16 +-
 drivers/memory/Kconfig                             |   10 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/fsl-corenet-cf.c                    |  251 +++++
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c   |    1 -
 drivers/net/ethernet/freescale/fs_enet/mac-scc.c   |    1 -
 drivers/pcmcia/Kconfig                             |   10 -
 drivers/pcmcia/Makefile                            |    1 -
 drivers/pcmcia/m8xx_pcmcia.c                       | 1168 --------------------
 drivers/vfio/Makefile                              |    1 +
 drivers/vfio/pci/vfio_pci.c                        |   18 +-
 drivers/vfio/vfio_iommu_spapr_tce.c                |   17 +-
 drivers/vfio/vfio_spapr_eeh.c                      |   87 ++
 include/linux/vfio.h                               |   23 +
 include/uapi/linux/vfio.h                          |   34 +
 tools/testing/selftests/powerpc/Makefile           |   10 +-
 tools/testing/selftests/powerpc/pmu/Makefile       |   19 +-
 .../selftests/powerpc/pmu/count_instructions.c     |   30 +-
 tools/testing/selftests/powerpc/pmu/ebb/Makefile   |    5 +-
 .../testing/selftests/powerpc/pmu/ebb/busy_loop.S  |  271 +++++
 .../powerpc/pmu/ebb/cycles_with_mmcr2_test.c       |   91 ++
 tools/testing/selftests/powerpc/pmu/ebb/ebb.c      |  261 +----
 tools/testing/selftests/powerpc/pmu/ebb/ebb.h      |    1 -
 tools/testing/selftests/powerpc/pmu/l3_bank_test.c |   48 +
 tools/testing/selftests/powerpc/pmu/lib.c          |   50 +-
 tools/testing/selftests/powerpc/pmu/lib.h          |    1 +
 .../selftests/powerpc/pmu/per_event_excludes.c     |  114 ++
 163 files changed, 5483 insertions(+), 3288 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/t2080si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/t208xsi-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/t2080qds.dts
 create mode 100644 arch/powerpc/boot/dts/t2080rdb.dts
 create mode 100644 arch/powerpc/boot/dts/t2081qds.dts
 create mode 100644 arch/powerpc/boot/dts/t208xqds.dtsi
 create mode 100644 arch/powerpc/boot/dts/t208xrdb.dtsi
 create mode 100644 arch/powerpc/boot/dts/t4240rdb.dts
 delete mode 100644 arch/powerpc/include/asm/mpc8xx.h
 delete mode 100644 arch/powerpc/mm/stab.c
 delete mode 100644 arch/powerpc/oprofile/op_model_rs64.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-hmi.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-tracepoints.c
 create mode 100644 drivers/memory/fsl-corenet-cf.c
 delete mode 100644 drivers/pcmcia/m8xx_pcmcia.c
 create mode 100644 drivers/vfio/vfio_spapr_eeh.c
 create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/busy_loop.S
 create mode 100644 tools/testing/selftests/powerpc/pmu/ebb/cycles_with_mmcr2_test.c
 create mode 100644 tools/testing/selftests/powerpc/pmu/l3_bank_test.c
 create mode 100644 tools/testing/selftests/powerpc/pmu/per_event_excludes.c


