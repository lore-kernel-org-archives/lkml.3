Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaFDK60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:58:26 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:50290 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaFDK6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:58:23 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.16
Date: Wed,  4 Jun 2014 12:58:05 +0200
Message-Id: <1401879485-10706-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 0f689a33ad17845363acdc6d52783befd6ad116c:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2014-04-16 11:28:25 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 820b3fcdeb80d30410f4427d2cbf9161c35fdeef:

  KVM: add missing cleanup_srcu_struct (2014-06-03 13:44:17 +0200)

----------------------------------------------------------------
At over 200 commits, covering almost all supported architectures, this
was a pretty active cycle for KVM.  Changes include:

- a lot of s390 changes: optimizations, support for migration,
  GDB support and more

- ARM changes are pretty small: support for the PSCI 0.2 hypercall
  interface on both the guest and the host (the latter acked by Catalin)

- initial POWER8 and little-endian host support

- support for running u-boot on embedded POWER targets

- pretty large changes to MIPS too, completing the userspace interface
  and improving the handling of virtualized timer hardware

- for x86, a larger set of changes is scheduled for 3.17.  Still,
  we have a few emulator bugfixes and support for running nested
  fully-virtualized Xen guests (para-virtualized Xen guests have
  always worked).  And some optimizations too.

The only missing architecture here is ia64.  It's not a coincidence
that support for KVM on ia64 is scheduled for removal in 3.17.

----------------------------------------------------------------
Alexander Graf (27):
      KVM: PPC: E500: Ignore L1CSR1_ICFI,ICLFR
      KVM: PPC: E500: Add dcbtls emulation
      KVM: PPC: Book3S: PR: Fix C/R bit setting
      KVM: PPC: Book3S_32: PR: Access HTAB in big endian
      KVM: PPC: Book3S_64 PR: Access HTAB in big endian
      KVM: PPC: Book3S_64 PR: Access shadow slb in big endian
      KVM: PPC: Book3S PR: Default to big endian guest
      KVM: PPC: Book3S PR: PAPR: Access HTAB in big endian
      KVM: PPC: Book3S PR: PAPR: Access RTAS in big endian
      KVM: PPC: PR: Fill pvinfo hcall instructions in big endian
      KVM: PPC: Make shared struct aka magic page guest endian
      KVM: PPC: Book3S PR: Do dcbz32 patching with big endian instructions
      KVM: PPC: Book3S: Move little endian conflict to HV KVM
      KVM: PPC: Book3S PR: Ignore PMU SPRs
      KVM: PPC: Book3S PR: Emulate TIR register
      KVM: PPC: Book3S PR: Handle Facility interrupt and FSCR
      KVM: PPC: Book3S PR: Expose TAR facility to guest
      KVM: PPC: Book3S PR: Expose EBB registers
      KVM: PPC: Book3S PR: Expose TM registers
      KVM: PPC: Disable NX for old magic page using guests
      PPC: KVM: Make NX bit available with magic page
      PPC: ePAPR: Fix hypercall on LE guest
      KVM: PPC: Graciously fail broken LE hypercalls
      KVM: PPC: MPIC: Reset IRQ source private members
      KVM: PPC: Add CAP to indicate hcall fixes
      KVM: PPC: Book3S PR: Use SLB entry 0
      KVM: PPC: Book3S PR: Rework SLB switching code

Alexander Yarygin (4):
      KVM: s390: add sie exit reasons tables
      KVM: s390: Use trace tables from sie.h.
      KVM: s390: decoder of SIE intercepted instructions
      KVM: s390: Use intercept_insn decoder in trace event

Alexey Kardashevskiy (1):
      KVM: PPC: Book3S HV: Fix dirty map for hugepages

Aneesh Kumar K.V (6):
      KVM: PPC: BOOK3S: PR: Enable Little Endian PR guest
      KVM: PPC: BOOK3S: PR: Fix WARN_ON with debug options on
      KVM: PPC: BOOK3S: HV: Prefer CMA region for hash page table allocation
      KVM: PPC: BOOK3S: HV: Add mixed page-size support for guest
      KVM: PPC: BOOK3S: Always use the saved DAR value
      KVM: PPC: BOOK3S: Remove open coded make_dsisr in alignment handler

