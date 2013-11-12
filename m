Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3KLAcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:32:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:42903 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab3KLAcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:32:09 -0500
Message-ID: <1384216311.4776.299.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:31:51 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Now that you've proven that even a typhoon can't get you, let's start
throwing code at you again !

The bulk of this is LE updates. One should now be able to build an
LE kernel and even run some things in it.

I'm still sitting on a handful of patches to enable the new ABI that
I *might* still send this merge window around, but due to the
incertainty (they are pretty fresh) I want to keep them separate.

Other notable changes are some infrastructure bits to better handle
PCI pass-through under KVM, some bits and pieces added to the new
PowerNV platform support such as access to the CPU SCOM bus via sysfs,
and support for EEH error handling on PHB3 (Power8 PCIe).

We also grew arch_get_random_long() for both pseries and powernv when
running on P7+ and P8, exploiting the HW rng.

And finally various embedded updates from freescale.

Cheers,
Ben.

The following changes since commit 8b5ede69d24db939f52b47effff2f6fe1e83e08b:

  powerpc/irq: Don't switch to irq stack from softirq stack (2013-10-07 14:19:39 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 0c4888ef1d8a8b82c29075ce7e257ff795af15c7:

  powerpc: Fix fatal SLB miss when restoring PPR (2013-11-06 14:13:53 +1100)

----------------------------------------------------------------
Alexey Kardashevskiy (3):
      hashtable: add hash_for_each_possible_rcu_notrace()
      powerpc: Prepare to support kernel handling of IOMMU map/unmap
      powerpc: add real mode support for dma operations on powernv

Alistair Popple (5):
      powerpc: Little endian fixes for platforms/powernv/opal.c
      powerpc: Little endian fix for arch/powerpc/platforms/powernv/pci.c
      powerpc: Little endian fix for arch/powerpc/platforms/powernv/pci-p5ioc2.c
      powerpc: Little endian sparse clean up for arch/powerpc/platforms/powernv/pci-ioda.c
      powerpc: Fix 64K page size support for PPC44x

Anatolij Gustschin (1):
      powerpc/52xx: fix build breakage for MPC5200 LPBFIFO module

Anton Blanchard (30):
      powerpc: Fix endian issues in VMX copy loops
      powerpc: Book 3S MMU little endian support
      powerpc: Fix offset of FPRs in VSX registers in little endian builds
      powerpc: PTRACE_PEEKUSR/PTRACE_POKEUSER of FPR registers in little endian builds
      powerpc: Little endian builds double word swap VSX state during context save/restore
      powerpc: Add little endian support for word-at-a-time functions
      powerpc: Set MSR_LE bit on little endian builds
      powerpc: Reset MSR_LE on signal entry
      powerpc: Remove open coded byte swap macro in alignment handler
      powerpc: Remove hard coded FP offsets in alignment handler
      powerpc: Alignment handler shouldn't access VSX registers with TS_FPR
      powerpc: Add little endian support to alignment handler
      powerpc: Handle VSX alignment faults in little endian mode
      powerpc: Use generic checksum code in little endian
      powerpc: Use generic memcpy code in little endian
      powerpc: uname should return ppc64le/ppcle on little endian builds
      powerpc/powernv: More little endian issues in OPAL RTC driver
      powerpc/powernv: Fix some PCI sparse errors and one LE bug
      KVM: PPC: Disable KVM on little endian builds
      powerpc: Don't set HAVE_EFFICIENT_UNALIGNED_ACCESS on little endian builds
      powerpc: Work around little endian gcc bug
      powerpc: Fix little endian issue in OF PCI scan
      powerpc/pseries: Fix endian issues in pseries iommu code
      powerpc/pseries: Fix dedicated processor partition detection
      powerpc: Use -mcpu=power7 on ppc64 little endian builds
      powerpc: sync ppc64, ppc64e and pseries configs
      powerpc: Enable multipath modules on ppc64 and pseries
      powerpc: Enable virtio on ppc64 and pseries configs
      powerpc: Use 32 bit loads and stores when operating on condition register values
      powerpc: Add VMX optimised xor for RAID5

Bartlomiej Zolnierkiewicz (2):
      powerpc/legacy_serial: Fix incorrect placement of __initdata tag
      powerpc/8xx/tqm8xx: Fix incorrect placement of __initdata tag

