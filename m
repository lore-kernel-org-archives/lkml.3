Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaATSAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:00:17 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25947 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750744AbaATSAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:00:14 -0500
Date: Mon, 20 Jan 2014 17:59:42 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 patches for 3.14-rc1
Message-ID: <20140120175928.GA642@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below. Thanks.


The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-upstream

for you to fetch changes up to 883c057367014d20a14b5054e4eb0d81ce3bea5c:

  arm64: fix typo in entry.S (2014-01-13 13:55:13 +0000)

----------------------------------------------------------------
- CPU suspend support on top of PSCI (firmware Power State Coordination
  Interface)
- Jump label support
- CMA can now be enabled on arm64
- HWCAP bits for crypto and CRC32 extensions
- Optimised percpu using tpidr_el1 register
- Code cleanup

----------------------------------------------------------------
Ard Biesheuvel (1):
      arm64: drop redundant macros from read_cpuid()

Catalin Marinas (1):
      Merge tag 'arm64-suspend' of git://linux-arm.org/linux-2.6-lp into upstream

Geoff Levand (1):
      arm64: Remove unused __data_loc variable

Jiang Liu (7):
      arm64: introduce basic aarch64 instruction decoding helpers
      arm64: introduce interfaces to hotpatch kernel and module code
      arm64: move encode_insn_immediate() from module.c to insn.c
      arm64: introduce aarch64_insn_gen_{nop|branch_imm}() helper functions
      arm64, jump label: detect %c support for ARM64
      arm64, jump label: optimize jump label implementation
      jump_label: use defined macros instead of hard-coding for better readability

Konstantin Khlebnikov (2):
      ARM64: check stack pointer in get_wchan
      ARM64: fix framepointer check in unwind_frame

Laura Abbott (3):
      arm64: Correct virt_addr_valid
      arm64: Warn on NULL device structure for dma APIs
      arm64: Enable CMA

Liviu Dudau (1):
      arm64: Remove outdated comment

Lorenzo Pieralisi (13):
      arm64: kernel: add MPIDR_EL1 accessors macros
      arm64: kernel: build MPIDR_EL1 hash function data structure
      arm64: kernel: suspend/resume registers save/restore
      arm64: kernel: cpu_{suspend/resume} implementation
      arm64: kernel: implement fpsimd CPU PM notifier
      arm: kvm: implement CPU PM notifier
      arm64: kernel: refactor code to install/uninstall breakpoints
      arm64: kernel: implement HW breakpoints CPU PM notifier
      arm64: enable generic clockevent broadcast
      arm64: kernel: add CPU idle call
      arm64: kernel: add PM build infrastructure
      arm64: add CPU power management menu/entries
      arm64: kernel: restore HW breakpoint registers in cpu_suspend

Mark Brown (1):
      arm64: dts: Reduce size of virtio block device for foundation model

Mark Hambleton (2):
      arm64: dts: Add a virtio disk to the RTSM motherboard
      arm64: cmpxchg: update macros to prevent warnings

Mark Rutland (1):
      arm64: vmlinux.lds.S: drop redundant .comment

Neil Zhang (1):
      arm64: fix typo in entry.S

Sandeepa Prabhu (1):
      arm64: support single-step and breakpoint handler hooks

Steve Capper (1):
      arm64: Add hwcaps for crypto and CRC32 extensions.

Vinayak Kale (2):
      genirq: Add an accessor for IRQ_PER_CPU flag
      arm64: perf: add support for percpu pmu interrupt