Anup Patel (12):
      KVM: Add capability to advertise PSCI v0.2 support
      ARM/ARM64: KVM: Add common header for PSCI related defines
      ARM/ARM64: KVM: Add base for PSCI v0.2 emulation
      KVM: Documentation: Add info regarding KVM_ARM_VCPU_PSCI_0_2 feature
      ARM/ARM64: KVM: Make kvm_psci_call() return convention more flexible
      KVM: Add KVM_EXIT_SYSTEM_EVENT to user space API header
      ARM/ARM64: KVM: Emulate PSCI v0.2 SYSTEM_OFF and SYSTEM_RESET
      ARM/ARM64: KVM: Emulate PSCI v0.2 AFFINITY_INFO
      ARM/ARM64: KVM: Emulate PSCI v0.2 MIGRATE_INFO_TYPE and related functions
      ARM/ARM64: KVM: Fix CPU_ON emulation for PSCI v0.2
      ARM/ARM64: KVM: Emulate PSCI v0.2 CPU_SUSPEND
      ARM/ARM64: KVM: Advertise KVM_CAP_ARM_PSCI_0_2 to user space

Ashwin Chaugule (3):
      PSCI: Add initial support for PSCIv0.2 functions
      Documentation: devicetree: Add new binding for PSCIv0.2
      ARM: Check if a CPU has gone offline

Bandan Das (7):
      KVM: nVMX: Don't advertise single context invalidation for invept
      KVM: nVMX: Ack and write vector info to intr_info if L1 asks us to
      KVM: nVMX: Advertise support for interrupt acknowledgement
      KVM: nVMX: rearrange get_vmx_mem_address
      KVM: nVMX: additional checks on vmxon region
      KVM: nVMX: fail on invalid vmclear/vmptrld pointer
      KVM: nVMX: move vmclear and vmptrld pre-checks to nested_vmx_check_vmptr

Christian Borntraeger (2):
      KVM: s390: Drop pending interrupts on guest exit
      kvm/irqchip: Speed up KVM_SET_GSI_ROUTING

Christoffer Dall (1):
      arm: Fix compile warning for psci

Cornelia Huck (1):
      KVM: s390: reinject io interrupt on tpi failure

Dan Carpenter (1):
      KVM: s390: return -EFAULT if copy_from_user() fails

Dave Hansen (1):
      x86: fix page fault tracing when KVM guest support enabled

David Hildenbrand (13):
      KVM: s390: extract irq parameters of intercepted program irqs
      KVM: s390: deliver program irq parameters and use correct ilc
      KVM: s390: emulate stctl and stctg
      KVM: s390: kernel header addition for guest debugging
      KVM: s390: hardware support for guest debugging
      KVM: s390: add documentation for diag 501
      KVM: s390: move timer interrupt checks into own functions
      KVM: s390: no timer interrupts when single-stepping a guest
      KVM: s390: introduce kvm_s390_vcpu_{start,stop}
      KVM: s390: enable IBS for single running VCPUs
      KVM: s390: interpretive execution of SIGP EXTERNAL CALL
      KVM: s390: check the given debug flags, not the set ones
      KVM: s390: a VCPU is already started when delivering interrupts

Deng-Cheng Zhu (1):
      MIPS: KVM: remove the stale memory alias support function unalias_gfn

Dominik Dingel (8):
      KVM: s390: Adding skey bit to mmu context
      KVM: s390: Clear storage keys
      KVM: s390: Allow skeys to be enabled for the current process
      KVM: s390: Don't enable skeys by default
      KVM: s390/mm: new gmap_test_and_clear_dirty function
      KVM: s390: Per-vm kvm device controls
      KVM: s390: make cmma usage conditionally
      KVM: s390: Exploiting generic userspace interface for cmma

Gabriel L. Somlo (1):
      kvm: x86: emulate monitor and mwait instructions as nop

