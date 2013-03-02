Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab3CBGsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 01:48:30 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:60369 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3CBGs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 01:48:29 -0500
Message-ID: <5131A0AB.5090105@synopsys.com>
Date: Sat, 2 Mar 2013 12:18:11 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        "Gilad Ben-Yossef" <gilad@benyossef.com>, Helge Deller <deller@gmx.de>,
        "Mischa Jonker" <Mischa.Jonker@synopsys.com>
Subject: [GIT PULL] arch/arc (with fixes) for v3.9-rc1
References: <51271703.8050107@synopsys.com>
In-Reply-To: <51271703.8050107@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Friday 22 February 2013 12:28 PM, Vineet Gupta wrote:
> Hi Linus,
> 
> I would like to introduce the Linux port to ARC Processors (from Synopsys)
> for 3.9-rc1. The patch-set has been discussed on the public lists since Nov
> and has received a fair bit of review, specially from Arnd, tglx, Al and
> other subsystem maintainers for DeviceTree, kgdb .....
> 
> The arch bits are in arch/arc, some asm-generic changes (acked by Arnd), a
> minor change to PARISC (acked by Helge).
> 
> The series is a touch bigger for a new port for 2 main reasons: 1. It enables
> a basic kernel in first sub-series and adds ptrace/kgdb/.. later 2. Some of
> the fallout of review (DeviceTree support, multi-platform-image support) were
> added on top of orig series, primarily to record the revision history.
> 
> Please consider pulling.
> 
> Thanks, Vineet

Hi Linus,

This updated pull request contains the
- -original ARC port (1st pull request)
- -fixes due to our GNU tools catching up with the new syscall/ptrace ABI
- -some (minor) cross-arch Kconfig updates.

Please consider pulling.

Thanks,
Vineet

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git
tags/arc-v3.9-rc1-late

for you to fetch changes up to 8ccfe6675fa974bd06d64f74d0fdee6a5267d2aa:

  ARC: split elf.h into uapi and export it for userspace (2013-02-27 20:00:26 +0530)

- ----------------------------------------------------------------
Initial ARC Linux port with some fixes on top for 3.9-rc1

- ----------------------------------------------------------------
Gilad Ben-Yossef (1):
      ARC: Add support for ioremap_prot API

Mischa Jonker (1):
      ARC: kgdb support

