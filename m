Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaLIKqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:46:14 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46817 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaLIKqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:46:12 -0500
Date: Tue, 9 Dec 2014 10:46:19 +0000
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com, ard.biesheuvel@linaro.org,
        matt.fleming@intel.com
Subject: [GIT PULL] arm64: updates for 3.19
Message-ID: <20141209104619.GD12815@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the usual mixed bag of arm64 updates, also including some related
EFI changes (Acked by Matt) and the MMU gather range cleanup (Acked by
you). Please can you pull for 3.19?

Cheers,

Will

--->8

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-upstream

for you to fetch changes up to eb8a653137b7e74f7cdc01f814eb9d094a65aed9:

  arm64: remove the unnecessary arm64_swiotlb_init() (2014-12-05 12:19:52 +0000)

----------------------------------------------------------------
arm64 updates for 3.19

Changes include:
 - Support for alternative instruction patching from Andre
 - seccomp from Akashi
 - Some AArch32 instruction emulation, required by the Android folks
 - Optimisations for exception entry/exit code, cmpxchg, pcpu atomics
 - mmu_gather range calculations moved into core code
 - EFI updates from Ard, including long-awaited SMBIOS support
 - /proc/cpuinfo fixes to align with the format used by arch/arm/
 - A few non-critical fixes across the architecture

----------------------------------------------------------------
AKASHI Takahiro (6):
      arm64: ptrace: add NT_ARM_SYSTEM_CALL regset
      arm64: ptrace: allow tracer to skip a system call
      asm-generic: add generic seccomp.h for secure computing mode 1
      arm64: add seccomp syscall for compat task
      arm64: add SIGSYS siginfo for compat task
      arm64: add seccomp support

Andre Przywara (7):
      arm64: add cpu_capabilities bitmap
      arm64: add alternative runtime patching
      arm64: detect silicon revisions and set cap bits accordingly
      arm64: add Cortex-A53 cache errata workaround
      arm64: add Cortex-A57 erratum 832075 workaround
      arm64: protect alternatives workarounds with Kconfig options
      arm64: add module support for alternatives fixups

Ard Biesheuvel (12):
      arm64/efi: efistub: jump to 'stext' directly, not through the header
      arm64/efi: set PE/COFF section alignment to 4 KB
      arm64/efi: set PE/COFF file alignment to 512 bytes
      arm64/efi: invert UEFI memory region reservation logic
      arm64/efi: drop redundant set_bit(EFI_CONFIG_TABLES)
      efi: dmi: add support for SMBIOS 3.0 UEFI configuration table
      dmi: add support for SMBIOS 3.0 64-bit entry point
      arm64: dmi: set DMI string as dump stack arch description
      arm64/dt: add machine name to kernel call stack dump output
      arm64/crypto: use crypto instructions to generate AES key schedule
      arm64: ftrace: eliminate literal pool entries
      arm64: kvm: eliminate literal pool entries

Catalin Marinas (1):
      arm64: Add COMPAT_HWCAP_LPAE

Chunyan Zhang (1):
      arm64/include/asm: Fixed a warning about 'struct pt_regs'

Daniel Thompson (1):
      arm64: perf: Prevent wraparound during overflow

Ding Tianhong (1):
      arm64: remove the unnecessary arm64_swiotlb_init()

Fabio Estevam (1):
      arm64: Provide a namespace to NCAPS

Geoff Levand (1):
      arm64/kvm: Fix assembler compatibility of macros

Joonwoo Park (1):
      arm64: optimize memcpy_{from,to}io() and memset_io()

Jungseok Lee (1):
      arm64: Implement support for read-mostly sections

Laura Abbott (7):
      arm64: Treat handle_arch_irq as a function pointer
      arm64: Switch to adrp for loading the stub vectors
      arm64: Move cpu_resume into the text section
      arm64: Factor out fixmap initialization from ioremap
      arm64: Add FIX_HOLE to permanent fixed addresses
      arm64: add support to dump the kernel page tables
      arm64: Move some head.text functions to executable section

Mark Brown (1):
      arm64: topology: Fix handling of multi-level cluster MPIDR-based detection

