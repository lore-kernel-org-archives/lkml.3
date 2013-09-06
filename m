Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab3IFCYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 22:24:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:35524 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab3IFCYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 22:24:44 -0400
Message-ID: <1378434264.4321.209.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 06 Sep 2013 12:24:24 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the powerpc batch for this merge window. Some of the highlights are:

 * A bunch of endian fixes ! We don't have full LE support yet in that
release but this contains a lot of fixes all over arch/powerpc to use the
proper accessors, call the firmware with the right endian mode, etc...

 * A few updates to our "powernv" platform (non-virtualized, the one
to run KVM on), among other, support for bridging the P8 LPC bus for UARTs,
support and some EEH fixes.
 
 * Some mpc51xx clock API cleanups in preparation for a clock API overhaul

 * A pile of cleanups of our old math emulation code, including better
support for using it to emulate optional FP instructions on embedded
chips that otherwise have a HW FPU.

 * Some infrastructure in selftest, for powerpc now, but could be generalized,
initially used by some tests for our perf instruction counting code.

 * A pile of fixes for hotplug on pseries (that was seriously bitrotting)

 * The usual slew of freescale embedded updates, new boards, 64-bit hiberation
support, e6500 core PMU support, etc...

Cheers,
Ben.

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 9f24b0c9ef9b6b1292579c9e2cd7ff07ddc372b7:

  powerpc: Correct FSCR bit definitions (2013-09-05 17:29:20 +1000)

----------------------------------------------------------------
Alistair Popple (4):
      powerpc: More little endian fixes for prom.c
      powerpc: More little endian fixes for setup-common.c
      powerpc: Little endian fixes for legacy_serial.c
      powerpc: Make NUMA device node code endian safe

Andy Fleming (2):
      powerpc: Add smp_generic_cpu_bootable
      powerpc: Convert platforms to smp_generic_cpu_bootable

Anton Blanchard (29):
      powerpc: Align p_toc
      powerpc: Handle unaligned ldbrx/stdbrx
      powerpc: Wrap MSR macros with parentheses
      powerpc: Remove SAVE_VSRU and REST_VSRU macros
      powerpc: Simplify logic in include/uapi/asm/elf.h
      powerpc/pseries: Simplify H_GET_TERM_CHAR
      powerpc: Fix a number of sparse warnings
      powerpc/pci: Don't use bitfield for force_32bit_msi
      powerpc: Stop using non-architected shared_proc field in lppaca
      powerpc: Make RTAS device tree accesses endian safe
      powerpc: Make cache info device tree accesses endian safe
      powerpc: Make RTAS calls endian safe
      powerpc: Make logical to real cpu mapping code endian safe
      powerpc: Add some endian annotations to time and xics code
      powerpc: Fix some endian issues in xics code
      powerpc: of_parse_dma_window should take a __be32 *dma_window
      powerpc: Make device tree accesses in cache info code endian safe
      powerpc: Make device tree accesses in HVC VIO console endian safe
      powerpc: Make device tree accesses in VIO subsystem endian safe
      powerpc: Make OF PCI device tree accesses endian safe
      powerpc: Make PCI device node device tree accesses endian safe
      powerpc: Add endian annotations to lppaca, slb_shadow and dtl_entry
      powerpc: Fix little endian lppaca, slb_shadow and dtl_entry
      powerpc: Emulate instructions in little endian mode
      powerpc: Little endian SMP IPI demux
      powerpc/pseries: Fix endian issues in H_GET_TERM_CHAR/H_PUT_TERM_CHAR
      powerpc: Fix little endian coredumps
      powerpc: Make rwlocks endian safe
      powerpc: Never handle VSX alignment exceptions from kernel

