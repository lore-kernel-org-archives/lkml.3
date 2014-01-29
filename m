Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaA2SJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:09:53 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59016 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaA2SJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:09:51 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second round of KVM updates for 3.14
Date: Wed, 29 Jan 2014 19:09:41 +0100
Message-Id: <1391018981-7793-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 0dc3fd0249a295863900984e02dd4bb89204205b:

  Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2014-01-22 22:30:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to b73117c49364551ff789db7c424a115ac5b77850:

  Merge branch 'kvm-ppc-next' of git://github.com/agraf/linux-2.6 into kvm-queue (2014-01-29 18:29:01 +0100)

----------------------------------------------------------------

Second batch of KVM updates.  Some minor x86 fixes,
two s390 guest features that need some handling in the host,
and all the PPC changes.  The PPC changes include support for
little-endian guests and enablement for new POWER8 features.

----------------------------------------------------------------
Alexander Graf (2):
      KVM: PPC: Add devname:kvm aliases for modules
      KVM: PPC: Unify kvmppc_get_last_inst and sc

Andreas Schwab (1):
      KVM: PPC: Book3S HV: use xics_wake_cpu only when defined

Anton Blanchard (1):
      KVM: PPC: Book3S HV: Basic little-endian guest support

Bharat Bhushan (6):
      kvm/powerpc: rename kvm_hypercall() to epapr_hypercall()
      kvm/powerpc: move kvm_hypercall0() and friends to epapr_hypercall0()
      kvm: booke: clear host tlb reference flag on guest tlb invalidation
      kvm: book3s: rename lookup_linux_pte() to lookup_linux_pte_and_update()
      kvm: powerpc: define a linux pte lookup function
      kvm: powerpc: use caching attributes as per linux pte

Cornelia Huck (1):
      KVM: s390: virtio-ccw: Handle command rejects.

Cédric Le Goater (1):
      KVM: PPC: Book3S: MMIO emulation support for little endian guests

Gleb Natapov (1):
      KVM: PPC: fix couple of memory leaks in MPIC/XICS devices

Jan Kiszka (1):
      KVM: x86: Validate guest writes to MSR_IA32_APICBASE

Liu Ping Fan (1):
      powerpc: kvm: optimize "sc 1" as fast return

Michael Ellerman (1):
      KVM: PPC: Book3S HV: Add handler for HV facility unavailable

Michael Mueller (1):
      KVM: s390: enable Transactional Execution

Michael Neuling (5):
      KVM: PPC: Book3S HV: Don't set DABR on POWER8
      KVM: PPC: Book3S HV: Context-switch new POWER8 SPRs
      powerpc/Kconfig: Make TM select VSX and VMX
      KVM: PPC: Book3S HV: Add new state for transactional memory
      KVM: PPC: Book3S HV: Add software abort codes for transactional memory

Mihai Caraman (1):
      KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()

Paolo Bonzini (5):
      Merge tag 'kvm-s390-20140117' of git://git.kernel.org/.../kvms390/linux into kvm-queue
      kvm: x86: move KVM_CAP_HYPERV_TIME outside #ifdef
      x86, kvm: cache the base of the KVM cpuid leaves
      x86, kvm: correctly access the KVM_CPUID_FEATURES leaf at 0x40000101
      Merge branch 'kvm-ppc-next' of git://github.com/agraf/linux-2.6 into kvm-queue

Paul Mackerras (13):
      KVM: PPC: Use load_fp/vr_state rather than load_up_fpu/altivec
      KVM: PPC: Store FP/VSX/VMX state in thread_fp/vr_state structures
      KVM: PPC: Load/save FP/VMX/VSX state directly to/from vcpu struct
      KVM: PPC: Book3S HV: Use load/store_fp_state functions in HV guest entry/exit
      KVM: PPC: Book3S HV: Align physical and virtual CPU thread numbers
      KVM: PPC: Book3S HV: Flush the correct number of TLB sets on POWER8
      KVM: PPC: Book3S HV: Implement architecture compatibility modes for POWER8
      KVM: PPC: Book3S HV: Consolidate code that checks reason for wake from nap
      KVM: PPC: Book3S HV: Handle guest using doorbells for IPIs
      KVM: PPC: Book3S HV: Handle new LPCR bits on POWER8
      KVM: PPC: Book3S HV: Prepare for host using hypervisor doorbells
      KVM: PPC: Book3S HV: Add support for DABRX register on POWER7
      KVM: PPC: Book3S PR: Cope with doorbell interrupts

