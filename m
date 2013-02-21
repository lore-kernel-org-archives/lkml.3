Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3BUVNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:13:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3BUVNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:13:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 09/09] arm-soc: virtualization changes
Date: Thu, 21 Feb 2013 21:12:29 +0000
Message-Id: <1361481149-27559-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0ni9YyCjvMsShXgcZzj5etVEW2t1lS3mQNCzng7BMV/
 hMsPOhox8v0IevsUmoMoA6NVMYl/L1LVx8MiLT/qumKZzRUDV7
 FoF4o0RXfQwHrlLFPrp/Ko2Gcds1v22EdsvliHxwgPUyP6MpPV
 aH3+XzZnRbihY6dgHTsqzw/CKzT+5pf3aEM1B7HrOqZAAq4aJ9
 sqtGKrG1DoIgYqjOAZ/W7h5fMjWPfGggDawRlwHuIlGcr4//Zg
 ZiMBTqoN0UUnleotKiBFOPtFiScPRuAAeCOq0KC3OQ5f6ygnzj
 JLxcjMHoJ3rQ1vyIIaUcpzyc71hSQWdNLLzD1QVaADBSEbRrC5
 a8882E+u5Aoxf1BM4Erbv0rdRw8k3/pGBScR6/iP5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39:

  Linux 3.8-rc7 (2013-02-09 08:20:39 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/virt

for you to fetch changes up to fe7dc7202d7d24fe211e0eecf531d8b79b655b3c:

  ARM: arch_timer: include linux/errno.h (2013-02-15 19:32:03 +0100)

----------------------------------------------------------------
arm-soc: virtualization changes

This contains parts of the ARM KVM support that have dependencies on
other patches merged through the arm-soc tree. In combination with
patches coming through Russell's tree, this will finally add full
support for the kernel based virtual machine on ARM,  which has
been awaited for some time now.

Further, we now have a separate platform for virtual machines
and qemu booting that is used by both Xen and KVM, separating
these from the Versatile Express reference implementation.
Obviously, this new platform is multiplatform capable so it
can be combined with existing machines in the same kernel.

----------------------------------------------------------------
Arnd Bergmann (2):
      ARM: arch_timer: include linux/errno.h

Christoffer Dall (16):
      ARM: Add page table and page defines needed by KVM
      ARM: Section based HYP idmap
      KVM: ARM: Initial skeleton to compile KVM support
      KVM: ARM: Hypervisor initialization
      KVM: ARM: Memory virtualization setup
      KVM: ARM: Inject IRQs and FIQs from userspace
      KVM: ARM: World-switch implementation
      KVM: ARM: Emulation framework and CP15 emulation
      KVM: ARM: User space API for getting/setting co-proc registers
      KVM: ARM: Demux CCSIDR in the userspace API
      KVM: ARM: Handle guest faults in KVM
      KVM: ARM: Handle I/O aborts
      KVM: ARM: Add maintainer entry for KVM/ARM
      ARM: gic: add missing distributor defintions
      KVM: ARM: Introduce KVM_ARM_SET_DEVICE_ADDR ioctl
      ARM: KVM: VGIC accept vcpu and dist base addresses from user space

Marc Zyngier (19):
      KVM: ARM: Power State Coordination Interface implementation
      Merge remote-tracking branch 'arm-soc/irqchip/gic-vic-move' into kvm-arm/vgic
      ARM: arch_timers: switch to physical timers if HYP mode is available
      ARM: Dummy Virtual Machine platform support
      ARM: gic: define GICH offsets for VGIC support
      ARM: gic: add __ASSEMBLY__ guard to C definitions
      ARM: KVM: Keep track of currently running vcpus
      ARM: KVM: Initial VGIC infrastructure code
      ARM: KVM: VGIC distributor handling
      ARM: KVM: VGIC virtual CPU interface management
      ARM: KVM: vgic: retire queued, disabled interrupts
      ARM: KVM: VGIC interrupt injection
      ARM: KVM: VGIC control interface world switch
      ARM: KVM: VGIC initialisation code
      ARM: KVM: Add VGIC configuration option
      Merge branch 'for-arm-soc/arch-timers' of git://git.kernel.org/.../will/linux into kvm-arm/timer
      ARM: KVM: arch_timers: Add guest timer core support
      ARM: KVM: arch_timers: Add timer world switch
      ARM: KVM: arch_timers: Wire the init code and config option

Mark Rutland (17):
      arm: arch_timer: balance device_node refcounting
      arm: arch_timer: remove redundant available check
      arm: arch_timer: use u64/u32 for register data
      arm: arch_timer: standardise counter reading
      arm: arch_timer: split cntfrq accessor
      arm: arch_timer: factor out register accessors
      arm: arch_timer: add isbs to register accessors
      arm: arch_timer: divorce from local_timer api
      arm: arch_timer: add arch_counter_set_user_access
      arm: arch_timer: move core to drivers/clocksource
      arm64: arm_generic: prevent reading stale time
      arm64: move from arm_generic to arm_arch_timer
      Documentation: Add ARMv8 to arch_timer devicetree
      clockevents: Add generic timer broadcast receiver
      clockevents: Add generic timer broadcast function
      arm: Use generic timer broadcast receiver
      arm: Add generic timer broadcast support

Olof Johansson (10):
      Merge branch 'for-rmk/perf' of git://git.kernel.org/.../will/linux into next/virt
      Merge branch 'for-rmk/virt/kvm/core' of git://git.kernel.org/.../will/linux into next/virt
      Merge branch 'for-rmk/broadcast' of git://git.kernel.org/.../will/linux into next/virt
      Merge branch 'for-arm-soc/arch-timers' of git://git.kernel.org/.../will/linux into next/virt
      Merge branch 'irqchip/gic-vic-move' into next/virt
      Merge branch 'depends/rmk-psci' into next/virt
      Merge branch 'depends/cleanup' into next/virt
      Merge branch 'for-arm-soc/virt/mach' of git://git.kernel.org/.../will/linux into next/virt
      arm: arch_timer: add missing inline in stub function
      Merge branch 'kvm-arm/timer' of git://git.kernel.org/.../maz/arm-platforms into next/virt

Rusty Russell (1):
      KVM: ARM: VFP userspace interface

Will Deacon (9):
      Merge branch 'for-rmk/perf' into for-rmk/virt/kvm/core
      Merge branch 'for-will/kvm/core' of git://github.com/virtualopensystems/linux-kvm-arm into for-rmk/virt/kvm/core
      Merge branch 'timers/for-arm' of git://git.kernel.org/.../tip/tip into for-rmk/broadcast
      Merge branch 'clocks/broadcast-arm' of git://linux-arm.org/linux-mr into for-rmk/broadcast
      Merge branch 'for-will/arch-timer-unification' of git://linux-arm.org/linux-mr into for-arm-soc/arch-timers
      Merge branch 'for-rmk/virt/psci' into for-arm-soc/virt/mach
      Merge branch 'irqchip/gic-vic-move' of git://git.kernel.org/.../arm/arm-soc into for-arm-soc/virt/mach
      ARM: mach-virt: add SMP support using PSCI
      ARM: mach-virt: fixup machine descriptor after removal of sys_timer

 .../devicetree/bindings/arm/arch_timer.txt         |    7 +-
 Documentation/virtual/kvm/api.txt                  |  137 +-
 MAINTAINERS                                        |    9 +
 arch/arm/Kconfig                                   |    8 +-
 arch/arm/Makefile                                  |    2 +
 arch/arm/include/asm/arch_timer.h                  |  109 +-
 arch/arm/include/asm/idmap.h                       |    1 +
 arch/arm/include/asm/kvm_arch_timer.h              |   85 ++
 arch/arm/include/asm/kvm_arm.h                     |  214 +++
 arch/arm/include/asm/kvm_asm.h                     |   83 ++
 arch/arm/include/asm/kvm_coproc.h                  |   47 +
 arch/arm/include/asm/kvm_emulate.h                 |   72 +
 arch/arm/include/asm/kvm_host.h                    |  184 +++
 arch/arm/include/asm/kvm_mmio.h                    |   56 +
 arch/arm/include/asm/kvm_mmu.h                     |   50 +
 .../arm/include/asm/kvm_psci.h                     |   12 +-
 arch/arm/include/asm/kvm_vgic.h                    |  221 +++
 arch/arm/include/asm/pgtable-3level-hwdef.h        |    5 +
 arch/arm/include/asm/pgtable-3level.h              |   18 +
 arch/arm/include/asm/pgtable.h                     |    7 +
 arch/arm/include/uapi/asm/kvm.h                    |  180 +++
 arch/arm/kernel/arch_timer.c                       |  505 +------
 arch/arm/kernel/asm-offsets.c                      |   43 +
 arch/arm/kernel/smp.c                              |   13 +-
 arch/arm/kernel/vmlinux.lds.S                      |    6 +-
 arch/arm/kvm/Kconfig                               |   72 +
 arch/arm/kvm/Makefile                              |   23 +
 arch/arm/kvm/arch_timer.c                          |  271 ++++
 arch/arm/kvm/arm.c                                 | 1169 +++++++++++++++
 arch/arm/kvm/coproc.c                              | 1050 ++++++++++++++
 arch/arm/kvm/coproc.h                              |  153 ++
 arch/arm/kvm/coproc_a15.c                          |  162 +++
 arch/arm/kvm/emulate.c                             |  373 +++++
 arch/arm/kvm/guest.c                               |  222 +++
 arch/arm/kvm/init.S                                |  114 ++
 arch/arm/kvm/interrupts.S                          |  484 +++++++
 arch/arm/kvm/interrupts_head.S                     |  605 ++++++++
 arch/arm/kvm/mmio.c                                |  156 ++
 arch/arm/kvm/mmu.c                                 |  787 ++++++++++
 arch/arm/kvm/psci.c                                |  108 ++
 arch/arm/kvm/reset.c                               |   74 +
 arch/arm/kvm/trace.h                               |  235 +++
 arch/arm/kvm/vgic.c                                | 1506 ++++++++++++++++++++
 arch/arm/mach-omap2/Kconfig                        |    2 +-
 arch/arm/mach-virt/Kconfig                         |   10 +
 arch/arm/mach-virt/Makefile                        |    6 +
 arch/arm/mach-virt/platsmp.c                       |   58 +
 arch/arm/mach-virt/virt.c                          |   54 +
 arch/arm/mm/idmap.c                                |   55 +-
 arch/arm/mm/mmu.c                                  |   22 +
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/include/asm/arch_timer.h                |  133 ++
 arch/arm64/include/asm/arm_generic.h               |  100 --
 arch/arm64/kernel/time.c                           |   29 +-
 drivers/clocksource/Kconfig                        |    6 +-
 drivers/clocksource/Makefile                       |    2 +-
 drivers/clocksource/arm_arch_timer.c               |  391 +++++
 drivers/clocksource/arm_generic.c                  |  232 ---
 include/clocksource/arm_arch_timer.h               |   63 +
 include/linux/clockchips.h                         |    9 +
 include/linux/irqchip/arm-gic.h                    |   33 +-
 include/uapi/linux/kvm.h                           |   17 +
 kernel/time/Kconfig                                |    4 +
 kernel/time/tick-broadcast.c                       |   30 +
 64 files changed, 10026 insertions(+), 869 deletions(-)
