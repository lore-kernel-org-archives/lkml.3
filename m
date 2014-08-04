Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaHDJnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:43:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbaHDJnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:43:19 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First round of KVM changes for 3.17
Date: Mon,  4 Aug 2014 11:43:10 +0200
Message-Id: <1407145390-28054-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 33b458d276bbdbe28febac0742835002b9f4778d:

  KVM: SVM: Fix CPL export via SS.DPL (2014-06-30 16:45:28 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 42cbc04fd3b5e3f9b011bf9fa3ce0b3d1e10b58b:

  x86/kvm: Resolve shadow warnings in macro expansion (2014-07-31 16:33:29 +0200)

----------------------------------------------------------------
These are the x86, MIPS and s390 changes; PPC and ARM will come in a
few days.

MIPS and s390 have little going on this release; just bugfixes, some
small, some larger.

The highlights for x86 are nested VMX improvements (Jan Kiszka), optimizations
for old processor (up to Nehalem, by me and Bandan Das), and a lot of x86
emulator bugfixes (Nadav Amit).

Stephen Rothwell reported a trivial conflict with the tracing branch.

----------------------------------------------------------------
Bandan Das (6):
      KVM: emulate: move init_decode_cache to emulate.c
      KVM: emulate: Remove ctxt->intercept and ctxt->check_perm checks
      KVM: emulate: cleanup decode_modrm
      KVM: emulate: clean up initializations in init_decode_cache
      KVM: emulate: rework seg_override
      KVM: emulate: do not initialize memopp

Chris J Arges (1):
      KVM: vmx: remove duplicate vmx_mpx_supported() prototype

Christian Borntraeger (2):
      KVM: s390: add ipte to trace event decoding
      KVM: s390: Fix memory leak on busy SIGP stop

Cornelia Huck (3):
      KVM: document target of capability enablement
      KVM: s390: document KVM_CAP_S390_IRQCHIP
      KVM: s390: advertise KVM_CAP_S390_IRQCHIP

David Hildenbrand (11):
      KVM: s390: allow only one SIGP STOP (AND STORE STATUS) at a time
      KVM: s390: move finalization of SIGP STOP orders to kvm_s390_vcpu_stop
      KVM: s390: remove __cpu_is_stopped and expose is_vcpu_stopped
      KVM: prepare for KVM_(S|G)ET_MP_STATE on other architectures
      KVM: s390: implement KVM_(S|G)ET_MP_STATE for user space state control
      KVM: s390: cleanup handle_wait by reusing kvm_vcpu_block
      KVM: s390: remove _bh locking from local_int.lock
      KVM: s390: remove _bh locking from start_stop_lock
      KVM: s390: move vcpu wakeup code to a central point
      KVM: s390: remove the tasklet used by the hrtimer
      KVM: s390: rework broken SIGP STOP interrupt handling

Deng-Cheng Zhu (7):
      MIPS: KVM: Reformat code and comments
      MIPS: KVM: Use KVM internal logger
      MIPS: KVM: Simplify functions by removing redundancy
      MIPS: KVM: Remove unneeded volatile
      MIPS: KVM: Rename files to remove the prefix "kvm_" and "kvm_mips_"
      MIPS: KVM: Skip memory cleaning in kvm_mips_commpage_init()
      MIPS: KVM: Remove dead code of TLB index error in kvm_mips_emul_tlbwr()

Fabian Frederick (1):
      arch/x86/kvm/vmx.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE

James Hogan (3):
      KVM: Document KVM_SET_SIGNAL_MASK as universal
      KVM: Reformat KVM_SET_ONE_REG register documentation
      KVM: MIPS: Document MIPS specifics of KVM API.

Jan Kiszka (10):
      KVM: x86: Fix constant value of VM_{EXIT_SAVE,ENTRY_LOAD}_DEBUG_CONTROLS
      KVM: nVMX: Advertise support for MSR_IA32_VMX_TRUE_*_CTLS
      KVM: nVMX: Allow to disable CR3 access interception
      KVM: nVMX: Fix returned value of MSR_IA32_VMX_PROCBASED_CTLS
      KVM: nVMX: Allow to disable VM_{ENTRY_LOAD,EXIT_SAVE}_DEBUG_CONTROLS
      KVM: nVMX: Fix returned value of MSR_IA32_VMX_VMCS_ENUM
      KVM: nSVM: Do not report CLTS via SVM_EXIT_WRITE_CR0 to L1
      KVM: nSVM: Fix IOIO bitmap evaluation
      KVM: nSVM: Fix IOIO size reported on emulation
      KVM: nSVM: Set correct port for IOIO interception evaluation

Jim Mattson (1):
      KVM: Synthesize G bit for all segments.

Mark D Rustad (1):
      x86/kvm: Resolve shadow warnings in macro expansion

Mark Rustad (2):
      kvm: Resolve missing-field-initializers warnings
      x86/kvm: Resolve shadow warning from min macro

Matthias Lange (1):
      KVM: svm: writes to MSR_K7_HWCR generates GPE in guest

Nadav Amit (32):
      KVM: x86: Mark VEX-prefix instructions emulation as unimplemented
      KVM: x86: Emulator ignores LDTR/TR extended base on LLDT/LTR
      KVM: x86: Loading segments on 64-bit mode may be wrong
      KVM: x86: sgdt and sidt are not privilaged
      KVM: x86: cmpxchg emulation should compare in reverse order
      KVM: x86: movnti minimum op size of 32-bit is not kept
      KVM: x86: rdpmc emulation checks the counter incorrectly
      KVM: x86: Return error on cmpxchg16b emulation
      KVM: x86: smsw emulation is incorrect in 64-bit mode
      KVM: x86: bit-ops emulation ignores offset on 64-bit
      KVM: x86: Wrong emulation on 'xadd X, X'
      KVM: x86: Inter-privilege level ret emulation is not implemeneted
      KVM: x86: emulation of dword cmov on long-mode should clear [63:32]
      KVM: x86: NOP emulation clears (incorrectly) the high 32-bits of RAX
      KVM: x86: check DR6/7 high-bits are clear only on long-mode
      KVM: x86: Hypercall handling does not considers opsize correctly
      KVM: vmx: handle_cr ignores 32/64-bit mode
      KVM: vmx: vmx instructions handling does not consider cs.l
      KVM: x86: Fix lapic.c debug prints
      KVM: x86: Pending interrupt may be delivered after INIT
      KVM: x86: Emulator flag for instruction that only support 16-bit addresses in real mode
      KVM: x86: Emulator support for #UD on CPL>0
      KVM: x86: Clearing rflags.rf upon skipped emulated instruction
      KVM: x86: popf emulation should not change RF
      KVM: x86: Clear rflags.rf on emulated instructions
      KVM: x86: Cleanup of rflags.rf cleaning
      KVM: x86: emulator injects #DB when RFLAGS.RF is set
      KVM: x86: Defining missing x86 vectors
      KVM: x86: DR6/7.RTM cannot be written
      KVM: x86: Setting rflags.rf during rep-string emulation
      KVM: x86: set rflags.rf during fault injection
      KVM: x86: Assertions to check no overrun in MSR lists

Paolo Bonzini (25):
      KVM: emulate: POP SS triggers a MOV SS shadow too
      KVM: emulate: simplify BitOp handling
      KVM: emulate: fix harmless typo in MMX decoding
      Merge commit '33b458d276bb' into kvm-next
      Merge tag 'kvms390-20140626' of git://git.kernel.org/.../kvms390/linux into HEAD
      KVM: vmx: speed up emulation of invalid guest state
      KVM: x86: return all bits from get_interrupt_shadow
      KVM: x86: avoid useless set of KVM_REQ_EVENT after emulation
      KVM: emulate: move around some checks
      KVM: emulate: protect checks on ctxt->d by a common "if (unlikely())"
      KVM: emulate: speed up emulated moves
      KVM: emulate: simplify writeback
      KVM: emulate: speed up do_insn_fetch
      KVM: emulate: avoid repeated calls to do_insn_fetch_bytes
      KVM: emulate: avoid per-byte copying in instruction fetches
      KVM: emulate: put pointers in the fetch_cache
      KVM: x86: ensure emulator fetches do not span multiple pages
      KVM: x86: use kvm_read_guest_page for emulator accesses
      Merge tag 'kvm-s390-20140715' of git://git.kernel.org/.../kvms390/linux into kvm-next
      KVM: nVMX: fix lifetime issues for vmcs02
      KVM: nVMX: clean up nested_release_vmcs12 and code around it
      Merge tag 'kvm-s390-20140721' of git://git.kernel.org/.../kvms390/linux into kvm-next
      Replace NR_VMX_MSR with its definition
      KVM: x86: always exit on EOIs for interrupts listed in the IOAPIC redir table
      Merge tag 'kvm-s390-20140730' of git://git.kernel.org/.../kvms390/linux into kvm-next

Rickard Strandqvist (1):
      arch: x86: kvm: x86.c: Cleaning up variable is set more than once

Tomasz Grabiec (1):
      KVM: x86: fix TSC matching

Wanpeng Li (1):
      KVM: nVMX: Fix virtual interrupt delivery injection


 Documentation/virtual/kvm/api.txt                 | 345 +++++++++-----
 arch/mips/include/asm/kvm_host.h                  |  12 +-
 arch/mips/include/asm/r4kcache.h                  |   3 +
 arch/mips/kvm/Makefile                            |   8 +-
 arch/mips/kvm/{kvm_cb.c => callback.c}            |   0
 arch/mips/kvm/commpage.c                          |  33 ++
 arch/mips/kvm/commpage.h                          |  24 +
 arch/mips/kvm/{kvm_mips_dyntrans.c => dyntrans.c} |  40 +-
 arch/mips/kvm/{kvm_mips_emul.c => emulate.c}      | 539 +++++++++++-----------
 arch/mips/kvm/{kvm_mips_int.c => interrupt.c}     |  47 +-
 arch/mips/kvm/{kvm_mips_int.h => interrupt.h}     |  22 +-
 arch/mips/kvm/kvm_mips_comm.h                     |  23 -
 arch/mips/kvm/kvm_mips_commpage.c                 |  37 --
 arch/mips/kvm/kvm_mips_opcode.h                   |  24 -
 arch/mips/kvm/{kvm_locore.S => locore.S}          |  55 ++-
 arch/mips/kvm/{kvm_mips.c => mips.c}              | 224 +++++----
 arch/mips/kvm/opcode.h                            |  22 +
 arch/mips/kvm/{kvm_mips_stats.c => stats.c}       |  28 +-
 arch/mips/kvm/{kvm_tlb.c => tlb.c}                | 258 +++++------
 arch/mips/kvm/trace.h                             |  18 +-
 arch/mips/kvm/{kvm_trap_emul.c => trap_emul.c}    | 112 +++--
 arch/s390/include/asm/kvm_host.h                  |   3 +-
 arch/s390/include/uapi/asm/sie.h                  |   1 +
 arch/s390/kvm/diag.c                              |   3 +-
 arch/s390/kvm/intercept.c                         |  32 +-
 arch/s390/kvm/interrupt.c                         | 103 ++---
 arch/s390/kvm/kvm-s390.c                          |  66 ++-
 arch/s390/kvm/kvm-s390.h                          |  12 +-
 arch/s390/kvm/sigp.c                              |  44 +-
 arch/x86/include/asm/kvm_emulate.h                |  33 +-
 arch/x86/include/asm/kvm_host.h                   |  15 +-
 arch/x86/include/asm/vmx.h                        |   7 +-
 arch/x86/include/uapi/asm/kvm.h                   |   3 +
 arch/x86/include/uapi/asm/msr-index.h             |   1 +
 arch/x86/kvm/cpuid.h                              |   8 +
 arch/x86/kvm/emulate.c                            | 494 +++++++++++---------
 arch/x86/kvm/lapic.c                              |   4 +-
 arch/x86/kvm/mmutrace.h                           |   4 +-
 arch/x86/kvm/pmu.c                                |   9 +
 arch/x86/kvm/svm.c                                |  57 ++-
 arch/x86/kvm/trace.h                              |   6 +-
 arch/x86/kvm/vmx.c                                | 239 ++++++----
 arch/x86/kvm/x86.c                                | 171 +++++--
 arch/x86/kvm/x86.h                                |  27 ++
 include/uapi/linux/kvm.h                          |   7 +-
 virt/kvm/ioapic.c                                 |   7 +-
 virt/kvm/irq_comm.c                               |   4 +-
 47 files changed, 1790 insertions(+), 1444 deletions(-)