Vineet Gupta (80):
      ARC: Generic Headers
      ARC: Build system: Makefiles, Kconfig, Linker script
      ARC: irqflags - Interrupt enabling/disabling at in-core intc
      ARC: Atomic/bitops/cmpxchg/barriers
      asm-generic headers: uaccess.h to conditionally define segment_eq()
      ARC: uaccess friends
      asm-generic: uaccess: Allow arches to over-ride __{get,put}_user_fn()
      ARC: [optim] uaccess __{get,put}_user() optimised
      asm-generic headers: Allow yet more arch overrides in checksum.h
      ARC: Checksum/byteorder/swab routines
      ARC: Fundamental ARCH data-types/defines
      ARC: Spinlock/rwlock/mutex primitives
      ARC: String library
      ARC: Low level IRQ/Trap/Exception Handling
      ARC: Interrupt Handling
      ARC: Non-MMU Exception Handling
      ARC: Syscall support (no-legacy-syscall ABI)
      ARC: Process-creation/scheduling/idle-loop
      ARC: Timers/counters/delay management
      ARC: Signal handling
      ARC: [Review] Preparing to fix incorrect syscall restarts due to signals
      ARC: [Review] Prevent incorrect syscall restarts
      ARC: Cache Flush Management
      ARC: Page Table Management
      ARC: MMU Context Management
      ARC: MMU Exception Handling
      ARC: TLB flush Handling
      ARC: Page Fault handling
      ARC: I/O and DMA Mappings
      ARC: Boot #1: low-level, setup_arch(), /proc/cpuinfo, mem init
      ARC: [plat-arcfpga] Static platform device for CONFIG_SERIAL_ARC
      ARC: [DeviceTree] Basic support
      ARC: [DeviceTree] Convert some Kconfig items to runtime values
      ARC: [plat-arcfpga]: Enabling DeviceTree for Angel4 board
      ARC: Last bits (stubs) to get to a running kernel with UART
      ARC: [plat-arcfpga] defconfig
      ARC: [optim] Cache "current" in Register r25
      ARC: ptrace support
      ARC: Futex support
      ARC: OProfile support
      ARC: Support for high priority interrupts in the in-core intc
      ARC: Module support
      ARC: Diagnostics: show_regs() etc
      ARC: SMP support
      ARC: DWARF2 .debug_frame based stack unwinder
      ARC: stacktracing APIs based on dw2 unwinder
      ARC: disassembly (needed by kprobes/kgdb/unaligned-access-emul)
      ARC: kprobes support
      sysctl: Enable PARISC "unaligned-trap" to be used cross-arch
      ARC: Unaligned access emulation
      ARC: Boot #2: Verbose Boot reporting / feature verification
      ARC: [plat-arfpga] BVCI Latency Unit setup
      perf, ARC: Enable building perf tools for ARC
      ARC: perf support (software counters only)
      ARC: Support for single cycle Close Coupled Mem (CCM)
      ARC: Hostlink Pseudo-Driver for Metaware Debugger
      ARC: UAPI Disintegrate arch/arc/include/asm
      ARC: [Review] Multi-platform image #1: Kconfig enablement
      ARC: Fold boards sub-menu into platform/SoC menu
      ARC: [Review] Multi-platform image #2: Board callback Infrastructure
      ARC: [Review] Multi-platform image #3: switch to board callback
      ARC: [Review] Multi-platform image #4: Isolate platform headers
      ARC: [Review] Multi-platform image #5: NR_IRQS defined by ARC core
      ARC: [Review] Multi-platform image #6: cpu-to-dma-addr optional
      ARC: [Review] Multi-platform image #7: SMP common code to use callbacks
      ARC: [Review] Multi-platform image #8: platform registers SMP callbacks
      ARC: [plat-arcfpga] defconfig for fully loaded ARC Linux
      ARC: Provide a default serial.h for uart drivers needing BASE_BAUD
      ARC: Add self to MAINTAINERS
      ARC: Don't fiddle with non-existent caches
      ARC: 64bit RTSC timestamp hardware issue
      ARC: [3.9] Fallout of hlist iterator update
      ARC: Fix pt_orig_r8 access
      ARC: Ensure CONFIG_VIRT_TO_BUS is not enabled
      ARC: [plat-arcfpga] DT arc-uart bindings change: "baud" => "current-speed"