Heiko Carstens (27):
      KVM: add kvm_is_error_gpa() helper
      KVM: s390: export test_vfacility()
      s390/ptrace: add struct psw and accessor function
      s390/ctl_reg: add union type for control register 0
      KVM: s390: add kvm_s390_logical_to_effective() helper
      KVM: s390: add 'pgm' member to kvm_vcpu_arch and helper function
      KVM: s390: add lowcore access functions
      KVM: s390: add architecture compliant guest access functions
      KVM: s390/sclp: correctly set eca siif bit
      KVM: s390: make use of ipte lock
      KVM: s390: convert __do_deliver_interrupt()
      KVM: s390: convert handle_stfl()
      KVM: s390: convert pfault code
      KVM: s390: convert handle_prog()
      KVM: s390: convert kvm_s390_store_status_unloaded()
      KVM: s390: convert __sigp_set_prefix()/handle_set_prefix()
      KVM: s390: convert handle_set_clock()
      KVM: s390: convert handle_store_prefix()
      KVM: s390: convert handle_store_cpu_address()
      KVM: s390: convert handle_test_block()
      KVM: s390: convert handle_tpi()
      KVM: s390: convert handle_lpsw[e]()
      KVM: s390: convert handle_stidp()
      KVM: s390: convert handle lctl[g]()
      KVM: s390: convert handle_stsi()
      KVM: s390: remove old guest access functions
      KVM: s390: cleanup kvm_s390_real_to_abs()

Huw Davies (1):
      KVM: VMX: Advance rip to after an ICEBP instruction

James Hogan (23):
      MIPS: KVM: Allocate at least 16KB for exception handlers
      MIPS: Export local_flush_icache_range for KVM
      MIPS: KVM: Use local_flush_icache_range to fix RI on XBurst
      MIPS: KVM: Use tlb_write_random
      MIPS: KVM: Add CP0_EPC KVM register access
      MIPS: KVM: Move KVM_{GET,SET}_ONE_REG definitions into kvm_host.h
      MIPS: KVM: Add CP0_Count/Compare KVM register access
      MIPS: KVM: Add CP0_UserLocal KVM register access
      MIPS: KVM: Add CP0_HWREna KVM register access
      MIPS: KVM: Deliver guest interrupts after local_irq_disable()
      MIPS: KVM: Fix timer race modifying guest CP0_Cause
      MIPS: KVM: Migrate hrtimer to follow VCPU
      MIPS: KVM: Rewrite count/compare timer emulation
      MIPS: KVM: Override guest kernel timer frequency directly
      MIPS: KVM: Add master disable count interface
      MIPS: KVM: Add count frequency KVM register
      MIPS: KVM: Make kvm_mips_comparecount_{func,wakeup} static
      MIPS: KVM: Whitespace fixes in kvm_mips_callbacks
      MIPS: KVM: Fix kvm_debug bit-rottage
      MIPS: KVM: Remove ifdef DEBUG around kvm_debug
      MIPS: KVM: Quieten kvm_info() logging
      MIPS: KVM: Remove redundant NULL checks before kfree()
      MIPS: KVM: Remove redundant semicolon

Jan Kiszka (1):
      KVM: x86: Fix CR3 reserved bits check in long mode

Jason J. Herne (1):
      KVM: s390: Add proper dirty bitmap support to S390 kvm.

Jens Freimann (6):
      KVM: s390: allow injecting every kind of interrupt
      KVM: s390: convert local irqs in  __do_deliver_interrupt()
      s390: fix name of lowcore field at offset 0xa3
      s390: rename and split lowcore field per_perc_atmid
      s390: add fields to lowcore definition
      KVM: s390: clean up interrupt injection in sigp code

Marc Zyngier (1):
      arm64: KVM: Enable minimalistic support for Cortex-A53

Marcelo Tosatti (2):
      Merge tag 'kvm-s390-20140422' of git://git.kernel.org/.../kvms390/linux into queue
      KVM: x86: expose invariant tsc cpuid bit (v2)

Martin Schwidefsky (2):
      KVM: s390/mm: use software dirty bit detection for user dirty tracking
      KVM: s390: correct locking for s390_enable_skey

Matthew Rosato (1):
      KVM: s390: Intercept the tprot instruction

Michael Mueller (4):
      KVM: s390: replace TDB_ADDR by __LC_PGM_TDB
      KVM: s390: Factor out handle_itdb to handle TX aborts
      s390/sclp: add sclp_get_ibc function
      KVM: s390: split SIE state guest prefix field

Michael S. Tsirkin (3):
      KVM: support any-length wildcard ioeventfd
      KVM: VMX: speed up wildcard MMIO EVENTFD
      kvm/x86: implement hv EOI assist