Benjamin Herrenschmidt (26):
      powerpc: Endian safe trampoline
      powerpc/powernv: Fix endian issues in OPAL RTC driver
      powerpc/powernv: Fix endian issues in OPAL ICS backend
      powerpc/powernv: Make OPAL NVRAM device tree accesses endian safe
      powerpc/powernv: Fix endian issues in powernv PCI code
      powerpc/powernv: Fix endian issues in OPAL console and udbg backend
      powerpc/powernv: Fix OPAL entry and exit in little endian mode
      powerpc/powernv: Don't register exception handlers in little endian mode
      powerpc/hvsi: Fix endian issues in HVSI driver
      tty/hvc_opal: powerpc: Make OPAL HVC device tree accesses endian safe
      powerpc: Enable /dev/port when isa_io_special is set
      powerpc/scom: Change scom_read() and scom_write() to return errors
      powerpc/scom: Add support for "reg" property
      powerpc/scom: Create debugfs files using ibm,chip-id if available
      powerpc/powernv: Add scom support under OPALv3
      powerpc/scom: CONFIG_SCOM_DEBUGFS should depend on CONFIG_DEBUG_FS
      powerpc/scom: Use "devspec" rather than "path" in debugfs entries
      Merge branch 'for-kvm' into next
      Merge branch 'for-kvm' into next
      Merge remote-tracking branch 'scott/next' into next
      Merge remote-tracking branch 'agust/next' into next
      powerpc/boot: Properly handle the base "of" boot wrapper
      powerpc/scom: Enable 64-bit addresses
      powerpc/scom: Improve debugfs interface
      powerpc/powernv: Add support for indirect XSCOM via debugfs
      powerpc: Fix fatal SLB miss when restoring PPR

Bharat Bhushan (4):
      powerpc: Added __cmpdi2 for signed 64bit comparision
      powerpc: remove unnecessary line continuations
      powerpc: move debug registers in a structure
      powerpc: export debug registers save function for KVM

Brian Norris (1):
      powerpc/mpc512x: remove unnecessary #if

Cedric Le Goater (4):
      powerpc/kernel: Fix endian issue in rtas_pci
      powerpc/nvram: Scan partitions only once
      powerpc/nvram: Fix endian issue when reading the NVRAM size
      powerpc/nvram: Fix endian issue when using the partition length

Christian Kujau (2):
      powerpc/6xx: CONFIG_MCU_MPC8349EMITX cannot be a module
      powerpc/pmu: Fix ADB_PMU_LED_IDE dependencies

Chunhe Lan (1):
      powerpc/pci: Change the DECLARE_PCI_FIXUP_{HEADER => EARLY} macro of pci quirk

Dan Streetman (1):
      powerpc: Only save/restore SDR1 if in hypervisor mode

Eugene Surovegin (2):
      powerpc: Make kernel module helper endian-safe.
      powerpc: Make ftrace endian-safe.

Gavin Shan (8):
      powerpc/powernv: Enable EEH for PHB3
      powerpc/powernv: Support inbound error injection
      powerpc/eeh: Output error number
      powerpc/powernv: Double size of log blob
      powerpc/eeh: Output PHB3 diag-data
      powerpc/eeh: Reorder output messages
      powerpc/powernv: Add PE to its own PELTV
      powerpc/powernv: Reserve the correct PE number

Geert Uytterhoeven (1):
      powerpc/kexec: kexec_sequence() is in misc_64.S

Gerhard Sittig (1):
      powerpc/mpc512x: silence build warning upon disabled DIU

Haijun.Zhang (2):
      powerpc/eSDCH: Specify voltage for T4240QDS
      powerpc/dts: Correct sdhci quirk for bsc9131

Hongtao Jia (1):
      powerpc: Add I2C bus multiplexer node for B4 and T4240QDS

Ian Munsie (3):
      powerpc: Support endian agnostic MMIO
      powerpc: Include the appropriate endianness header
      powerpc: Add ability to build little endian kernels

James Yang (2):
      powerpc: Emulate sync instruction variants
      powerpc/booke: clear DBCR0_BT in user_disable_single_step()

Kevin Hao (5):
      powerpc/ppc64: Remove the unneeded load of ti_flags in resume_kernel
      powerpc/booke64: Check napping in performance monitor interrupt
      powerpc/85xx: introduce corenet_generic machine
      powerpc/85xx: rename the corenet_ds.c to corenet_generic.c
      powerpc/85xx: use one kernel option for all the CoreNet_Generic boards

