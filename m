Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3GCWoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 18:44:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:42222 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab3GCWoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 18:44:06 -0400
Message-ID: <1372891427.4122.78.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 04 Jul 2013 08:43:47 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This is the powerpc changes for the 3.11 merge window. In addition to
the usual bug fixes and small updates, the main highlights are:

 - Support for transparent huge pages by Aneesh Kumar for 64-bit server
processors. This allows the use of 16M pages as transparent huge pages
on kernels compiled with a 64K base page size.

 - Base VFIO support for KVM on power by 
Alexey Kardashevskiy

 - Wiring up of our nvram to the pstore infrastructure, including
putting compressed oopses in there by Aruna Balakrishnaiah

 - Move, rework and improve our "EEH" (basically PCI error handling
and recovery) infrastructure. It is no longer specific to pseries but is
now usable by the new "powernv" platform as well (no hypervisor) by
Gavin Shan.

 - I fixed some bugs in our math-emu instruction decoding and made it
usable to emulate some optional FP instructions on processors with hard
FP that lack them (such as fsqrt on Freescale embedded processors).

 - Support for Power8 "Event Based Branch" facility by Michael Ellerman.
This facility allows what is basically "userspace interrupts" for
performance monitor events.

 - A bunch of Transactional Memory vs. Signals bug fixes and HW
breakpoint/watchpoint fixes by Michael Neuling.

And more ... I appologize in advance if I've failed to highlight
something that somebody deemed worth it.

Cheers,
Ben.

The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 1d8b368ab4aacfc3f864655baad4d31a3028ec1a:

  pstore: Add hsize argument in write_buf call of pstore_ftrace_call (2013-07-02 18:39:37 +1000)

----------------------------------------------------------------
Aaro Koskinen (1):
      powerpc/windfarm: Fix overtemperature clearing

Alexey Kardashevskiy (3):
      powerpc/vfio: Enable on PowerNV platform
      powerpc/vfio: Implement IOMMU driver for VFIO
      powerpc/vfio: Enable on pSeries platform

Alistair Popple (3):
      powerpc: Add a configuration option for early BootX/OpenFirmware debug
      powerpc: Update default configurations
      powerpc: Update currituck pci/usb fixup for new board revision

Anatolij Gustschin (1):
      powerpc/mpc512x: enable USB support in defconfig

Aneesh Kumar K.V (20):
      mm/thp: use the correct function when updating access flags
      mm/THP: add pmd args to pgtable deposit and withdraw APIs
      mm/THP: withdraw the pgtable after pmdp related operations
      mm/THP: don't use HPAGE_SHIFT in transparent hugepage code
      mm/THP: deposit the transpare huge pgtable before set_pmd
      powerpc/mm: handle hugepage size correctly when invalidating hpte entries
      powerpc/THP: Double the PMD table size for THP
      powerpc/THP: Implement transparent hugepages for ppc64
      powerpc: move find_linux_pte_or_hugepte and gup_hugepte to common code
      powerpc: Update find_linux_pte_or_hugepte to handle transparent hugepages
      powerpc: Replace find_linux_pte with find_linux_pte_or_hugepte
      powerpc/kvm: Handle transparent hugepage in KVM
      powerpc: Update gup_pmd_range to handle transparent hugepages
      powerpc/THP: Add code to handle HPTE faults for hugepages
      powerpc: Make linux pagetable walk safe with THP enabled
      powerpc: Prevent gcc to re-read the pagetables
      powerpc: disable assert_pte_locked for collapse_huge_page
      powerpc: split hugepage when using subpage protection
      powerpc/THP: Enable THP on PPC64
      powerpc: Optimize hugepage invalidate

Anton Blanchard (1):
      powerpc: Align thread->fpr to 16 bytes

