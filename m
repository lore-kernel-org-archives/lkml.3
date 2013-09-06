Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab3IFRvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:51:40 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:25932 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3IFRvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:51:37 -0400
Message-ID: <522A1627.3050900@tilera.com>
Date: Fri, 6 Sep 2013 13:51:35 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arch/tile changes for v3.12
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.12 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These changes bring in a bunch of new functionality that has been
maintained internally at Tilera over the last year, plus other stray
bits of work that I've taken into the tile tree from other folks.
The changes include some PCI root complex work, interrupt-driven console
support, support for performing fast-path unaligned data fixups by
kernel-based JIT code generation, CONFIG_PREEMPT support, vDSO support
for gettimeofday(), a serial driver for the tilegx on-chip UART,
KGDB support, more optimized string routines, support for ftrace and
kprobes, improved ASLR, and many bug fixes.  We also remove support for
the old TILE64 chip, which is no longer buildable.

Akinobu Mita (1):
      tile: use asm-generic/bitops/builtin-*.h

Chen Gang (1):
      arch: tile: include: asm: add cmpxchg64() definition

Chris Metcalf (77):
      tile: various minor cleanups to hardwall subsystem
      tile: convert uses of "inv" to "finv"
      tile: optimize and clean up string functions
      tile PCI RC: cleanups for tilepro PCI RC
      tile PCI RC: tilepro conflict with PCI and RAM addresses
      tile PCI RC: support pci=off boot arg for tilepro
      tile PCI RC: tweak the the pcie_rc_delay support
      tile PCI RC: handle case that PCI link is already up
      tile: support LSI MEGARAID SAS HBA hybrid dma_ops
      tile PCI RC: support more MSI-X interrupt vectors
      tile PCI RC: gentler warning for missing plug-in PCI
      tile PCI RC: support I/O space access
      tile PCI DMA: handle a NULL dev argument properly
      tile PCI RC: restructure TRIO initialization
      tile PCI RC: eliminate pci_controller.mem_resources field
      tile PCI RC: include pci/pcie/Kconfig
      tile PCI RC: bomb comments and whitespace format
      tile PCI RC: use proper accessor function
      tile PCI RC: add dma_get_required_mask()
      tile PCI DMA: fix bug in non-page-aligned accessors
      tile PCI RC: support PCIe TRIO 0 MAC 0 on Gx72 system
      tile PCI RC: reduce driver's vmalloc space usage
      tile PCI RC: remove stale include of linux/numa.h
      tile: various console improvements
      tile: support "memmap" boot parameter
      tile: fix comment bug in sys_cmpxchg description
      tile: fix tilegx vmalloc_sync_all BUG_ON
      tile: remove unnecessary backslashes in asm-offsets.c
      tile: fast-path unaligned memory access for tilegx
      tile: avoid recursive backtrace faults
      tile: add some tile drivers to MAINTAINERS
      tile: fix some issues in hugepage support
      tile: remove calls to arch_flush_lazy_mmu_mode()
      tile: support CONFIG_PREEMPT
      tile: improve big-endian support
      tile: make register dumps more readable
      tile: improve illegal translation interrupt handling
      tile: support simulator notification for ET_DYN objects
      tile: implement gettimeofday() via vDSO
      tile: avoid struct vm_struct leak
      tile: provide traceability for hypervisor calls
      tile: use proper .align directives on __ex_table sections
      tile: fix panic with large IRQ number
      tile: correct r1 value during syscall tracing
      tile: allow "initrd" boot argument for kexec
      tile: do less L1 I-cache eviction
      tile: remove set/clear_fixmap APIs
      tile: fix strncpy_from_user bug
      tile: group .hottext* sections properly in vmlinux.lds
      tile: fix some -Wsign-compare warnings
      tile: don't call show_regs_print_info() with corrupt current
      tilegx: change how we find the kernel stack
      tile: handle super huge pages in virt_to_pte
      tile: clean up relocate_kernel_64 debug code
      tile: don't assume user privilege is zero
      tile: parameterize VA and PA space more cleanly
      tilegx: provide kernel support for the tilegx UART shim
      tilegx: Add tty serial support for TILE-Gx on-chip UART
      tilegx: support KGDB
      tile: support reporting Tilera hypervisor statistics
      tile: support FRAME_POINTER
      tile: add virt_to_kpte() API and clean up and document behavior
      tile: remove DEBUG_EXTRA_FLAGS kernel config option
      tile PCI RC: add comment about "PCI hole" problem
      tile: use asm-generic version of <asm/local64.h>
      tile: use standard 'generic-y' model for <asm/hw_irq.h>
      tile: check for correct compiler earlier in asm-offsets.c
      tile: mark pcibios_init() as __init
      tile: change <asm/system.h> to <asm/switch_to.h> in comments
      tile: simplify code referencing hypervisor API addresses
      tile: use standard tile_bundle_bits type in traps.c
      tile: eliminate no-op "noatomichash" boot argument
      tile: remove support for TILE64
      tile: make __write_once a synonym for __read_mostly
      tile PCI RC: make default consistent DMA mask 32-bit
      tile: rework <asm/cmpxchg.h>
      tile: refresh tile defconfig files

