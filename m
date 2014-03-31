Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaCaIbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:31:06 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61166 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaCaIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:31:00 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.15 merge window
Date: Mon, 31 Mar 2014 10:30:46 +0200
Message-Id: <1396254646-14971-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.15-1

for you to fetch changes up to 7227fc0666606b0df2c0d2966a7f4859b01bdf74:

  Merge branch 'kvm-ppchv-next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into kvm-next (2014-03-29 15:44:05 +0100)

No other changes expected for this merge window.

Paolo

----------------------------------------------------------------

PPC and ARM do not have much going on this time.  Most of the cool stuff,
instead, is in s390 and (after a few releases) x86.

ARM has some caching fixes and PPC has transactional memory support
in guests.  MIPS has some fixes, with more probably coming in 3.16 as
QEMU will soon get support for MIPS KVM.

For x86 there are optimizations for debug registers, which trigger on
some Windows games, and other important fixes for Windows guests.  We now
expose to the guest Broadwell instruction set extensions and also Intel
MPX.  There's also a fix/workaround for OS X guests, nested virtualization
features (preemption timer), and a couple kvmclock refinements.

For s390, the main news is asynchronous page faults, together with
improvements to IRQs (floating irqs and adapter irqs) that speed up
virtio devices.

----------------------------------------------------------------
Andrew Honig (1):
      kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Andrew Jones (2):
      x86: kvm: rate-limit global clock updates
      x86: kvm: introduce periodic global clock updates

Anton Blanchard (1):
      KVM: PPC: Book3S HV: Fix KVM hang with CONFIG_KVM_XICS=n

Christian Borntraeger (4):
      KVM: s390: Provide access to program parameter
      KVM: s390: expose gbea register to userspace
      KVM: s390: Optimize ucontrol path
      KVM: s390: randomize sca address

Christoffer Dall (1):
      KVM: Specify byte order for KVM_EXIT_MMIO

Cornelia Huck (6):
      virtio-ccw: virtio-ccw adapter interrupt support.
      KVM: eventfd: Fix lock order inversion.
      KVM: Add per-vm capability enablement.
      KVM: s390: adapter interrupt sources
      KVM: s390: irq routing for adapter interrupts.
      KVM: Bump KVM_MAX_IRQ_ROUTES for s390

Dominik Dingel (7):
      KVM: s390: Add FAULT_FLAG_RETRY_NOWAIT for guest fault
      KVM: async_pf: Provide additional direct page notification
      KVM: async_pf: Allow to wait for outstanding work
      KVM: async_pf: Async page fault support on s390
      KVM: async_pf: Exploit one reg interface for pfault
      KVM: async_pf: Add missing call for async page present
      KVM: s390: Removing untriggerable BUG_ONs

Fernando Luis Vázquez Cao (1):
      kvm: remove redundant registration of BSP's hv_clock area

Gabriel L. Somlo (1):
      kvm: x86: ignore ioapic polarity

Greg Kurz (1):
      KVM: PPC: Book3S HV: Fix incorrect userspace exit on ioeventfd write

Heinz Graalfs (2):
      virtio_ccw: fix vcdev pointer handling issues
      virtio_ccw: fix hang in set offline processing

Igor Mammedov (2):
      KVM: x86 emulator: emulate MOVAPS
      KVM: x86 emulator: emulate MOVAPD

James Hogan (4):
      MIPS: KVM: asm/kvm_host.h: Clean up whitespace
      MIPS: KVM: Pass reserved instruction exceptions to guest
      MIPS: KVM: Consult HWREna before emulating RDHWR
      MIPS: KVM: Remove dead code in CP0 emulation

Jan Kiszka (4):
      KVM: nVMX: Rework interception of IRQs and NMIs
      KVM: nVMX: Fully emulate preemption timer
      KVM: nVMX: Do not inject NMI vmexits when L2 has a pending interrupt
      KVM: x86: Remove return code from enable_irq/nmi_window

Jens Freimann (7):
      KVM: s390: add and extend interrupt information data structs
      KVM: s390: add floating irq controller
      KVM: s390: limit floating irqs
      KVM: s390: Simplify online vcpus counting for stsi
      KVM: s390: get rid of local_int array
      KVM: s390: fix calculation of idle_mask array size
      KVM: s390: clear local interrupts at cpu initial reset

Laurent Dufour (1):
      KVM: PPC: Book3S: Introduce hypervisor call H_GET_TCE

Liu, Jinsong (6):
      KVM: x86: expose new instruction RDSEED to guest
      KVM: x86: expose ADX feature to guest
      KVM: x86: Fix xsave cpuid exposing bug
      KVM: x86: Intel MPX vmx and msr handle
      KVM: x86: add MSR_IA32_BNDCFGS to msrs_to_save
      KVM: x86: Enable Intel MPX for guest

