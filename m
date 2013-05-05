Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3EEMAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 08:00:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab3EEMAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 08:00:36 -0400
Date: Sun, 5 May 2013 15:00:31 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM updates for the 3.10 merge window
Message-ID: <20130505120031.GB1475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.10-1

to receive the KVM updates for the 3.10 merge window. 

Highlights of the updates are:

general:
 - new emulated device API
 - legacy device assignment is now optional
 - irqfd interface is more generic and can be shared between arches
x86:
 - VMCS shadow support and other nested VMX improvements
 - APIC virtualization and Posted Interrupt hardware support
 - Optimize mmio spte zapping
ppc:
  - BookE: in-kernel MPIC emulation with irqfd support
  - Book3S: in-kernel XICS emulation (incomplete)
  - Book3S: HV: migration fixes
  - BookE: more debug support preparation
  - BookE: e6500 support
ARM:
 - reworking of Hyp idmaps
s390:
 - ioeventfd for virtio-ccw

And many other bug fixes, cleanups and improvements.

Abel Gordon (11):
      KVM: nVMX: Shadow-vmcs control fields/bits
      KVM: nVMX: Detect shadow-vmcs capability
      KVM: nVMX: Introduce vmread and vmwrite bitmaps
      KVM: nVMX: Refactor handle_vmwrite
      KVM: nVMX: Fix VMXON emulation
      KVM: nVMX: Allocate shadow vmcs
      KVM: nVMX: Release shadow vmcs
      KVM: nVMX: Copy processor-specific shadow-vmcs to VMCS12
      KVM: nVMX: Copy VMCS12 to processor-specific shadow vmcs
      KVM: nVMX: Synchronize VMCS12 content with the shadow vmcs
      KVM: nVMX: Enable and disable shadow vmcs functionality

Alex Williamson (2):
      kvm: Allow build-time configuration of KVM device assignment
      kvm: KVM_CAP_IOMMU only available with device assignment

Alexander Graf (15):
      Merge commit 'origin/next' into kvm-ppc-next
      KVM: ARM: Fix kvm_vm_ioctl_irq_line
      Merge commit 'origin/next' into kvm-ppc-next
      KVM: Add KVM_IRQCHIP_NUM_PINS in addition to KVM_IOAPIC_NUM_PINS
      KVM: Introduce CONFIG_HAVE_KVM_IRQ_ROUTING
      KVM: Drop __KVM_HAVE_IOAPIC condition on irq routing
      KVM: Remove kvm_get_intr_delivery_bitmask
      KVM: Move irq routing to generic code
      KVM: Extract generic irqchip logic into irqchip.c
      KVM: Move irq routing setup to irqchip.c
      KVM: Move irqfd resample cap handling to generic code
      KVM: PPC: Support irq routing and irqfd for in-kernel MPIC
      KVM: PPC: MPIC: Add support for KVM_IRQ_LINE
      KVM: PPC: MPIC: Restrict to e500 platforms
      KVM: IA64: Carry non-ia64 changes into ia64

Andre Przywara (1):
      ARM: KVM: iterate over all CPUs for CPU compatibility check

Andrew Honig (1):
      KVM: x86: Fix memory leak in vmx.c

Arnd Bergmann (1):
      ARM: KVM: define KVM_ARM_MAX_VCPUS unconditionally

Benjamin Herrenschmidt (3):
      KVM: PPC: Book3S: Add kernel emulation for the XICS interrupt controller
      KVM: PPC: Book3S HV: Speed up wakeups of CPUs on HV KVM
      KVM: PPC: Book3S HV: Add support for real mode ICP in XICS emulation

Bharat Bhushan (9):
      KVM: PPC: move tsr update in a separate function
      KVM: PPC: Added one_reg interface for timer registers
      KVM: PPC: booke: Added debug handler
      Added ONE_REG interface for debug instruction
      KVM: PPC: cache flush for kernel managed pages
      KVM: PPC: debug stub interface parameter defined
      Rename EMULATE_DO_PAPR to EMULATE_EXIT_USER
      KVM: extend EMULATE_EXIT_USER to support different exit reasons
      booke: exit to user space if emulator request

