Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3BUBSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:18:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab3BUBSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:18:35 -0500
Date: Wed, 20 Feb 2013 22:17:02 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi.kivity@gmail.com>
Subject: [GIT PULL] KVM updates for the 3.9 merge window
Message-ID: <20130221011702.GA791@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.9-1

to receive the KVM updates for the 3.9 merge window, including x86 real
mode emulation fixes, stronger memory slot interface restrictions, 
mmu_lock spinlock hold time reduction, improved handling of large 
page faults on shadow, initial APICv HW acceleration support, 
s390 channel IO based virtio, amongst others.

--

Alex Williamson (13):
      KVM: Restrict non-existing slot state transitions
      KVM: Check userspace_addr when modifying a memory slot
      KVM: Fix iommu map/unmap to handle memory slot moves
      KVM: Minor memory slot optimization
      KVM: Rename KVM_MEMORY_SLOTS -> KVM_USER_MEM_SLOTS
      KVM: Make KVM_PRIVATE_MEM_SLOTS optional
      KVM: struct kvm_memory_slot.user_alloc -> bool
      KVM: struct kvm_memory_slot.flags -> u32
      KVM: struct kvm_memory_slot.id -> short
      KVM: Increase user memory slots on x86 to 125
      kvm: Fix memory slot generation updates
      kvm: Force IOMMU remapping on memory slot read-only flag changes
      kvm: Obey read-only mappings in iommu

Alexander Graf (17):
      KVM: PPC: Only WARN on invalid emulation
      KVM: PPC: Book3S: PR: Enable alternative instruction for SC 1
      KVM: PPC: BookE: Allow irq deliveries to inject requests
      KVM: PPC: BookE: Emulate mfspr on EPR
      KVM: PPC: BookE: Implement EPR exit
      KVM: PPC: BookE: Add EPR ONE_REG sync
      KVM: PPC: E500: Move write_stlbe higher
      KVM: PPC: E500: Explicitly mark shadow maps invalid
      KVM: PPC: E500: Propagate errors when shadow mapping
      KVM: PPC: e500: Call kvmppc_mmu_map for initial mapping
      KVM: PPC: E500: Split host and guest MMU parts
      KVM: PPC: e500: Implement TLB1-in-TLB0 mapping
      KVM: PPC: E500: Make clear_tlb_refs and clear_tlb1_bitmap static
      KVM: PPC: E500: Remove kvmppc_e500_tlbil_all usage from guest TLB code
      Merge commit 'origin/next' into kvm-ppc-next
      KVM: PPC: BookE: Handle alignment interrupts
      Merge commit 'origin/next' into kvm-ppc-next

Avi Kivity (16):
      KVM: x86 emulator: framework for streamlining arithmetic opcodes
      KVM: x86 emulator: Support for declaring single operand fastops
      KVM: x86 emulator: introduce NoWrite flag
      KVM: x86 emulator: mark CMP, CMPS, SCAS, TEST as NoWrite
      KVM: x86 emulator: convert NOT, NEG to fastop
      KVM: x86 emulator: add macros for defining 2-operand fastop emulation
      KVM: x86 emulator: convert basic ALU ops to fastop
      KVM: x86 emulator: Convert SHLD, SHRD to fastop
      KVM: x86 emulator: convert shift/rotate instructions to fastop
      KVM: x86 emulator: covert SETCC to fastop
      KVM: x86 emulator: convert INC/DEC to fastop
      KVM: x86 emulator: convert BT/BTS/BTR/BTC/BSF/BSR to fastop
      KVM: x86 emulator: convert 2-operand IMUL to fastop
      KVM: x86 emulator: rearrange fastop definitions
      KVM: x86 emulator: convert a few freestanding emulations to fastop
      KVM: x86 emulator: fix test_cc() build failure on i386

Bharat Bhushan (3):
      KVM: PPC: booke: use vcpu reference from thread_struct
      KVM: PPC: booke: Allow multiple exception types
      booke: Added DBCR4 SPR number

Christian Borntraeger (3):
      KVM: s390: Gracefully handle busy conditions on ccw_device_start
      s390/kvm: Fix store status for ACRS/FPRS
      s390/kvm: Fix instruction decoding

Cong Ding (1):
      KVM: s390: kvm/sigp.c: fix memory leakage

Cornelia Huck (14):
      KVM: s390: Handle hosts not supporting s390-virtio.
      s390/ccwdev: Include asm/schid.h.
      KVM: s390: Add a channel I/O based virtio transport driver.
      KVM: s390: Constify intercept handler tables.
      KVM: s390: Decoding helper functions.
      KVM: s390: Support for I/O interrupts.
      KVM: s390: Add support for machine checks.
      KVM: s390: In-kernel handling of I/O instructions.
      KVM: s390: Base infrastructure for enabling capabilities.
      KVM: s390: Add support for channel I/O instructions.
      KVM: s390: Dynamic allocation of virtio-ccw I/O data.
      KVM: trace: Fix exit decoding.
      s390/virtio-ccw: Fix setup_vq error handling.
      KVM: s390: Fix handling of iscs.

