Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaJGRac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:30:32 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42083 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbaJGRa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:30:29 -0400
Date: Tue, 7 Oct 2014 18:30:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 patches for 3.18
Message-ID: <20141007173007.GA1188@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below for 3.18. Thanks.

The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-upstream

for you to fetch changes up to 0a6479b0ffad8dd236915e271faaf2cbb4cac287:

  arm64: Remove unneeded extern keyword (2014-10-03 14:51:02 +0100)

----------------------------------------------------------------
arm64 updates for 3.18:

- eBPF JIT compiler for arm64
- CPU suspend backend for PSCI (firmware interface) with standard idle
  states defined in DT (generic idle driver to be merged via a different
  tree)
- Support for CONFIG_DEBUG_SET_MODULE_RONX
- Support for unmapped cpu-release-addr (outside kernel linear mapping)
- set_arch_dma_coherent_ops() implemented and bus notifiers removed
- EFI_STUB improvements when base of DRAM is occupied
- Typos in KGDB macros
- Clean-up to (partially) allow kernel building with LLVM
- Other clean-ups (extern keyword, phys_addr_t usage)

----------------------------------------------------------------
Ard Biesheuvel (4):
      arm64: add helper functions to read I-cache attributes
      arm64: don't flag non-aliasing VIPT I-caches as aliasing
      arm64/efi: efistub: cover entire static mem footprint in PE/COFF .text
      arm64/efi: efistub: don't abort if base of DRAM is occupied

Arun Chandran (1):
      arm64: convert part of soft_restart() to assembly

Behan Webster (5):
      arm64: LLVMLinux: Add current_stack_pointer() for arm64
      arm64: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
      arm64: LLVMLinux: Calculate current_thread_info from current_stack_pointer
      arm64: LLVMLinux: Use current_stack_pointer in kernel/traps.c
      arm64: LLVMLinux: Use global stack pointer in return_address()

Catalin Marinas (5):
      Merge arm64 CPU suspend branch
      arm64: Correct ftrace calls to aarch64_insn_gen_branch_imm()
      arm64: Implement set_arch_dma_coherent_ops() to replace bus notifiers
      Revert "arm64: dmi: Add SMBIOS/DMI support"
      arm64: Fix typos in KGDB macros

Daniel Borkmann (1):
      net: bpf: arm64: fix module memory leak when JIT image build fails

Ganapatrao Kulkarni (1):
      arm64:mm: initialize max_mapnr using function set_max_mapnr

Geoff Levand (1):
      arm64: Remove unneeded extern keyword

Jon Masters (1):
      setup: Move unmask of async interrupts after possible earlycon setup

Kyle McMartin (1):
      aarch64: filter $x from kallsyms

Laura Abbott (3):
      arm64: Introduce {set,clear}_pte_bit
      arm64: Add CONFIG_DEBUG_SET_MODULE_RONX support
      arm64: pageattr: Correctly adjust unaligned start addresses

Lorenzo Pieralisi (4):
      Documentation: arm: define DT idle states bindings
      arm64: kernel: refactor the CPU suspend API for retention states
      arm64: kernel: introduce cpu_init_idle CPU operation
      arm64: add PSCI CPU_SUSPEND based cpu_suspend support

Mark Brown (1):
      arm64: insn: Add return statements after BUG_ON()

Mark Charlebois (2):
      arm64: LLVMLinux: Use global stack register variable for aarch64
      arm64: LLVMLinux: Fix inline arm64 assembly for use with clang

Mark Rutland (1):
      arm64: spin-table: handle unmapped cpu-release-addrs

Min-Hua Chen (1):
      arm64: Use phys_addr_t type for physical address

Robert Richter (1):
      arm64: defconfig: increase NR_CPUS default to 64

Robin Murphy (1):
      of: amba: use of_dma_configure for AMBA devices

Sean Paul (1):
      arm64: Use DMA_ERROR_CODE to denote failed allocation

Uwe Kleine-König (1):
      ARM64: make of_device_ids const

Will Deacon (1):
      arm64: debug: don't re-enable debug exceptions on return from el1_dbg

Yi Li (1):
      arm64: dmi: Add SMBIOS/DMI support