LEROY Christophe (4):
      powerpc/mpc8xx: Clearer Oops message for Software Emulation Exception
      powerpc/8xx: Revert commit e0908085fc2391c85b85fb814ae1df377c8e0dcb
      powerpc/8xx: Fixing issue with CONFIG_PIN_TLB
      powerpc/8xx: Fixing memory init issue with CONFIG_PIN_TLB

Laurent Dufour (1):
      powerpc: prom_init exception when updating core value

Lijun Pan (2):
      powerpc/e6500: Include Power ISA properties
      powerpc/e500v2: Include Power ISA properties

Michael Ellerman (5):
      hwrng: Return errors to upper levels in pseries-rng.c
      powerpc: Implement arch_get_random_long/int() for powernv
      hwrng: Add a driver for the hwrng found in power7+ systems
      powerpc/pseries: Implement arch_get_random_long() based on H_RANDOM
      powerpc: FA_DUMP depends on KEXEC

Michael Neuling (1):
      powerpc/tm: Remove interrupt disable in __switch_to()

Mihai Caraman (2):
      powerpc/booke64: Use common defines for AltiVec interrupts numbers
      powerpc/fsl-booke: Use common defines for SPE/FP interrupts numbers

Minghuan Lian (1):
      powerpc/dts: fix sRIO error interrupt for b4860

Paul Bolle (1):
      powerpc: remove dependency on MV64360

Paul Mackerras (4):
      powerpc: Put FP/VSX and VR state into structures
      powerpc: Provide for giveup_fpu/altivec to save state in alternate location
      powerpc: Don't corrupt user registers on 32-bit
      powerpc/boot: Don't change link address for OF-based platforms

Philippe Bergheaud (2):
      powerpc/bpf: BPF JIT compiler for 64-bit Little Endian
      powerpc: word-at-a-time optimization for 64-bit Little Endian

Prabhakar Kushwaha (1):
      powerpc/dts/c293pcie: Add range field for IFC NAND

Prarit Bhargava (1):
      powerpc/vio: use strcpy in modalias_show

Robert Jennings (2):
      powerpc: Fix warnings for arch/powerpc/mm/numa.c
      powerpc: Move local setup.h declarations to arch includes

Scott Wood (3):
      powerpc/mpic: Disable preemption when calling mpic_processor_id()
      powerpc/b4qds: enable coreint
      powerpc: Fix PPC_EMULATED_STATS build break with sync patch

Shengzhou Liu (1):
      powerpc/fsl/defconfig: enable CONFIG_AT803X_PHY

Stephen Rothwell (1):
      powerpc: Add includes to fix powernv/rng.c build

Sudeep KarkadaNagesha (2):
      powerpc: Remove big endianness assumption in of_find_next_cache_node
      of: Move definition of of_find_next_cache_node into common code.

Suzuki Poulose (1):
      powerpc: Set the NOTE type for SPE regset

Tiejun Chen (1):
      powerpc/kgdb: use DEFINE_PER_CPU to allocate kgdb's thread_info

Tom Musta (4):
      powerpc: Fix Handler of Unaligned Load/Store Strings
      powerpc: Enable Little Endian Alignment Handler for Float Pair Instructions
      powerpc: Fix Unaligned Loads and Stores
      powerpc: Fix Unaligned LE Floating Point Loads and Stores

Vaishnavi Bhat (1):
      powerpc: Fix a typo in comments of va to pa conversion

Vasant Hegde (2):
      powerpc/powernv: Create opal sysfs directory
      powerpc/powernv: Code update interface

Vladimir Murzin (3):
      powerpc: Fix section mismatch warning in free_lppacas
      powerpc/bpf: Fix DIVWU instruction opcode
      powerpc/bpf: Support MOD operation

Wei Yongjun (2):
      powerpc/6xx: add missing iounmap() on error in hlwd_pic_init()
      powerpc/mv643xx_eth: fix return check in mv64x60_eth_register_shared_pdev()

Wolfram Sang (2):
      arch/powerpc/platforms/83xx: Remove obsolete cleanup for clientdata
      Kind of revert "powerpc: 52xx: provide a default in mpc52xx_irqhost_map()"

York Sun (2):
      powerpc/t4240emu: Add device tree file for t4240emu
      powerpc/b4860emu: Add device tree file for b4860emu

