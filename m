Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaKCKx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:53:26 -0500
Received: from mail-bl2on0068.outbound.protection.outlook.com ([65.55.169.68]:64644
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751114AbaKCKxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:53:21 -0500
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v6 00/29] nios2 Linux kernel port
Date: Mon, 3 Nov 2014 18:51:56 +0800
Message-ID: <1415011945-3297-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(54164003)(189002)(199003)(19580395003)(44976005)(104166001)(2201001)(92566001)(92726001)(105596002)(6806004)(95666004)(36756003)(15975445006)(50466002)(68736004)(86362001)(62966003)(93916002)(46102003)(48376002)(15202345003)(21056001)(102836001)(33646002)(84676001)(50986999)(99396003)(87936001)(31966008)(97736003)(20776003)(64706001)(47776003)(87286001)(50226001)(4396001)(120916001)(89996001)(229853001)(107046002)(106466001)(88136002)(42186005)(77156002)(77096003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB220;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB220;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 6th version of patchset adds the Linux kernel port for Nios II
processor from Altera. All of the feedback from v5 patchseries has been
addressed. Note, only patch #1, #7 and #21 have non-trivial changes. 
Thanks to all who provided feedback on the previous version.

About Nios II Cores
-------------------
Nios II is a 32-bit embedded-processor architecture designed specifically for the
Altera family of FPGAs.
More information is available  at http://www.altera.com/devices/processor/nios2/ni2-index.html

Instruction set and architecture overview documents can be found on the
following page:
http://www.altera.com/literature/lit-nio2.jsp

Nios2 GCC port is in mainline and will be in the FSF 4.9 release.

The patchset are based on v3.18-rc3 and can also be found in the following git tree:
git://git.rocketboards.org/linux-socfpga-next.git  nios2-upstream

v6:
* time: change from setup_irq to request_irq
* time: move num_called to nios2_time_init()
* time: remove checking for period==0
* time: change to use statically allocation for nios2 clock structures
* time: remove ARCH_HAS_READ_CURRENT_TIMER and use lpj_fine
* io: remove unused outs{b,w,l}, ins{b,w,l}, out{b,w,l} and in{b,w,l}
* remove __divdi3 and __udivdi3 sysmbol export
* add description to futex.h


patchset history
-----------------
[v1] : https://lkml.org/lkml/2014/4/18/216
[v2] : https://lkml.org/lkml/2014/7/15/120
[v3] : https://lkml.org/lkml/2014/9/8/139
[v4] : https://lkml.org/lkml/2014/10/8/141
[v5] : https://lkml.org/lkml/2014/10/24/104

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
 arch/nios2/include/asm/Kbuild                     |  66 +++
 arch/nios2/include/asm/asm-macros.h               | 309 +++++++++++
 arch/nios2/include/asm/asm-offsets.h              |  20 +
 arch/nios2/include/asm/cache.h                    |  36 ++
 arch/nios2/include/asm/cacheflush.h               |  52 ++
 arch/nios2/include/asm/checksum.h                 |  78 +++
 arch/nios2/include/asm/cmpxchg.h                  |  61 +++
 arch/nios2/include/asm/cpuinfo.h                  |  57 +++
 arch/nios2/include/asm/delay.h                    |  21 +
 arch/nios2/include/asm/dma-mapping.h              | 140 +++++
 arch/nios2/include/asm/elf.h                      | 101 ++++
 arch/nios2/include/asm/entry.h                    | 120 +++++
 arch/nios2/include/asm/io.h                       |  61 +++
 arch/nios2/include/asm/irq.h                      |  28 +
 arch/nios2/include/asm/irqflags.h                 |  72 +++
 arch/nios2/include/asm/linkage.h                  |  25 +
 arch/nios2/include/asm/mmu.h                      |  16 +
 arch/nios2/include/asm/mmu_context.h              |  66 +++
 arch/nios2/include/asm/mutex.h                    |   1 +
 arch/nios2/include/asm/page.h                     | 111 ++++
 arch/nios2/include/asm/pgalloc.h                  |  86 ++++
 arch/nios2/include/asm/pgtable-bits.h             |  35 ++
 arch/nios2/include/asm/pgtable.h                  | 310 +++++++++++
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
 arch/nios2/include/asm/timex.h                    |  24 +
 arch/nios2/include/asm/tlb.h                      |  34 ++
 arch/nios2/include/asm/tlbflush.h                 |  46 ++
 arch/nios2/include/asm/traps.h                    |  19 +
 arch/nios2/include/asm/uaccess.h                  | 231 +++++++++
 arch/nios2/include/asm/ucontext.h                 |  32 ++
 arch/nios2/include/uapi/asm/Kbuild                |   4 +
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
 arch/nios2/kernel/entry.S                         | 555 ++++++++++++++++++++
 arch/nios2/kernel/head.S                          | 175 +++++++
 arch/nios2/kernel/insnemu.S                       | 592 ++++++++++++++++++++++
 arch/nios2/kernel/irq.c                           |  93 ++++
 arch/nios2/kernel/misaligned.c                    | 256 ++++++++++
 arch/nios2/kernel/module.c                        | 138 +++++
 arch/nios2/kernel/nios2_ksyms.c                   |  33 ++
 arch/nios2/kernel/process.c                       | 258 ++++++++++
 arch/nios2/kernel/prom.c                          |  65 +++
 arch/nios2/kernel/ptrace.c                        | 166 ++++++
 arch/nios2/kernel/setup.c                         | 218 ++++++++
 arch/nios2/kernel/signal.c                        | 323 ++++++++++++
 arch/nios2/kernel/sys_nios2.c                     |  53 ++
 arch/nios2/kernel/syscall_table.c                 |  29 ++
 arch/nios2/kernel/time.c                          | 310 +++++++++++
 arch/nios2/kernel/traps.c                         | 185 +++++++
 arch/nios2/kernel/vmlinux.lds.S                   |  75 +++
 arch/nios2/lib/Makefile                           |   8 +
 arch/nios2/lib/delay.c                            |  52 ++
 arch/nios2/lib/memcpy.c                           | 202 ++++++++
 arch/nios2/lib/memmove.c                          |  82 +++
 arch/nios2/lib/memset.c                           |  81 +++
 arch/nios2/mm/Makefile                            |  14 +
 arch/nios2/mm/cacheflush.c                        | 271 ++++++++++
 arch/nios2/mm/dma-mapping.c                       | 186 +++++++
 arch/nios2/mm/extable.c                           |  25 +
 arch/nios2/mm/fault.c                             | 251 +++++++++
 arch/nios2/mm/init.c                              | 142 ++++++
 arch/nios2/mm/ioremap.c                           | 187 +++++++
 arch/nios2/mm/mmu_context.c                       | 116 +++++
 arch/nios2/mm/pgtable.c                           |  74 +++
 arch/nios2/mm/tlb.c                               | 275 ++++++++++
 arch/nios2/mm/uaccess.c                           | 163 ++++++
 arch/nios2/platform/Kconfig.platform              | 129 +++++
 arch/nios2/platform/Makefile                      |   1 +
 arch/nios2/platform/platform.c                    |  46 ++
 include/asm-generic/futex.h                       | 114 +++++
 include/uapi/linux/elf-em.h                       |   1 +
 100 files changed, 10212 insertions(+)
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

