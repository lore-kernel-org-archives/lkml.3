Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaA1EgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 23:36:10 -0500
Received: from gate.crashing.org ([63.228.1.57]:46470 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbaA1EgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 23:36:07 -0500
Message-ID: <1390883744.3872.76.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jan 2014 15:35:44 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

So here's my next branch for powerpc. A bit late as I was on vacation
last week. It's mostly the same stuff that was in next already, I just
added two patches today which are the wiring up of lockref for powerpc,
which for some reason fell through the cracks last time and is trivial.

The merge has conflicts that aren't too nasty but in case you have an
issue resolving them, I've put a resolved branch in "test" of the same
repository for you to look at.

The highlights are, in addition to a bunch of bug fixes:

 - Reworked Machine Check handling on kernels running without a
hypervisor (or acting as a hypervisor). Provides hooks to handle
some errors in real mode such as TLB errors, handle SLB errors, etc...

 - Support for retrieving memory error information from the service
processor on IBM servers running without a hypervisor and routing
them to the memory poison infrastructure.

 - _PAGE_NUMA support on server processors

 - 32-bit BookE relocatable kernel support

 - FSL e6500 hardware tablewalk support

 - A bunch of new/revived board support

 - FSL e6500 deeper idle states and altivec powerdown support

I have a remaining fix that is still based on a different branch for
which I will send you a pull request separately (it's the patch that
didn't make it in -rc8 since it might potentially affect x86).

You'll notice a generic mm change here, it has been acked by the
relevant authorities and is a pre-req for our _PAGE_NUMA support.

The following changes since commit f991db1cf1bdca43675b5d2df0af991719727029:

  Merge remote-tracking branch 'agust/merge' into merge (2013-12-30 14:48:27 +1100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 7179ba52889bef7e5e23f72908270e1ab2b7fc6f:

  powerpc: Implement arch_spin_is_locked() using arch_spin_value_unlocked() (2014-01-28 14:45:44 +1100)

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      PPC: POWERNV: move iommu_add_device earlier

Alistair Popple (3):
      powerpc/iommu: Update constant names to reflect their hardcoded page size
      powerpc/iommu: Add it_page_shift field to determine iommu page size
      powerpc/iommu: Update the generic code to use dynamic iommu page sizes

Andreas Schwab (1):
      powerpc: Add vr save/restore functions

Aneesh Kumar K.V (5):
      mm: Move change_prot_numa outside CONFIG_ARCH_USES_NUMA_PROT_NONE
      powerpc/mm: Use HPTE constants when updating hpte bits
      powerpc/mm: Free up _PAGE_COHERENCE for numa fault use later
      powerpc/mm: Only check for _PAGE_PRESENT in set_pte/pmd functions
      powerpc/mm: Enable _PAGE_NUMA for book3s

Anton Blanchard (2):
      powerpc: Fix endian issues in power7/8 machine check handler
      drivers/tty: ehv_bytechan fails to build as a module

Benjamin Herrenschmidt (3):
      powerpc: Fix races with irq_work

Brian King (1):
      powerpc: Increase EEH recovery timeout for SR-IOV

Chen Gang (1):
      powerpc: kernel: remove useless code which related with 'max_cpus'

Christian Engelmayer (1):
      powerpc/sysdev: Fix a pci section mismatch for Book E

Denis Efremov (1):
      powerpc/ps3: Remove inline marking of EXPORT_SYMBOL functions

Diana Craciun (1):
      powerpc: Replaced tlbilx with tlbwe in the initialization code

Gavin Shan (9):
      powerpc/powernv: Move PHB-diag dump functions around
      powerpc/eeh: Output PHB diag-data
      powerpc/powernv: Remove unnecessary assignment
      powerpc/eeh: Add restore_config operation
      powerpc/eeh: Call opal_pci_reinit() on powernv for restoring config space
      powerpc/eeh: Hotplug improvement
      powerpc/iommu: Don't detach device without IOMMU group
      powerpc/eeh: Handle multiple EEH errors
      powerpc/eeh: Escalate error on non-existing PE

Geert Uytterhoeven (2):
      powerpc/windfarm: Remove superfluous name casts
      powerpc: Make add_system_ram_resources() __init

Ian Campbell (3):
      powerpc/4xx: Fix warning in kilauea.dtb
      powerpc/dts/virtex440: Declare address/size-cells for phy device
      powerpc/boot: Ignore .dtb files.

Jeremy Kerr (2):
      powerpc: Make slb_shadow a local
      powerpc: Dynamically allocate slb_shadow from memblock

Joseph Myers (6):
      powerpc: fix exception clearing in e500 SPE float emulation
      powerpc: fix e500 SPE float rounding inexactness detection
      math-emu: fix floating-point to integer unsigned saturation
      math-emu: fix floating-point to integer overflow detection
      powerpc: fix e500 SPE float to integer and fixed-point conversions
      powerpc: fix e500 SPE float SIGFPE generation

Kevin Hao (14):
      powerpc: Move the patch_exception to a common place
      powerpc: Use patch_exception to update the debug exception handler
      powerpc: purge all the prefetched instructions for the coherent icache flush
      powerpc/85xx: don't init the mpic ipi for the SoC which has doorbell support
      powerpc/fsl_booke: protect the access to MAS7
      powerpc/fsl_booke: introduce get_phys_addr function
      powerpc: introduce macro LOAD_REG_ADDR_PIC
      powerpc: enable the relocatable support for the fsl booke 32bit kernel
      powerpc/fsl_booke: set the tlb entry for the kernel address in AS1
      powerpc: introduce early_get_first_memblock_info
      powerpc/fsl_booke: introduce map_mem_in_cams_addr
      powerpc/fsl_booke: make sure PAGE_OFFSET map to memstart_addr for relocatable kernel
      powerpc/fsl_booke: smp support for booting a relocatable kernel above 64M
      powerpc/fsl_booke: enable the relocatable for the kdump kernel

LEROY Christophe (1):
      powerpc 8xx: defconfig: slice by 4 is more efficient than the default slice by 8 on Powerpc 8xx.

Lijun Pan (1):
      powerpc/85xx: Merge 85xx/p1023_defconfig into mpc85xx_smp and mpc85xx

Madhavan Srinivasan (1):
      powerpc/kernel/sysfs: Cleanup set up macros for PMC/non-PMC SPRs

Mahesh Salgaonkar (17):
      powerpc/book3s: Split the common exception prolog logic into two section.
      powerpc/book3s: Introduce exclusive emergency stack for machine check exception.
      powerpc/book3s: handle machine check in Linux host.
      powerpc/book3s: Return from interrupt if coming from evil context.
      powerpc/book3s: Introduce a early machine check hook in cpu_spec.
      powerpc/book3s: Add flush_tlb operation in cpu_spec.
      powerpc/book3s: Flush SLB/TLBs if we get SLB/TLB machine check errors on power7.
      powerpc/book3s: Flush SLB/TLBs if we get SLB/TLB machine check errors on power8.
      powerpc/book3s: Decode and save machine check event.
      powerpc/book3s: Queue up and process delayed MCE events.
      powerpc/powernv: Remove machine check handling in OPAL.
      powerpc/powernv: Machine check exception handling.
      powerpc/powernv: Infrastructure to read opal messages in generic format.
      powerpc/powernv: Add config option for hwpoisoning.
      powerpc/powernv: Get FSP memory errors and plumb into memory poison infrastructure.
      powerpc: Fix "attempt to move .org backwards" error
      Move precessing of MCE queued event out from syscall exit path.

Michael Ellerman (5):
      powerpc/pseries: CONFIG_PSERIES_MSI should depend on PPC_PSERIES
      powerpc/powernv: Replace CONFIG_POWERNV_MSI with just CONFIG_PPC_POWERNV
      powerpc: Add real mode cache inhibited IO accessors
      powerpc: Add support for the optimised lockref implementation
      powerpc: Implement arch_spin_is_locked() using arch_spin_value_unlocked()

Michael Neuling (1):
      powernv: Remove get/set_rtc_time when they are not present

Michael Opdenacker (1):
      powerpc: Remove unused REDBOOT Kconfig parameter

Mihai Caraman (1):
      powerpc/booke64: Add LRAT error exception handler

Nishanth Aravamudan (2):
      Revert "powerpc/pseries/iommu: remove default window before attempting DDW manipulation"
      Revert "pseries/iommu: Remove DDW on kexec"

Olof Johansson (1):
      powerpc: add SATA_MV to ppc64_defconfig

Paul Gortmaker (2):
      powerpc: fix 8xx and 6xx final link failures
      powerpc: Delete non-required instances of include <linux/init.h>

Paul Mackerras (3):
      powerpc: Reclaim two unused thread_info flag bits
      powerpc: Don't corrupt transactional state when using FP/VMX in kernel
      powerpc: Fix transactional FP/VMX/VSX unavailable handlers

Preeti U Murthy (1):
      pseries/cpuidle: Remove redundant call to ppc64_runlatch_off() in cpu idle routines

Scott Wood (5):
      powerpc/fsl-booke: Use SPRN_SPRGn rather than mfsprg/mtsprg
      powerpc: add barrier after writing kernel PTE
      powerpc/e6500: TLB miss handler with hardware tablewalk support
      powerpc/fsl-book3e-64: Use paca for hugetlb TLB1 entry selection
      powerpc/booke-64: fix tlbsrx. path in bolted tlb handler

Shaohui Xie (1):
      powerpc/85xx: handle the eLBC error interrupt if it exists in dts

Shengzhou Liu (2):
      powerpc/85xx/dts: add third elo3 dma component
      powerpc/fsl_pci: add versionless pci compatible

Srivatsa S. Bhat (2):
      powerpc: Fix the setup of CPU-to-Node mappings during CPU online
      powerpc: Add debug checks to catch invalid cpu-to-node mappings

Stephen Chivers (1):
      powerpc/embedded6xx: Add support for Motorola/Emerson MVME5100

Vasant Hegde (3):
      powerpc/powernv: Move SG list structure to header file
      powerpc/powernv: Increase candidate fw image size
      powerpc/powernv: Call OPAL sync before kexec'ing

Wang Dongsheng (9):
      powerpc/fsl: add E6500 PVR and SPRN_PWRMGTCR0 define
      powerpc/85xx: add hardware automatically enter altivec idle state
      powerpc/85xx: add hardware automatically enter pw20 state
      powerpc/85xx: add sysfs for pw20 state and altivec idle
      powerpc/p1022ds: fix rtc compatible string
      powerpc/p1022ds: add a interrupt for rtc node
      powerpc/mpic_timer: fix the time is not accurate caused by GTCRR toggle bit
      powerpc/mpic_timer: fix convert ticks to time subtraction overflow
      powerpc/dts: fix lbc lack of error interrupt

Xie Xiaobo (2):
      powerpc/85xx: Add QE common init function
      powerpc/85xx: Add TWR-P1025 board support

Yijing Wang (1):
      powerpc/pci: Use dev_is_pci() to check whether it is pci device

Zhao Qiang (3):
      powerpc/p1010rdb:update dts to adapt to both old and new p1010rdb
      powerpc/p1010rdb:update mtd of nand to adapt to both old and new p1010rdb
      powerpc/p1010rdb-pa: modify phy interrupt.

fan.du (1):
      powerpc: Make irq_stat.timers_irqs counting more specific

 .../devicetree/bindings/video/ssd1289fb.txt        |  13 +
 arch/powerpc/Kconfig                               |  15 +-
 arch/powerpc/boot/.gitignore                       |   1 +
 arch/powerpc/boot/Makefile                         |   7 +-
 arch/powerpc/boot/dts/fsl/elo3-dma-2.dtsi          |  82 +++++
 arch/powerpc/boot/dts/fsl/p1020si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/fsl/p1021si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/fsl/p1022si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/fsl/p1023si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/kilauea.dts                  |   2 +-
 arch/powerpc/boot/dts/mvme5100.dts                 | 185 ++++++++++
 arch/powerpc/boot/dts/p1010rdb-pa.dts              |  23 ++
 arch/powerpc/boot/dts/p1010rdb-pa.dtsi             |  85 +++++
 .../dts/{p1010rdb_36b.dts => p1010rdb-pa_36b.dts}  |  47 +--
 arch/powerpc/boot/dts/p1010rdb-pb.dts              |  35 ++
 arch/powerpc/boot/dts/p1010rdb-pb_36b.dts          |  58 +++
 arch/powerpc/boot/dts/p1010rdb.dts                 |  66 ----
 arch/powerpc/boot/dts/p1010rdb.dtsi                |  43 +--
 arch/powerpc/boot/dts/p1010rdb_32b.dtsi            |  79 +++++
 arch/powerpc/boot/dts/p1010rdb_36b.dtsi            |  79 +++++
 arch/powerpc/boot/dts/p1022ds.dtsi                 |   3 +-
 arch/powerpc/boot/dts/p1025twr.dts                 |  95 +++++
 arch/powerpc/boot/dts/p1025twr.dtsi                | 280 +++++++++++++++
 arch/powerpc/boot/dts/virtex440-ml507.dts          |   2 +
 arch/powerpc/boot/mvme5100.c                       |  27 ++
 arch/powerpc/boot/wrapper                          |   4 +
 arch/powerpc/configs/85xx/p1023_defconfig          | 188 ----------
 arch/powerpc/configs/adder875_defconfig            |   1 +
 arch/powerpc/configs/ep88xc_defconfig              |   1 +
 arch/powerpc/configs/mpc85xx_defconfig             |   3 +
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   3 +
 arch/powerpc/configs/mpc866_ads_defconfig          |   1 +
 arch/powerpc/configs/mpc885_ads_defconfig          |   1 +
 arch/powerpc/configs/mvme5100_defconfig            | 144 ++++++++
 arch/powerpc/configs/ppc64_defconfig               |   1 +
 arch/powerpc/configs/tqm8xx_defconfig              |   1 +
 arch/powerpc/include/asm/bitops.h                  |   5 +
 arch/powerpc/include/asm/cache.h                   |  14 +-
 arch/powerpc/include/asm/cmpxchg.h                 |   1 +
 arch/powerpc/include/asm/code-patching.h           |   7 +
 arch/powerpc/include/asm/cputable.h                |  12 +
 arch/powerpc/include/asm/eeh.h                     |  14 +-
 arch/powerpc/include/asm/exception-64s.h           |  21 +-
 arch/powerpc/include/asm/fsl_lbc.h                 |   2 +-
 arch/powerpc/include/asm/hardirq.h                 |   3 +-
 arch/powerpc/include/asm/io.h                      |  16 +
 arch/powerpc/include/asm/iommu.h                   |  54 ++-
 arch/powerpc/include/asm/kvm_asm.h                 |   1 +
 arch/powerpc/include/asm/lppaca.h                  |   2 -
 arch/powerpc/include/asm/mce.h                     | 197 +++++++++++
 arch/powerpc/include/asm/mmu-book3e.h              |  13 +
 arch/powerpc/include/asm/mmu.h                     |  21 +-
 arch/powerpc/include/asm/opal.h                    | 108 +++++-
 arch/powerpc/include/asm/paca.h                    |  16 +-
 arch/powerpc/include/asm/pgtable.h                 |  66 +++-
 arch/powerpc/include/asm/ppc_asm.h                 |  14 +-
 arch/powerpc/include/asm/processor.h               |   8 +-
 arch/powerpc/include/asm/ps3.h                     |   1 -
 arch/powerpc/include/asm/pte-hash64.h              |   8 +-
 arch/powerpc/include/asm/reg.h                     |   2 +
 arch/powerpc/include/asm/reg_booke.h               |  10 +
 arch/powerpc/include/asm/spinlock.h                |  12 +-
 arch/powerpc/include/asm/thread_info.h             |   9 +-
 arch/powerpc/include/asm/tm.h                      |   1 +
 arch/powerpc/include/asm/topology.h                |  10 +-
 arch/powerpc/include/asm/vio.h                     |   1 -
 arch/powerpc/kernel/Makefile                       |   1 +
 arch/powerpc/kernel/asm-offsets.c                  |  13 +
 arch/powerpc/kernel/cacheinfo.c                    |   1 -
 arch/powerpc/kernel/cpu_setup_fsl_booke.S          |  54 +++
 arch/powerpc/kernel/cpu_setup_power.S              |  38 +-
 arch/powerpc/kernel/cputable.c                     |  16 +
 arch/powerpc/kernel/crash.c                        |   1 -
 arch/powerpc/kernel/dma-iommu.c                    |   4 +-
 arch/powerpc/kernel/eeh.c                          |  17 +-
 arch/powerpc/kernel/eeh_driver.c                   | 162 +++++----
 arch/powerpc/kernel/eeh_pe.c                       |   4 +-
 arch/powerpc/kernel/entry_64.S                     |  12 +-
 arch/powerpc/kernel/exceptions-64e.S               |  27 +-
 arch/powerpc/kernel/exceptions-64s.S               | 242 +++++++++++--
 arch/powerpc/kernel/fpu.S                          |  16 +
 arch/powerpc/kernel/fsl_booke_entry_mapping.S      |   2 +
 arch/powerpc/kernel/head_64.S                      |   1 +
 arch/powerpc/kernel/head_fsl_booke.S               | 266 ++++++++++++--
 arch/powerpc/kernel/hw_breakpoint.c                |   1 -
 arch/powerpc/kernel/idle_power7.S                  |   1 +
 arch/powerpc/kernel/iomap.c                        |   1 -
 arch/powerpc/kernel/iommu.c                        | 145 ++++----
 arch/powerpc/kernel/irq.c                          |  12 +-
 arch/powerpc/kernel/kgdb.c                         |   1 -
 arch/powerpc/kernel/mce.c                          | 352 +++++++++++++++++++
 arch/powerpc/kernel/mce_power.c                    | 284 +++++++++++++++
 arch/powerpc/kernel/misc_32.S                      |   4 +-
 arch/powerpc/kernel/misc_64.S                      |   6 +
 arch/powerpc/kernel/paca.c                         |  37 +-
 arch/powerpc/kernel/process.c                      | 177 +++++++++-
 arch/powerpc/kernel/prom.c                         |  41 ++-
 arch/powerpc/kernel/setup_64.c                     |  47 ++-
 arch/powerpc/kernel/signal.c                       |   3 +-
 arch/powerpc/kernel/signal_32.c                    |  21 +-
 arch/powerpc/kernel/signal_64.c                    |  14 +-
 arch/powerpc/kernel/smp-tbsync.c                   |   1 -
 arch/powerpc/kernel/smp.c                          |   9 +-
 arch/powerpc/kernel/swsusp_booke.S                 |  32 +-
 arch/powerpc/kernel/syscalls.c                     |   1 -
 arch/powerpc/kernel/sysfs.c                        | 388 +++++++++++++++++++--
 arch/powerpc/kernel/time.c                         |  14 +-
 arch/powerpc/kernel/traps.c                        |  72 +++-
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S        |   1 -
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S        |   1 -
 arch/powerpc/kernel/vector.S                       |  10 +
 arch/powerpc/kernel/vio.c                          |  31 +-
 arch/powerpc/kvm/book3s_hv_ras.c                   |  50 ++-
 arch/powerpc/kvm/bookehv_interrupts.S              |   2 +
 arch/powerpc/lib/code-patching.c                   |  15 +
 arch/powerpc/lib/crtsavres.S                       | 186 ++++++++++
 arch/powerpc/math-emu/math_efp.c                   | 316 ++++++++++++-----
 arch/powerpc/mm/fsl_booke_mmu.c                    |  80 ++++-
 arch/powerpc/mm/hash_low_64.S                      |  15 +-
 arch/powerpc/mm/hash_utils_64.c                    |   7 +-
 arch/powerpc/mm/hugepage-hash64.c                  |   6 +-
 arch/powerpc/mm/hugetlbpage-book3e.c               |  54 ++-
 arch/powerpc/mm/hugetlbpage-hash64.c               |   4 +
 arch/powerpc/mm/mem.c                              |   8 +-
 arch/powerpc/mm/mmu_decl.h                         |   2 +
 arch/powerpc/mm/numa.c                             |  96 ++++-
 arch/powerpc/mm/pgtable.c                          |   3 +-
 arch/powerpc/mm/pgtable_32.c                       |   1 +
 arch/powerpc/mm/pgtable_64.c                       |  15 +-
 arch/powerpc/mm/tlb_hash64.c                       |   1 -
 arch/powerpc/mm/tlb_low_64e.S                      | 174 ++++++++-
 arch/powerpc/mm/tlb_nohash.c                       | 112 +++---
 arch/powerpc/mm/tlb_nohash_low.S                   |   4 +-
 arch/powerpc/oprofile/op_model_7450.c              |   1 -
 arch/powerpc/oprofile/op_model_cell.c              |   1 -
 arch/powerpc/oprofile/op_model_fsl_emb.c           |   1 -
 arch/powerpc/oprofile/op_model_pa6t.c              |   1 -
 arch/powerpc/oprofile/op_model_power4.c            |   1 -
 arch/powerpc/oprofile/op_model_rs64.c              |   1 -
 arch/powerpc/platforms/83xx/Kconfig                |   1 -
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c     |   1 -
 arch/powerpc/platforms/83xx/suspend.c              |   1 -
 arch/powerpc/platforms/85xx/Kconfig                |   6 +
 arch/powerpc/platforms/85xx/Makefile               |   1 +
 arch/powerpc/platforms/85xx/common.c               |  38 ++
 arch/powerpc/platforms/85xx/mpc85xx.h              |   6 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |  29 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |  25 +-
 arch/powerpc/platforms/85xx/sgy_cts1000.c          |   1 -
 arch/powerpc/platforms/85xx/smp.c                  |  17 +-
 arch/powerpc/platforms/85xx/twr_p102x.c            | 147 ++++++++
 arch/powerpc/platforms/8xx/Kconfig                 |   1 -
 arch/powerpc/platforms/Kconfig.cputype             |   1 +
 arch/powerpc/platforms/cell/beat_htab.c            |   4 +-
 arch/powerpc/platforms/cell/iommu.c                |  14 +-
 arch/powerpc/platforms/chrp/smp.c                  |   1 -
 arch/powerpc/platforms/embedded6xx/Kconfig         |  13 +-
 arch/powerpc/platforms/embedded6xx/Makefile        |   1 +
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |   1 -
 arch/powerpc/platforms/embedded6xx/mvme5100.c      | 221 ++++++++++++
 arch/powerpc/platforms/pasemi/dma_lib.c            |   1 -
 arch/powerpc/platforms/pasemi/iommu.c              |   5 +-
 arch/powerpc/platforms/powermac/pfunc_core.c       |   1 -
 arch/powerpc/platforms/powernv/Kconfig             |   5 -
 arch/powerpc/platforms/powernv/Makefile            |   1 +
 arch/powerpc/platforms/powernv/eeh-ioda.c          | 223 +++---------
 arch/powerpc/platforms/powernv/eeh-powernv.c       |  24 +-
 arch/powerpc/platforms/powernv/opal-flash.c        |  35 +-
 .../powerpc/platforms/powernv/opal-memory-errors.c | 146 ++++++++
 arch/powerpc/platforms/powernv/opal-rtc.c          |   6 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S     |   3 +
 arch/powerpc/platforms/powernv/opal.c              | 267 ++++++++------
 arch/powerpc/platforms/powernv/pci-ioda.c          |  11 +-
 arch/powerpc/platforms/powernv/pci-p5ioc2.c        |   2 +-
 arch/powerpc/platforms/powernv/pci.c               | 230 ++++++++----
 arch/powerpc/platforms/powernv/pci.h               |   3 +
 arch/powerpc/platforms/powernv/setup.c             |   6 +-
 arch/powerpc/platforms/ps3/spu.c                   |   2 +-
 arch/powerpc/platforms/pseries/Kconfig             |   2 +-
 arch/powerpc/platforms/pseries/cmm.c               |   1 -
 arch/powerpc/platforms/pseries/dtl.c               |   1 -
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   4 +-
 arch/powerpc/platforms/pseries/iommu.c             | 167 +++------
 arch/powerpc/platforms/pseries/lpar.c              |   5 +-
 arch/powerpc/platforms/pseries/processor_idle.c    |   3 -
 arch/powerpc/platforms/pseries/setup.c             |   4 +-
 arch/powerpc/platforms/wsp/wsp_pci.c               |  11 +-
 arch/powerpc/sysdev/Kconfig                        |   2 +-
 arch/powerpc/sysdev/cpm2_pic.c                     |   1 -
 arch/powerpc/sysdev/fsl_ifc.c                      |   1 -
 arch/powerpc/sysdev/fsl_lbc.c                      |  31 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   5 +-
 arch/powerpc/sysdev/ge/ge_pic.h                    |   1 -
 arch/powerpc/sysdev/i8259.c                        |   1 -
 arch/powerpc/sysdev/indirect_pci.c                 |   6 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                   |   1 -
 arch/powerpc/sysdev/mpic_timer.c                   |  10 +-
 arch/powerpc/sysdev/qe_lib/qe_io.c                 |   1 -
 arch/powerpc/sysdev/qe_lib/ucc.c                   |   1 -
 arch/powerpc/sysdev/qe_lib/ucc_fast.c              |   1 -
 arch/powerpc/sysdev/qe_lib/ucc_slow.c              |   1 -
 arch/powerpc/sysdev/udbg_memcons.c                 |   1 -
 arch/powerpc/sysdev/xics/icp-hv.c                  |   1 -
 arch/powerpc/xmon/xmon.c                           |   4 +
 drivers/macintosh/windfarm_lm75_sensor.c           |   2 +-
 drivers/macintosh/windfarm_max6690_sensor.c        |   2 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  12 +-
 drivers/tty/Kconfig                                |   2 +-
 drivers/vfio/vfio_iommu_spapr_tce.c                |  28 +-
 include/linux/mm.h                                 |   2 +-
 include/linux/of_fdt.h                             |   1 +
 include/math-emu/op-common.h                       |   9 +-
 mm/mempolicy.c                                     |   5 +-
 scripts/mod/modpost.c                              |   8 +-
 214 files changed, 6169 insertions(+), 1647 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/ssd1289fb.txt
 create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/mvme5100.dts
 create mode 100644 arch/powerpc/boot/dts/p1010rdb-pa.dts
 create mode 100644 arch/powerpc/boot/dts/p1010rdb-pa.dtsi
 rename arch/powerpc/boot/dts/{p1010rdb_36b.dts => p1010rdb-pa_36b.dts} (64%)
 create mode 100644 arch/powerpc/boot/dts/p1010rdb-pb.dts
 create mode 100644 arch/powerpc/boot/dts/p1010rdb-pb_36b.dts
 delete mode 100644 arch/powerpc/boot/dts/p1010rdb.dts
 create mode 100644 arch/powerpc/boot/dts/p1010rdb_32b.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1010rdb_36b.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1025twr.dts
 create mode 100644 arch/powerpc/boot/dts/p1025twr.dtsi
 create mode 100644 arch/powerpc/boot/mvme5100.c
 delete mode 100644 arch/powerpc/configs/85xx/p1023_defconfig
 create mode 100644 arch/powerpc/configs/mvme5100_defconfig
 create mode 100644 arch/powerpc/include/asm/mce.h
 create mode 100644 arch/powerpc/kernel/mce.c
 create mode 100644 arch/powerpc/kernel/mce_power.c
 create mode 100644 arch/powerpc/platforms/85xx/twr_p102x.c
 create mode 100644 arch/powerpc/platforms/embedded6xx/mvme5100.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-memory-errors.c


