Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaIHJhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:37:12 -0400
Received: from mail-bn1on0082.outbound.protection.outlook.com ([157.56.110.82]:29760
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752784AbaIHJhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:37:08 -0400
X-Greylist: delayed 839 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 05:37:07 EDT
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v3 00/29] nios2 Linux kernel port
Date: Mon, 8 Sep 2014 17:22:11 +0800
Message-ID: <1410168160-3624-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009017)(6009001)(54164003)(199003)(189002)(87936001)(47776003)(74502001)(77096002)(102836001)(83322001)(20776003)(86362001)(4396001)(80022001)(21056001)(81342001)(44976005)(92726001)(50466002)(107046002)(76482001)(77982001)(79102001)(90102001)(97736003)(104166001)(36756003)(87286001)(33646002)(89996001)(105596002)(93916002)(99396002)(19580395003)(15975445006)(77156001)(88136002)(85306004)(62966002)(92566001)(83072002)(74662001)(31966008)(229853001)(15202345003)(68736004)(42186005)(50226001)(6806004)(84676001)(50986999)(81542001)(46102001)(48376002)(2201001)(85852003)(106466001)(95666004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB041;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03283976A6
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 3rd version of patchset adds the Linux kernel port for Nios II processor from
Altera. All of the feedback from v2 patchseries has been addressed. Thanks to all who
provided feedback on the previous version.

About Nios II Cores
-------------------
Nios II is a 32-bit embedded-processor architecture designed specifically for the
Altera family of FPGAs.
More information is available  at http://www.altera.com/devices/processor/nios2/ni2-index.html

Instruction set and architecture overview documents can be found on the
following page:
http://www.altera.com/literature/lit-nio2.jsp

Nios2 GCC port is in mainline and will be in the FSF 4.9 release.

The patchset are based on v3.17-rc3 and can also be found in the following git tree:
git://git.rocketboards.org/linux-socfpga-next.git  nios2-upstream

v3:
* asm-generic: add generic futex for !CONFIG_SMP
* dma: empty function for dma_cache_sync()
* dma: rework for _for_device() and _for_cpu()
* irq: Enable SPARSE_IRQ and remove NR_IRQS
* irq: remove NO_IRQ
* io: move __IO_OUT[IN]_LOOP to C file
* io: add dummy implementation for in{b}{w}{l} and out{b}{w}{l}
* io: drop ioremap_writethrough() and drop ioremap_writethrough()
* signal: change to use set_current_blocked()
* signal: add error handling in setup_rt_frame()
* time: rework timer driver and use clockevent framework
* time: port to use asm-generic delay.h
* time: change __delay to use timer
* Kconfig: add define ARCH_HAS_READ_CURRENT_TIME
* change to use of_platform_populate() and default of_default_bus_match_table
* remove module_arch_cleanup
* add comment to module_alloc
* remove gpio.h, pci.h and use generic pci.h
* remove stat.h and statfs.h, use generic version.
* remove CLOCK_TICK_RATE
* update Makefile
* clean up uapi Kbuild file
* add install.sh
* remove nommu comment from license header

patchset history
-----------------
[v1] : https://lkml.org/lkml/2014/4/18/216
[v2] : https://lkml.org/lkml/2014/7/15/120

Ley Foon Tan (29):
  asm-generic: add generic futex for !CONFIG_SMP
  nios2: Assembly macros and definitions
  nios2: Kernel booting and initialization
  nios2: Exception handling
  nios2: Traps exception handling
  nios2: Memory management
  nios2: I/O Mapping
  nios2: MMU Fault handling
  nios2: Page table management
  nios2: Process management
  nios2: Cache handling
  nios2: TLB handling
  nios2: Interrupt handling
  nios2: DMA mapping API
  Add ELF machine define for Nios2
  nios2: ELF definitions
  nios2: System calls handling
  nios2: Signal handling support
  nios2: Library functions
  nios2: Device tree support
  nios2: Time keeping
  nios2: Cpuinfo handling
  nios2: Miscellaneous header files
  nios2: Nios2 registers
  nios2: Module support
  nios2: ptrace support
  MAINTAINERS: Add nios2 maintainer
  Documentation: Add documentation for Nios2 architecture
  nios2: Build infrastructure

 Documentation/devicetree/bindings/nios2/nios2.txt |  62 +++
 Documentation/devicetree/bindings/nios2/timer.txt |  19 +
 Documentation/nios2/README                        |  23 +
 MAINTAINERS                                       |   7 +
 arch/nios2/Kconfig                                | 201 ++++++++
 arch/nios2/Kconfig.debug                          |  17 +
 arch/nios2/Makefile                               |  73 +++
 arch/nios2/boot/Makefile                          |  52 ++
 arch/nios2/boot/dts/3c120_devboard.dts            | 164 ++++++
 arch/nios2/boot/install.sh                        |  52 ++
 arch/nios2/boot/linked_dtb.S                      |  19 +
 arch/nios2/configs/3c120_defconfig                |  77 +++
 arch/nios2/include/asm/Kbuild                     |  63 +++
 arch/nios2/include/asm/asm-macros.h               | 309 +++++++++++
 arch/nios2/include/asm/asm-offsets.h              |  20 +
 arch/nios2/include/asm/cache.h                    |  36 ++
 arch/nios2/include/asm/cacheflush.h               |  52 ++
 arch/nios2/include/asm/checksum.h                 |  78 +++
 arch/nios2/include/asm/cmpxchg.h                  |  61 +++
 arch/nios2/include/asm/cpuinfo.h                  |  57 +++
 arch/nios2/include/asm/delay.h                    |  21 +
 arch/nios2/include/asm/dma-mapping.h              | 130 +++++
 arch/nios2/include/asm/elf.h                      | 101 ++++
 arch/nios2/include/asm/entry.h                    | 120 +++++
 arch/nios2/include/asm/io.h                       |  84 +++
 arch/nios2/include/asm/irq.h                      |  28 +
 arch/nios2/include/asm/irqflags.h                 |  69 +++
 arch/nios2/include/asm/linkage.h                  |  25 +
 arch/nios2/include/asm/mmu.h                      |  16 +
 arch/nios2/include/asm/mmu_context.h              |  66 +++
 arch/nios2/include/asm/mutex.h                    |   1 +
 arch/nios2/include/asm/page.h                     | 111 ++++
 arch/nios2/include/asm/pgalloc.h                  |  86 ++++
 arch/nios2/include/asm/pgtable-bits.h             |  35 ++
 arch/nios2/include/asm/pgtable.h                  | 305 +++++++++++
 arch/nios2/include/asm/processor.h                | 103 ++++
 arch/nios2/include/asm/ptrace.h                   |  33 ++
 arch/nios2/include/asm/registers.h                |  71 +++
 arch/nios2/include/asm/setup.h                    |  38 ++
 arch/nios2/include/asm/signal.h                   |  22 +
 arch/nios2/include/asm/string.h                   |  24 +
 arch/nios2/include/asm/switch_to.h                |  31 ++
 arch/nios2/include/asm/syscall.h                  | 138 +++++
 arch/nios2/include/asm/syscalls.h                 |  25 +
 arch/nios2/include/asm/thread_info.h              | 120 +++++
 arch/nios2/include/asm/timex.h                    |  26 +
 arch/nios2/include/asm/tlb.h                      |  34 ++
 arch/nios2/include/asm/tlbflush.h                 |  46 ++
 arch/nios2/include/asm/traps.h                    |  19 +
 arch/nios2/include/asm/uaccess.h                  | 231 +++++++++
 arch/nios2/include/asm/ucontext.h                 |  32 ++
 arch/nios2/include/uapi/asm/Kbuild                |   6 +
 arch/nios2/include/uapi/asm/byteorder.h           |  22 +
 arch/nios2/include/uapi/asm/elf.h                 |  67 +++
 arch/nios2/include/uapi/asm/ptrace.h              | 120 +++++
 arch/nios2/include/uapi/asm/sigcontext.h          |  28 +
 arch/nios2/include/uapi/asm/signal.h              |  23 +
 arch/nios2/include/uapi/asm/swab.h                |  37 ++
 arch/nios2/include/uapi/asm/unistd.h              |  25 +
 arch/nios2/kernel/Makefile                        |  24 +
 arch/nios2/kernel/asm-offsets.c                   |  88 ++++
 arch/nios2/kernel/cpuinfo.c                       | 201 ++++++++
 arch/nios2/kernel/entry.S                         | 548 ++++++++++++++++++++
 arch/nios2/kernel/head.S                          | 175 +++++++
 arch/nios2/kernel/insnemu.S                       | 592 ++++++++++++++++++++++
 arch/nios2/kernel/irq.c                           |  93 ++++
 arch/nios2/kernel/misaligned.c                    | 255 ++++++++++
 arch/nios2/kernel/module.c                        | 137 +++++
 arch/nios2/kernel/nios2_ksyms.c                   |  35 ++
 arch/nios2/kernel/process.c                       | 257 ++++++++++
 arch/nios2/kernel/prom.c                          |  66 +++
 arch/nios2/kernel/ptrace.c                        | 176 +++++++
 arch/nios2/kernel/setup.c                         | 220 ++++++++
 arch/nios2/kernel/signal.c                        | 315 ++++++++++++
 arch/nios2/kernel/sys_nios2.c                     |  66 +++
 arch/nios2/kernel/syscall_table.c                 |  29 ++
 arch/nios2/kernel/time.c                          | 318 ++++++++++++
 arch/nios2/kernel/traps.c                         | 185 +++++++
 arch/nios2/kernel/vmlinux.lds.S                   |  75 +++
 arch/nios2/lib/Makefile                           |   9 +
 arch/nios2/lib/delay.c                            |  52 ++
 arch/nios2/lib/io.c                               | 138 +++++
 arch/nios2/lib/memcpy.c                           | 199 ++++++++
 arch/nios2/lib/memmove.c                          |  82 +++
 arch/nios2/lib/memset.c                           |  81 +++
 arch/nios2/mm/Makefile                            |  14 +
 arch/nios2/mm/cacheflush.c                        | 270 ++++++++++
 arch/nios2/mm/dma-mapping.c                       | 185 +++++++
 arch/nios2/mm/extable.c                           |  25 +
 arch/nios2/mm/fault.c                             | 251 +++++++++
 arch/nios2/mm/init.c                              | 142 ++++++
 arch/nios2/mm/ioremap.c                           | 186 +++++++
 arch/nios2/mm/mmu_context.c                       | 116 +++++
 arch/nios2/mm/pgtable.c                           |  73 +++
 arch/nios2/mm/tlb.c                               | 274 ++++++++++
 arch/nios2/mm/uaccess.c                           | 162 ++++++
 arch/nios2/platform/Kconfig.platform              | 129 +++++
 arch/nios2/platform/Makefile                      |   1 +
 arch/nios2/platform/platform.c                    |  46 ++
 include/asm-generic/futex.h                       |  82 +++
 include/uapi/linux/elf-em.h                       |   1 +
 101 files changed, 10334 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nios2/nios2.txt
 create mode 100644 Documentation/devicetree/bindings/nios2/timer.txt
 create mode 100644 Documentation/nios2/README
 create mode 100644 arch/nios2/Kconfig
 create mode 100644 arch/nios2/Kconfig.debug
 create mode 100644 arch/nios2/Makefile
 create mode 100644 arch/nios2/boot/Makefile
 create mode 100644 arch/nios2/boot/dts/3c120_devboard.dts
 create mode 100644 arch/nios2/boot/install.sh
 create mode 100644 arch/nios2/boot/linked_dtb.S
 create mode 100644 arch/nios2/configs/3c120_defconfig
 create mode 100644 arch/nios2/include/asm/Kbuild
 create mode 100644 arch/nios2/include/asm/asm-macros.h
 create mode 100644 arch/nios2/include/asm/asm-offsets.h
 create mode 100644 arch/nios2/include/asm/cache.h
 create mode 100644 arch/nios2/include/asm/cacheflush.h
 create mode 100644 arch/nios2/include/asm/checksum.h
 create mode 100644 arch/nios2/include/asm/cmpxchg.h
 create mode 100644 arch/nios2/include/asm/cpuinfo.h
 create mode 100644 arch/nios2/include/asm/delay.h
 create mode 100644 arch/nios2/include/asm/dma-mapping.h
 create mode 100644 arch/nios2/include/asm/elf.h
 create mode 100644 arch/nios2/include/asm/entry.h
 create mode 100644 arch/nios2/include/asm/io.h
 create mode 100644 arch/nios2/include/asm/irq.h
 create mode 100644 arch/nios2/include/asm/irqflags.h
 create mode 100644 arch/nios2/include/asm/linkage.h
 create mode 100644 arch/nios2/include/asm/mmu.h
 create mode 100644 arch/nios2/include/asm/mmu_context.h
 create mode 100644 arch/nios2/include/asm/mutex.h
 create mode 100644 arch/nios2/include/asm/page.h
 create mode 100644 arch/nios2/include/asm/pgalloc.h
 create mode 100644 arch/nios2/include/asm/pgtable-bits.h
 create mode 100644 arch/nios2/include/asm/pgtable.h
 create mode 100644 arch/nios2/include/asm/processor.h
 create mode 100644 arch/nios2/include/asm/ptrace.h
 create mode 100644 arch/nios2/include/asm/registers.h
 create mode 100644 arch/nios2/include/asm/setup.h
 create mode 100644 arch/nios2/include/asm/signal.h
 create mode 100644 arch/nios2/include/asm/string.h
 create mode 100644 arch/nios2/include/asm/switch_to.h
 create mode 100644 arch/nios2/include/asm/syscall.h
 create mode 100644 arch/nios2/include/asm/syscalls.h
 create mode 100644 arch/nios2/include/asm/thread_info.h
 create mode 100644 arch/nios2/include/asm/timex.h
 create mode 100644 arch/nios2/include/asm/tlb.h
 create mode 100644 arch/nios2/include/asm/tlbflush.h
 create mode 100644 arch/nios2/include/asm/traps.h
 create mode 100644 arch/nios2/include/asm/uaccess.h
 create mode 100644 arch/nios2/include/asm/ucontext.h
 create mode 100644 arch/nios2/include/uapi/asm/Kbuild
 create mode 100644 arch/nios2/include/uapi/asm/byteorder.h
 create mode 100644 arch/nios2/include/uapi/asm/elf.h
 create mode 100644 arch/nios2/include/uapi/asm/ptrace.h
 create mode 100644 arch/nios2/include/uapi/asm/sigcontext.h
 create mode 100644 arch/nios2/include/uapi/asm/signal.h
 create mode 100644 arch/nios2/include/uapi/asm/swab.h
 create mode 100644 arch/nios2/include/uapi/asm/unistd.h
 create mode 100644 arch/nios2/kernel/Makefile
 create mode 100644 arch/nios2/kernel/asm-offsets.c
 create mode 100644 arch/nios2/kernel/cpuinfo.c
 create mode 100644 arch/nios2/kernel/entry.S
 create mode 100644 arch/nios2/kernel/head.S
 create mode 100644 arch/nios2/kernel/insnemu.S
 create mode 100644 arch/nios2/kernel/irq.c
 create mode 100644 arch/nios2/kernel/misaligned.c
 create mode 100644 arch/nios2/kernel/module.c
 create mode 100644 arch/nios2/kernel/nios2_ksyms.c
 create mode 100644 arch/nios2/kernel/process.c
 create mode 100644 arch/nios2/kernel/prom.c
 create mode 100644 arch/nios2/kernel/ptrace.c
 create mode 100644 arch/nios2/kernel/setup.c
 create mode 100644 arch/nios2/kernel/signal.c
 create mode 100644 arch/nios2/kernel/sys_nios2.c
 create mode 100644 arch/nios2/kernel/syscall_table.c
 create mode 100644 arch/nios2/kernel/time.c
 create mode 100644 arch/nios2/kernel/traps.c
 create mode 100644 arch/nios2/kernel/vmlinux.lds.S
 create mode 100644 arch/nios2/lib/Makefile
 create mode 100644 arch/nios2/lib/delay.c
 create mode 100644 arch/nios2/lib/io.c
 create mode 100644 arch/nios2/lib/memcpy.c
 create mode 100644 arch/nios2/lib/memmove.c
 create mode 100644 arch/nios2/lib/memset.c
 create mode 100644 arch/nios2/mm/Makefile
 create mode 100644 arch/nios2/mm/cacheflush.c
 create mode 100644 arch/nios2/mm/dma-mapping.c
 create mode 100644 arch/nios2/mm/extable.c
 create mode 100644 arch/nios2/mm/fault.c
 create mode 100644 arch/nios2/mm/init.c
 create mode 100644 arch/nios2/mm/ioremap.c
 create mode 100644 arch/nios2/mm/mmu_context.c
 create mode 100644 arch/nios2/mm/pgtable.c
 create mode 100644 arch/nios2/mm/tlb.c
 create mode 100644 arch/nios2/mm/uaccess.c
 create mode 100644 arch/nios2/platform/Kconfig.platform
 create mode 100644 arch/nios2/platform/Makefile
 create mode 100644 arch/nios2/platform/platform.c

-- 
1.8.2.1