Dongxiao Xu (1):
      KVM: VMX: disable SMEP feature when guest is in non-paging mode

Geoff Levand (1):
      KVM: Remove duplicate text in api.txt

Gleb Natapov (39):
      KVM: emulator: implement AAD instruction
      KVM: inject ExtINT interrupt before APIC interrupts
      KVM: remove unused variable.
      KVM: VMX: cleanup rmode_segment_valid()
      KVM: VMX: relax check for CS register in rmode_segment_valid()
      KVM: VMX: return correct segment limit and flags for CS/SS registers in real mode
      KVM: VMX: use fix_rmode_seg() to fix all code/data segments
      KVM: VMX: remove redundant code from vmx_set_segment()
      KVM: VMX: clean-up vmx_set_segment()
      KVM: VMX: remove unneeded temporary variable from vmx_set_segment()
      KVM: move the code that installs new slots array to a separate function.
      KVM: emulator: drop RPL check from linearize() function
      KVM: emulator: implement fninit, fnstsw, fnstcw
      KVM: VMX: make rmode_segment_valid() more strict.
      KVM: VMX: fix emulation of invalid guest state.
      KVM: VMX: Do not fix segment register during vcpu initialization.
      KVM: VMX: handle IO when emulation is due to #GP in real mode.
      KVM: mmu: remove unused trace event
      KVM: MMU: simplify folding of dirty bit into accessed_dirty
      KVM: x86: remove unused variable from walk_addr_generic()
      Merge branch 'kvm-ppc-next' of https://github.com/agraf/linux-2.6 into queue
      KVM: VMX: remove special CPL cache access during transition to real mode.
      KVM: VMX: reset CPL only on CS register write.
      KVM: VMX: if unrestricted guest is enabled vcpu state is always valid.
      KVM: VMX: remove hack that disables emulation on vcpu reset/init
      KVM: VMX: skip vmx->rmode.vm86_active check on cr0 write if unrestricted guest is enabled
      KVM: VMX: don't clobber segment AR of unusable segments.
      KVM: VMX: rename fix_pmode_dataseg to fix_pmode_seg.
      KVM: x86: fix use of uninitialized memory as segment descriptor in emulator.
      KVM: VMX: set vmx->emulation_required only when needed.
      KVM: MMU: make spte_is_locklessly_modifiable() more clear
      KVM: MMU: drop unneeded checks.
      KVM: MMU: set base_role.nxe during mmu initialization.
      KVM: MMU: drop superfluous min() call.
      KVM: MMU: drop superfluous is_present_gpte() check.
      Revert "KVM: MMU: split kvm_mmu_free_page"
      KVM: VMX: add missing exit names to VMX_EXIT_REASONS array
      KVM: VMX: cleanup vmx_set_cr0().
      x86 emulator: fix parity calculation for AAD instruction

Jan Kiszka (1):
      KVM: nVMX: Remove redundant get_vmcs12 from nested_vmx_exit_handled_msr

Jesse Larrew (1):
      x86: kvm_para: fix typo in hypercall comments

Marcelo Tosatti (3):
      KVM: VMX: fix incorrect cached cpl value with real/v8086 modes
      x86: pvclock kvm: align allocation size to page size
      Revert "KVM: MMU: lazily drop large spte"

Mihai Caraman (2):
      KVM: PPC: Fix SREGS documentation reference
      KVM: PPC: Fix mfspr/mtspr MMUCFG emulation

Nadav Amit (1):
      KVM: x86: fix mov immediate emulation for 64-bit operands

Nickolai Zeldovich (1):
      kvm: fix i8254 counter 0 wraparound

Peter Zijlstra (1):
      sched: Bail out of yield_to when source and target runqueue has one task

Raghavendra K T (1):
      kvm: Handle yield_to failure return code for potential undercommit case

Takuya Yoshikawa (13):
      KVM: Write protect the updated slot only when dirty logging is enabled
      KVM: MMU: Remove unused parameter level from __rmap_write_protect()
      KVM: MMU: Make kvm_mmu_slot_remove_write_access() rmap based
      KVM: Remove unused slot_bitmap from kvm_mmu_page
      KVM: Make kvm_mmu_change_mmu_pages() take mmu_lock by itself
      KVM: Make kvm_mmu_slot_remove_write_access() take mmu_lock by itself
      KVM: MMU: Conditionally reschedule when kvm_mmu_slot_remove_write_access() takes a long time
      KVM: set_memory_region: Don't jump to out_free unnecessarily
      KVM: set_memory_region: Don't check for overlaps unless we create or move a slot
      KVM: set_memory_region: Remove unnecessary variable memslot
      KVM: set_memory_region: Identify the requested change explicitly
      KVM: set_memory_region: Disallow changing read-only attribute later
      KVM: Remove user_alloc from struct kvm_memory_slot

