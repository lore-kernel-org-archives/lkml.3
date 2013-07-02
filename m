Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab3GBIPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:15:22 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54158 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3GBIPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:15:16 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        christoffer.dall@linaro.org, agraf@suse.de, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com
Subject: [GIT PULL] KVM changes for 3.11
Date: Tue,  2 Jul 2013 10:15:06 +0200
Message-Id: <1372752906-30135-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a3ff5fbc94a829680d4aa005cd17add1c1a1fb5b:

  KVM: PPC: Ignore PIR writes (2013-06-30 03:33:22 +0200)

----------------------------------------------------------------
KVM fixes for 3.11

On the x86 side, there are some optimizations and documentation updates.
The big ARM/KVM change for 3.11, support for AArch64, will come through
Catalin Marinas's tree.  s390 and PPC have misc cleanups and bugfixes.

There is a conflict due to "s390/pgtable: fix ipte notify bit" having
entered 3.10 through Martin Schwidefsky's s390 tree.  This pull request
has additional changes on top, so this tree's version is the correct one.

----------------------------------------------------------------
Alexander Graf (1):
      KVM: PPC: Ignore PIR writes

Alexey Kardashevskiy (1):
      kvm api doc: fix section numbers

Amos Kong (1):
      kvm: exclude ioeventfd from counting kvm_io_range limit

Anup Patel (1):
      ARM: KVM: Allow host virt timer irq to be different from guest timer virt irq

Arnd Bergmann (1):
      ARM: kvm: don't include drivers/virtio/Kconfig

Avi Kivity (8):
      KVM: x86 emulator: add support for writing back the source operand
      KVM: x86 emulator: decode extended accumulator explicity
      KVM: x86 emulator: switch MUL/DIV to DstXacc
      KVM: x86 emulator: Switch fastop src operand to RDX
      KVM: x86 emulator: convert single-operand MUL/IMUL to fastop
      KVM: x86 emulator: convert DIV/IDIV to fastop
      KVM: x86 emulator: drop unused old-style inline emulation
      KVM: x86 emulator: convert XADD to fastop

Christian Borntraeger (8):
      s390/pgtable: fix ipte notify bit
      s390/kvm: Mark if a cpu is in SIE
      s390/kvm: Provide a way to prevent reentering SIE
      s390/kvm: Kick guests out of sie if prefix page host pte is touched
      s390: fix gmap_ipte_notifier vs. software dirty pages
      KVM: s390: Provide function for setting the guest storage key
      KVM: s390: guest large pages
      KVM: s390: Use common waitqueue

Christoffer Dall (1):
      Update MAINTAINERS: KVM/ARM work now funded by Linaro

Cornelia Huck (1):
      KVM: s390: Add "devname:kvm" alias.

Dave P Martin (1):
      ARM: KVM: Don't handle PSCI calls via SMC

Geoff Levand (1):
      arm/kvm: Cleanup KVM_ARM_MAX_VCPUS logic

Gleb Natapov (4):
      KVM: MMU: clenaup locking in mmu_free_roots()
      KVM: MMU: reduce KVM_REQ_MMU_RELOAD when root page is zapped
      KVM: Fix RTC interrupt coalescing tracking
      Merge git://git.linaro.org/people/cdall/linux-kvm-arm.git tags/kvm-arm-3.11 into queue

Heinz Graalfs (1):
      KVM: s390,perf: Detect if perf samples belong to KVM host or guest

Jan Kiszka (1):
      KVM: x86: Remove support for reporting coalesced APIC IRQs

Marc Zyngier (9):
      ARM: KVM: move GIC/timer code to a common location
      KVM: get rid of $(addprefix ../../../virt/kvm/, ...) in Makefiles
      ARM: KVM: remove dead prototype for __kvm_tlb_flush_vmid
      ARM: KVM: use phys_addr_t instead of unsigned long long for HYP PGDs
      ARM: KVM: don't special case PC when doing an MMIO
      ARM: KVM: get rid of S2_PGD_SIZE
      ARM: KVM: perform save/restore of PAR
      ARM: KVM: add missing dsb before invalidating Stage-2 TLBs
      ARM: KVM: clear exclusive monitor on all exception returns

