Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaCaRxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:53:10 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:10881 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753045AbaCaRxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:53:07 -0400
Date: Mon, 31 Mar 2014 18:52:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 patches for 3.15
Message-ID: <20140331175230.GA7480@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below for 3.15. Thanks.


The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-upstream

for you to fetch changes up to 196adf2f3015eacac0567278ba538e3ffdd16d0e:

  arm64: Remove pgprot_dmacoherent() (2014-03-24 10:35:35 +0000)

----------------------------------------------------------------
- KGDB support for arm64
- PCI I/O space extended to 16M (in preparation of PCIe support patches)
- Dropping ZONE_DMA32 in favour of ZONE_DMA (we only need one for the
  time being), together with swiotlb late initialisation to correctly
  setup the bounce buffer
- DMA API cache maintenance support (not all ARMv8 platforms have
  hardware cache coherency)
- Crypto extensions advertising via ELF_HWCAP2 for compat user space
- Perf support for dwarf unwinding in compat mode
- asm/tlb.h converted to the generic mmu_gather code
- asm-generic rwsem implementation
- Code clean-up

----------------------------------------------------------------
Ard Biesheuvel (4):
      binfmt_elf: add ELF_HWCAP2 to compat auxv entries
      arm64: add AT_HWCAP2 support for 32-bit compat
      arm64: advertise ARMv8 extensions to 32-bit compat ELF binaries
      arm64: enable generic CPU feature modalias matching for this architecture

Catalin Marinas (9):
      arm64: Extend the PCI I/O space to 16MB
      arm64: Convert asm/tlb.h to generic mmu_gather
      arm64: Extend the idmap to the whole kernel image
      arm64: Replace ZONE_DMA32 with ZONE_DMA
      arm64: Use swiotlb late initialisation
      arm64: Implement coherent DMA API based on swiotlb
      arm64: Make DMA coherent and strongly ordered mappings not executable
      arm64: Do not synchronise I and D caches for special ptes
      arm64: Remove pgprot_dmacoherent()

Christopher Covington (1):
      arm64: Fix __range_ok macro

Geoff Levand (1):
      arm64: Fix the soft_restart routine

Jean Pihet (3):
      ARM64: perf: add support for perf registers API
      ARM64: perf: add support for frame pointer unwinding in compat mode
      ARM64: perf: support dwarf unwinding in compat mode

Jingoo Han (2):
      arm64: debug: make local symbols static
      arm64: smp: make local symbol static

Laura Abbott (2):
      arm64: Implement custom mmap functions for dma mapping
      arm64: Support DMA_ATTR_WRITE_COMBINE

Mark Brown (2):
      arm64: topology: Implement basic CPU topology support
      arm64: Fix duplicated Kconfig entries

Mark Rutland (1):
      arm64: remove unnecessary cache flush at boot

Nathan Lynch (1):
      arm64: vdso: clean up vdso_pagelist initialization

Radha Mohan Chintakuntla (1):
      arm64: Add boot time configuration of Intermediate Physical Address size

Ritesh Harjani (1):
      arm64: Change misleading function names in dma-mapping

Rob Herring (1):
      cpufreq: enable ARM drivers on arm64

Steve Capper (1):
      arm64: mm: Route pmd thp functions through pte equivalents

Vijaya Kumar K (7):
      arm64: Add macros to manage processor debug state
      arm64: KGDB: Add Basic KGDB support
      arm64: KGDB: Add step debugging support
      KGDB: make kgdb_breakpoint() as noinline
      misc: debug: remove compilation warnings
      arm64: KGDB: Add KGDB config
      arm64: enable processor debug state for secondary cpus

Vladimir Murzin (2):
      arm64: remove redundant "psci:" prefixes
      arm64: remove return value form psci_init()

Will Deacon (3):
      arm64: barriers: add dmb barrier
      asm-generic: rwsem: de-PPCify rwsem.h
      arm64: rwsem: use asm-generic rwsem implementation

 Documentation/arm64/memory.txt          |  16 +-
 arch/arm64/Kconfig                      |  26 ++-
 arch/arm64/include/asm/Kbuild           |   1 +
 arch/arm64/include/asm/barrier.h        |   1 +
 arch/arm64/include/asm/cacheflush.h     |   7 +
 arch/arm64/include/asm/compat.h         |   2 +-
 arch/arm64/include/asm/cpufeature.h     |  29 +++
 arch/arm64/include/asm/debug-monitors.h |  64 ++++--
 arch/arm64/include/asm/dma-mapping.h    |   7 +
 arch/arm64/include/asm/hwcap.h          |   9 +-
 arch/arm64/include/asm/io.h             |   2 +-
 arch/arm64/include/asm/irqflags.h       |  23 +++
 arch/arm64/include/asm/kgdb.h           |  84 ++++++++
 arch/arm64/include/asm/kvm_arm.h        |  15 +-
 arch/arm64/include/asm/pgtable-hwdef.h  |   5 +-
 arch/arm64/include/asm/pgtable.h        |  60 +++---
 arch/arm64/include/asm/psci.h           |   2 +-
 arch/arm64/include/asm/ptrace.h         |   5 +-
 arch/arm64/include/asm/tlb.h            | 136 ++-----------
 arch/arm64/include/asm/topology.h       |  39 ++++
 arch/arm64/include/asm/uaccess.h        |   4 +-
 arch/arm64/include/uapi/asm/Kbuild      |   1 +
 arch/arm64/include/uapi/asm/perf_regs.h |  40 ++++
 arch/arm64/kernel/Makefile              |   6 +-
 arch/arm64/kernel/debug-monitors.c      |  10 +-
 arch/arm64/kernel/head.S                |  20 +-
 arch/arm64/kernel/kgdb.c                | 336 ++++++++++++++++++++++++++++++++
 arch/arm64/kernel/perf_event.c          |  75 ++++++-
 arch/arm64/kernel/perf_regs.c           |  44 +++++
 arch/arm64/kernel/process.c             |  11 +-
 arch/arm64/kernel/psci.c                |  13 +-
 arch/arm64/kernel/setup.c               |  33 ++++
 arch/arm64/kernel/smp.c                 |  12 ++
 arch/arm64/kernel/smp_spin_table.c      |   2 +-
 arch/arm64/kernel/topology.c            |  95 +++++++++
 arch/arm64/kernel/vdso.c                |  42 ++--
 arch/arm64/kvm/hyp-init.S               |   6 +
 arch/arm64/mm/cache.S                   |  80 +++++++-
 arch/arm64/mm/dma-mapping.c             | 246 +++++++++++++++++++++--
 arch/arm64/mm/init.c                    |  33 ++--
 arch/arm64/mm/proc.S                    |  14 +-
 drivers/cpufreq/Kconfig                 |   2 +-
 fs/compat_binfmt_elf.c                  |   5 +
 include/asm-generic/rwsem.h             |  10 +-
 kernel/debug/debug_core.c               |   2 +-
 45 files changed, 1368 insertions(+), 307 deletions(-)
 create mode 100644 arch/arm64/include/asm/cpufeature.h
 create mode 100644 arch/arm64/include/asm/kgdb.h
 create mode 100644 arch/arm64/include/asm/topology.h
 create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
 create mode 100644 arch/arm64/kernel/kgdb.c
 create mode 100644 arch/arm64/kernel/perf_regs.c
 create mode 100644 arch/arm64/kernel/topology.c

-- 
Catalin
