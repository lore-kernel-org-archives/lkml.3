Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaLIIU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:20:27 -0500
Received: from mail-bn1on0055.outbound.protection.outlook.com ([157.56.110.55]:4288
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751013AbaLIIUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:20:25 -0500
Message-ID: <1418112651.4779.17.camel@leyfoon-vm>
From: Ley Foon Tan <lftan@altera.com>
To: <lftan.linux@gmail.com>
CC: Ley Foon Tan <lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [GIT PULL] arch/nios2 for v3.19-rc1
Date: Tue, 9 Dec 2014 16:20:17 +0800
Content-Transfer-Encoding: 
X-Mailer: Evolution 3.8.4-0ubuntu1 
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(377424004)(199003)(33646002)(110136001)(46102003)(31966008)(50466002)(87936001)(105596002)(86362001)(21056001)(107046002)(2351001)(50986999)(229853001)(106466001)(84676001)(33716001)(56776999)(50226001)(4396001)(120916001)(99396003)(92566001)(19580395003)(97736003)(42186005)(20776003)(68736005)(47776003)(89996001)(62966003)(48376002)(77156002)(64706001)(6806004)(103116003)(7099022)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB211;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BL2PR03MB211;
X-Forefront-PRVS: 0420213CCD
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Here is the Linux port for Nios II processor (from Altera) arch/nios2/
tree for v3.19-rc1. The patchset has been discussed on the kernel
mailing lists since April and has gone through 6 revisions of review.
The additional changes since then have been mostly further cleanups and
fixes when merged with other trees.

The arch code is in arch/nios2 and one asm-generic change (acked by
Arnd).

Please consider pulling. 

Regards
Ley Foon


The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  git://git.rocketboards.org/linux-socfpga-next.git tags/nios2-v3.19-rc1

for you to fetch changes up to 2b2b4074e647f4e88c9601e14f834f4a3a379d2a:

  nios2: Make NIOS2_CMDLINE_IGNORE_DTB depend on CMDLINE_BOOL (2014-12-08 12:56:14 +0800)

----------------------------------------------------------------
Introducing Linux port for Nios II processor (for v3.19-rc1)

This adds core architecture support for Nios II processor, 
followed by some later miscellaneous nios2 changes. 

----------------------------------------------------------------
Dmitry Torokhov (1):
      nios2: fix error handling of irq_of_parse_and_map

Ley Foon Tan (33):
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
      nios2: remove unnecessary space before define
      nios2: remove include asm-generic/iomap.h from io.h
      nios2: move include asm-generic/io.h to end of file
      nios2: include linux/type.h in io.h

Tobias Klauser (6):
      nios2: Use IS_ENABLED instead of #ifdefs to check config symbols
      nios2: Remove unused extern declaration of shm_align_mask
      nios2: Remove write-only struct member from nios2_timer
      nios2: asm-offsets: Remove unused definition TI_TASK
      nios2: Add missing NR_CPUS to Kconfig
      nios2: Make NIOS2_CMDLINE_IGNORE_DTB depend on CMDLINE_BOOL

 Documentation/devicetree/bindings/nios2/nios2.txt |  62 +++
 Documentation/devicetree/bindings/nios2/timer.txt |  19 +
 Documentation/nios2/README                        |  23 +
 MAINTAINERS                                       |   7 +
 arch/nios2/Kconfig                                | 206 ++++++++
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
 arch/nios2/include/asm/page.h                     | 109 ++++
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
 arch/nios2/kernel/asm-offsets.c                   |  87 ++++
 arch/nios2/kernel/cpuinfo.c                       | 197 +++++++
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
 arch/nios2/kernel/time.c                          | 308 +++++++++++
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
 100 files changed, 10208 insertions(+)
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


