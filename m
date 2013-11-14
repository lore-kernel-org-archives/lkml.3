Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab3KNRYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:24:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50527 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3KNRY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:24:28 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: gleb@redhat.com
Subject: [GIT PULL] KVM changes for 3.13
Date: Thu, 14 Nov 2013 18:24:18 +0100
Message-Id: <1384449858-12875-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 34ec4de42be5006abdd8d0c08b306ffaa64d0d5d:

  Merge tag 'devicetree-for-linus' of git://git.secretlab.ca/git/linux (2013-10-15 17:14:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e504c9098ed6acd9e1079c5e10e4910724ad429f:

  kvm, vmx: Fix lazy FPU on nested guest (2013-11-13 18:46:54 +0100)

Not using -rc1 as usual as the base, because the PPC guys based
their 3.13 work on something after -rc4, and decided to do the same
for KVM-PPC.  The above commit comes just after -rc5; the backmerge
is commit 13acfd571514 (Powerpc KVM work is based on a commit after rc4).

With all the work going into PPC, there were unfortunately some duplicate
commits, and with them came conflicts.  Your tree has already the correct
version of the affected files, except for arch/powerpc/kernel/traps.c
which has bad coding style in your tree and good in ours.

----------------------------------------------------------------
Here are the 3.13 KVM changes.  There was a lot of work on the PPC
side: the HV and emulation flavors can now coexist in a single kernel
is probably the most interesting change from a user point of view.
On the x86 side there are nested virtualization improvements and a
few bugfixes.  ARM got transparent huge page support, improved
overcommit, and support for big endian guests.

Finally, there is a new interface to connect KVM with VFIO.  This
helps with devices that use NoSnoop PCI transactions, letting the
driver in the guest execute WBINVD instructions.  This includes
some nVidia cards on Windows, that fail to start without these
patches and the corresponding userspace changes.

----------------------------------------------------------------
Alex Williamson (3):
      kvm: Add VFIO device
      kvm/x86: Convert iommu_flags to iommu_noncoherent
      kvm: Create non-coherent DMA registeration

Andre Richter (1):
      virt/kvm/iommu.c: Add leading zeros to device's BDF notation in debug messages

Aneesh Kumar K.V (11):
      kvm: powerpc: book3s: pr: Rename KVM_BOOK3S_PR to KVM_BOOK3S_PR_POSSIBLE
      kvm: powerpc: book3s: Add a new config variable CONFIG_KVM_BOOK3S_HV_POSSIBLE
      kvm: powerpc: Add kvmppc_ops callback
      kvm: powerpc: book3s: Cleanup interrupt handling code
      kvm: powerpc: book3s: Add is_hv_enabled to kvmppc_ops
      kvm: powerpc: book3s: pr: move PR related tracepoints to a separate header
      kvm: powerpc: booke: Move booke related tracepoints to separate header
      kvm: powerpc: book3s: Support building HV and PR KVM as module
      kvm: Add struct kvm arg to memslot APIs
      kvm: powerpc: book3s: Allow the HV and PR selection per virtual machine
      kvm: powerpc: book3s: drop is_hv_enabled

Anthoine Bourgeois (1):
      kvm, vmx: Fix lazy FPU on nested guest

Anup Patel (5):
      KVM: ARM: Fix typo in comments of inject_abt()
      ARM: KVM: Implement kvm_vcpu_preferred_target() function
      ARM64: KVM: Implement kvm_vcpu_preferred_target() function
      ARM/ARM64: KVM: Implement KVM_ARM_PREFERRED_TARGET ioctl
      KVM: Add documentation for KVM_ARM_PREFERRED_TARGET ioctl

Arthur Chunqi Li (1):
      KVM: nVMX: Fully support nested VMX preemption timer