Marcelo Tosatti (2):
      KVM: x86: limit difference between kvmclock updates
      KVM: x86: handle idiv overflow at kvm_write_tsc

Martin Schwidefsky (3):
      s390/kvm: fix psw rewinding in handle_skey
      s390/kvm: rename RCP_xxx defines to PGSTE_xxx
      s390/kvm: avoid automatic sie reentry

Michael Mueller (1):
      KVM: s390: code cleanup to use common vcpu slab cache

Paul Mackerras (5):
      KVM: PPC: Book3S PR: Fix proto-VSID calculations
      KVM: PPC: Book3S PR: Fix invalidation of SLB entry 0 on guest entry
      KVM: PPC: Book3S PR: Don't keep scanning HPTEG after we find a match
      KVM: PPC: Book3S PR: Allow guest to use 1TB segments
      KVM: PPC: Book3S PR: Invalidate SLB entries properly

Takuya Yoshikawa (2):
      KVM: MMU: Use kvm_mmu_sync_roots() in kvm_mmu_load()
      KVM: MMU: Inform users of mmio generation wraparound

Thomas Huth (8):
      KVM: s390: Fix epsw instruction decoding
      KVM: s390: Renamed PGM_PRIVILEGED_OPERATION
      KVM: s390: Privileged operation check for TPROT
      KVM: s390: Privileged operation checks moved to instruction handlers
      KVM: s390: Check for PSTATE when handling DIAGNOSE
      KVM: s390: Check for access exceptions during TPI
      KVM: s390: Reworked LCTL and LCTLG instructions
      KVM: s390: Fixed priority of execution in STSI

Tiejun Chen (1):
      KVM: PPC: Guard doorbell exception with CONFIG_PPC_DOORBELL

Wei Yongjun (1):
      KVM: add missing misc_deregister() on error in kvm_init()

Xiao Guangrong (24):
      KVM: x86: drop calling kvm_mmu_zap_all in emulator_fix_hypercall
      KVM: MMU: drop unnecessary kvm_reload_remote_mmus
      KVM: MMU: fast invalidate all pages
      KVM: x86: use the fast way to invalidate all pages
      KVM: MMU: show mmu_valid_gen in shadow page related tracepoints
      KVM: MMU: add tracepoint for kvm_mmu_invalidate_all_pages
      KVM: MMU: do not reuse the obsolete page
      KVM: MMU: zap pages in batch
      KVM: MMU: collapse TLB flushes when zap all pages
      KVM: MMU: reclaim the zapped-obsolete page first
      KVM: MMU: update the documentation for reverse mapping of parent_pte
      KVM: MMU: retain more available bits on mmio spte
      KVM: MMU: store generation-number into mmio spte
      KVM: MMU: make return value of mmio page fault handler more readable
      KVM: MMU: fast invalidate all mmio sptes
      KVM: MMU: add tracepoint for check_mmio_spte
      KVM: MMU: init kvm generation close to mmio wrap-around value
      KVM: MMU: drop kvm_mmu_zap_mmio_sptes
      KVM: MMU: document clear_spte_count
      KVM: MMU: document write_flooding_count
      KVM: MMU: document mmio page fault
      KVM: MMU: document fast page fault
      KVM: MMU: document fast invalidate all pages
      KVM: MMU: document fast invalidate all mmio sptes