Zi Shen Lim (14):
      arm64: introduce aarch64_insn_gen_comp_branch_imm()
      arm64: introduce aarch64_insn_gen_branch_reg()
      arm64: introduce aarch64_insn_gen_cond_branch_imm()
      arm64: introduce aarch64_insn_gen_load_store_reg()
      arm64: introduce aarch64_insn_gen_load_store_pair()
      arm64: introduce aarch64_insn_gen_add_sub_imm()
      arm64: introduce aarch64_insn_gen_bitfield()
      arm64: introduce aarch64_insn_gen_movewide()
      arm64: introduce aarch64_insn_gen_add_sub_shifted_reg()
      arm64: introduce aarch64_insn_gen_data1()
      arm64: introduce aarch64_insn_gen_data2()
      arm64: introduce aarch64_insn_gen_data3()
      arm64: introduce aarch64_insn_gen_logical_shifted_reg()
      arm64: eBPF JIT compiler

 Documentation/devicetree/bindings/arm/cpus.txt     |   8 +
 .../devicetree/bindings/arm/idle-states.txt        | 679 +++++++++++++++++++++
 Documentation/devicetree/bindings/arm/psci.txt     |  14 +-
 Documentation/networking/filter.txt                |   6 +-
 arch/arm64/Kconfig                                 |   7 +-
 arch/arm64/Kconfig.debug                           |  11 +
 arch/arm64/Makefile                                |   1 +
 arch/arm64/include/asm/cacheflush.h                |   4 +
 arch/arm64/include/asm/cachetype.h                 |  20 +
 arch/arm64/include/asm/cpu_ops.h                   |   7 +-
 arch/arm64/include/asm/cpuidle.h                   |  13 +
 arch/arm64/include/asm/debug-monitors.h            |  30 +-
 arch/arm64/include/asm/dma-mapping.h               |   7 +
 arch/arm64/include/asm/insn.h                      | 249 ++++++++
 arch/arm64/include/asm/io.h                        |   2 +-
 arch/arm64/include/asm/kgdb.h                      |   2 +-
 arch/arm64/include/asm/percpu.h                    |   4 +-
 arch/arm64/include/asm/pgtable.h                   |  33 +-
 arch/arm64/include/asm/proc-fns.h                  |   2 +
 arch/arm64/include/asm/suspend.h                   |   1 +
 arch/arm64/include/asm/thread_info.h               |   9 +-
 arch/arm64/kernel/Makefile                         |   1 +
 arch/arm64/kernel/cpuidle.c                        |  31 +
 arch/arm64/kernel/cpuinfo.c                        |  28 +-
 arch/arm64/kernel/efi-stub.c                       |  16 +-
 arch/arm64/kernel/entry.S                          |   1 -
 arch/arm64/kernel/ftrace.c                         |  10 +-
 arch/arm64/kernel/head.S                           |   6 +-
 arch/arm64/kernel/insn.c                           | 671 +++++++++++++++++++-
 arch/arm64/kernel/kgdb.c                           |   4 +-
 arch/arm64/kernel/perf_event.c                     |   2 +-
 arch/arm64/kernel/process.c                        |  30 +-
 arch/arm64/kernel/psci.c                           | 104 ++++
 arch/arm64/kernel/return_address.c                 |   3 +-
 arch/arm64/kernel/setup.c                          |  11 +-
 arch/arm64/kernel/sleep.S                          |  47 +-
 arch/arm64/kernel/smp_spin_table.c                 |  22 +-
 arch/arm64/kernel/stacktrace.c                     |   3 +-
 arch/arm64/kernel/suspend.c                        |  48 +-
 arch/arm64/kernel/traps.c                          |   3 +-
 arch/arm64/mm/Makefile                             |   2 +-
 arch/arm64/mm/dma-mapping.c                        |  33 +-
 arch/arm64/mm/init.c                               |   2 +-
 arch/arm64/mm/mmap.c                               |   2 +-
 arch/arm64/mm/mmu.c                                |   2 +-
 arch/arm64/mm/pageattr.c                           |  97 +++
 arch/arm64/mm/proc.S                               |  15 +
 arch/arm64/net/Makefile                            |   4 +
 arch/arm64/net/bpf_jit.h                           | 169 +++++
 arch/arm64/net/bpf_jit_comp.c                      | 679 +++++++++++++++++++++
 drivers/of/platform.c                              |   7 +-
 kernel/module.c                                    |   2 +-
 scripts/kallsyms.c                                 |   2 +-
 scripts/mod/modpost.c                              |   2 +-
 54 files changed, 2979 insertions(+), 189 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/idle-states.txt
 create mode 100644 arch/arm64/include/asm/cpuidle.h
 create mode 100644 arch/arm64/kernel/cpuidle.c
 create mode 100644 arch/arm64/mm/pageattr.c
 create mode 100644 arch/arm64/net/Makefile
 create mode 100644 arch/arm64/net/bpf_jit.h
 create mode 100644 arch/arm64/net/bpf_jit_comp.c

-- 
Catalin