Aruna Balakrishnaiah (13):
      powerpc/pseries: Remove syslog prefix in uncompressed oops text
      powerpc/pseries: Add version and timestamp to oops header
      powerpc/pseries: Introduce generic read function to read nvram-partitions
      powerpc/pseries: Read/Write oops nvram partition via pstore
      powerpc/pseries: Read rtas partition via pstore
      powerpc/pseries: Distinguish between a os-partition and non-os partition
      powerpc/pseries: Read of-config partition via pstore
      powerpc/pseries: Read common partition via pstore
      powerpc/pseries: Enable PSTORE in pseries_defconfig
      pstore: Pass header size in the pstore write callback
      powerpc/pseries: Re-organise the oops compression code
      powerpc/pseries: Support compression of oops text via pstore
      pstore: Add hsize argument in write_buf call of pstore_ftrace_call

Benjamin Herrenschmidt (8):
      powerpc/math-emu: Fix decoding of some instructions
      powerpc/math-emu: Allow math-emu to be used for HW FPU
      powerpc/8xx: Remove 8xx specific "minimal FPU emulation"
      powerpc/powernv: Fix iommu initialization again
      powerpc: Handle both new style and old style reserve maps

Bharat Bhushan (2):
      powerpc: Debug control and status registers are 32bit
      powerpc: Restore dbcr0 on user space exit

Bjorn Helgaas (1):
      powerpc/iommu: Remove unused pci_iommu_init() and pci_direct_iommu_init()

Chen Gang (2):
      powerpc/nvram64: Need return the related error code on failure occurs
      powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries

Chunhe Lan (1):
      powerpc/fsl: Enable CONFIG_E1000E in mpc85xx_smp_defconfig

Daniel Walker (1):
      powerpc/mm: Make mmap_64.c compile on 32bit powerpc

Dongsheng.wang@freescale.com (4):
      powerpc/mpic: add irq_set_wake support
      powerpc/mpic: add global timer support
      powerpc/mpic: create mpic subsystem object
      powerpc/fsl: add MPIC timer wakeup support

Gavin Shan (43):
      powerpc/eeh: Fix fetching bus for single-dev-PE
      powerpc/eeh: Enhance converting EEH dev
      powerpc/eeh: Cleanup for EEH core
      powerpc/eeh: Move common part to kernel directory
      powerpc/eeh: Make eeh_phb_pe_get() public
      powerpc/eeh: Make eeh_pe_get() public
      powerpc/eeh: Trace PCI bus from PE
      powerpc/eeh: Make eeh_init() public
      powerpc/eeh: EEH post initialization operation
      powerpc/eeh: Refactor eeh_reset_pe_once()
      powerpc/eeh: Delay EEH probe during hotplug
      powerpc/eeh: Single kthread to handle events
      powerpc/eeh: Trace time on first error for PE
      powerpc/eeh: Allow to purge EEH events
      powerpc/eeh: Export confirm_error_lock
      powerpc/eeh: EEH core to handle special event
      powerpc/eeh: Sync OPAL API with firmware
      powerpc/eeh: EEH backend for P7IOC
      powerpc/eeh: I/O chip post initialization
      powerpc/eeh: I/O chip EEH enable option
      powerpc/eeh: I/O chip EEH state retrieval
      powerpc/eeh: I/O chip PE reset
      powerpc/eeh: I/O chip PE log and bridge setup
      powerpc/eeh: I/O chip next error
      powerpc/eeh: PowerNV EEH backends
      powerpc/eeh: Initialization for PowerNV
      powerpc/eeh: Enable EEH check for config access
      powerpc/eeh: Allow to check fenced PHB proactively
      powernv/opal: Notifier for OPAL events
      powernv/opal: Disable OPAL notifier upon poweroff
      powerpc/eeh: Register OPAL notifier for PCI error
      powerpc/powernv: Debugfs directory for PHB
      powerpc/eeh: Debugfs for error injection
      powerpc/eeh: Remove eeh_mutex
      powerpc/eeh: Use interruptible sleep in keehd
      powerpc/eeh: Don't collect PCI-CFG data on PHB
      powerpc/eeh: Check PCIe link after reset
      powerpc/powernv: Replace variables with flags
      powerpc/eeh: Fix address catch for PowerNV
      powerpc/eeh: Refactor the output message
      powerpc/eeh: Avoid build warnings
      powerpc/powernv: Use dev-node in PCI config accessors
      powerpc/eeh: Update MAINTAINERS