Nadav Amit (10):
      KVM: x86: Fix page-tables reserved bits
      KVM: x86: Fix CR3 and LDT sel should not be saved in TSS
      KVM: x86: Fix wrong/stuck PMU when guest does not use PMI
      KVM: x86: Fix CR3 reserved bits
      KVM: x86: IN instruction emulation should ignore REP-prefix
      KVM: x86: Processor mode may be determined incorrectly
      KVM: vmx: handle_dr does not handle RSP correctly
      KVM: x86: Mark bit 7 in long-mode PDPTE according to 1GB pages support
      KVM: vmx: DR7 masking on task switch emulation is wrong
      KVM: x86: MOV CR/DR emulation should ignore mod

Oleg Nesterov (2):
      KVM: async_pf: kill the unnecessary use_mm/unuse_mm async_pf_execute()
      KVM: async_pf: change async_pf_execute() to use get_user_pages(tsk => NULL)

Paolo Bonzini (12):
      Merge tag 'kvm-s390-20140429' of git://git.kernel.org/.../kvms390/linux into kvm-next
      Merge tag 'kvm-s390-20140506' of git://git.kernel.org/.../kvms390/linux into kvm-next
      Merge tag 'kvm-s390-20140516' of git://git.kernel.org/.../kvms390/linux into kvm-next
      KVM: x86: use new CS.RPL as CPL during task switch
      KVM: x86: drop set_rflags callback
      KVM: x86: check CS.DPL against RPL during task switch
      KVM: x86: get CPL from SS.DPL
      KVM: lapic: sync highest ISR to hardware apic on EOI
      Merge tag 'kvm-arm-for-3.16' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-next
      Merge tag 'kvm-s390-20140530' of git://git.kernel.org/.../kvms390/linux into kvm-next
      Merge tag 'signed-kvm-ppc-next' of git://github.com/agraf/linux-2.6 into kvm-next
      KVM: add missing cleanup_srcu_struct

Paul Mackerras (7):
      KVM: PPC: Book3S: Add ONE_REG register names that were missed
      KVM: PPC: Book3S: Move KVM_REG_PPC_WORT to an unused register number
      KVM: PPC: Book3S HV: Fix check for running inside guest in global_invalidates()
      KVM: PPC: Book3S HV: Put huge-page HPTEs in rmap chain for base address
      KVM: PPC: Book3S HV: Make sure we don't miss dirty pages
      KVM: PPC: Book3S HV: Work around POWER8 performance monitor bugs
      KVM: PPC: Book3S HV: Fix machine check delivery to guest

Thomas Huth (12):
      KVM: s390: Handle MVPG partial execution interception
      KVM: s390: Add a function for checking the low-address protection
      KVM: s390: Fixes for PFMF
      KVM: s390: Add low-address protection to TEST BLOCK
      KVM: s390: Add clock comparator and CPU timer IRQ injection
      KVM: s390: Fix external interrupt interception
      KVM: s390: Improve is_valid_psw()
      KVM: s390: Avoid endless loops of specification exceptions
      KVM: s390: Introduce helper function for faulting-in a guest page
      KVM: s390: Improved MVPG partial execution handler
      KVM: s390: Add a generic function for translating guest addresses
      KVM: s390: Enable DAT support for TPROT handler

Ulrich Obergfell (1):
      KVM: x86: improve the usability of the 'kvm_pio' tracepoint

