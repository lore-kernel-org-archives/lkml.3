Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaLRJSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:18:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaLRJRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:17:25 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        torvalds@linux-foundation.org
Cc: gleb@kernel.org, Alexander Graf <agraf@suse.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL] KVM changes for 3.19
Date: Thu, 18 Dec 2014 10:17:07 +0100
Message-Id: <1418894228-8189-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 2c4aa55a6af070262cca425745e8e54310e96b8d:

  Merge tag 'signed-kvm-ppc-next' of git://github.com/agraf/linux-2.6 into HEAD (2014-12-18 09:39:55 +0100)

IA64 removal will cause a trivial merge conflict.

----------------------------------------------------------------

3.19 changes for KVM:
- spring cleaning: removed support for IA64, and for hardware-assisted
virtualization on the PPC970
- ARM, PPC, s390 all had only small fixes

For x86:
- small performance improvements (though only on weird guests)
- usual round of hardware-compliancy fixes from Nadav
- APICv fixes
- XSAVES support for hosts and guests.  XSAVES hosts were broken because
the (non-KVM) XSAVES patches inadvertently changed the KVM userspace
ABI whenever XSAVES was enabled; hence, this part is going to stable.
Guest support is just a matter of exposing the feature and CPUID leaves
support.

Right now KVM is broken for PPC BookE in your tree (doesn't compile).
I'll reply to the pull request with a patch, please apply it either
before the pull request or in the merge commit, in order to preserve
bisectability somewhat.

----------------------------------------------------------------
Alexander Graf (1):
      KVM: PPC: BookE: Improve irq inject tracepoint

Andre Przywara (1):
      arm/arm64: KVM: avoid unnecessary guest register mangling on MMIO read

Andy Lutomirski (4):
      x86,kvm,vmx: Don't trap writes to CR4.TSD
      x86, kvm, vmx: Always use LOAD_IA32_EFER if available
      x86, kvm, vmx: Don't set LOAD_IA32_EFER when host and guest match
      x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit

Aneesh Kumar K.V (1):
      KVM: PPC: Book3S HV: Add missing HPTE unlock

Anton Blanchard (1):
      KVM: PPC: Book3S: Enable in-kernel XICS emulation by default

Ard Biesheuvel (4):
      arm/arm64: kvm: drop inappropriate use of kvm_is_mmio_pfn()
      kvm: fix kvm_is_mmio_pfn() and rename to kvm_is_reserved_pfn()
      kvm: add a memslot flag for incoherent memory regions
      arm, arm64: KVM: handle potential incoherency of readonly memslots

Bandan Das (1):
      KVM: nVMX: Disable unrestricted mode if ept=0

Chao Peng (1):
      KVM: x86: Enable Intel AVX-512 for guest

Chris J Arges (1):
      kvm: svm: move WARN_ON in svm_adjust_tsc_offset

Christian Borntraeger (4):
      KVM: s390: Fix ipte locking
      KVM: s390: flush CPU on load control
      KVM: s390: trigger the right CPU exit for floating interrupts
      KVM: track pid for VCPU only on KVM_RUN ioctl

Christoffer Dall (12):
      arm/arm64: vgic: Remove unreachable irq_clear_pending
      arm/arm64: KVM: Don't clear the VCPU_POWER_OFF flag
      arm/arm64: KVM: Correct KVM_ARM_VCPU_INIT power off option
      arm/arm64: KVM: Reset the HCR on each vcpu when resetting the vcpu
      arm/arm64: KVM: Clarify KVM_ARM_VCPU_INIT ABI
      arm/arm64: KVM: Turn off vcpus on PSCI shutdown/reboot
      arm/arm64: KVM: Introduce stage2_unmap_vm
      arm/arm64: KVM: Rename vgic_initialized to vgic_ready
      arm/arm64: KVM: Add (new) vgic_initialized macro
      arm/arm64: KVM: Don't allow creating VCPUs after vgic_initialized
      arm/arm64: KVM: Initialize the vgic on-demand when injecting IRQs
      arm/arm64: KVM: Require in-kernel vgic for the arch timers

Cédric Le Goater (1):
      KVM: PPC: Book3S HV: ptes are big endian

David Hildenbrand (9):
      KVM: s390: sigp: dispatch orders with one target in a separate function
      KVM: s390: sigp: move target cpu checks into dispatcher
      KVM: s390: sigp: separate preparation handlers
      KVM: s390: sigp: instruction counters for all sigp orders
      KVM: s390: sigp: inject emergency calls in a separate function
      KVM: s390: sigp: split handling of SIGP STOP (AND STORE STATUS)
      KVM: s390: external param not valid for cpu timer and ckc
      KVM: don't check for PF_VCPU when yielding
      KVM: s390: some ext irqs have to clear the ext cpu addr

David Matlack (1):
      kvm: x86: add trace event for pvclock updates

Dominik Dingel (2):
      KVM: trivial fix comment regarding __kvm_set_memory_region
      KVM: fix vm device attribute documentation

Heiko Carstens (1):
      KVM: s390: fix handling of lctl[g]/stctl[g]

Igor Mammedov (7):
      kvm: x86: increase user memory slots to 509
      kvm: memslots: replace heap sort with an insertion sort pass
      kvm: update_memslots: drop not needed check for the same number of pages
      kvm: update_memslots: drop not needed check for the same slot
      kvm: search_memslots: add simple LRU memslot caching
      kvm: change memslot sorting rule from size to GFN
      kvm: optimize GFN to memslot lookup with large slots amount

Jan Kiszka (1):
      KVM: nVMX: Disable preemption while reading from shadow VMCS

Jason J. Herne (2):
      KVM: s390: Cleanup usage of current->mm in set_guest_storage_key
      KVM: S390: Create helper function get_guest_storage_key

Jens Freimann (8):
      KVM: s390: refactor interrupt injection code
      KVM: s390: add defines for virtio and pfault interrupt code
      KVM: s390: refactor interrupt delivery code
      KVM: s390: add bitmap for handling cpu-local interrupts
      KVM: s390: handle pending local interrupts via bitmap
      KVM: s390: allow injecting all kinds of machine checks
      KVM: s390: use atomic bitops to access pending_irqs bitmap
      KVM: s390: clean up return code handling in irq delivery code

Laszlo Ersek (1):
      arm, arm64: KVM: allow forced dcache flush on page faults

Mahesh Salgaonkar (1):
      KVM: PPC: Book3S HV: Fix an issue where guest is paused on receiving HMI

Marcelo Tosatti (1):
      KVM: x86: update masterclock values on TSC writes

Michael S. Tsirkin (1):
      kvm: drop unsupported capabilities, fix documentation

Nadav Amit (43):
      KVM: x86: Fix far-jump to non-canonical check
      KVM: x86: Use new is_noncanonical_address in _linearize
      KVM: x86: Getting rid of grp45 in emulator
      KVM: x86: Distinguish between stack operation and near branches
      KVM: x86: Sysexit emulation does not mask RIP/RSP
      KVM: x86: some apic broadcast modes does not work
      KVM: x86: DR7.GD should be cleared upon any #DB exception
      KVM: x86: Emulator does not calculate address correctly
      KVM: x86: Clear DR7.LE during task-switch
      KVM: x86: Emulator performs code segment checks on read access
      KVM: vmx: Unavailable DR4/5 is checked before CPL
      KVM: x86: decode_modrm does not regard modrm correctly
      KVM: x86: No error-code on real-mode exceptions
      KVM: x86: Emulator should set DR6 upon GD like real CPU
      KVM: x86: Clear DR6[0:3] on #DB during handle_dr
      KVM: x86: Breakpoints do not consider CS.base
      KVM: x86: Emulation of MOV-sreg to memory uses incorrect size
      KVM: x86: SYSCALL cannot clear eflags[1]
      KVM: x86: Wrong flags on CMPS and SCAS emulation
      KVM: x86: Emulate push sreg as done in Core
      KVM: x86: MOV to CR3 can set bit 63
      KVM: x86: Do not update EFLAGS on faulting emulation
      KVM: x86: Combine the lgdt and lidt emulation logic
      KVM: x86: Inject #GP when loading system segments with non-canonical base
      KVM: x86: Remove redundant and incorrect cpl check on task-switch
      KVM: x86: Emulator mis-decodes VEX instructions on real-mode
      KVM: x86: Warn on APIC base relocation
      KVM: x86: Return UNHANDLABLE on unsupported SYSENTER
      KVM: x86: MOVNTI emulation min opsize is not respected
      KVM: x86: Software disabled APIC should still deliver NMIs
      KVM: x86: Fix lost interrupt on irr_pending race
      KVM: x86: Revert NoBigReal patch in the emulator
      KVM: x86: Stack size is overridden by __linearize
      KVM: x86: Emulator performs privilege checks on __linearize
      KVM: x86: Perform limit checks when assigning EIP
      KVM: x86: Non-canonical access using SS should cause #SS
      KVM: x86: Move __linearize masking of la into switch
      KVM: x86: Generate #UD when memory operand is required
      KVM: x86: Fix reserved x2apic registers
      KVM: x86: Remove prefix flag when GP macro is used
      KVM: x86: Do not push eflags.vm on pushf
      KVM: x86: Emulate should check #UD before #GP
      KVM: x86: em_ret_far overrides cpl

Nicholas Krause (1):
      KVM: x86: Remove FIXMEs in emulate.c

Owen Hofmann (1):
      kvm: x86: Fix kvm clock versioning.

Paolo Bonzini (27):
      Merge tag 'kvm-s390-next-20141028' of git://git.kernel.org/.../kvms390/linux into HEAD
      Merge remote-tracking branch 'origin/master' into HEAD
      KVM: emulator: always inline __linearize
      Merge tag 'kvm-s390-next-20141107' of git://git.kernel.org/.../kvms390/linux into HEAD
      kvm: x86: vmx: avoid returning bool to distinguish success from error
      KVM: x86: fix warning on 32-bit compilation
      kvm: memslots: track id_to_index changes during the insertion sort
      kvm: commonize allocation of the new memory slots
      kvm: simplify update_memslots invocation
      KVM: compute correct map even if all APICs are software disabled
      KVM: emulator: remove code duplication in register_address{,_increment}
      KVM: emulator: remove duplicated limit check
      KVM: ia64: remove
      kvm: x86: move ioapic.c and irq_comm.c back to arch/x86/
      kvm: x86: mask out XSAVES
      KVM: x86: move device assignment out of kvm_host.h
      kvm: x86: avoid warning about potential shift wrapping bug
      Merge tag 'kvm-s390-next-20141128' of git://git.kernel.org/.../kvms390/linux into HEAD
      Merge tag 'kvm-s390-next-20141204' of git://git.kernel.org/.../kvms390/linux into HEAD
      x86: export get_xsave_addr
      KVM: x86: support XSAVES usage in the host
      KVM: x86: use F() macro throughout cpuid.c
      KVM: cpuid: set CPUID(EAX=0xd,ECX=1).EBX correctly
      KVM: cpuid: mask more bits in leaf 0xd and subleaves
      Merge tag 'kvm-arm-for-3.19-take2' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      KVM: move APIC types to arch/x86/
      Merge tag 'signed-kvm-ppc-next' of git://github.com/agraf/linux-2.6 into HEAD

Paul Mackerras (5):
      KVM: PPC: Book3S HV: Fix computation of tlbie operand
      KVM: PPC: Book3S HV: Fix KSM memory corruption
      KVM: PPC: Book3S HV: Simplify locking around stolen time calculations
      KVM: PPC: Book3S HV: Remove code for PPC970 processors
      KVM: PPC: Book3S HV: Fix endianness of instruction obtained from HEIR register

Peter Maydell (1):
      arm/arm64: KVM: vgic: move reset initialization into vgic_init_maps()

Radim Krcmar (1):
      kvm: remove CONFIG_X86 #ifdefs from files formerly shared with ia64

Radim Krčmář (14):
      KVM: x86: add apic_timer_expired()
      KVM: x86: fix deadline tsc interrupt injection
      KVM: x86: detect SPIV changes under APICv
      KVM: x86: detect LVTT changes under APICv
      KVM: x86: optimize some accesses to LVTT and SPIV
      kvm: remove IA64 ioctls
      kvm: x86: move assigned-dev.c and iommu.c to arch/x86/
      KVM: x86: use MSR_ICR instead of a number
      KVM: x86: don't retry hopeless APIC delivery
      KVM: x86: deliver phys lowest-prio
      KVM: x86: fix APIC physical destination wrapping
      KVM: x86: check bounds of APIC maps
      KVM: x86: allow 256 logical x2APICs again
      KVM: cpuid: recompute CPUID 0xD.0:EBX,ECX

Rickard Strandqvist (4):
      arch: powerpc: kvm: book3s_32_mmu.c: Remove unused function
      arch: powerpc: kvm: book3s.c: Remove some unused functions
      arch: powerpc: kvm: book3s_pr.c: Remove unused function
      arch: powerpc: kvm: book3s_paired_singles.c: Remove unused function

Sam Bobroff (1):
      KVM: PPC: Book3S HV: Improve H_CONFER implementation

Shannon Zhao (1):
      arm/arm64: KVM: vgic: kick the specific vcpu instead of iterating through all

Suresh E. Warrier (3):
      KVM: PPC: Book3S HV: Fix inaccuracies in ICP emulation for H_IPI
      KVM: PPC: Book3S HV: Check wait conditions before sleeping in kvmppc_vcore_blocked
      KVM: PPC: Book3S HV: Tracepoints for KVM HV guest interactions

Thomas Huth (4):
      KVM: s390: Make the simple ipte mutex specific to a VM instead of global
      KVM: s390: Fix size of monitor-class number field
      KVM: s390: Small fixes for the PFMF handler
      KVM: s390: Fix rewinding of the PSW pointing to an EXECUTE instruction

Tiejun Chen (7):
      Documentation: virtual: kvm: correct one bit description in APF case
      kvm: kvmclock: use get_cpu() and put_cpu()
      kvm: x86: vmx: move down hardware_setup() and hardware_unsetup()
      kvm: x86: vmx: move some vmx setting from vmx_init() to hardware_setup()
      kvm: x86: vmx: cleanup handle_ept_violation
      kvm: x86: vmx: remove MMIO_MAX_GEN
      kvm: Documentation: remove ia64

Wanpeng Li (4):
      kvm: x86: Add kvm_x86_ops hook that enables XSAVES for guest
      kvm: x86: handle XSAVES vmcs and vmexit
      kvm: vmx: add MSR logic for XSAVES
      kvm: vmx: add nested virtualization support for xsaves

Wei Wang (1):
      KVM: x86: reset RVI upon system reset

wanghaibin (1):
      KVM: ARM: VGIC: Optimize the vGIC vgic_update_irq_pending function.

 Documentation/ia64/kvm.txt               |   83 --
 Documentation/virtual/kvm/api.txt        |  102 +-
 Documentation/virtual/kvm/devices/vm.txt |   10 +-
 Documentation/virtual/kvm/msr.txt        |    2 +-
 MAINTAINERS                              |    9 -
 arch/arm/include/asm/kvm_emulate.h       |    5 +
 arch/arm/include/asm/kvm_host.h          |    2 -
 arch/arm/include/asm/kvm_mmu.h           |    6 +-
 arch/arm/kvm/arm.c                       |   78 +-
 arch/arm/kvm/guest.c                     |   26 -
 arch/arm/kvm/mmio.c                      |   15 +-
 arch/arm/kvm/mmu.c                       |   99 +-
 arch/arm/kvm/psci.c                      |   18 +
 arch/arm64/include/asm/kvm_emulate.h     |    5 +
 arch/arm64/include/asm/kvm_host.h        |    3 +-
 arch/arm64/include/asm/kvm_mmu.h         |    6 +-
 arch/arm64/kvm/guest.c                   |   26 -
 arch/ia64/Kconfig                        |    3 -
 arch/ia64/Makefile                       |    1 -
 arch/ia64/include/asm/kvm_host.h         |  609 --------
 arch/ia64/include/asm/pvclock-abi.h      |   48 -
 arch/ia64/include/uapi/asm/kvm.h         |  268 ----
 arch/ia64/kvm/Kconfig                    |   66 -
 arch/ia64/kvm/Makefile                   |   67 -
 arch/ia64/kvm/asm-offsets.c              |  241 ----
 arch/ia64/kvm/irq.h                      |   33 -
 arch/ia64/kvm/kvm-ia64.c                 | 1942 --------------------------
 arch/ia64/kvm/kvm_fw.c                   |  674 ---------
 arch/ia64/kvm/kvm_lib.c                  |   21 -
 arch/ia64/kvm/kvm_minstate.h             |  266 ----
 arch/ia64/kvm/lapic.h                    |   30 -
 arch/ia64/kvm/memcpy.S                   |    1 -
 arch/ia64/kvm/memset.S                   |    1 -
 arch/ia64/kvm/misc.h                     |   94 --
 arch/ia64/kvm/mmio.c                     |  336 -----
 arch/ia64/kvm/optvfault.S                | 1090 ---------------
 arch/ia64/kvm/process.c                  | 1024 --------------
 arch/ia64/kvm/trampoline.S               | 1038 --------------
 arch/ia64/kvm/vcpu.c                     | 2209 ------------------------------
 arch/ia64/kvm/vcpu.h                     |  752 ----------
 arch/ia64/kvm/vmm.c                      |   99 --
 arch/ia64/kvm/vmm_ivt.S                  | 1392 -------------------
 arch/ia64/kvm/vti.h                      |  290 ----
 arch/ia64/kvm/vtlb.c                     |  640 ---------
 arch/powerpc/include/asm/kvm_book3s.h    |    2 -
 arch/powerpc/include/asm/kvm_book3s_64.h |    3 +-
 arch/powerpc/include/asm/kvm_host.h      |   18 +-
 arch/powerpc/include/asm/kvm_ppc.h       |    2 -
 arch/powerpc/kernel/asm-offsets.c        |    2 +-
 arch/powerpc/kvm/Kconfig                 |    1 +
 arch/powerpc/kvm/book3s.c                |    8 -
 arch/powerpc/kvm/book3s_32_mmu.c         |    5 -
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |  224 +--
 arch/powerpc/kvm/book3s_hv.c             |  438 ++----
 arch/powerpc/kvm/book3s_hv_builtin.c     |  136 +-
 arch/powerpc/kvm/book3s_hv_interrupts.S  |   39 +-
 arch/powerpc/kvm/book3s_hv_ras.c         |    5 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |  150 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c     |   36 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |  251 +---
 arch/powerpc/kvm/book3s_paired_singles.c |    8 -
 arch/powerpc/kvm/book3s_pr.c             |    5 -
 arch/powerpc/kvm/book3s_xics.c           |   30 +-
 arch/powerpc/kvm/book3s_xics.h           |    1 +
 arch/powerpc/kvm/e500.c                  |    8 -
 arch/powerpc/kvm/powerpc.c               |   10 +-
 arch/powerpc/kvm/trace_book3s.h          |   32 +
 arch/powerpc/kvm/trace_booke.h           |   47 +-
 arch/powerpc/kvm/trace_hv.h              |  477 +++++++
 arch/powerpc/kvm/trace_pr.h              |   25 +-
 arch/s390/include/asm/kvm_host.h         |   99 +-
 arch/s390/include/asm/pgalloc.h          |    1 +
 arch/s390/include/asm/sigp.h             |    1 +
 arch/s390/kvm/gaccess.c                  |   40 +-
 arch/s390/kvm/intercept.c                |   20 +-
 arch/s390/kvm/interrupt.c                | 1044 +++++++++-----
 arch/s390/kvm/kvm-s390.c                 |   22 +-
 arch/s390/kvm/kvm-s390.h                 |   11 +-
 arch/s390/kvm/priv.c                     |   95 +-
 arch/s390/kvm/sigp.c                     |  305 ++---
 arch/s390/mm/pgtable.c                   |   41 +-
 arch/x86/include/asm/kvm_host.h          |   37 +-
 arch/x86/include/asm/vmx.h               |    3 +
 arch/x86/include/asm/xsave.h             |    1 +
 arch/x86/include/uapi/asm/vmx.h          |    6 +-
 arch/x86/kernel/kvm.c                    |    9 +-
 arch/x86/kernel/kvmclock.c               |   20 +-
 arch/x86/kernel/xsave.c                  |    1 +
 arch/x86/kvm/Makefile                    |    7 +-
 {virt => arch/x86}/kvm/assigned-dev.c    |   30 +-
 arch/x86/kvm/assigned-dev.h              |   32 +
 arch/x86/kvm/cpuid.c                     |   57 +-
 arch/x86/kvm/emulate.c                   |  408 +++---
 {virt => arch/x86}/kvm/ioapic.c          |   12 -
 {virt => arch/x86}/kvm/ioapic.h          |   21 +-
 {virt => arch/x86}/kvm/iommu.c           |   11 +-
 {virt => arch/x86}/kvm/irq_comm.c        |   45 +-
 arch/x86/kvm/lapic.c                     |  210 ++-
 arch/x86/kvm/lapic.h                     |   14 +-
 arch/x86/kvm/mmu.c                       |   13 +-
 arch/x86/kvm/svm.c                       |   24 +-
 arch/x86/kvm/trace.h                     |   37 +
 arch/x86/kvm/vmx.c                       |  608 ++++----
 arch/x86/kvm/x86.c                       |  226 ++-
 arch/x86/kvm/x86.h                       |    3 +-
 include/kvm/arm_arch_timer.h             |   10 +-
 include/kvm/arm_vgic.h                   |   12 +-
 include/linux/kvm_host.h                 |  108 +-
 include/linux/kvm_types.h                |   27 -
 include/uapi/linux/kvm.h                 |   11 -
 virt/kvm/arm/arch_timer.c                |   30 +-
 virt/kvm/arm/vgic.c                      |  116 +-
 virt/kvm/eventfd.c                       |    7 -
 virt/kvm/kvm_main.c                      |  149 +-
 114 files changed, 3569 insertions(+), 16108 deletions(-)
 delete mode 100644 Documentation/ia64/kvm.txt
 delete mode 100644 arch/ia64/include/asm/kvm_host.h
 delete mode 100644 arch/ia64/include/asm/pvclock-abi.h
 delete mode 100644 arch/ia64/include/uapi/asm/kvm.h
 delete mode 100644 arch/ia64/kvm/Kconfig
 delete mode 100644 arch/ia64/kvm/Makefile
 delete mode 100644 arch/ia64/kvm/asm-offsets.c
 delete mode 100644 arch/ia64/kvm/irq.h
 delete mode 100644 arch/ia64/kvm/kvm-ia64.c
 delete mode 100644 arch/ia64/kvm/kvm_fw.c
 delete mode 100644 arch/ia64/kvm/kvm_lib.c
 delete mode 100644 arch/ia64/kvm/kvm_minstate.h
 delete mode 100644 arch/ia64/kvm/lapic.h
 delete mode 100644 arch/ia64/kvm/memcpy.S
 delete mode 100644 arch/ia64/kvm/memset.S
 delete mode 100644 arch/ia64/kvm/misc.h
 delete mode 100644 arch/ia64/kvm/mmio.c
 delete mode 100644 arch/ia64/kvm/optvfault.S
 delete mode 100644 arch/ia64/kvm/process.c
 delete mode 100644 arch/ia64/kvm/trampoline.S
 delete mode 100644 arch/ia64/kvm/vcpu.c
 delete mode 100644 arch/ia64/kvm/vcpu.h
 delete mode 100644 arch/ia64/kvm/vmm.c
 delete mode 100644 arch/ia64/kvm/vmm_ivt.S
 delete mode 100644 arch/ia64/kvm/vti.h
 delete mode 100644 arch/ia64/kvm/vtlb.c
 create mode 100644 arch/powerpc/kvm/trace_book3s.h
 create mode 100644 arch/powerpc/kvm/trace_hv.h
 rename {virt => arch/x86}/kvm/assigned-dev.c (97%)
 create mode 100644 arch/x86/kvm/assigned-dev.h
 rename {virt => arch/x86}/kvm/ioapic.c (98%)
 rename {virt => arch/x86}/kvm/ioapic.h (89%)
 rename {virt => arch/x86}/kvm/iommu.c (96%)
 rename {virt => arch/x86}/kvm/irq_comm.c (89%)