Benjamin Herrenschmidt (21):
      Merge remote-tracking branch 'scott/next' into next
      powerpc/pmac: Early debug output on screen on 64-bit macs
      powerpc: Better split CONFIG_PPC_INDIRECT_PIO and CONFIG_PPC_INDIRECT_MMIO
      powerpc/powernv: Update opal.h to add new LPC and XSCOM functions
      powerpc/powernv: Add helper to get ibm,chip-id of a node
      powerpc/powernv: Add PIO accessors for Power8 LPC bus
      powerpc: Cleanup udbg_16550 and add support for LPC PIO-only UARTs
      powerpc: Check "status" property before adding legacy ISA serial ports
      powerpc/powernv: Don't crash if there are no OPAL consoles
      powerpc/powernv: Enable detection of legacy UARTs
      Revert "powerpc/e500: Update compilation flags with core specific options"
      powerpc: Make prom_init.c endian safe
      powerpc/wsp: Fix early debug build
      Merge remote-tracking branch 'scott/next' into next
      Merge branch 'merge' into next
      powerpc/btext: Fix CONFIG_PPC_EARLY_DEBUG_BOOTX on ppc32
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor
      powerpc/powernv: Return secondary CPUs to firmware on kexec
      Merge branch 'merge' into next
      powerpc/pseries: Move lparcfg.c to platforms/pseries
      Merge remote-tracking branch 'agust/next' into next

Catalin Udma (2):
      powerpc/perf: increase the perf HW events to 6
      powerpc/e500: Update compilation flags with core specific options

Chunhe Lan (1):
      powerpc/85xx: Add P1023RDB board support

Deepthi Dharwar (2):
      pseries/cpuidle: Remove dependency of pseries.h file
      pseries: Move plpar_wrapper.h to powerpc common include/asm location.

Dongsheng Wang (1):
      powerpc/mpc85xx: invalidate TLB after hibernation resume

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Gavin Shan (5):
      powerpc/powernv: Free PHB instance upon error
      powerpc/powernv: Fetch PHB bus range from dev-tree
      powerpc/powernv: Check primary PHB through ID
      powerpc/powernv: Needn't IO segment map for PHB3
      powerpc/pci: Remove duplicate check in pcibios_fixup_bus()

Gerhard Sittig (6):
      serial: mpc512x: cleanup clock API use
      USB: fsl-mph-dr-of: cleanup clock API use
      mtd: mpc5121_nfc: cleanup clock API use
      fsl-viu: cleanup clock API use
      powerpc: mpc512x: array decl for MCLK registers in CCM
      dts: mpc512x: prepare for preprocessor support

Haijun.Zhang (3):
      powerpc/85xx: add P1020RDB-PD platform support
      powerpc/85xx: add the P1020RDB-PD DTS support
      powerpc/85xx: Add support for 85xx cpu type detection

Hongtao Jia (3):
      powerpc: Move opcode definitions from kvm/emulate.c to asm/ppc-opcode.h
      powerpc/85xx: Add machine check handler to fix PCIe erratum on mpc85xx
      powerpc/msi: Fix compile error on mpc83xx

Ian Campbell (1):
      powerpc/fsl-booke: Rename b4qds.dts -> b4qds.dtsi.

Ian Munsie (1):
      powerpc: Make prom.c device tree accesses endian safe

James Yang (1):
      powerpc/math-emu: Fix load/store indexed emulation

Jingoo Han (1):
      macintosh/ams: Replace strict_strtoul() with kstrtoul()

Kevin Hao (16):
      powerpc/mpc85xx: remove the unneeded pci init functions for corenet ds board
      powerpc/fsl-pci: fix the unreachable warning message
      powerpc/fsl-pci: enable SWIOTLB in function setup_pci_atmu
      powerpc: Move the testing of CPU_FTR_COHERENT_ICACHE into __flush_icache_range
      powerpc: Remove the symbol __flush_icache_range
      powerpc/math-emu: Remove the dead code in math.c
      powerpc/math-emu: Remove the unneeded check for CONFIG_MATH_EMULATION in math.c
      powerpc/85xx: Enable the math emulation for the corenet64_smp_defconfig
      powerpc/math-emu: Move the flush FPU state function into do_mathemu
      powerpc: Introduce function emulate_math()
      powerpc: split She math emulation into two parts
      powerpc: remove the unused function disable_kernel_fp()
      powerpc/mpc85xx: Only emulate the unimplemented FP instructions on corenet64
      powerpc: Remove the redundant flush_fp_to_thread() in setup_sigcontext()
      powerpc: Make flush_fp_to_thread() nop when CONFIG_PPC_FPU is disabled
      powerpc: Remove the empty giveup_fpu() function on 32bit kernel