Borislav Petkov (1):
      kvm, svm: Fix typo in printk message

Chegu Vinod (1):
      KVM: x86: Increase the "hard" max VCPU limit

Chen Gang (1):
      arch/x86/kvm: beautify source code for __u32 irq which is never < 0

Christian Borntraeger (1):
      KVM: s390: Dont do a gmap update on minor memslot changes

Christoffer Dall (3):
      KVM: ARM: Reintroduce trace_kvm_hvc
      KVM: ARM: Fix API documentation for ONE_REG encoding
      KVM: ARM: Fix spelling in error message

Cornelia Huck (6):
      KVM: s390: Export virtio-ccw api.
      KVM: Initialize irqfd from kvm_init().
      KVM: Introduce KVM_VIRTIO_CCW_NOTIFY_BUS.
      KVM: ioeventfd for virtio-ccw devices.
      KVM: s390: Wire up ioeventfd.
      KVM: s390: virtio_ccw: reset errors for new I/O.

Geoff Levand (4):
      KVM: Move vm_list kvm_lock declarations out of x86
      KVM: Make local routines static
      KVM: Move kvm_spurious_fault to x86.c
      KVM: Move kvm_rebooting declaration out of x86

Gleb Natapov (10):
      Merge  'git://github.com/agraf/linux-2.6.git kvm-ppc-next' into queue
      KVM: emulator: fix unimplemented instruction detection
      KVM: VMX: do not try to reexecute failed instruction while emulating invalid guest state
      KVM: emulator: Do not fail on emulation of undefined opcode
      KVM: emulator: mark 0xff 0x7d opcode as undefined.
      KVM: VMX: Fix check guest state validity if a guest is in VM86 mode
      Merge git://github.com/agraf/linux-2.6.git kvm-ppc-next into queue
      KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x instructions
      Merge branch 'kvm-arm-cleanup' from git://github.com/columbia/linux-kvm-arm.git
      Merge git://github.com/agraf/linux-2.6.git kvm-ppc-next into queue

Heiko Carstens (15):
      s390/kvm,gaccess: fix guest access return code handling
      s390/mm,gmap: implement gmap_translate()
      s390/kvm,tprot: use new gmap_translate() function
      s390/kvm: remove explicit -EFAULT return code checking on guest access
      s390/kvm,gaccess: shorten put/get_guest code
      s390/kvm,gaccess: shorten copy_to/from_guest code
      s390/kvm: cleanup/fix handle_tpi()
      s390/kvm,gaccess: add address space annotations
      KVM: s390: fix 24 bit psw handling in lpsw/lpswe handler
      KVM: s390: fix psw conversion in lpsw handler
      KVM: s390: fix return code handling in lpsw/lpswe handlers
      KVM: s390: make if statements in lpsw/lpswe handlers readable
      KVM: s390: fix and enforce return code handling for irq injections
      KVM: s390: fix stsi exception handling
      KVM: s390: fix compile with !CONFIG_COMPAT

Ioan Orghici (1):
      kvm: remove cast for kmalloc return value