Mark Rutland (8):
      efi: efi-stub: notify on DTB absence
      arm64: log physical ID of boot CPU
      arm64: Fix up /proc/cpuinfo
      arm64: pgalloc: consistently use PGALLOC_GFP
      arm64: sanity checks: ignore ID_MMFR0.AuxReg
      arm64: sanity checks: add missing newline to print
      arm64: sanity checks: add ID_AA64DFR{0,1}_EL1
      arm64: jump labels: NOP out NOP -> NOP replacement

Min-Hua Chen (1):
      arm64: fix data type for physical address

Punit Agrawal (6):
      arm64: Add support for hooks to handle undefined instructions
      arm64: Add AArch32 instruction set condition code checks
      arm64: Add framework for legacy instruction emulation
      arm64: Port SWP/SWPB emulation support from arm
      arm64: Emulate CP15 Barrier instructions
      arm64: Trace emulation of AArch32 legacy instructions

Steve Capper (2):
      arm64: xchg: Implement cmpxchg_double
      arm64: percpu: Implement this_cpu operations

Vladimir Murzin (1):
      arm64: compat: align cacheflush syscall with arch/arm

Will Deacon (9):
      Merge tag 'for-3.19' of git://git.linaro.org/people/ard.biesheuvel/linux-arm into ard/efi-for-3.19
      arm64: entry: avoid writing lr explicitly for constructing return paths
      arm64: entry: use ldp/stp instead of push/pop when saving/restoring regs
      mmu_gather: move minimal range calculations into generic code
      arm64: kconfig: move emulation option under kernel features
      arm64: mm: report unhandled level-0 translation faults correctly
      arm64: fix return code check when changing emulation handler
      arm64: vmlinux.lds.S: don't discard .exit.* sections at link-time
      arm64: alternatives: fix pr_fmt string for consistency

Yann Droneaud (1):
      arm64/mm: Remove hack in mmap randomize layout

Yi Li (1):
      arm64: dmi: Add SMBIOS/DMI support

