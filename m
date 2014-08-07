Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaHGKGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:06:36 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39841 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426AbaHGKGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:06:33 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: gleb@kernel.org, kvm@vger.kernel.org, christoffer.dall@linaro.org,
        agraf@suse.de
Subject: [GIT PULL] Second round of KVM changes for 3.17
Date: Thu,  7 Aug 2014 12:06:16 +0200
Message-Id: <1407405976-22122-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 5167d09ffad5b16b574d35ce3047ed34caf1e837:

  Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2014-08-04 12:31:53 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c77dcacb397519b6ade8f08201a4a90a7f4f751e:

  KVM: Move more code under CONFIG_HAVE_KVM_IRQFD (2014-08-06 14:24:47 +0200)

----------------------------------------------------------------
Here are the PPC and ARM changes for KVM, which I separated because
they had small conflicts (respectively within KVM documentation,
and with 3.16-rc changes).  Since they were all within the subsystem,
I took care of them.

Stephen Rothwell reported some snags in PPC builds, but they are all
fixed now; the latest linux-next report was clean.

New features for ARM include:
- KVM VGIC v2 emulation on GICv3 hardware
- Big-Endian support for arm/arm64 (guest and host)
- Debug Architecture support for arm64 (arm32 is on Christoffer's todo list)

And for PPC:
- Book3S: Good number of LE host fixes, enable HV on LE
- Book3S HV: Add in-guest debug support

This release drops support for KVM on the PPC440.  As a result, the
PPC merge removes more lines than it adds. :)

I also included an x86 change, since Davidlohr tied it to an independent
bug report and the reporter quickly provided a Tested-by; there was no
reason to wait for -rc2.

----------------------------------------------------------------
Alex Bennée (2):
      arm64: KVM: export demux regids as KVM_REG_ARM64
      arm64: KVM: allow export and import of generic timer regs

Alexander Graf (31):
      KVM: PPC: Book3s PR: Disable AIL mode with OPAL
      KVM: PPC: Book3s HV: Fix tlbie compile error
      KVM: PPC: Book3S PR: Handle hyp doorbell exits
      KVM: PPC: Book3S PR: Fix ABIv2 on LE
      KVM: PPC: Book3S PR: Fix sparse endian checks
      PPC: Add asm helpers for BE 32bit load/store
      KVM: PPC: Book3S HV: Make HTAB code LE host aware
      KVM: PPC: Book3S HV: Access guest VPA in BE
      KVM: PPC: Book3S HV: Access host lppaca and shadow slb in BE
      KVM: PPC: Book3S HV: Access XICS in BE
      KVM: PPC: Book3S HV: Fix ABIv2 on LE
      KVM: PPC: Book3S HV: Enable for little endian hosts
      KVM: PPC: Book3S: Move vcore definition to end of kvm_arch struct
      KVM: PPC: Deflect page write faults properly in kvmppc_st
      KVM: PPC: Book3S: Stop PTE lookup on write errors
      KVM: PPC: Book3S: Add hack for split real mode
      KVM: PPC: Book3S: Make magic page properly 4k mappable
      KVM: PPC: Remove 440 support
      KVM: Rename and add argument to check_extension
      KVM: Allow KVM_CHECK_EXTENSION on the vm fd
      KVM: PPC: Book3S: Provide different CAPs based on HV or PR mode
      KVM: PPC: Implement kvmppc_xlate for all targets
      KVM: PPC: Move kvmppc_ld/st to common code
      KVM: PPC: Remove kvmppc_bad_hva()
      KVM: PPC: Use kvm_read_guest in kvmppc_ld
      KVM: PPC: Handle magic page in kvmppc_ld/st
      KVM: PPC: Separate loadstore emulation from priv emulation
      KVM: PPC: Expose helper functions for data/inst faults
      KVM: PPC: Remove DCR handling
      KVM: PPC: HV: Remove generic instruction emulation
      KVM: PPC: PR: Handle FSCR feature deselects

Alexey Kardashevskiy (1):
      KVM: PPC: Book3S: Fix LPCR one_reg interface

