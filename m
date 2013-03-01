Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab3CAQzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:55:54 -0500
Received: from multi.imgtec.com ([194.200.65.239]:60328 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3CAQzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:55:52 -0500
Message-ID: <5130DD94.2060408@imgtec.com>
Date: Fri, 1 Mar 2013 16:55:48 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] late arch/metag fixes for v3.9-rc1
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_01_16_55_49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following changes in addition to my previous arch/metag
pull request. See the tag (below) for details. The shortlog is a bit
inflated unfortunately as it includes the previous pull request too.
I've marked where the new changes begin though.

Thanks
James

The following changes since commit e72837e3e7bae3f182c4ac63c9424e86f1158dd0:

  default SET_PERSONALITY() in linux/elf.h (2013-02-26 02:46:08 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/metag-v3.9-rc1-late

for you to fetch changes up to 2149e40998b5c9bbee62a5bf97e04f28feb27ba8:

  metag: remove SET_PERSONALITY() (2013-02-27 08:36:18 +0000)

----------------------------------------------------------------
Late arch/metag changes for v3.9-rc1

Since the previous pull request (tag:metag-v3.9-rc1) this adds a few
fixes, mostly dependent on other changes which have now been merged into
mainline (which is why they weren't included in the original pull
request). As such it merges a few of these commits individually prior to
making the appropriate change in arch/metag.

* fix lack of device tree copy into non-init memory
* provide dma_get_sgtable() as added recently for other arches
* remove CONFIG_GENERIC_SIGALTSTACK
* remove CONFIG_HAVE_IRQ_WORK
* remove CONFIG_EXPERIMENTAL from defconfigs
* remove SET_PERSONALITY()

Signed-off-by: James Hogan <james.hogan@imgtec.com>

----------------------------------------------------------------
James Hogan (70):
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
(new since previous merge request tag:metag-v3.9-rc1:)
      metag: copy devicetree to non-init memory
      metag: prom.h: remove declaration of metag_dt_memblock_reserve()
      metag: Provide dma_get_sgtable()
      Merge commit 'burying unused conditionals'
      metag: remove GENERIC_SIGALTSTACK
      Merge commit 'irq_work: Remove CONFIG_HAVE_IRQ_WORK'
      metag: remove select CONFIG_HAVE_IRQ_WORK
      Merge commit 'make CONFIG_EXPERIMENTAL invisible and default'
      metag: remove CONFIG_EXPERIMENTAL from defconfigs
      Merge commit 'default SET_PERSONALITY() in linux/elf.h'
      metag: remove SET_PERSONALITY()

Stephen Rothwell (1):
      metag: min_low_pfn is now exported by generic code

 Documentation/00-INDEX                             |    2 +
 .../devicetree/bindings/metag/meta-intc.txt        |   82 ++
 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |    5 +-
 Documentation/filesystems/f2fs.txt                 |   18 +-
 Documentation/kernel-parameters.txt                |    4 +
 Documentation/metag/00-INDEX                       |    4 +
 Documentation/metag/kernel-ABI.txt                 |  256 ++++
 MAINTAINERS                                        |   14 +-
 Makefile                                           |    4 +-
 arch/Kconfig                                       |   45 +-
 arch/alpha/Kconfig                                 |    4 +-
 arch/alpha/include/asm/signal.h                    |   11 +-
 arch/alpha/include/asm/unistd.h                    |    1 -
 arch/alpha/kernel/process.c                        |    1 -
 arch/alpha/kernel/signal.c                         |   10 -
 arch/alpha/kernel/traps.c                          |    2 +-
 arch/arm/Kconfig                                   |    3 +-
 arch/arm/boot/dts/armada-370-db.dts                |    2 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |   14 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |   21 +-
 arch/arm/boot/dts/armada-xp-mv78460.dtsi           |   21 +-
 arch/arm/boot/dts/at91rm9200.dtsi                  |    4 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   60 +-
 arch/arm/boot/dts/cros5250-common.dtsi             |   12 +-
 arch/arm/boot/dts/dove-cubox.dts                   |   14 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi         |   16 +
 arch/arm/boot/dts/kirkwood.dtsi                    |    2 +
 arch/arm/boot/dts/kizbox.dts                       |    2 +
 arch/arm/boot/dts/sunxi.dtsi                       |    6 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |    2 -
 arch/arm/configs/at91_dt_defconfig                 |    3 +-
 arch/arm/include/asm/signal.h                      |   18 +-
 arch/arm/include/asm/unistd.h                      |    2 -
 arch/arm/kernel/calls.S                            |    2 +-
 arch/arm/kernel/debug.S                            |    2 +
 arch/arm/kernel/entry-common.S                     |    5 -
 arch/arm/kernel/head.S                             |    5 +-
 arch/arm/kernel/hyp-stub.S                         |   18 +-
 arch/arm/kernel/signal.c                           |   52 +-
 arch/arm/kernel/traps.c                            |    2 +-
 arch/arm/mach-at91/setup.c                         |    2 +
 arch/arm/mach-imx/Kconfig                          |    1 +
 arch/arm/mach-imx/clk-imx25.c                      |    6 +-
 arch/arm/mach-imx/clk-imx27.c                      |    6 +-
 arch/arm/mach-imx/clk-imx31.c                      |    6 +-
 arch/arm/mach-imx/clk-imx35.c                      |    6 +-
 arch/arm/mach-imx/clk-imx51-imx53.c                |    6 +-
 arch/arm/mach-imx/clk-imx6q.c                      |    3 +
 arch/arm/mach-imx/common.h                         |    1 +
 arch/arm/mach-imx/devices/devices-common.h         |    1 +
 arch/arm/mach-imx/devices/platform-fsl-usb2-udc.c  |   15 +-
 arch/arm/mach-imx/devices/platform-imx-fb.c        |    2 +-
 arch/arm/mach-imx/hotplug.c                        |   10 +-
 arch/arm/mach-imx/iram_alloc.c                     |    3 +-
 arch/arm/mach-imx/platsmp.c                        |    1 +
 arch/arm/mach-imx/pm-imx6q.c                       |    1 +
 arch/arm/mach-integrator/pci_v3.c                  |   14 +-
 arch/arm/mach-kirkwood/board-ns2.c                 |   38 -
 arch/arm/mach-mvebu/Makefile                       |    2 +
 arch/arm/mach-omap2/board-omap4panda.c             |    6 +
 arch/arm/mach-omap2/cclock2420_data.c              |    2 +
 arch/arm/mach-omap2/cclock2430_data.c              |    2 +
 arch/arm/mach-omap2/cclock44xx_data.c              |   13 +-
 arch/arm/mach-omap2/devices.c                      |    2 +-
 arch/arm/mach-omap2/drm.c                          |    3 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    6 +-
 arch/arm/mach-omap2/timer.c                        |    8 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    2 +-
 arch/arm/mach-s3c64xx/pm.c                         |    2 +
 arch/arm/mm/dma-mapping.c                          |   18 +-
 arch/arm/mm/mmu.c                                  |    2 +-
 arch/arm/plat-versatile/headsmp.S                  |    2 +-
 arch/arm/vfp/entry.S                               |    6 +-
 arch/arm/vfp/vfphw.S                               |    4 +-
 arch/arm64/Kconfig                                 |    3 +-
 arch/arm64/include/asm/elf.h                       |    5 +-
 arch/arm64/include/asm/syscalls.h                  |    2 -
 arch/arm64/include/asm/unistd.h                    |    2 -
 arch/arm64/include/asm/unistd32.h                  |    4 +-
 arch/arm64/kernel/entry.S                          |    5 -
 arch/arm64/kernel/signal.c                         |   17 +-
 arch/arm64/kernel/signal32.c                       |  220 +--
 arch/arm64/kernel/sys.c                            |    1 -
 arch/arm64/kernel/sys32.S                          |    5 -
 arch/arm64/kernel/traps.c                          |    2 +-
 arch/avr32/include/asm/signal.h                    |   11 +-
 arch/avr32/include/asm/unistd.h                    |    2 -
 arch/avr32/kernel/signal.c                         |   15 +-
 arch/avr32/kernel/syscall-stubs.S                  |    6 -
 arch/avr32/kernel/syscall_table.S                  |    2 +-
 arch/avr32/kernel/traps.c                          |    2 +-
 arch/blackfin/Kconfig                              |    1 -
 arch/blackfin/include/asm/unistd.h                 |    2 -
 arch/blackfin/kernel/signal.c                      |   12 +-
 arch/c6x/kernel/entry.S                            |   12 -
 arch/cris/Kconfig                                  |    2 +
 arch/cris/arch-v10/kernel/signal.c                 |   65 +-
 arch/cris/arch-v32/kernel/signal.c                 |   68 +-
 arch/cris/include/asm/signal.h                     |   19 +-
 arch/cris/include/asm/unistd.h                     |    2 -
 arch/frv/Kconfig                                   |    3 +-
 arch/frv/include/asm/signal.h                      |    7 -
 arch/frv/include/asm/unistd.h                      |    2 -
 arch/frv/kernel/signal.c                           |   55 +-
 arch/h8300/Kconfig                                 |    2 +
 arch/h8300/include/asm/signal.h                    |   18 +-
 arch/h8300/include/asm/unistd.h                    |    2 -
 arch/h8300/kernel/signal.c                         |   72 +-
 arch/h8300/kernel/syscalls.S                       |   15 -
 arch/hexagon/Kconfig                               |    1 -
 arch/hexagon/kernel/signal.c                       |   16 +-
 arch/hexagon/kernel/traps.c                        |    2 +-
 arch/ia64/include/asm/signal.h                     |   10 -
 arch/ia64/include/asm/unistd.h                     |    8 -
 arch/ia64/kernel/signal.c                          |   19 +-
 arch/ia64/kernel/traps.c                           |    2 +-
 arch/m32r/include/asm/signal.h                     |   11 +-
 arch/m32r/include/asm/unistd.h                     |    2 -
 arch/m32r/kernel/signal.c                          |   16 +-
 arch/m68k/Kconfig                                  |    2 +
 arch/m68k/include/asm/dma-mapping.h                |   16 +
 arch/m68k/include/asm/signal.h                     |   19 +-
 arch/m68k/include/asm/unistd.h                     |    4 +-
 arch/m68k/include/uapi/asm/unistd.h                |    1 +
 arch/m68k/kernel/signal.c                          |   59 +-
 arch/m68k/kernel/syscalltable.S                    |    1 +
 arch/m68k/kernel/traps.c                           |    2 +-
 arch/metag/Kconfig                                 |  293 ++++
 arch/metag/Kconfig.debug                           |   40 +
 arch/metag/Kconfig.soc                             |   55 +
 arch/metag/Makefile                                |   87 ++
 arch/metag/boot/.gitignore                         |    4 +
 arch/metag/boot/Makefile                           |   68 +
 arch/metag/boot/dts/Makefile                       |   16 +
 arch/metag/boot/dts/skeleton.dts                   |   10 +
 arch/metag/boot/dts/skeleton.dtsi                  |   14 +
 arch/metag/configs/meta1_defconfig                 |   40 +
 arch/metag/configs/meta2_defconfig                 |   41 +
 arch/metag/configs/meta2_smp_defconfig             |   42 +
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
 arch/metag/include/asm/dma-mapping.h               |  190 +++
 arch/metag/include/asm/elf.h                       |  125 ++
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
 arch/metag/include/asm/metag_mem.h                 | 1106 +++++++++++++++
 arch/metag/include/asm/metag_regs.h                | 1184 ++++++++++++++++
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
 arch/metag/include/asm/tbx.h                       | 1425 ++++++++++++++++++++
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
 arch/metag/kernel/devtree.c                        |  114 ++
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
 arch/metag/kernel/setup.c                          |  631 +++++++++
 arch/metag/kernel/signal.c                         |  344 +++++
 arch/metag/kernel/smp.c                            |  575 ++++++++
 arch/metag/kernel/stacktrace.c                     |  187 +++
 arch/metag/kernel/sys_metag.c                      |  180 +++
 arch/metag/kernel/tbiunexp.S                       |   22 +
 arch/metag/kernel/tcm.c                            |  151 +++
 arch/metag/kernel/time.c                           |   15 +
 arch/metag/kernel/topology.c                       |   77 ++
 arch/metag/kernel/traps.c                          |  995 ++++++++++++++
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
 arch/metag/lib/usercopy.c                          | 1354 +++++++++++++++++++
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
 arch/microblaze/include/asm/unistd.h               |    2 -
 arch/microblaze/kernel/entry-nommu.S               |   21 +-
 arch/microblaze/kernel/entry.S                     |   62 +-
 arch/microblaze/kernel/ptrace.c                    |   23 -
 arch/microblaze/kernel/signal.c                    |   26 +-
 arch/mips/Kconfig                                  |    2 +-
 arch/mips/include/asm/compat.h                     |    8 +
 arch/mips/include/asm/signal.h                     |    2 +
 arch/mips/include/asm/sim.h                        |   24 +-
 arch/mips/include/asm/unistd.h                     |    3 +-
 arch/mips/include/uapi/asm/signal.h                |    6 +-
 arch/mips/kernel/linux32.c                         |   44 -
 arch/mips/kernel/process.c                         |    3 +-
 arch/mips/kernel/scall32-o32.S                     |    4 +-
 arch/mips/kernel/scall64-64.S                      |    4 +-
 arch/mips/kernel/scall64-n32.S                     |   20 +-
 arch/mips/kernel/scall64-o32.S                     |   22 +-
 arch/mips/kernel/signal.c                          |   48 +-
 arch/mips/kernel/signal32.c                        |  237 +---
 arch/mips/kernel/signal_n32.c                      |   59 +-
 arch/mips/kernel/syscall.c                         |   73 +-
 arch/mips/kernel/traps.c                           |    2 +-
 arch/mn10300/Kconfig                               |    2 +
 arch/mn10300/include/asm/signal.h                  |   19 +-
 arch/mn10300/include/asm/unistd.h                  |    2 -
 arch/mn10300/kernel/signal.c                       |   60 +-
 arch/openrisc/kernel/entry.S                       |    4 -
 arch/openrisc/kernel/signal.c                      |   15 +-
 arch/parisc/Kconfig                                |    1 -
 arch/parisc/include/asm/signal.h                   |    6 +-
 arch/parisc/include/asm/unistd.h                   |    3 -
 arch/parisc/kernel/entry.S                         |   56 +-
 arch/parisc/kernel/irq.c                           |    6 +-
 arch/parisc/kernel/ptrace.c                        |    2 +-
 arch/parisc/kernel/signal.c                        |   23 +-
 arch/parisc/kernel/signal32.c                      |  142 --
 arch/parisc/kernel/signal32.h                      |   23 -
 arch/parisc/kernel/sys32.h                         |   12 -
 arch/parisc/kernel/sys_parisc32.c                  |   12 -
 arch/parisc/kernel/syscall_table.S                 |   10 +-
 arch/parisc/kernel/traps.c                         |    2 +-
 arch/parisc/math-emu/cnv_float.h                   |   11 +-
 arch/powerpc/Kconfig                               |    4 +-
 arch/powerpc/include/asm/signal.h                  |    1 +
 arch/powerpc/include/asm/syscalls.h                |   15 -
 arch/powerpc/include/asm/systbl.h                  |   63 +-
 arch/powerpc/include/asm/unistd.h                  |    4 -
 arch/powerpc/include/uapi/asm/signal.h             |    6 +-
 arch/powerpc/kernel/ppc32.h                        |   26 +-
 arch/powerpc/kernel/signal.c                       |    7 -
 arch/powerpc/kernel/signal_32.c                    |  253 +---
 arch/powerpc/kernel/signal_64.c                    |   11 +-
 arch/powerpc/kernel/sys_ppc32.c                    |  301 -----
 arch/powerpc/kernel/traps.c                        |    2 +-
 arch/powerpc/kvm/emulate.c                         |    2 +
 arch/s390/Kconfig                                  |    4 +-
 arch/s390/include/asm/signal.h                     |   19 +-
 arch/s390/include/asm/unistd.h                     |    3 -
 arch/s390/kernel/compat_linux.c                    |   80 --
 arch/s390/kernel/compat_linux.h                    |   34 +-
 arch/s390/kernel/compat_signal.c                   |  134 +-
 arch/s390/kernel/compat_wrapper.S                  |  144 --
 arch/s390/kernel/entry.h                           |    4 -
 arch/s390/kernel/signal.c                          |   56 +-
 arch/s390/kernel/syscalls.S                        |   46 +-
 arch/s390/kernel/traps.c                           |    2 +-
 arch/score/include/asm/syscalls.h                  |    1 -
 arch/score/kernel/entry.S                          |    5 -
 arch/score/kernel/signal.c                         |   21 +-
 arch/sh/Kconfig                                    |    3 +-
 arch/sh/include/asm/syscalls_32.h                  |    6 -
 arch/sh/include/asm/unistd.h                       |    2 -
 arch/sh/include/uapi/asm/signal.h                  |    2 +
 arch/sh/kernel/signal_32.c                         |   63 +-
 arch/sh/kernel/signal_64.c                         |   62 +-
 arch/sh/kernel/traps.c                             |    2 +-
 arch/sparc/Kconfig                                 |    5 +-
 arch/sparc/include/asm/compat_signal.h             |    6 -
 arch/sparc/include/asm/signal.h                    |    6 +-
 arch/sparc/include/asm/unistd.h                    |    3 -
 arch/sparc/include/uapi/asm/signal.h               |    2 +
 arch/sparc/kernel/entry.S                          |    8 -
 arch/sparc/kernel/setup_64.c                       |    2 +-
 arch/sparc/kernel/signal32.c                       |   48 +-
 arch/sparc/kernel/signal_32.c                      |   29 +-
 arch/sparc/kernel/signal_64.c                      |   24 +-
 arch/sparc/kernel/sys32.S                          |   86 --
 arch/sparc/kernel/sys_sparc32.c                    |  185 +--
 arch/sparc/kernel/sys_sparc_32.c                   |   48 +-
 arch/sparc/kernel/syscalls.S                       |    6 -
 arch/sparc/kernel/systbls.h                        |    4 +-
 arch/sparc/kernel/systbls_32.S                     |    2 +-
 arch/sparc/kernel/systbls_64.S                     |   84 +-
 arch/sparc/kernel/traps_32.c                       |    2 +-
 arch/sparc/kernel/traps_64.c                       |    2 +-
 arch/tile/include/asm/compat.h                     |    8 -
 arch/tile/include/asm/syscalls.h                   |    2 -
 arch/tile/include/asm/unistd.h                     |    1 -
 arch/tile/kernel/compat_signal.c                   |  112 +-
 arch/tile/kernel/signal.c                          |   15 +-
 arch/um/kernel/signal.c                            |   10 -
 arch/unicore32/kernel/entry.S                      |    5 -
 arch/unicore32/kernel/signal.c                     |   12 +-
 arch/unicore32/kernel/traps.c                      |    2 +-
 arch/x86/Kconfig                                   |    5 +-
 arch/x86/ia32/ia32_signal.c                        |   13 +-
 arch/x86/ia32/ia32entry.S                          |   12 +-
 arch/x86/ia32/sys_ia32.c                           |  171 ---
 arch/x86/include/asm/ia32.h                        |   15 -
 arch/x86/include/asm/signal.h                      |   22 +-
 arch/x86/include/asm/sys_ia32.h                    |   16 +-
 arch/x86/include/asm/syscalls.h                    |   13 +-
 arch/x86/include/asm/unistd.h                      |    2 -
 arch/x86/include/uapi/asm/signal.h                 |    8 +-
 arch/x86/kernel/cpu/amd.c                          |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   |    2 +-
 arch/x86/kernel/cpu/mcheck/p5.c                    |    2 +-
 arch/x86/kernel/cpu/mcheck/winchip.c               |    2 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |    2 +-
 arch/x86/kernel/cpu/perf_event.c                   |    6 -
 arch/x86/kernel/dumpstack.c                        |    2 +-
 arch/x86/kernel/entry_32.S                         |   45 -
 arch/x86/kernel/entry_64.S                         |   34 +-
 arch/x86/kernel/ioport.c                           |    3 +-
 arch/x86/kernel/signal.c                           |   67 +-
 arch/x86/kernel/step.c                             |    9 +-
 arch/x86/kernel/vm86_32.c                          |    8 +-
 arch/x86/syscalls/syscall_32.tbl                   |   22 +-
 arch/x86/syscalls/syscall_64.tbl                   |    6 +-
 arch/x86/um/Kconfig                                |    3 +-
 arch/x86/um/Makefile                               |    4 +-
 arch/x86/um/shared/sysdep/syscalls_32.h            |    5 -
 arch/x86/um/signal.c                               |   15 +-
 arch/x86/um/sys_call_table_32.c                    |    4 -
 arch/x86/um/syscalls_32.c                          |   38 -
 arch/xtensa/include/asm/signal.h                   |   11 +-
 arch/xtensa/include/asm/syscall.h                  |    7 -
 arch/xtensa/include/asm/unistd.h                   |    2 -
 arch/xtensa/include/uapi/asm/unistd.h              |    2 +-
 arch/xtensa/kernel/signal.c                        |   18 +-
 arch/xtensa/kernel/traps.c                         |    2 +-
 drivers/acpi/apei/apei-base.c                      |    3 +
 drivers/acpi/custom_method.c                       |    2 +-
 drivers/acpi/osl.c                                 |    2 +-
 drivers/acpi/processor_idle.c                      |    4 +
 drivers/acpi/processor_perflib.c                   |    7 +
 drivers/ata/ahci.c                                 |    8 +-
 drivers/ata/libahci.c                              |    6 +-
 drivers/ata/libata-core.c                          |   22 +-
 drivers/ata/libata-eh.c                            |    2 +-
 drivers/base/regmap/regmap-debugfs.c               |    4 +-
 drivers/base/regmap/regmap.c                       |    2 +-
 drivers/block/virtio_blk.c                         |    7 +-
 drivers/clk/mvebu/clk-cpu.c                        |    9 +-
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/metag_generic.c                |  198 +++
 drivers/cpufreq/Kconfig.x86                        |    2 +-
 drivers/cpufreq/acpi-cpufreq.c                     |    7 +
 drivers/cpufreq/cpufreq-cpu0.c                     |    5 +
 drivers/cpufreq/omap-cpufreq.c                     |    3 +
 drivers/devfreq/devfreq.c                          |    5 +
 drivers/devfreq/exynos4_bus.c                      |   94 +-
 drivers/dma/imx-dma.c                              |    5 +-
 drivers/dma/ioat/dma_v3.c                          |    2 +-
 drivers/dma/tegra20-apb-dma.c                      |    8 +-
 drivers/gpio/gpio-mvebu.c                          |    6 -
 drivers/gpio/gpio-samsung.c                        |   14 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |    3 +
 drivers/gpu/drm/i915/i915_drv.h                    |    3 +
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   21 +
 drivers/gpu/drm/i915/i915_irq.c                    |   11 +
 drivers/gpu/drm/i915/i915_reg.h                    |    2 +
 drivers/gpu/drm/i915/intel_dp.c                    |   47 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   17 +-
 drivers/gpu/drm/radeon/evergreen.c                 |    6 +
 drivers/gpu/drm/radeon/ni.c                        |    6 +
 drivers/gpu/drm/radeon/r600.c                      |    6 +
 drivers/gpu/drm/radeon/radeon.h                    |    3 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |    3 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   18 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |    2 +
 drivers/gpu/drm/radeon/radeon_semaphore.c          |    4 +
 drivers/gpu/drm/radeon/reg_srcs/rv515              |    2 +
 drivers/gpu/drm/radeon/si.c                        |    6 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |    1 +
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |   11 +-
 drivers/i2c/busses/i2c-designware-core.c           |    4 +
 drivers/i2c/busses/i2c-mxs.c                       |    6 +-
 drivers/i2c/busses/i2c-omap.c                      |    6 +-
 drivers/i2c/busses/i2c-sirf.c                      |    4 +
 drivers/i2c/muxes/i2c-mux-pinctrl.c                |    2 +-
 drivers/idle/intel_idle.c                          |    3 +-
 drivers/irqchip/Makefile                           |    2 +
 drivers/irqchip/irq-metag-ext.c                    |  868 ++++++++++++
 drivers/irqchip/irq-metag.c                        |  343 +++++
 drivers/media/i2c/m5mols/m5mols_core.c             |    2 +-
 drivers/media/platform/coda.c                      |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    3 -
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   88 +-
 drivers/media/usb/gspca/kinect.c                   |    1 +
 drivers/media/usb/gspca/sonixb.c                   |   13 +-
 drivers/media/usb/gspca/sonixj.c                   |    1 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |    4 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |    6 +-
 drivers/media/v4l2-core/videobuf2-core.c           |    4 +-
 drivers/mfd/vexpress-sysreg.c                      |   32 +-
 drivers/misc/ti-st/st_kim.c                        |   37 +-
 drivers/mmc/host/mvsdio.c                          |   92 +-
 drivers/pci/hotplug/pciehp.h                       |    2 +-
 drivers/pci/hotplug/pciehp_core.c                  |   11 +-
 drivers/pci/hotplug/pciehp_ctrl.c                  |    8 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   11 +-
 drivers/pci/hotplug/shpchp.h                       |    3 +-
 drivers/pci/hotplug/shpchp_core.c                  |   36 +-
 drivers/pci/hotplug/shpchp_ctrl.c                  |    6 +-
 drivers/pci/pcie/Kconfig                           |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c                 |    1 +
 drivers/pci/pcie/aspm.c                            |    3 +
 drivers/staging/iio/trigger/Kconfig                |    1 -
 drivers/usb/dwc3/gadget.c                          |    1 +
 drivers/usb/gadget/f_fs.c                          |    6 +-
 drivers/usb/gadget/fsl_mxc_udc.c                   |   40 +-
 drivers/usb/gadget/fsl_udc_core.c                  |   42 +-
 drivers/usb/gadget/fsl_usb2_udc.h                  |    5 +-
 drivers/usb/host/Kconfig                           |    2 +-
 drivers/usb/host/Makefile                          |    1 +
 drivers/usb/host/ehci-hcd.c                        |   12 +-
 drivers/usb/host/ehci-mxc.c                        |  120 +-
 drivers/usb/host/ehci.h                            |    7 +
 drivers/usb/host/uhci-hcd.c                        |   15 +-
 drivers/usb/musb/cppi_dma.c                        |    4 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                   |    4 +-
 drivers/video/imxfb.c                              |   13 +-
 fs/Kconfig                                         |   10 -
 fs/binfmt_elf.c                                    |    4 +
 fs/btrfs/extent-tree.c                             |    6 +-
 fs/btrfs/extent_map.c                              |   13 +-
 fs/btrfs/extent_map.h                              |    1 +
 fs/btrfs/file-item.c                               |    4 +-
 fs/btrfs/file.c                                    |   10 +-
 fs/btrfs/free-space-cache.c                        |   20 +-
 fs/btrfs/inode.c                                   |  137 +-
 fs/btrfs/ioctl.c                                   |  129 +-
 fs/btrfs/qgroup.c                                  |   20 +-
 fs/btrfs/send.c                                    |    4 +-
 fs/btrfs/super.c                                   |    2 +-
 fs/btrfs/transaction.c                             |   19 +-
 fs/btrfs/tree-log.c                                |   10 +-
 fs/btrfs/volumes.c                                 |   23 +-
 fs/cifs/cifs_dfs_ref.c                             |    2 +
 fs/cifs/connect.c                                  |    2 +-
 fs/compat.c                                        |   52 +-
 fs/f2fs/acl.c                                      |   13 +-
 fs/f2fs/checkpoint.c                               |    3 +-
 fs/f2fs/data.c                                     |   17 +-
 fs/f2fs/debug.c                                    |   50 +-
 fs/f2fs/dir.c                                      |    2 +-
 fs/f2fs/f2fs.h                                     |   18 +-
 fs/f2fs/file.c                                     |   16 +-
 fs/f2fs/gc.c                                       |   68 +-
 fs/f2fs/inode.c                                    |    3 +
 fs/f2fs/node.c                                     |   19 +-
 fs/f2fs/recovery.c                                 |   10 +-
 fs/f2fs/segment.c                                  |    2 +-
 fs/f2fs/super.c                                    |   97 +-
 fs/f2fs/xattr.c                                    |    2 +
 fs/fuse/Kconfig                                    |   16 +-
 fs/fuse/cuse.c                                     |   36 +-
 fs/fuse/dev.c                                      |    5 -
 fs/fuse/file.c                                     |    5 +-
 fs/timerfd.c                                       |   85 +-
 include/asm-generic/dma-mapping-broken.h           |   16 +
 include/asm-generic/io.h                           |    2 +
 include/asm-generic/syscalls.h                     |   16 -
 include/asm-generic/unistd.h                       |   12 +-
 include/clocksource/metag_generic.h                |   21 +
 include/linux/ata.h                                |    8 +-
 include/linux/compat.h                             |   50 +-
 include/linux/irqchip/metag-ext.h                  |   33 +
 include/linux/irqchip/metag.h                      |   24 +
 include/linux/kernel.h                             |    6 +-
 include/linux/libata.h                             |    4 +-
 include/linux/mm.h                                 |    2 +
 include/linux/module.h                             |   10 +-
 .../linux/platform_data/imx-iram.h                 |    0
 include/linux/sched.h                              |   23 +-
 include/linux/signal.h                             |   52 +-
 include/linux/syscalls.h                           |   25 +-
 include/uapi/asm-generic/signal.h                  |   10 +-
 include/uapi/asm-generic/unistd.h                  |    4 +-
 include/uapi/linux/elf.h                           |    2 +
 init/Kconfig                                       |   35 +-
 kernel/async.c                                     |   27 +-
 kernel/compat.c                                    |   72 +-
 kernel/debug/kdb/kdb_main.c                        |    2 +
 kernel/futex_compat.c                              |   19 +-
 kernel/irq_work.c                                  |   21 +-
 kernel/module.c                                    |  187 ++-
 kernel/panic.c                                     |   34 +-
 kernel/ptrace.c                                    |   72 +-
 kernel/sched/core.c                                |    5 +-
 kernel/signal.c                                    |  351 ++++-
 kernel/sysctl.c                                    |    2 +-
 kernel/trace/ftrace.c                              |    2 +-
 kernel/trace/ring_buffer.c                         |    6 +-
 lib/Kconfig.debug                                  |    4 +-
 lib/bug.c                                          |    4 +-
 mm/memory.c                                        |    2 +-
 mm/page_alloc.c                                    |    2 +-
 mm/slab.c                                          |    2 +-
 mm/slub.c                                          |    2 +-
 scripts/checkstack.pl                              |    8 +-
 scripts/genksyms/genksyms.c                        |    3 +-
 scripts/recordmcount.c                             |   13 +
 security/device_cgroup.c                           |    2 +
 security/integrity/evm/evm_crypto.c                |    4 +-
 sound/pci/hda/hda_codec.c                          |    5 +-
 sound/pci/hda/patch_conexant.c                     |    9 +
 sound/pci/hda/patch_realtek.c                      |    2 +
 sound/soc/soc-core.c                               |    2 +-
 tools/perf/MANIFEST                                |   10 +
 tools/perf/Makefile                                |    2 +-
 tools/perf/perf.h                                  |    6 +
 626 files changed, 29793 insertions(+), 5505 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/metag/meta-intc.txt
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
 delete mode 100644 arch/x86/um/syscalls_32.c
 create mode 100644 drivers/clocksource/metag_generic.c
 create mode 100644 drivers/irqchip/irq-metag-ext.c
 create mode 100644 drivers/irqchip/irq-metag.c
 create mode 100644 include/clocksource/metag_generic.h
 create mode 100644 include/linux/irqchip/metag-ext.h
 create mode 100644 include/linux/irqchip/metag.h
 rename arch/arm/mach-imx/iram.h => include/linux/platform_data/imx-iram.h (100%)