Yoshihiro YUNOMAE (1):
      kvm: Add a tracepoint write_tsc_offset

 Documentation/virtual/kvm/api.txt                  |   8 +-
 Documentation/virtual/kvm/mmu.txt                  |  91 ++++-
 MAINTAINERS                                        |   4 +-
 arch/arm/include/asm/kvm_arm.h                     |   1 -
 arch/arm/include/asm/kvm_asm.h                     |  24 +-
 arch/arm/include/asm/kvm_emulate.h                 |   5 -
 arch/arm/include/asm/kvm_host.h                    |  13 +-
 arch/arm/kvm/Kconfig                               |   8 +-
 arch/arm/kvm/Makefile                              |   7 +-
 arch/arm/kvm/arm.c                                 |   8 +-
 arch/arm/kvm/coproc.c                              |   4 +
 arch/arm/kvm/handle_exit.c                         |   3 -
 arch/arm/kvm/interrupts.S                          |  16 +-
 arch/arm/kvm/interrupts_head.S                     |  10 +-
 arch/arm/kvm/mmio.c                                |   6 -
 arch/arm/kvm/mmu.c                                 |   3 -
 arch/arm/kvm/psci.c                                |   2 +-
 arch/arm/kvm/reset.c                               |  12 +
 arch/ia64/kvm/Makefile                             |   7 +-
 arch/powerpc/include/asm/kvm_book3s.h              |   6 +-
 arch/powerpc/kvm/Makefile                          |  13 +-
 arch/powerpc/kvm/book3s_64_mmu.c                   |  81 +++--
 arch/powerpc/kvm/book3s_64_mmu_host.c              |  21 +-
 arch/powerpc/kvm/book3s_64_slb.S                   |  13 +-
 arch/powerpc/kvm/book3s_pr.c                       |   3 +-
 arch/powerpc/kvm/booke.c                           |   2 +-
 arch/powerpc/kvm/emulate.c                         |   3 +
 arch/s390/include/asm/kvm_host.h                   |  18 +-
 arch/s390/include/asm/perf_event.h                 |  10 +
 arch/s390/include/asm/pgalloc.h                    |   3 +
 arch/s390/include/asm/pgtable.h                    |  83 +++--
 arch/s390/kernel/asm-offsets.c                     |   3 +
 arch/s390/kernel/entry64.S                         |  81 ++---
 arch/s390/kernel/perf_event.c                      |  52 +++
 arch/s390/kernel/s390_ksyms.c                      |   1 +
 arch/s390/kvm/Makefile                             |   3 +-
 arch/s390/kvm/diag.c                               |   3 +
 arch/s390/kvm/intercept.c                          | 124 +------
 arch/s390/kvm/interrupt.c                          |  18 +-
 arch/s390/kvm/kvm-s390.c                           | 105 +++++-
 arch/s390/kvm/kvm-s390.h                           |  14 +-
 arch/s390/kvm/priv.c                               | 274 ++++++++++++---
 arch/s390/kvm/sigp.c                               |  19 +-
 arch/s390/mm/pgtable.c                             |  53 ++-
 arch/x86/include/asm/kvm_host.h                    |  15 +-
 arch/x86/kvm/Makefile                              |  13 +-
 arch/x86/kvm/emulate.c                             | 391 ++++++---------------
 arch/x86/kvm/lapic.c                               |   4 +-
 arch/x86/kvm/mmu.c                                 | 301 +++++++++++++---
 arch/x86/kvm/mmu.h                                 |  18 +
 arch/x86/kvm/mmutrace.h                            |  76 +++-
 arch/x86/kvm/paging_tmpl.h                         |  10 +-
 arch/x86/kvm/svm.c                                 |  10 +-
 arch/x86/kvm/trace.h                               |  21 ++
 arch/x86/kvm/vmx.c                                 |  19 +-
 arch/x86/kvm/x86.c                                 |  80 +++--
 .../kvm/arm_arch_timer.h                           |   4 +
 .../asm/kvm_vgic.h => include/kvm/arm_vgic.h       |   0
 include/linux/kvm_host.h                           |   4 +-
 {arch/arm/kvm => virt/kvm/arm}/arch_timer.c        |  33 +-
 {arch/arm/kvm => virt/kvm/arm}/vgic.c              |   0
 virt/kvm/eventfd.c                                 |   2 +
 virt/kvm/kvm_main.c                                |   4 +-
 63 files changed, 1434 insertions(+), 809 deletions(-)
 rename arch/arm/include/asm/kvm_arch_timer.h => include/kvm/arm_arch_timer.h (92%)
 rename arch/arm/include/asm/kvm_vgic.h => include/kvm/arm_vgic.h (100%)
 rename {arch/arm/kvm => virt/kvm/arm}/arch_timer.c (90%)
 rename {arch/arm/kvm => virt/kvm/arm}/vgic.c (100%)