Aneesh Kumar K.V (4):
      KVM: PPC: BOOK3S: PR: Fix PURR and SPURR emulation
      KVM: PPC: BOOK3S: PR: Emulate virtual timebase register
      KVM: PPC: BOOK3S: PR: Emulate instruction counter
      KVM: PPC: BOOK3S: HV: Update compute_tlbie_rb to handle 16MB base page

Anton Blanchard (2):
      KVM: PPC: Book3S HV: Fix ABIv2 indirect branch issue
      KVM: PPC: Assembly functions exported to modules need _GLOBAL_TOC()

Bharat Bhushan (10):
      kvm: ppc: bookehv: Added wrapper macros for shadow registers
      kvm: ppc: booke: Use the shared struct helpers of SRR0 and SRR1
      kvm: ppc: booke: Use the shared struct helpers of SPRN_DEAR
      kvm: ppc: booke: Add shared struct helpers of SPRN_ESR
      kvm: ppc: booke: Use the shared struct helpers for SPRN_SPRG0-7
      kvm: ppc: Add SPRN_EPR get helper function
      kvm: ppc: bookehv: Save restore SPRN_SPRG9 on guest entry exit
      KVM: PPC: Booke-hv: Add one reg interface for SPRG9
      KVM: PPC: Remove comment saying SPRG1 is used for vcpu pointer
      KVM: PPC: BOOKEHV: rename e500hv_spr to bookehv_spr

Christoffer Dall (2):
      arm/arm64: KVM: Fix and refactor unmap_range
      Merge tag 'deps-irqchip-gic-3.17' of git://git.infradead.org/users/jcooper/linux.git

Eric Auger (1):
      ARM: KVM: Unmap IPA on memslot delete/move

Kim Phillips (1):
      ARM: KVM: user_mem_abort: support stage 2 MMIO page mapping

Li Liu (1):
      ARM: virt: fix wrong HSCTLR.EE bit setting

Marc Zyngier (31):
      arm64: GICv3 device tree binding documentation
      arm64: boot protocol documentation update for GICv3
      KVM: arm/arm64: vgic: move GICv2 registers to their own structure
      KVM: ARM: vgic: introduce vgic_ops and LR manipulation primitives
      KVM: ARM: vgic: abstract access to the ELRSR bitmap
      KVM: ARM: vgic: abstract EISR bitmap access
      KVM: ARM: vgic: abstract MISR decoding
      KVM: ARM: vgic: move underflow handling to vgic_ops
      KVM: ARM: vgic: abstract VMCR access
      KVM: ARM: vgic: introduce vgic_enable
      KVM: ARM: introduce vgic_params structure
      KVM: ARM: vgic: split GICv2 backend from the main vgic code
      KVM: ARM: vgic: revisit implementation of irqchip_in_kernel
      arm64: KVM: remove __kvm_hyp_code_{start,end} from hyp.S
      arm64: KVM: split GICv2 world switch from hyp code
      arm64: KVM: move HCR_EL2.{IMO,FMO} manipulation into the vgic switch code
      KVM: ARM: vgic: add the GICv3 backend
      arm64: KVM: vgic: add GICv3 world switch
      arm64: KVM: vgic: enable GICv2 emulation on top on GICv3 hardware
      arm64: KVM: rename pm_fake handler to trap_raz_wi
      arm64: move DBG_MDSCR_* to asm/debug-monitors.h
      arm64: KVM: add trap handlers for AArch64 debug registers
      arm64: KVM: common infrastructure for handling AArch32 CP14/CP15
      arm64: KVM: use separate tables for AArch32 32 and 64bit traps
      arm64: KVM: check ordering of all system register tables
      arm64: KVM: add trap handlers for AArch32 debug registers
      arm64: KVM: implement lazy world switch for debug registers
      arm64: KVM: enable trapping of all debug registers
      arm64: KVM: GICv3: move system register access to msr_s/mrs_s
      KVM: arm64: GICv3: mandate page-aligned GICV region
      arm64: KVM: fix 64bit CP15 VM access for 32bit guests

