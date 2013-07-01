Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3GARXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:23:54 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51774 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752688Ab3GARXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:23:52 -0400
Date: Mon, 1 Jul 2013 18:23:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 patches for 3.11
Message-ID: <20130701172309.GA12256@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64-upstream tag as below.

For arm64 huge pages support, there are x86 changes moving part of
arch/x86/mm/hugetlbpage.c into mm/hugetlb.c to be re-used by arm64. They
have been acked by akpm
(http://marc.info/?l=linux-mm&m=137115843813005&w=2) and I'm merging
them through the arm64 tree to avoid dependency issues.

There is also a trivial merge conflict with 3.10 in
include/uapi/linux/kvm.h (with the KVM_REG_MIPS define).

Thanks.


The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-upstream

for you to fetch changes up to aa729dccb5e8dfbc78e2e235b8754d6acccee731:

  Merge branch 'for-next/hugepages' of git://git.linaro.org/people/stevecapper/linux into upstream-hugepages (2013-07-01 11:20:58 +0100)

----------------------------------------------------------------

Main features:
- KVM and Xen ports to AArch64
- Hugetlbfs and transparent huge pages support for arm64
- Applied Micro X-Gene Kconfig entry and dts file
- Cache flushing improvements

----------------------------------------------------------------
Catalin Marinas (7):
      arm64: Avoid cache flushing in flush_dcache_page()
      arm64: Do not flush the D-cache for anonymous pages
      arm64: Remove __flush_dcache_page()
      arm64: spinlock: retry trylock operation if strex fails on free lock
      Merge tag 'xen-arm64-3.1-tag' of git://git.kernel.org/.../sstabellini/xen into upstream
      Merge branch 'kvm-arm64/kvm-for-3.11' of git://git.kernel.org/.../maz/arm-platforms into upstream
      Merge branch 'for-next/hugepages' of git://git.linaro.org/people/stevecapper/linux into upstream-hugepages

Chen Gang (1):
      arm64: kernel: compiling issue, need delete read_current_timer()

Damian Hobson-Garcia (1):
      arm64: Provide default implementation for dma_{alloc,free}_attrs

Kyle McMartin (1):
      arm64/Makefile: provide vdso_install target

Marc Zyngier (33):
      arm64: KVM: define HYP and Stage-2 translation page flags
      arm64: KVM: HYP mode idmap support
      arm64: KVM: EL2 register definitions
      arm64: KVM: system register definitions for 64bit guests
      arm64: KVM: Basic ESR_EL2 helpers and vcpu register access
      arm64: KVM: fault injection into a guest
      arm64: KVM: architecture specific MMU backend
      arm64: KVM: user space interface
      arm64: KVM: system register handling
      arm64: KVM: CPU specific system registers handling
      arm64: KVM: virtual CPU reset
      arm64: KVM: kvm_arch and kvm_vcpu_arch definitions
      arm64: KVM: MMIO access backend
      arm64: KVM: guest one-reg interface
      arm64: KVM: hypervisor initialization code
      arm64: KVM: HYP mode world switch implementation
      arm64: KVM: Exit handling
      arm64: KVM: Plug the VGIC
      ARM: KVM: timer: allow DT matching for ARMv8 cores
      arm64: KVM: Plug the arch timer
      arm64: KVM: PSCI implementation
      arm64: KVM: Build system integration
      arm64: KVM: define 32bit specific registers
      arm64: KVM: 32bit GP register access
      arm64: KVM: 32bit conditional execution emulation
      arm64: KVM: 32bit handling of coprocessor traps
      arm64: KVM: CPU specific 32bit coprocessor access
      arm64: KVM: 32bit specific register world switch
      arm64: KVM: 32bit guest fault injection
      arm64: KVM: enable initialization of a 32bit vcpu
      arm64: KVM: userspace API documentation
      arm64: KVM: MAINTAINERS update
      arm64: KVM: document kernel object mappings in HYP

Stefano Stabellini (6):
      arm/xen: define xen_remap as ioremap_cached
      arm64/xen: introduce asm/xen header files on arm64
      arm64/xen: implement ioremap_cached on arm64
      arm64/xen: use XEN_IO_PROTO_ABI_ARM on ARM64
      arm64/xen: introduce CONFIG_XEN and hypercall.S on ARM64
      MAINTAINERS: add myself as arm64/xen maintainer

Steve Capper (11):
      mm: hugetlb: Copy huge_pmd_share from x86 to mm.
      x86: mm: Remove x86 version of huge_pmd_share.
      mm: hugetlb: Copy general hugetlb code from x86 to mm.
      x86: mm: Remove general hugetlb code from x86.
      mm: thp: Correct the HPAGE_PMD_ORDER check.
      ARM64: mm: Restore memblock limit when map_mem finished.
      ARM64: mm: Make PAGE_NONE pages read only and no-execute.
      ARM64: mm: Move PTE_PROT_NONE bit.
      ARM64: mm: HugeTLB support.
      ARM64: mm: Raise MAX_ORDER for 64KB pages and THP.
      ARM64: mm: THP support.

Vinayak Kale (4):
      arm64: Add Kconfig option for APM X-Gene SOC family
      arm64: Enable APM X-Gene SOC family in the defconfig
      arm64: Add defines for APM ARMv8 implementation
      arm64: Add initial DTS for APM X-Gene Storm SOC and APM Mustang board

Will Deacon (5):
      arm64: mm: don't bother invalidating the icache in switch_mm
      arm64: pgtable: use pte_index instead of __pte_index
      arm64: device: add iommu pointer to device archdata
      arm64: extable: sort the exception table at build time
      arm64: debug: consolidate software breakpoint handlers

 Documentation/arm64/memory.txt          |    7 +
 Documentation/virtual/kvm/api.txt       |   58 +-
 MAINTAINERS                             |   16 +
 arch/arm/include/asm/xen/page.h         |    3 +-
 arch/arm/kvm/arch_timer.c               |    1 +
 arch/arm64/Kconfig                      |   35 ++
 arch/arm64/Makefile                     |    6 +
 arch/arm64/boot/dts/Makefile            |    1 +
 arch/arm64/boot/dts/apm-mustang.dts     |   26 +
 arch/arm64/boot/dts/apm-storm.dtsi      |  116 ++++
 arch/arm64/configs/defconfig            |    4 +
 arch/arm64/include/asm/cacheflush.h     |    3 -
 arch/arm64/include/asm/cputype.h        |    3 +
 arch/arm64/include/asm/debug-monitors.h |    9 +
 arch/arm64/include/asm/device.h         |    3 +
 arch/arm64/include/asm/dma-mapping.h    |   17 +-
 arch/arm64/include/asm/hugetlb.h        |  117 ++++
 arch/arm64/include/asm/hypervisor.h     |    6 +
 arch/arm64/include/asm/io.h             |    2 +
 arch/arm64/include/asm/kvm_arm.h        |  245 ++++++++
 arch/arm64/include/asm/kvm_asm.h        |  104 +++
 arch/arm64/include/asm/kvm_coproc.h     |   56 ++
 arch/arm64/include/asm/kvm_emulate.h    |  180 ++++++
 arch/arm64/include/asm/kvm_host.h       |  202 ++++++
 arch/arm64/include/asm/kvm_mmio.h       |   59 ++
 arch/arm64/include/asm/kvm_mmu.h        |  135 ++++
 arch/arm64/include/asm/kvm_psci.h       |   23 +
 arch/arm64/include/asm/memory.h         |    6 +
 arch/arm64/include/asm/mmu_context.h    |    6 -
 arch/arm64/include/asm/pgtable-hwdef.h  |   30 +
 arch/arm64/include/asm/pgtable.h        |  112 +++-
 arch/arm64/include/asm/ptrace.h         |    2 -
 arch/arm64/include/asm/spinlock.h       |    3 +-
 arch/arm64/include/asm/sync_bitops.h    |   26 +
 arch/arm64/include/asm/timex.h          |    6 +-
 arch/arm64/include/asm/tlb.h            |    6 +
 arch/arm64/include/asm/tlbflush.h       |    2 +
 arch/arm64/include/asm/xen/events.h     |   21 +
 arch/arm64/include/asm/xen/hypercall.h  |    1 +
 arch/arm64/include/asm/xen/hypervisor.h |    1 +
 arch/arm64/include/asm/xen/interface.h  |    1 +
 arch/arm64/include/asm/xen/page.h       |    1 +
 arch/arm64/include/uapi/asm/kvm.h       |  168 +++++
 arch/arm64/kernel/asm-offsets.c         |   33 +
 arch/arm64/kernel/debug-monitors.c      |   66 +-
 arch/arm64/kernel/ptrace.c              |   59 --
 arch/arm64/kernel/time.c                |    6 -
 arch/arm64/kernel/traps.c               |    5 +-
 arch/arm64/kernel/vmlinux.lds.S         |   30 +-
 arch/arm64/kvm/Makefile                 |   23 +
 arch/arm64/kvm/emulate.c                |  158 +++++
 arch/arm64/kvm/guest.c                  |  265 ++++++++
 arch/arm64/kvm/handle_exit.c            |  124 ++++
 arch/arm64/kvm/hyp-init.S               |  107 ++++
 arch/arm64/kvm/hyp.S                    |  831 ++++++++++++++++++++++++
 arch/arm64/kvm/inject_fault.c           |  203 ++++++
 arch/arm64/kvm/regmap.c                 |  168 +++++
 arch/arm64/kvm/reset.c                  |  112 ++++
 arch/arm64/kvm/sys_regs.c               | 1050 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.h               |  138 ++++
 arch/arm64/kvm/sys_regs_generic_v8.c    |   95 +++
 arch/arm64/mm/Makefile                  |    1 +
 arch/arm64/mm/fault.c                   |   19 +-
 arch/arm64/mm/flush.c                   |   37 +-
 arch/arm64/mm/hugetlbpage.c             |   70 +++
 arch/arm64/mm/mm.h                      |    1 -
 arch/arm64/mm/mmu.c                     |   20 +-
 arch/arm64/xen/Makefile                 |    2 +
 arch/arm64/xen/hypercall.S              |   92 +++
 arch/x86/Kconfig                        |    6 +
 arch/x86/mm/hugetlbpage.c               |  187 ------
 include/linux/huge_mm.h                 |    2 +-
 include/linux/hugetlb.h                 |    4 +
 include/uapi/linux/kvm.h                |    2 +
 include/xen/interface/io/protocols.h    |    2 +-
 mm/hugetlb.c                            |  219 ++++++-
 scripts/sortextable.c                   |    5 +
 77 files changed, 5582 insertions(+), 389 deletions(-)
 create mode 100644 arch/arm64/boot/dts/apm-mustang.dts
 create mode 100644 arch/arm64/boot/dts/apm-storm.dtsi
 create mode 100644 arch/arm64/include/asm/hugetlb.h
 create mode 100644 arch/arm64/include/asm/hypervisor.h
 create mode 100644 arch/arm64/include/asm/kvm_arm.h
 create mode 100644 arch/arm64/include/asm/kvm_asm.h
 create mode 100644 arch/arm64/include/asm/kvm_coproc.h
 create mode 100644 arch/arm64/include/asm/kvm_emulate.h
 create mode 100644 arch/arm64/include/asm/kvm_host.h
 create mode 100644 arch/arm64/include/asm/kvm_mmio.h
 create mode 100644 arch/arm64/include/asm/kvm_mmu.h
 create mode 100644 arch/arm64/include/asm/kvm_psci.h
 create mode 100644 arch/arm64/include/asm/sync_bitops.h
 create mode 100644 arch/arm64/include/asm/xen/events.h
 create mode 100644 arch/arm64/include/asm/xen/hypercall.h
 create mode 100644 arch/arm64/include/asm/xen/hypervisor.h
 create mode 100644 arch/arm64/include/asm/xen/interface.h
 create mode 100644 arch/arm64/include/asm/xen/page.h
 create mode 100644 arch/arm64/include/uapi/asm/kvm.h
 create mode 100644 arch/arm64/kvm/Makefile
 create mode 100644 arch/arm64/kvm/emulate.c
 create mode 100644 arch/arm64/kvm/guest.c
 create mode 100644 arch/arm64/kvm/handle_exit.c
 create mode 100644 arch/arm64/kvm/hyp-init.S
 create mode 100644 arch/arm64/kvm/hyp.S
 create mode 100644 arch/arm64/kvm/inject_fault.c
 create mode 100644 arch/arm64/kvm/regmap.c
 create mode 100644 arch/arm64/kvm/reset.c
 create mode 100644 arch/arm64/kvm/sys_regs.c
 create mode 100644 arch/arm64/kvm/sys_regs.h
 create mode 100644 arch/arm64/kvm/sys_regs_generic_v8.c
 create mode 100644 arch/arm64/mm/hugetlbpage.c
 create mode 100644 arch/arm64/xen/Makefile
 create mode 100644 arch/arm64/xen/hypercall.S

-- 
Catalin