Marc Zyngier (13):
      arm/arm64: KVM: detect CPU reset on CPU_PM_EXIT
      arm64: KVM: force cache clean on page fault when caches are off
      arm64: KVM: allows discrimination of AArch32 sysreg access
      arm64: KVM: trap VM system registers until MMU and caches are ON
      ARM: KVM: introduce kvm_p*d_addr_end
      arm64: KVM: flush VM pages before letting the guest enable caches
      ARM: KVM: force cache clean on page fault when caches are off
      ARM: KVM: fix handling of trapped 64bit coprocessor accesses
      ARM: KVM: fix ordering of 64bit coprocessor accesses
      ARM: KVM: introduce per-vcpu HYP Configuration Register
      ARM: KVM: add world-switch for AMAIR{0,1}
      ARM: KVM: trap VM system registers until MMU and caches are ON
      ARM: KVM: fix warning in mmu.c

Marcelo Tosatti (3):
      KVM: x86: remove unused last_kernel_ns variable
      KVM: x86: emulator_cmpxchg_emulated should mark_page_dirty
      KVM: MMU: drop read-only large sptes when creating lower level sptes

Martin Schwidefsky (1):
      s390/airq: add support for irq ranges

Michael Mueller (3):
      KVM: s390: implementation of kvm_arch_vcpu_runnable()
      KVM: add kvm_arch_vcpu_runnable() test to kvm_vcpu_on_spin() loop
      KVM/s390: Set preempted flag during vcpu wakeup and interrupt delivery

Michael Neuling (2):
      KVM: PPC: Book3S HV: Add transactional memory support
      KVM: PPC: Book3S HV: Add get/set_one_reg for new TM state

Paolo Bonzini (27):
      Merge tag 'kvm-s390-20140130' of git://git.kernel.org/.../kvms390/linux into HEAD
      Merge branch 'kvm-master' into kvm-queue
      kvm, vmx: Really fix lazy FPU on nested guest
      kvm, vmx: Really fix lazy FPU on nested guest
      Merge tag 'kvm-s390-20140304' of git://git.kernel.org/.../kvms390/linux into kvm-next
      Merge tag 'kvm-for-3.15-1' of git://git.kernel.org/.../maz/arm-platforms into kvm-next
      Merge tag 'kvm-s390-20140306' of git://git.kernel.org/.../kvms390/linux into kvm-next
      KVM: vmx: we do rely on loading DR7 on entry
      KVM: x86: change vcpu->arch.switch_db_regs to a bit mask
      KVM: x86: Allow the guest to run with dirty debug registers
      KVM: vmx: Allow the guest to run with dirty debug registers
      KVM: nVMX: Allow nested guests to run with dirty debug registers
      KVM: svm: set/clear all DR intercepts in one swoop
      KVM: svm: Allow the guest to run with dirty debug registers
      Merge branch 'kvm-ppc-fix' into HEAD
      Merge tag 'kvm-s390-20140317' of git://git.kernel.org/.../kvms390/linux into HEAD
      KVM: x86: introduce kvm_supported_xcr0()
      KVM: x86: Add nested virtualization support for MPX
      KVM: x86: handle missing MPX in nested virtualization
      KVM: ioapic: merge ioapic_deliver into ioapic_service
      KVM: ioapic: clear IRR for edge-triggered interrupts at delivery
      KVM: ioapic: extract body of kvm_ioapic_set_irq
      KVM: ioapic: reinject pending interrupts on KVM_SET_IRQCHIP
      Merge branch 'kvms390-irqfd' of git://git.kernel.org/.../kvms390/linux into kvm-next
      Merge tag 'kvm-s390-20140325' of git://git.kernel.org/.../kvms390/linux into kvm-next
      KVM: vmx: fix MPX detection
      Merge branch 'kvm-ppchv-next' of git://git.kernel.org/.../paulus/powerpc into kvm-next

Paul Mackerras (7):
      KVM: PPC: Book3S HV: Remove bogus duplicate code
      KVM: PPC: Book3S HV: Fix register usage when loading/saving VRSAVE
      KVM: PPC: Book3S: Trim top 4 bits of physical address in RTAS code
      KVM: PPC: Book3S HV: Return ENODEV error rather than EIO
      KVM: PPC: Book3S HV: Don't use kvm_memslots() in real mode
      KVM: PPC: Book3S HV: Fix decrementer timeouts with non-zero TB offset
      KVM: PPC: Book3S HV: Save/restore host PMU registers that are new in POWER8

Radim Krčmář (1):
      KVM: SVM: fix NMI window after iret

Takuya Yoshikawa (2):
      KVM: Simplify kvm->tlbs_dirty handling
      KVM: x86: Break kvm_for_each_vcpu loop after finding the VP_INDEX