Michael Neuling (1):
      KVM: PPC: Book3S HV: Add H_SET_MODE hcall handling

Mihai Caraman (8):
      KVM: PPC: e500mc: Enhance tlb invalidation condition on vcpu schedule
      KVM: PPC: e500: Fix default tlb for victim hint
      KVM: PPC: e500: Emulate power management control SPR
      KVM: PPC: e500mc: Revert "add load inst fixup"
      KVM: PPC: Book3e: Add TLBSEL/TSIZE defines for MAS0/1
      KVM: PPC: Book3s: Remove kvmppc_read_inst() function
      KVM: PPC: Allow kvmppc_get_last_inst() to fail
      KVM: PPC: Bookehv: Get vcpu's last instruction for emulation

Paolo Bonzini (4):
      Merge tag 'kvm-arm-for-3.17' of git://git.kernel.org/.../kvmarm/kvmarm into kvm
      Merge tag 'signed-kvm-ppc-next' of git://github.com/agraf/linux-2.6 into kvm
      KVM: PPC: drop duplicate tracepoint
      KVM: Move more code under CONFIG_HAVE_KVM_IRQFD

Paul Mackerras (10):
      KVM: PPC: Book3S: Controls for in-kernel sPAPR hypercall handling
      KVM: PPC: Book3S: Allow only implemented hcalls to be enabled or disabled
      KVM: PPC: Book3S PR: Take SRCU read lock around RTAS kvm_read_guest() call
      KVM: PPC: Book3S: Make kvmppc_ld return a more accurate error indication
      KVM: Don't keep reference to irq routing table in irqfd struct
      KVM: irqchip: Provide and use accessors for irq routing table
      KVM: Move all accesses to kvm::irq_routing into irqchip.c
      KVM: Move irq notifier implementation into eventfd.c
      KVM: Give IRQFD its own separate enabling Kconfig option
      KVM: PPC: Enable IRQFD support for the XICS interrupt controller

Stewart Smith (2):
      Split out struct kvmppc_vcore creation to separate function
      Use the POWER8 Micro Partition Prefetch Engine in KVM HV on POWER8

Victor Kamensky (12):
      ARM: KVM: fix vgic V7 assembler code to work in BE image
      ARM: KVM: handle 64bit values passed to mrcc or from mcrr instructions in BE case
      ARM: KVM: __kvm_vcpu_run function return result fix in BE case
      ARM: KVM: vgic mmio should hold data as LE bytes array in BE case
      ARM: KVM: MMIO support BE host running LE code
      ARM: KVM: one_reg coproc set and get BE fixes
      ARM: KVM: enable KVM in Kconfig on big-endian systems
      ARM64: KVM: MMIO support BE host running LE code
      ARM64: KVM: store kvm_vcpu_fault_info est_el2 as word
      ARM64: KVM: fix vgic_bitmap_get_reg function for BE 64bit case
      ARM64: KVM: set and get of sys registers in BE case
      ARM64: KVM: fix big endian issue in access_vm_reg for 32bit guest

