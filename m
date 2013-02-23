Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3BWRqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 12:46:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:53645 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab3BWRqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 12:46:46 -0500
Message-ID: <1361641550.15017.57.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 23 Feb 2013 11:45:50 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

So from the depth of frozen Minnesota, here's the powerpc pull request
for 3.9. It has a few interesting highlights, in addition to the usual
bunch of bug fixes, minor updates, embedded device tree updates and new
boards:

 - Hand tuned asm implementation of SHA1 (by Paulus & Michael Ellerman)

 - Support for Doorbell interrupts on Power8 (kind of fast thread-thread
IPIs) by Ian Munsie

 - Long overdue cleanup of the way we handle relocation of our open
firmware trampoline (prom_init.c) on 64-bit by Anton Blanchard

 - Support for saving/restoring & context switching the PPR (Processor
Priority Register) on server processors that support it. This allows the
kernel to preserve thread priorities established by userspace. By Haren
Myneni.

 - DAWR (new watchpoint facility) support on Power8 by Michael Neuling

 - Ability to change the DSCR (Data Stream Control Register) which
controls cache prefetching on a running process via ptrace by Alexey
Kardashevskiy

 - Support for context switching the TAR register on Power8 (new branch
target register meant to be used by some new specific userspace perf
event interrupt facility which is yet to be enabled) by Ian Munsie.

 - Improve preservation of the CFAR register (which captures the origin
of a branch) on various exception conditions by Paulus.

 - Move the Bestcomm DMA driver from arch powerpc to drivers/dma where
it belongs by Philippe De Muyter

 - Support for Transactional Memory on Power8 by Michael Neuling
(based on original work by Matt Evans). For those curious about the
feature, the patch contains a pretty good description.

Cheers,
Ben.