Zi Shen Lim (1):
      arm64: bpf: lift restriction on last instruction

 Documentation/arm64/legacy_instructions.txt |  45 +++
 arch/arm64/Kconfig                          | 187 ++++++++++
 arch/arm64/Kconfig.debug                    |  12 +
 arch/arm64/crypto/Kconfig                   |   5 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c         |   4 +-
 arch/arm64/crypto/aes-ce-cipher.c           | 112 +++++-
 arch/arm64/crypto/aes-ce-setkey.h           |   5 +
 arch/arm64/crypto/aes-glue.c                |  18 +-
 arch/arm64/include/asm/alternative-asm.h    |  29 ++
 arch/arm64/include/asm/alternative.h        |  44 +++
 arch/arm64/include/asm/cache.h              |   2 +
 arch/arm64/include/asm/cacheflush.h         |   2 +-
 arch/arm64/include/asm/cmpxchg.h            |  73 ++++
 arch/arm64/include/asm/compat.h             |   7 +
 arch/arm64/include/asm/cpu.h                |   2 +
 arch/arm64/include/asm/cpufeature.h         |  29 ++
 arch/arm64/include/asm/cputype.h            |   5 +
 arch/arm64/include/asm/dmi.h                |  31 ++
 arch/arm64/include/asm/fixmap.h             |   8 +-
 arch/arm64/include/asm/hwcap.h              |   1 +
 arch/arm64/include/asm/insn.h               |  10 +
 arch/arm64/include/asm/io.h                 |  23 +-
 arch/arm64/include/asm/irq.h                |   3 +-
 arch/arm64/include/asm/kvm_arm.h            |  21 +-
 arch/arm64/include/asm/opcodes.h            |   1 +
 arch/arm64/include/asm/percpu.h             | 215 +++++++++++
 arch/arm64/include/asm/pgalloc.h            |   8 +-
 arch/arm64/include/asm/seccomp.h            |  25 ++
 arch/arm64/include/asm/tlb.h                |  67 +---
 arch/arm64/include/asm/traps.h              |  16 +
 arch/arm64/include/asm/unistd.h             |   3 +
 arch/arm64/include/asm/unistd32.h           |   3 +-
 arch/arm64/kernel/Makefile                  |   7 +-
 arch/arm64/kernel/alternative.c             |  85 +++++
 arch/arm64/kernel/armv8_deprecated.c        | 553 ++++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c              | 111 ++++++
 arch/arm64/kernel/cpuinfo.c                 |  23 +-
 arch/arm64/kernel/efi-entry.S               |   3 +-
 arch/arm64/kernel/efi.c                     |  37 +-
 arch/arm64/kernel/entry-ftrace.S            |  21 +-
 arch/arm64/kernel/entry.S                   | 138 +++----
 arch/arm64/kernel/head.S                    | 434 +++++++++++-----------
 arch/arm64/kernel/insn.c                    |  26 ++
 arch/arm64/kernel/io.c                      |  66 +++-
 arch/arm64/kernel/irq.c                     |   2 +
 arch/arm64/kernel/jump_label.c              |  23 +-
 arch/arm64/kernel/module.c                  |  18 +
 arch/arm64/kernel/perf_event.c              |  10 +-
 arch/arm64/kernel/ptrace.c                  |  40 ++
 arch/arm64/kernel/setup.c                   | 108 ++++--
 arch/arm64/kernel/signal32.c                |   6 +
 arch/arm64/kernel/sleep.S                   |  36 +-
 arch/arm64/kernel/smp.c                     |   2 +
 arch/arm64/kernel/suspend.c                 |   4 +-
 arch/arm64/kernel/sys_compat.c              |  49 ++-
 arch/arm64/kernel/topology.c                |   7 +-
 arch/arm64/kernel/trace-events-emulation.h  |  35 ++
 arch/arm64/kernel/traps.c                   |  66 ++++
 arch/arm64/kernel/vmlinux.lds.S             |  33 +-
 arch/arm64/kvm/hyp.S                        |   4 +-
 arch/arm64/mm/Makefile                      |   1 +
 arch/arm64/mm/cache.S                       |  10 +-
 arch/arm64/mm/dump.c                        | 332 +++++++++++++++++
 arch/arm64/mm/fault.c                       |   2 +-
 arch/arm64/mm/init.c                        |   2 +
 arch/arm64/mm/ioremap.c                     |  93 +----
 arch/arm64/mm/mm.h                          |   1 -
 arch/arm64/mm/mmap.c                        |  12 +-
 arch/arm64/mm/mmu.c                         |  96 ++++-
 arch/arm64/mm/pgd.c                         |   4 +-
 arch/arm64/net/bpf_jit_comp.c               |  13 +-
 arch/microblaze/include/asm/tlb.h           |   3 +-
 arch/powerpc/include/asm/pgalloc.h          |   3 +-
 arch/powerpc/include/asm/tlb.h              |   1 +
 arch/powerpc/mm/hugetlbpage.c               |   2 -
 drivers/firmware/dmi_scan.c                 |  79 +++-
 drivers/firmware/efi/efi.c                  |   4 +
 drivers/firmware/efi/libstub/arm-stub.c     |  11 +-
 drivers/xen/efi.c                           |   1 +
 include/asm-generic/seccomp.h               |  30 ++
 include/asm-generic/tlb.h                   |  57 ++-
 include/linux/efi.h                         |   6 +-
 include/uapi/linux/elf.h                    |   1 +
 mm/memory.c                                 |  30 +-
 84 files changed, 3095 insertions(+), 662 deletions(-)
 create mode 100644 Documentation/arm64/legacy_instructions.txt
 create mode 100644 arch/arm64/crypto/aes-ce-setkey.h
 create mode 100644 arch/arm64/include/asm/alternative-asm.h
 create mode 100644 arch/arm64/include/asm/alternative.h
 create mode 100644 arch/arm64/include/asm/dmi.h
 create mode 100644 arch/arm64/include/asm/opcodes.h
 create mode 100644 arch/arm64/include/asm/seccomp.h
 create mode 100644 arch/arm64/kernel/alternative.c
 create mode 100644 arch/arm64/kernel/armv8_deprecated.c
 create mode 100644 arch/arm64/kernel/cpu_errata.c
 create mode 100644 arch/arm64/kernel/trace-events-emulation.h
 create mode 100644 arch/arm64/mm/dump.c
 create mode 100644 include/asm-generic/seccomp.h