================ changes after 1st pull rquest ===============
      ARC: make a copy of flat DT
      ARC: Kconfig cleanup tracking cross-arch Kconfig pruning in merge window
      ARC: gdbserver using regset interface possibly broken
      ARC: Fixup the current ABI version
      ARC: split elf.h into uapi and export it for userspace

 .../devicetree/bindings/arc/interrupts.txt         |   24 +
 MAINTAINERS                                        |    6 +
 arch/arc/Kbuild                                    |    2 +
 arch/arc/Kconfig                                   |  453 +++++++
 arch/arc/Kconfig.debug                             |   34 +
 arch/arc/Makefile                                  |  126 ++
 arch/arc/boot/Makefile                             |   26 +
 arch/arc/boot/dts/Makefile                         |   13 +
 arch/arc/boot/dts/angel4.dts                       |   55 +
 arch/arc/boot/dts/skeleton.dts                     |   10 +
 arch/arc/boot/dts/skeleton.dtsi                    |   37 +
 arch/arc/configs/fpga_defconfig                    |   61 +
 arch/arc/include/asm/Kbuild                        |   49 +
 arch/arc/include/asm/arcregs.h                     |  433 +++++++
 arch/arc/include/asm/asm-offsets.h                 |    9 +
 arch/arc/include/asm/atomic.h                      |  232 ++++
 arch/arc/include/asm/barrier.h                     |   42 +
 arch/arc/include/asm/bitops.h                      |  516 ++++++++
 arch/arc/include/asm/bug.h                         |   37 +
 arch/arc/include/asm/cache.h                       |   75 ++
 arch/arc/include/asm/cacheflush.h                  |   67 +
 arch/arc/include/asm/checksum.h                    |  101 ++
 arch/arc/include/asm/clk.h                         |   22 +
 arch/arc/include/asm/cmpxchg.h                     |  143 +++
 arch/arc/include/asm/current.h                     |   32 +
 arch/arc/include/asm/defines.h                     |   56 +
 arch/arc/include/asm/delay.h                       |   68 +
 arch/arc/include/asm/disasm.h                      |  116 ++
 arch/arc/include/asm/dma-mapping.h                 |  221 ++++
 arch/arc/include/asm/dma.h                         |   14 +
 arch/arc/include/asm/elf.h                         |   78 ++
 arch/arc/include/asm/entry.h                       |  724 +++++++++++
 arch/arc/include/asm/exec.h                        |   15 +
 arch/arc/include/asm/futex.h                       |  151 +++
 arch/arc/include/asm/io.h                          |  105 ++
 arch/arc/include/asm/irq.h                         |   25 +
 arch/arc/include/asm/irqflags.h                    |  153 +++
 arch/arc/include/asm/kdebug.h                      |   19 +
 arch/arc/include/asm/kgdb.h                        |   61 +
 arch/arc/include/asm/kprobes.h                     |   62 +
 arch/arc/include/asm/linkage.h                     |   63 +
 arch/arc/include/asm/mach_desc.h                   |   87 ++
 arch/arc/include/asm/mmu.h                         |   23 +
 arch/arc/include/asm/mmu_context.h                 |  213 ++++
 arch/arc/include/asm/module.h                      |   28 +
 arch/arc/include/asm/mutex.h                       |   18 +
 arch/arc/include/asm/page.h                        |  109 ++
 arch/arc/include/asm/perf_event.h                  |   13 +
 arch/arc/include/asm/pgalloc.h                     |  134 ++
 arch/arc/include/asm/pgtable.h                     |  405 ++++++
 arch/arc/include/asm/processor.h                   |  151 +++
 arch/arc/include/asm/prom.h                        |   14 +
 arch/arc/include/asm/ptrace.h                      |  130 ++
 arch/arc/include/asm/sections.h                    |   18 +
 arch/arc/include/asm/segment.h                     |   24 +
 arch/arc/include/asm/serial.h                      |   25 +
 arch/arc/include/asm/setup.h                       |   37 +
 arch/arc/include/asm/smp.h                         |  130 ++
 arch/arc/include/asm/spinlock.h                    |  144 +++
 arch/arc/include/asm/spinlock_types.h              |   35 +
 arch/arc/include/asm/string.h                      |   40 +
 arch/arc/include/asm/switch_to.h                   |   41 +
 arch/arc/include/asm/syscall.h                     |   72 ++
 arch/arc/include/asm/syscalls.h                    |   29 +
 arch/arc/include/asm/thread_info.h                 |  121 ++
 arch/arc/include/asm/timex.h                       |   18 +
 arch/arc/include/asm/tlb-mmu1.h                    |  104 ++
 arch/arc/include/asm/tlb.h                         |   58 +
 arch/arc/include/asm/tlbflush.h                    |   28 +
 arch/arc/include/asm/uaccess.h                     |  751 +++++++++++
 arch/arc/include/asm/unaligned.h                   |   29 +
 arch/arc/include/asm/unwind.h                      |  163 +++
 arch/arc/include/uapi/asm/Kbuild                   |   12 +
 arch/arc/include/uapi/asm/byteorder.h              |   18 +
 arch/arc/include/uapi/asm/cachectl.h               |   28 +
 arch/arc/include/uapi/asm/elf.h                    |   26 +
 arch/arc/include/uapi/asm/page.h                   |   39 +
 arch/arc/include/uapi/asm/ptrace.h                 |   48 +
 arch/arc/include/uapi/asm/setup.h                  |    6 +
 arch/arc/include/uapi/asm/sigcontext.h             |   22 +
 arch/arc/include/uapi/asm/signal.h                 |   27 +
 arch/arc/include/uapi/asm/swab.h                   |   98 ++
 arch/arc/include/uapi/asm/unistd.h                 |   34 +
 arch/arc/kernel/Makefile                           |   33 +
 arch/arc/kernel/arc_hostlink.c                     |   58 +
 arch/arc/kernel/arcksyms.c                         |   56 +
 arch/arc/kernel/asm-offsets.c                      |   64 +
 arch/arc/kernel/clk.c                              |   21 +
 arch/arc/kernel/ctx_sw.c                           |  109 ++
 arch/arc/kernel/ctx_sw_asm.S                       |   58 +
 arch/arc/kernel/devtree.c                          |  123 ++
 arch/arc/kernel/disasm.c                           |  538 ++++++++
 arch/arc/kernel/entry.S                            |  839 ++++++++++++
 arch/arc/kernel/fpu.c                              |   55 +
 arch/arc/kernel/head.S                             |  111 ++
 arch/arc/kernel/irq.c                              |  273 ++++
 arch/arc/kernel/kgdb.c                             |  205 +++
 arch/arc/kernel/kprobes.c                          |  525 ++++++++
 arch/arc/kernel/module.c                           |  145 +++
 arch/arc/kernel/process.c                          |  235 ++++
 arch/arc/kernel/ptrace.c                           |  158 +++
 arch/arc/kernel/reset.c                            |   33 +
 arch/arc/kernel/setup.c                            |  473 +++++++
 arch/arc/kernel/signal.c                           |  360 ++++++
 arch/arc/kernel/smp.c                              |  332 +++++
 arch/arc/kernel/stacktrace.c                       |  254 ++++
 arch/arc/kernel/sys.c                              |   18 +
 arch/arc/kernel/time.c                             |  265 ++++
 arch/arc/kernel/traps.c                            |  170 +++
 arch/arc/kernel/troubleshoot.c                     |  322 +++++
 arch/arc/kernel/unaligned.c                        |  245 ++++
 arch/arc/kernel/unwind.c                           | 1329 ++++++++++++++++++++
 arch/arc/kernel/vmlinux.lds.S                      |  163 +++
 arch/arc/lib/Makefile                              |    9 +
 arch/arc/lib/memcmp.S                              |  124 ++
 arch/arc/lib/memcpy-700.S                          |   66 +
 arch/arc/lib/memset.S                              |   59 +
 arch/arc/lib/strchr-700.S                          |  123 ++
 arch/arc/lib/strcmp.S                              |   96 ++
 arch/arc/lib/strcpy-700.S                          |   70 ++
 arch/arc/lib/strlen.S                              |   83 ++
 arch/arc/mm/Makefile                               |   10 +
 arch/arc/mm/cache_arc700.c                         |  768 +++++++++++
 arch/arc/mm/dma.c                                  |   94 ++
 arch/arc/mm/extable.c                              |   63 +
 arch/arc/mm/fault.c                                |  228 ++++
 arch/arc/mm/init.c                                 |  187 +++
 arch/arc/mm/ioremap.c                              |   91 ++
 arch/arc/mm/tlb.c                                  |  645 ++++++++++
 arch/arc/mm/tlbex.S                                |  408 ++++++
 arch/arc/oprofile/Makefile                         |    9 +
 arch/arc/oprofile/common.c                         |   26 +
 arch/arc/plat-arcfpga/Kconfig                      |   84 ++
 arch/arc/plat-arcfpga/Makefile                     |   12 +
 arch/arc/plat-arcfpga/include/plat/irq.h           |   31 +
 arch/arc/plat-arcfpga/include/plat/memmap.h        |   31 +
 arch/arc/plat-arcfpga/include/plat/smp.h           |  118 ++
 arch/arc/plat-arcfpga/irq.c                        |   25 +
 arch/arc/plat-arcfpga/platform.c                   |  226 ++++
 arch/arc/plat-arcfpga/smp.c                        |  171 +++
 arch/parisc/Kconfig                                |    1 +
 include/asm-generic/checksum.h                     |    4 +
 include/asm-generic/uaccess.h                      |   14 +-
 init/Kconfig                                       |    8 +
 kernel/sysctl.c                                    |    5 +
 lib/checksum.c                                     |    2 +
 tools/perf/perf.h                                  |    6 +
 147 files changed, 19552 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arc/interrupts.txt
 create mode 100644 arch/arc/Kbuild
 create mode 100644 arch/arc/Kconfig
 create mode 100644 arch/arc/Kconfig.debug
 create mode 100644 arch/arc/Makefile
 create mode 100644 arch/arc/boot/Makefile
 create mode 100644 arch/arc/boot/dts/Makefile
 create mode 100644 arch/arc/boot/dts/angel4.dts
 create mode 100644 arch/arc/boot/dts/skeleton.dts
 create mode 100644 arch/arc/boot/dts/skeleton.dtsi
 create mode 100644 arch/arc/configs/fpga_defconfig
 create mode 100644 arch/arc/include/asm/Kbuild
 create mode 100644 arch/arc/include/asm/arcregs.h
 create mode 100644 arch/arc/include/asm/asm-offsets.h
 create mode 100644 arch/arc/include/asm/atomic.h
 create mode 100644 arch/arc/include/asm/barrier.h
 create mode 100644 arch/arc/include/asm/bitops.h
 create mode 100644 arch/arc/include/asm/bug.h
 create mode 100644 arch/arc/include/asm/cache.h
 create mode 100644 arch/arc/include/asm/cacheflush.h
 create mode 100644 arch/arc/include/asm/checksum.h
 create mode 100644 arch/arc/include/asm/clk.h
 create mode 100644 arch/arc/include/asm/cmpxchg.h
 create mode 100644 arch/arc/include/asm/current.h
 create mode 100644 arch/arc/include/asm/defines.h
 create mode 100644 arch/arc/include/asm/delay.h
 create mode 100644 arch/arc/include/asm/disasm.h
 create mode 100644 arch/arc/include/asm/dma-mapping.h
 create mode 100644 arch/arc/include/asm/dma.h
 create mode 100644 arch/arc/include/asm/elf.h
 create mode 100644 arch/arc/include/asm/entry.h
 create mode 100644 arch/arc/include/asm/exec.h
 create mode 100644 arch/arc/include/asm/futex.h
 create mode 100644 arch/arc/include/asm/io.h
 create mode 100644 arch/arc/include/asm/irq.h
 create mode 100644 arch/arc/include/asm/irqflags.h
 create mode 100644 arch/arc/include/asm/kdebug.h
 create mode 100644 arch/arc/include/asm/kgdb.h
 create mode 100644 arch/arc/include/asm/kprobes.h
 create mode 100644 arch/arc/include/asm/linkage.h
 create mode 100644 arch/arc/include/asm/mach_desc.h
 create mode 100644 arch/arc/include/asm/mmu.h
 create mode 100644 arch/arc/include/asm/mmu_context.h
 create mode 100644 arch/arc/include/asm/module.h
 create mode 100644 arch/arc/include/asm/mutex.h
 create mode 100644 arch/arc/include/asm/page.h
 create mode 100644 arch/arc/include/asm/perf_event.h
 create mode 100644 arch/arc/include/asm/pgalloc.h
 create mode 100644 arch/arc/include/asm/pgtable.h
 create mode 100644 arch/arc/include/asm/processor.h
 create mode 100644 arch/arc/include/asm/prom.h
 create mode 100644 arch/arc/include/asm/ptrace.h
 create mode 100644 arch/arc/include/asm/sections.h
 create mode 100644 arch/arc/include/asm/segment.h
 create mode 100644 arch/arc/include/asm/serial.h
 create mode 100644 arch/arc/include/asm/setup.h
 create mode 100644 arch/arc/include/asm/smp.h
 create mode 100644 arch/arc/include/asm/spinlock.h
 create mode 100644 arch/arc/include/asm/spinlock_types.h
 create mode 100644 arch/arc/include/asm/string.h
 create mode 100644 arch/arc/include/asm/switch_to.h
 create mode 100644 arch/arc/include/asm/syscall.h
 create mode 100644 arch/arc/include/asm/syscalls.h
 create mode 100644 arch/arc/include/asm/thread_info.h
 create mode 100644 arch/arc/include/asm/timex.h
 create mode 100644 arch/arc/include/asm/tlb-mmu1.h
 create mode 100644 arch/arc/include/asm/tlb.h
 create mode 100644 arch/arc/include/asm/tlbflush.h
 create mode 100644 arch/arc/include/asm/uaccess.h
 create mode 100644 arch/arc/include/asm/unaligned.h
 create mode 100644 arch/arc/include/asm/unwind.h
 create mode 100644 arch/arc/include/uapi/asm/Kbuild
 create mode 100644 arch/arc/include/uapi/asm/byteorder.h
 create mode 100644 arch/arc/include/uapi/asm/cachectl.h
 create mode 100644 arch/arc/include/uapi/asm/elf.h
 create mode 100644 arch/arc/include/uapi/asm/page.h
 create mode 100644 arch/arc/include/uapi/asm/ptrace.h
 create mode 100644 arch/arc/include/uapi/asm/setup.h
 create mode 100644 arch/arc/include/uapi/asm/sigcontext.h
 create mode 100644 arch/arc/include/uapi/asm/signal.h
 create mode 100644 arch/arc/include/uapi/asm/swab.h
 create mode 100644 arch/arc/include/uapi/asm/unistd.h
 create mode 100644 arch/arc/kernel/Makefile
 create mode 100644 arch/arc/kernel/arc_hostlink.c
 create mode 100644 arch/arc/kernel/arcksyms.c
 create mode 100644 arch/arc/kernel/asm-offsets.c
 create mode 100644 arch/arc/kernel/clk.c
 create mode 100644 arch/arc/kernel/ctx_sw.c
 create mode 100644 arch/arc/kernel/ctx_sw_asm.S
 create mode 100644 arch/arc/kernel/devtree.c
 create mode 100644 arch/arc/kernel/disasm.c
 create mode 100644 arch/arc/kernel/entry.S
 create mode 100644 arch/arc/kernel/fpu.c
 create mode 100644 arch/arc/kernel/head.S
 create mode 100644 arch/arc/kernel/irq.c
 create mode 100644 arch/arc/kernel/kgdb.c
 create mode 100644 arch/arc/kernel/kprobes.c
 create mode 100644 arch/arc/kernel/module.c
 create mode 100644 arch/arc/kernel/process.c
 create mode 100644 arch/arc/kernel/ptrace.c
 create mode 100644 arch/arc/kernel/reset.c
 create mode 100644 arch/arc/kernel/setup.c
 create mode 100644 arch/arc/kernel/signal.c
 create mode 100644 arch/arc/kernel/smp.c
 create mode 100644 arch/arc/kernel/stacktrace.c
 create mode 100644 arch/arc/kernel/sys.c
 create mode 100644 arch/arc/kernel/time.c
 create mode 100644 arch/arc/kernel/traps.c
 create mode 100644 arch/arc/kernel/troubleshoot.c
 create mode 100644 arch/arc/kernel/unaligned.c
 create mode 100644 arch/arc/kernel/unwind.c
 create mode 100644 arch/arc/kernel/vmlinux.lds.S
 create mode 100644 arch/arc/lib/Makefile
 create mode 100644 arch/arc/lib/memcmp.S
 create mode 100644 arch/arc/lib/memcpy-700.S
 create mode 100644 arch/arc/lib/memset.S
 create mode 100644 arch/arc/lib/strchr-700.S
 create mode 100644 arch/arc/lib/strcmp.S
 create mode 100644 arch/arc/lib/strcpy-700.S
 create mode 100644 arch/arc/lib/strlen.S
 create mode 100644 arch/arc/mm/Makefile
 create mode 100644 arch/arc/mm/cache_arc700.c
 create mode 100644 arch/arc/mm/dma.c
 create mode 100644 arch/arc/mm/extable.c
 create mode 100644 arch/arc/mm/fault.c
 create mode 100644 arch/arc/mm/init.c
 create mode 100644 arch/arc/mm/ioremap.c
 create mode 100644 arch/arc/mm/tlb.c
 create mode 100644 arch/arc/mm/tlbex.S
 create mode 100644 arch/arc/oprofile/Makefile
 create mode 100644 arch/arc/oprofile/common.c
 create mode 100644 arch/arc/plat-arcfpga/Kconfig
 create mode 100644 arch/arc/plat-arcfpga/Makefile
 create mode 100644 arch/arc/plat-arcfpga/include/plat/irq.h
 create mode 100644 arch/arc/plat-arcfpga/include/plat/memmap.h
 create mode 100644 arch/arc/plat-arcfpga/include/plat/smp.h
 create mode 100644 arch/arc/plat-arcfpga/irq.c
 create mode 100644 arch/arc/plat-arcfpga/platform.c
 create mode 100644 arch/arc/plat-arcfpga/smp.c

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRMaClAAoJEGnX8d3iisJevncP/2hDe1rd0k5YzKQljNTBw7qH
e+8G2bvX4sYD1IX3d5ENXtlceis0b42uYcDNLvkm6UutnlWQf07Xetb+wezC/fAv
qj9rU/IVZni2m8tG6+O9rD/jKdJilQ8w77A8p+ygTDqvRe4deAwp5mu2f96ie03f
ELy7WZjRSdUcrEHjZ4W6CPVJ6/PS2fNzjJfE2m0eTVAvEywaxBt5XRjKhWnXDZ7p
DQQTLE62f9Dgk+M5sQcB9sXp7F9P9zABBSEwfE8SuiGUjhHWc018BRXtPkhGjNMW
CDlm5c8gdZM0AAfP/X/vf58x1oJ8C/so8/ZOtJh/b2m1idAIMKMeSM3qS5IG5I98
O4GW1n5PRfPTVSRPgrFUB0kWv4+hriVWi4i6ugX4tNEalWpy5BFg+iPRirELc8cp
PTRmmzD+lBPJX1hl3tde9ZdxsZpsmLUxyCYy75bbx0xh8FzPoU6gZpTafjMV9tvn
mxnHbKvEFIVAC9ntefiJx7Zte9xshk0yRaVYrzKWL1ARx9ux24yXQpGGBs0vkIaf
qo9MyLvdqrvnYjtMBh+lFd/5unn02UlNP1GsQ6f/wwq3JciR+Yvi+ictHYJhJ1yT
gbBlpDdm89WMqVqsUo0s/Q6vd0I7sASRXBETWlyG/fgstbkIQJTjMw+E8CSnD8LF
rvgT99yS45juZOC8aTZy
=szcU
-----END PGP SIGNATURE-----