Xiao Guangrong (9):
      KVM: MMU: fix Dirty bit missed if CR0.WP = 0
      KVM: MMU: fix infinite fault access retry
      KVM: x86: clean up reexecute_instruction
      KVM: x86: let reexecute_instruction work for tdp
      KVM: x86: improve reexecute_instruction
      KVM: MMU: lazily drop large spte
      KVM: MMU: cleanup mapping-level
      KVM: MMU: remove pt_access in mmu_set_spte
      KVM: MMU: cleanup __direct_map

Yang Zhang (5):
      KVM: remove a wrong hack of delivery PIT intr to vcpu0
      x86, apicv: add APICv register virtualization support
      x86, apicv: add virtual x2apic support
      x86, apicv: add virtual interrupt delivery support
      KVM: VMX: disable apicv by default

 Documentation/virtual/kvm/api.txt    |  108 +-
 Documentation/virtual/kvm/mmu.txt    |    7 
 arch/ia64/include/asm/kvm_host.h     |    4 
 arch/ia64/kvm/kvm-ia64.c             |    8 
 arch/ia64/kvm/lapic.h                |    6 
 arch/powerpc/include/asm/kvm_host.h  |   10 
 arch/powerpc/include/asm/kvm_ppc.h   |   12 
 arch/powerpc/include/asm/reg.h       |    2 
 arch/powerpc/include/asm/reg_booke.h |    1 
 arch/powerpc/include/uapi/asm/kvm.h  |    6 
 arch/powerpc/kernel/asm-offsets.c    |    2 
 arch/powerpc/kvm/Makefile            |    9 
 arch/powerpc/kvm/book3s_emulate.c    |   30 
 arch/powerpc/kvm/book3s_hv.c         |    2 
 arch/powerpc/kvm/book3s_pr.c         |    5 
 arch/powerpc/kvm/booke.c             |   70 +
 arch/powerpc/kvm/booke.h             |    1 
 arch/powerpc/kvm/booke_emulate.c     |    3 
 arch/powerpc/kvm/booke_interrupts.S  |   49 -
 arch/powerpc/kvm/e500.c              |   16 
 arch/powerpc/kvm/e500.h              |    1 
 arch/powerpc/kvm/e500_mmu.c          |  825 ++++++++++++++++++
 arch/powerpc/kvm/e500_mmu_host.c     |  741 +++++++++++++++-
 arch/powerpc/kvm/e500_mmu_host.h     |   22 
 arch/powerpc/kvm/e500_tlb.c          | 1578 +----------------------------------
 arch/powerpc/kvm/emulate.c           |    5 
 arch/powerpc/kvm/powerpc.c           |   17 
 arch/s390/include/asm/ccwdev.h       |    4 
 arch/s390/include/asm/irq.h          |    1 
 arch/s390/include/asm/kvm_host.h     |   15 
 arch/s390/kernel/irq.c               |    1 
 arch/s390/kvm/intercept.c            |   45 
 arch/s390/kvm/interrupt.c            |  270 +++++
 arch/s390/kvm/kvm-s390.c             |   50 +
 arch/s390/kvm/kvm-s390.h             |   68 +
 arch/s390/kvm/priv.c                 |  328 ++++++-
 arch/s390/kvm/sigp.c                 |   10 
 arch/s390/kvm/trace-s390.h           |   26 
 arch/x86/include/asm/kvm_host.h      |   28 
 arch/x86/include/asm/kvm_para.h      |    2 
 arch/x86/include/asm/vmx.h           |   27 
 arch/x86/kernel/kvmclock.c           |   11 
 arch/x86/kvm/emulate.c               |  769 +++++++++--------
 arch/x86/kvm/i8254.c                 |    1 
 arch/x86/kvm/i8259.c                 |    2 
 arch/x86/kvm/irq.c                   |   86 +
 arch/x86/kvm/lapic.c                 |  140 ++-
 arch/x86/kvm/lapic.h                 |   34 
 arch/x86/kvm/mmu.c                   |  226 ++---
 arch/x86/kvm/mmutrace.h              |    6 
 arch/x86/kvm/paging_tmpl.h           |  122 +-
 arch/x86/kvm/svm.c                   |   24 
 arch/x86/kvm/vmx.c                   |  772 +++++++++++------
 arch/x86/kvm/x86.c                   |  194 ++--
 drivers/s390/kvm/Makefile            |    2 
 drivers/s390/kvm/kvm_virtio.c        |   38 
 drivers/s390/kvm/virtio_ccw.c        | 1166 +++++++++++++++++++++++--
 include/linux/kvm_host.h             |   32 
 include/trace/events/kvm.h           |    4 
 include/uapi/linux/kvm.h             |   27 
 kernel/sched/core.c                  |   25 
 virt/kvm/ioapic.c                    |   48 -
 virt/kvm/ioapic.h                    |    4 
 virt/kvm/iommu.c                     |    4 
 virt/kvm/irq_comm.c                  |   25 
 virt/kvm/kvm_main.c                  |  301 ++++--
 66 files changed, 5582 insertions(+), 2896 deletions(-)
