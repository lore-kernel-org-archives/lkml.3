Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaAVOgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:36:13 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:61385 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaAVOgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:36:10 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First round of KVM updates for 3.14
Date: Wed, 22 Jan 2014 15:35:59 +0100
Message-Id: <1390401359-22040-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 7650b6870930055426abb32cc47d164ccdea49db:

  Merge branch 'kvm-urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-queue (2014-01-20 13:00:02 +0100)

----------------------------------------------------------------

First round of KVM updates for 3.14; PPC parts will come next week.
Nothing major here, just bugfixes all over the place.  The most
interesting part is the ARM guys' virtualized interrupt controller
overhaul, which lets userspace get/set the state and thus enables
migration of ARM VMs.

----------------------------------------------------------------
Andre Przywara (1):
      ARM/KVM: save and restore generic timer registers

Anup Patel (4):
      KVM: Documentation: Fix typo for KVM_ARM_VCPU_INIT ioctl
      arm64: KVM: Add Kconfig option for max VCPUs per-Guest
      arm64: KVM: Support X-Gene guest VCPU on APM X-Gene host
      arm64: KVM: Force undefined exception for Guest SMC intructions

Chen Fan (1):
      KVM: x86: Fix debug typo error in lapic

Christian Borntraeger (1):
      KVM: s390: Fix memory access error detection

Christoffer Dall (12):
      arm: KVM: Don't return PSCI_INVAL if waitqueue is inactive
      arm/arm64: KVM: arch_timer: Initialize cntvoff at kvm_init
      ARM: KVM: Allow creating the VGIC after VCPUs
      KVM: arm-vgic: Support KVM_CREATE_DEVICE for VGIC
      KVM: arm-vgic: Set base addr through device API
      irqchip: arm-gic: Define additional MMIO offsets and masks
      KVM: arm-vgic: Make vgic mmio functions more generic
      arm/arm64: kvm: Set vcpu->cpu to -1 on vcpu_put
      KVM: arm-vgic: Add vgic reg access from dev attr
      KVM: arm-vgic: Support unqueueing of LRs to the dist
      KVM: arm-vgic: Add GICD_SPENDSGIR and GICD_CPENDSGIR handlers
      KVM: arm-vgic: Support CPU interface reg access

Cornelia Huck (1):
      KVM: s390: diagnose call documentation

Dominik Dingel (1):
      KVM: s390: ioeventfd: ignore leftmost bits

Gleb Natapov (2):
      KVM: Change maintainer email address
      KVM: VMX: shadow VM_(ENTRY|EXIT)_CONTROLS vmcs field

Heiko Carstens (1):
      KVM: s390: fix diagnose code extraction

Jan Kiszka (12):
      KVM: nVMX: Add support for activity state HLT
      KVM: nVMX: Support direct APIC access from L2
      KVM: VMX: Do not skip the instruction if handle_dr injects a fault
      KVM: x86: Sync DR7 on KVM_SET_DEBUGREGS
      KVM: SVM: Fix reading of DR6
      KVM: VMX: Fix DR6 update on #DB exception
      KVM: nVMX: Leave VMX mode on clearing of feature control MSR
      KVM: nVMX: Pass vmexit parameters to nested_vmx_vmexit
      KVM: nVMX: Add tracepoints for nested_vmexit and nested_vmexit_inject
      KVM: nVMX: Clean up handling of VMX-related MSRs
      KVM: nVMX: Fix nested_run_pending on activity state HLT
      KVM: nVMX: Update guest activity state field on L2 exits

Marc Zyngier (3):
      Merge tag 'vgic-migrate-for-marc' of git://git.linaro.org/people/christoffer.dall/linux-kvm-arm into kvm-arm64/next
      Merge branch 'kvm-arm64/for-3.14' into kvm-arm64/next
      arm/arm64: KVM: relax the requirements of VMA alignment for THP

Marcelo Tosatti (5):
      KVM: MMU: handle invalid root_hpa at __direct_map
      KVM: VMX: fix use after free of vmx->loaded_vmcs
      KVM: x86: handle invalid root_hpa everywhere
      KVM: x86: limit PIT timer frequency
      KVM: x86: fix tsc catchup issue with tsc scaling

Masanari Iida (1):
      KVM: doc: Fix typo in doc/virtual/kvm

Paolo Bonzini (6):
      Merge tag 'kvm-s390-20131128' of git://git.kernel.org/.../kvms390/linux into kvm-next
      Merge remote-tracking branch 'tip/x86/cpufeature' into kvm-next
      Merge tag 'kvm-s390-20131211' of git://git.kernel.org/.../kvms390/linux into kvm-next
      Merge tag 'kvm-arm-for-3.14' of git://git.linaro.org/people/christoffer.dall/linux-kvm-arm into kvm-queue
      KVM: remove useless write to vcpu->hv_clock.tsc_timestamp
      Merge branch 'kvm-urgent' of git://git.kernel.org/.../kvms390/linux into kvm-queue

Paul Bolle (1):
      kvm: vfio: silence GCC warning

Qiaowei Ren (2):
      x86, cpufeature: Define the Intel MPX feature flag
      x86, xsave: Support eager-only xsave features, add MPX support

Randy Dunlap (1):
      kvm: make KVM_MMU_AUDIT help text more readable

Sachin Kamat (1):
      KVM: ARM: Remove duplicate include

Santosh Shilimkar (1):
      arm/arm64: kvm: Use virt_to_idmap instead of virt_to_phys for idmap mappings