The following changes since commit 689dfa894c57842a05bf6dc9f97e6bb71ec5f386:

  powerpc: Max next_tb to prevent from replaying timer interrupt (2013-01-29 10:18:16 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 8520e443aa56cc157b015205ea53e7b9fc831291:

  powerpc/kexec: Disable hard IRQ before kexec (2013-02-24 03:49:28 +1100)

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      powerpc: Add DSCR support to ptrace

Anatolij Gustschin (11):
      powerpc/mpc5121: add common .dtsi and use it in mpc5121ads.dts
      powerpc/mpc5121: pdm360ng.dts: use common mpc5121.dtsi
      mpc5121: remove obsolete cell-index property from PSC clock code
      mpc5121: don't check PSC ac97 using node name
      powerpc/512x: initialize clocks before bus probing
      drivers/video: fsl-diu-fb: fix pixel formats for 24 and 16 bpp
      drivers/video: fsl-diu-fb: fix bugs in interrupt handling
      powerpc/512x: add function for chip select parameter configuration
      powerpc/mpc512x: fix noderef sparse warnings
      powerpc/mpc512x: fix sparce warnings for non static symbols
      powerpc/mpc5xxx: fix sparse warning for non static symbol

Anshuman Khandual (1):
      powerpc/perf: Change PMU flag representation from decimal to hex

Anton Blanchard (7):
      powerpc: Relocate prom_init.c on 64bit
      powerpc: Remove RELOC() macro
      powerpc: Build kernel with -mcmodel=medium
      powerpc: Run savedefconfig over pseries, ppc64 and ppc64e defconfig
      powerpc: Cleanup NLS config options on pseries, ppc64 and ppc64e defconfig
      powerpc: Enable devtmpfs, EFI partition support and tmpfs ACLs on pseries, ppc64 and ppc64e defconfig
      powerpc: Avoid load of static chain register when calling nested functions through a pointer on 64bit

Benjamin Collins (1):
      powerpc: Add support for CTS-1000 GPIO controlled system poweroff

Benjamin Herrenschmidt (4):
      powerpc: Make room in exception vector area
      Merge branch 'merge' into next
      Merge remote-tracking branch 'kumar/next' into next
      Merge remote-tracking branch 'agust/next' into next

Chris Freehill (1):
      powerpc/perf: Add stalled-cycles events

Cody P Schafer (1):
      powerpc/mm: Eliminate unneeded for_each_memblock

Daniel Borkmann (1):
      powerpc: fix ics_rtas_init and start_secondary section mismatch

David Woodhouse (1):
      powerpc: Enable ARCH_USE_BUILTIN_BSWAP

Geoff Levand (4):
      powerpc/ps3: Add macro PS3_VERBOSE_RESULT
      powerpc/ps3: Increase verbosity of htab errors
      powerpc/ps3: Refresh ps3_defconfig
      powerpc: Move boot_paca into early_setup

Gerlando Falauto (2):
      powerpc/83xx: refactor mpc8360e quirk for kmeter1
      powerpc/83xx: apply mpc8360e quirk for kmeter1 only when par_io is present

Gernot Vormayr (1):
      powerpc/dts/virtex440: Add ethernet phy to virtex440-ml507 board

Grant Likely (2):
      powerpc/5200: Add Lite5200 on-board LEDs as devices
      powerpc/5200: Use the gpt* labels to simplify mpc5200 dts files

Haren Myneni (6):
      powerpc: Move branch instruction from ACCOUNT_CPU_USER_ENTRY to caller
      powerpc: Enable PPR save/restore
      powerpc: Increase exceptions arrays in paca struct to save PPR
      powerpc: Define ppr in thread_struct
      powerpc: Macros for saving/restore PPR
      powerpc: Implement PPR save/restore

Harninder Rai (2):
      powerpc/85xx: bsc9131 - Correct typo in SDHC device node
      powerpc/85xx: l2sram - Add compatible string for BSC9131 platform

Holger Brunck (3):
      powerpc/82xx: fix checkpatch warnings for km82xx.c
      powerpc/83xx: fix checkpatch warnings for km83xx.c
      powerpc/83xx: update kmeter1_defconfig

Ian Munsie (10):
      powerpc: Define differences between doorbells on book3e and book3s
      powerpc: Add book3s hypervisor doorbell exception vectors
      powerpc: Add book3s privileged doorbell exception vectors
      powerpc: Select either privileged or hypervisor doorbell when sending
      powerpc: Add code to handle soft-disabled doorbells on server
      powerpc: Update Kconfig + Makefile to prepare for server doorbells
      powerpc: Hook up doorbells on server
      powerpc: Disable relocation on exceptions whenever PR KVM is active
      powerpc: Add helper functions set the DAWR and CIABR using set_mode
      powerpc: Add support for context switching the TAR register

Jason Gunthorpe (1):
      powerpc: Enable the Watchdog vector for 405

Jimi Xenidis (1):
      powerpc/kexec: Add kexec "hold" support for Book3e processors

Joe Perches (1):
      powerpc: Convert print_symbol to %pSR

Julia Lawall (1):
      arch/powerpc/platforms/85xx/p1022_ds.c: adjust duplicate test

Kim Phillips (4):
      powerpc/fsl: lbc: sparse fixes
      powerpc/fsl: fsl_soc: sparse fixes
      powerpc/fsl: ifc: sparse fixes
      powerpc/fsl: msi: sparse fixes

Li Zhong (3):
      powerpc: Fix a lazy irq related WARING in arch_local_irq_restore()
      powerpc: Fix MAX_STACK_TRACE_ENTRIES too low warning for ppc32
      powerpc: Avoid debug_smp_processor_id() check in SHARED_PROCESSOR

Michael Ellerman (2):
      powerpc: Add a powerpc implementation of SHA-1
      powerpc: Apply early paca fixups to boot_paca and the boot cpu's paca

Michael Neuling (32):
      powerpc/pseries: Allow firmware features to match partial strings
      powerpc/pseries: Cleanup best_energy_hcall detection
      powerpc: Remove extra zeros from 32 bit CPU features definitions
      powerpc: Repack 64bit CPU features to remove holes
      powerpc: Add DAWR CPU feature bit definition
      powerpc: Add DAWR/X SPR number definitions
      powerpc: Hardware breakpoints rewrite to handle non DABR breakpoint registers
      powerpc: Add the DAWR support to the set_break()
      powerpc/perf: Fix finding overflowed PMC in interrupt
      powerpc/perf: Fix for PMCs not making progress
      powerpc: Fix typo in breakpoint kgdb code.
      powerpc: Rename set_break to avoid naming conflict
      powerpc/ptrace: Make #defines for all request numbers hex
      powerpc: Add length setting to set_dawr
      powerpc: Change hardware breakpoint to allow longer ranges
      powerpc: Add new CPU feature bit for transactional memory
      powerpc: Add new instructions for transactional memory
      powerpc: Add additional state needed for transactional memory to thread struct
      powerpc: New macros for transactional memory support
      powerpc: Register defines for various transactional memory registers
      powerpc: Add transactional memory paca scratch register to show_regs
      powerpc: Add helper functions for transactional memory context switching
      powerpc: Add FP/VSX and VMX register load functions for transactional memory
      powerpc: Add reclaim and recheckpoint functions for context switching transactional memory processes
      powerpc: Add transactional memory unavaliable execption handler
      powerpc: Routines for FP/VSX/VMX unavailable during a transaction
      powerpc: Hook in new transactional memory code
      powerpc: Add new transactional memory state to the signal context
      powerpc: Add transactional memory to POWER8 cpu features
      powerpc: Add config option for transactional memory
      powerpc: Add transactional memory to pseries and ppc64 defconfigs
      powerpc: Documentation for transactional memory on powerpc

Nishanth Aravamudan (4):
      pseries/iommu: Fix iteration in DDW TCE clearrange
      pseries/iommu: Ensure TCEs are cleared with non-huge DDW
      pseries/iommu: Restore_default_window does not use liobn parameter
      pseries/iommu: Remove DDW on kexec

Olof Johansson (1):
      powerpc/pasemi: Enable PRINTK_TIME in defconfig

Paul Gortmaker (4):
      powerpc/85xx: split sbc8548 dts file into pre and post chunks
      powerpc/85xx: update sbc8548 flash information to match recent u-boot
      powerpc/85xx: add alternate dts file for sbc8548 boot via SODIMM
      powerpc/85xx: enable MTD options in sbc8548 defconfig

Paul Mackerras (4):
      powerpc: Remove Cell-specific relocation-on interrupt vector code
      powerpc: Save CFAR before branching in interrupt entry paths
      powerpc/kvm/book3s_hv: Preserve guest CFAR register value
      powerpc/kvm/book3s_pr: Fix compilation on 32-bit machines

Phileas Fogg (1):
      powerpc/kexec: Disable hard IRQ before kexec

Philippe De Muyter (1):
      powerpc, dma: move bestcomm driver from arch/powerpc/sysdev to drivers/dma

Po Liu (1):
      powerpc/85xx: dts - add ranges property for SEC

Scott Wood (4):
      powerpc/mpic: Make distribute_irqs obey MPIC_SINGLE_DEST_CPU
      powerpc/fsl: Remove CONFIG_IRQ_ALL_CPUS from mpc85xx/mpc86xx defconfig
      powerpc/mpic: allow coreint to be determined by MPIC version
      powerpc/e500/qemu-e500: enable coreint

Stef van Os (1):
      powerpc/85xx: Board support for ppa8548

Suzuki K. Poulose (1):
      uprobes/powerpc: Add dependency on single step emulation

Thadeu Lima de Souza Cascardo (3):
      powerpc/iommu: Prevent false TCE leak message
      powerpc/eeh/of: Checking for CONFIG_EEH is not needed
      powerpc/eeh: Fix crash when adding a device in a slot with DDW

Thomas Waldecker (1):
      Documentation/powerpc: Fix path to the powerpc directory

Timur Tabi (3):
      powerpc/85xx: describe the PAMU topology in the device tree
      powerpc/85xx: fix various PCI node compatible strings
      powerpc/fsl: remove extraneous DIU platform functions

Tushar Behera (1):
      powerpc/pseries/pci: Use NULL instead of 0 for pointers

Vakul Garg (1):
      crypto: caam - Added property fsl, sec-era in SEC4.0 device tree binding.

Varun Sethi (1):
      powerpc/fsl_pci: Store the pci ctlr device ptr in the pci ctlr struct

Vinh Nguyen Huu Tuong (1):
      powerpc/44x: Support OCM(On Chip Memory) for APM821xx SoC and Bluestone board

Wei Yongjun (5):
      powerpc/windfarm: Use for_each_node_by_type() macro
      tty/hvsi: Use for_each_compatible_node() macro
      powerpc/celleb: Use for_each_compatible_node() macro
      powerpc/82xx: Use for_each_compatible_node() macro
      powerpc/85xx: use for_each_compatible_node() macro

sukadev@linux.vnet.ibm.com (1):
      perf/Power: PERF_EVENT_IOC_ENABLE does not reenable event

 .../devicetree/bindings/crypto/fsl-sec4.txt        |   12 +-
 .../devicetree/bindings/powerpc/fsl/guts.txt       |   13 +-
 .../devicetree/bindings/powerpc/fsl/pamu.txt       |  140 +++++
 Documentation/powerpc/cpu_features.txt             |   10 +-
 Documentation/powerpc/transactional_memory.txt     |  175 ++++++
 arch/powerpc/Kconfig                               |   13 +
 arch/powerpc/Makefile                              |   22 +-
 arch/powerpc/boot/dts/a3m071.dts                   |    6 +-
 arch/powerpc/boot/dts/a4m072.dts                   |   27 +-
 arch/powerpc/boot/dts/bluestone.dts                |    8 +
 arch/powerpc/boot/dts/bsc9131rdb.dtsi              |    2 +-
 arch/powerpc/boot/dts/cm5200.dts                   |    6 +-
 arch/powerpc/boot/dts/digsy_mtc.dts                |   14 +-
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi        |    4 +-
 arch/powerpc/boot/dts/fsl/p1022si-post.dtsi        |    6 +-
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi        |   87 ++-
 arch/powerpc/boot/dts/fsl/p3041si-post.dtsi        |   87 ++-
 arch/powerpc/boot/dts/fsl/p4080si-post.dtsi        |   74 ++-
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |   92 ++-
 arch/powerpc/boot/dts/fsl/p5040si-post.dtsi        |   92 ++-
 arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi        |    1 +
 arch/powerpc/boot/dts/lite5200b.dts                |   23 +-
 arch/powerpc/boot/dts/media5200.dts                |    6 +-
 arch/powerpc/boot/dts/motionpro.dts                |   26 +-
 arch/powerpc/boot/dts/mpc5121.dtsi                 |  410 +++++++++++++
 arch/powerpc/boot/dts/mpc5121ads.dts               |  319 ++--------
 arch/powerpc/boot/dts/mpc5200b.dtsi                |   25 +-
 arch/powerpc/boot/dts/mucmc52.dts                  |   48 +-
 arch/powerpc/boot/dts/o2d.dtsi                     |   27 +-
 arch/powerpc/boot/dts/pcm030.dts                   |   48 +-
 arch/powerpc/boot/dts/pcm032.dts                   |   45 +-
 arch/powerpc/boot/dts/pdm360ng.dts                 |  273 +--------
 arch/powerpc/boot/dts/ppa8548.dts                  |  166 ++++++
 arch/powerpc/boot/dts/sbc8548-altflash.dts         |  115 ++++
 arch/powerpc/boot/dts/sbc8548-post.dtsi            |  295 +++++++++
 arch/powerpc/boot/dts/sbc8548-pre.dtsi             |   52 ++
 arch/powerpc/boot/dts/sbc8548.dts                  |  356 +----------
 arch/powerpc/boot/dts/uc101.dts                    |   52 +-
 arch/powerpc/boot/dts/virtex440-ml507.dts          |    6 +
 arch/powerpc/configs/83xx/kmeter1_defconfig        |    6 +-
 arch/powerpc/configs/85xx/ge_imp3a_defconfig       |    1 -
 arch/powerpc/configs/85xx/ppa8548_defconfig        |   65 ++
 arch/powerpc/configs/85xx/sbc8548_defconfig        |   19 +
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |    1 -
 arch/powerpc/configs/86xx/gef_sbc310_defconfig     |    1 -
 arch/powerpc/configs/86xx/gef_sbc610_defconfig     |    1 -
 arch/powerpc/configs/86xx/sbc8641d_defconfig       |    1 -
 arch/powerpc/configs/corenet32_smp_defconfig       |    1 -
 arch/powerpc/configs/corenet64_smp_defconfig       |    1 -
 arch/powerpc/configs/mpc85xx_smp_defconfig         |    1 -
 arch/powerpc/configs/pasemi_defconfig              |   31 +-
 arch/powerpc/configs/ppc64_defconfig               |  147 ++---
 arch/powerpc/configs/ppc64e_defconfig              |  107 +---
 arch/powerpc/configs/ps3_defconfig                 |   15 +-
 arch/powerpc/configs/pseries_defconfig             |   91 +--
 arch/powerpc/crypto/Makefile                       |    9 +
 arch/powerpc/crypto/sha1-powerpc-asm.S             |  179 ++++++
 arch/powerpc/crypto/sha1.c                         |  157 +++++
 arch/powerpc/include/asm/cputable.h                |  126 ++--
 arch/powerpc/include/asm/dbell.h                   |   30 +-
 arch/powerpc/include/asm/debug.h                   |   15 +-
 arch/powerpc/include/asm/eeh.h                     |    3 +
 arch/powerpc/include/asm/exception-64s.h           |  138 ++++-
 arch/powerpc/include/asm/firmware.h                |    3 +-
 arch/powerpc/include/asm/hvcall.h                  |    9 +
 arch/powerpc/include/asm/hw_breakpoint.h           |   35 +-
 arch/powerpc/include/asm/kvm_book3s_asm.h          |    3 +
 arch/powerpc/include/asm/kvm_host.h                |    1 +
 arch/powerpc/include/asm/machdep.h                 |    4 +
 arch/powerpc/include/asm/mpc5121.h                 |   17 +
 arch/powerpc/include/asm/paca.h                    |   10 +-
 arch/powerpc/include/asm/perf_event_server.h       |   10 +-
 arch/powerpc/include/asm/ppc-opcode.h              |   13 +
 arch/powerpc/include/asm/ppc4xx_ocm.h              |   45 ++
 arch/powerpc/include/asm/ppc_asm.h                 |  110 +++-
 arch/powerpc/include/asm/processor.h               |   48 +-
 arch/powerpc/include/asm/ps3.h                     |    2 +-
 arch/powerpc/include/asm/reg.h                     |   43 +-
 arch/powerpc/include/asm/sections.h                |    3 +
 arch/powerpc/include/asm/spinlock.h                |    2 +-
 arch/powerpc/include/asm/tm.h                      |   20 +
 arch/powerpc/include/uapi/asm/ptrace.h             |   29 +-
 arch/powerpc/kernel/Makefile                       |   10 +-
 arch/powerpc/kernel/asm-offsets.c                  |   34 ++
 arch/powerpc/kernel/cpu_setup_power.S              |    7 +
 arch/powerpc/kernel/dbell.c                        |    4 +-
 arch/powerpc/kernel/entry_64.S                     |   43 +-
 arch/powerpc/kernel/exceptions-64e.S               |    3 +-
 arch/powerpc/kernel/exceptions-64s.S               |  351 +++++++----
 arch/powerpc/kernel/fpu.S                          |   66 +++
 arch/powerpc/kernel/head_40x.S                     |   47 +-
 arch/powerpc/kernel/head_64.S                      |   34 +-
 arch/powerpc/kernel/hw_breakpoint.c                |   84 ++-
 arch/powerpc/kernel/iommu.c                        |    7 +
 arch/powerpc/kernel/irq.c                          |   11 +-
 arch/powerpc/kernel/kgdb.c                         |   10 +-
 arch/powerpc/kernel/machine_kexec_64.c             |    5 +
 arch/powerpc/kernel/module_64.c                    |   30 +
 arch/powerpc/kernel/of_platform.c                  |    7 +-
 arch/powerpc/kernel/paca.c                         |    2 -
 arch/powerpc/kernel/pci-common.c                   |    7 +-
 arch/powerpc/kernel/process.c                      |  241 +++++++-
 arch/powerpc/kernel/prom_init.c                    |  626 ++++++++++----------
 arch/powerpc/kernel/prom_init_check.sh             |    2 +-
 arch/powerpc/kernel/ptrace.c                       |   89 ++-
 arch/powerpc/kernel/ptrace32.c                     |    8 +-
 arch/powerpc/kernel/setup_64.c                     |   18 +-
 arch/powerpc/kernel/signal.c                       |    5 +-
 arch/powerpc/kernel/signal.h                       |    8 +
 arch/powerpc/kernel/signal_32.c                    |  500 +++++++++++++++-
 arch/powerpc/kernel/signal_64.c                    |  337 ++++++++++-
 arch/powerpc/kernel/smp.c                          |    2 +-
 arch/powerpc/kernel/tm.S                           |  388 ++++++++++++
 arch/powerpc/kernel/traps.c                        |  150 ++++-
 arch/powerpc/kernel/vector.S                       |   51 ++
 arch/powerpc/kernel/vmlinux.lds.S                  |    5 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |    9 +
 arch/powerpc/kvm/book3s_pr.c                       |   19 +
 arch/powerpc/lib/Makefile                          |    6 +-
 arch/powerpc/mm/Makefile                           |    2 +-
 arch/powerpc/mm/fault.c                            |    4 +-
 arch/powerpc/mm/hash_utils_64.c                    |   16 +
 arch/powerpc/mm/mem.c                              |   11 +-
 arch/powerpc/oprofile/Makefile                     |    2 +-
 arch/powerpc/perf/core-book3s.c                    |   93 ++-
 arch/powerpc/perf/e500-pmu.c                       |    2 +
 arch/powerpc/platforms/44x/Kconfig                 |    8 +
 arch/powerpc/platforms/512x/clock.c                |   34 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c       |   37 +-
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |    6 +-
 arch/powerpc/platforms/82xx/km82xx.c               |    6 +-
 arch/powerpc/platforms/82xx/pq2.c                  |    4 +-
 arch/powerpc/platforms/83xx/km83xx.c               |  161 ++---
 arch/powerpc/platforms/85xx/Kconfig                |   15 +
 arch/powerpc/platforms/85xx/Makefile               |    2 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    4 +-
 arch/powerpc/platforms/85xx/p1022_ds.c             |   40 +-
 arch/powerpc/platforms/85xx/p1022_rdk.c            |   12 -
 arch/powerpc/platforms/85xx/ppa8548.c              |   98 +++
 arch/powerpc/platforms/85xx/qemu_e500.c            |    7 +-
 arch/powerpc/platforms/85xx/sgy_cts1000.c          |  176 ++++++
 arch/powerpc/platforms/Kconfig                     |    2 -
 arch/powerpc/platforms/Kconfig.cputype             |    6 +
 arch/powerpc/platforms/cell/celleb_scc_sio.c       |    5 +-
 arch/powerpc/platforms/cell/spu_callbacks.c        |   13 +-
 arch/powerpc/platforms/ps3/htab.c                  |   14 +-
 arch/powerpc/platforms/pseries/Kconfig             |    1 +
 arch/powerpc/platforms/pseries/Makefile            |    2 +-
 arch/powerpc/platforms/pseries/eeh.c               |   24 +-
 arch/powerpc/platforms/pseries/firmware.c          |   21 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |    8 +
 arch/powerpc/platforms/pseries/iommu.c             |  104 ++--
 arch/powerpc/platforms/pseries/pci.c               |    3 +-
 arch/powerpc/platforms/pseries/plpar_wrappers.h    |   18 +
 arch/powerpc/platforms/pseries/pseries_energy.c    |   37 +-
 arch/powerpc/platforms/pseries/setup.c             |   20 +-
 arch/powerpc/platforms/pseries/smp.c               |   33 +-
 arch/powerpc/platforms/wsp/Makefile                |    2 +-
 arch/powerpc/sysdev/Makefile                       |    4 +-
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c              |    1 +
 arch/powerpc/sysdev/fsl_ifc.c                      |    2 +-
 arch/powerpc/sysdev/fsl_lbc.c                      |    6 +-
 arch/powerpc/sysdev/fsl_msi.c                      |    4 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   24 +-
 arch/powerpc/sysdev/fsl_pci.h                      |    2 +-
 arch/powerpc/sysdev/fsl_soc.c                      |    4 +-
 arch/powerpc/sysdev/mpc5xxx_clocks.c               |    4 +-
 arch/powerpc/sysdev/mpic.c                         |   28 +-
 arch/powerpc/sysdev/ppc4xx_ocm.c                   |  415 +++++++++++++
 arch/powerpc/sysdev/xics/ics-rtas.c                |    2 +-
 arch/powerpc/xmon/Makefile                         |    2 +-
 arch/powerpc/xmon/xmon.c                           |   21 +-
 crypto/Kconfig                                     |    7 +
 drivers/Makefile                                   |    2 +-
 drivers/ata/pata_mpc52xx.c                         |    6 +-
 drivers/dma/Kconfig                                |    2 +
 drivers/dma/Makefile                               |    1 +
 .../sysdev => drivers/dma}/bestcomm/Kconfig        |    0
 .../sysdev => drivers/dma}/bestcomm/Makefile       |    0
 .../powerpc/sysdev => drivers/dma}/bestcomm/ata.c  |    6 +-
 .../dma}/bestcomm/bcom_ata_task.c                  |    0
 .../dma}/bestcomm/bcom_fec_rx_task.c               |    0
 .../dma}/bestcomm/bcom_fec_tx_task.c               |    0
 .../dma}/bestcomm/bcom_gen_bd_rx_task.c            |    0
 .../dma}/bestcomm/bcom_gen_bd_tx_task.c            |    0
 .../sysdev => drivers/dma}/bestcomm/bestcomm.c     |    6 +-
 .../powerpc/sysdev => drivers/dma}/bestcomm/fec.c  |    6 +-
 .../sysdev => drivers/dma}/bestcomm/gen_bd.c       |    6 +-
 .../powerpc/sysdev => drivers/dma}/bestcomm/sram.c |    2 +-
 drivers/macintosh/windfarm_pm112.c                 |    2 +-
 drivers/macintosh/windfarm_pm72.c                  |    2 +-
 drivers/macintosh/windfarm_rm31.c                  |    2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |    4 +-
 drivers/tty/hvc/hvsi.c                             |    4 +-
 drivers/video/fsl-diu-fb.c                         |   64 +-
 .../sysdev => include/linux/fsl}/bestcomm/ata.h    |    0
 .../linux/fsl}/bestcomm/bestcomm.h                 |    0
 .../linux/fsl}/bestcomm/bestcomm_priv.h            |    0
 .../sysdev => include/linux/fsl}/bestcomm/fec.h    |    0
 .../sysdev => include/linux/fsl}/bestcomm/gen_bd.h |    0
 .../sysdev => include/linux/fsl}/bestcomm/sram.h   |    0
 sound/soc/fsl/mpc5200_dma.c                        |    4 +-
 202 files changed, 7076 insertions(+), 2584 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/pamu.txt
 create mode 100644 Documentation/powerpc/transactional_memory.txt
 create mode 100644 arch/powerpc/boot/dts/mpc5121.dtsi
 create mode 100644 arch/powerpc/boot/dts/ppa8548.dts
 create mode 100644 arch/powerpc/boot/dts/sbc8548-altflash.dts
 create mode 100644 arch/powerpc/boot/dts/sbc8548-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/sbc8548-pre.dtsi
 create mode 100644 arch/powerpc/configs/85xx/ppa8548_defconfig
 create mode 100644 arch/powerpc/crypto/Makefile
 create mode 100644 arch/powerpc/crypto/sha1-powerpc-asm.S
 create mode 100644 arch/powerpc/crypto/sha1.c
 create mode 100644 arch/powerpc/include/asm/ppc4xx_ocm.h
 create mode 100644 arch/powerpc/include/asm/tm.h
 create mode 100644 arch/powerpc/kernel/tm.S
 create mode 100644 arch/powerpc/platforms/85xx/ppa8548.c
 create mode 100644 arch/powerpc/platforms/85xx/sgy_cts1000.c
 create mode 100644 arch/powerpc/sysdev/ppc4xx_ocm.c
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/Kconfig (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/Makefile (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/ata.c (97%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_ata_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_fec_rx_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_fec_tx_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_gen_bd_rx_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_gen_bd_tx_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bestcomm.c (99%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/fec.c (98%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/gen_bd.c (98%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/sram.c (99%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/ata.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/bestcomm.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/bestcomm_priv.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/fec.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/gen_bd.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/sram.h (100%)