Thomas Huth (2):
      KVM: s390: Fixed CC of SIGP SET_PREFIX handler
      KVM: s390: Fix possible memory leak in SIGP functions

 Documentation/virtual/kvm/api.txt               |  47 +-
 Documentation/virtual/kvm/devices/s390_flic.txt |  91 +++
 arch/arm/include/asm/kvm_arm.h                  |   4 +-
 arch/arm/include/asm/kvm_asm.h                  |   4 +-
 arch/arm/include/asm/kvm_host.h                 |   9 +-
 arch/arm/include/asm/kvm_mmu.h                  |  30 +-
 arch/arm/kernel/asm-offsets.c                   |   1 +
 arch/arm/kvm/arm.c                              |   3 +-
 arch/arm/kvm/coproc.c                           |  84 ++-
 arch/arm/kvm/coproc.h                           |  14 +-
 arch/arm/kvm/coproc_a15.c                       |   2 +-
 arch/arm/kvm/coproc_a7.c                        |   2 +-
 arch/arm/kvm/guest.c                            |   1 +
 arch/arm/kvm/interrupts.S                       |  11 +-
 arch/arm/kvm/interrupts_head.S                  |  21 +-
 arch/arm/kvm/mmu.c                              | 110 +++-
 arch/arm64/include/asm/kvm_arm.h                |   3 +-
 arch/arm64/include/asm/kvm_asm.h                |   3 +-
 arch/arm64/include/asm/kvm_mmu.h                |  22 +-
 arch/arm64/kvm/hyp.S                            |  27 +-
 arch/arm64/kvm/sys_regs.c                       |  99 +++-
 arch/arm64/kvm/sys_regs.h                       |   2 +
 arch/ia64/kvm/kvm-ia64.c                        |   1 +
 arch/mips/include/asm/kvm_host.h                | 417 +++++++-------
 arch/mips/kvm/kvm_mips_emul.c                   |  40 +-
 arch/powerpc/include/asm/kvm_book3s.h           |   5 +
 arch/powerpc/include/asm/kvm_book3s_64.h        |  12 +
 arch/powerpc/include/asm/kvm_book3s_asm.h       |   2 +-
 arch/powerpc/include/asm/kvm_ppc.h              |   2 +
 arch/powerpc/include/asm/reg.h                  |   1 +
 arch/powerpc/include/asm/tm.h                   |   4 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c             |   9 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c             |  28 +
 arch/powerpc/kvm/book3s_hv.c                    | 159 +++++-
 arch/powerpc/kvm/book3s_hv_interrupts.S         |  22 +
 arch/powerpc/kvm/book3s_hv_rm_mmu.c             |   6 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S         | 258 +++++----
 arch/powerpc/kvm/book3s_rtas.c                  |   7 +-
 arch/s390/include/asm/airq.h                    |  14 +-
 arch/s390/include/asm/irq.h                     |   1 +
 arch/s390/include/asm/kvm_host.h                |  98 ++--
 arch/s390/include/asm/pgtable.h                 |   2 +
 arch/s390/include/asm/processor.h               |   1 +
 arch/s390/include/uapi/asm/kvm.h                |  43 ++
 arch/s390/kernel/irq.c                          |   1 +
 arch/s390/kvm/Kconfig                           |   4 +
 arch/s390/kvm/Makefile                          |   2 +-
 arch/s390/kvm/diag.c                            |  84 +++
 arch/s390/kvm/interrupt.c                       | 704 +++++++++++++++++++++---
 arch/s390/kvm/irq.h                             |  22 +
 arch/s390/kvm/kvm-s390.c                        | 212 ++++++-
 arch/s390/kvm/kvm-s390.h                        |   7 +
 arch/s390/kvm/priv.c                            |   7 +-
 arch/s390/kvm/sigp.c                            | 157 +++---
 arch/s390/kvm/trace.h                           |  46 ++
 arch/s390/mm/fault.c                            |  26 +-
 arch/x86/include/asm/kvm_host.h                 |  18 +-
 arch/x86/include/asm/vmx.h                      |   4 +
 arch/x86/include/asm/xsave.h                    |   2 +
 arch/x86/include/uapi/asm/msr-index.h           |   1 +
 arch/x86/kernel/kvm.c                           |   1 -
 arch/x86/kernel/kvmclock.c                      |   2 +-
 arch/x86/kvm/cpuid.c                            |  37 +-
 arch/x86/kvm/emulate.c                          |   8 +-
 arch/x86/kvm/mmu.c                              |   3 +-
 arch/x86/kvm/paging_tmpl.h                      |   7 +-
 arch/x86/kvm/svm.c                              |  84 ++-
 arch/x86/kvm/vmx.c                              | 336 +++++++----
 arch/x86/kvm/x86.c                              | 147 ++++-
 arch/x86/kvm/x86.h                              |   5 +-
 drivers/s390/cio/airq.c                         |  66 ++-
 drivers/s390/kvm/virtio_ccw.c                   | 323 ++++++++++-
 include/linux/kvm_host.h                        |  20 +-
 include/uapi/linux/kvm.h                        |  83 +++
 virt/kvm/Kconfig                                |   4 +
 virt/kvm/async_pf.c                             |  27 +-
 virt/kvm/eventfd.c                              |   8 +-
 virt/kvm/ioapic.c                               | 108 ++--
 virt/kvm/kvm_main.c                             |  12 +-
 79 files changed, 3360 insertions(+), 940 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/s390_flic.txt
 create mode 100644 arch/s390/kvm/irq.h