Jan Kiszka (33):
      KVM: nVMX: Improve I/O exit handling
      KVM: nVMX: Trap unconditionally if msr bitmap access fails
      x86: kvmclock: Do not setup kvmclock vsyscall in the absence of that clock
      KVM: VMX: Make prepare_vmcs12 and load_vmcs12_host_state static
      KVM: nVMX: Advertise PAUSE and WBINVD exiting support
      KVM: nVMX: Clear segment cache after switching between L1 and L2
      KVM: nVMX: Use cached exit reason
      KVM: nVMX: Avoid one redundant vmcs_read in prepare_vmcs12
      KVM: VMX: Pass vcpu to __vmx_complete_interrupts
      KVM: nVMX: Fix switching of debug state
      KVM: nVMX: Reset RFLAGS on VM-exit
      KVM: nVMX: Fix content of MSR_IA32_VMX_ENTRY/EXIT_CTLS
      KVM: nVMX: Fix setting of CR0 and CR4 in guest mode
      KVM: x86: Drop unused return code from VCPU reset callback
      KVM: x86: Rework INIT and SIPI handling
      KVM: nVMX: Clean up and fix pin-based execution controls
      KVM: nVMX: Provide EFER.LMA saving support
      KVM: nVMX: Add preemption timer support
      KVM: VMX: Require KVM_SET_TSS_ADDR being called prior to running a VCPU
      KVM: nVMX: Check exit control for VM_EXIT_SAVE_IA32_PAT, not entry controls
      KVM: VMX: Add missing braces to avoid redundant error check
      KVM: nVMX: Fix injection of PENDING_INTERRUPT and NMI_WINDOW exits to L1
      KVM: nVMX: Rework event injection and recovery
      KVM: nVMX: Fix conditions for interrupt injection
      KVM: nVMX: Avoid reading VM_EXIT_INTR_ERROR_CODE needlessly on nested exits
      KVM: VMX: Move vmx_nmi_allowed after vmx_set_nmi_mask
      KVM: nVMX: Fix conditions for NMI injection
      KVM: nVMX: Validate EFER values for VM_ENTRY/EXIT_LOAD_IA32_EFER
      KVM: nVMX: VM_ENTRY/EXIT_LOAD_IA32_EFER overrides EFER.LMA settings
      KVM: VMX: remove unprintable characters from comment
      KVM: x86: Rework request for immediate exit
      KVM: nVMX: Skip PF interception check when queuing during nested run
      KVM: x86: Account for failing enable_irq_window for NMI window request

Jonghwan Choi (1):
      KVM: ARM: Fix wrong address in comment

Kevin Wolf (1):
      KVM: x86 emulator: Fix segment loading in VM86

Marc Zyngier (39):
      ARM: KVM: convert GP registers from u32 to unsigned long
      ARM: KVM: abstract fault register accesses
      ARM: KVM: abstract HSR_ISV away
      ARM: KVM: abstract HSR_WNR away
      ARM: KVM: abstract HSR_SSE away
      ARM: KVM: abstract HSR_SRT_{MASK,SHIFT} away
      ARM: KVM: abstract (and fix) external abort detection away
      ARM: KVM: abstract S1TW abort detection away
      ARM: KVM: abstract SAS decoding away
      ARM: KVM: abstract IL decoding away
      ARM: KVM: abstract exception class decoding away
      ARM: KVM: abstract fault decoding away
      ARM: KVM: abstract HSR_EC_IABT away
      ARM: KVM: move kvm_condition_valid to emulate.c
      ARM: KVM: move exit handler selection to a separate file
      ARM: KVM: abstract most MMU operations
      ARM: KVM: remove superfluous include from kvm_vgic.h
      ARM: KVM: move hyp init to kvm_host.h
      ARM: KVM: use kvm_kernel_vfp_t as an abstract type for VFP containers
      ARM: KVM: allow HYP mappings to be at an offset from kernel mappings
      ARM: KVM: fix address validation for HYP mappings
      ARM: KVM: move kvm_target_cpu to guest.c
      ARM: KVM: fix fault_ipa computing
      ARM: KVM: vgic: decouple alignment restriction from page size
      ARM: KVM: move include of asm/idmap.h to kvm_mmu.h
      ARM: KVM: change kvm_tlb_flush_vmid to kvm_tlb_flush_vmid_ipa
      ARM: KVM: move kvm_handle_wfi to handle_exit.c
      ARM: KVM: sanitize freeing of HYP page tables
      ARM: KVM: Fix length of mmio access
      ARM: KVM: add support for minimal host vs guest profiling
      ARM: KVM: simplify HYP mapping population
      ARM: KVM: fix HYP mapping limitations around zero
      ARM: KVM: move to a KVM provided HYP idmap
      ARM: KVM: enforce maximum size for identity mapped code
      ARM: KVM: rework HYP page table freeing
      ARM: KVM: switch to a dual-step HYP init code
      ARM: KVM: perform HYP initilization for hotplugged CPUs
      ARM: KVM: add architecture specific hook for capabilities
      ARM: KVM: promote vfp_host pointer to generic host cpu context