Geert Uytterhoeven (1):
      mac: Make cuda_init_via() __init

Gerhard Sittig (3):
      powerpc/mpc512x: move common code to shared.c file
      powerpc/mpc512x: initialize board restart earlier
      powerpc/mpc512x: commit re-generated defconfig

Hongtao Jia (1):
      powerpc/mpic: Add get_version API both for internal and external use

James Yang (1):
      powerpc: Fix string instr. emulation for 32-bit processes on ppc64

Jeremy Kerr (1):
      powerpc/prom: Scan reserved-ranges node for memory reservations

Joe Liccese (1):
      powerpc: Add T4 LAC device tree binding & defs

Joe Perches (2):
      powerpc/idle: Convert use of typedef ctl_table to struct ctl_table
      macintosh: Convert use of typedef ctl_table to struct ctl_table

Kevin Hao (3):
      powerpc: Remove the unneeded trigger of decrementer interrupt in decrementer_check_overflow
      powerpc: Don't flush/invalidate the d/icache for an unknown relocation type
      powerpc/85xx: enable coreint for all the 64bit boards

Kirill A. Shutemov (1):
      mm/thp: define HPAGE_PMD_* constants as BUILD_BUG() if !THP

LEROY Christophe (1):
      powerpc/8xx: Erroneous double irq_eoi() on CPM IRQ in MPC8xx

Li Zhong (1):
      powerpc: Set cpu sibling mask before online cpu

Matteo Facchinetti (1):
      powerpc/mpc512x: add MPC5125 reset module support for system restart

Michael Ellerman (13):
      powerpc: Remove unreachable relocation on exception handlers
      powerpc: Remove KVMTEST from RELON exception handlers
      powerpc: Rename and flesh out the facility unavailable exception handler
      powerpc: Wire up the HV facility unavailable exception
      powerpc/perf: Check that events only include valid bits on Power8
      powerpc/perf: Rework disable logic in pmu_disable()
      powerpc/perf: Freeze PMC5/6 if we're not using them
      powerpc/perf: Use existing out label in power_pmu_enable()
      powerpc/perf: Don't enable if we have zero events
      powerpc/perf: Drop MMCRA from thread_struct
      powerpc/perf: Core EBB support for 64-bit book3s
      powerpc/perf: Add power8 EBB support
      powerpc/pseries: Inform the hypervisor we are using EBB regs

Michael Neuling (10):
      powerpc: Fix single step emulation of 32bit overflowed branches
      powerpc/tm: Fix writing top half of MSR on 32 bit signals
      powerpc/tm: Fix 32 bit non-rt signals
      powerpc/tm: Fix restoration of MSR on 32bit signal return
      powerpc/tm: Fix return of 32bit rt signals to active transactions
      powerpc/tm: Fix return of active 64bit signals
      powerpc/hw_brk: Fix setting of length for exact mode breakpoints
      powerpc/hw_brk: Fix clearing of extraneous IRQ
      powerpc/tm: Clear MSR RI in non-recoverable TM code
      powerpc/hw_brk: Fix off by one error when validating DAWR region end

Nathan Fontenot (2):
      powerpc/mm: Fix build warnings with CONFIG_TRANSPARENT_HUGEPAGE disabled
      powerpc/numa: Do not update sysfs cpu registration from invalid context

Paul Gortmaker (1):
      powerpc: Delete __cpuinit usage from all users