Bharat Bhushan (10):
      powerpc: book3e: _PAGE_LENDIAN must be _PAGE_ENDIAN
      kvm: powerpc: allow guest control "E" attribute in mas2
      kvm: powerpc: allow guest control "G" attribute in mas2
      kvm: powerpc: e500: mark page accessed when mapping a guest page
      powerpc: remove unnecessary line continuations
      powerpc: move debug registers in a structure
      powerpc: export debug registers save function for KVM
      KVM: PPC: E500: exit to user space on "ehpriv 1" instruction
      KVM: PPC: E500: Using "struct debug_reg"
      KVM: PPC: E500: Add userspace debug stub support

Borislav Petkov (6):
      kvm: Add KVM_GET_EMULATED_CPUID
      kvm, emulator: Use opcode length
      kvm, emulator: Rename VendorSpecific flag
      kvm, emulator: Add initial three-byte insns support
      kvm: Emulate MOVBE
      kvm, cpuid: Fix sparse warning

Christoffer Dall (14):
      KVM: Move gfn_to_index to x86 specific code
      KVM: ARM: Get rid of KVM_HPAGE defines
      KVM: arm64: Get rid of KVM_HPAGE defines
      KVM: mips: Get rid of KVM_HPAGE defines
      KVM: ia64: Get rid of KVM_HPAGE defines
      KVM: PPC: Get rid of KVM_HPAGE defines
      KVM: s390: Get rid of KVM_HPAGE defines
      KVM: ARM: Remove non-ASCII space characters
      KVM: ARM: Update comments for kvm_handle_wfi
      KVM: ARM: Update comments for kvm_handle_wfi
      KVM: ARM: Support hugetlbfs backed huge pages
      KVM: ARM: Transparent huge page (THP) support
      Merge remote-tracking branch 'kvm/next' into kvm-arm-next
      Merge branch 'kvm-arm-next-3.13-2' into kvm-arm-next

Gleb Natapov (11):
      KVM: nVMX: Amend nested_run_pending logic
      KVM: nVMX: Do not put exception that caused vmexit to IDT_VECTORING_INFO
      KVM: nVMX: Check all exceptions for intercept during delivery to L2
      KVM: nVMX: Do not generate #DF if #PF happens during exception delivery into L2
      Merge tag 'kvm-arm-for-3.13-1' of git://git.linaro.org/people/cdall/linux-kvm-arm into next
      Powerpc KVM work is based on a commit after rc4.
      Merge branch 'kvm-ppc-queue' of git://github.com/agraf/linux-2.6 into queue
      KVM: emulator: check rex prefix inside decode_register()
      KVM: emulator: cleanup decode_register_operand() a bit
      KVM: x86: trace cpuid emulation when called from emulator
      KVM: remove vm mmap method

Greg Edwards (1):
      KVM: IOMMU: hva align mapping page size

Jan Kiszka (7):
      KVM: nVMX: Replace kvm_set_cr0 with vmx_set_cr0 in load_vmcs12_host_state
      KVM: nVMX: Do not set identity page map for L2
      KVM: nVMX: Implement support for EFER saving on VM-exit
      KVM: nVMX: Enable unrestricted guest mode support
      KVM: nVMX: Report 2MB EPT pages as supported
      nVMX: Fix pick-up of uninjected NMIs
      nVMX: Report CPU_BASED_VIRTUAL_NMI_PENDING as supported

Jonathan Austin (3):
      KVM: ARM: Fix calculation of virtual CPU ID
      KVM: ARM: fix the size of TTBCR_{T0SZ,T1SZ} masks
      KVM: ARM: Add support for Cortex-A7

Josh Triplett (2):
      kvm: Delete prototype for non-existent function complete_pio
      kvm: Delete prototype for non-existent function kvm_check_iopl

Marc Zyngier (9):
      ARM: KVM: Yield CPU when vcpu executes a WFE
      ARM: KVM: Yield CPU when vcpu executes a WFE
      ARM: KVM: Fix MPIDR computing to support virtual clusters
      ARM: KVM: fix L2CTLR to be per-cluster
      ARM: KVM: drop limitation to 4 CPU VMs
      arm/arm64: KVM: PSCI: use MPIDR to identify a target CPU
      arm64: KVM: Yield CPU when vcpu executes a WFE
      arm/arm64: KVM: MMIO support for BE guest
      arm/arm64: KVM: PSCI: propagate caller endianness to the incoming vcpu