Marcelo Tosatti (5):
      Merge branch 'master' into queue
      VMX: x86: handle host TSC calibration failure
      KVM: MMU: make kvm_mmu_available_pages robust against n_used_mmu_pages > n_max_mmu_pages
      Merge remote-tracking branch 'upstream/master' into queue
      Merge branch 'kvm-arm-for-3.10' of git://github.com/columbia/linux-kvm-arm into queue

Mark Rutland (1):
      ARM: KVM: arch_timer: use symbolic constants

Michael Ellerman (1):
      KVM: PPC: Book3S: Add infrastructure to implement kernel-side RTAS calls

Michael S. Tsirkin (2):
      virtio_ccw: pass a cookie value to kvm hypercall
      kvm: fix MMIO/PIO collision misdetection

Mihai Caraman (8):
      KVM: PPC: Book3E: Refactor ONE_REG ioctl implementation
      KVM: PPC: e500: Expose MMU registers via ONE_REG
      KVM: PPC: e500: Move vcpu's MMU configuration to dedicated functions
      KVM: PPC: e500: Add support for TLBnPS registers
      KVM: PPC: e500: Add support for EPTCFG register
      KVM: PPC: e500: Remove E.PT and E.HV.LRAT categories from VCPUs
      KVM: PPC: e500mc: Enable e6500 cores
      KVM: PPC: e500: Add e6500 core to Kconfig description

Nick Wang (3):
      KVM: s390: Change the virtual memory mapping location for virtio devices
      KVM: s390: Remove the sanity checks for kvm memory slot
      KVM: s390: Enable KVM_CAP_NR_MEMSLOTS on s390

Paolo Bonzini (3):
      KVM: x86: correctly initialize the CS base on reset
      pmu: prepare for migration support
      KVM: nVMX: check vmcs12 for valid activity state

Paul Mackerras (7):
      KVM: PPC: Remove unused argument to kvmppc_core_dequeue_external
      KVM: PPC: Book3S HV: Make HPT reading code notice R/C bit changes
      KVM: PPC: Book3S HV: Report VPA and DTL modifications in dirty map
      KVM: PPC: Book3S HV: Improve real-mode handling of external interrupts
      KVM: PPC: Book3S: Add support for ibm,int-on/off RTAS calls
      KVM: PPC: Book3S: Facilities to save/restore XICS presentation ctrler state
      KVM: PPC: Book3S: Add API for in-kernel XICS emulation

Raghavendra K T (2):
      kvm: Record the preemption status of vcpus using preempt notifiers
      kvm: Iterate over only vcpus that are preempted

Scott Wood (17):
      kvm/ppc/e500: h2g_tlb1_rmap: esel 0 is valid
      kvm/ppc/e500: g2h_tlb1_map: clear old bit before setting new bit
      kvm/ppc/e500: eliminate tlb_refs
      kvm/ppc: don't call complete_mmio_load when it's a store
      kvm: add device control API
      kvm/ppc/mpic: import hw/openpic.c from QEMU
      kvm/ppc/mpic: remove some obviously unneeded code
      kvm/ppc/mpic: adapt to kernel style and environment
      kvm/ppc/mpic: in-kernel MPIC emulation
      kvm/ppc/mpic: add KVM_CAP_IRQ_MPIC
      kvm: destroy emulated devices on VM exit
      kvm/ppc/mpic: Eliminate mmio_mapped
      kvm/ppc/mpic: remove default routes from documentation
      kvm/ppc/mpic: fix mmio region lists when multiple guests used
      kvm/ppc/mpic: remove users
      kvm/ppc: Hold srcu lock when calling kvm_io_bus_read/write
      kvm: Add compat_ioctl for device control API

