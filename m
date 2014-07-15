Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbaGOIqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:46:48 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:37698
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbaGOIqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:46:43 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v2 00/29] nios2 Linux kernel port
Date: Tue, 15 Jul 2014 16:45:27 +0800
Message-ID: <1405413956-2772-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(54164003)(50226001)(77982001)(4396001)(68736004)(74502001)(31966008)(48376002)(50986999)(229853001)(99396002)(77156001)(19580395003)(92726001)(92566001)(86362001)(88136002)(79102001)(105596002)(97736001)(102836001)(6806004)(84676001)(83072002)(36756003)(15975445006)(106466001)(107046002)(44976005)(74662001)(15202345003)(85852003)(89996001)(83322001)(21056001)(76482001)(20776003)(104166001)(47776003)(87286001)(87936001)(81342001)(93916002)(62966002)(2201001)(46102001)(77096002)(64706001)(85306003)(80022001)(81542001)(95666004)(42186005)(33646002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB036;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 2nd version of patchset adds the Linux kernel port for Nios II processor from
Altera. All of the feedback from v1 patchseries has been addressed. Thanks to all who
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

The patchset are based on v3.16-rc5 and can also be found in the following git tree:
git://git.rocketboards.org/linux-socfpga-next.git  nios2-upstream

-----------------
v2:
* move "Build infrastructure" to last patch
* remove unused console.o from Makefile
* sorted nios2/Kconfig
* change outw/inw to writew/readw in arch/nios2/kernel/time.c
* update PAGE_SIZE to (_AC(1, UL) << PAGE_SHIFT)
* remove config GENERIC_FIND_NEXT_BIT
* rename NO_IOPORT to NO_IOPORT_MAP
* restructure and sort filename in Makefile
* add NIOS2 prefix to all nios2 specific configs
* add targets in Makefile
* remove arch specific misaligned profs
* add debug message when unhandled page fault
* include cpuinfo.h to registers.h
* use generic PTRACE_GETREGSET/PTRACE_SETREGSET
* set IO_SPACE_LIMIT to 0
* remove ZONE_DMA
* update sys_cacheflush()
* remove sys_mmap()
* remove signal domain translation
* update 3c120_devboard.dts
* remove hardcoded constants from soc_dev
* merge nios2_device_probe to nios2_soc_device_init
* add nios2 and timer dts bindings.
* use get_signal() signal_setup_done()
* remove virt_to_bus and bus_to_virt
* update io.h
* update nios2 documentation
* add futex support
* bug fixes

patchset history
-----------------
[v1] : https://lkml.org/lkml/2014/4/18/216


Ley Foon Tan (29):
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
  nios2: ELF definitions
  nios2: System calls handling
  nios2: Signal handling support
  nios2: Library functions
  nios2: Device tree support
  nios2: Time keeping
  nios2: Cpuinfo handling
  nios2: Futex operations
  nios2: Miscellaneous header files
  nios2: Nios2 registers
  nios2: Module support
  nios2: ptrace support
  Add ELF machine define for Nios2
  MAINTAINERS: Add nios2 maintainer
  Documentation: Add documentation for Nios2 architecture
  nios2: Build infrastructure

 Documentation/devicetree/bindings/nios2/nios2.txt |  62 +++
 Documentation/devicetree/bindings/nios2/timer.txt |  19 +
 Documentation/nios2/README                        |  23 +
 MAINTAINERS                                       |   7 +
 arch/nios2/Kconfig                                | 199 ++++++++
 arch/nios2/Kconfig.debug                          |  17 +
 arch/nios2/Makefile                               |  78 +++
 arch/nios2/boot/Makefile                          |  52 ++
 arch/nios2/boot/dts/3c120_devboard.dts            | 155 ++++++
 arch/nios2/boot/linked_dtb.S                      |  19 +
 arch/nios2/configs/3c120_defconfig                |  76 +++
 arch/nios2/include/asm/Kbuild                     |  67 +++
 arch/nios2/include/asm/asm-macros.h               | 309 +++++++++++
 arch/nios2/include/asm/asm-offsets.h              |  20 +
 arch/nios2/include/asm/cache.h                    |  36 ++
 arch/nios2/include/asm/cacheflush.h               |  54 ++
 arch/nios2/include/asm/checksum.h                 |  78 +++
 arch/nios2/include/asm/cmpxchg.h                  |  61 +++
 arch/nios2/include/asm/cpuinfo.h                  |  57 +++
 arch/nios2/include/asm/delay.h                    |  92 ++++
 arch/nios2/include/asm/dma-mapping.h              | 106 ++++
 arch/nios2/include/asm/elf.h                      | 101 ++++
 arch/nios2/include/asm/entry.h                    | 152 ++++++
 arch/nios2/include/asm/futex-irq.h                | 130 +++++
 arch/nios2/include/asm/futex.h                    | 110 ++++
 arch/nios2/include/asm/gpio.h                     |  23 +
 arch/nios2/include/asm/io.h                       | 174 +++++++
 arch/nios2/include/asm/irq.h                      |  34 ++
 arch/nios2/include/asm/irqflags.h                 |  69 +++
 arch/nios2/include/asm/linkage.h                  |  25 +
 arch/nios2/include/asm/mmu.h                      |  18 +
 arch/nios2/include/asm/mmu_context.h              |  66 +++
 arch/nios2/include/asm/mutex.h                    |   1 +
 arch/nios2/include/asm/page.h                     | 113 +++++
 arch/nios2/include/asm/pci.h                      |  25 +
 arch/nios2/include/asm/pgalloc.h                  |  86 ++++
 arch/nios2/include/asm/pgtable-bits.h             |  35 ++
 arch/nios2/include/asm/pgtable.h                  | 305 +++++++++++
 arch/nios2/include/asm/processor.h                | 102 ++++
 arch/nios2/include/asm/ptrace.h                   |  33 ++
 arch/nios2/include/asm/registers.h                |  71 +++
 arch/nios2/include/asm/setup.h                    |  38 ++
 arch/nios2/include/asm/signal.h                   |  22 +
 arch/nios2/include/asm/string.h                   |  24 +
 arch/nios2/include/asm/switch_to.h                |  31 ++
 arch/nios2/include/asm/syscall.h                  | 138 +++++
 arch/nios2/include/asm/syscalls.h                 |  25 +
 arch/nios2/include/asm/thread_info.h              | 120 +++++
 arch/nios2/include/asm/timex.h                    |  27 +
 arch/nios2/include/asm/tlb.h                      |  34 ++
 arch/nios2/include/asm/tlbflush.h                 |  46 ++
 arch/nios2/include/asm/traps.h                    |  19 +
 arch/nios2/include/asm/uaccess.h                  | 233 +++++++++
 arch/nios2/include/asm/ucontext.h                 |  34 ++
 arch/nios2/include/uapi/asm/Kbuild                |  14 +
 arch/nios2/include/uapi/asm/byteorder.h           |  22 +
 arch/nios2/include/uapi/asm/elf.h                 |  67 +++
 arch/nios2/include/uapi/asm/ptrace.h              | 120 +++++
 arch/nios2/include/uapi/asm/sigcontext.h          |  30 ++
 arch/nios2/include/uapi/asm/signal.h              |  23 +
 arch/nios2/include/uapi/asm/stat.h                |  23 +
 arch/nios2/include/uapi/asm/statfs.h              |  24 +
 arch/nios2/include/uapi/asm/swab.h                |  37 ++
 arch/nios2/include/uapi/asm/unistd.h              |  25 +
 arch/nios2/kernel/Makefile                        |  24 +
 arch/nios2/kernel/asm-offsets.c                   |  88 ++++
 arch/nios2/kernel/cpuinfo.c                       | 201 ++++++++
 arch/nios2/kernel/entry.S                         | 554 ++++++++++++++++++++
 arch/nios2/kernel/head.S                          | 175 +++++++
 arch/nios2/kernel/insnemu.S                       | 592 ++++++++++++++++++++++
 arch/nios2/kernel/irq.c                           |  90 ++++
 arch/nios2/kernel/misaligned.c                    | 255 ++++++++++
 arch/nios2/kernel/module.c                        | 135 +++++
 arch/nios2/kernel/nios2_ksyms.c                   |  35 ++
 arch/nios2/kernel/process.c                       | 262 ++++++++++
 arch/nios2/kernel/prom.c                          |  66 +++
 arch/nios2/kernel/ptrace.c                        | 180 +++++++
 arch/nios2/kernel/setup.c                         | 222 ++++++++
 arch/nios2/kernel/signal.c                        | 316 ++++++++++++
 arch/nios2/kernel/sys_nios2.c                     |  66 +++
 arch/nios2/kernel/syscall_table.c                 |  29 ++
 arch/nios2/kernel/time.c                          | 150 ++++++
 arch/nios2/kernel/traps.c                         | 185 +++++++
 arch/nios2/kernel/vmlinux.lds.S                   |  75 +++
 arch/nios2/lib/Makefile                           |   8 +
 arch/nios2/lib/io.c                               |  59 +++
 arch/nios2/lib/memcpy.c                           | 199 ++++++++
 arch/nios2/lib/memmove.c                          |  82 +++
 arch/nios2/lib/memset.c                           |  81 +++
 arch/nios2/mm/Makefile                            |  14 +
 arch/nios2/mm/cacheflush.c                        | 270 ++++++++++
 arch/nios2/mm/dma-mapping.c                       | 186 +++++++
 arch/nios2/mm/extable.c                           |  25 +
 arch/nios2/mm/fault.c                             | 245 +++++++++
 arch/nios2/mm/init.c                              | 142 ++++++
 arch/nios2/mm/ioremap.c                           | 188 +++++++
 arch/nios2/mm/mmu_context.c                       | 116 +++++
 arch/nios2/mm/pgtable.c                           |  73 +++
 arch/nios2/mm/tlb.c                               | 274 ++++++++++
 arch/nios2/mm/uaccess.c                           | 162 ++++++
 arch/nios2/platform/Kconfig.platform              | 129 +++++
 arch/nios2/platform/Makefile                      |   1 +
 arch/nios2/platform/platform.c                    |  51 ++
 include/uapi/linux/elf-em.h                       |   1 +
 104 files changed, 10442 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nios2/nios2.txt
 create mode 100644 Documentation/devicetree/bindings/nios2/timer.txt
 create mode 100644 Documentation/nios2/README
 create mode 100644 arch/nios2/Kconfig
 create mode 100644 arch/nios2/Kconfig.debug
 create mode 100644 arch/nios2/Makefile
 create mode 100644 arch/nios2/boot/Makefile
 create mode 100644 arch/nios2/boot/dts/3c120_devboard.dts
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
 create mode 100644 arch/nios2/include/asm/futex-irq.h
 create mode 100644 arch/nios2/include/asm/futex.h
 create mode 100644 arch/nios2/include/asm/gpio.h
 create mode 100644 arch/nios2/include/asm/io.h
 create mode 100644 arch/nios2/include/asm/irq.h
 create mode 100644 arch/nios2/include/asm/irqflags.h
 create mode 100644 arch/nios2/include/asm/linkage.h
 create mode 100644 arch/nios2/include/asm/mmu.h
 create mode 100644 arch/nios2/include/asm/mmu_context.h
 create mode 100644 arch/nios2/include/asm/mutex.h
 create mode 100644 arch/nios2/include/asm/page.h
 create mode 100644 arch/nios2/include/asm/pci.h
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
 create mode 100644 arch/nios2/include/uapi/asm/stat.h
 create mode 100644 arch/nios2/include/uapi/asm/statfs.h
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