Will Deacon (5):
      arm64: percpu: implement optimised pcpu access using tpidr_el1
      arm64: use generic strnlen_user and strncpy_from_user functions
      arm64: futex: ensure .fixup entries are sufficiently aligned
      arm64: dcache: select DCACHE_WORD_ACCESS for little-endian CPUs
      arm64: kconfig: select HAVE_EFFICIENT_UNALIGNED_ACCESS

 arch/arm/kvm/arm.c                           |  30 +++
 arch/arm64/Kconfig                           |  27 +++
 arch/arm64/boot/dts/foundation-v8.dts        |   2 +-
 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi |   6 +
 arch/arm64/include/asm/Kbuild                |   1 -
 arch/arm64/include/asm/cmpxchg.h             |  28 ++-
 arch/arm64/include/asm/cpu_ops.h             |   6 +
 arch/arm64/include/asm/cputype.h             |  28 +--
 arch/arm64/include/asm/debug-monitors.h      |  21 ++
 arch/arm64/include/asm/dma-contiguous.h      |  29 +++
 arch/arm64/include/asm/futex.h               |   1 +
 arch/arm64/include/asm/hardirq.h             |   2 +-
 arch/arm64/include/asm/insn.h                | 108 ++++++++++
 arch/arm64/include/asm/jump_label.h          |  52 +++++
 arch/arm64/include/asm/memory.h              |   3 +-
 arch/arm64/include/asm/percpu.h              |  41 ++++
 arch/arm64/include/asm/proc-fns.h            |   3 +
 arch/arm64/include/asm/smp_plat.h            |  13 ++
 arch/arm64/include/asm/suspend.h             |  27 +++
 arch/arm64/include/asm/uaccess.h             |  25 +--
 arch/arm64/include/asm/word-at-a-time.h      |  94 +++++++++
 arch/arm64/include/uapi/asm/hwcap.h          |   6 +-
 arch/arm64/kernel/Makefile                   |   4 +-
 arch/arm64/kernel/arm64ksyms.c               |   5 +-
 arch/arm64/kernel/asm-offsets.c              |  11 +
 arch/arm64/kernel/debug-monitors.c           |  88 +++++++-
 arch/arm64/kernel/entry.S                    |   4 +-
 arch/arm64/kernel/fpsimd.c                   |  36 ++++
 arch/arm64/kernel/head.S                     |  10 -
 arch/arm64/kernel/hw_breakpoint.c            | 203 ++++++++++++------
 arch/arm64/kernel/insn.c                     | 304 +++++++++++++++++++++++++++
 arch/arm64/kernel/jump_label.c               |  58 +++++
 arch/arm64/kernel/module.c                   | 157 +++++---------
 arch/arm64/kernel/perf_event.c               | 108 +++++++---
 arch/arm64/kernel/process.c                  |  14 +-
 arch/arm64/kernel/setup.c                    | 122 ++++++++++-
 arch/arm64/kernel/sleep.S                    | 184 ++++++++++++++++
 arch/arm64/kernel/smp.c                      |  23 +-
 arch/arm64/kernel/stacktrace.c               |   2 +-
 arch/arm64/kernel/suspend.c                  | 132 ++++++++++++
 arch/arm64/kernel/vmlinux.lds.S              |   3 -
 arch/arm64/lib/Makefile                      |   8 +-
 arch/arm64/lib/strncpy_from_user.S           |  50 -----
 arch/arm64/lib/strnlen_user.S                |  47 -----
 arch/arm64/mm/dma-mapping.c                  |  35 ++-
 arch/arm64/mm/init.c                         |   3 +
 arch/arm64/mm/proc.S                         |  69 ++++++
 include/linux/irqdesc.h                      |   8 +
 include/linux/jump_label.h                   |  19 +-
 scripts/gcc-goto.sh                          |   2 +-
 50 files changed, 1859 insertions(+), 403 deletions(-)
 create mode 100644 arch/arm64/include/asm/dma-contiguous.h
 create mode 100644 arch/arm64/include/asm/insn.h
 create mode 100644 arch/arm64/include/asm/jump_label.h
 create mode 100644 arch/arm64/include/asm/percpu.h
 create mode 100644 arch/arm64/include/asm/suspend.h
 create mode 100644 arch/arm64/include/asm/word-at-a-time.h
 create mode 100644 arch/arm64/kernel/insn.c
 create mode 100644 arch/arm64/kernel/jump_label.c
 create mode 100644 arch/arm64/kernel/sleep.S
 create mode 100644 arch/arm64/kernel/suspend.c
 delete mode 100644 arch/arm64/lib/strncpy_from_user.S
 delete mode 100644 arch/arm64/lib/strnlen_user.S

-- 
Catalin
