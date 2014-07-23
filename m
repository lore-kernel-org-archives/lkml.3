Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaGWCa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:30:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:33761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbaGWCaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:30:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577334372"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: [RESEND RFC PATCH v1 0/70] Gloabl CPU Hot-plug flag _FROZEN Clean up
Date: Tue, 22 Jul 2014 21:58:36 -0400
Message-Id: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back to long time ago (about 1.5 years), Thomas began the work
for CPU hot-plug, one first thing is CPU hotplug flag cleanup.
Paul hoped all the _FROZEN variants of the notifier actions
can be removed at that time. Now here it is.

Patch 1 ~ 69: remove all kinds of XXX_FROZEN usages
Patch 70: remove XXX_FROZEN from the kernel thoroughly

Not sure if removing XXX_FROZEN flags thoroughly is overkilled.
Fix me if I'm wrong.

P.S. My last post is banned because of the capital Triple-X in subject :-(

----------------------------------------------------------------
Chen, Gong (69):
      ia64, err_inject: _FROZEN Cleanup
      ia64, mca: _FROZEN Cleanup
      ia64, palinfo: _FROZEN Cleanup
      ia64, salinfo: _FROZEN Cleanup
      ia64, topology: _FROZEN Cleanup
      x86, intel_cacheinfo: _FROZEN Cleanup
      x86, mce, therm_throt: _FROZEN Cleanup
      x86, mce_amd: _FROZEN Cleanup
      x86, kvm: _FROZEN Cleanup
      x86, vsyscall_64: _FROZEN Cleanup
      x86, pci, amd_bus: _FROZEN Cleanup
      x86, x2apic_cluster: _FROZEN Cleanup
      x86, microcode, core: _FROZEN Cleanup
      x86, kernel, cpuid: _FROZEN Cleanup
      x86, kernel, msr: _FROZEN Cleanup
      arm, vfp, vfpmodule: _FROZEN Cleanup
      arm, kvm: _FROZEN Cleanup
      powerpc, sysfs: _FROZEN Cleanup
      powerpc, mm, numa: _FROZEN Cleanup
      powerpc, powermac, smp: _FROZEN Cleanup
      powerpc, mmu_context_nohash: _FROZEN Cleanup
      mips, loongson, smp: _FROZEN Cleanup
      s390, perf_cpum_sf: _FROZEN Cleanup
      sparc, sysfs: _FROZEN Cleanup
      rcu, tree: _FROZEN Cleanup
      kernel, padata: _FROZEN Cleanup
      kernel, profile: _FROZEN Cleanup
      kernel, sched, core: _FROZEN Cleanup
      kernel, hrtimer: _FROZEN Cleanup
      kernel, relay: _FROZEN Cleanup
      kernel, smp: _FROZEN Cleanup
      kernel, timer: _FROZEN Cleanup
      kernel, softirq: _FROZEN Cleanup
      mm, slab: _FROZEN Cleanup
      mm, vmscan: _FROZEN Cleanup
      mm, vmstat: _FROZEN Cleanup
      mm, memcontrol: _FROZEN Cleanup
      mm, page_alloc: _FROZEN Cleanup
      mm, slub: _FROZEN Cleanup
      fs, buffer: _FROZEN Cleanup
      xfs, xfs_mount: _FROZEN Cleanup
      net, iucv: _FROZEN Cleanup
      net, core, flow: _FROZEN Cleanup
      net, core, dev: _FROZEN Cleanup
      block, blk-mq: _FROZEN Cleanup
      block, blk-iopoll: _FROZEN Cleanup
      block, blk-softirq: _FROZEN Cleanup
      driver, base, topology: _FROZEN Cleanup
      clocksource, metag_generic: _FROZEN Cleanup
      powercap, intel_rapl: _FROZEN Cleanup
      cpuidle, cpuidle-powernv: _FROZEN Cleanup
      cpuidle, cpuidle-pseries: _FROZEN Cleanup
      cpufreq, acpi-cpufreq: _FROZEN Cleanup
      irqchip, irq-armada-370-xp: _FROZEN Cleanup
      irqchip, irq-gic: _FROZEN Cleanup
      scsi, bnx2fc, bnx2fc_fcoe: _FROZEN Cleanup
      scsi, bnx2i, bnx2i_init: _FROZEN Cleanup
      scsi, fcoe: _FROZEN Cleanup
      scsi, virtio_scsi: _FROZEN Cleanup
      md, raid5: _FROZEN Cleanup
      virt, kvm, arm, arch_timer: _FROZEN Cleanup
      virt, kvm, arm, vgic: _FROZEN Cleanup
      trace, ring_buffer: _FROZEN Cleanup
      oprofile, timer_int: _FROZEN Cleanup
      lib, cpu-notifier-error-inject: _FROZEN Cleanup
      lib, percpu_counter: _FROZEN Cleanup
      lib, radix-tree: _FROZEN Cleanup
      staging, lustre, linux-cpu: _FROZEN Cleanup
      cpu: Eliminate _FROZEN flags thoroughly

Thomas Gleixner (1):
      cpu: Restructure FROZEN state handling

 arch/arm/kvm/arm.c                                 |  3 +-
 arch/arm/vfp/vfpmodule.c                           |  6 +-
 arch/ia64/kernel/err_inject.c                      |  4 +-
 arch/ia64/kernel/mca.c                             |  3 +-
 arch/ia64/kernel/palinfo.c                         |  4 +-
 arch/ia64/kernel/salinfo.c                         |  4 +-
 arch/ia64/kernel/topology.c                        |  4 +-
 arch/mips/loongson/loongson-3/smp.c                |  5 +-
 arch/powerpc/kernel/sysfs.c                        |  4 +-
 arch/powerpc/mm/mmu_context_nohash.c               |  5 +-
 arch/powerpc/mm/numa.c                             |  5 +-
 arch/powerpc/platforms/powermac/smp.c              | 11 ++--
 arch/s390/kernel/perf_cpum_sf.c                    |  1 -
 arch/sparc/kernel/sysfs.c                          |  4 +-
 arch/x86/kernel/apic/x2apic_cluster.c              | 11 +++-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |  4 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c               |  4 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |  5 +-
 arch/x86/kernel/cpu/microcode/core.c               |  8 +--
 arch/x86/kernel/cpuid.c                            |  6 +-
 arch/x86/kernel/kvm.c                              |  9 +--
 arch/x86/kernel/msr.c                              |  6 +-
 arch/x86/kernel/vsyscall_64.c                      |  2 +-
 arch/x86/pci/amd_bus.c                             |  3 +-
 block/blk-iopoll.c                                 |  2 +-
 block/blk-mq.c                                     | 10 ++--
 block/blk-softirq.c                                |  2 +-
 drivers/base/topology.c                            |  5 +-
 drivers/clocksource/metag_generic.c                |  3 +-
 drivers/cpufreq/acpi-cpufreq.c                     |  4 +-
 drivers/cpuidle/cpuidle-powernv.c                  |  4 +-
 drivers/cpuidle/cpuidle-pseries.c                  |  4 +-
 drivers/irqchip/irq-armada-370-xp.c                |  2 +-
 drivers/irqchip/irq-gic.c                          |  2 +-
 drivers/md/raid5.c                                 |  4 +-
 drivers/oprofile/timer_int.c                       |  4 +-
 drivers/powercap/intel_rapl.c                      |  5 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |  4 +-
 drivers/scsi/bnx2i/bnx2i_init.c                    |  4 +-
 drivers/scsi/fcoe/fcoe.c                           |  4 +-
 drivers/scsi/virtio_scsi.c                         |  4 +-
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |  6 +-
 fs/buffer.c                                        |  2 +-
 fs/xfs/xfs_mount.c                                 |  5 +-
 include/linux/cpu.h                                |  9 ---
 kernel/cpu.c                                       | 66 +++++++++-------------
 kernel/hrtimer.c                                   | 10 +---
 kernel/padata.c                                    |  6 +-
 kernel/profile.c                                   |  6 +-
 kernel/rcu/tree.c                                  | 12 ++--
 kernel/relay.c                                     |  4 +-
 kernel/sched/core.c                                | 55 ++++++++----------
 kernel/smp.c                                       |  8 +--
 kernel/softirq.c                                   |  3 +-
 kernel/timer.c                                     |  4 +-
 kernel/trace/ring_buffer.c                         |  4 +-
 lib/cpu-notifier-error-inject.c                    |  8 +--
 lib/percpu_counter.c                               |  2 +-
 lib/radix-tree.c                                   |  2 +-
 mm/memcontrol.c                                    |  2 +-
 mm/page_alloc.c                                    |  2 +-
 mm/slab.c                                          |  8 +--
 mm/slub.c                                          |  4 +-
 mm/vmscan.c                                        |  2 +-
 mm/vmstat.c                                        |  6 +-
 net/core/dev.c                                     |  2 +-
 net/core/flow.c                                    |  4 +-
 net/iucv/iucv.c                                    |  8 +--
 virt/kvm/arm/arch_timer.c                          |  4 +-
 virt/kvm/arm/vgic.c                                |  4 +-
 70 files changed, 159 insertions(+), 287 deletions(-)