Scott Wood (1):
      kvm/ppc: IRQ disabling cleanup

Thomas Huth (1):
      KVM: s390: Enable the LPP facility for guests

Tiejun Chen (1):
      KVM: PPC: Book3E HV: call RECONCILE_IRQ_STATE to sync the software state

Vadim Rozenfeld (2):
      KVM: x86: mark hyper-v hypercall page as dirty
      KVM: x86: mark hyper-v vapic assist page as dirty

Zhouyi Zhou (1):
      KVM: PPC: NULL return of kvmppc_mmu_hpte_cache_next should be handled

 Documentation/virtual/kvm/api.txt         |    1 +
 arch/powerpc/Kconfig                      |    2 +
 arch/powerpc/include/asm/epapr_hcalls.h   |  111 +++
 arch/powerpc/include/asm/kvm_asm.h        |    3 +
 arch/powerpc/include/asm/kvm_book3s.h     |   27 +-
 arch/powerpc/include/asm/kvm_book3s_asm.h |    1 +
 arch/powerpc/include/asm/kvm_booke.h      |    6 +
 arch/powerpc/include/asm/kvm_host.h       |   61 +-
 arch/powerpc/include/asm/kvm_para.h       |   80 +-
 arch/powerpc/include/asm/kvm_ppc.h        |   13 +-
 arch/powerpc/include/asm/pgtable.h        |   21 +
 arch/powerpc/include/asm/reg.h            |   43 +-
 arch/powerpc/include/asm/switch_to.h      |    2 -
 arch/powerpc/include/uapi/asm/kvm.h       |    3 +
 arch/powerpc/include/uapi/asm/tm.h        |    2 +
 arch/powerpc/kernel/asm-offsets.c         |   50 +-
 arch/powerpc/kernel/kvm.c                 |   41 +-
 arch/powerpc/kvm/44x.c                    |    4 +
 arch/powerpc/kvm/book3s.c                 |   46 +-
 arch/powerpc/kvm/book3s_32_mmu_host.c     |    5 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c       |    4 +-
 arch/powerpc/kvm/book3s_exports.c         |    4 -
 arch/powerpc/kvm/book3s_hv.c              |  319 ++++++--
 arch/powerpc/kvm/book3s_hv_interrupts.S   |    8 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c       |    8 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 1213 ++++++++++++++++++-----------
 arch/powerpc/kvm/book3s_paired_singles.c  |  169 ++--
 arch/powerpc/kvm/book3s_pr.c              |  155 +---
 arch/powerpc/kvm/book3s_rmhandlers.S      |   47 --
 arch/powerpc/kvm/book3s_segment.S         |    2 +
 arch/powerpc/kvm/book3s_xics.c            |    4 +-
 arch/powerpc/kvm/booke.c                  |   44 +-
 arch/powerpc/kvm/booke.h                  |    5 +-
 arch/powerpc/kvm/bookehv_interrupts.S     |   11 +
 arch/powerpc/kvm/e500.c                   |    4 +
 arch/powerpc/kvm/e500.h                   |    8 +-
 arch/powerpc/kvm/e500_mmu.c               |    2 +-
 arch/powerpc/kvm/e500_mmu_host.c          |   59 +-
 arch/powerpc/kvm/e500mc.c                 |    4 +
 arch/powerpc/kvm/emulate.c                |    1 -
 arch/powerpc/kvm/mpic.c                   |    1 +
 arch/powerpc/kvm/powerpc.c                |   58 +-
 arch/s390/include/asm/kvm_host.h          |   15 +-
 arch/s390/kvm/intercept.c                 |   11 +
 arch/s390/kvm/kvm-s390.c                  |   17 +-
 arch/s390/kvm/kvm-s390.h                  |    6 +
 arch/x86/include/asm/kvm_para.h           |   33 +-
 arch/x86/kernel/kvm.c                     |   32 +
 arch/x86/kvm/cpuid.h                      |    8 +
 arch/x86/kvm/lapic.h                      |    2 +-
 arch/x86/kvm/vmx.c                        |    9 +-
 arch/x86/kvm/x86.c                        |   41 +-
 drivers/s390/kvm/virtio_ccw.c             |   11 +-
 53 files changed, 1715 insertions(+), 1122 deletions(-)