Laurentiu TUDOR (1):
      powerpc/85xx: Move ePAPR paravirt initialization earlier

Lijun Pan (2):
      powerpc/perf: correct typos in counter enumeration
      powerpc/perf: add 2 additional performance monitor counters for e6500 core

Mark Brown (1):
      powerpc: Ignore zImage.epapr

Michael Ellerman (9):
      selftests: Add infrastructure for powerpc selftests
      selftests: Add support files for powerpc tests
      selftests: Add test of PMU instruction counting on powerpc
      powerpc: Update the 00-Index in Documentation/powerpc
      powerpc/pseries: Add a warning in the case of cross-cpu VPA registration
      powerpc: Add more trap names to xmon
      powerpc: Fix location and rename exception trampolines
      powerpc: Add more exception trampolines for hypervisor exceptions
      powerpc: Skip emulating & leave interrupts off for kernel program checks

Michael Neuling (2):
      powerpc: Avoid link stack corruption for MMU on exceptions
      powerpc: Cleanup handling of the DSCR bit in the FSCR register

Mike Qiu (1):
      powerpc/eeh: powerpc/eeh: Fix undefined variable

Minghuan Lian (3):
      powerpc/dts: update MSI bindings doc for MPIC v4.3
      powerpc/dts: add MPIC v4.3 dts node
      powerpc/fsl_msi: add MSIIR1 support for MPIC v4.3

Mingkai Hu (3):
      powerpc/85xx: Add SEC6.0 device tree
      powerpc/85xx: Add silicon device tree for C293
      powerpc/85xx: Add C293PCIE board support

Nathan Fontenot (1):
      powerpc/mm: Mark Memory Resources as busy

Paul Bolle (1):
      powerpc/8xx: Remove last traces of 8XX_MINIMAL_FPEMU

Paul Mackerras (8):
      powerpc: Implement __get_user_pages_fast()
      powerpc: Fix VRSAVE handling
      powerpc: Fix denormalized exception handler
      powerpc: Pull out cpu_core_mask updates into a separate function
      powerpc: Use ibm, chip-id property to compute cpu_core_mask if available
      powerpc: Work around gcc miscompilation of __pa() on 64-bit
      powerpc/xmon: Fix printing of set of CPUs in xmon
      powerpc: Correct FSCR bit definitions

Priyanka Jain (1):
      powerpc/perf: Add e6500 PMU driver

Scott Wood (5):
      powerpc/fsl-booke: Work around erratum A-006958
      powerpc: Convert some mftb/mftbu into mfspr
      powerpc/85xx: Remove -Wa,-me500
      powerpc/booke64: Use appropriate -mcpu
      powerpc/e500: Set -mcpu flag for 32-bit e500

Sebastian Siewior (1):
      powerpc: 52xx: provide a default in mpc52xx_irqhost_map()

Tiejun Chen (1):
      powerpc/ppc64: Rename SOFT_DISABLE_INTS with RECONCILE_IRQ_STATE

Tom Musta (1):
      powerpc: Unaligned stores and stmw are broken in emulation code

Tyrel Datwyler (8):
      powerpc/pseries: Fix creation of loop in device node property list
      powerpc/pseries: Fix over writing of rtas return code in update_dt_node
      powerpc/pseries: Pack update_props_workarea to map correctly to rtas buffer header
      powerpc/pseries: Fix parsing of initial node path in update_dt_node
      powerpc/pseries: Do all node initialization in dlpar_parse_cc_node
      powerpc/pseries: Make dlpar_configure_connector parent node aware
      powerpc/pseries: Add mising of_node_put in delete_dt_node
      powerpc/pseries: Child nodes are not detached by dlpar_detach_node

Vasant Hegde (1):
      powerpc: Make chip-id information available to userspace