Marcelo Tosatti (2):
      pvclock: detect watchdog reset at pvclock read
      hung_task: add method to reset detector

Michael Neuling (1):
      KVM: PPC: Book3S HV: Reserve POWER8 space in get/set_one_reg

Michael S. Tsirkin (4):
      kvm/vmx: error message typo fix
      kvm_host: typo fix
      srcu: API for barrier after srcu read unlock
      kvm: optimize out smp_mb after srcu_read_unlock

Paolo Bonzini (17):
      KVM: cleanup (physical) CPU hotplug
      KVM: protect kvm_usage_count with its own spinlock
      KVM: Convert kvm_lock back to non-raw spinlock
      KVM: x86: mask unsupported XSAVE entries from leaf 0Dh index 0
      KVM: x86: prevent setting unsupported XSAVE states
      KVM: x86: only copy XSAVE state for the supported features
      KVM: mmu: remove uninteresting MMU "free" callbacks
      KVM: mmu: remove uninteresting MMU "new_cr3" callbacks
      KVM: mmu: unify destroy_kvm_mmu with kvm_mmu_unload
      KVM: mmu: change useless int return types to void
      Merge tag 'kvm-arm-for-3.13-2' of git://git.linaro.org/people/cdall/linux-kvm-arm into kvm-queue
      KVM: x86: fix KVM_SET_XCRS for CPUs that do not support XSAVE
      KVM: x86: fix KVM_SET_XCRS loop
      KVM: x86: emulate SAHF instruction
      KVM: x86: fix emulation of "movzbl %bpl, %eax"
      Merge tag 'kvm-arm-for-3.13-3' of git://git.linaro.org/people/cdall/linux-kvm-arm into kvm-next
      Merge tag 'kvm-arm64/for-3.13-1' of git://git.kernel.org/.../maz/arm-platforms into kvm-next

Paul Mackerras (29):
      KVM: PPC: Book3S HV: Save/restore SIAR and SDAR along with other PMU registers
      KVM: PPC: Book3S HV: Implement timebase offset for guests
      KVM: PPC: Book3S: Add GET/SET_ONE_REG interface for VRSAVE
      KVM: PPC: Book3S HV: Implement H_CONFER
      KVM: PPC: Book3S HV: Restructure kvmppc_hv_entry to be a subroutine
      KVM: PPC: Book3S HV: Pull out interrupt-reading code into a subroutine
      KVM: PPC: Book3S HV: Avoid unbalanced increments of VPA yield count
      KVM: PPC: BookE: Add GET/SET_ONE_REG interface for VRSAVE
      KVM: PPC: Book3S HV: Store LPCR value for each virtual core
      KVM: PPC: Book3S HV: Add support for guest Program Priority Register
      KVM: PPC: Book3S HV: Support POWER6 compatibility mode on POWER7
      KVM: PPC: Book3S HV: Don't crash host on unknown guest interrupt
      KVM: PPC: Book3S PR: Fix compilation without CONFIG_ALTIVEC
      KVM: PPC: Book3S PR: Keep volatile reg values in vcpu rather than shadow_vcpu
      KVM: PPC: Book3S PR: Allow guest to use 64k pages
      KVM: PPC: Book3S PR: Use 64k host pages where possible
      KVM: PPC: Book3S PR: Handle PP0 page-protection bit in guest HPTEs
      KVM: PPC: Book3S PR: Correct errors in H_ENTER implementation
      KVM: PPC: Book3S PR: Make HPT accesses and updates SMP-safe
      KVM: PPC: Book3S PR: Allocate kvm_vcpu structs from kvm_vcpu_cache
      KVM: PPC: Book3S: Move skip-interrupt handlers to common code
      KVM: PPC: Book3S PR: Better handling of host-side read-only pages
      KVM: PPC: Book3S PR: Use mmu_notifier_retry() in kvmppc_mmu_map_page()
      KVM: PPC: Book3S PR: Mark pages accessed, and dirty if being written
      KVM: PPC: Book3S PR: Reduce number of shadow PTEs invalidated by MMU notifiers
      kvm: powerpc: book3s hv: Fix vcore leak
      KVM: PPC: Book3S HV: Better handling of exceptions that happen in real mode
      kvm: powerpc: book3s: remove kvmppc_handler_highmem label
      kvm: powerpc: book3s: move book3s_64_vio_hv.c into the main kernel binary