Xiao Guangrong (5):
      Revert "KVM: Simplify kvm->tlbs_dirty handling"
      KVM: MMU: properly check last spte in fast_page_fault()
      KVM: MMU: lazily drop large spte
      KVM: MMU: flush tlb if the spte can be locklessly modified
      KVM: MMU: flush tlb out of mmu lock when write-protect the sptes

 Documentation/devicetree/bindings/arm/psci.txt |  37 +-
 Documentation/virtual/kvm/api.txt              |  33 +-
 Documentation/virtual/kvm/devices/vm.txt       |  26 +
 Documentation/virtual/kvm/ppc-pv.txt           |  14 +
 Documentation/virtual/kvm/s390-diag.txt        |   2 +
 arch/arm/include/asm/kvm_host.h                |   2 +-
 arch/arm/include/asm/kvm_psci.h                |   6 +-
 arch/arm/include/asm/psci.h                    |   7 +-
 arch/arm/include/uapi/asm/kvm.h                |  10 +-
 arch/arm/kernel/psci.c                         | 196 +++++--
 arch/arm/kernel/psci_smp.c                     |  33 ++
 arch/arm/kvm/arm.c                             |   1 +
 arch/arm/kvm/handle_exit.c                     |  10 +-
 arch/arm/kvm/psci.c                            | 235 +++++++-
 arch/arm64/include/asm/cpu_ops.h               |   2 +
 arch/arm64/include/asm/cputype.h               |   1 +
 arch/arm64/include/asm/kvm_host.h              |   2 +-
 arch/arm64/include/asm/kvm_psci.h              |   6 +-
 arch/arm64/include/asm/psci.h                  |   2 +-
 arch/arm64/include/uapi/asm/kvm.h              |  13 +-
 arch/arm64/kernel/psci.c                       | 231 ++++++--
 arch/arm64/kernel/smp.c                        |  22 +
 arch/arm64/kvm/guest.c                         |   2 +
 arch/arm64/kvm/handle_exit.c                   |  10 +-
 arch/arm64/kvm/sys_regs_generic_v8.c           |   2 +
 arch/mips/Kconfig                              |  12 +-
 arch/mips/include/asm/kvm_host.h               | 183 +++++--
 arch/mips/include/uapi/asm/kvm.h               |  35 ++
 arch/mips/kvm/kvm_locore.S                     |  32 --
 arch/mips/kvm/kvm_mips.c                       | 145 ++---
 arch/mips/kvm/kvm_mips_dyntrans.c              |  15 +-
 arch/mips/kvm/kvm_mips_emul.c                  | 557 ++++++++++++++++++-
 arch/mips/kvm/kvm_tlb.c                        |  77 +--
 arch/mips/kvm/kvm_trap_emul.c                  |  86 ++-
 arch/mips/mm/cache.c                           |   1 +
 arch/mips/mti-malta/malta-time.c               |  14 +-
 arch/powerpc/include/asm/disassemble.h         |  34 ++
 arch/powerpc/include/asm/kvm_asm.h             |  18 +-
 arch/powerpc/include/asm/kvm_book3s.h          |   3 +-
 arch/powerpc/include/asm/kvm_book3s_64.h       | 146 ++++-
 arch/powerpc/include/asm/kvm_book3s_asm.h      |   2 +
 arch/powerpc/include/asm/kvm_booke.h           |   5 -
 arch/powerpc/include/asm/kvm_host.h            |   9 +-
 arch/powerpc/include/asm/kvm_ppc.h             |  80 ++-
 arch/powerpc/include/asm/reg.h                 |  12 +-
 arch/powerpc/include/asm/reg_booke.h           |   1 +
 arch/powerpc/include/uapi/asm/kvm.h            |   2 +-
 arch/powerpc/include/uapi/asm/kvm_para.h       |   6 +
 arch/powerpc/kernel/align.c                    |  34 +-
 arch/powerpc/kernel/asm-offsets.c              |  11 +-
 arch/powerpc/kernel/epapr_paravirt.c           |   5 +-
 arch/powerpc/kernel/kvm.c                      |   2 +-
 arch/powerpc/kernel/paca.c                     |   3 +
 arch/powerpc/kvm/Kconfig                       |   2 +-
 arch/powerpc/kvm/book3s.c                      | 106 ++--
 arch/powerpc/kvm/book3s_32_mmu.c               |  41 +-
 arch/powerpc/kvm/book3s_32_mmu_host.c          |   4 +-
 arch/powerpc/kvm/book3s_64_mmu.c               |  39 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c          |  15 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c            | 116 ++--
 arch/powerpc/kvm/book3s_64_slb.S               |  87 ++-
 arch/powerpc/kvm/book3s_emulate.c              | 156 ++++--
 arch/powerpc/kvm/book3s_exports.c              |   1 +
 arch/powerpc/kvm/book3s_hv.c                   |  48 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c            |   3 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S        |  60 +-
 arch/powerpc/kvm/book3s_interrupts.S           |  23 +-
 arch/powerpc/kvm/book3s_paired_singles.c       |  16 +-
 arch/powerpc/kvm/book3s_pr.c                   | 238 ++++++--
 arch/powerpc/kvm/book3s_pr_papr.c              |  16 +-
 arch/powerpc/kvm/book3s_rtas.c                 |  29 +
 arch/powerpc/kvm/book3s_segment.S              |  25 +
 arch/powerpc/kvm/e500_emulate.c                |  15 +
 arch/powerpc/kvm/emulate.c                     |  24 +-
 arch/powerpc/kvm/mpic.c                        |   5 +-
 arch/powerpc/kvm/powerpc.c                     |  64 ++-
 arch/powerpc/kvm/trace_pr.h                    |   2 +-
 arch/powerpc/mm/slb.c                          |   2 +-
 arch/s390/include/asm/ctl_reg.h                |  14 +
 arch/s390/include/asm/kvm_host.h               | 163 +++++-
 arch/s390/include/asm/lowcore.h                |  10 +-
 arch/s390/include/asm/mmu.h                    |   2 +
 arch/s390/include/asm/mmu_context.h            |   1 +
 arch/s390/include/asm/pgalloc.h                |   3 +-
 arch/s390/include/asm/pgtable.h                | 169 +++---
 arch/s390/include/asm/ptrace.h                 |  44 ++
 arch/s390/include/asm/sclp.h                   |   8 +-
 arch/s390/include/uapi/asm/kvm.h               |  28 +
 arch/s390/include/uapi/asm/sie.h               | 245 +++++++++
 arch/s390/kernel/asm-offsets.c                 |  14 +-
 arch/s390/kernel/entry.S                       |   4 +-
 arch/s390/kernel/entry64.S                     |   4 +-
 arch/s390/kvm/Makefile                         |   4 +-
 arch/s390/kvm/diag.c                           |  19 +-
 arch/s390/kvm/gaccess.c                        | 726 +++++++++++++++++++++++++
 arch/s390/kvm/gaccess.h                        | 379 ++++++++++---
 arch/s390/kvm/guestdbg.c                       | 482 ++++++++++++++++
 arch/s390/kvm/intercept.c                      | 222 +++++++-
 arch/s390/kvm/interrupt.c                      | 400 ++++++++++----
 arch/s390/kvm/kvm-s390.c                       | 554 +++++++++++++++----
 arch/s390/kvm/kvm-s390.h                       |  73 ++-
 arch/s390/kvm/priv.c                           | 357 ++++++++----
 arch/s390/kvm/sigp.c                           | 103 ++--
 arch/s390/kvm/trace-s390.h                     |  43 ++
 arch/s390/kvm/trace.h                          |  99 ++--
 arch/s390/mm/pgtable.c                         |  89 ++-
 arch/x86/include/asm/kvm_emulate.h             |   1 -
 arch/x86/include/asm/kvm_host.h                |   7 +-
 arch/x86/include/asm/traps.h                   |   5 +
 arch/x86/kernel/kvm.c                          |   2 +-
 arch/x86/kvm/cpuid.c                           |  11 +-
 arch/x86/kvm/cpuid.h                           |   7 +
 arch/x86/kvm/emulate.c                         |  93 ++--
 arch/x86/kvm/irq.c                             |   1 +
 arch/x86/kvm/lapic.c                           |  62 ++-
 arch/x86/kvm/mmu.c                             |  84 ++-
 arch/x86/kvm/mmu.h                             |  33 ++
 arch/x86/kvm/paging_tmpl.h                     |   7 +-
 arch/x86/kvm/pmu.c                             |   7 +-
 arch/x86/kvm/svm.c                             |  63 ++-
 arch/x86/kvm/trace.h                           |  20 +-
 arch/x86/kvm/vmx.c                             | 333 +++++++-----
 arch/x86/kvm/x86.c                             |  61 +--
 drivers/s390/char/sclp_early.c                 |  34 +-
 include/linux/kvm_host.h                       |  15 +-
 include/uapi/linux/Kbuild                      |   1 +
 include/uapi/linux/kvm.h                       |  17 +-
 include/uapi/linux/psci.h                      |  90 +++
 virt/kvm/async_pf.c                            |   4 +-
 virt/kvm/eventfd.c                             |  68 ++-
 virt/kvm/irq_comm.c                            |  17 +-
 virt/kvm/irqchip.c                             |  31 +-
 virt/kvm/kvm_main.c                            |  25 +-
 133 files changed, 7181 insertions(+), 1749 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/vm.txt
 create mode 100644 arch/s390/include/uapi/asm/sie.h
 create mode 100644 arch/s390/kvm/gaccess.c
 create mode 100644 arch/s390/kvm/guestdbg.c
 create mode 100644 include/uapi/linux/psci.h
