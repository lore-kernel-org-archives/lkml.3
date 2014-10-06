Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaJFNHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:07:21 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61412 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaJFNHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:07:18 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.18
Date: Mon,  6 Oct 2014 15:07:08 +0200
Message-Id: <1412600828-3194-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit ab3f285f227fec62868037e9b1b1fd18294a83b8:

  KVM: s390/mm: try a cow on read only pages for key ops (2014-08-25 14:35:28 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to f439ed27f8b8b90d243ae15acb193d37f96eebe0:

  kvm: do not handle APIC access page if in-kernel irqchip is not in use (2014-10-02 19:26:11 +0200)

----------------------------------------------------------------
Fixes and features for 3.18.

Apart from the usual cleanups, here is the summary of new features:

- s390 moves closer towards host large page support

- PowerPC has improved support for debugging (both inside the guest and
  via gdbstub) and support for e6500 processors

- ARM/ARM64 support read-only memory (which is necessary to put firmware
  in emulated NOR flash)

- x86 has the usual emulator fixes and nested virtualization improvements
  (including improved Windows support on Intel and Jailhouse hypervisor
  support on AMD), adaptive PLE which helps overcommitting of huge guests.
  Also included are some patches that make KVM more friendly to memory
  hot-unplug, and fixes for rare caching bugs.

Two patches have trivial mm/ parts that were acked by Rik and Andrew.

Note: I will soon switch to a subkey for signing purposes.  To verify
future signed pull requests from me, please update my key with
"gpg --recv-keys 9B4D86F2".  You should see 3 new subkeys---the
one for signing will be a 2048-bit RSA key, 4E6B09D7.

----------------------------------------------------------------
Alex Bennée (2):
      KVM: document KVM_SET_GUEST_DEBUG api
      KVM: fix api documentation of KVM_GET_EMULATED_CPUID

Alex Williamson (1):
      KVM: x86 emulator: emulate MOVNTDQ

Alexander Graf (1):
      KVM: PPC: Pass enum to kvmppc_get_last_inst

Andres Lagar-Cavilla (4):
      kvm: Faults which trigger IO release the mmap_sem
      kvm/x86/mmu: Pass gfn and level to rmapp callback.
      kvm: Fix page ageing bugs
      kvm: Fix kvm_get_page_retry_io __gup retval check

Aneesh Kumar K.V (1):
      KVM: PPC: BOOK3S: HV: CMA: Reserve cma region only in hypervisor mode

Ard Biesheuvel (1):
      ARM/arm64: KVM: fix use of WnR bit in kvm_is_write_fault()

Bharat Bhushan (8):
      KVM: PPC: BOOKE: allow debug interrupt at "debug level"
      KVM: PPC: BOOKE : Emulate rfdi instruction
      KVM: PPC: BOOKE: Allow guest to change MSR_DE
      KVM: PPC: BOOKE: Clear guest dbsr in userspace exit KVM_EXIT_DEBUG
      KVM: PPC: BOOKE: Guest and hardware visible debug registers are same
      KVM: PPC: BOOKE: Add one reg interface for DBSR
      KVM: PPC: BOOKE: Add one_reg documentation of SPRG9 and DBSR
      KVM: PPC: BOOKE: Emulate debug registers and exception

Chen Yucong (1):
      kvm: x86: use macros to compute bank MSRs

Christian Borntraeger (13):
      KVM: avoid unnecessary synchronize_rcu
      KVM: s390: no special machine check delivery
      KVM: s390/mm: fix up indentation of set_guest_storage_key
      KVM: remove redundant check of in_spin_loop
      KVM: remove redundant assigment of return value in kvm_dev_ioctl
      KVM: remove redundant assignments in __kvm_set_memory_region
      KVM: s390: add __must_check to interrupt deliver functions
      KVM: s390: Limit guest size to 16TB
      KVM: s390: unintended fallthrough for external call
      KVM: s390: get rid of constant condition in ipte_unlock_simple
      KVM: s390/cmm: Fix prefix handling for diag 10 balloon
      KVM: s390/interrupt: remove double assignment
      KVM: s390/facilities: allow TOD-CLOCK steering facility bit

Christoffer Dall (14):
      KVM: Introduce gfn_to_hva_memslot_prot
      arm/arm64: KVM: Support KVM_CAP_READONLY_MEM
      KVM: Unconditionally export KVM_CAP_READONLY_MEM
      KVM: Unconditionally export KVM_CAP_USER_NMI
      Merge remote-tracking branch 'kvm/next' into queue
      arm/arm64: KVM: Rename irq_state to irq_pending
      arm/arm64: KVM: Rename irq_active to irq_queued
      arm/arm64: KVM: vgic: Clear queued flags on unqueue
      arm/arm64: KVM: vgic: Improve handling of GICD_I{CS}PENDRn
      arm/arm64: KVM: vgic: Fix SGI writes to GICD_I{CS}PENDR0
      arm/arm64: KVM: vgic: Clarify and correct vgic documentation
      KVM: EVENTFD: Remove inclusion of irq.h
      arm/arm64: KVM: Fix set_clear_sgi_pend_reg offset
      arm/arm64: KVM: Report correct FSC for unsupported fault types

Cornelia Huck (1):
      KVM: s390: register flic ops dynamically

David Hildenbrand (5):
      KVM: clarify the idea of kvm_dirty_regs
      KVM: s390: clear kvm_dirty_regs when dropping to user space
      KVM: s390: synchronize more registers with kvm_run
      KVM: s390: implement KVM_REQ_TLB_FLUSH and make use of it
      KVM: s390: count vcpu wakeups in stat.halt_wakeup

David Matlack (3):
      kvm: fix potentially corrupt mmio cache
      kvm: x86: fix stale mmio cache bug
      kvm: don't take vcpu mutex for obviously invalid vcpu ioctls

Eric Auger (1):
      KVM: EVENTFD: remove inclusion of irq.h

Guo Hui Liu (1):
      KVM: x86: Use kvm_make_request when applicable

Jens Freimann (4):
      KVM: s390: add defines for pfault init delivery code
      KVM: s390: factor out get_ilc() function
      KVM: s390: return -EFAULT if lowcore is not mapped during irq delivery
      KVM: s390: don't use kvm lock in interrupt injection code

Joel Schopp (1):
      arm/arm64: KVM: Fix VTTBR_BADDR_MASK and pgd alloc

Liang Chen (1):
      KVM: x86: directly use kvm_make_request again

Madhavan Srinivasan (2):
      powerpc/kvm: support to handle sw breakpoint
      powerpc/kvm: common sw breakpoint instr across ppc

Marc Zyngier (8):
      KVM: ARM: vgic: plug irq injection race
      arm/arm64: KVM: vgic: switch to dynamic allocation
      arm/arm64: KVM: vgic: Parametrize VGIC_NR_SHARED_IRQS
      arm/arm64: KVM: vgic: kill VGIC_MAX_CPUS
      arm/arm64: KVM: vgic: handle out-of-range MMIO accesses
      arm/arm64: KVM: vgic: kill VGIC_NR_IRQS
      arm/arm64: KVM: vgic: delay vgic allocation until init time
      arm/arm64: KVM: vgic: make number of irqs a configurable attribute

Marcelo Tosatti (1):
      KVM: nested VMX: disable perf cpuid reporting

Martin Schwidefsky (6):
      KVM: s390/mm: readd address parameter to pgste_ipte_notify
      KVM: s390/mm: readd address parameter to gmap_do_ipte_notify
      KVM: s390/mm: cleanup gmap function arguments, variable names
      KVM: s390/mm: use radix trees for guest to host mappings
      KVM: s390/mm: support gmap page tables with less than 5 levels
      KVM: s390/mm: remove outdated gmap data structures

Michael Neuling (1):
      KVM: PPC: Book3S HV: Add register name when loading toc

Mihai Caraman (10):
      powerpc/booke: Restrict SPE exception handlers to e200/e500 cores
      powerpc/booke: Revert SPE/AltiVec common defines for interrupt numbers
      KVM: PPC: Book3E: Increase FPU laziness
      KVM: PPC: Book3e: Add AltiVec support
      KVM: PPC: Make ONE_REG powerpc generic
      KVM: PPC: Move ONE_REG AltiVec support to powerpc
      KVM: PPC: Remove the tasklet used by the hrtimer
      KVM: PPC: Remove shared defines for SPE and AltiVec interrupts
      KVM: PPC: e500mc: Add support for single threaded vcpus on e6500 core
      KVM: PPC: Book3E: Enable e6500 core

Monam Agarwal (1):
      arch/x86: Use RCU_INIT_POINTER(x, NULL) in kvm/vmx.c

Nadav Amit (10):
      KVM: x86: Clear apic tsc-deadline after deadline
      KVM: x86: recalculate_apic_map after enabling apic
      KVM: x86: Clarify PMU related features bit manipulation
      KVM: x86: Replace X86_FEATURE_NX offset with the definition
      KVM: vmx: VMXOFF emulation in vm86 should cause #UD
      KVM: x86: Warn if guest virtual address space is not 48-bits
      KVM: x86: Don't report guest userspace emulation error to userspace
      KVM: x86: emulating descriptor load misses long-mode case
      KVM: vmx: Inject #GP on invalid PAT CR
      KVM: x86: Remove debug assertion of non-PAE reserved bits

Paolo Bonzini (24):
      KVM: x86: raise invalid TSS exceptions during a task switch
      KVM: emulate: do not return X86EMUL_PROPAGATE_FAULT explicitly
      KVM: emulate: warn on invalid or uninitialized exception numbers
      Merge tag 'kvm-s390-20140825' of git://git.kernel.org/.../kvms390/linux into HEAD
      kvm: x86: fix tracing for 32-bit
      Merge tag 'kvm-s390-next-20140825' of git://git.kernel.org/.../kvms390/linux into HEAD
      KVM: x86: fix some sparse warnings
      KVM: x86: remove Aligned bit from movntps/movntpd
      KVM: forward declare structs in kvm_types.h
      KVM: x86: use guest maxphyaddr to check MTRR values
      KVM: do not bias the generation number in kvm_current_mmio_generation
      KVM: x86: reserve bit 8 of non-leaf PDPEs and PML4Es in 64-bit mode on AMD
      KVM: nSVM: propagate the NPF EXITINFO to the guest
      KVM: x86: skip writeback on injection of nested exception
      KVM: x86: propagate exception from permission checks on the nested page fault
      Merge tag 'kvm-s390-next-20140910' of git://git.kernel.org/.../kvms390/linux into kvm-next
      KVM: x86: make apic_accept_irq tracepoint more generic
      kvm-vfio: do not use module_init
      kvm: Make init_rmode_tss() return 0 on success.
      x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is read-only
      Merge tag 'signed-kvm-ppc-next' of git://github.com/agraf/linux-2.6 into kvm-next
      Merge tag 'kvm-arm-for-3.18' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-next
      Merge tag 'kvm-s390-next-20141001' of git://git.kernel.org/.../kvms390/linux into kvm-next
      kvm: do not handle APIC access page if in-kernel irqchip is not in use

Paul Mackerras (2):
      KVM: PPC: Book3S HV: Increase timeout for grabbing secondary threads
      KVM: PPC: Book3S HV: Only accept host PVR value for guest PVR

Radim Krčmář (8):
      KVM: add kvm_arch_sched_in
      KVM: x86: introduce sched_in to kvm_x86_ops
      KVM: VMX: make PLE window per-VCPU
      KVM: VMX: dynamise PLE window
      KVM: trace kvm_ple_window grow/shrink
      KVM: static inline empty kvm_arch functions
      KVM: remove garbage arg to *hardware_{en,dis}able
      KVM: x86: count actual tlb flushes

Tang Chen (8):
      kvm: Use APIC_DEFAULT_PHYS_BASE macro as the apic access page address.
      kvm: Remove ept_identity_pagetable from struct kvm_arch.
      kvm: Make init_rmode_identity_map() return 0 on success.
      kvm: Rename make_all_cpus_request() to kvm_make_all_cpus_request() and make it non-static
      kvm: Add arch specific mmu notifier for page invalidation
      kvm: x86: Add request bit to reload APIC access page address
      kvm: vmx: Implement set_apic_access_page_addr
      kvm: x86: Unpin and remove kvm_arch->apic_access_page

Tiejun Chen (2):
      KVM: mmio: cleanup kvm_set_mmio_spte_mask
      kvm: x86: fix two typos in comment

Tony Krowiak (1):
      KVM: CPACF: Enable MSA4 instructions for kvm guest

Wanpeng Li (6):
      KVM: x86: drop fpu_activate hook
      KVM: x86: fix check legal type of Variable Range MTRRs
      KVM: x86: #GP when attempts to write reserved bits of Variable Range MTRRs
      KVM: vmx: fix ept reserved bits for 1-GByte page
      KVM: nVMX: introduce nested_get_vmcs12_pages
      KVM: nVMX: nested TPR shadow/threshold emulation

Wei Huang (1):
      KVM: SVM: add rdmsr support for AMD event registers

Will Deacon (9):
      KVM: ARM/arm64: fix non-const declaration of function returning const
      KVM: ARM/arm64: fix broken __percpu annotation
      KVM: ARM/arm64: avoid returning negative error code as bool
      KVM: ARM/arm64: return -EFAULT if copy_from_user fails in set_timer_reg
      KVM: vgic: return int instead of bool when checking I/O ranges
      KVM: vgic: declare probe function pointer as const
      KVM: device: add simple registration mechanism for kvm_device_ops
      KVM: ARM: vgic: register kvm_device_ops dynamically
      KVM: VFIO: register kvm_device_ops dynamically

Zhang Haoyu (1):
      kvm: ioapic: conditionally delay irq delivery duringeoi broadcast

 Documentation/virtual/kvm/api.txt              | 188 ++++---
 Documentation/virtual/kvm/devices/arm-vgic.txt |  10 +
 Documentation/virtual/kvm/mmu.txt              |  14 +
 arch/arm/include/asm/kvm_emulate.h             |   5 +
 arch/arm/include/asm/kvm_host.h                |  23 +-
 arch/arm/include/asm/kvm_mmu.h                 |  11 -
 arch/arm/include/uapi/asm/kvm.h                |   2 +
 arch/arm/kvm/arm.c                             |  34 +-
 arch/arm/kvm/coproc.c                          |   2 +-
 arch/arm/kvm/guest.c                           |   2 +-
 arch/arm/kvm/mmu.c                             |  40 +-
 arch/arm64/include/asm/kvm_arm.h               |  13 +-
 arch/arm64/include/asm/kvm_emulate.h           |   5 +
 arch/arm64/include/asm/kvm_host.h              |  24 +-
 arch/arm64/include/asm/kvm_mmu.h               |  18 +-
 arch/arm64/include/uapi/asm/kvm.h              |   2 +
 arch/arm64/kvm/guest.c                         |   2 +-
 arch/arm64/kvm/sys_regs.c                      |   2 +-
 arch/ia64/include/asm/kvm_host.h               |  15 +-
 arch/ia64/kvm/kvm-ia64.c                       |  34 +-
 arch/mips/include/asm/kvm_host.h               |  16 +-
 arch/mips/kvm/mips.c                           |  40 +-
 arch/powerpc/include/asm/kvm_asm.h             |  20 +-
 arch/powerpc/include/asm/kvm_booke.h           |   7 +-
 arch/powerpc/include/asm/kvm_host.h            |  24 +-
 arch/powerpc/include/asm/kvm_ppc.h             |  13 +-
 arch/powerpc/include/asm/reg_booke.h           |   2 +
 arch/powerpc/include/uapi/asm/kvm.h            |   6 +
 arch/powerpc/kernel/cpu_setup_fsl_booke.S      |  12 +-
 arch/powerpc/kernel/cputable.c                 |   5 +
 arch/powerpc/kernel/exceptions-64e.S           |   4 +-
 arch/powerpc/kernel/head_fsl_booke.S           |  26 +-
 arch/powerpc/kvm/book3s.c                      | 162 ++----
 arch/powerpc/kvm/book3s.h                      |   3 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c            |   4 +-
 arch/powerpc/kvm/book3s_hv.c                   |  47 +-
 arch/powerpc/kvm/book3s_hv_builtin.c           |  12 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S        |   3 +-
 arch/powerpc/kvm/book3s_pr.c                   |   6 +-
 arch/powerpc/kvm/booke.c                       | 287 +++++++---
 arch/powerpc/kvm/booke.h                       |  40 +-
 arch/powerpc/kvm/booke_emulate.c               | 163 ++++++
 arch/powerpc/kvm/bookehv_interrupts.S          |  13 +-
 arch/powerpc/kvm/e500.h                        |  20 +
 arch/powerpc/kvm/e500_emulate.c                |  20 +
 arch/powerpc/kvm/e500_mmu_host.c               |  20 +-
 arch/powerpc/kvm/e500mc.c                      |  60 +-
 arch/powerpc/kvm/emulate.c                     |  17 +-
 arch/powerpc/kvm/emulate_loadstore.c           |   2 +-
 arch/powerpc/kvm/powerpc.c                     | 134 +++--
 arch/powerpc/platforms/Kconfig.cputype         |   6 +-
 arch/s390/include/asm/kvm_host.h               |  34 +-
 arch/s390/include/asm/pgalloc.h                |   8 +-
 arch/s390/include/asm/pgtable.h                |  72 +--
 arch/s390/include/asm/tlb.h                    |   2 +-
 arch/s390/include/uapi/asm/kvm.h               |  10 +
 arch/s390/kvm/diag.c                           |  28 +-
 arch/s390/kvm/gaccess.c                        |   3 +-
 arch/s390/kvm/interrupt.c                      | 152 ++---
 arch/s390/kvm/kvm-s390.c                       | 179 +++---
 arch/s390/kvm/kvm-s390.h                       |   6 +-
 arch/s390/kvm/priv.c                           |  11 +-
 arch/s390/mm/fault.c                           |  25 +-
 arch/s390/mm/pgtable.c                         | 707 +++++++++++------------
 arch/s390/mm/vmem.c                            |   2 +-
 arch/x86/include/asm/cpufeature.h              |   1 +
 arch/x86/include/asm/kvm_host.h                |  34 +-
 arch/x86/include/asm/kvm_para.h                |  10 +-
 arch/x86/kernel/cpu/amd.c                      |   7 +
 arch/x86/kvm/cpuid.c                           |  31 +-
 arch/x86/kvm/cpuid.h                           |  10 +-
 arch/x86/kvm/emulate.c                         |  62 ++-
 arch/x86/kvm/lapic.c                           |  34 +-
 arch/x86/kvm/mmu.c                             | 139 ++---
 arch/x86/kvm/mmu.h                             |   5 +
 arch/x86/kvm/paging_tmpl.h                     |  22 +-
 arch/x86/kvm/pmu.c                             |  24 +-
 arch/x86/kvm/svm.c                             |  40 +-
 arch/x86/kvm/trace.h                           |  41 +-
 arch/x86/kvm/vmx.c                             | 377 ++++++++++---
 arch/x86/kvm/x86.c                             | 148 +++--
 arch/x86/kvm/x86.h                             |  22 +-
 drivers/iommu/amd_iommu_v2.c                   |   6 +-
 include/kvm/arm_vgic.h                         | 112 +++-
 include/linux/kvm_host.h                       |  31 +-
 include/linux/kvm_types.h                      |  14 +
 include/linux/mm.h                             |   1 +
 include/linux/mmu_notifier.h                   |  24 +-
 include/trace/events/kvm.h                     |  36 +-
 include/uapi/linux/kvm.h                       |  28 +-
 mm/gup.c                                       |   4 +
 mm/mmu_notifier.c                              |   5 +-
 mm/rmap.c                                      |   6 +-
 virt/kvm/arm/vgic.c                            | 744 +++++++++++++++++++------
 virt/kvm/assigned-dev.c                        |   4 +-
 virt/kvm/async_pf.c                            |   4 +-
 virt/kvm/eventfd.c                             |   4 +-
 virt/kvm/ioapic.c                              |  46 +-
 virt/kvm/ioapic.h                              |   2 +
 virt/kvm/iommu.c                               |  19 +-
 virt/kvm/kvm_main.c                            | 192 +++++--
 virt/kvm/vfio.c                                |  22 +-
 virt/kvm/vfio.h                                |  13 +
 103 files changed, 3360 insertions(+), 1843 deletions(-)
 create mode 100644 virt/kvm/vfio.h