Ken Steele (1):
      tile: optimize strnlen using SIMD instructions

Sachin Kamat (1):
      edac: Remove redundant platform_set_drvdata()

Tony Lu (3):
      tile: support ftrace on tilegx
      tile: support kprobes on tilegx
      tile: support ASLR fully

Wang Sheng-Hui (1):
      tile: add null check for kzalloc in tile/kernel/setup.c

 MAINTAINERS                                  |    9 +-
 arch/tile/Kconfig                            |   31 +-
 arch/tile/Kconfig.debug                      |   14 +-
 arch/tile/Makefile                           |    4 -
 arch/tile/configs/tilegx_defconfig           |  241 +---
 arch/tile/configs/tilepro_defconfig          |   87 +-
 arch/tile/gxio/Kconfig                       |    5 +
 arch/tile/gxio/Makefile                      |    1 +
 arch/tile/gxio/iorpc_trio.c                  |   23 +
 arch/tile/gxio/iorpc_uart.c                  |   77 ++
 arch/tile/gxio/uart.c                        |   87 ++
 arch/tile/include/arch/trio.h                |   39 +
 arch/tile/include/arch/uart.h                |  300 +++++
 arch/tile/include/arch/uart_def.h            |  120 ++
 arch/tile/include/asm/Kbuild                 |    3 +-
 arch/tile/include/asm/atomic.h               |   52 +
 arch/tile/include/asm/atomic_32.h            |  102 +-
 arch/tile/include/asm/atomic_64.h            |   42 +-
 arch/tile/include/asm/barrier.h              |    4 -
 arch/tile/include/asm/bitops.h               |   41 +-
 arch/tile/include/asm/bitops_32.h            |    2 +-
 arch/tile/include/asm/bitops_64.h            |    8 +-
 arch/tile/include/asm/cache.h                |   13 +-
 arch/tile/include/asm/cacheflush.h           |   44 +-
 arch/tile/include/asm/cmpxchg.h              |   93 +-
 arch/tile/include/asm/device.h               |    5 +-
 arch/tile/include/asm/dma-mapping.h          |   27 +-
 arch/tile/include/asm/elf.h                  |   10 +-
 arch/tile/include/asm/fixmap.h               |    8 -
 arch/tile/include/asm/ftrace.h               |   22 +-
 arch/tile/include/asm/futex.h                |    1 +
 arch/tile/include/asm/homecache.h            |   11 +-
 arch/tile/include/asm/io.h                   |  132 ++-
 arch/tile/include/asm/irqflags.h             |   21 +-
 arch/tile/include/asm/{hw_irq.h => kdebug.h} |   18 +-
 arch/tile/include/asm/kgdb.h                 |   71 ++
 arch/tile/include/asm/kprobes.h              |   79 ++
 arch/tile/include/asm/mmu.h                  |    1 +
 arch/tile/include/asm/mmu_context.h          |    2 +-
 arch/tile/include/asm/mmzone.h               |    2 +-
 arch/tile/include/asm/page.h                 |   61 +-
 arch/tile/include/asm/pci.h                  |   22 +-
 arch/tile/include/asm/pgtable_32.h           |    4 +-
 arch/tile/include/asm/pgtable_64.h           |   27 +-
 arch/tile/include/asm/processor.h            |   84 +-
 arch/tile/include/asm/ptrace.h               |    6 +-
 arch/tile/include/asm/sections.h             |    8 +-
 arch/tile/include/asm/setup.h                |    3 +-
 arch/tile/include/asm/smp.h                  |    2 -
 arch/tile/include/asm/spinlock_64.h          |    4 +-
 arch/tile/include/asm/string.h               |    2 +
 arch/tile/include/asm/thread_info.h          |    6 +
 arch/tile/include/asm/traps.h                |   13 +-
 arch/tile/include/asm/uaccess.h              |   37 +-
 arch/tile/include/asm/unaligned.h            |   14 +-
 arch/tile/include/asm/vdso.h                 |   49 +
 arch/tile/include/gxio/iorpc_trio.h          |    5 +
 arch/tile/include/gxio/iorpc_uart.h          |   40 +
 arch/tile/include/gxio/uart.h                |  105 ++
 arch/tile/include/hv/drv_trio_intf.h         |    8 +-
 arch/tile/include/hv/drv_uart_intf.h         |   33 +
 arch/tile/include/hv/hypervisor.h            |   61 +-
 arch/tile/include/uapi/arch/Kbuild           |    1 -
 arch/tile/include/uapi/arch/chip.h           |    4 +-
 arch/tile/include/uapi/arch/chip_tile64.h    |  258 -----
 arch/tile/include/uapi/arch/opcode_tilegx.h  |    1 +
 arch/tile/include/uapi/arch/opcode_tilepro.h |    1 +
 arch/tile/include/uapi/arch/spr_def_32.h     |    2 -
 arch/tile/include/uapi/asm/auxvec.h          |    3 +-
 arch/tile/include/uapi/asm/cachectl.h        |    4 +-
 arch/tile/kernel/Makefile                    |   16 +-
 arch/tile/kernel/asm-offsets.c               |   52 +-
 arch/tile/kernel/compat_signal.c             |    3 +-
 arch/tile/kernel/early_printk.c              |   47 +-
 arch/tile/kernel/entry.S                     |   16 -
 arch/tile/kernel/ftrace.c                    |  246 ++++
 arch/tile/kernel/hardwall.c                  |   28 +-
 arch/tile/kernel/head_32.S                   |   17 +-
 arch/tile/kernel/head_64.S                   |   46 +-
 arch/tile/kernel/hvglue.S                    |   74 ++
 arch/tile/kernel/hvglue.lds                  |   59 -
 arch/tile/kernel/hvglue_trace.c              |  266 +++++
 arch/tile/kernel/intvec_32.S                 |  114 +-
 arch/tile/kernel/intvec_64.S                 |  305 ++++-
 arch/tile/kernel/irq.c                       |    8 +-
 arch/tile/kernel/kgdb.c                      |  499 ++++++++
 arch/tile/kernel/kprobes.c                   |  528 +++++++++
 arch/tile/kernel/mcount_64.S                 |  224 ++++
 arch/tile/kernel/pci-dma.c                   |   74 +-
 arch/tile/kernel/pci.c                       |   33 +-
 arch/tile/kernel/pci_gx.c                    |  727 +++++++-----
 arch/tile/kernel/proc.c                      |    2 -
 arch/tile/kernel/process.c                   |  116 +-
 arch/tile/kernel/ptrace.c                    |   19 +-
 arch/tile/kernel/reboot.c                    |    2 -
 arch/tile/kernel/regs_32.S                   |    4 +-
 arch/tile/kernel/regs_64.S                   |    4 +-
 arch/tile/kernel/relocate_kernel_32.S        |   27 +-
 arch/tile/kernel/relocate_kernel_64.S        |   11 +-
 arch/tile/kernel/setup.c                     |  162 ++-
 arch/tile/kernel/signal.c                    |    3 +-
 arch/tile/kernel/single_step.c               |  118 +-
 arch/tile/kernel/smp.c                       |   22 +-
 arch/tile/kernel/smpboot.c                   |    8 +-
 arch/tile/kernel/stack.c                     |   51 +-
 arch/tile/kernel/sys.c                       |    4 +-
 arch/tile/kernel/sysfs.c                     |   76 ++
 arch/tile/kernel/time.c                      |   37 +-
 arch/tile/kernel/tlb.c                       |    8 +-
 arch/tile/kernel/traps.c                     |   89 +-
 arch/tile/kernel/unaligned.c                 | 1609 ++++++++++++++++++++++++++
 arch/tile/kernel/vdso.c                      |  212 ++++
 arch/tile/kernel/vdso/Makefile               |  118 ++
 arch/tile/kernel/vdso/vdso.S                 |   28 +
 arch/tile/kernel/vdso/vdso.lds.S             |   87 ++
 arch/tile/kernel/vdso/vdso32.S               |   28 +
 arch/tile/kernel/vdso/vgettimeofday.c        |  107 ++
 arch/tile/kernel/vdso/vrt_sigreturn.S        |   30 +
 arch/tile/kernel/vmlinux.lds.S               |   31 +-
 arch/tile/lib/Makefile                       |   16 +-
 arch/tile/lib/atomic_32.c                    |  133 +--
 arch/tile/lib/atomic_asm_32.S                |    1 +
 arch/tile/lib/cacheflush.c                   |   16 +-
 arch/tile/lib/exports.c                      |    7 +-
 arch/tile/lib/memchr_64.c                    |    2 +-
 arch/tile/lib/memcpy_32.S                    |   63 +-
 arch/tile/lib/memcpy_64.c                    |  264 +++--
 arch/tile/lib/memcpy_tile64.c                |  276 -----
 arch/tile/lib/memcpy_user_64.c               |    2 +
 arch/tile/lib/memset_32.c                    |  110 +-
 arch/tile/lib/memset_64.c                    |    9 +-
 arch/tile/lib/strchr_32.c                    |    2 -
 arch/tile/lib/strchr_64.c                    |    2 +-
 arch/tile/lib/string-endian.h                |   13 +-
 arch/tile/lib/strlen_32.c                    |    2 -
 arch/tile/lib/strnlen_32.c                   |   47 +
 arch/tile/lib/strnlen_64.c                   |   48 +
 arch/tile/lib/usercopy_32.S                  |   36 +-
 arch/tile/lib/usercopy_64.S                  |   36 +-
 arch/tile/mm/elf.c                           |   99 +-
 arch/tile/mm/fault.c                         |  135 ++-
 arch/tile/mm/highmem.c                       |    2 -
 arch/tile/mm/homecache.c                     |   39 +-
 arch/tile/mm/hugetlbpage.c                   |   38 +-
 arch/tile/mm/init.c                          |   96 +-
 arch/tile/mm/migrate_32.S                    |    4 +-
 arch/tile/mm/migrate_64.S                    |    4 +-
 arch/tile/mm/mmap.c                          |   24 +-
 arch/tile/mm/pgtable.c                       |   76 +-
 drivers/edac/tile_edac.c                     |    1 -
 drivers/tty/hvc/hvc_tile.c                   |  149 ++-
 drivers/tty/serial/Kconfig                   |    9 +
 drivers/tty/serial/Makefile                  |    1 +
 drivers/tty/serial/tilegx.c                  |  708 ++++++++++++
 include/uapi/linux/serial_core.h             |    3 +
 samples/kprobes/kprobe_example.c             |    9 +
 scripts/recordmcount.pl                      |    4 +
 157 files changed, 8708 insertions(+), 2893 deletions(-)
 create mode 100644 arch/tile/gxio/iorpc_uart.c
 create mode 100644 arch/tile/gxio/uart.c
 create mode 100644 arch/tile/include/arch/uart.h
 create mode 100644 arch/tile/include/arch/uart_def.h
 rename arch/tile/include/asm/{hw_irq.h => kdebug.h} (65%)
 create mode 100644 arch/tile/include/asm/kgdb.h
 create mode 100644 arch/tile/include/asm/kprobes.h
 create mode 100644 arch/tile/include/asm/vdso.h
 create mode 100644 arch/tile/include/gxio/iorpc_uart.h
 create mode 100644 arch/tile/include/gxio/uart.h
 create mode 100644 arch/tile/include/hv/drv_uart_intf.h
 delete mode 100644 arch/tile/include/uapi/arch/chip_tile64.h
 create mode 100644 arch/tile/kernel/ftrace.c
 create mode 100644 arch/tile/kernel/hvglue.S
 delete mode 100644 arch/tile/kernel/hvglue.lds
 create mode 100644 arch/tile/kernel/hvglue_trace.c
 create mode 100644 arch/tile/kernel/kgdb.c
 create mode 100644 arch/tile/kernel/kprobes.c
 create mode 100644 arch/tile/kernel/mcount_64.S
 create mode 100644 arch/tile/kernel/unaligned.c
 create mode 100644 arch/tile/kernel/vdso.c
 create mode 100644 arch/tile/kernel/vdso/Makefile
 create mode 100644 arch/tile/kernel/vdso/vdso.S
 create mode 100644 arch/tile/kernel/vdso/vdso.lds.S
 create mode 100644 arch/tile/kernel/vdso/vdso32.S
 create mode 100644 arch/tile/kernel/vdso/vgettimeofday.c
 create mode 100644 arch/tile/kernel/vdso/vrt_sigreturn.S
 delete mode 100644 arch/tile/lib/memcpy_tile64.c
 create mode 100644 arch/tile/lib/strnlen_32.c
 create mode 100644 arch/tile/lib/strnlen_64.c
 create mode 100644 drivers/tty/serial/tilegx.c

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

