Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaHDJeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:34:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52442 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbaHDJeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:34:01 -0400
Date: Mon, 4 Aug 2014 10:33:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com, pbonzini@redhat.com, marc.zyngier@arm.com,
        jason@lakedaemon.net, christoffer.dall@linaro.org
Subject: [GIT PULL] arm64: updates for 3.17
Message-ID: <20140804093328.GB15117@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Once again, Catalin's off on holiday and I'm looking after the arm64
tree. Please can you pull the following arm64 updates for 3.17?

Note that this branch also includes the new GICv3 driver (merged via a
stable tag from Jason's irqchip tree), since there is a fix for older
binutils on top.

Cheers,

Will

--->8

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-upstream

for you to fetch changes up to ea1719672f59eeb85829073b567495c4f472ac9f:

  arm64: add newline to I-cache policy string (2014-08-01 14:00:06 +0100)

----------------------------------------------------------------
arm64 updates for 3.17

Changes include:
 - Context tracking support (NO_HZ_FULL) which narrowly missed 3.16
 - vDSO layout rework following Andy's work on x86
 - TEXT_OFFSET fuzzing for bootloader testing
 - /proc/cpuinfo tidy-up
 - Preliminary work to support 48-bit virtual addresses, but this is
   currently disabled until KVM has been ported to use it (the patches
   do, however, bring some nice clean-up)
 - Boot-time CPU sanity checks (especially useful on heterogenous
   systems)
 - Support for syscall auditing
 - Support for CC_STACKPROTECTOR
 - defconfig updates

----------------------------------------------------------------
AKASHI Takahiro (2):
      arm64: audit: Add audit hook in syscall_trace_enter/exit()
      arm64: Add audit support

Andreas Schwab (1):
      arm64/crypto: fix makefile rule for aes-glue-%.o

Arun Chandran (1):
      arm64: vdso: fix build error when switching from LE to BE

Catalin Marinas (15):
      arm64: Add __NR_* definitions for compat syscalls
      arm64: Cast KSTK_(EIP|ESP) to unsigned long
      arm64: Remove duplicate (SWAPPER|IDMAP)_DIR_SIZE definitions
      arm64: Do not initialise the fixmap page tables in head.S
      arm64: Convert bool ARM64_x_LEVELS to int ARM64_PGTABLE_LEVELS
      arm64: Remove asm/pgtable-*level-hwdef.h files
      arm64: Remove asm/pgtable-*level-types.h files
      arm64: Clean up the initial page table creation in head.S
      arm64: Determine the vmalloc/vmemmap space at build time based on VA_BITS
      arm64: asm/pgtable.h pmd/pud definitions clean-up
      arm64: Add support for 48-bit VA space with 64KB page configuration
      arm64: Fix barriers used for page table modifications
      arm64: Do not invoke audit_syscall_* functions if !CONFIG_AUDIT_SYSCALL
      Merge tag 'deps-irqchip-gic-3.17' of git://git.infradead.org/users/jcooper/linux
      arm64: gicv3: Allow GICv3 compilation with older binutils

Ian Campbell (1):
      arm64: Align the kbuild output for VDSOL and VDSOA

Jungseok Lee (5):
      arm64: Use pr_* instead of printk
      arm64: Introduce VA_BITS and translation level options
      arm64: Add a description on 48-bit address space with 4KB pages
      arm64: Add 4 levels of page tables definition with 4KB pages
      arm64: mm: Implement 4 levels of translation tables

Larry Bassel (2):
      arm64: adjust el0_sync so that a function can be called
      arm64: enable context tracking

Laura Abbott (1):
      arm64: Add CONFIG_CC_STACKPROTECTOR

Lorenzo Pieralisi (3):
      arm64: kernel: enable PSCI cpu operations on UP systems
      arm64: kernel: add __init marker to PSCI init functions
      arm64: kernel: add missing __init section marker to cpu_suspend_init

Marc Zyngier (2):
      irqchip: gic: Move some bits of GICv2 to a library-type file
      irqchip: gic-v3: Initial support for GICv3

Mark Brown (1):
      arm64: Remove stray ARCH_HAS_OPP reference

Mark Rutland (10):
      arm64: head.S: remove unnecessary function alignment
      arm64: place initial page tables above the kernel
      arm64: Update the Image header
      arm64: Enable TEXT_OFFSET fuzzing
      arm64: add MIDR_EL1 field accessors
      arm64: cpuinfo: record cpu system register values
      arm64: cachetype: report weakest cache policy
      arm64: add runtime system sanity checks
      arm64: cpuinfo: print info for all CPUs
      arm64: add newline to I-cache policy string

Mark Salter (1):
      arm64: fix soft lockup due to large tlb flush range

Robert Richter (1):
      arm64: defconfig: enable devtmpfs mount option

Will Deacon (7):
      arm64: vdso: put vdso datapage in a separate vma
      arm64: vdso: move to _install_special_mapping and remove arch_vma_name
      arm64: vdso: move data page before code pages
      arm64: fpsimd: avoid restoring fpcr if the contents haven't changed
      arm64: defconfig: add virtio support for running as a kvm guest
      arm64: don't call break hooks for BRK exceptions from EL0
      Revert "arm64: dmi: Add SMBIOS/DMI support"

Yi Li (1):
      arm64: dmi: Add SMBIOS/DMI support

Zi Shen Lim (1):
      arm64: topology: add MPIDR-based detection

byungchul.park (1):
      arm64: fpsimd: fix a typo in fpsimd_save_partial_state ENDPROC

 Documentation/arm64/booting.txt                    |   43 +-
 Documentation/arm64/memory.txt                     |   69 +-
 arch/arm64/Kconfig                                 |   57 +-
 arch/arm64/Kconfig.debug                           |   15 +
 arch/arm64/Makefile                                |    4 +
 arch/arm64/configs/defconfig                       |    7 +
 arch/arm64/crypto/Makefile                         |    2 +-
 arch/arm64/include/asm/cacheflush.h                |   11 +-
 arch/arm64/include/asm/cachetype.h                 |   16 +-
 arch/arm64/include/asm/cpu.h                       |   59 +
 arch/arm64/include/asm/cputype.h                   |   35 +-
 arch/arm64/include/asm/fpsimdmacros.h              |   17 +-
 arch/arm64/include/asm/memory.h                    |    6 +-
 arch/arm64/include/asm/page.h                      |   20 +-
 arch/arm64/include/asm/pgalloc.h                   |   24 +-
 arch/arm64/include/asm/pgtable-2level-hwdef.h      |   43 -
 arch/arm64/include/asm/pgtable-2level-types.h      |   62 --
 arch/arm64/include/asm/pgtable-3level-hwdef.h      |   50 -
 arch/arm64/include/asm/pgtable-hwdef.h             |   42 +-
 .../{pgtable-3level-types.h => pgtable-types.h}    |   73 +-
 arch/arm64/include/asm/pgtable.h                   |  100 +-
 arch/arm64/include/asm/processor.h                 |    4 +-
 arch/arm64/include/asm/stackprotector.h            |   38 +
 arch/arm64/include/asm/syscall.h                   |   14 +
 arch/arm64/include/asm/sysreg.h                    |   60 +
 arch/arm64/include/asm/thread_info.h               |    5 +-
 arch/arm64/include/asm/tlb.h                       |   11 +-
 arch/arm64/include/asm/tlbflush.h                  |   34 +-
 arch/arm64/include/asm/unistd.h                    |   17 +
 arch/arm64/include/asm/unistd32.h                  | 1166 +++++++++++++-------
 arch/arm64/kernel/Makefile                         |    3 +-
 arch/arm64/kernel/cpu_ops.c                        |    2 +-
 arch/arm64/kernel/cpuinfo.c                        |  192 ++++
 arch/arm64/kernel/debug-monitors.c                 |   22 +-
 arch/arm64/kernel/entry-fpsimd.S                   |    2 +-
 arch/arm64/kernel/entry.S                          |   56 +-
 arch/arm64/kernel/head.S                           |  121 +-
 arch/arm64/kernel/hyp-stub.S                       |    1 +
 arch/arm64/kernel/image.h                          |   62 ++
 arch/arm64/kernel/kuser32.S                        |    2 +-
 arch/arm64/kernel/process.c                        |    6 +
 arch/arm64/kernel/psci.c                           |    8 +-
 arch/arm64/kernel/ptrace.c                         |   11 +
 arch/arm64/kernel/setup.c                          |   47 +-
 arch/arm64/kernel/signal32.c                       |    2 +-
 arch/arm64/kernel/smp.c                            |    6 +
 arch/arm64/kernel/suspend.c                        |    2 +-
 arch/arm64/kernel/sys_compat.c                     |    2 +-
 arch/arm64/kernel/topology.c                       |   47 +-
 arch/arm64/kernel/traps.c                          |   13 +-
 arch/arm64/kernel/vdso.c                           |   94 +-
 arch/arm64/kernel/vdso/Makefile                    |    6 +-
 arch/arm64/kernel/vdso/vdso.lds.S                  |    4 +-
 arch/arm64/kernel/vmlinux.lds.S                    |   16 +
 arch/arm64/mm/fault.c                              |    1 +
 arch/arm64/mm/init.c                               |   34 +-
 arch/arm64/mm/ioremap.c                            |   30 +-
 arch/arm64/mm/mmu.c                                |   14 +-
 drivers/irqchip/Kconfig                            |    5 +
 drivers/irqchip/Makefile                           |    3 +-
 drivers/irqchip/irq-gic-common.c                   |  115 ++
 drivers/irqchip/irq-gic-common.h                   |   29 +
 drivers/irqchip/irq-gic-v3.c                       |  692 ++++++++++++
 drivers/irqchip/irq-gic.c                          |   59 +-
 include/linux/irqchip/arm-gic-v3.h                 |  200 ++++
 include/uapi/linux/audit.h                         |    1 +
 66 files changed, 3061 insertions(+), 953 deletions(-)
 create mode 100644 arch/arm64/include/asm/cpu.h
 delete mode 100644 arch/arm64/include/asm/pgtable-2level-hwdef.h
 delete mode 100644 arch/arm64/include/asm/pgtable-2level-types.h
 delete mode 100644 arch/arm64/include/asm/pgtable-3level-hwdef.h
 rename arch/arm64/include/asm/{pgtable-3level-types.h => pgtable-types.h} (56%)
 create mode 100644 arch/arm64/include/asm/stackprotector.h
 create mode 100644 arch/arm64/include/asm/sysreg.h
 create mode 100644 arch/arm64/kernel/cpuinfo.c
 create mode 100644 arch/arm64/kernel/image.h
 create mode 100644 drivers/irqchip/irq-gic-common.c
 create mode 100644 drivers/irqchip/irq-gic-common.h
 create mode 100644 drivers/irqchip/irq-gic-v3.c
 create mode 100644 include/linux/irqchip/arm-gic-v3.h