Zhao Qiang (1):
      powerpc/p1010rdb: add P1010RDB-PB platform support

 arch/powerpc/Kconfig                           |  12 +-
 arch/powerpc/Makefile                          |  37 +-
 arch/powerpc/boot/Makefile                     |   3 +-
 arch/powerpc/boot/dts/b4860emu.dts             | 218 ++++++++
 arch/powerpc/boot/dts/b4qds.dtsi               |  51 +-
 arch/powerpc/boot/dts/c293pcie.dts             |   1 +
 arch/powerpc/boot/dts/fsl/b4420si-pre.dtsi     |   2 +
 arch/powerpc/boot/dts/fsl/b4860si-post.dtsi    |   2 +-
 arch/powerpc/boot/dts/fsl/b4860si-pre.dtsi     |   2 +
 arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi  |   2 +-
 arch/powerpc/boot/dts/fsl/bsc9131si-pre.dtsi   |   3 +
 arch/powerpc/boot/dts/t4240emu.dts             | 268 ++++++++++
 arch/powerpc/boot/dts/t4240qds.dts             |  73 +--
 arch/powerpc/boot/wrapper                      |   8 +
 arch/powerpc/configs/corenet32_smp_defconfig   |   7 +-
 arch/powerpc/configs/corenet64_smp_defconfig   |   5 +-
 arch/powerpc/configs/mpc85xx_defconfig         |   1 +
 arch/powerpc/configs/mpc85xx_smp_defconfig     |   1 +
 arch/powerpc/configs/ppc64_defconfig           |  27 +-
 arch/powerpc/configs/ppc64e_defconfig          |  12 +-
 arch/powerpc/configs/ppc6xx_defconfig          |   2 +-
 arch/powerpc/configs/pseries_defconfig         |  25 +-
 arch/powerpc/include/asm/archrandom.h          |  32 ++
 arch/powerpc/include/asm/checksum.h            |   5 +
 arch/powerpc/include/asm/emulated_ops.h        |   1 +
 arch/powerpc/include/asm/hvsi.h                |  16 +-
 arch/powerpc/include/asm/io.h                  |  69 ++-
 arch/powerpc/include/asm/lppaca.h              |  12 +-
 arch/powerpc/include/asm/machdep.h             |  16 +
 arch/powerpc/include/asm/mmu-hash64.h          |   4 +-
 arch/powerpc/include/asm/opal.h                | 109 +++-
 arch/powerpc/include/asm/page.h                |   4 +-
 arch/powerpc/include/asm/pgtable-ppc64.h       |   2 +
 arch/powerpc/include/asm/ppc-opcode.h          |   8 +-
 arch/powerpc/include/asm/ppc_asm.h             | 142 ++----
 arch/powerpc/include/asm/processor.h           |  91 ++--
 arch/powerpc/include/asm/prom.h                |   3 -
 arch/powerpc/include/asm/reg.h                 |   7 +-
 arch/powerpc/include/asm/reg_booke.h           |   8 +-
 arch/powerpc/include/asm/scom.h                |  23 +-
 arch/powerpc/include/asm/setup.h               |   4 +
 arch/powerpc/include/asm/sfp-machine.h         |   2 +-
 arch/powerpc/include/asm/string.h              |   4 +
 arch/powerpc/include/asm/switch_to.h           |   1 +
 arch/powerpc/include/asm/word-at-a-time.h      |  78 +++
 arch/powerpc/include/asm/xor.h                 |  67 +++
 arch/powerpc/include/uapi/asm/byteorder.h      |   4 +
 arch/powerpc/kernel/align.c                    | 173 ++++---
 arch/powerpc/kernel/asm-offsets.c              |  29 +-
 arch/powerpc/kernel/eeh.c                      |   6 +-
 arch/powerpc/kernel/entry_64.S                 |  50 +-
 arch/powerpc/kernel/exceptions-64e.S           |   6 +-
 arch/powerpc/kernel/fpu.S                      |  86 ++--
 arch/powerpc/kernel/ftrace.c                   |   4 +
 arch/powerpc/kernel/head_64.S                  |   3 +
 arch/powerpc/kernel/head_8xx.S                 |   3 +
 arch/powerpc/kernel/head_fsl_booke.S           |  10 +-
 arch/powerpc/kernel/kgdb.c                     |   6 +-
 arch/powerpc/kernel/legacy_serial.c            |   2 +-
 arch/powerpc/kernel/machine_kexec_64.c         |   2 +-
 arch/powerpc/kernel/misc_32.S                  |  14 +
 arch/powerpc/kernel/module.c                   |   3 +-
 arch/powerpc/kernel/module_32.c                |   3 +-
 arch/powerpc/kernel/module_64.c                |  19 +-
 arch/powerpc/kernel/nvram_64.c                 |  10 +-
 arch/powerpc/kernel/paca.c                     |   6 +-
 arch/powerpc/kernel/pci_of_scan.c              |   4 +-
 arch/powerpc/kernel/ppc_ksyms.c                |  10 +
 arch/powerpc/kernel/process.c                  |  67 +--
 arch/powerpc/kernel/prom.c                     |  31 --
 arch/powerpc/kernel/prom_init.c                |  28 +-
 arch/powerpc/kernel/ptrace.c                   | 209 ++++----
 arch/powerpc/kernel/ptrace32.c                 |  13 +-
 arch/powerpc/kernel/rtas_pci.c                 |   6 +-
 arch/powerpc/kernel/setup-common.c             |   2 -
 arch/powerpc/kernel/setup.h                    |   9 -
 arch/powerpc/kernel/setup_32.c                 |   2 -
 arch/powerpc/kernel/setup_64.c                 |   2 -
 arch/powerpc/kernel/signal_32.c                |  81 +--
 arch/powerpc/kernel/signal_64.c                |  32 +-
 arch/powerpc/kernel/swsusp_asm64.S             |   4 +
 arch/powerpc/kernel/tm.S                       |  49 +-
 arch/powerpc/kernel/traps.c                    |  56 ++-
 arch/powerpc/kernel/vdso.c                     |   3 +-
 arch/powerpc/kernel/vdso32/vdso32.lds.S        |   4 +
 arch/powerpc/kernel/vdso64/vdso64.lds.S        |   4 +
 arch/powerpc/kernel/vecemu.c                   |   6 +-
 arch/powerpc/kernel/vector.S                   |  80 +--
 arch/powerpc/kernel/vio.c                      |   4 +-
 arch/powerpc/kvm/Kconfig                       |   1 +
 arch/powerpc/kvm/book3s_pr.c                   |  36 +-
 arch/powerpc/kvm/booke.c                       |  19 +-
 arch/powerpc/lib/Makefile                      |  21 +-
 arch/powerpc/lib/copyuser_power7.S             |  54 +-
 arch/powerpc/lib/memcpy_power7.S               |  55 +-
 arch/powerpc/lib/sstep.c                       |  97 +++-
 arch/powerpc/lib/xor_vmx.c                     | 177 +++++++
 arch/powerpc/mm/hash_native_64.c               |  46 +-
 arch/powerpc/mm/hash_utils_64.c                |  38 +-
 arch/powerpc/mm/init_32.c                      |   5 +
 arch/powerpc/mm/init_64.c                      |  51 +-
 arch/powerpc/mm/numa.c                         |   8 +-
 arch/powerpc/mm/pgtable.c                      |  19 +-
 arch/powerpc/net/bpf_jit.h                     |  11 +
 arch/powerpc/net/bpf_jit_64.S                  |   9 +-
 arch/powerpc/net/bpf_jit_comp.c                |  37 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c   |  18 +-
 arch/powerpc/platforms/52xx/Kconfig            |   2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c      |   5 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   1 -
 arch/powerpc/platforms/85xx/Kconfig            | 101 +---
 arch/powerpc/platforms/85xx/Makefile           |   8 +-
 arch/powerpc/platforms/85xx/b4_qds.c           | 102 ----
 arch/powerpc/platforms/85xx/corenet_ds.c       |  96 ----
 arch/powerpc/platforms/85xx/corenet_ds.h       |  19 -
 arch/powerpc/platforms/85xx/corenet_generic.c  | 182 +++++++
 arch/powerpc/platforms/85xx/p1010rdb.c         |   2 +
 arch/powerpc/platforms/85xx/p2041_rdb.c        |  87 ----
 arch/powerpc/platforms/85xx/p3041_ds.c         |  89 ----
 arch/powerpc/platforms/85xx/p4080_ds.c         |  87 ----
 arch/powerpc/platforms/85xx/p5020_ds.c         |  93 ----
 arch/powerpc/platforms/85xx/p5040_ds.c         |  84 ----
 arch/powerpc/platforms/85xx/t4240_qds.c        |  93 ----
 arch/powerpc/platforms/8xx/tqm8xx_setup.c      |   4 +-
 arch/powerpc/platforms/Kconfig.cputype         |   9 +-
 arch/powerpc/platforms/chrp/nvram.c            |   4 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c  |   1 +
 arch/powerpc/platforms/powernv/Kconfig         |   2 +
 arch/powerpc/platforms/powernv/Makefile        |   4 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c      | 153 +++++-
 arch/powerpc/platforms/powernv/eeh-powernv.c   |   5 +-
 arch/powerpc/platforms/powernv/opal-flash.c    | 667 +++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/opal-nvram.c    |   4 +-
 arch/powerpc/platforms/powernv/opal-rtc.c      |  12 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S |  16 +-
 arch/powerpc/platforms/powernv/opal-xscom.c    | 128 +++++
 arch/powerpc/platforms/powernv/opal.c          |  57 ++-
 arch/powerpc/platforms/powernv/pci-ioda.c      | 110 ++--
 arch/powerpc/platforms/powernv/pci-p5ioc2.c    |   4 +-
 arch/powerpc/platforms/powernv/pci.c           |  78 ++-
 arch/powerpc/platforms/powernv/pci.h           |   6 +-
 arch/powerpc/platforms/powernv/rng.c           | 125 +++++
 arch/powerpc/platforms/pseries/Makefile        |   2 +-
 arch/powerpc/platforms/pseries/iommu.c         |  59 +--
 arch/powerpc/platforms/pseries/nvram.c         |  10 +-
 arch/powerpc/platforms/pseries/rng.c           |  44 ++
 arch/powerpc/platforms/wsp/scom_smp.c          |  18 +-
 arch/powerpc/platforms/wsp/scom_wsp.c          |  12 +-
 arch/powerpc/platforms/wsp/wsp.c               |  13 +-
 arch/powerpc/sysdev/Kconfig                    |   2 +-
 arch/powerpc/sysdev/fsl_pci.c                  |   5 +-
 arch/powerpc/sysdev/fsl_soc.h                  |   3 -
 arch/powerpc/sysdev/mpic.c                     |   8 +-
 arch/powerpc/sysdev/mv64x60_dev.c              |   2 +-
 arch/powerpc/sysdev/scom.c                     | 168 ++++---
 arch/powerpc/sysdev/xics/ics-opal.c            |  17 +-
 drivers/char/hw_random/Kconfig                 |  13 +
 drivers/char/hw_random/Makefile                |   1 +
 drivers/char/hw_random/powernv-rng.c           |  81 +++
 drivers/char/hw_random/pseries-rng.c           |  14 +-
 drivers/macintosh/Kconfig                      |   1 +
 drivers/of/base.c                              |  31 ++
 drivers/tty/hvc/hvc_opal.c                     |   4 +-
 drivers/tty/hvc/hvsi_lib.c                     |  25 +-
 include/linux/hashtable.h                      |  15 +
 include/linux/mm.h                             |  14 +
 include/linux/of.h                             |   2 +
 include/linux/page-flags.h                     |   4 +-
 168 files changed, 4200 insertions(+), 2125 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/b4860emu.dts
 create mode 100644 arch/powerpc/boot/dts/t4240emu.dts
 create mode 100644 arch/powerpc/include/asm/archrandom.h
 delete mode 100644 arch/powerpc/kernel/setup.h
 create mode 100644 arch/powerpc/lib/xor_vmx.c
 delete mode 100644 arch/powerpc/platforms/85xx/b4_qds.c
 delete mode 100644 arch/powerpc/platforms/85xx/corenet_ds.c
 delete mode 100644 arch/powerpc/platforms/85xx/corenet_ds.h
 create mode 100644 arch/powerpc/platforms/85xx/corenet_generic.c
 delete mode 100644 arch/powerpc/platforms/85xx/p2041_rdb.c
 delete mode 100644 arch/powerpc/platforms/85xx/p3041_ds.c
 delete mode 100644 arch/powerpc/platforms/85xx/p4080_ds.c
 delete mode 100644 arch/powerpc/platforms/85xx/p5020_ds.c
 delete mode 100644 arch/powerpc/platforms/85xx/p5040_ds.c
 delete mode 100644 arch/powerpc/platforms/85xx/t4240_qds.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-flash.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-xscom.c
 create mode 100644 arch/powerpc/platforms/powernv/rng.c
 create mode 100644 arch/powerpc/platforms/pseries/rng.c
 create mode 100644 drivers/char/hw_random/powernv-rng.c