Robert P. J. Day (1):
      macintosh/adb: Replace __WAITQUEUE_INITIALIZER with more standard DECLARE_WAITQUEUE.

Sachin Surendran (1):
      i2c-cpm: Fix to takeback i2c bus master-ship after a collision

Scott Wood (1):
      powerpc/mm/nohash: Ignore NULL stale_map entries

Sebastien Bessiere (1):
      trivial: powerpc: Fix typo in ioei_interrupt() description

Suzuki K. Poulose (2):
      powerpc/kprobes: Do not disable External interrupts during single step
      powerpc: Move the single step enable code to a generic path

Thomas Gleixner (1):
      powerpc: Mark low level irq handlers NO_THREAD

Tudor Laurentiu (1):
      powerpc/watchdog: Don't enable interrupt on PPC64 BookE

Wei Yongjun (1):
      powerpc/83xx: use module_i2c_driver to simplify the code

Wolfram Sang (1):
      macintosh/windfarm: Remove obsolete cleanup for clientdata

liguang (2):
      powerpc/smp: Use '==' instead of '<' for system_state
      powerpc/pseries: Use 'true' instead of '1' for orderly_poweroff

 .../bindings/powerpc/fsl/interlaken-lac.txt        | 309 +++++++
 Documentation/powerpc/00-INDEX                     |   2 +
 Documentation/powerpc/pmu-ebb.txt                  | 137 +++
 Documentation/vfio.txt                             |  63 ++
 MAINTAINERS                                        |   8 +-
 arch/powerpc/Kconfig                               |  17 +-
 arch/powerpc/Kconfig.debug                         |   7 +
 arch/powerpc/boot/dts/currituck.dts                |   5 +
 .../boot/dts/fsl/interlaken-lac-portals.dtsi       | 156 ++++
 arch/powerpc/boot/dts/fsl/interlaken-lac.dtsi      |  45 +
 arch/powerpc/configs/c2k_defconfig                 |   2 +
 arch/powerpc/configs/g5_defconfig                  |   2 +
 arch/powerpc/configs/maple_defconfig               |   2 +
 arch/powerpc/configs/mpc512x_defconfig             |  27 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   1 +
 arch/powerpc/configs/pmac32_defconfig              |   2 +
 arch/powerpc/configs/ppc64_defconfig               |   2 +
 arch/powerpc/configs/ppc6xx_defconfig              |   2 +
 arch/powerpc/configs/pseries_defconfig             |   1 +
 arch/powerpc/include/asm/eeh.h                     |  36 +-
 arch/powerpc/include/asm/eeh_event.h               |   2 +
 arch/powerpc/include/asm/exception-64s.h           |   8 +-
 arch/powerpc/include/asm/hugetlb.h                 |   8 +-
 arch/powerpc/include/asm/iommu.h                   |  33 +-
 arch/powerpc/include/asm/kvm_book3s_64.h           |  58 +-
 arch/powerpc/include/asm/lppaca.h                  |   3 +-
 arch/powerpc/include/asm/machdep.h                 |  11 +-
 arch/powerpc/include/asm/mmu-hash64.h              |  14 +
 arch/powerpc/include/asm/mpc5121.h                 |   1 -
 arch/powerpc/include/asm/mpic.h                    |   5 +
 arch/powerpc/include/asm/mpic_timer.h              |  46 ++
 arch/powerpc/include/asm/opal.h                    | 140 +++-
 arch/powerpc/include/asm/perf_event_server.h       |   6 +
 arch/powerpc/include/asm/pgalloc-64.h              |   6 +-
 arch/powerpc/include/asm/pgtable-ppc64-64k.h       |   3 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           | 241 +++++-
 arch/powerpc/include/asm/pgtable.h                 |   6 +
 arch/powerpc/include/asm/probes.h                  |  25 +
 arch/powerpc/include/asm/processor.h               |  16 +-
 arch/powerpc/include/asm/reg.h                     |   9 +
 arch/powerpc/include/asm/rtas.h                    |   4 +-
 arch/powerpc/include/asm/switch_to.h               |  14 +
 arch/powerpc/include/asm/tlbflush.h                |   3 +-
 arch/powerpc/include/asm/vdso.h                    |   2 +-
 arch/powerpc/kernel/Makefile                       |   4 +-
 arch/powerpc/kernel/asm-offsets.c                  |   7 +-
 arch/powerpc/kernel/cacheinfo.c                    |  36 +-
 arch/powerpc/{platforms/pseries => kernel}/eeh.c   | 196 ++++-
 .../{platforms/pseries => kernel}/eeh_cache.c      |   5 +-
 .../{platforms/pseries => kernel}/eeh_dev.c        |   0
 .../{platforms/pseries => kernel}/eeh_driver.c     | 169 +++-
 .../{platforms/pseries => kernel}/eeh_event.c      | 134 +--
 .../powerpc/{platforms/pseries => kernel}/eeh_pe.c | 237 +++++-
 .../{platforms/pseries => kernel}/eeh_sysfs.c      |   1 -
 arch/powerpc/kernel/entry_64.S                     |  30 +-
 arch/powerpc/kernel/exceptions-64s.S               |  56 +-
 arch/powerpc/kernel/hw_breakpoint.c                |   3 +-
 arch/powerpc/kernel/idle.c                         |   4 +-
 arch/powerpc/kernel/io-workarounds.c               |  11 +-
 arch/powerpc/kernel/iommu.c                        | 323 ++++++++
 arch/powerpc/kernel/irq.c                          |   2 -
 arch/powerpc/kernel/kprobes.c                      |  20 +-
 arch/powerpc/kernel/nvram_64.c                     |  20 +-
 arch/powerpc/kernel/pci-hotplug.c                  | 111 +++
 arch/powerpc/kernel/process.c                      |   4 +
 arch/powerpc/kernel/prom.c                         |  42 +-
 arch/powerpc/kernel/ptrace.c                       |   4 +-
 arch/powerpc/kernel/reloc_32.S                     |   3 +-
 arch/powerpc/kernel/rtas.c                         |   4 +-
 arch/powerpc/kernel/setup_64.c                     |   2 +-
 arch/powerpc/kernel/signal_32.c                    |  70 +-
 arch/powerpc/kernel/signal_64.c                    |   8 +-
 arch/powerpc/kernel/smp.c                          |  12 +-
 arch/powerpc/kernel/sysfs.c                        |   6 +-
 arch/powerpc/kernel/time.c                         |   1 -
 arch/powerpc/kernel/tm.S                           |  18 +-
 arch/powerpc/kernel/traps.c                        |  79 +-
 arch/powerpc/kernel/udbg.c                         |   2 +-
 arch/powerpc/kernel/vdso.c                         |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c              |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   8 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |  14 +-
 arch/powerpc/lib/sstep.c                           |   2 +-
 arch/powerpc/math-emu/Makefile                     |   3 +-
 arch/powerpc/math-emu/fre.c                        |  11 +
 arch/powerpc/math-emu/frsqrtes.c                   |  11 +
 arch/powerpc/math-emu/math.c                       |  14 +-
 arch/powerpc/mm/44x_mmu.c                          |   6 +-
 arch/powerpc/mm/Makefile                           |   8 +-
 arch/powerpc/mm/gup.c                              |  18 +-
 arch/powerpc/mm/hash_low_64.S                      |  21 +-
 arch/powerpc/mm/hash_native_64.c                   | 195 +++--
 arch/powerpc/mm/hash_utils_64.c                    |  67 +-
 arch/powerpc/mm/hugepage-hash64.c                  | 175 ++++
 arch/powerpc/mm/hugetlbpage-hash64.c               |   2 +-
 arch/powerpc/mm/hugetlbpage.c                      | 299 ++++---
 arch/powerpc/mm/init_64.c                          |   9 +-
 arch/powerpc/mm/mem.c                              |   4 +
 arch/powerpc/mm/{mmap_64.c => mmap.c}              |   0
 arch/powerpc/mm/mmu_context_nohash.c               |  15 +-
 arch/powerpc/mm/numa.c                             |  12 +-
 arch/powerpc/mm/pgtable.c                          |   8 +
 arch/powerpc/mm/pgtable_64.c                       | 414 ++++++++++
 arch/powerpc/mm/subpage-prot.c                     |  48 ++
 arch/powerpc/mm/tlb_hash64.c                       |  36 +-
 arch/powerpc/mm/tlb_nohash.c                       |   2 +-
 arch/powerpc/perf/core-book3s.c                    | 201 ++++-
 arch/powerpc/perf/power8-pmu.c                     |  62 +-
 arch/powerpc/platforms/44x/currituck.c             |  43 +-
 arch/powerpc/platforms/44x/iss4xx.c                |   4 +-
 arch/powerpc/platforms/512x/mpc5121_ads.c          |   6 +-
 arch/powerpc/platforms/512x/mpc512x.h              |  12 +-
 arch/powerpc/platforms/512x/mpc512x_generic.c      |   4 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c       |  31 +-
 arch/powerpc/platforms/512x/pdm360ng.c             |   4 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c     |  12 +-
 arch/powerpc/platforms/85xx/p5020_ds.c             |   5 -
 arch/powerpc/platforms/85xx/p5040_ds.c             |   5 -
 arch/powerpc/platforms/85xx/smp.c                  |   6 +-
 arch/powerpc/platforms/85xx/t4240_qds.c            |   5 -
 arch/powerpc/platforms/8xx/m8xx_setup.c            |  14 +-
 arch/powerpc/platforms/Kconfig                     |  26 +
 arch/powerpc/platforms/Kconfig.cputype             |   1 +
 arch/powerpc/platforms/cell/beat_htab.c            |  16 +-
 arch/powerpc/platforms/cell/smp.c                  |   2 +-
 arch/powerpc/platforms/powermac/smp.c              |   2 +-
 arch/powerpc/platforms/powernv/Makefile            |   1 +
 arch/powerpc/platforms/powernv/eeh-ioda.c          | 916 +++++++++++++++++++++
 arch/powerpc/platforms/powernv/eeh-powernv.c       | 379 +++++++++
 arch/powerpc/platforms/powernv/opal-wrappers.S     |   3 +
 arch/powerpc/platforms/powernv/opal.c              |  69 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  62 +-
 arch/powerpc/platforms/powernv/pci-p5ioc2.c        |  11 +-
 arch/powerpc/platforms/powernv/pci.c               | 139 +++-
 arch/powerpc/platforms/powernv/pci.h               |  35 +
 arch/powerpc/platforms/powernv/setup.c             |   4 +
 arch/powerpc/platforms/powernv/smp.c               |   4 +-
 arch/powerpc/platforms/ps3/htab.c                  |   5 +-
 arch/powerpc/platforms/pseries/Kconfig             |   5 -
 arch/powerpc/platforms/pseries/Makefile            |   4 +-
 arch/powerpc/platforms/pseries/io_event_irq.c      |   2 +-
 arch/powerpc/platforms/pseries/iommu.c             |   4 +
 arch/powerpc/platforms/pseries/lpar.c              | 142 +++-
 arch/powerpc/platforms/pseries/nvram.c             | 554 ++++++++++---
 arch/powerpc/platforms/pseries/pci_dlpar.c         |  85 --
 arch/powerpc/platforms/pseries/ras.c               |   8 +-
 arch/powerpc/platforms/pseries/smp.c               |   2 +-
 arch/powerpc/sysdev/Makefile                       |   2 +
 arch/powerpc/sysdev/cpm1.c                         |   1 +
 arch/powerpc/sysdev/fsl_mpic_timer_wakeup.c        | 161 ++++
 arch/powerpc/sysdev/mpic.c                         |  58 +-
 arch/powerpc/sysdev/mpic_timer.c                   | 593 +++++++++++++
 arch/s390/include/asm/pgtable.h                    |   5 +-
 arch/s390/mm/pgtable.c                             |   5 +-
 arch/sparc/include/asm/pgtable_64.h                |   5 +-
 arch/sparc/mm/tlb.c                                |   5 +-
 drivers/acpi/apei/erst.c                           |   4 +-
 drivers/firmware/efi/efi-pstore.c                  |   2 +-
 drivers/i2c/busses/i2c-cpm.c                       |   8 +
 drivers/iommu/Kconfig                              |   8 +
 drivers/macintosh/adb.c                            |   2 +-
 drivers/macintosh/mac_hid.c                        |   8 +-
 drivers/macintosh/via-cuda.c                       |   2 +-
 drivers/macintosh/windfarm_pm121.c                 |   6 +-
 drivers/macintosh/windfarm_pm81.c                  |   6 +-
 drivers/macintosh/windfarm_pm91.c                  |   6 +-
 drivers/macintosh/windfarm_smu_sat.c               |   1 -
 drivers/vfio/Kconfig                               |   6 +
 drivers/vfio/Makefile                              |   1 +
 drivers/vfio/vfio.c                                |   1 +
 drivers/vfio/vfio_iommu_spapr_tce.c                | 377 +++++++++
 drivers/watchdog/booke_wdt.c                       |   8 +
 fs/pstore/ftrace.c                                 |   2 +-
 fs/pstore/inode.c                                  |   9 +
 fs/pstore/platform.c                               |  10 +-
 fs/pstore/ram.c                                    |   3 +-
 include/asm-generic/pgtable.h                      |   5 +-
 include/linux/huge_mm.h                            |   6 +-
 include/linux/pstore.h                             |  12 +-
 include/uapi/linux/vfio.h                          |  34 +
 mm/huge_memory.c                                   |  28 +-
 mm/pgtable-generic.c                               |   5 +-
 182 files changed, 7633 insertions(+), 1177 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/interlaken-lac.txt
 create mode 100644 Documentation/powerpc/pmu-ebb.txt
 create mode 100644 arch/powerpc/boot/dts/fsl/interlaken-lac-portals.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/interlaken-lac.dtsi
 create mode 100644 arch/powerpc/include/asm/mpic_timer.h
 rename arch/powerpc/{platforms/pseries => kernel}/eeh.c (86%)
 rename arch/powerpc/{platforms/pseries => kernel}/eeh_cache.c (99%)
 rename arch/powerpc/{platforms/pseries => kernel}/eeh_dev.c (100%)
 rename arch/powerpc/{platforms/pseries => kernel}/eeh_driver.c (81%)
 rename arch/powerpc/{platforms/pseries => kernel}/eeh_event.c (56%)
 rename arch/powerpc/{platforms/pseries => kernel}/eeh_pe.c (75%)
 rename arch/powerpc/{platforms/pseries => kernel}/eeh_sysfs.c (99%)
 create mode 100644 arch/powerpc/kernel/pci-hotplug.c
 create mode 100644 arch/powerpc/math-emu/fre.c
 create mode 100644 arch/powerpc/math-emu/frsqrtes.c
 create mode 100644 arch/powerpc/mm/hugepage-hash64.c
 rename arch/powerpc/mm/{mmap_64.c => mmap.c} (100%)
 create mode 100644 arch/powerpc/platforms/powernv/eeh-ioda.c
 create mode 100644 arch/powerpc/platforms/powernv/eeh-powernv.c
 create mode 100644 arch/powerpc/sysdev/fsl_mpic_timer_wakeup.c
 create mode 100644 arch/powerpc/sysdev/mpic_timer.c
 create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c


