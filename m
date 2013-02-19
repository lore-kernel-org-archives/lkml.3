Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3BSL13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:27:29 -0500
Received: from multi.imgtec.com ([194.200.65.239]:21414 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab3BSL11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:27:27 -0500
Message-ID: <51236191.5070805@imgtec.com>
Date: Tue, 19 Feb 2013 11:27:13 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/metag for v3.9-rc1
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig10B5626ACFB9D3917423DBAE"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_19_11_27_22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig10B5626ACFB9D3917423DBAE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here is the arch/metag/ tree for v3.9-rc1. Arnd said he's happy to ack
it (the additional changes since then have been mostly further cleanups
and fixes for when merged with other trees).

Please pull.

Thanks
James

The following changes since commit 949db153b6466c6f7cad5a427ecea949859273=
11:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/met=
ag-v3.9-rc1

for you to fetch changes up to f1cbc24247f5cc7dc698d81d4963ec9a72681c50:

  metag: cleanup metag_ksyms.c includes (2013-02-15 10:33:11 +0000)

----------------------------------------------------------------
ImgTec Meta architecture changes for v3.9-rc1

This adds core architecture support for Imagination's Meta processor
cores, followed by some later miscellaneous Meta changes. A couple of
Rusty Russell's commits from the modules tree are merged mid way through
to get the extra argument to add_taint().

Signed-off-by: James Hogan <james.hogan@imgtec.com>

----------------------------------------------------------------
James Hogan (59):
      asm-generic/io.h: check CONFIG_VIRT_TO_BUS
      asm-generic/unistd.h: handle symbol prefixes in cond_syscall
      Revert some of "binfmt_elf: cleanups"
      Add HAVE_64BIT_ALIGNED_ACCESS
      trace/ring_buffer: handle 64bit aligned structs
      metag: Add MAINTAINERS entry
      metag: Headers for core arch constants
      metag: Header for core memory mapped registers
      metag: Boot
      metag: TBX header
      metag: TBX source
      metag: Cache/TLB handling
      metag: Memory management
      metag: Memory handling
      metag: Huge TLB
      metag: Highmem support
      metag: TCM support
      metag: Signal handling
      metag: Device tree
      metag: ptrace
      metag: Time keeping
      Merge commit 'taint: add explicit flag...' from modules tree
      metag: Traps
      metag: IRQ handling
      metag: Internal and external irqchips
      metag: System Calls
      metag: Scheduling/Process management
      metag: Module support
      metag: Atomics, locks and bitops
      metag: Basic documentation
      metag: SMP support
      metag: DMA
      metag: Optimised library functions
      metag: Stack unwinding
      metag: Various other headers
      mm: define VM_GROWSUP for CONFIG_METAG
      Kconfig.debug: add METAG to dependency lists
      metag: Build infrastructure
      metag: Perf
      metag: ftrace support
      scripts/checkstack.pl: Add metag support
      metag: Add JTAG Debug Adapter (DA) support
      metag: add __init to metag_cache_probe()
      metag: add boot time LNKGET/LNKSET check
      perf: Enable building perf tools for Meta
      metag: kernel/setup.c: sort includes
      metag: make TXPRIVEXT bits explicit
      metag: protect more non-MMU memory regions
      metag: export metag_code_cache_flush_all
      metag: export clear_page and copy_page
      metag: hugetlb: convert to vm_unmapped_area()
      genksyms: fix metag symbol prefix on crc symbols
      metag: move irq enable out of irqflags.h on SMP
      metag: move traps.c exports out of metag_ksyms.c
      metag: move kick.c exports out of metag_ksyms.c
      metag: move setup.c exports out of metag_ksyms.c
      metag: move usercopy.c exports out of metag_ksyms.c
      metag: move mm/init.c exports out of metag_ksyms.c
      metag: cleanup metag_ksyms.c includes

Rusty Russell (2):
      module: printk message when module signature fail taints kernel.
      taint: add explicit flag to show whether lock dep is still OK.

Stephen Rothwell (1):
      metag: min_low_pfn is now exported by generic code

 Documentation/00-INDEX                             |    2 +
 .../devicetree/bindings/metag/meta-intc.txt        |   82 ++
 Documentation/kernel-parameters.txt                |    4 +
 Documentation/metag/00-INDEX                       |    4 +
 Documentation/metag/kernel-ABI.txt                 |  256 ++++
 MAINTAINERS                                        |   12 +
 arch/Kconfig                                       |   16 +
 arch/alpha/kernel/traps.c                          |    2 +-
 arch/arm/kernel/traps.c                            |    2 +-
 arch/arm64/kernel/traps.c                          |    2 +-
 arch/avr32/kernel/traps.c                          |    2 +-
 arch/hexagon/kernel/traps.c                        |    2 +-
 arch/ia64/kernel/traps.c                           |    2 +-
 arch/m68k/kernel/traps.c                           |    2 +-
 arch/metag/Kconfig                                 |  295 ++++
 arch/metag/Kconfig.debug                           |   40 +
 arch/metag/Kconfig.soc                             |   55 +
 arch/metag/Makefile                                |   87 ++
 arch/metag/boot/.gitignore                         |    4 +
 arch/metag/boot/Makefile                           |   68 +
 arch/metag/boot/dts/Makefile                       |   16 +
 arch/metag/boot/dts/skeleton.dts                   |   10 +
 arch/metag/boot/dts/skeleton.dtsi                  |   14 +
 arch/metag/configs/meta1_defconfig                 |   41 +
 arch/metag/configs/meta2_defconfig                 |   42 +
 arch/metag/configs/meta2_smp_defconfig             |   43 +
 arch/metag/include/asm/Kbuild                      |   54 +
 arch/metag/include/asm/atomic.h                    |   53 +
 arch/metag/include/asm/atomic_lnkget.h             |  234 ++++
 arch/metag/include/asm/atomic_lock1.h              |  160 +++
 arch/metag/include/asm/barrier.h                   |   85 ++
 arch/metag/include/asm/bitops.h                    |  132 ++
 arch/metag/include/asm/bug.h                       |   12 +
 arch/metag/include/asm/cache.h                     |   23 +
 arch/metag/include/asm/cacheflush.h                |  250 ++++
 arch/metag/include/asm/cachepart.h                 |   42 +
 arch/metag/include/asm/checksum.h                  |   92 ++
 arch/metag/include/asm/clock.h                     |   51 +
 arch/metag/include/asm/cmpxchg.h                   |   65 +
 arch/metag/include/asm/cmpxchg_irq.h               |   42 +
 arch/metag/include/asm/cmpxchg_lnkget.h            |   86 ++
 arch/metag/include/asm/cmpxchg_lock1.h             |   48 +
 arch/metag/include/asm/core_reg.h                  |   35 +
 arch/metag/include/asm/cpu.h                       |   14 +
 arch/metag/include/asm/da.h                        |   43 +
 arch/metag/include/asm/delay.h                     |   29 +
 arch/metag/include/asm/div64.h                     |   12 +
 arch/metag/include/asm/dma-mapping.h               |  183 +++
 arch/metag/include/asm/elf.h                       |  128 ++
 arch/metag/include/asm/fixmap.h                    |   99 ++
 arch/metag/include/asm/ftrace.h                    |   23 +
 arch/metag/include/asm/global_lock.h               |  100 ++
 arch/metag/include/asm/gpio.h                      |    4 +
 arch/metag/include/asm/highmem.h                   |   62 +
 arch/metag/include/asm/hugetlb.h                   |   86 ++
 arch/metag/include/asm/hwthread.h                  |   40 +
 arch/metag/include/asm/io.h                        |  165 +++
 arch/metag/include/asm/irq.h                       |   32 +
 arch/metag/include/asm/irqflags.h                  |   93 ++
 arch/metag/include/asm/l2cache.h                   |  258 ++++
 arch/metag/include/asm/linkage.h                   |    7 +
 arch/metag/include/asm/mach/arch.h                 |   86 ++
 arch/metag/include/asm/metag_isa.h                 |   81 ++
 arch/metag/include/asm/metag_mem.h                 | 1106 ++++++++++++++=
+
 arch/metag/include/asm/metag_regs.h                | 1184 ++++++++++++++=
++
 arch/metag/include/asm/mman.h                      |   11 +
 arch/metag/include/asm/mmu.h                       |   77 ++
 arch/metag/include/asm/mmu_context.h               |  113 ++
 arch/metag/include/asm/mmzone.h                    |   42 +
 arch/metag/include/asm/module.h                    |   37 +
 arch/metag/include/asm/page.h                      |  128 ++
 arch/metag/include/asm/perf_event.h                |    4 +
 arch/metag/include/asm/pgalloc.h                   |   79 ++
 arch/metag/include/asm/pgtable.h                   |  370 +++++
 arch/metag/include/asm/processor.h                 |  202 +++
 arch/metag/include/asm/prom.h                      |   23 +
 arch/metag/include/asm/ptrace.h                    |   60 +
 arch/metag/include/asm/setup.h                     |    8 +
 arch/metag/include/asm/smp.h                       |   29 +
 arch/metag/include/asm/sparsemem.h                 |   13 +
 arch/metag/include/asm/spinlock.h                  |   22 +
 arch/metag/include/asm/spinlock_lnkget.h           |  249 ++++
 arch/metag/include/asm/spinlock_lock1.h            |  184 +++
 arch/metag/include/asm/spinlock_types.h            |   20 +
 arch/metag/include/asm/stacktrace.h                |   20 +
 arch/metag/include/asm/string.h                    |   13 +
 arch/metag/include/asm/switch.h                    |   21 +
 arch/metag/include/asm/syscall.h                   |  104 ++
 arch/metag/include/asm/syscalls.h                  |   39 +
 arch/metag/include/asm/tbx.h                       | 1425 ++++++++++++++=
++++++
 arch/metag/include/asm/tcm.h                       |   30 +
 arch/metag/include/asm/thread_info.h               |  155 +++
 arch/metag/include/asm/tlb.h                       |   36 +
 arch/metag/include/asm/tlbflush.h                  |   77 ++
 arch/metag/include/asm/topology.h                  |   53 +
 arch/metag/include/asm/traps.h                     |   48 +
 arch/metag/include/asm/uaccess.h                   |  241 ++++
 arch/metag/include/asm/unistd.h                    |   12 +
 arch/metag/include/asm/user_gateway.h              |   44 +
 arch/metag/include/uapi/asm/Kbuild                 |   13 +
 arch/metag/include/uapi/asm/byteorder.h            |    1 +
 arch/metag/include/uapi/asm/ptrace.h               |  113 ++
 arch/metag/include/uapi/asm/resource.h             |    7 +
 arch/metag/include/uapi/asm/sigcontext.h           |   31 +
 arch/metag/include/uapi/asm/siginfo.h              |    8 +
 arch/metag/include/uapi/asm/swab.h                 |   26 +
 arch/metag/include/uapi/asm/unistd.h               |   21 +
 arch/metag/kernel/.gitignore                       |    1 +
 arch/metag/kernel/Makefile                         |   39 +
 arch/metag/kernel/asm-offsets.c                    |   14 +
 arch/metag/kernel/cachepart.c                      |  124 ++
 arch/metag/kernel/clock.c                          |   53 +
 arch/metag/kernel/core_reg.c                       |  117 ++
 arch/metag/kernel/da.c                             |   23 +
 arch/metag/kernel/devtree.c                        |   97 ++
 arch/metag/kernel/dma.c                            |  507 +++++++
 arch/metag/kernel/ftrace.c                         |  126 ++
 arch/metag/kernel/ftrace_stub.S                    |   76 ++
 arch/metag/kernel/head.S                           |   57 +
 arch/metag/kernel/irq.c                            |  323 +++++
 arch/metag/kernel/kick.c                           |  101 ++
 arch/metag/kernel/machines.c                       |   20 +
 arch/metag/kernel/metag_ksyms.c                    |   48 +
 arch/metag/kernel/module.c                         |  284 ++++
 arch/metag/kernel/perf/Makefile                    |    3 +
 arch/metag/kernel/perf/perf_event.c                |  861 ++++++++++++
 arch/metag/kernel/perf/perf_event.h                |  106 ++
 arch/metag/kernel/perf_callchain.c                 |   96 ++
 arch/metag/kernel/process.c                        |  461 +++++++
 arch/metag/kernel/ptrace.c                         |  380 ++++++
 arch/metag/kernel/setup.c                          |  629 +++++++++
 arch/metag/kernel/signal.c                         |  344 +++++
 arch/metag/kernel/smp.c                            |  575 ++++++++
 arch/metag/kernel/stacktrace.c                     |  187 +++
 arch/metag/kernel/sys_metag.c                      |  180 +++
 arch/metag/kernel/tbiunexp.S                       |   22 +
 arch/metag/kernel/tcm.c                            |  151 +++
 arch/metag/kernel/time.c                           |   15 +
 arch/metag/kernel/topology.c                       |   77 ++
 arch/metag/kernel/traps.c                          |  995 ++++++++++++++=

 arch/metag/kernel/user_gateway.S                   |   97 ++
 arch/metag/kernel/vmlinux.lds.S                    |   71 +
 arch/metag/lib/Makefile                            |   22 +
 arch/metag/lib/ashldi3.S                           |   33 +
 arch/metag/lib/ashrdi3.S                           |   33 +
 arch/metag/lib/checksum.c                          |  168 +++
 arch/metag/lib/clear_page.S                        |   17 +
 arch/metag/lib/cmpdi2.S                            |   32 +
 arch/metag/lib/copy_page.S                         |   20 +
 arch/metag/lib/delay.c                             |   56 +
 arch/metag/lib/div64.S                             |  108 ++
 arch/metag/lib/divsi3.S                            |  100 ++
 arch/metag/lib/ip_fast_csum.S                      |   32 +
 arch/metag/lib/lshrdi3.S                           |   33 +
 arch/metag/lib/memcpy.S                            |  185 +++
 arch/metag/lib/memmove.S                           |  345 +++++
 arch/metag/lib/memset.S                            |   86 ++
 arch/metag/lib/modsi3.S                            |   38 +
 arch/metag/lib/muldi3.S                            |   44 +
 arch/metag/lib/ucmpdi2.S                           |   27 +
 arch/metag/lib/usercopy.c                          | 1354 ++++++++++++++=
+++++
 arch/metag/mm/Kconfig                              |  153 +++
 arch/metag/mm/Makefile                             |   19 +
 arch/metag/mm/cache.c                              |  521 +++++++
 arch/metag/mm/extable.c                            |   15 +
 arch/metag/mm/fault.c                              |  239 ++++
 arch/metag/mm/highmem.c                            |  133 ++
 arch/metag/mm/hugetlbpage.c                        |  259 ++++
 arch/metag/mm/init.c                               |  451 +++++++
 arch/metag/mm/ioremap.c                            |   89 ++
 arch/metag/mm/l2cache.c                            |  192 +++
 arch/metag/mm/maccess.c                            |   68 +
 arch/metag/mm/mmu-meta1.c                          |  157 +++
 arch/metag/mm/mmu-meta2.c                          |  207 +++
 arch/metag/mm/numa.c                               |   81 ++
 arch/metag/tbx/Makefile                            |   21 +
 arch/metag/tbx/tbicore.S                           |  136 ++
 arch/metag/tbx/tbictx.S                            |  366 +++++
 arch/metag/tbx/tbictxfpu.S                         |  190 +++
 arch/metag/tbx/tbidefr.S                           |  175 +++
 arch/metag/tbx/tbidspram.S                         |  161 +++
 arch/metag/tbx/tbilogf.S                           |   48 +
 arch/metag/tbx/tbipcx.S                            |  451 +++++++
 arch/metag/tbx/tbiroot.S                           |   87 ++
 arch/metag/tbx/tbisoft.S                           |  237 ++++
 arch/metag/tbx/tbistring.c                         |  114 ++
 arch/metag/tbx/tbitimer.S                          |  207 +++
 arch/mips/kernel/traps.c                           |    2 +-
 arch/parisc/kernel/traps.c                         |    2 +-
 arch/powerpc/kernel/traps.c                        |    2 +-
 arch/s390/kernel/traps.c                           |    2 +-
 arch/sh/kernel/traps.c                             |    2 +-
 arch/sparc/kernel/setup_64.c                       |    2 +-
 arch/sparc/kernel/traps_32.c                       |    2 +-
 arch/sparc/kernel/traps_64.c                       |    2 +-
 arch/unicore32/kernel/traps.c                      |    2 +-
 arch/x86/kernel/cpu/amd.c                          |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   |    2 +-
 arch/x86/kernel/cpu/mcheck/p5.c                    |    2 +-
 arch/x86/kernel/cpu/mcheck/winchip.c               |    2 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |    2 +-
 arch/x86/kernel/dumpstack.c                        |    2 +-
 arch/xtensa/kernel/traps.c                         |    2 +-
 drivers/acpi/custom_method.c                       |    2 +-
 drivers/acpi/osl.c                                 |    2 +-
 drivers/base/regmap/regmap-debugfs.c               |    2 +-
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/metag_generic.c                |  198 +++
 drivers/irqchip/Makefile                           |    2 +
 drivers/irqchip/irq-metag-ext.c                    |  868 ++++++++++++
 drivers/irqchip/irq-metag.c                        |  343 +++++
 fs/binfmt_elf.c                                    |    4 +
 include/asm-generic/io.h                           |    2 +
 include/asm-generic/unistd.h                       |    9 +-
 include/clocksource/metag_generic.h                |   21 +
 include/linux/irqchip/metag-ext.h                  |   33 +
 include/linux/irqchip/metag.h                      |   24 +
 include/linux/kernel.h                             |    6 +-
 include/linux/mm.h                                 |    2 +
 include/uapi/linux/elf.h                           |    2 +
 kernel/module.c                                    |   33 +-
 kernel/panic.c                                     |   34 +-
 kernel/sched/core.c                                |    2 +-
 kernel/sysctl.c                                    |    2 +-
 kernel/trace/ring_buffer.c                         |    6 +-
 lib/Kconfig.debug                                  |    4 +-
 lib/bug.c                                          |    3 +-
 mm/memory.c                                        |    2 +-
 mm/page_alloc.c                                    |    2 +-
 mm/slab.c                                          |    2 +-
 mm/slub.c                                          |    2 +-
 scripts/checkstack.pl                              |    8 +-
 scripts/genksyms/genksyms.c                        |    3 +-
 scripts/recordmcount.c                             |   13 +
 sound/soc/soc-core.c                               |    2 +-
 tools/perf/perf.h                                  |    6 +
 237 files changed, 26990 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/metag/meta-intc.txt=

 create mode 100644 Documentation/metag/00-INDEX
 create mode 100644 Documentation/metag/kernel-ABI.txt
 create mode 100644 arch/metag/Kconfig
 create mode 100644 arch/metag/Kconfig.debug
 create mode 100644 arch/metag/Kconfig.soc
 create mode 100644 arch/metag/Makefile
 create mode 100644 arch/metag/boot/.gitignore
 create mode 100644 arch/metag/boot/Makefile
 create mode 100644 arch/metag/boot/dts/Makefile
 create mode 100644 arch/metag/boot/dts/skeleton.dts
 create mode 100644 arch/metag/boot/dts/skeleton.dtsi
 create mode 100644 arch/metag/configs/meta1_defconfig
 create mode 100644 arch/metag/configs/meta2_defconfig
 create mode 100644 arch/metag/configs/meta2_smp_defconfig
 create mode 100644 arch/metag/include/asm/Kbuild
 create mode 100644 arch/metag/include/asm/atomic.h
 create mode 100644 arch/metag/include/asm/atomic_lnkget.h
 create mode 100644 arch/metag/include/asm/atomic_lock1.h
 create mode 100644 arch/metag/include/asm/barrier.h
 create mode 100644 arch/metag/include/asm/bitops.h
 create mode 100644 arch/metag/include/asm/bug.h
 create mode 100644 arch/metag/include/asm/cache.h
 create mode 100644 arch/metag/include/asm/cacheflush.h
 create mode 100644 arch/metag/include/asm/cachepart.h
 create mode 100644 arch/metag/include/asm/checksum.h
 create mode 100644 arch/metag/include/asm/clock.h
 create mode 100644 arch/metag/include/asm/cmpxchg.h
 create mode 100644 arch/metag/include/asm/cmpxchg_irq.h
 create mode 100644 arch/metag/include/asm/cmpxchg_lnkget.h
 create mode 100644 arch/metag/include/asm/cmpxchg_lock1.h
 create mode 100644 arch/metag/include/asm/core_reg.h
 create mode 100644 arch/metag/include/asm/cpu.h
 create mode 100644 arch/metag/include/asm/da.h
 create mode 100644 arch/metag/include/asm/delay.h
 create mode 100644 arch/metag/include/asm/div64.h
 create mode 100644 arch/metag/include/asm/dma-mapping.h
 create mode 100644 arch/metag/include/asm/elf.h
 create mode 100644 arch/metag/include/asm/fixmap.h
 create mode 100644 arch/metag/include/asm/ftrace.h
 create mode 100644 arch/metag/include/asm/global_lock.h
 create mode 100644 arch/metag/include/asm/gpio.h
 create mode 100644 arch/metag/include/asm/highmem.h
 create mode 100644 arch/metag/include/asm/hugetlb.h
 create mode 100644 arch/metag/include/asm/hwthread.h
 create mode 100644 arch/metag/include/asm/io.h
 create mode 100644 arch/metag/include/asm/irq.h
 create mode 100644 arch/metag/include/asm/irqflags.h
 create mode 100644 arch/metag/include/asm/l2cache.h
 create mode 100644 arch/metag/include/asm/linkage.h
 create mode 100644 arch/metag/include/asm/mach/arch.h
 create mode 100644 arch/metag/include/asm/metag_isa.h
 create mode 100644 arch/metag/include/asm/metag_mem.h
 create mode 100644 arch/metag/include/asm/metag_regs.h
 create mode 100644 arch/metag/include/asm/mman.h
 create mode 100644 arch/metag/include/asm/mmu.h
 create mode 100644 arch/metag/include/asm/mmu_context.h
 create mode 100644 arch/metag/include/asm/mmzone.h
 create mode 100644 arch/metag/include/asm/module.h
 create mode 100644 arch/metag/include/asm/page.h
 create mode 100644 arch/metag/include/asm/perf_event.h
 create mode 100644 arch/metag/include/asm/pgalloc.h
 create mode 100644 arch/metag/include/asm/pgtable.h
 create mode 100644 arch/metag/include/asm/processor.h
 create mode 100644 arch/metag/include/asm/prom.h
 create mode 100644 arch/metag/include/asm/ptrace.h
 create mode 100644 arch/metag/include/asm/setup.h
 create mode 100644 arch/metag/include/asm/smp.h
 create mode 100644 arch/metag/include/asm/sparsemem.h
 create mode 100644 arch/metag/include/asm/spinlock.h
 create mode 100644 arch/metag/include/asm/spinlock_lnkget.h
 create mode 100644 arch/metag/include/asm/spinlock_lock1.h
 create mode 100644 arch/metag/include/asm/spinlock_types.h
 create mode 100644 arch/metag/include/asm/stacktrace.h
 create mode 100644 arch/metag/include/asm/string.h
 create mode 100644 arch/metag/include/asm/switch.h
 create mode 100644 arch/metag/include/asm/syscall.h
 create mode 100644 arch/metag/include/asm/syscalls.h
 create mode 100644 arch/metag/include/asm/tbx.h
 create mode 100644 arch/metag/include/asm/tcm.h
 create mode 100644 arch/metag/include/asm/thread_info.h
 create mode 100644 arch/metag/include/asm/tlb.h
 create mode 100644 arch/metag/include/asm/tlbflush.h
 create mode 100644 arch/metag/include/asm/topology.h
 create mode 100644 arch/metag/include/asm/traps.h
 create mode 100644 arch/metag/include/asm/uaccess.h
 create mode 100644 arch/metag/include/asm/unistd.h
 create mode 100644 arch/metag/include/asm/user_gateway.h
 create mode 100644 arch/metag/include/uapi/asm/Kbuild
 create mode 100644 arch/metag/include/uapi/asm/byteorder.h
 create mode 100644 arch/metag/include/uapi/asm/ptrace.h
 create mode 100644 arch/metag/include/uapi/asm/resource.h
 create mode 100644 arch/metag/include/uapi/asm/sigcontext.h
 create mode 100644 arch/metag/include/uapi/asm/siginfo.h
 create mode 100644 arch/metag/include/uapi/asm/swab.h
 create mode 100644 arch/metag/include/uapi/asm/unistd.h
 create mode 100644 arch/metag/kernel/.gitignore
 create mode 100644 arch/metag/kernel/Makefile
 create mode 100644 arch/metag/kernel/asm-offsets.c
 create mode 100644 arch/metag/kernel/cachepart.c
 create mode 100644 arch/metag/kernel/clock.c
 create mode 100644 arch/metag/kernel/core_reg.c
 create mode 100644 arch/metag/kernel/da.c
 create mode 100644 arch/metag/kernel/devtree.c
 create mode 100644 arch/metag/kernel/dma.c
 create mode 100644 arch/metag/kernel/ftrace.c
 create mode 100644 arch/metag/kernel/ftrace_stub.S
 create mode 100644 arch/metag/kernel/head.S
 create mode 100644 arch/metag/kernel/irq.c
 create mode 100644 arch/metag/kernel/kick.c
 create mode 100644 arch/metag/kernel/machines.c
 create mode 100644 arch/metag/kernel/metag_ksyms.c
 create mode 100644 arch/metag/kernel/module.c
 create mode 100644 arch/metag/kernel/perf/Makefile
 create mode 100644 arch/metag/kernel/perf/perf_event.c
 create mode 100644 arch/metag/kernel/perf/perf_event.h
 create mode 100644 arch/metag/kernel/perf_callchain.c
 create mode 100644 arch/metag/kernel/process.c
 create mode 100644 arch/metag/kernel/ptrace.c
 create mode 100644 arch/metag/kernel/setup.c
 create mode 100644 arch/metag/kernel/signal.c
 create mode 100644 arch/metag/kernel/smp.c
 create mode 100644 arch/metag/kernel/stacktrace.c
 create mode 100644 arch/metag/kernel/sys_metag.c
 create mode 100644 arch/metag/kernel/tbiunexp.S
 create mode 100644 arch/metag/kernel/tcm.c
 create mode 100644 arch/metag/kernel/time.c
 create mode 100644 arch/metag/kernel/topology.c
 create mode 100644 arch/metag/kernel/traps.c
 create mode 100644 arch/metag/kernel/user_gateway.S
 create mode 100644 arch/metag/kernel/vmlinux.lds.S
 create mode 100644 arch/metag/lib/Makefile
 create mode 100644 arch/metag/lib/ashldi3.S
 create mode 100644 arch/metag/lib/ashrdi3.S
 create mode 100644 arch/metag/lib/checksum.c
 create mode 100644 arch/metag/lib/clear_page.S
 create mode 100644 arch/metag/lib/cmpdi2.S
 create mode 100644 arch/metag/lib/copy_page.S
 create mode 100644 arch/metag/lib/delay.c
 create mode 100644 arch/metag/lib/div64.S
 create mode 100644 arch/metag/lib/divsi3.S
 create mode 100644 arch/metag/lib/ip_fast_csum.S
 create mode 100644 arch/metag/lib/lshrdi3.S
 create mode 100644 arch/metag/lib/memcpy.S
 create mode 100644 arch/metag/lib/memmove.S
 create mode 100644 arch/metag/lib/memset.S
 create mode 100644 arch/metag/lib/modsi3.S
 create mode 100644 arch/metag/lib/muldi3.S
 create mode 100644 arch/metag/lib/ucmpdi2.S
 create mode 100644 arch/metag/lib/usercopy.c
 create mode 100644 arch/metag/mm/Kconfig
 create mode 100644 arch/metag/mm/Makefile
 create mode 100644 arch/metag/mm/cache.c
 create mode 100644 arch/metag/mm/extable.c
 create mode 100644 arch/metag/mm/fault.c
 create mode 100644 arch/metag/mm/highmem.c
 create mode 100644 arch/metag/mm/hugetlbpage.c
 create mode 100644 arch/metag/mm/init.c
 create mode 100644 arch/metag/mm/ioremap.c
 create mode 100644 arch/metag/mm/l2cache.c
 create mode 100644 arch/metag/mm/maccess.c
 create mode 100644 arch/metag/mm/mmu-meta1.c
 create mode 100644 arch/metag/mm/mmu-meta2.c
 create mode 100644 arch/metag/mm/numa.c
 create mode 100644 arch/metag/tbx/Makefile
 create mode 100644 arch/metag/tbx/tbicore.S
 create mode 100644 arch/metag/tbx/tbictx.S
 create mode 100644 arch/metag/tbx/tbictxfpu.S
 create mode 100644 arch/metag/tbx/tbidefr.S
 create mode 100644 arch/metag/tbx/tbidspram.S
 create mode 100644 arch/metag/tbx/tbilogf.S
 create mode 100644 arch/metag/tbx/tbipcx.S
 create mode 100644 arch/metag/tbx/tbiroot.S
 create mode 100644 arch/metag/tbx/tbisoft.S
 create mode 100644 arch/metag/tbx/tbistring.c
 create mode 100644 arch/metag/tbx/tbitimer.S
 create mode 100644 drivers/clocksource/metag_generic.c
 create mode 100644 drivers/irqchip/irq-metag-ext.c
 create mode 100644 drivers/irqchip/irq-metag.c
 create mode 100644 include/clocksource/metag_generic.h
 create mode 100644 include/linux/irqchip/metag-ext.h
 create mode 100644 include/linux/irqchip/metag.h


--------------enig10B5626ACFB9D3917423DBAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRI2GZAAoJEKHZs+irPybfvIkP/28Vsde5DaQTix3MMmy2a2Jx
3TPdWwFDGGIlSxb4DAA6vmIqFxjIvAr85JsoF7Hgxv1IzoRILpUImh6OJvnZvmbA
Zwg0NqDZn20Su9PoH935hNaGhW0zLs6Z7jZlawklVEVv8RJlzLZRdJzVs2fWGls7
73xYAysng5D7td03sBWSAjPRzNg/4x6MtH0J8rkOqcYOYDgROGzyiEm1h1DM2Ypv
5txYY+1kXIr3AKjDZBBUOF1o2ju0L5bGn6rO6FvZ1SsvcWPIscrPwzfODoj6YuxH
C+sfM9B0p+a72hSQoLbkhVG4GFm1OaXcQd0y4L5yRtyKufUTwpENaUlj4CTJ1f9Y
dZ7P4Fn1qovetlqRwrp4uns8QvjyU/xPLXJNGclwWzIFV39LnLliko3ApdoadUlL
vukiBEuQMwupBSYDQXL6QmSxqMM89zwnTESifKrNrI5qlwVEcPuKb4mopTHSdRYT
6+RozSyD0wvvY++TFOEkoOC/2IWeBcqb+mj7TOMvoyu1mm5q6VStRHUmSIBjb1q5
uA4AHO/vhzETI6CB5RMAQ2CVlCjI6tcH3Js+KwfAcKPHA/rQOFPH6I/nmC8AoxJK
sFw8V65Iylu0wdeFeRb4YbwRsx1dVh91qTkKsZMzPCmrOO3sVCWJ7S2VRa6/Fzxb
1NTdR8/7qoKYbPkZwYkA
=NnAY
-----END PGP SIGNATURE-----

--------------enig10B5626ACFB9D3917423DBAE--

