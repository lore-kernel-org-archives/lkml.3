Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaDRMle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:41:34 -0400
Received: from mail-bn1on0140.outbound.protection.outlook.com ([157.56.110.140]:14571
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751429AbaDRMlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:41:31 -0400
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Apr 2014 08:41:31 EDT
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 00/28] nios2 Linux kernel port
Date: Fri, 18 Apr 2014 20:26:47 +0800
Message-ID: <1397824031-4892-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(99396002)(36756003)(31966008)(97736001)(2009001)(47776003)(74502001)(20776003)(16796002)(87286001)(50986999)(74662001)(85852003)(83072002)(88136002)(87936001)(89996001)(86362001)(93916002)(92726001)(2201001)(84676001)(92566001)(15975445006)(19580395003)(80022001)(62966002)(80976001)(81342001)(46102001)(50226001)(4396001)(81542001)(6806004)(83322001)(44976005)(15202345003)(77982001)(42186004)(50466002)(48376002)(76482001)(77156001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB064;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:8EE07DFE.AC0246CD.42D0AB75.8E146AC7.204A6;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the Linux kernel port for Nios II processor from Altera.
The nios2 Linux port follows the guidance for new architecture ports using
generic headers (including unistd.h).

About Nios II Cores
-------------------
Nios II is a 32-bit embedded-processor architecture designed specifically for the
Altera family of FPGAs.
More information is available  at http://www.altera.com/devices/processor/nios2/ni2-index.html

Instruction set and architecture overview documents can be found on the
following page:
http://www.altera.com/literature/lit-nio2.jsp

Nios2 GCC port is in mainline and and will be in the FSF 4.9 release.

These patches are also available on this branch:
git://git.rocketboards.org/linux-socfpga-next.git  nios2-upstream

Regards,
Ley Foon

Ley Foon Tan (28):
  nios2: Build infrastructure
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
  nios2: Miscellaneous header files
  nios2: Nios2 registers
  nios2: Module support
  nios2: ptrace support
  Add ELF machine define for Nios2
  MAINTAINERS: Add nios2 maintainer
  Documentation: Add documentation for Nios2 architecture

 Documentation/nios2/README               |  23 ++
 MAINTAINERS                              |   7 +
 arch/nios2/Kconfig                       | 213 +++++++++++
 arch/nios2/Kconfig.debug                 |  17 +
 arch/nios2/Makefile                      |  78 ++++
 arch/nios2/boot/Makefile                 |  51 +++
 arch/nios2/boot/dts/3c120_devboard.dts   | 205 +++++++++++
 arch/nios2/boot/linked_dtb.S             |  19 +
 arch/nios2/configs/3c120_defconfig       |  77 ++++
 arch/nios2/include/asm/Kbuild            |  66 ++++
 arch/nios2/include/asm/asm-macros.h      | 309 ++++++++++++++++
 arch/nios2/include/asm/asm-offsets.h     |  20 ++
 arch/nios2/include/asm/cache.h           |  36 ++
 arch/nios2/include/asm/cacheflush.h      |  48 +++
 arch/nios2/include/asm/checksum.h        |  78 ++++
 arch/nios2/include/asm/cmpxchg.h         |  61 ++++
 arch/nios2/include/asm/cpuinfo.h         |  58 +++
 arch/nios2/include/asm/delay.h           |  92 +++++
 arch/nios2/include/asm/dma-mapping.h     | 113 ++++++
 arch/nios2/include/asm/elf.h             | 101 ++++++
 arch/nios2/include/asm/entry.h           | 152 ++++++++
 arch/nios2/include/asm/gpio.h            |  23 ++
 arch/nios2/include/asm/io.h              | 227 ++++++++++++
 arch/nios2/include/asm/irq.h             |  34 ++
 arch/nios2/include/asm/irqflags.h        |  69 ++++
 arch/nios2/include/asm/linkage.h         |  25 ++
 arch/nios2/include/asm/mmu.h             |  18 +
 arch/nios2/include/asm/mmu_context.h     |  66 ++++
 arch/nios2/include/asm/mutex.h           |   1 +
 arch/nios2/include/asm/page.h            | 111 ++++++
 arch/nios2/include/asm/pci.h             |  25 ++
 arch/nios2/include/asm/pgalloc.h         |  86 +++++
 arch/nios2/include/asm/pgtable-bits.h    |  35 ++
 arch/nios2/include/asm/pgtable.h         | 304 ++++++++++++++++
 arch/nios2/include/asm/processor.h       | 102 ++++++
 arch/nios2/include/asm/prom.h            |  26 ++
 arch/nios2/include/asm/ptrace.h          |  40 +++
 arch/nios2/include/asm/registers.h       |  65 ++++
 arch/nios2/include/asm/setup.h           |  38 ++
 arch/nios2/include/asm/signal.h          |  22 ++
 arch/nios2/include/asm/string.h          |  24 ++
 arch/nios2/include/asm/switch_to.h       |  31 ++
 arch/nios2/include/asm/syscalls.h        |  25 ++
 arch/nios2/include/asm/thread_info.h     | 120 +++++++
 arch/nios2/include/asm/timex.h           |  27 ++
 arch/nios2/include/asm/tlb.h             |  34 ++
 arch/nios2/include/asm/tlbflush.h        |  46 +++
 arch/nios2/include/asm/traps.h           |  19 +
 arch/nios2/include/asm/uaccess.h         | 233 ++++++++++++
 arch/nios2/include/asm/ucontext.h        |  34 ++
 arch/nios2/include/uapi/asm/Kbuild       |  14 +
 arch/nios2/include/uapi/asm/byteorder.h  |  22 ++
 arch/nios2/include/uapi/asm/elf.h        |  67 ++++
 arch/nios2/include/uapi/asm/ptrace.h     | 123 +++++++
 arch/nios2/include/uapi/asm/sigcontext.h |  30 ++
 arch/nios2/include/uapi/asm/signal.h     |  23 ++
 arch/nios2/include/uapi/asm/stat.h       |  23 ++
 arch/nios2/include/uapi/asm/statfs.h     |  24 ++
 arch/nios2/include/uapi/asm/swab.h       |  37 ++
 arch/nios2/include/uapi/asm/unistd.h     |  25 ++
 arch/nios2/kernel/Makefile               |  14 +
 arch/nios2/kernel/asm-offsets.c          |  88 +++++
 arch/nios2/kernel/cpuinfo.c              | 201 +++++++++++
 arch/nios2/kernel/entry.S                | 551 ++++++++++++++++++++++++++++
 arch/nios2/kernel/head.S                 | 175 +++++++++
 arch/nios2/kernel/insnemu.S              | 592 +++++++++++++++++++++++++++++++
 arch/nios2/kernel/irq.c                  |  90 +++++
 arch/nios2/kernel/misaligned.c           | 319 +++++++++++++++++
 arch/nios2/kernel/module.c               | 135 +++++++
 arch/nios2/kernel/nios2_ksyms.c          |  35 ++
 arch/nios2/kernel/process.c              | 262 ++++++++++++++
 arch/nios2/kernel/prom.c                 |  67 ++++
 arch/nios2/kernel/ptrace.c               | 198 +++++++++++
 arch/nios2/kernel/setup.c                | 214 +++++++++++
 arch/nios2/kernel/signal.c               | 364 +++++++++++++++++++
 arch/nios2/kernel/sys_nios2.c            |  72 ++++
 arch/nios2/kernel/syscall_table.c        |  29 ++
 arch/nios2/kernel/time.c                 | 150 ++++++++
 arch/nios2/kernel/traps.c                | 185 ++++++++++
 arch/nios2/kernel/vmlinux.lds.S          |  75 ++++
 arch/nios2/lib/Makefile                  |   1 +
 arch/nios2/lib/memcpy.c                  | 199 +++++++++++
 arch/nios2/lib/memmove.c                 |  82 +++++
 arch/nios2/lib/memset.c                  |  81 +++++
 arch/nios2/mm/Makefile                   |  12 +
 arch/nios2/mm/cacheflush.c               | 255 +++++++++++++
 arch/nios2/mm/dma-mapping.c              | 186 ++++++++++
 arch/nios2/mm/extable.c                  |  25 ++
 arch/nios2/mm/fault.c                    | 242 +++++++++++++
 arch/nios2/mm/init.c                     | 152 ++++++++
 arch/nios2/mm/ioremap.c                  | 188 ++++++++++
 arch/nios2/mm/mmu_context.c              | 116 ++++++
 arch/nios2/mm/pgtable.c                  |  73 ++++
 arch/nios2/mm/tlb.c                      | 274 ++++++++++++++
 arch/nios2/mm/uaccess.c                  | 162 +++++++++
 arch/nios2/platform/Kconfig.platform     | 129 +++++++
 arch/nios2/platform/Makefile             |   1 +
 arch/nios2/platform/platform.c           |  69 ++++
 include/uapi/linux/elf-em.h              |   1 +
 99 files changed, 10186 insertions(+)
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
 create mode 100644 arch/nios2/include/asm/prom.h
 create mode 100644 arch/nios2/include/asm/ptrace.h
 create mode 100644 arch/nios2/include/asm/registers.h
 create mode 100644 arch/nios2/include/asm/setup.h
 create mode 100644 arch/nios2/include/asm/signal.h
 create mode 100644 arch/nios2/include/asm/string.h
 create mode 100644 arch/nios2/include/asm/switch_to.h
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
1.8.3.2