Wanpeng Li (2):
      KVM: nVMX: Fix nested vmexit ack intr before load vmcs01
      KVM: nVMX: fix "acknowledge interrupt on exit" when APICv is in use

 Documentation/arm64/booting.txt                  |   8 +
 Documentation/devicetree/bindings/arm/gic-v3.txt |  79 +++
 Documentation/powerpc/00-INDEX                   |   2 -
 Documentation/powerpc/kvm_440.txt                |  41 --
 Documentation/virtual/kvm/api.txt                |  60 ++-
 arch/arm/include/asm/kvm_asm.h                   |  18 +
 arch/arm/include/asm/kvm_emulate.h               |  22 +-
 arch/arm/include/asm/kvm_host.h                  |   8 +-
 arch/arm/include/asm/kvm_mmu.h                   |  12 +
 arch/arm/kernel/asm-offsets.c                    |  14 +-
 arch/arm/kernel/hyp-stub.S                       |   4 +-
 arch/arm/kvm/Kconfig                             |   2 +-
 arch/arm/kvm/Makefile                            |   1 +
 arch/arm/kvm/arm.c                               |  39 +-
 arch/arm/kvm/coproc.c                            |  88 +++-
 arch/arm/kvm/guest.c                             |  10 -
 arch/arm/kvm/init.S                              |   4 +-
 arch/arm/kvm/interrupts.S                        |   9 +-
 arch/arm/kvm/interrupts_head.S                   |  48 +-
 arch/arm/kvm/mmu.c                               | 214 +++++---
 arch/arm64/include/asm/debug-monitors.h          |  19 +-
 arch/arm64/include/asm/kvm_arm.h                 |   5 +-
 arch/arm64/include/asm/kvm_asm.h                 |  53 +-
 arch/arm64/include/asm/kvm_coproc.h              |   3 +-
 arch/arm64/include/asm/kvm_emulate.h             |  22 +
 arch/arm64/include/asm/kvm_host.h                |  48 +-
 arch/arm64/include/asm/kvm_mmu.h                 |  15 +
 arch/arm64/include/asm/virt.h                    |   4 +
 arch/arm64/kernel/asm-offsets.c                  |  26 +-
 arch/arm64/kernel/debug-monitors.c               |   9 -
 arch/arm64/kvm/Makefile                          |   4 +
 arch/arm64/kvm/guest.c                           |  68 ++-
 arch/arm64/kvm/handle_exit.c                     |   4 +-
 arch/arm64/kvm/hyp.S                             | 600 +++++++++++++++++++----
 arch/arm64/kvm/sys_regs.c                        | 546 ++++++++++++++++++---
 arch/arm64/kvm/vgic-v2-switch.S                  | 133 +++++
 arch/arm64/kvm/vgic-v3-switch.S                  | 267 ++++++++++
 arch/ia64/kvm/Kconfig                            |   1 +
 arch/ia64/kvm/kvm-ia64.c                         |   2 +-
 arch/mips/kvm/mips.c                             |   2 +-
 arch/powerpc/Kconfig.debug                       |   4 +-
 arch/powerpc/configs/ppc44x_defconfig            |   1 -
 arch/powerpc/include/asm/asm-compat.h            |   4 +
 arch/powerpc/include/asm/cache.h                 |   7 +
 arch/powerpc/include/asm/hvcall.h                |   6 +
 arch/powerpc/include/asm/kvm_44x.h               |  67 ---
 arch/powerpc/include/asm/kvm_asm.h               |   2 +-
 arch/powerpc/include/asm/kvm_book3s.h            |  51 +-
 arch/powerpc/include/asm/kvm_book3s_64.h         |  29 +-
 arch/powerpc/include/asm/kvm_booke.h             |  15 +-
 arch/powerpc/include/asm/kvm_host.h              |  28 +-
 arch/powerpc/include/asm/kvm_ppc.h               | 116 ++++-
 arch/powerpc/include/asm/mmu-book3e.h            |   8 +-
 arch/powerpc/include/asm/ppc-opcode.h            |  17 +
 arch/powerpc/include/asm/reg.h                   |  13 +-
 arch/powerpc/include/asm/time.h                  |   9 +
 arch/powerpc/include/uapi/asm/kvm.h              |   2 +
 arch/powerpc/kernel/asm-offsets.c                |   2 +
 arch/powerpc/kvm/44x.c                           | 237 ---------
 arch/powerpc/kvm/44x_emulate.c                   | 194 --------
 arch/powerpc/kvm/44x_tlb.c                       | 528 --------------------
 arch/powerpc/kvm/44x_tlb.h                       |  86 ----
 arch/powerpc/kvm/Kconfig                         |  20 +-
 arch/powerpc/kvm/Makefile                        |  18 +-
 arch/powerpc/kvm/book3s.c                        | 156 +++---
 arch/powerpc/kvm/book3s_32_mmu.c                 |   2 +-
 arch/powerpc/kvm/book3s_32_mmu_host.c            |   7 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c            |   5 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c              | 145 +++---
 arch/powerpc/kvm/book3s_emulate.c                |  28 +-
 arch/powerpc/kvm/book3s_hv.c                     | 271 ++++++++--
 arch/powerpc/kvm/book3s_hv_builtin.c             |  13 +
 arch/powerpc/kvm/book3s_hv_ras.c                 |   6 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c              | 146 +++---
 arch/powerpc/kvm/book3s_hv_rm_xics.c             |   5 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S          |  70 ++-
 arch/powerpc/kvm/book3s_paired_singles.c         |  38 +-
 arch/powerpc/kvm/book3s_pr.c                     | 223 ++++++---
 arch/powerpc/kvm/book3s_pr_papr.c                |  92 +++-
 arch/powerpc/kvm/book3s_xics.c                   |  55 ++-
 arch/powerpc/kvm/book3s_xics.h                   |   2 +
 arch/powerpc/kvm/booke.c                         | 225 +++++----
 arch/powerpc/kvm/booke.h                         |   7 -
 arch/powerpc/kvm/booke_emulate.c                 |   8 +-
 arch/powerpc/kvm/booke_interrupts.S              |   5 -
 arch/powerpc/kvm/bookehv_interrupts.S            |  60 +--
 arch/powerpc/kvm/e500_emulate.c                  |  12 +
 arch/powerpc/kvm/e500_mmu_host.c                 | 102 ++++
 arch/powerpc/kvm/e500mc.c                        |  28 +-
 arch/powerpc/kvm/emulate.c                       | 206 +-------
 arch/powerpc/kvm/emulate_loadstore.c             | 272 ++++++++++
 arch/powerpc/kvm/mpic.c                          |   4 +-
 arch/powerpc/kvm/powerpc.c                       | 181 ++++++-
 arch/powerpc/kvm/timing.c                        |   1 -
 arch/powerpc/kvm/timing.h                        |   3 -
 arch/s390/kvm/Kconfig                            |   1 +
 arch/s390/kvm/interrupt.c                        |   3 +-
 arch/s390/kvm/kvm-s390.c                         |   2 +-
 arch/x86/kvm/Kconfig                             |   1 +
 arch/x86/kvm/irq.c                               |   2 +-
 arch/x86/kvm/lapic.c                             |  52 +-
 arch/x86/kvm/vmx.c                               |   4 +-
 arch/x86/kvm/x86.c                               |   2 +-
 include/kvm/arm_arch_timer.h                     |  14 +
 include/kvm/arm_vgic.h                           | 115 ++++-
 include/linux/kvm_host.h                         |  47 +-
 include/trace/events/kvm.h                       |   8 +-
 include/uapi/linux/kvm.h                         |   6 +-
 virt/kvm/Kconfig                                 |   3 +
 virt/kvm/arm/vgic-v2.c                           | 265 ++++++++++
 virt/kvm/arm/vgic-v3.c                           | 247 ++++++++++
 virt/kvm/arm/vgic.c                              | 389 ++++++++-------
 virt/kvm/eventfd.c                               | 134 +++--
 virt/kvm/irq_comm.c                              |  24 +-
 virt/kvm/irqchip.c                               |  98 ++--
 virt/kvm/kvm_main.c                              |  62 +--
 116 files changed, 5010 insertions(+), 2825 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/gic-v3.txt
 delete mode 100644 Documentation/powerpc/kvm_440.txt
 create mode 100644 arch/arm64/kvm/vgic-v2-switch.S
 create mode 100644 arch/arm64/kvm/vgic-v3-switch.S
 delete mode 100644 arch/powerpc/include/asm/kvm_44x.h
 delete mode 100644 arch/powerpc/kvm/44x.c
 delete mode 100644 arch/powerpc/kvm/44x_emulate.c
 delete mode 100644 arch/powerpc/kvm/44x_tlb.c
 delete mode 100644 arch/powerpc/kvm/44x_tlb.h
 create mode 100644 arch/powerpc/kvm/emulate_loadstore.c
 create mode 100644 virt/kvm/arm/vgic-v2.c
 create mode 100644 virt/kvm/arm/vgic-v3.c