Radim Krčmář (1):
      kvm: remove .done from struct kvm_async_pf

Raghavendra K T (1):
      Documentation/kvm: Update cpuid documentation for steal time and pv eoi

Ramkumar Ramachandra (3):
      MAINTAINERS: fix broken link to www.linux-kvm.org
      Documentation/kvm: add a 00-INDEX file
      MAINTAINERS: add tree for kvm.git

Thomas Huth (9):
      KVM: Add documentation for kvm->srcu lock
      KVM: s390: Remove dead "rerun vcpu" code
      KVM: s390: Split up __vcpu_run into three parts
      KVM: s390: Push run loop into __vcpu_run
      KVM: s390: Lock kvm->srcu at the appropriate places
      KVM: s390: Allow NULL parameter for kvm_s390_get_regs_rre
      KVM: s390: Helper for converting real addresses to absolute
      KVM: s390: Implement TEST BLOCK
      KVM: s390: Intercept SCK instruction

Yang Zhang (1):
      KVM: Mapping IOMMU pages after updating memslot

chai wen (1):
      KVM: Drop FOLL_GET in GUP when doing async page fault

 Documentation/virtual/kvm/00-INDEX         |  24 ++
 Documentation/virtual/kvm/api.txt          | 152 ++++++-
 Documentation/virtual/kvm/cpuid.txt        |   7 +
 Documentation/virtual/kvm/devices/vfio.txt |  22 +
 Documentation/virtual/kvm/locking.txt      |  19 +-
 MAINTAINERS                                |   3 +-
 arch/arm/include/asm/kvm_arm.h             |   9 +-
 arch/arm/include/asm/kvm_asm.h             |   2 +-
 arch/arm/include/asm/kvm_emulate.h         |  51 +++
 arch/arm/include/asm/kvm_host.h            |   6 +-
 arch/arm/include/asm/kvm_mmu.h             |  17 +-
 arch/arm/include/asm/pgtable-3level.h      |   2 +
 arch/arm/include/uapi/asm/kvm.h            |   3 +-
 arch/arm/kvm/Kconfig                       |   1 +
 arch/arm/kvm/Makefile                      |   2 +-
 arch/arm/kvm/arm.c                         |  18 +-
 arch/arm/kvm/coproc.c                      | 120 ++++++
 arch/arm/kvm/coproc_a15.c                  | 117 +-----
 arch/arm/kvm/coproc_a7.c                   |  54 +++
 arch/arm/kvm/emulate.c                     |   2 +-
 arch/arm/kvm/guest.c                       |  24 +-
 arch/arm/kvm/handle_exit.c                 |  20 +-
 arch/arm/kvm/mmio.c                        |  86 +++-
 arch/arm/kvm/mmu.c                         | 223 +++++++++--
 arch/arm/kvm/psci.c                        |  21 +-
 arch/arm/kvm/reset.c                       |  15 +-
 arch/arm64/include/asm/kvm_arm.h           |   8 +-
 arch/arm64/include/asm/kvm_emulate.h       |  61 +++
 arch/arm64/include/asm/kvm_host.h          |   6 +-
 arch/arm64/include/asm/kvm_mmu.h           |  12 +-
 arch/arm64/include/asm/pgtable-hwdef.h     |   2 +
 arch/arm64/kvm/Kconfig                     |   1 +
 arch/arm64/kvm/guest.c                     |  20 +
 arch/arm64/kvm/handle_exit.c               |  18 +-
 arch/ia64/include/asm/kvm_host.h           |   6 +-
 arch/ia64/kvm/kvm-ia64.c                   |   5 +-
 arch/mips/include/asm/kvm_host.h           |   7 -
 arch/mips/kvm/kvm_mips.c                   |   5 +-
 arch/powerpc/include/asm/disassemble.h     |   4 +
 arch/powerpc/include/asm/exception-64s.h   |  21 +-
 arch/powerpc/include/asm/kvm_asm.h         |   4 +
 arch/powerpc/include/asm/kvm_book3s.h      | 232 +----------
 arch/powerpc/include/asm/kvm_book3s_32.h   |   2 +-
 arch/powerpc/include/asm/kvm_book3s_64.h   |   8 +-
 arch/powerpc/include/asm/kvm_book3s_asm.h  |   9 +-
 arch/powerpc/include/asm/kvm_booke.h       |   7 +-
 arch/powerpc/include/asm/kvm_host.h        |  57 +--
 arch/powerpc/include/asm/kvm_ppc.h         | 107 +++--
 arch/powerpc/include/asm/paca.h            |   2 +-
 arch/powerpc/include/asm/processor.h       |  37 +-
 arch/powerpc/include/asm/pte-book3e.h      |   2 +-
 arch/powerpc/include/asm/reg.h             |  15 +
 arch/powerpc/include/asm/reg_booke.h       |   8 +-
 arch/powerpc/include/asm/switch_to.h       |   1 +
 arch/powerpc/include/uapi/asm/kvm.h        |  86 +++-
 arch/powerpc/kernel/asm-offsets.c          |  23 +-
 arch/powerpc/kernel/exceptions-64s.S       |  30 +-
 arch/powerpc/kernel/idle_power7.S          |   2 +-
 arch/powerpc/kernel/process.c              |  45 ++-
 arch/powerpc/kernel/ptrace.c               | 154 +++----
 arch/powerpc/kernel/ptrace32.c             |   2 +-
 arch/powerpc/kernel/signal_32.c            |   6 +-
 arch/powerpc/kernel/traps.c                |  35 +-
 arch/powerpc/kvm/44x.c                     |  58 ++-
 arch/powerpc/kvm/44x_emulate.c             |   8 +-
 arch/powerpc/kvm/44x_tlb.c                 |   2 +-
 arch/powerpc/kvm/Kconfig                   |  28 +-
 arch/powerpc/kvm/Makefile                  |  29 +-
 arch/powerpc/kvm/book3s.c                  | 257 +++++++++++-
 arch/powerpc/kvm/book3s.h                  |  34 ++
 arch/powerpc/kvm/book3s_32_mmu.c           |  73 ++--
 arch/powerpc/kvm/book3s_32_mmu_host.c      |  16 +-
 arch/powerpc/kvm/book3s_64_mmu.c           | 181 +++++++--
 arch/powerpc/kvm/book3s_64_mmu_host.c      | 106 +++--
 arch/powerpc/kvm/book3s_64_mmu_hv.c        |  24 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c        |   1 +
 arch/powerpc/kvm/book3s_emulate.c          |  18 +-
 arch/powerpc/kvm/book3s_exports.c          |   5 +-
 arch/powerpc/kvm/book3s_hv.c               | 389 ++++++++++++++----
 arch/powerpc/kvm/book3s_hv_interrupts.S    |   3 -
 arch/powerpc/kvm/book3s_hv_rmhandlers.S    | 618 +++++++++++++++++------------
 arch/powerpc/kvm/book3s_interrupts.S       |  32 +-
 arch/powerpc/kvm/book3s_mmu_hpte.c         |  66 ++-
 arch/powerpc/kvm/book3s_pr.c               | 498 ++++++++++++++++-------
 arch/powerpc/kvm/book3s_pr_papr.c          |  52 ++-
 arch/powerpc/kvm/book3s_rmhandlers.S       |  32 +-
 arch/powerpc/kvm/book3s_rtas.c             |   1 +
 arch/powerpc/kvm/book3s_segment.S          |   4 +-
 arch/powerpc/kvm/book3s_xics.c             |   7 +-
 arch/powerpc/kvm/booke.c                   | 337 ++++++++++++++--
 arch/powerpc/kvm/booke.h                   |  29 ++
 arch/powerpc/kvm/e500.c                    |  59 ++-
 arch/powerpc/kvm/e500.h                    |   2 +-
 arch/powerpc/kvm/e500_emulate.c            |  34 +-
 arch/powerpc/kvm/e500_mmu.c                |   4 +-
 arch/powerpc/kvm/e500_mmu_host.c           |   6 +-
 arch/powerpc/kvm/e500mc.c                  |  58 ++-
 arch/powerpc/kvm/emulate.c                 |  12 +-
 arch/powerpc/kvm/powerpc.c                 | 171 ++++----
 arch/powerpc/kvm/trace.h                   | 429 --------------------
 arch/powerpc/kvm/trace_booke.h             | 177 +++++++++
 arch/powerpc/kvm/trace_pr.h                | 297 ++++++++++++++
 arch/s390/include/asm/kvm_host.h           |   8 -
 arch/s390/kvm/diag.c                       |   4 +-
 arch/s390/kvm/gaccess.h                    |  21 +-
 arch/s390/kvm/intercept.c                  |   6 -
 arch/s390/kvm/interrupt.c                  |   3 +
 arch/s390/kvm/kvm-s390.c                   |  96 +++--
 arch/s390/kvm/kvm-s390.h                   |   9 +-
 arch/s390/kvm/priv.c                       |  61 +++
 arch/x86/include/asm/kvm_emulate.h         |  10 +-
 arch/x86/include/asm/kvm_host.h            |  23 +-
 arch/x86/include/asm/pvclock.h             |   2 +
 arch/x86/include/uapi/asm/kvm.h            |   6 +-
 arch/x86/include/uapi/asm/msr-index.h      |   1 +
 arch/x86/kernel/kvmclock.c                 |   1 +
 arch/x86/kernel/pvclock.c                  |  13 +
 arch/x86/kvm/Kconfig                       |   1 +
 arch/x86/kvm/Makefile                      |   2 +-
 arch/x86/kvm/cpuid.c                       | 115 +++++-
 arch/x86/kvm/cpuid.h                       |   5 +-
 arch/x86/kvm/emulate.c                     | 130 ++++--
 arch/x86/kvm/mmu.c                         | 115 ++----
 arch/x86/kvm/mmu.h                         |   4 +-
 arch/x86/kvm/svm.c                         |   8 +-
 arch/x86/kvm/vmx.c                         | 158 +++++---
 arch/x86/kvm/x86.c                         | 108 +++--
 arch/x86/kvm/x86.h                         |   1 +
 include/linux/kvm_host.h                   |  42 +-
 include/linux/sched.h                      |   8 +
 include/linux/srcu.h                       |  14 +
 include/trace/events/kvm.h                 |  10 +-
 include/uapi/linux/kvm.h                   |  11 +
 kernel/hung_task.c                         |  11 +
 virt/kvm/Kconfig                           |   3 +
 virt/kvm/async_pf.c                        |  22 +-
 virt/kvm/iommu.c                           |  38 +-
 virt/kvm/kvm_main.c                        | 134 +++----
 virt/kvm/vfio.c                            | 264 ++++++++++++
 139 files changed, 5317 insertions(+), 2378 deletions(-)
 create mode 100644 Documentation/virtual/kvm/00-INDEX
 create mode 100644 Documentation/virtual/kvm/devices/vfio.txt
 create mode 100644 arch/arm/kvm/coproc_a7.c
 create mode 100644 arch/powerpc/kvm/book3s.h
 create mode 100644 arch/powerpc/kvm/trace_booke.h
 create mode 100644 arch/powerpc/kvm/trace_pr.h
 create mode 100644 virt/kvm/vfio.c