Wang Dongsheng (1):
      powerpc: add Book E support to 64-bit hibernation

Wei Yongjun (1):
      powerpc/fsl_msi: fix error return code in fsl_of_msi_probe()

Yuanquan Chen (1):
      powerpc/pci: fix PCI-e check link issue

Zhenhua Luo (1):
      powerpc/fsl: Enable CONFIG_DEVTMPFS_MOUNT so /dev can be mounted correctly

 .../devicetree/bindings/crypto/fsl-sec6.txt        | 157 +++++++++
 .../devicetree/bindings/powerpc/fsl/msi-pic.txt    |  53 ++-
 Documentation/powerpc/00-INDEX                     |  11 +
 arch/powerpc/Kconfig                               |  21 ++
 arch/powerpc/Makefile                              |  18 +-
 arch/powerpc/boot/.gitignore                       |   1 +
 arch/powerpc/boot/dts/ac14xx.dts                   |   2 +-
 arch/powerpc/boot/dts/b4420qds.dts                 |   2 +-
 arch/powerpc/boot/dts/b4860qds.dts                 |   2 +-
 arch/powerpc/boot/dts/{b4qds.dts => b4qds.dtsi}    |   0
 arch/powerpc/boot/dts/c293pcie.dts                 | 223 +++++++++++++
 arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |   2 +-
 arch/powerpc/boot/dts/fsl/c293si-post.dtsi         | 193 +++++++++++
 arch/powerpc/boot/dts/fsl/c293si-pre.dtsi          |  63 ++++
 arch/powerpc/boot/dts/fsl/qoriq-mpic4.3.dtsi       | 149 +++++++++
 arch/powerpc/boot/dts/fsl/qoriq-sec6.0-0.dtsi      |  56 ++++
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |   2 +-
 arch/powerpc/boot/dts/include/dt-bindings          |   1 +
 arch/powerpc/boot/dts/mpc5121ads.dts               |   2 +-
 arch/powerpc/boot/dts/p1020rdb-pd.dts              | 280 ++++++++++++++++
 arch/powerpc/boot/dts/p1023rdb.dts                 | 234 +++++++++++++
 arch/powerpc/boot/dts/pdm360ng.dts                 |   2 +-
 arch/powerpc/boot/ppc_asm.h                        |   3 +
 arch/powerpc/boot/util.S                           |  10 +-
 .../85xx/{p1023rds_defconfig => p1023_defconfig}   |  25 +-
 arch/powerpc/configs/corenet32_smp_defconfig       |   1 +
 arch/powerpc/configs/corenet64_smp_defconfig       |   3 +
 arch/powerpc/configs/mpc83xx_defconfig             |   1 +
 arch/powerpc/configs/mpc85xx_defconfig             |   2 +
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   2 +
 arch/powerpc/include/asm/asm-compat.h              |   9 +
 arch/powerpc/include/asm/btext.h                   |   1 +
 arch/powerpc/include/asm/cacheflush.h              |   8 +-
 arch/powerpc/include/asm/cputable.h                |   9 +-
 arch/powerpc/include/asm/emulated_ops.h            |   2 -
 arch/powerpc/include/asm/epapr_hcalls.h            |   6 +
 arch/powerpc/include/asm/exception-64s.h           |  35 +-
 arch/powerpc/include/asm/io.h                      |  33 +-
 arch/powerpc/include/asm/irqflags.h                |   7 +-
 arch/powerpc/include/asm/lppaca.h                  |  68 ++--
 arch/powerpc/include/asm/mpc5121.h                 |  18 +-
 arch/powerpc/include/asm/mpc85xx.h                 |  92 +++++
 arch/powerpc/include/asm/mpic.h                    |   7 +
 arch/powerpc/include/asm/opal.h                    |  27 ++
 arch/powerpc/include/asm/paca.h                    |  11 +-
 arch/powerpc/include/asm/page.h                    |  10 +
 arch/powerpc/include/asm/pci-bridge.h              |   2 +-
 arch/powerpc/include/asm/perf_event_fsl_emb.h      |   2 +-
 .../pseries => include/asm}/plpar_wrappers.h       |  30 +-
 arch/powerpc/include/asm/ppc-opcode.h              |  47 +++
 arch/powerpc/include/asm/ppc_asm.h                 |  22 +-
 arch/powerpc/include/asm/prom.h                    |   7 +-
 arch/powerpc/include/asm/reg.h                     |  29 +-
 arch/powerpc/include/asm/reg_booke.h               |   8 +-
 arch/powerpc/include/asm/reg_fsl_emb.h             |  24 +-
 arch/powerpc/include/asm/rtas.h                    |   8 +-
 arch/powerpc/include/asm/smp.h                     |   3 +
 arch/powerpc/include/asm/spinlock.h                |   6 +-
 arch/powerpc/include/asm/switch_to.h               |  11 +-
 arch/powerpc/include/asm/timex.h                   |   4 +-
 arch/powerpc/include/asm/topology.h                |   1 +
 arch/powerpc/include/asm/udbg.h                    |   9 +-
 arch/powerpc/include/uapi/asm/elf.h                |  21 +-
 arch/powerpc/kernel/Makefile                       |   5 +-
 arch/powerpc/kernel/align.c                        |  14 +
 arch/powerpc/kernel/btext.c                        | 254 +++++++-------
 arch/powerpc/kernel/cacheinfo.c                    |  12 +-
 arch/powerpc/kernel/cpu_setup_fsl_booke.S          |   2 +-
 arch/powerpc/kernel/cputable.c                     |   2 +-
 arch/powerpc/kernel/entry_64.S                     |  46 +--
 arch/powerpc/kernel/epapr_paravirt.c               |  28 +-
 arch/powerpc/kernel/exceptions-64e.S               |   4 +-
 arch/powerpc/kernel/exceptions-64s.S               |  39 ++-
 arch/powerpc/kernel/head_40x.S                     |   8 -
 arch/powerpc/kernel/head_44x.S                     |  10 -
 arch/powerpc/kernel/head_64.S                      |   1 +
 arch/powerpc/kernel/head_8xx.S                     |   4 -
 arch/powerpc/kernel/head_fsl_booke.S               |  10 -
 arch/powerpc/kernel/io-workarounds.c               |  19 +-
 arch/powerpc/kernel/io.c                           |   3 +
 arch/powerpc/kernel/legacy_serial.c                |  62 ++--
 arch/powerpc/kernel/misc_32.S                      |   3 +-
 arch/powerpc/kernel/misc_64.S                      |  50 ++-
 arch/powerpc/kernel/paca.c                         |  10 +-
 arch/powerpc/kernel/pci-common.c                   |  13 +-
 arch/powerpc/kernel/pci_64.c                       |   4 +-
 arch/powerpc/kernel/pci_dn.c                       |  20 +-
 arch/powerpc/kernel/pci_of_scan.c                  |  23 +-
 arch/powerpc/kernel/ppc_ksyms.c                    |   3 +-
 arch/powerpc/kernel/process.c                      |   2 +
 arch/powerpc/kernel/prom.c                         |  90 +++--
 arch/powerpc/kernel/prom_init.c                    | 269 +++++++++------
 arch/powerpc/kernel/prom_init_check.sh             |   3 +-
 arch/powerpc/kernel/prom_parse.c                   |  17 +-
 arch/powerpc/kernel/rtas.c                         |  66 ++--
 arch/powerpc/kernel/setup-common.c                 |  13 +-
 arch/powerpc/kernel/setup_32.c                     |   4 +-
 arch/powerpc/kernel/setup_64.c                     |  36 +-
 arch/powerpc/kernel/signal_32.c                    |   9 +
 arch/powerpc/kernel/signal_64.c                    |  18 +-
 arch/powerpc/kernel/smp.c                          | 156 ++++++---
 arch/powerpc/kernel/softemu8xx.c                   | 199 -----------
 arch/powerpc/kernel/swsusp_asm64.S                 |  45 ++-
 arch/powerpc/kernel/swsusp_booke.S                 |   8 +
 arch/powerpc/kernel/time.c                         |  18 +-
 arch/powerpc/kernel/tm.S                           |   4 +-
 arch/powerpc/kernel/traps.c                        | 111 +++----
 arch/powerpc/kernel/udbg_16550.c                   | 370 +++++++++------------
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   6 +-
 arch/powerpc/kernel/vio.c                          |  33 +-
 arch/powerpc/kvm/book3s_64_slb.S                   |   4 +
 arch/powerpc/kvm/book3s_hv.c                       |   2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |   4 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  12 +
 arch/powerpc/kvm/emulate.c                         |  45 +--
 arch/powerpc/lib/locks.c                           |   4 +-
 arch/powerpc/lib/sstep.c                           |   8 +-
 arch/powerpc/math-emu/Makefile                     |  24 +-
 arch/powerpc/math-emu/math.c                       |  89 ++---
 arch/powerpc/mm/fault.c                            |   6 +-
 arch/powerpc/mm/gup.c                              |  37 ++-
 arch/powerpc/mm/hash_utils_64.c                    |   2 +-
 arch/powerpc/mm/mem.c                              |   2 +-
 arch/powerpc/mm/numa.c                             | 102 +++---
 arch/powerpc/mm/slb.c                              |   9 +-
 arch/powerpc/mm/subpage-prot.c                     |   4 +-
 arch/powerpc/oprofile/op_model_fsl_emb.c           |  30 ++
 arch/powerpc/perf/Makefile                         |   2 +-
 arch/powerpc/perf/core-book3s.c                    |   2 +-
 arch/powerpc/perf/core-fsl-emb.c                   |  30 ++
 arch/powerpc/perf/e6500-pmu.c                      | 121 +++++++
 arch/powerpc/platforms/52xx/mpc52xx_pic.c          |   3 +-
 arch/powerpc/platforms/85xx/Kconfig                |  10 +-
 arch/powerpc/platforms/85xx/Makefile               |   1 +
 arch/powerpc/platforms/85xx/c293pcie.c             |  75 +++++
 arch/powerpc/platforms/85xx/corenet_ds.c           |   6 -
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |  22 ++
 arch/powerpc/platforms/85xx/p1023_rds.c            |  24 +-
 arch/powerpc/platforms/85xx/smp.c                  |  26 ++
 arch/powerpc/platforms/Kconfig                     |   7 +-
 arch/powerpc/platforms/Kconfig.cputype             |  13 +
 arch/powerpc/platforms/cell/iommu.c                |   2 +-
 arch/powerpc/platforms/cell/smp.c                  |  15 +-
 arch/powerpc/platforms/powernv/Kconfig             |   2 +
 arch/powerpc/platforms/powernv/Makefile            |   2 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c          |  22 +-
 arch/powerpc/platforms/powernv/opal-lpc.c          | 203 +++++++++++
 arch/powerpc/platforms/powernv/opal-wrappers.S     |   5 +
 arch/powerpc/platforms/powernv/opal.c              |  18 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  47 ++-
 arch/powerpc/platforms/powernv/powernv.h           |   2 +
 arch/powerpc/platforms/powernv/setup.c             |  17 +
 arch/powerpc/platforms/powernv/smp.c               |  18 +-
 arch/powerpc/platforms/pseries/Makefile            |   1 +
 arch/powerpc/platforms/pseries/cmm.c               |   3 +-
 arch/powerpc/platforms/pseries/dlpar.c             |  67 ++--
 arch/powerpc/platforms/pseries/dtl.c               |   5 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   7 +-
 arch/powerpc/platforms/pseries/hvconsole.c         |  19 +-
 arch/powerpc/platforms/pseries/iommu.c             |  11 +-
 arch/powerpc/platforms/pseries/kexec.c             |   2 +-
 arch/powerpc/platforms/pseries/lpar.c              |  12 +-
 .../{kernel => platforms/pseries}/lparcfg.c        |  36 +-
 arch/powerpc/platforms/pseries/mobility.c          |  45 ++-
 arch/powerpc/platforms/pseries/processor_idle.c    |  12 +-
 arch/powerpc/platforms/pseries/pseries.h           |   5 +-
 arch/powerpc/platforms/pseries/pseries_energy.c    |   4 +-
 arch/powerpc/platforms/pseries/setup.c             |   6 +-
 arch/powerpc/platforms/pseries/smp.c               |  20 +-
 arch/powerpc/platforms/wsp/wsp.h                   |   1 -
 arch/powerpc/sysdev/fsl_msi.c                      | 137 +++++---
 arch/powerpc/sysdev/fsl_msi.h                      |  10 +-
 arch/powerpc/sysdev/fsl_pci.c                      | 184 ++++++++--
 arch/powerpc/sysdev/fsl_pci.h                      |   6 +
 arch/powerpc/sysdev/xics/icp-native.c              |   2 +-
 arch/powerpc/sysdev/xics/xics-common.c             |  10 +-
 arch/powerpc/xmon/xmon.c                           |  31 +-
 drivers/macintosh/ams/ams-input.c                  |   6 +-
 drivers/media/platform/fsl-viu.c                   |  23 +-
 drivers/mtd/nand/mpc5121_nfc.c                     |  21 +-
 drivers/tty/hvc/hvc_vio.c                          |   4 +-
 drivers/tty/hvc/hvsi_lib.c                         |   4 +-
 drivers/tty/serial/mpc52xx_uart.c                  |  98 +++++-
 drivers/usb/host/fsl-mph-dr-of.c                   |  16 +-
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/powerpc/Makefile           |  39 +++
 tools/testing/selftests/powerpc/harness.c          | 105 ++++++
 tools/testing/selftests/powerpc/pmu/Makefile       |  23 ++
 .../selftests/powerpc/pmu/count_instructions.c     | 135 ++++++++
 tools/testing/selftests/powerpc/pmu/event.c        | 105 ++++++
 tools/testing/selftests/powerpc/pmu/event.h        |  39 +++
 tools/testing/selftests/powerpc/pmu/loop.S         |  46 +++
 tools/testing/selftests/powerpc/subunit.h          |  47 +++
 tools/testing/selftests/powerpc/utils.h            |  34 ++
 194 files changed, 4899 insertions(+), 1786 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl-sec6.txt
 rename arch/powerpc/boot/dts/{b4qds.dts => b4qds.dtsi} (100%)
 create mode 100644 arch/powerpc/boot/dts/c293pcie.dts
 create mode 100644 arch/powerpc/boot/dts/fsl/c293si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/c293si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-mpic4.3.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sec6.0-0.dtsi
 create mode 120000 arch/powerpc/boot/dts/include/dt-bindings
 create mode 100644 arch/powerpc/boot/dts/p1020rdb-pd.dts
 create mode 100644 arch/powerpc/boot/dts/p1023rdb.dts
 rename arch/powerpc/configs/85xx/{p1023rds_defconfig => p1023_defconfig} (87%)
 create mode 100644 arch/powerpc/include/asm/mpc85xx.h
 rename arch/powerpc/{platforms/pseries => include/asm}/plpar_wrappers.h (90%)
 delete mode 100644 arch/powerpc/kernel/softemu8xx.c
 create mode 100644 arch/powerpc/perf/e6500-pmu.c
 create mode 100644 arch/powerpc/platforms/85xx/c293pcie.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-lpc.c
 rename arch/powerpc/{kernel => platforms/pseries}/lparcfg.c (96%)
 create mode 100644 tools/testing/selftests/powerpc/Makefile
 create mode 100644 tools/testing/selftests/powerpc/harness.c
 create mode 100644 tools/testing/selftests/powerpc/pmu/Makefile
 create mode 100644 tools/testing/selftests/powerpc/pmu/count_instructions.c
 create mode 100644 tools/testing/selftests/powerpc/pmu/event.c
 create mode 100644 tools/testing/selftests/powerpc/pmu/event.h
 create mode 100644 tools/testing/selftests/powerpc/pmu/loop.S
 create mode 100644 tools/testing/selftests/powerpc/subunit.h
 create mode 100644 tools/testing/selftests/powerpc/utils.h


