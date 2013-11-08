Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab3KHSEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:04:52 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52396 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757841Ab3KHSEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:04:50 -0500
Date: Fri, 8 Nov 2013 18:04:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 patches for 3.13
Message-ID: <20131108180412.GA7983@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below. Thanks.

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-upstream

for you to fetch changes up to 67317c2689567c24d18e0dd43ab6d409fd42dc6e:

  ARM64: /proc/interrupts: display IPIs of online CPUs only (2013-11-07 17:26:54 +0000)

----------------------------------------------------------------
Main features:
- Ticket-based spinlock implementation and lockless lockref support
- Big endian support
- CPU hotplug support, currently for PSCI (Power State Coordination
  Interface) capable firmware
- Virtual address space extended to 42-bit in the 64K page configuration
  (maximum VA space with 2 levels of page tables)
- Compat (AArch32) kuser helpers updated to ARMv8 (make use of
  load-acquire/store-release instructions)
- Code cleanup, defconfig update and minor fixes

----------------------------------------------------------------
AKASHI Takahiro (1):
      arm64: check for number of arguments in syscall_get/set_arguments()

Catalin Marinas (7):
      arm64: Fix memory layout typo
      arm64: Export __copy_in_user() to modules
      arm64: Fix the endianness of arch_spinlock_t
      arm64: Slightly improve the warning on CPU0 enable-method
      arm64: defconfig: Enable CONFIG_PREEMPT by default
      arm64: Use 42-bit address space with 64K pages
      arm64: locks: Remove CONFIG_GENERIC_LOCKBREAK

Marc Zyngier (4):
      arm64: move enabling of GIC before CPUs are set online
      arm64: fix access to preempt_count from assembly code
      arm64: KVM: initialize HYP mode following the kernel endianness
      arm64: KVM: vgic: byteswap GICv2 access on world switch if BE

Mark Rutland (7):
      Docs: arm64: booting: clarify boot requirements
      arm64: unify smp_psci.c and psci.c
      arm64: reorganise smp_enable_ops
      arm64: factor out spin-table boot method
      arm64: read enable-method for CPU0
      arm64: add CPU_HOTPLUG infrastructure
      arm64: add PSCI CPU_OFF-based hotplug support

Mark Salter (2):
      arm64: allow ioremap_cache() to use existing RAM mappings
      arm64: use generic RW_DATA_SECTION macro in linker script

Matthew Leach (6):
      arm64: compat: correct register concatenation for syscall wrappers
      arm64: big-endian: don't treat code as data when copying sigret code
      arm64: asm: add CPU_LE & CPU_BE assembler helpers
      arm64: head: create a new function for setting the boot_cpu_mode flag
      arm64: big-endian: set correct endianess on kernel entry
      arm64: big-endian: write CPU holding pen address as LE

Robin Murphy (1):
      arm64: update 32-bit kuser helpers to ARMv8

Sudeep KarkadaNagesha (3):
      ARM64: DT: define ARM64 specific arch_match_cpu_phys_id
      ARM64: simplify cpu_read_bootcpu_ops using OF/DT helper
      ARM64: /proc/interrupts: display IPIs of online CPUs only

T.J. Purtell (1):
      arm64: compat: Clear the IT state independent of the 32-bit ARM or Thumb-2 mode

Vinayak Kale (1):
      arm64: perf: fix event number mask

Will Deacon (10):
      arm64: locks: introduce ticket-based spinlock implementation
      arm64: lockref: add support for lockless lockrefs using cmpxchg
      arm64: cmpxchg: implement cmpxchg64_relaxed
      arm64: big-endian: add big-endian support to top-level arch Makefile
      arm64: big-endian: fix byteorder include
      arm64: ELF: add support for big-endian executables
      arm64: setup: report ELF_PLATFORM as the machine for utsname
      arm64: compat: add support for big-endian (BE8) AArch32 binaries
      arm64: kconfig: allow CPU_BIG_ENDIAN to be selected
      arm64: module: ensure instruction is little-endian before manipulation

 Documentation/arm64/booting.txt               |  45 ++++--
 Documentation/arm64/memory.txt                |  29 +++-
 arch/arm64/Kconfig                            |  17 +-
 arch/arm64/Makefile                           |   6 +
 arch/arm64/configs/defconfig                  |   2 +-
 arch/arm64/include/asm/assembler.h            |  31 ++++
 arch/arm64/include/asm/cmpxchg.h              |   2 +
 arch/arm64/include/asm/compat.h               |  14 ++
 arch/arm64/include/asm/cpu_ops.h              |  59 +++++++
 arch/arm64/include/asm/elf.h                  |  18 +++
 arch/arm64/include/asm/io.h                   |   2 +-
 arch/arm64/include/asm/irq.h                  |   1 +
 arch/arm64/include/asm/memory.h               |  11 +-
 arch/arm64/include/asm/pgtable-2level-hwdef.h |   4 +-
 arch/arm64/include/asm/pgtable.h              |   2 +-
 arch/arm64/include/asm/processor.h            |   5 +
 arch/arm64/include/asm/psci.h                 |  19 ---
 arch/arm64/include/asm/ptrace.h               |   1 +
 arch/arm64/include/asm/smp.h                  |  15 +-
 arch/arm64/include/asm/spinlock.h             |  83 ++++++----
 arch/arm64/include/asm/spinlock_types.h       |  15 +-
 arch/arm64/include/asm/syscall.h              |   6 +
 arch/arm64/include/asm/virt.h                 |   3 +-
 arch/arm64/include/uapi/asm/byteorder.h       |   4 +
 arch/arm64/kernel/Makefile                    |   4 +-
 arch/arm64/kernel/arm64ksyms.c                |   1 +
 arch/arm64/kernel/cpu_ops.c                   |  87 +++++++++++
 arch/arm64/kernel/cputable.c                  |   2 +-
 arch/arm64/kernel/entry.S                     |  22 +--
 arch/arm64/kernel/head.S                      |  61 ++++++--
 arch/arm64/kernel/irq.c                       |  61 ++++++++
 arch/arm64/kernel/kuser32.S                   |  57 +++++--
 arch/arm64/kernel/module.c                    |   5 +-
 arch/arm64/kernel/perf_event.c                |   7 +-
 arch/arm64/kernel/process.c                   |   7 +
 arch/arm64/kernel/psci.c                      |  87 ++++++++++-
 arch/arm64/kernel/setup.c                     |   9 +-
 arch/arm64/kernel/signal32.c                  |  37 +----
 arch/arm64/kernel/smp.c                       | 214 +++++++++++++-------------
 arch/arm64/kernel/smp_psci.c                  |  53 -------
 arch/arm64/kernel/smp_spin_table.c            |  97 +++++++++++-
 arch/arm64/kernel/sys32.S                     |  22 +--
 arch/arm64/kernel/vdso.c                      |   5 +-
 arch/arm64/kernel/vmlinux.lds.S               |  32 +---
 arch/arm64/kvm/hyp-init.S                     |   5 +-
 arch/arm64/kvm/hyp.S                          |  13 ++
 arch/arm64/mm/ioremap.c                       |  20 ++-
 arch/arm64/mm/proc.S                          |   4 +-
 48 files changed, 936 insertions(+), 370 deletions(-)
 create mode 100644 arch/arm64/include/asm/cpu_ops.h
 create mode 100644 arch/arm64/kernel/cpu_ops.c
 delete mode 100644 arch/arm64/kernel/smp_psci.c

-- 
Catalin