Stuart Yoder (1):
      KVM: PPC: emulate dcbst

Takuya Yoshikawa (14):
      KVM: set_memory_region: Drop user_alloc from prepare/commit_memory_region()
      KVM: set_memory_region: Drop user_alloc from set_memory_region()
      KVM: set_memory_region: Make kvm_mr_change available to arch code
      KVM: set_memory_region: Refactor prepare_memory_region()
      KVM: set_memory_region: Refactor commit_memory_region()
      KVM: ARM: Remove kvm_arch_set_memory_region()
      KVM: MMU: Fix and clean up for_each_gfn_* macros
      KVM: MMU: Use list_for_each_entry_safe in kvm_mmu_commit_zap_page()
      KVM: MMU: Introduce a helper function for FIFO zapping
      KVM: MMU: Mark sp mmio cached when creating mmio spte
      KVM: x86: Optimize mmio spte zapping when creating/moving memslot
      KVM: MMU: Move kvm_mmu_free_some_pages() into kvm_mmu_alloc_page()
      KVM: MMU: Rename kvm_mmu_free_some_pages() to make_mmu_pages_available()
      Revert "KVM: MMU: Move kvm_mmu_free_some_pages() into kvm_mmu_alloc_page()"

Wei Yongjun (2):
      KVM: x86: fix error return code in kvm_arch_vcpu_init()
      kvm/ppc/mpic: fix missing unlock in set_base_addr()

Yang Zhang (17):
      KVM: Call kvm_apic_match_dest() to check destination vcpu
      KVM: x86: fix memory leak in vmx_init
      KVM: Add vcpu info to ioapic_update_eoi()
      KVM: Introduce struct rtc_status
      KVM: Return destination vcpu on interrupt injection
      KVM: Add reset/restore rtc_status support
      KVM: Force vmexit with virtual interrupt delivery
      KVM: Let ioapic know the irq line status
      KVM: Use eoi to track RTC interrupt delivery status
      KVM: VMX: Enable acknowledge interupt on vmexit
      KVM: VMX: Register a new IPI for posted interrupt
      KVM: VMX: Check the posted interrupt capability
      KVM: Call common update function when ioapic entry changed.
      KVM: Set TMR when programming ioapic entry
      KVM: VMX: Add the deliver posted interrupt algorithm
      KVM: VMX: Use posted interrupt to deliver virtual interrupt
      KVM: ia64: Fix kvm_vm_ioctl_irq_line