Scott Wood (1):
      kvm: Provide kvm_vcpu_eligible_for_directed_yield() stub

Stephen Hemminger (2):
      kvm: make local functions static
      kvm: remove dead code

Takuya Yoshikawa (2):
      KVM: Use cond_resched() directly and remove useless kvm_resched()
      KVM: x86: Add comment on vcpu_enter_guest()'s return value

Thomas Huth (12):
      KVM: s390: Removed SIE_INTERCEPT_UCONTROL
      KVM: s390: Removed VIRTIODESCSPACE
      KVM: s390: Fix access to CR6 in TPI handler
      KVM: s390: Do not set CC3 for EQBS and SQBS
      KVM: s390: Always store status during SIGP STOP_AND_STORE_STATUS
      KVM: s390: Fix clock comparator field for STORE STATUS
      KVM: s390: Add SIGP store-status-at-address order
      KVM: s390: Removed kvm_s390_inject_sigp_stop()
      KVM: s390: Use helper function to set CC in SIGP handler
      KVM: s390: Add the SIGP order CONDITIONAL EMERGENCY SIGNAL
      KVM: s390: Reworked SIGP RESTART order
      KVM: s390: SIGP START has to report BUSY while stopping a CPU

Vadim Rozenfeld (1):
      add support for Hyper-V reference time counter

Zhihui Zhang (1):
      KVM: VMX: check use I/O bitmap first before unconditional I/O exit

 Documentation/virtual/kvm/api.txt              |  13 +-
 Documentation/virtual/kvm/devices/arm-vgic.txt |  73 ++++
 Documentation/virtual/kvm/hypercalls.txt       |   5 +-
 Documentation/virtual/kvm/locking.txt          |   4 +-
 Documentation/virtual/kvm/ppc-pv.txt           |   2 +-
 Documentation/virtual/kvm/s390-diag.txt        |  80 ++++
 Documentation/virtual/kvm/timekeeping.txt      |   2 +-
 MAINTAINERS                                    |   2 +-
 arch/arm/include/asm/kvm_host.h                |   3 +
 arch/arm/include/asm/kvm_mmu.h                 |   1 +
 arch/arm/include/uapi/asm/kvm.h                |  28 ++
 arch/arm/kvm/arm.c                             |  49 ++-
 arch/arm/kvm/guest.c                           |  92 +++-
 arch/arm/kvm/handle_exit.c                     |   2 -
 arch/arm/kvm/mmu.c                             |  24 +-
 arch/arm/kvm/psci.c                            |  11 +-
 arch/arm64/include/asm/kvm_host.h              |   7 +-
 arch/arm64/include/asm/kvm_mmu.h               |   1 +
 arch/arm64/include/uapi/asm/kvm.h              |  21 +-
 arch/arm64/kvm/Kconfig                         |  11 +
 arch/arm64/kvm/guest.c                         |  32 +-
 arch/arm64/kvm/handle_exit.c                   |   3 -
 arch/arm64/kvm/sys_regs_generic_v8.c           |   3 +
 arch/ia64/kvm/kvm-ia64.c                       |   2 +-
 arch/powerpc/kvm/book3s_hv.c                   |   2 +-
 arch/s390/include/asm/sigp.h                   |   2 +
 arch/s390/kvm/diag.c                           |   4 +-
 arch/s390/kvm/kvm-s390.c                       |  55 ++-
 arch/s390/kvm/kvm-s390.h                       |  10 +-
 arch/s390/kvm/priv.c                           |   4 +-
 arch/s390/kvm/sigp.c                           | 120 ++++-
 arch/s390/kvm/trace.h                          |   1 +
 arch/x86/include/asm/cpufeature.h              |   1 +
 arch/x86/include/asm/kvm_host.h                |   3 +
 arch/x86/include/asm/processor.h               |  23 +
 arch/x86/include/asm/vmx.h                     |   1 +
 arch/x86/include/asm/xsave.h                   |  14 +-
 arch/x86/include/uapi/asm/hyperv.h             |  13 +
 arch/x86/include/uapi/asm/msr-index.h          |   1 +
 arch/x86/kernel/xsave.c                        |  10 +
 arch/x86/kvm/Kconfig                           |   2 +-
 arch/x86/kvm/i8254.c                           |  18 +
 arch/x86/kvm/lapic.c                           |   9 +-
 arch/x86/kvm/mmu.c                             |  12 +
 arch/x86/kvm/paging_tmpl.h                     |   8 +
 arch/x86/kvm/svm.c                             |  15 +
 arch/x86/kvm/vmx.c                             | 323 +++++++++-----
 arch/x86/kvm/x86.c                             | 101 +++--
 arch/x86/kvm/x86.h                             |   2 +
 include/kvm/arm_vgic.h                         |   2 +-
 include/linux/irqchip/arm-gic.h                |  12 +
 include/linux/kvm_host.h                       |  20 +-
 include/uapi/linux/kvm.h                       |   2 +
 virt/kvm/arm/arch_timer.c                      |  34 ++
 virt/kvm/arm/vgic.c                            | 584 +++++++++++++++++++++++--
 virt/kvm/ioapic.c                              |   2 +-
 virt/kvm/ioapic.h                              |   1 -
 virt/kvm/kvm_main.c                            |  81 ++--
 virt/kvm/vfio.c                                |   6 +-
 59 files changed, 1559 insertions(+), 410 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/arm-vgic.txt
 create mode 100644 Documentation/virtual/kvm/s390-diag.txt