Zhang, Yang Z (1):
      KVM: x86: Fix posted interrupt with CONFIG_SMP=n

 Documentation/virtual/kvm/api.txt          |  146 ++-
 Documentation/virtual/kvm/devices/README   |    1 +
 Documentation/virtual/kvm/devices/mpic.txt |   53 +
 Documentation/virtual/kvm/devices/xics.txt |   66 +
 arch/arm/include/asm/idmap.h               |    1 -
 arch/arm/include/asm/kvm_arm.h             |    4 +
 arch/arm/include/asm/kvm_asm.h             |    2 +-
 arch/arm/include/asm/kvm_emulate.h         |  107 +-
 arch/arm/include/asm/kvm_host.h            |   57 +-
 arch/arm/include/asm/kvm_mmu.h             |   87 +-
 arch/arm/include/asm/kvm_vgic.h            |    1 -
 arch/arm/include/uapi/asm/kvm.h            |   12 +-
 arch/arm/kernel/asm-offsets.c              |   10 +-
 arch/arm/kernel/vmlinux.lds.S              |    7 +-
 arch/arm/kvm/Kconfig                       |    6 +-
 arch/arm/kvm/Makefile                      |    4 +-
 arch/arm/kvm/arch_timer.c                  |    7 +-
 arch/arm/kvm/arm.c                         |  315 ++---
 arch/arm/kvm/coproc.c                      |   28 +-
 arch/arm/kvm/coproc.h                      |    4 +-
 arch/arm/kvm/emulate.c                     |   75 +-
 arch/arm/kvm/guest.c                       |   17 +
 arch/arm/kvm/handle_exit.c                 |  164 +++
 arch/arm/kvm/init.S                        |   78 +-
 arch/arm/kvm/interrupts.S                  |   13 +-
 arch/arm/kvm/mmio.c                        |   46 +-
 arch/arm/kvm/mmu.c                         |  543 ++++----
 arch/arm/kvm/perf.c                        |   68 +
 arch/arm/kvm/vgic.c                        |    2 +-
 arch/arm/mm/idmap.c                        |   32 +-
 arch/ia64/include/asm/kvm_host.h           |    1 +
 arch/ia64/include/uapi/asm/kvm.h           |    1 -
 arch/ia64/kvm/Kconfig                      |   14 +-
 arch/ia64/kvm/Makefile                     |    6 +-
 arch/ia64/kvm/kvm-ia64.c                   |   35 +-
 arch/ia64/kvm/lapic.h                      |    6 -
 arch/powerpc/include/asm/hvcall.h          |    3 +
 arch/powerpc/include/asm/kvm_book3s.h      |    7 +-
 arch/powerpc/include/asm/kvm_book3s_64.h   |   13 +
 arch/powerpc/include/asm/kvm_book3s_asm.h  |    8 +-
 arch/powerpc/include/asm/kvm_booke.h       |    2 +
 arch/powerpc/include/asm/kvm_host.h        |   41 +-
 arch/powerpc/include/asm/kvm_ppc.h         |  114 +-
 arch/powerpc/include/asm/reg.h             |    1 +
 arch/powerpc/include/uapi/asm/kvm.h        |   94 ++
 arch/powerpc/kernel/asm-offsets.c          |    4 +
 arch/powerpc/kvm/44x.c                     |   12 +
 arch/powerpc/kvm/Kconfig                   |   26 +-
 arch/powerpc/kvm/Makefile                  |   12 +-
 arch/powerpc/kvm/book3s.c                  |   36 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c        |  120 +-
 arch/powerpc/kvm/book3s_emulate.c          |    4 +-
 arch/powerpc/kvm/book3s_hv.c               |   92 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c        |   11 -
 arch/powerpc/kvm/book3s_hv_rm_xics.c       |  406 ++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S    |  228 +++-
 arch/powerpc/kvm/book3s_pr.c               |    7 +-
 arch/powerpc/kvm/book3s_pr_papr.c          |   21 +
 arch/powerpc/kvm/book3s_rtas.c             |  274 ++++
 arch/powerpc/kvm/book3s_xics.c             | 1270 +++++++++++++++++++
 arch/powerpc/kvm/book3s_xics.h             |  130 ++
 arch/powerpc/kvm/booke.c                   |  158 ++-
 arch/powerpc/kvm/booke_interrupts.S        |   42 +-
 arch/powerpc/kvm/e500.c                    |   14 +
 arch/powerpc/kvm/e500.h                    |   46 +-
 arch/powerpc/kvm/e500_emulate.c            |   19 +
 arch/powerpc/kvm/e500_mmu.c                |  192 ++-
 arch/powerpc/kvm/e500_mmu_host.c           |   84 +-
 arch/powerpc/kvm/e500mc.c                  |   16 +
 arch/powerpc/kvm/emulate.c                 |    2 +
 arch/powerpc/kvm/irq.h                     |   20 +
 arch/powerpc/kvm/mpic.c                    | 1853 ++++++++++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c                 |  133 +-
 arch/powerpc/sysdev/xics/icp-native.c      |    8 +
 arch/s390/include/asm/pgtable.h            |    2 +
 arch/s390/include/uapi/asm/Kbuild          |    1 +
 arch/s390/include/uapi/asm/virtio-ccw.h    |   21 +
 arch/s390/kvm/Kconfig                      |    1 +
 arch/s390/kvm/Makefile                     |    2 +-
 arch/s390/kvm/diag.c                       |   26 +
 arch/s390/kvm/gaccess.h                    |  429 ++-----
 arch/s390/kvm/intercept.c                  |   18 +-
 arch/s390/kvm/interrupt.c                  |  245 ++--
 arch/s390/kvm/kvm-s390.c                   |   43 +-
 arch/s390/kvm/kvm-s390.h                   |   12 +-
 arch/s390/kvm/priv.c                       |  270 ++--
 arch/s390/mm/pgtable.c                     |  107 +-
 arch/x86/include/asm/entry_arch.h          |    4 +
 arch/x86/include/asm/hardirq.h             |    3 +
 arch/x86/include/asm/hw_irq.h              |    1 +
 arch/x86/include/asm/irq_vectors.h         |    5 +
 arch/x86/include/asm/kvm_host.h            |   26 +-
 arch/x86/include/asm/vmx.h                 |   18 +
 arch/x86/include/uapi/asm/kvm.h            |    1 -
 arch/x86/include/uapi/asm/msr-index.h      |    2 +
 arch/x86/include/uapi/asm/vmx.h            |    5 +-
 arch/x86/kernel/entry_64.S                 |    5 +
 arch/x86/kernel/irq.c                      |   22 +
 arch/x86/kernel/irqinit.c                  |    4 +
 arch/x86/kernel/kvmclock.c                 |    9 +-
 arch/x86/kvm/Kconfig                       |   14 +-
 arch/x86/kvm/Makefile                      |    5 +-
 arch/x86/kvm/emulate.c                     |   31 +-
 arch/x86/kvm/i8254.c                       |    4 +-
 arch/x86/kvm/lapic.c                       |  189 +--
 arch/x86/kvm/lapic.h                       |   22 +-
 arch/x86/kvm/mmu.c                         |  108 +-
 arch/x86/kvm/mmu.h                         |   11 +-
 arch/x86/kvm/paging_tmpl.h                 |    2 +-
 arch/x86/kvm/pmu.c                         |   14 +-
 arch/x86/kvm/svm.c                         |   40 +-
 arch/x86/kvm/vmx.c                         | 1077 ++++++++++++----
 arch/x86/kvm/x86.c                         |  243 ++--
 drivers/s390/kvm/kvm_virtio.c              |   11 +-
 drivers/s390/kvm/virtio_ccw.c              |   21 +-
 include/linux/kvm_host.h                   |  166 ++-
 include/trace/events/kvm.h                 |   12 +-
 include/uapi/linux/kvm.h                   |   45 +-
 virt/kvm/Kconfig                           |    3 +
 virt/kvm/assigned-dev.c                    |   43 +-
 virt/kvm/eventfd.c                         |   53 +-
 virt/kvm/ioapic.c                          |  163 ++-
 virt/kvm/ioapic.h                          |   27 +-
 virt/kvm/irq_comm.c                        |  215 +---
 virt/kvm/irqchip.c                         |  237 ++++
 virt/kvm/kvm_main.c                        |  258 +++-
 126 files changed, 9158 insertions(+), 2680 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/README
 create mode 100644 Documentation/virtual/kvm/devices/mpic.txt
 create mode 100644 Documentation/virtual/kvm/devices/xics.txt
 create mode 100644 arch/arm/kvm/handle_exit.c
 create mode 100644 arch/arm/kvm/perf.c
 create mode 100644 arch/powerpc/kvm/book3s_hv_rm_xics.c
 create mode 100644 arch/powerpc/kvm/book3s_rtas.c
 create mode 100644 arch/powerpc/kvm/book3s_xics.c
 create mode 100644 arch/powerpc/kvm/book3s_xics.h
 create mode 100644 arch/powerpc/kvm/irq.h
 create mode 100644 arch/powerpc/kvm/mpic.c
 create mode 100644 arch/s390/include/uapi/asm/virtio-ccw.h
 create mode 100644 virt/kvm/irqchip.c
--
			Gleb.
