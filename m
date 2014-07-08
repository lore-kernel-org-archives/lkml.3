Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaGHDpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:45:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:43591 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbaGHDpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:45:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,623,1400050800"; 
   d="log'?scan'208";a="558632657"
Date: Tue, 8 Jul 2014 11:45:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>
Subject: [timer] BUG: soft lockup - CPU#1 stuck for 23s! [swapper/0:1]
Message-ID: <20140708034521.GD17142@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
commit 1ead65812486cda65093683a99b8907a7242fa93
Merge: b6d739e b97f029
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Tue Apr 1 11:00:07 2014 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Tue Apr 1 11:00:07 2014 -0700

    Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull timer changes from Thomas Gleixner:
     "This assorted collection provides:
    
       - A new timer based timer broadcast feature for systems which do not
         provide a global accessible timer device.  That allows those
         systems to put CPUs into deep idle states where the per cpu timer
         device stops.
    
       - A few NOHZ_FULL related improvements to the timer wheel
    
       - The usual updates to timer devices found in ARM SoCs
    
       - Small improvements and updates all over the place"
    
    * 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip: (44 commits)
      tick: Remove code duplication in tick_handle_periodic()
      tick: Fix spelling mistake in tick_handle_periodic()
      x86: hpet: Use proper destructor for delayed work
      workqueue: Provide destroy_delayed_work_on_stack()
      clocksource: CMT, MTU2, TMU and STI should depend on GENERIC_CLOCKEVENTS
      timer: Remove code redundancy while calling get_nohz_timer_target()
      hrtimer: Rearrange comments in the order struct members are declared
      timer: Use variable head instead of &work_list in __run_timers()
      clocksource: exynos_mct: silence a static checker warning
      arm: zynq: Add support for cpufreq
      arm: zynq: Don't use arm_global_timer with cpufreq
      clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
      clocksource/cadence_ttc: Call clockevents_update_freq() with IRQs enabled
      clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI
      sh: Remove Kconfig entries for TMU, CMT and MTU2
      ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
      clocksource: armada-370-xp: Use atomic access for shared registers
      clocksource: orion: Use atomic access for shared registers
      clocksource: timer-keystone: Delete unnecessary variable
      clocksource: timer-keystone: introduce clocksource driver for Keystone
      ...

+------------------------------------------------+------------+------------+------------+---------------+
|                                                | b6d739e958 | b97f0291a2 | 1ead658124 | next-20140707 |
+------------------------------------------------+------------+------------+------------+---------------+
| boot_successes                                 | 900        | 900        | 153        | 3             |
| boot_failures                                  | 0          | 0          | 147        | 8             |
| BUG:soft_lockup-CPU_stuck_for_s                | 0          | 0          | 147        |               |
| EIP_is_at_get_node_info                        | 0          | 0          | 47         | 3             |
| Kernel_panic-not_syncing:softlockup:hung_tasks | 0          | 0          | 147        | 8             |
| backtrace:gcov_enable_events                   | 0          | 0          | 129        | 6             |
| backtrace:gcov_fs_init                         | 0          | 0          | 129        | 6             |
| backtrace:kernel_init_freeable                 | 0          | 0          | 130        | 6             |
| EIP_is_at_arch_local_irq_restore               | 0          | 0          | 32         |               |
| EIP_is_at_arch_local_irq_enable                | 0          | 0          | 17         | 2             |
| EIP_is_at_gcov_info_filename                   | 0          | 0          | 23         |               |
| EIP_is_at_lock_release                         | 0          | 0          | 1          |               |
| EIP_is_at_strcmp                               | 0          | 0          | 20         | 2             |
| EIP_is_at_kmalloc_slab                         | 0          | 0          | 1          |               |
| EIP_is_at_string                               | 0          | 0          | 1          |               |
| EIP_is_at_debugfs_mknod                        | 0          | 0          | 1          |               |
| EIP_is_at__create_file                         | 0          | 0          | 1          |               |
| EIP_is_at_generic_permission                   | 0          | 0          | 1          |               |
| EIP_is_at__kmalloc_track_caller                | 0          | 0          | 1          |               |
| backtrace:sysfs_slab_add                       | 0          | 0          | 1          |               |
| backtrace:slab_sysfs_init                      | 0          | 0          | 1          |               |
| EIP_is_at_arch_local_save_flags                | 0          | 0          | 1          |               |
| EIP_is_at_lock_acquire                         | 0          | 0          | 0          | 1             |
+------------------------------------------------+------------+------------+------------+---------------+

[   20.765075] futex hash table entries: 16 (order: -2, 1024 bytes)
[   20.791388] Initialise system trusted keyring
[   20.791388] Initialise system trusted keyring
[   49.443855] BUG: soft lockup - CPU#1 stuck for 23s! [swapper/0:1]
[   49.443855] BUG: soft lockup - CPU#1 stuck for 23s! [swapper/0:1]
[   49.443855] irq event stamp: 966764
[   49.443855] irq event stamp: 966764
[   49.443855] hardirqs last  enabled at (966763): 
[   49.443855] hardirqs last  enabled at (966763): [<41ce9b6f>] restore_all_notrace+0x0/0x18
[<41ce9b6f>] restore_all_notrace+0x0/0x18
[   49.443855] hardirqs last disabled at (966764): 
[   49.443855] hardirqs last disabled at (966764): [<41ce9e9f>] apic_timer_interrupt+0x2f/0x3c
[<41ce9e9f>] apic_timer_interrupt+0x2f/0x3c
[   49.443855] softirqs last  enabled at (966762): 
[   49.443855] softirqs last  enabled at (966762): [<4107286d>] __do_softirq+0x33a/0x3ec
[<4107286d>] __do_softirq+0x33a/0x3ec
[   49.443855] softirqs last disabled at (966757): 
[   49.443855] softirqs last disabled at (966757): [<4100715f>] call_on_stack+0x1b/0x2f
[<4100715f>] call_on_stack+0x1b/0x2f
[   49.443855] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-00677-g1ead658 #1
[   49.443855] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-00677-g1ead658 #1
[   49.443855] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[   49.443855] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[   49.443855] task: 53098000 ti: 530a0000 task.ti: 530a0000
[   49.443855] task: 53098000 ti: 530a0000 task.ti: 530a0000
[   49.443855] EIP: 0060:[<4111ec65>] EFLAGS: 00000202 CPU: 1
[   49.443855] EIP: 0060:[<4111ec65>] EFLAGS: 00000202 CPU: 1
[   49.443855] EIP is at get_node_info+0xe/0x31
[   49.443855] EIP is at get_node_info+0xe/0x31
[   49.443855] EAX: 424ff20c EBX: 522d61e0 ECX: 00000006 EDX: 4227b069
[   49.443855] EAX: 424ff20c EBX: 522d61e0 ECX: 00000006 EDX: 4227b069
[   49.443855] ESI: 4227b069 EDI: 423e4cd4 EBP: 530a1edc ESP: 530a1edc
[   49.443855] ESI: 4227b069 EDI: 423e4cd4 EBP: 530a1edc ESP: 530a1edc
[   49.443855]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   49.443855]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   49.443855] CR0: 8005003b CR2: 00000000 CR3: 0289b000 CR4: 000006b0
[   49.443855] CR0: 8005003b CR2: 00000000 CR3: 0289b000 CR4: 000006b0
[   49.443855] Stack:
[   49.443855] Stack:
[   49.443855]  530a1eec
[   49.443855]  530a1eec 4111ecd7 4111ecd7 423e4cd4 423e4cd4 00000000 00000000 530a1f10 530a1f10 4111fc7d 4111fc7d 5297caa8 5297caa8 523d5ee0 523d5ee0

git bisect start v3.15 v3.14 --
git bisect  bad 674366e90e5a2430e3ddef40ce51512d681944e4  # 04:55      1-      2  Merge tag 'pci-v3.15-fixes-1' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
git bisect  bad 9f800363bb0ea459e15bef0928a72c88d374e489  # 05:02      4-      6  Merge tag 'fixes-non-critical-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect  bad 1aabc5990d205cdb0789a1c26143c53601e9bb07  # 05:10      0-      1  x86: Fix dumpstack_64 to keep state of "used" variable in loop
git bisect good 1694f0bb8f04837f5232f35051f40eefc4ad5402  # 05:24     40+      1  Merge branch 'x86-mm-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 0c8cfbade0e9bef5637907ed00c7b81bc86ad359  # 05:33     30-      3  Merge git://www.linux-watchdog.org/linux-watchdog
git bisect  bad 1ead65812486cda65093683a99b8907a7242fa93  # 05:42      3-      4  Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good a21e40877ad130de837b0394583e4f68dc2ab6c5  # 06:04    300+      0  Merge branch 'timers-nohz-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 99f7b025bfadd7fac5216dcfb2a08312804674c0  # 06:36    300+      0  Merge branch 'x86-threadinfo-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good b6d739e9581272f0bbbd6edd15340fb8e108df96  # 06:51    300+      0  Merge branch 'x86-iommu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 9affbd2458eca452e63b108e1a6258cf370f6eb9  # 07:19    300+      0  ARM: u300: move timer driver to clocksource
git bisect good b3e90722f6f53fa457a88146a877e34ea71d25ea  # 07:45    300+      0  clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
git bisect good 6201b4d61fbf194df6371fb3376c5026cb8f5eec  # 08:01    300+      0  timer: Remove code redundancy while calling get_nohz_timer_target()
git bisect good b712c8dae05931a76b6c17a4254f403798e6caef  # 08:09    300+      0  x86: hpet: Use proper destructor for delayed work
git bisect good b97f0291a2504291aef850077f98cab68a5a2f33  # 08:23    300+      0  tick: Remove code duplication in tick_handle_periodic()
# first bad commit: [1ead65812486cda65093683a99b8907a7242fa93] Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good b6d739e9581272f0bbbd6edd15340fb8e108df96  # 08:33    900+      0  Merge branch 'x86-iommu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good b97f0291a2504291aef850077f98cab68a5a2f33  # 08:37    900+      0  tick: Remove code duplication in tick_handle_periodic()
git bisect  bad d584f2acf5cc6c4a14c330930222d8e70fe024a6  # 08:37      0-      8  Add linux-next specific files for 20140707
git bisect good 448bfad8a185876ce8de484a921d49769972cad7  # 09:16    900+      0  Merge branch 'for-rc' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux
git bisect  bad d584f2acf5cc6c4a14c330930222d8e70fe024a6  # 09:16      0-      8  Add linux-next specific files for 20140707


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 
	-kernel $kernel
	-initrd $initrd
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Fengguang

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb44-121:20140708054746:i386-randconfig-ib1-07080328::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-00677-g1ead658 (kbuild@lkp-ib03) (gcc v=
ersion 4.8.2 (Debian 4.8.2-18) ) #1 SMP Tue Jul 8 05:40:23 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x03ffffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x03351000, 0x03351fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000f0d00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13fffc2a 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 13fff1c0 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 13ffe040 001180 (v01 BOCHS  BXPCDSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACS 13ffe000 000040
[    0.000000] ACPI: SSDT 13fff234 00093E (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 13fffb72 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 13fffbf2 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @53629000 s1337536 r0 d14144 =
u1351680
[    0.000000] pcpu-alloc: s1337536 r0 d14144 u1351680 alloc=3D330*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1362b540
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1-07080328/next:m=
aster:1ead65812486cda65093683a99b8907a7242fa93:bisect-linux/.vmlinuz-1ead65=
812486cda65093683a99b8907a7242fa93-20140708054037-280-ivb44 branch=3Dnext/m=
aster BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-07080328/1ead65812486cda6509=
3683a99b8907a7242fa93/vmlinuz-3.14.0-00677-g1ead658 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 280576K/327280K available (13227K kernel code, 2875K=
 rwdata, 6856K rodata, 2164K init, 10856K bss, 46704K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     vmalloc : 0x547fe000 - 0xffd34000   (2741 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x53ffe000   ( 319 MB)
[    0.000000]       .init : 0x42677000 - 0x42894000   (2164 kB)
[    0.000000]       .data : 0x41ceb1c2 - 0x42676cc0   (9774 kB)
[    0.000000]       .text : 0x41000000 - 0x41ceb1c2   (13228 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=3D5301a000 soft=3D5301c000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-00677-g1ead658 (kbuild@lkp-ib03) (gcc v=
ersion 4.8.2 (Debian 4.8.2-18) ) #1 SMP Tue Jul 8 05:40:23 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x03ffffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x03351000, 0x03351fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000f0d00 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13fffc2a 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 13fff1c0 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 13ffe040 001180 (v01 BOCHS  BXPCDSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACS 13ffe000 000040
[    0.000000] ACPI: SSDT 13fff234 00093E (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 13fffb72 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 13fffbf2 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @53629000 s1337536 r0 d14144 =
u1351680
[    0.000000] pcpu-alloc: s1337536 r0 d14144 u1351680 alloc=3D330*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1362b540
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1-07080328/next:m=
aster:1ead65812486cda65093683a99b8907a7242fa93:bisect-linux/.vmlinuz-1ead65=
812486cda65093683a99b8907a7242fa93-20140708054037-280-ivb44 branch=3Dnext/m=
aster BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-07080328/1ead65812486cda6509=
3683a99b8907a7242fa93/vmlinuz-3.14.0-00677-g1ead658 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 280576K/327280K available (13227K kernel code, 2875K=
 rwdata, 6856K rodata, 2164K init, 10856K bss, 46704K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     vmalloc : 0x547fe000 - 0xffd34000   (2741 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x53ffe000   ( 319 MB)
[    0.000000]       .init : 0x42677000 - 0x42894000   (2164 kB)
[    0.000000]       .data : 0x41ceb1c2 - 0x42676cc0   (9774 kB)
[    0.000000]       .text : 0x41000000 - 0x41ceb1c2   (13228 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=3D5301a000 soft=3D5301c000
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 10 of 10 active objects replaced
[    0.000000] ODEBUG: 10 of 10 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.506 MHz processor
[    0.000000] tsc: Detected 2693.506 MHz processor
[    0.009000] Calibrating delay loop (skipped) preset value..=20
[    0.009000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D2693506)
5387.01 BogoMIPS (lpj=3D2693506)
[    0.011318] pid_max: default: 4096 minimum: 301
[    0.011318] pid_max: default: 4096 minimum: 301
[    0.027106] ACPI: Core revision 20131218
[    0.027106] ACPI: Core revision 20131218
[    0.924486] ACPI:=20
[    0.924486] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.937380] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.937380] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.940146] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.940146] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.984419] Initializing cgroup subsys memory
[    0.984419] Initializing cgroup subsys memory
[    0.987291] Initializing cgroup subsys devices
[    0.987291] Initializing cgroup subsys devices
[    0.989352] Initializing cgroup subsys perf_event
[    0.989352] Initializing cgroup subsys perf_event
[    0.998206] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.998206] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.998206] tlb_flushall_shift: 6
[    0.998206] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.998206] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.998206] tlb_flushall_shift: 6
[    1.009000] Freeing SMP alternatives memory: 8K (42894000 - 42896000)
[    1.009000] Freeing SMP alternatives memory: 8K (42894000 - 42896000)
[    1.045000] Getting VERSION: 1050014
[    1.045000] Getting VERSION: 1050014
[    1.046324] Getting VERSION: 1050014
[    1.046324] Getting VERSION: 1050014
[    1.047142] Getting ID: 0
[    1.047142] Getting ID: 0
[    1.050258] Getting ID: f000000
[    1.050258] Getting ID: f000000
[    1.054104] Getting LVT0: 8700
[    1.054104] Getting LVT0: 8700
[    1.057095] Getting LVT1: 8400
[    1.057095] Getting LVT1: 8400
[    1.059116] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    1.059116] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    1.061259] enabled ExtINT on CPU#0
[    1.061259] enabled ExtINT on CPU#0
[    1.084166] ENABLING IO-APIC IRQs
[    1.084166] ENABLING IO-APIC IRQs
[    1.085519] init IO_APIC IRQs
[    1.085519] init IO_APIC IRQs
[    1.088207]  apic 0 pin 0 not connected
[    1.088207]  apic 0 pin 0 not connected
[    1.092114] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.092114] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.099093] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    1.099093] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    1.103000] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.103000] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.106228] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.106228] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.108232] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    1.108232] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    1.112174] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.112174] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.115550] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.115550] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.118199] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.118199] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.121115] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    1.121115] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    1.124260] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    1.124260] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    1.130181] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    1.130181] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    1.133351] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.133351] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.135334] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    1.135334] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    1.137544] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    1.137544] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    1.140216] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    1.140216] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    1.142394]  apic 0 pin 16 not connected
[    1.142394]  apic 0 pin 16 not connected
[    1.143126]  apic 0 pin 17 not connected
[    1.143126]  apic 0 pin 17 not connected
[    1.145149]  apic 0 pin 18 not connected
[    1.145149]  apic 0 pin 18 not connected
[    1.147000]  apic 0 pin 19 not connected
[    1.147000]  apic 0 pin 19 not connected
[    1.148203]  apic 0 pin 20 not connected
[    1.148203]  apic 0 pin 20 not connected
[    1.150106]  apic 0 pin 21 not connected
[    1.150106]  apic 0 pin 21 not connected
[    1.152124]  apic 0 pin 22 not connected
[    1.152124]  apic 0 pin 22 not connected
[    1.154000]  apic 0 pin 23 not connected
[    1.154000]  apic 0 pin 23 not connected
[    1.156000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    1.156000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    1.156174] smpboot: CPU0:=20
[    1.156174] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    1.165149] Using local APIC timer interrupts.
[    1.165149] calibrating APIC timer ...
[    1.165149] Using local APIC timer interrupts.
[    1.165149] calibrating APIC timer ...
[    1.168000] ... lapic delta =3D 14114788
[    1.168000] ... lapic delta =3D 14114788
[    1.168000] ... PM-Timer delta =3D 808670
[    1.168000] ... PM-Timer delta =3D 808670
[    1.168000] APIC calibration not consistent with PM-Timer: 225ms instead=
 of 100ms
[    1.168000] APIC calibration not consistent with PM-Timer: 225ms instead=
 of 100ms
[    1.168000] APIC delta adjusted to PM-Timer: 6247845 (14114788)
[    1.168000] APIC delta adjusted to PM-Timer: 6247845 (14114788)
[    1.168000] TSC delta adjusted to PM-Timer: 269359951 (608523195)
[    1.168000] TSC delta adjusted to PM-Timer: 269359951 (608523195)
[    1.168000] ..... delta 6247845
[    1.168000] ..... delta 6247845
[    1.168000] ..... mult: 268342899
[    1.168000] ..... mult: 268342899
[    1.168000] ..... calibration result: 999655
[    1.168000] ..... calibration result: 999655
[    1.168000] ..... CPU clock speed is 2693.0599 MHz.
[    1.168000] ..... CPU clock speed is 2693.0599 MHz.
[    1.168000] ..... host bus clock speed is 999.0655 MHz.
[    1.168000] ..... host bus clock speed is 999.0655 MHz.
[    1.170000] Performance Events:=20
[    1.170000] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    1.376724] NMI watchdog: disabled (cpu0): hardware events not enabled
[    1.376724] NMI watchdog: disabled (cpu0): hardware events not enabled
[    1.397381] CPU 1 irqstacks, hard=3D53228000 soft=3D5322a000
[    1.397381] CPU 1 irqstacks, hard=3D53228000 soft=3D5322a000
[    1.399357] x86: Booting SMP configuration:
[    1.399357] x86: Booting SMP configuration:
[    1.400309] .... node  #0, CPUs: =20
[    1.400309] .... node  #0, CPUs:         #1 #1
[    0.009000] Initializing CPU#1
[    0.009000] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.009000] masked ExtINT on CPU#1
[    1.441210] x86: Booted up 1 node, 2 CPUs
[    1.441210] x86: Booted up 1 node, 2 CPUs
[    1.437147] KVM setup async PF for cpu 1
[    1.437147] KVM setup async PF for cpu 1
[    1.437147] kvm-stealtime: cpu 1, msr 13775540
[    1.437147] kvm-stealtime: cpu 1, msr 13775540
[    1.442116] smpboot: Total of 2 processors activated (10774.02 BogoMIPS)
[    1.442116] smpboot: Total of 2 processors activated (10774.02 BogoMIPS)
[    1.466110] devtmpfs: initialized
[    1.466110] devtmpfs: initialized
[    1.501098] gcov: version magic: 0x3430382a
[    1.501098] gcov: version magic: 0x3430382a
[    1.586235] prandom: seed boundary self test passed
[    1.586235] prandom: seed boundary self test passed
[    1.614280] prandom: 100 self tests passed
[    1.614280] prandom: 100 self tests passed
[    1.615134] atomic64 test passed for i586+ platform with CX8 and with SSE
[    1.615134] atomic64 test passed for i586+ platform with CX8 and with SSE
[    1.618059] pinctrl core: initialized pinctrl subsystem
[    1.618059] pinctrl core: initialized pinctrl subsystem
[    1.659333] regulator-dummy: no parameters
[    1.659333] regulator-dummy: no parameters
[    1.684623] NET: Registered protocol family 16
[    1.684623] NET: Registered protocol family 16
[    1.793185] cpuidle: using governor ladder
[    1.793185] cpuidle: using governor ladder
[    1.795124] cpuidle: using governor menu
[    1.795124] cpuidle: using governor menu
[    1.854477] ACPI: bus type PCI registered
[    1.854477] ACPI: bus type PCI registered
[    1.855102] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.855102] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.859429] PCI: Using configuration type 1 for base access
[    1.859429] PCI: Using configuration type 1 for base access
[    4.617697] ACPI: Added _OSI(Module Device)
[    4.617697] ACPI: Added _OSI(Module Device)
[    4.618196] ACPI: Added _OSI(Processor Device)
[    4.618196] ACPI: Added _OSI(Processor Device)
[    4.619117] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.619117] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.620187] ACPI: Added _OSI(Processor Aggregator Device)
[    4.620187] ACPI: Added _OSI(Processor Aggregator Device)
[    5.356641] ACPI: Interpreter enabled
[    5.356641] ACPI: Interpreter enabled
[    5.358426] ACPI: (supports S0 S5)
[    5.358426] ACPI: (supports S0 S5)
[    5.359065] ACPI: Using IOAPIC for interrupt routing
[    5.359065] ACPI: Using IOAPIC for interrupt routing
[    5.363275] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    5.363275] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    5.510515] ACPI: No dock devices found.
[    5.510515] ACPI: No dock devices found.
[    7.612205] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    7.612205] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    7.614388] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    7.614388] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    7.617571] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    7.617571] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    7.706071] acpiphp: Slot [3] registered
[    7.706071] acpiphp: Slot [3] registered
[    7.726054] acpiphp: Slot [4] registered
[    7.726054] acpiphp: Slot [4] registered
[    7.738880] acpiphp: Slot [5] registered
[    7.738880] acpiphp: Slot [5] registered
[    7.757423] acpiphp: Slot [6] registered
[    7.757423] acpiphp: Slot [6] registered
[    7.765643] acpiphp: Slot [7] registered
[    7.765643] acpiphp: Slot [7] registered
[    7.773770] acpiphp: Slot [8] registered
[    7.773770] acpiphp: Slot [8] registered
[    7.782801] acpiphp: Slot [9] registered
[    7.782801] acpiphp: Slot [9] registered
[    7.797214] acpiphp: Slot [10] registered
[    7.797214] acpiphp: Slot [10] registered
[    7.808189] acpiphp: Slot [11] registered
[    7.808189] acpiphp: Slot [11] registered
[    7.820203] acpiphp: Slot [12] registered
[    7.820203] acpiphp: Slot [12] registered
[    7.832180] acpiphp: Slot [13] registered
[    7.832180] acpiphp: Slot [13] registered
[    7.851274] acpiphp: Slot [14] registered
[    7.851274] acpiphp: Slot [14] registered
[    7.873345] acpiphp: Slot [15] registered
[    7.873345] acpiphp: Slot [15] registered
[    7.887541] acpiphp: Slot [16] registered
[    7.887541] acpiphp: Slot [16] registered
[    7.897643] acpiphp: Slot [17] registered
[    7.897643] acpiphp: Slot [17] registered
[    7.925146] acpiphp: Slot [18] registered
[    7.925146] acpiphp: Slot [18] registered
[    7.944832] acpiphp: Slot [19] registered
[    7.944832] acpiphp: Slot [19] registered
[    7.961279] acpiphp: Slot [20] registered
[    7.961279] acpiphp: Slot [20] registered
[    7.989301] acpiphp: Slot [21] registered
[    7.989301] acpiphp: Slot [21] registered
[    8.006520] acpiphp: Slot [22] registered
[    8.006520] acpiphp: Slot [22] registered
[    8.020217] acpiphp: Slot [23] registered
[    8.020217] acpiphp: Slot [23] registered
[    8.030055] acpiphp: Slot [24] registered
[    8.030055] acpiphp: Slot [24] registered
[    8.041173] acpiphp: Slot [25] registered
[    8.041173] acpiphp: Slot [25] registered
[    8.051121] acpiphp: Slot [26] registered
[    8.051121] acpiphp: Slot [26] registered
[    8.062132] acpiphp: Slot [27] registered
[    8.062132] acpiphp: Slot [27] registered
[    8.068836] acpiphp: Slot [28] registered
[    8.068836] acpiphp: Slot [28] registered
[    8.085265] acpiphp: Slot [29] registered
[    8.085265] acpiphp: Slot [29] registered
[    8.116413] acpiphp: Slot [30] registered
[    8.116413] acpiphp: Slot [30] registered
[    8.127122] acpiphp: Slot [31] registered
[    8.127122] acpiphp: Slot [31] registered
[    8.129161] PCI host bridge to bus 0000:00
[    8.129161] PCI host bridge to bus 0000:00
[    8.131172] pci_bus 0000:00: root bus resource [bus 00-ff]
[    8.131172] pci_bus 0000:00: root bus resource [bus 00-ff]
[    8.133098] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    8.133098] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    8.135102] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    8.135102] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    8.136356] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    8.136356] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    8.137276] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    8.137276] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    8.138184] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    8.138184] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    8.140181] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    8.140181] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    8.141217] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    8.141217] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    8.143476] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    8.143476] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    8.175594] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    8.175594] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    8.197225] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    8.197225] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    8.212081] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    8.212081] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    8.234571] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    8.234571] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    8.238642] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    8.238642] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    8.240337] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    8.240337] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    8.266308] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    8.266308] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    8.271162] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    8.271162] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    8.278142] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    8.278142] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    8.298000] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    8.298000] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    8.319217] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    8.319217] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    8.325083] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    8.325083] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    8.328096] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    8.328096] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    8.350107] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    8.350107] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    8.380407] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    8.380407] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    8.385085] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    8.385085] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    8.444293] pci_bus 0000:00: on NUMA node 0
[    8.444293] pci_bus 0000:00: on NUMA node 0
[    8.551818] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    8.551818] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    8.586869] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    8.586869] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    8.621414] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    8.621414] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    8.650082] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    8.650082] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    8.664384] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    8.664384] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    8.736000] ACPI:=20
[    8.736000] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    8.806000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    8.806000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    8.806140] vgaarb: loaded
[    8.806140] vgaarb: loaded
[    8.807066] vgaarb: bridge control possible 0000:00:02.0
[    8.807066] vgaarb: bridge control possible 0000:00:02.0
[    8.863133] ACPI: bus type USB registered
[    8.863133] ACPI: bus type USB registered
[    8.868515] usbcore: registered new interface driver usbfs
[    8.868515] usbcore: registered new interface driver usbfs
[    8.871685] usbcore: registered new interface driver hub
[    8.871685] usbcore: registered new interface driver hub
[    8.876258] usbcore: registered new device driver usb
[    8.876258] usbcore: registered new device driver usb
[    8.910206] wmi: Mapper loaded
[    8.910206] wmi: Mapper loaded
[    8.932744] Advanced Linux Sound Architecture Driver Initialized.
[    8.932744] Advanced Linux Sound Architecture Driver Initialized.
[    8.933136] PCI: Using ACPI for IRQ routing
[    8.933136] PCI: Using ACPI for IRQ routing
[    8.934088] PCI: pci_cache_line_size set to 64 bytes
[    8.934088] PCI: pci_cache_line_size set to 64 bytes
[    8.939227] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    8.939227] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    8.940446] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    8.940446] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    8.982229] Switched to clocksource kvm-clock
[    8.982229] Switched to clocksource kvm-clock
[    9.031417] pnp: PnP ACPI init
[    9.031417] pnp: PnP ACPI init
[    9.053499] ACPI: bus type PNP registered
[    9.053499] ACPI: bus type PNP registered
[    9.079039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    9.079039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    9.142514] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    9.142514] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    9.223074] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    9.223074] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    9.279591] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    9.279591] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    9.314963] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    9.314963] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    9.409661] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    9.409661] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    9.483106] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    9.483106] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    9.574627] pnp 00:03: [dma 2]
[    9.574627] pnp 00:03: [dma 2]
[    9.631293] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    9.631293] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    9.703894] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    9.703894] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    9.777068] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    9.777068] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    9.833531] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    9.833531] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    9.896484] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    9.896484] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   10.091307] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   10.091307] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   10.182013] pnp: PnP ACPI: found 7 devices
[   10.182013] pnp: PnP ACPI: found 7 devices
[   10.203622] ACPI: bus type PNP unregistered
[   10.203622] ACPI: bus type PNP unregistered
[   10.454065] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   10.454065] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   10.504156] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[   10.504156] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[   10.573624] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[   10.573624] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[   10.609932] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[   10.609932] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[   10.657220] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[   10.657220] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[   10.686887] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[   10.686887] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[   10.717563] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[   10.717563] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[   10.769170] NET: Registered protocol family 1
[   10.769170] NET: Registered protocol family 1
[   10.817961] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   10.817961] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   10.850459] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   10.850459] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   10.906909] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   10.906909] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   10.936165] pci 0000:00:02.0: Boot video device
[   10.936165] pci 0000:00:02.0: Boot video device
[   10.961348] PCI: CLS 0 bytes, default 64
[   10.961348] PCI: CLS 0 bytes, default 64
[   11.048355] Unpacking initramfs...
[   11.048355] Unpacking initramfs...
[   19.279676] Freeing initrd memory: 3276K (53cbd000 - 53ff0000)
[   19.279676] Freeing initrd memory: 3276K (53cbd000 - 53ff0000)
[   19.514187] Scanning for low memory corruption every 60 seconds
[   19.514187] Scanning for low memory corruption every 60 seconds
[   19.560319] cryptomgr_test (27) used greatest stack depth: 6924 bytes le=
ft
[   19.560319] cryptomgr_test (27) used greatest stack depth: 6924 bytes le=
ft
[   19.747519] cryptomgr_probe (34) used greatest stack depth: 6784 bytes l=
eft
[   19.747519] cryptomgr_probe (34) used greatest stack depth: 6784 bytes l=
eft
[   19.811318] cryptomgr_test (33) used greatest stack depth: 5804 bytes le=
ft
[   19.811318] cryptomgr_test (33) used greatest stack depth: 5804 bytes le=
ft
[   19.856407] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[   19.856407] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[   19.943976] NatSemi SCx200 Driver
[   19.943976] NatSemi SCx200 Driver
[   20.005763] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[   20.005763] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[   20.145910] spin_lock-torture: Creating torture_shuffle task
[   20.145910] spin_lock-torture: Creating torture_shuffle task
[   20.177732] spin_lock-torture: Creating torture_stutter task
[   20.177732] spin_lock-torture: Creating torture_stutter task
[   20.205729] spin_lock-torture: torture_shuffle task started
[   20.205729] spin_lock-torture: torture_shuffle task started
[   20.254082] spin_lock-torture: Creating lock_torture_writer task
[   20.254082] spin_lock-torture: Creating lock_torture_writer task
[   20.260792] spin_lock-torture: torture_stutter task started
[   20.260792] spin_lock-torture: torture_stutter task started
[   20.287786] spin_lock-torture: lock_torture_writer task started
[   20.287786] spin_lock-torture: lock_torture_writer task started
[   20.288040] spin_lock-torture: Creating lock_torture_writer task
[   20.288040] spin_lock-torture: Creating lock_torture_writer task
[   20.385078] spin_lock-torture: Creating lock_torture_writer task
[   20.385078] spin_lock-torture: Creating lock_torture_writer task
[   20.430171] spin_lock-torture: lock_torture_writer task started
[   20.430171] spin_lock-torture: lock_torture_writer task started
[   20.477873] spin_lock-torture: lock_torture_writer task started
[   20.477873] spin_lock-torture: lock_torture_writer task started
[   20.502360] spin_lock-torture: Creating lock_torture_writer task
[   20.502360] spin_lock-torture: Creating lock_torture_writer task
[   20.573767] spin_lock-torture: lock_torture_writer task started
[   20.573767] spin_lock-torture: lock_torture_writer task started
[   20.627574] spin_lock-torture: Creating lock_torture_stats task
[   20.627574] spin_lock-torture: Creating lock_torture_stats task
[   20.765075] futex hash table entries: 16 (order: -2, 1024 bytes)
[   20.765075] futex hash table entries: 16 (order: -2, 1024 bytes)
[   20.791388] Initialise system trusted keyring
[   20.791388] Initialise system trusted keyring
[   49.443855] BUG: soft lockup - CPU#1 stuck for 23s! [swapper/0:1]
[   49.443855] BUG: soft lockup - CPU#1 stuck for 23s! [swapper/0:1]
[   49.443855] irq event stamp: 966764
[   49.443855] irq event stamp: 966764
[   49.443855] hardirqs last  enabled at (966763):=20
[   49.443855] hardirqs last  enabled at (966763): [<41ce9b6f>] restore_all=
_notrace+0x0/0x18
[<41ce9b6f>] restore_all_notrace+0x0/0x18
[   49.443855] hardirqs last disabled at (966764):=20
[   49.443855] hardirqs last disabled at (966764): [<41ce9e9f>] apic_timer_=
interrupt+0x2f/0x3c
[<41ce9e9f>] apic_timer_interrupt+0x2f/0x3c
[   49.443855] softirqs last  enabled at (966762):=20
[   49.443855] softirqs last  enabled at (966762): [<4107286d>] __do_softir=
q+0x33a/0x3ec
[<4107286d>] __do_softirq+0x33a/0x3ec
[   49.443855] softirqs last disabled at (966757):=20
[   49.443855] softirqs last disabled at (966757): [<4100715f>] call_on_sta=
ck+0x1b/0x2f
[<4100715f>] call_on_stack+0x1b/0x2f
[   49.443855] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-00677-g1ead=
658 #1
[   49.443855] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-00677-g1ead=
658 #1
[   49.443855] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[   49.443855] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[   49.443855] task: 53098000 ti: 530a0000 task.ti: 530a0000
[   49.443855] task: 53098000 ti: 530a0000 task.ti: 530a0000
[   49.443855] EIP: 0060:[<4111ec65>] EFLAGS: 00000202 CPU: 1
[   49.443855] EIP: 0060:[<4111ec65>] EFLAGS: 00000202 CPU: 1
[   49.443855] EIP is at get_node_info+0xe/0x31
[   49.443855] EIP is at get_node_info+0xe/0x31
[   49.443855] EAX: 424ff20c EBX: 522d61e0 ECX: 00000006 EDX: 4227b069
[   49.443855] EAX: 424ff20c EBX: 522d61e0 ECX: 00000006 EDX: 4227b069
[   49.443855] ESI: 4227b069 EDI: 423e4cd4 EBP: 530a1edc ESP: 530a1edc
[   49.443855] ESI: 4227b069 EDI: 423e4cd4 EBP: 530a1edc ESP: 530a1edc
[   49.443855]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   49.443855]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   49.443855] CR0: 8005003b CR2: 00000000 CR3: 0289b000 CR4: 000006b0
[   49.443855] CR0: 8005003b CR2: 00000000 CR3: 0289b000 CR4: 000006b0
[   49.443855] Stack:
[   49.443855] Stack:
[   49.443855]  530a1eec
[   49.443855]  530a1eec 4111ecd7 4111ecd7 423e4cd4 423e4cd4 00000000 00000=
000 530a1f10 530a1f10 4111fc7d 4111fc7d 5297caa8 5297caa8 523d5ee0 523d5ee0

[   49.443855]  00000000
[   49.443855]  00000000 423e4cd4 423e4cd4 423e4cd4 423e4cd4 00000000 00000=
000 530a1f98 530a1f98 530a1f1c 530a1f1c 4111ec0b 4111ec0b 4269e5fb 4269e5fb

[   49.443855]  530a1f24
[   49.443855]  530a1f24 4269e6a0 4269e6a0 530a1f88 530a1f88 426786b3 42678=
6b3 426776ac 426776ac 53ff680a 53ff680a 42677600 42677600 530a1f78 530a1f78

[   49.443855] Call Trace:
[   49.443855] Call Trace:
[   49.443855]  [<4111ecd7>] get_node_by_name+0x3a/0xa6
[   49.443855]  [<4111ecd7>] get_node_by_name+0x3a/0xa6
[   49.443855]  [<4111fc7d>] gcov_event+0x52/0x718
[   49.443855]  [<4111fc7d>] gcov_event+0x52/0x718
[   49.443855]  [<4111ec0b>] gcov_enable_events+0x5c/0x95
[   49.443855]  [<4111ec0b>] gcov_enable_events+0x5c/0x95
[   49.443855]  [<4269e5fb>] ? gcov_persist_setup+0x8b/0x8b
[   49.443855]  [<4269e5fb>] ? gcov_persist_setup+0x8b/0x8b
[   49.443855]  [<4269e6a0>] gcov_fs_init+0xa5/0x101
[   49.443855]  [<4269e6a0>] gcov_fs_init+0xa5/0x101
[   49.443855]  [<426786b3>] do_one_initcall+0x133/0x264
[   49.443855]  [<426786b3>] do_one_initcall+0x133/0x264
[   49.443855]  [<426776ac>] ? repair_env_string+0x32/0xd3
[   49.443855]  [<426776ac>] ? repair_env_string+0x32/0xd3
[   49.443855]  [<42677600>] ? do_early_param+0xae/0x128
[   49.443855]  [<42677600>] ? do_early_param+0xae/0x128
[   49.443855]  [<41097c5b>] ? parse_args+0x41a/0x5cf
[   49.443855]  [<41097c5b>] ? parse_args+0x41a/0x5cf
[   49.443855]  [<4267767a>] ? do_early_param+0x128/0x128
[   49.443855]  [<4267767a>] ? do_early_param+0x128/0x128
[   49.443855]  [<42678c99>] kernel_init_freeable+0x4b5/0x610
[   49.443855]  [<42678c99>] kernel_init_freeable+0x4b5/0x610
[   49.443855]  [<42678c99>] ? kernel_init_freeable+0x4b5/0x610
[   49.443855]  [<42678c99>] ? kernel_init_freeable+0x4b5/0x610
[   49.443855]  [<41cc4ee9>] kernel_init+0x16/0x1fa
[   49.443855]  [<41cc4ee9>] kernel_init+0x16/0x1fa
[   49.443855]  [<41cea281>] ret_from_kernel_thread+0x21/0x30
[   49.443855]  [<41cea281>] ret_from_kernel_thread+0x21/0x30
[   49.443855]  [<41cc4ed3>] ? rest_init+0x1cb/0x1cb
[   49.443855]  [<41cc4ed3>] ? rest_init+0x1cb/0x1cb
[   49.443855] Code:
[   49.443855] Code: 5b 5b 83 83 15 15 74 74 aa aa e5 e5 42 42 00 00 5d 5d =
c3 c3 83 83 05 05 c8 c8 ad ad e5 e5 42 42 01 01 55 55 89 89 e5 e5 83 83 15 =
15 cc cc ad ad e5 e5 42 42 00 00 5d 5d c3 c3 55 55 83 83 78 78 2c 2c 00 00 =
89 89 e5 e5 7e 7e 15 15 8b 8b 40 40 1c 1c 8b 8b 00 00 <83> <83> 05 05 d0 d0=
 ad ad e5 e5 42 42 01 01 83 83 15 15 d4 d4 ad ad e5 e5 42 42 00 00 eb eb 11=
 11 83 83 05 05 d8 d8 ad ad e5 e5

[   49.443855] Kernel panic - not syncing: softlockup: hung tasks
[   49.443855] Kernel panic - not syncing: softlockup: hung tasks
[   49.443855] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-00677-g1ead=
658 #1
[   49.443855] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-00677-g1ead=
658 #1
[   49.443855] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[   49.443855] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[   49.443855]  00000000
[   49.443855]  00000000 530a1dc0 530a1dc0 41cd10bb 41cd10bb 53098000 53098=
000 530a1dd8 530a1dd8 41ccc444 41ccc444 410e033e 410e033e 53098000 53098000

[   49.443855]  530a1ea0
[   49.443855]  530a1ea0 00000017 00000017 530a1df8 530a1df8 41121a2d 41121=
a2d 4228391c 4228391c ee6b2800 ee6b2800 00000000 00000000 538b5d5c 538b5d5c

[   49.443855]  537755e4
[   49.443855]  537755e4 537755e4 537755e4 530a1e44 530a1e44 4109ff00 4109f=
f00 537756a4 537756a4 00000000 00000000 411217db 411217db 0000000b 0000000b

[   49.443855] Call Trace:
[   49.443855] Call Trace:
[   49.443855]  [<41cd10bb>] dump_stack+0xf3/0x143
[   49.443855]  [<41cd10bb>] dump_stack+0xf3/0x143
[   49.443855]  [<41ccc444>] panic+0x174/0x3f4
[   49.443855]  [<41ccc444>] panic+0x174/0x3f4
[   49.443855]  [<410e033e>] ? console_unlock+0x5ee/0x66f
[   49.443855]  [<410e033e>] ? console_unlock+0x5ee/0x66f
[   49.443855]  [<41121a2d>] watchdog_timer_fn+0x252/0x28d
[   49.443855]  [<41121a2d>] watchdog_timer_fn+0x252/0x28d
[   49.443855]  [<4109ff00>] hrtimer_run_queues+0x2c4/0x3f1
[   49.443855]  [<4109ff00>] hrtimer_run_queues+0x2c4/0x3f1
[   49.443855]  [<411217db>] ? watchdog+0x32/0x32
[   49.443855]  [<411217db>] ? watchdog+0x32/0x32
[   49.443855]  [<4107d00d>] run_local_timers+0x16/0x3e
[   49.443855]  [<4107d00d>] run_local_timers+0x16/0x3e
[   49.443855]  [<4107d075>] update_process_times+0x40/0xc0
[   49.443855]  [<4107d075>] update_process_times+0x40/0xc0
[   49.443855]  [<41100fa6>] tick_periodic+0x1cf/0x1df
[   49.443855]  [<41100fa6>] tick_periodic+0x1cf/0x1df
[   49.443855]  [<41101061>] tick_handle_periodic+0x2b/0xd2
[   49.443855]  [<41101061>] tick_handle_periodic+0x2b/0xd2
[   49.443855]  [<41044c57>] local_apic_timer_interrupt+0x79/0x8c
[   49.443855]  [<41044c57>] local_apic_timer_interrupt+0x79/0x8c
[   49.443855]  [<410454d9>] smp_apic_timer_interrupt+0x37/0x62
[   49.443855]  [<410454d9>] smp_apic_timer_interrupt+0x37/0x62
[   49.443855]  [<41ce9ea6>] apic_timer_interrupt+0x36/0x3c
[   49.443855]  [<41ce9ea6>] apic_timer_interrupt+0x36/0x3c
[   49.443855]  [<412a00e0>] ? sha_transform+0x22/0x11bb
[   49.443855]  [<412a00e0>] ? sha_transform+0x22/0x11bb
[   49.443855]  [<4111ec65>] ? get_node_info+0xe/0x31
[   49.443855]  [<4111ec65>] ? get_node_info+0xe/0x31
[   49.443855]  [<4111ecd7>] get_node_by_name+0x3a/0xa6
[   49.443855]  [<4111ecd7>] get_node_by_name+0x3a/0xa6
[   49.443855]  [<4111fc7d>] gcov_event+0x52/0x718
[   49.443855]  [<4111fc7d>] gcov_event+0x52/0x718
[   49.443855]  [<4111ec0b>] gcov_enable_events+0x5c/0x95
[   49.443855]  [<4111ec0b>] gcov_enable_events+0x5c/0x95
[   49.443855]  [<4269e5fb>] ? gcov_persist_setup+0x8b/0x8b
[   49.443855]  [<4269e5fb>] ? gcov_persist_setup+0x8b/0x8b
[   49.443855]  [<4269e6a0>] gcov_fs_init+0xa5/0x101
[   49.443855]  [<4269e6a0>] gcov_fs_init+0xa5/0x101
[   49.443855]  [<426786b3>] do_one_initcall+0x133/0x264
[   49.443855]  [<426786b3>] do_one_initcall+0x133/0x264
[   49.443855]  [<426776ac>] ? repair_env_string+0x32/0xd3
[   49.443855]  [<426776ac>] ? repair_env_string+0x32/0xd3
[   49.443855]  [<42677600>] ? do_early_param+0xae/0x128
[   49.443855]  [<42677600>] ? do_early_param+0xae/0x128
[   49.443855]  [<41097c5b>] ? parse_args+0x41a/0x5cf
[   49.443855]  [<41097c5b>] ? parse_args+0x41a/0x5cf
[   49.443855]  [<4267767a>] ? do_early_param+0x128/0x128
[   49.443855]  [<4267767a>] ? do_early_param+0x128/0x128
[   49.443855]  [<42678c99>] kernel_init_freeable+0x4b5/0x610
[   49.443855]  [<42678c99>] kernel_init_freeable+0x4b5/0x610
[   49.443855]  [<42678c99>] ? kernel_init_freeable+0x4b5/0x610
[   49.443855]  [<42678c99>] ? kernel_init_freeable+0x4b5/0x610
[   49.443855]  [<41cc4ee9>] kernel_init+0x16/0x1fa
[   49.443855]  [<41cc4ee9>] kernel_init+0x16/0x1fa
[   49.443855]  [<41cea281>] ret_from_kernel_thread+0x21/0x30
[   49.443855]  [<41cea281>] ret_from_kernel_thread+0x21/0x30
[   49.443855]  [<41cc4ed3>] ? rest_init+0x1cb/0x1cb
[   49.443855]  [<41cc4ed3>] ? rest_init+0x1cb/0x1cb
[   49.443855] Kernel Offset: 0x0 from 0x41000000 (relocation range: 0x4000=
0000-0x547fdfff)
[   49.443855] Kernel Offset: 0x0 from 0x41000000 (relocation range: 0x4000=
0000-0x547fdfff)

Elapsed time: 85
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-i=
b1-07080328/1ead65812486cda65093683a99b8907a7242fa93/vmlinuz-3.14.0-00677-g=
1ead658 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuil=
d-tests/run-queue/kvm/i386-randconfig-ib1-07080328/next:master:1ead65812486=
cda65093683a99b8907a7242fa93:bisect-linux/.vmlinuz-1ead65812486cda65093683a=
99b8907a7242fa93-20140708054037-280-ivb44 branch=3Dnext/master BOOT_IMAGE=
=3D/kernel/i386-randconfig-ib1-07080328/1ead65812486cda65093683a99b8907a724=
2fa93/vmlinuz-3.14.0-00677-g1ead658 drbd.minor_count=3D8'  -initrd /kernel-=
tests/initrd/yocto-minimal-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=
=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb =
-rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-ivb44-121 -serial f=
ile:/dev/shm/kboot/serial-yocto-ivb44-121 -daemonize -display none -monitor=
 null=20

--Kj7319i9nmIyA2yE
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-ib1-07080328-d584f2acf5cc6c4a14c330930222d8e70fe024a6-EIP-is-at-get_node_info+-x-73543.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgZDU4NGYyYS4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA3MDcKZ2l0IGNoZWNrb3V0IDkyZjY4ODZjMTM1NDQzNzlmOWEyMjA3NzM0
N2E4MzQ3YTkyYTJlNjIKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvbmV4dDptYXN0ZXI6OTJmNjg4NmMxMzU0NDM3OWY5
YTIyMDc3MzQ3YTgzNDdhOTJhMmU2MjpiaXNlY3QtbGludXgKCjIwMTQtMDctMDgtMDM6NDc6
MDUgOTJmNjg4NmMxMzU0NDM3OWY5YTIyMDc3MzQ3YTgzNDdhOTJhMmU2MiBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctaWIxLTA3MDgwMzI4LTkyZjY4ODZjMTM1NDQzNzlmOWEyMjA3NzM0N2E4MzQ3
YTkyYTJlNjIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcwODAzMjgvOTJmNjg4NmMxMzU0NDM3OWY5YTIyMDc3MzQ3YTgzNDdhOTJhMmU2Mgp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC05MmY2ODg2YzEzNTQ0Mzc5ZjlhMjIwNzczNDdh
ODM0N2E5MmEyZTYyCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgw
MzI4LzkyZjY4ODZjMTM1NDQzNzlmOWEyMjA3NzM0N2E4MzQ3YTkyYTJlNjIvdm1saW51ei0z
LjE2LjAtcmM0LTAzNjYzLWc5MmY2ODg2CgoyMDE0LTA3LTA4LTAzOjUwOjA1IGRldGVjdGlu
ZyBib290IHN0YXRlIC4uLi4uIFRFU1QgRkFJTFVSRQpbICAgMTguNzQ0NDIzXSBmdXRleCBo
YXNoIHRhYmxlIGVudHJpZXM6IDE2IChvcmRlcjogLTIsIDEwMjQgYnl0ZXMpClsgICAxOC44
NDc0NjVdIEluaXRpYWxpc2Ugc3lzdGVtIHRydXN0ZWQga2V5cmluZwpbICAgMTguODQ3NDY1
XSBJbml0aWFsaXNlIHN5c3RlbSB0cnVzdGVkIGtleXJpbmcKWyAgIDQ0LjkzODM0Ml0gQlVH
OiBzb2Z0IGxvY2t1cCAtIENQVSMxIHN0dWNrIGZvciAyMnMhIFtzd2FwcGVyLzA6MV0KWyAg
IDQ0LjkzODM0Ml0gQlVHOiBzb2Z0IGxvY2t1cCAtIENQVSMxIHN0dWNrIGZvciAyMnMhIFtz
d2FwcGVyLzA6MV0KWyAgIDQ0LjkzODM0Ml0gaXJxIGV2ZW50IHN0YW1wOiA4NjQ2NzYKWyAg
IDQ0LjkzODM0Ml0gaXJxIGV2ZW50IHN0YW1wOiA4NjQ2NzYKWyAgIDQ0LjkzODM0Ml0gaGFy
ZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoODY0Njc1KTogClsgICA0NC45MzgzNDJdIGhhcmRp
cnFzIGxhc3QgIGVuYWJsZWQgYXQgKDg2NDY3NSk6IFs8NDFkNmY1NDM+XSByZXN0b3JlX2Fs
bF9ub3RyYWNlKzB4MC8weDE4Cls8NDFkNmY1NDM+XSByZXN0b3JlX2FsbF9ub3RyYWNlKzB4
MC8weDE4ClsgICA0NC45MzgzNDJdIGhhcmRpcnFzIGxhc3QgZGlzYWJsZWQgYXQgKDg2NDY3
Nik6IApbICAgNDQuOTM4MzQyXSBoYXJkaXJxcyBsYXN0IGRpc2FibGVkIGF0ICg4NjQ2NzYp
OiBbPDQxZDZmY2NiPl0gYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgyZi8weDNjCls8NDFkNmZj
Y2I+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDJmLzB4M2MKWyAgIDQ0LjkzODM0Ml0gc29m
dGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoODY0Njc0KTogClsgICA0NC45MzgzNDJdIHNvZnRp
cnFzIGxhc3QgIGVuYWJsZWQgYXQgKDg2NDY3NCk6IFs8NDEwNzE0YTI+XSBfX2RvX3NvZnRp
cnErMHgzMzcvMHgzZTkKWzw0MTA3MTRhMj5dIF9fZG9fc29mdGlycSsweDMzNy8weDNlOQpb
ICAgNDQuOTM4MzQyXSBzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0ICg4NjQ2NjkpOiAKWyAg
IDQ0LjkzODM0Ml0gc29mdGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoODY0NjY5KTogWzw0MTAw
NmYwNz5dIGNhbGxfb25fc3RhY2srMHgxYi8weDJmCls8NDEwMDZmMDc+XSBjYWxsX29uX3N0
YWNrKzB4MWIvMHgyZgpbICAgNDQuOTM4MzQyXSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBw
ZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM0LTAzNjYzLWc5MmY2ODg2ICMxClsgICA0NC45
MzgzNDJdIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTYu
MC1yYzQtMDM2NjMtZzkyZjY4ODYgIzEKWyAgIDQ0LjkzODM0Ml0gSGFyZHdhcmUgbmFtZTog
UUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEv
MDEvMjAxMQpbICAgNDQuOTM4MzQyXSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBD
IChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICA0NC45
MzgzNDJdIHRhc2s6IDUzMGEwMDAwIHRpOiA1MzBhODAwMCB0YXNrLnRpOiA1MzBhODAwMApb
ICAgNDQuOTM4MzQyXSB0YXNrOiA1MzBhMDAwMCB0aTogNTMwYTgwMDAgdGFzay50aTogNTMw
YTgwMDAKWyAgIDQ0LjkzODM0Ml0gRUlQOiAwMDYwOls8NDExMjE3OGQ+XSBFRkxBR1M6IDAw
MDAwMjAyIENQVTogMQpbICAgNDQuOTM4MzQyXSBFSVA6IDAwNjA6Wzw0MTEyMTc4ZD5dIEVG
TEFHUzogMDAwMDAyMDIgQ1BVOiAxClsgICA0NC45MzgzNDJdIEVJUCBpcyBhdCBnZXRfbm9k
ZV9pbmZvKzB4ZS8weDMxClsgICA0NC45MzgzNDJdIEVJUCBpcyBhdCBnZXRfbm9kZV9pbmZv
KzB4ZS8weDMxClsgICA0NC45MzgzNDJdIEVBWDogNDI1ZGI0MGMgRUJYOiA1MjMwOTY2MCBF
Q1g6IDAwMDAwMDA2IEVEWDogNDIzODk0OGUKWyAgIDQ0LjkzODM0Ml0gRUFYOiA0MjVkYjQw
YyBFQlg6IDUyMzA5NjYwIEVDWDogMDAwMDAwMDYgRURYOiA0MjM4OTQ4ZQpbICAgNDQuOTM4
MzQyXSBFU0k6IDQyMzg5NDhlIEVESTogNDI1NmNmOWMgRUJQOiA1MzBhOWVkYyBFU1A6IDUz
MGE5ZWRjClsgICA0NC45MzgzNDJdIEVTSTogNDIzODk0OGUgRURJOiA0MjU2Y2Y5YyBFQlA6
IDUzMGE5ZWRjIEVTUDogNTMwYTllZGMKWyAgIDQ0LjkzODM0Ml0gIERTOiAwMDdiIEVTOiAw
MDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICA0NC45MzgzNDJdICBEUzogMDA3
YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAgNDQuOTM4MzQyXSBD
UjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMjliYzAwMCBDUjQ6IDAwMDAwNmIw
ClsgICA0NC45MzgzNDJdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBDUjM6IDAyOWJj
MDAwIENSNDogMDAwMDA2YjAKWyAgIDQ0LjkzODM0Ml0gU3RhY2s6ClsgICA0NC45MzgzNDJd
IFN0YWNrOgpbICAgNDQuOTM4MzQyXSAgNTMwYTllZWMKWyAgIDQ0LjkzODM0Ml0gIDUzMGE5
ZWVjIDQxMTIxN2ZmIDQxMTIxN2ZmIDQyNTZjZjljIDQyNTZjZjljIDAwMDAwMDAwIDAwMDAw
MDAwIDUzMGE5ZjEwIDUzMGE5ZjEwIDQxMTIyN2E1IDQxMTIyN2E1IDUyMzdiNGI4IDUyMzdi
NGI4IDUyMzdlZWUwIDUyMzdlZWUwCgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcw
ODAzMjgvOTJmNjg4NmMxMzU0NDM3OWY5YTIyMDc3MzQ3YTgzNDdhOTJhMmU2Mi9kbWVzZy15
b2N0by1pdmI0MS01NDoyMDE0MDcwODAzNTEzODppMzg2LXJhbmRjb25maWctaWIxLTA3MDgw
MzI4OjoKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNv
bW1pdCA5MmY2ODg2YzEzNTQ0Mzc5ZjlhMjIwNzczNDdhODM0N2E5MmEyZTYyCmdpdCBjaGVj
a291dCB2My4xNQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzA4MDMyOC9uZXh0Om1hc3RlcjoxODYwZTM3OTg3NWRmZTcyNzFjNjQ5
MDU4YWVkZGZmZTVhZmQ5ZDBkOmJpc2VjdC1saW51eAoKMjAxNC0wNy0wOC0wMzo1MjozOSAx
ODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkIGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcwODAzMjgtMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZk
OWQwZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzA4MDMyOC8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctaWIxLTA3MDgwMzI4LTE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZl
NWFmZDlkMGQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4
LTE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvMTg2MGUzNzk4NzVkZmU3MjcxYzY0
OTA1OGFlZGRmZmU1YWZkOWQwZC92bWxpbnV6LTMuMTUuMAoKMjAxNC0wNy0wOC0wNDowMzoz
OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4JMi4gVEVTVCBGQUlMVVJFClsgICA1Ny4w
NTA0MDldIGZ1dGV4IGhhc2ggdGFibGUgZW50cmllczogMTYgKG9yZGVyOiAtMiwgMTAyNCBi
eXRlcykKWyAgIDU3LjA2ODA1Nl0gSW5pdGlhbGlzZSBzeXN0ZW0gdHJ1c3RlZCBrZXlyaW5n
ClsgICA1Ny4wNjgwNTZdIEluaXRpYWxpc2Ugc3lzdGVtIHRydXN0ZWQga2V5cmluZwpbICAg
ODQuODc1MzY3XSBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzEgc3R1Y2sgZm9yIDIzcyEgW3N3
YXBwZXIvMDoxXQpbICAgODQuODc1MzY3XSBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzEgc3R1
Y2sgZm9yIDIzcyEgW3N3YXBwZXIvMDoxXQpbICAgODQuODc1MzY3XSBpcnEgZXZlbnQgc3Rh
bXA6IDIxNDE1MzQKWyAgIDg0Ljg3NTM2N10gaXJxIGV2ZW50IHN0YW1wOiAyMTQxNTM0Clsg
ICA4NC44NzUzNjddIGhhcmRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDIxNDE1MzMpOiAKWyAg
IDg0Ljg3NTM2N10gaGFyZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoMjE0MTUzMyk6IFs8NDFk
MjUyMDc+XSByZXN0b3JlX2FsbF9ub3RyYWNlKzB4MC8weDE4Cls8NDFkMjUyMDc+XSByZXN0
b3JlX2FsbF9ub3RyYWNlKzB4MC8weDE4ClsgICA4NC44NzUzNjddIGhhcmRpcnFzIGxhc3Qg
ZGlzYWJsZWQgYXQgKDIxNDE1MzQpOiAKWyAgIDg0Ljg3NTM2N10gaGFyZGlycXMgbGFzdCBk
aXNhYmxlZCBhdCAoMjE0MTUzNCk6IFs8NDFkMjU1Mzc+XSBhcGljX3RpbWVyX2ludGVycnVw
dCsweDJmLzB4M2MKWzw0MWQyNTUzNz5dIGFwaWNfdGltZXJfaW50ZXJydXB0KzB4MmYvMHgz
YwpbICAgODQuODc1MzY3XSBzb2Z0aXJxcyBsYXN0ICBlbmFibGVkIGF0ICgyMTQxNTMyKTog
ClsgICA4NC44NzUzNjddIHNvZnRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDIxNDE1MzIpOiBb
PDQxMDcyOWQzPl0gX19kb19zb2Z0aXJxKzB4MzNhLzB4M2VjCls8NDEwNzI5ZDM+XSBfX2Rv
X3NvZnRpcnErMHgzM2EvMHgzZWMKWyAgIDg0Ljg3NTM2N10gc29mdGlycXMgbGFzdCBkaXNh
YmxlZCBhdCAoMjE0MTUyNyk6IApbICAgODQuODc1MzY3XSBzb2Z0aXJxcyBsYXN0IGRpc2Fi
bGVkIGF0ICgyMTQxNTI3KTogWzw0MTAwNzIzZj5dIGNhbGxfb25fc3RhY2srMHgxYi8weDJm
Cls8NDEwMDcyM2Y+XSBjYWxsX29uX3N0YWNrKzB4MWIvMHgyZgpbICAgODQuODc1MzY3XSBD
UFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE1LjAgIzEKWyAg
IDg0Ljg3NTM2N10gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQg
My4xNS4wICMxClsgICA4NC44NzUzNjddIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQg
UEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDg0
Ljg3NTM2N10gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJ
WCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgODQuODc1MzY3XSB0YXNrOiA1
MWNhMDAwMCB0aTogNTFjOWMwMDAgdGFzay50aTogNTFjOWMwMDAKWyAgIDg0Ljg3NTM2N10g
dGFzazogNTFjYTAwMDAgdGk6IDUxYzljMDAwIHRhc2sudGk6IDUxYzljMDAwClsgICA4NC44
NzUzNjddIEVJUDogMDA2MDpbPDQxMTIwMDg3Pl0gRUZMQUdTOiAwMDAwMDIwMiBDUFU6IDEK
WyAgIDg0Ljg3NTM2N10gRUlQOiAwMDYwOls8NDExMjAwODc+XSBFRkxBR1M6IDAwMDAwMjAy
IENQVTogMQpbICAgODQuODc1MzY3XSBFSVAgaXMgYXQgZ2Nvdl9pbmZvX2ZpbGVuYW1lKzB4
ZC8weDE2ClsgICA4NC44NzUzNjddIEVJUCBpcyBhdCBnY292X2luZm9fZmlsZW5hbWUrMHhk
LzB4MTYKWyAgIDg0Ljg3NTM2N10gRUFYOiA0MjQwNzllZSBFQlg6IDRkNTY2MDAwIEVDWDog
MDAwMDAwMDYgRURYOiA0MjJlOTI3MQpbICAgODQuODc1MzY3XSBFQVg6IDQyNDA3OWVlIEVC
WDogNGQ1NjYwMDAgRUNYOiAwMDAwMDAwNiBFRFg6IDQyMmU5MjcxClsgICA4NC44NzUzNjdd
IEVTSTogNDIyZTkyNzEgRURJOiA0MjQ2OGYwMCBFQlA6IDUxYzlkZWRjIEVTUDogNTFjOWRl
ZGMKWyAgIDg0Ljg3NTM2N10gRVNJOiA0MjJlOTI3MSBFREk6IDQyNDY4ZjAwIEVCUDogNTFj
OWRlZGMgRVNQOiA1MWM5ZGVkYwpbICAgODQuODc1MzY3XSAgRFM6IDAwN2IgRVM6IDAwN2Ig
RlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDg0Ljg3NTM2N10gIERTOiAwMDdiIEVT
OiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICA4NC44NzUzNjddIENSMDog
ODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBDUjM6IDAyOTI2MDAwIENSNDogMDAwMDA2YjAKWyAg
IDg0Ljg3NTM2N10gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDI5MjYwMDAg
Q1I0OiAwMDAwMDZiMApbICAgODQuODc1MzY3XSBTdGFjazoKWyAgIDg0Ljg3NTM2N10gU3Rh
Y2s6ClsgICA4NC44NzUzNjddICA1MWM5ZGVlYwpbICAgODQuODc1MzY3XSAgNTFjOWRlZWMg
NDExMWU3OWUgNDExMWU3OWUgNDI0NjhmMDAgNDI0NjhmMDAgMDAwMDAwMDAgMDAwMDAwMDAg
NTFjOWRmMTAgNTFjOWRmMTAgNDExMWY3MWYgNDExMWY3MWYgNTM0NWE2OTggNTM0NWE2OTgg
NTM0NjkwMDAgNTM0NjkwMDAKCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMy
OC8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL2RtZXNnLXF1YW50
YWwtaXZiNDItMTIzOjIwMTQwNzA4MDQwNzMxOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAz
Mjg6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvMTg2MGUzNzk4NzVk
ZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy15b2N0by1pdmI0MS0zNToyMDE0
MDcwODA0MDYyNTppMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4OjoKMDoyOjQgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xNQpnaXQgY2hl
Y2tvdXQgdjMuMTQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcwODAzMjgvbmV4dDptYXN0ZXI6NDU1YzZmZGJkMjE5MTYxYmQwOWIx
MTY1ZjExNjk5ZDZkNzNkZTExYzpiaXNlY3QtbGludXgKCjIwMTQtMDctMDgtMDQ6MDc6NDIg
NDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYyBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctaWIxLTA3MDgwMzI4LTQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDcz
ZGUxMWMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcwODAzMjgvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYwp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzA4MDMyOC00NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlk
NmQ3M2RlMTFjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9sa3AtaWIwMy1zbW9rZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LTQ1
NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1
ZjExNjk5ZDZkNzNkZTExYy92bWxpbnV6LTMuMTQuMAoKMjAxNC0wNy0wOC0wNDozNDo0MiBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTIJNgkxMgkyMAkyNgkzMQkzNSBTVUNDRVNTCgpiaXNl
Y3Q6IGdvb2QgY29tbWl0IHYzLjE0CmdpdCBiaXNlY3Qgc3RhcnQgdjMuMTUgdjMuMTQgLS0K
L2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAidjMuMTUiLCAiLWciLCAi
djMuMTQiLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIs
ICIvYy9ib290LWJpc2VjdC9saW51eC9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxNDg3MSBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCls2
NzQzNjZlOTBlNWEyNDMwZTNkZGVmNDBjZTUxNTEyZDY4MTk0NGU0XSBNZXJnZSB0YWcgJ3Bj
aS12My4xNS1maXhlcy0xJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvaGVsZ2Fhcy9wY2kKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcwODAzMjgvbmV4dDptYXN0ZXI6Njc0MzY2ZTkwZTVhMjQzMGUzZGRlZjQwY2U1MTUxMmQ2
ODE5NDRlNDpiaXNlY3QtbGludXgKCjIwMTQtMDctMDgtMDQ6Mzg6NDUgNjc0MzY2ZTkwZTVh
MjQzMGUzZGRlZjQwY2U1MTUxMmQ2ODE5NDRlNCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3
MDgwMzI4LTY3NDM2NmU5MGU1YTI0MzBlM2RkZWY0MGNlNTE1MTJkNjgxOTQ0ZTQKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvNjc0
MzY2ZTkwZTVhMjQzMGUzZGRlZjQwY2U1MTUxMmQ2ODE5NDRlNAp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzA4MDMyOC02NzQzNjZlOTBlNWEyNDMwZTNkZGVmNDBjZTUxNTEyZDY4MTk0NGU0Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3At
aWIwMy1zbW9rZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LTY3NDM2NmU5MGU1YTI0
MzBlM2RkZWY0MGNlNTE1MTJkNjgxOTQ0ZTQKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcwODAzMjgvNjc0MzY2ZTkwZTVhMjQzMGUzZGRlZjQwY2U1MTUxMmQ2ODE5
NDRlNC92bWxpbnV6LTMuMTUuMC1yYzEtMDAxODQtZzY3NDM2NmUKCjIwMTQtMDctMDgtMDQ6
NTM6NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTEgVEVTVCBGQUlMVVJFClsgICAxNy4y
NTUwMzhdIGZ1dGV4IGhhc2ggdGFibGUgZW50cmllczogMTYgKG9yZGVyOiAtMiwgMTAyNCBi
eXRlcykKWyAgIDE3LjI4NTQyMl0gSW5pdGlhbGlzZSBzeXN0ZW0gdHJ1c3RlZCBrZXlyaW5n
ClsgICAxNy4yODU0MjJdIEluaXRpYWxpc2Ugc3lzdGVtIHRydXN0ZWQga2V5cmluZwpbICAg
NDYuMjM1ODA4XSBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzEgc3R1Y2sgZm9yIDIzcyEgW3N3
YXBwZXIvMDoxXQpbICAgNDYuMjM1ODA4XSBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzEgc3R1
Y2sgZm9yIDIzcyEgW3N3YXBwZXIvMDoxXQpbICAgNDYuMjM1ODA4XSBpcnEgZXZlbnQgc3Rh
bXA6IDkwMDI1MgpbICAgNDYuMjM1ODA4XSBpcnEgZXZlbnQgc3RhbXA6IDkwMDI1MgpbICAg
NDYuMjM1ODA4XSBoYXJkaXJxcyBsYXN0ICBlbmFibGVkIGF0ICg5MDAyNTEpOiAKWyAgIDQ2
LjIzNTgwOF0gaGFyZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoOTAwMjUxKTogWzw0MWQyMThh
Zj5dIHJlc3RvcmVfYWxsX25vdHJhY2UrMHgwLzB4MTgKWzw0MWQyMThhZj5dIHJlc3RvcmVf
YWxsX25vdHJhY2UrMHgwLzB4MTgKWyAgIDQ2LjIzNTgwOF0gaGFyZGlycXMgbGFzdCBkaXNh
YmxlZCBhdCAoOTAwMjUyKTogClsgICA0Ni4yMzU4MDhdIGhhcmRpcnFzIGxhc3QgZGlzYWJs
ZWQgYXQgKDkwMDI1Mik6IFs8NDFkMjFiZGY+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDJm
LzB4M2MKWzw0MWQyMWJkZj5dIGFwaWNfdGltZXJfaW50ZXJydXB0KzB4MmYvMHgzYwpbICAg
NDYuMjM1ODA4XSBzb2Z0aXJxcyBsYXN0ICBlbmFibGVkIGF0ICg5MDAyNTApOiAKWyAgIDQ2
LjIzNTgwOF0gc29mdGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoOTAwMjUwKTogWzw0MTA3Mjkz
Nj5dIF9fZG9fc29mdGlycSsweDMzYS8weDNlYwpbPDQxMDcyOTM2Pl0gX19kb19zb2Z0aXJx
KzB4MzNhLzB4M2VjClsgICA0Ni4yMzU4MDhdIHNvZnRpcnFzIGxhc3QgZGlzYWJsZWQgYXQg
KDkwMDI0NSk6IApbICAgNDYuMjM1ODA4XSBzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0ICg5
MDAyNDUpOiBbPDQxMDA3MWZlPl0gY2FsbF9vbl9zdGFjaysweDFiLzB4MmYKWzw0MTAwNzFm
ZT5dIGNhbGxfb25fc3RhY2srMHgxYi8weDJmClsgICA0Ni4yMzU4MDhdIENQVTogMSBQSUQ6
IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTUuMC1yYzEtMDAxODQtZzY3NDM2
NmUgIzEKWyAgIDQ2LjIzNTgwOF0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90
IHRhaW50ZWQgMy4xNS4wLXJjMS0wMDE4NC1nNjc0MzY2ZSAjMQpbICAgNDYuMjM1ODA4XSBI
YXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwg
QklPUyBCb2NocyAwMS8wMS8yMDExClsgICA0Ni4yMzU4MDhdIEhhcmR3YXJlIG5hbWU6IFFF
TVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAx
LzIwMTEKWyAgIDQ2LjIzNTgwOF0gdGFzazogNTMwYTAwMDAgdGk6IDUzMDljMDAwIHRhc2su
dGk6IDUzMDljMDAwClsgICA0Ni4yMzU4MDhdIHRhc2s6IDUzMGEwMDAwIHRpOiA1MzA5YzAw
MCB0YXNrLnRpOiA1MzA5YzAwMApbICAgNDYuMjM1ODA4XSBFSVA6IDAwNjA6Wzw0MTJhYWIx
Zj5dIEVGTEFHUzogMDAwMDAyNDYgQ1BVOiAxClsgICA0Ni4yMzU4MDhdIEVJUDogMDA2MDpb
PDQxMmFhYjFmPl0gRUZMQUdTOiAwMDAwMDI0NiBDUFU6IDEKWyAgIDQ2LjIzNTgwOF0gRUlQ
IGlzIGF0IHN0cmNtcCsweDE4LzB4MzkKWyAgIDQ2LjIzNTgwOF0gRUlQIGlzIGF0IHN0cmNt
cCsweDE4LzB4MzkKWyAgIDQ2LjIzNTgwOF0gRUFYOiA0MjMyNGMyZiBFQlg6IDUyMzMzMjIw
IEVDWDogMDAwMDAwMDYgRURYOiA0MjJmNDc2NApbICAgNDYuMjM1ODA4XSBFQVg6IDQyMzI0
YzJmIEVCWDogNTIzMzMyMjAgRUNYOiAwMDAwMDAwNiBFRFg6IDQyMmY0NzY0ClsgICA0Ni4y
MzU4MDhdIEVTSTogNDIzMjRjMTAgRURJOiA0MjJmNDc2NCBFQlA6IDUzMDlkZWRjIEVTUDog
NTMwOWRlZDQKWyAgIDQ2LjIzNTgwOF0gRVNJOiA0MjMyNGMxMCBFREk6IDQyMmY0NzY0IEVC
UDogNTMwOWRlZGMgRVNQOiA1MzA5ZGVkNApbICAgNDYuMjM1ODA4XSAgRFM6IDAwN2IgRVM6
IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDQ2LjIzNTgwOF0gIERTOiAw
MDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICA0Ni4yMzU4MDhd
IENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBDUjM6IDAyOTFkMDAwIENSNDogMDAwMDA2
YjAKWyAgIDQ2LjIzNTgwOF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDI5
MWQwMDAgQ1I0OiAwMDAwMDZiMApbICAgNDYuMjM1ODA4XSBTdGFjazoKWyAgIDQ2LjIzNTgw
OF0gU3RhY2s6ClsgICA0Ni4yMzU4MDhdICA0MjJmNDc2NApbICAgNDYuMjM1ODA4XSAgNDIy
ZjQ3NjQgNDI0YTcwNWMgNDI0YTcwNWMgNTMwOWRlZWMgNTMwOWRlZWMgNDExMWUxZTcgNDEx
MWUxZTcgNDI0YTcwNWMgNDI0YTcwNWMgMDAwMDAwMDAgMDAwMDAwMDAgNTMwOWRmMTAgNTMw
OWRmMTAgNDExMWYxNTMgNDExMWYxNTMKCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzA4MDMyOC82NzQzNjZlOTBlNWEyNDMwZTNkZGVmNDBjZTUxNTEyZDY4MTk0NGU0L2RtZXNn
LXlvY3RvLWl2YjQyLTE1OjIwMTQwNzA4MDQ1NTIzOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcw
ODAzMjg6OgowOjE6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAx
MzAxMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3Rl
cHMpCls5ZjgwMDM2M2JiMGVhNDU5ZTE1YmVmMDkyOGE3MmM4OGQzNzRlNDg5XSBNZXJnZSB0
YWcgJ2ZpeGVzLW5vbi1jcml0aWNhbC0zLjE1JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYXJtL2FybS1zb2MKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcwODAzMjgvbmV4dDptYXN0ZXI6OWY4MDAzNjNiYjBlYTQ1OWUxNWJl
ZjA5MjhhNzJjODhkMzc0ZTQ4OTpiaXNlY3QtbGludXgKCjIwMTQtMDctMDgtMDQ6NTU6NDgg
OWY4MDAzNjNiYjBlYTQ1OWUxNWJlZjA5MjhhNzJjODhkMzc0ZTQ4OSBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctaWIxLTA3MDgwMzI4LTlmODAwMzYzYmIwZWE0NTllMTViZWYwOTI4YTcyYzg4ZDM3
NGU0ODkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcwODAzMjgvOWY4MDAzNjNiYjBlYTQ1OWUxNWJlZjA5MjhhNzJjODhkMzc0ZTQ4OQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzA4MDMyOC05ZjgwMDM2M2JiMGVhNDU5ZTE1YmVmMDkyOGE3MmM4
OGQzNzRlNDg5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMy
OC05ZjgwMDM2M2JiMGVhNDU5ZTE1YmVmMDkyOGE3MmM4OGQzNzRlNDg5Cmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LzlmODAwMzYzYmIwZWE0NTllMTVi
ZWYwOTI4YTcyYzg4ZDM3NGU0ODkvdm1saW51ei0zLjE0LjAtMDg5MzktZzlmODAwMzYKCjIw
MTQtMDctMDgtMDQ6NTk6NDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTIJNC4gVEVTVCBG
QUlMVVJFClsgICA2MC4xNjc5NzRdIGZ1dGV4IGhhc2ggdGFibGUgZW50cmllczogMTYgKG9y
ZGVyOiAtMiwgMTAyNCBieXRlcykKWyAgIDYwLjE4NjQyMF0gSW5pdGlhbGlzZSBzeXN0ZW0g
dHJ1c3RlZCBrZXlyaW5nClsgICA2MC4xODY0MjBdIEluaXRpYWxpc2Ugc3lzdGVtIHRydXN0
ZWQga2V5cmluZwpbICAgODUuMjI4MTYxXSBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzEgc3R1
Y2sgZm9yIDIycyEgW3N3YXBwZXIvMDoxXQpbICAgODUuMjI4MTYxXSBCVUc6IHNvZnQgbG9j
a3VwIC0gQ1BVIzEgc3R1Y2sgZm9yIDIycyEgW3N3YXBwZXIvMDoxXQpbICAgODUuMjI4MTYx
XSBpcnEgZXZlbnQgc3RhbXA6IDIwOTQyNTgKWyAgIDg1LjIyODE2MV0gaXJxIGV2ZW50IHN0
YW1wOiAyMDk0MjU4ClsgICA4NS4yMjgxNjFdIGhhcmRpcnFzIGxhc3QgIGVuYWJsZWQgYXQg
KDIwOTQyNTcpOiAKWyAgIDg1LjIyODE2MV0gaGFyZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAo
MjA5NDI1Nyk6IFs8NDFkMDZiNmY+XSByZXN0b3JlX2FsbF9ub3RyYWNlKzB4MC8weDE4Cls8
NDFkMDZiNmY+XSByZXN0b3JlX2FsbF9ub3RyYWNlKzB4MC8weDE4ClsgICA4NS4yMjgxNjFd
IGhhcmRpcnFzIGxhc3QgZGlzYWJsZWQgYXQgKDIwOTQyNTgpOiAKWyAgIDg1LjIyODE2MV0g
aGFyZGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoMjA5NDI1OCk6IFs8NDFkMDZlOWY+XSBhcGlj
X3RpbWVyX2ludGVycnVwdCsweDJmLzB4M2MKWzw0MWQwNmU5Zj5dIGFwaWNfdGltZXJfaW50
ZXJydXB0KzB4MmYvMHgzYwpbICAgODUuMjI4MTYxXSBzb2Z0aXJxcyBsYXN0ICBlbmFibGVk
IGF0ICgyMDk0MjU2KTogClsgICA4NS4yMjgxNjFdIHNvZnRpcnFzIGxhc3QgIGVuYWJsZWQg
YXQgKDIwOTQyNTYpOiBbPDQxMDcyODE1Pl0gX19kb19zb2Z0aXJxKzB4MzNhLzB4M2VjCls8
NDEwNzI4MTU+XSBfX2RvX3NvZnRpcnErMHgzM2EvMHgzZWMKWyAgIDg1LjIyODE2MV0gc29m
dGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoMjA5NDI1MSk6IApbICAgODUuMjI4MTYxXSBzb2Z0
aXJxcyBsYXN0IGRpc2FibGVkIGF0ICgyMDk0MjUxKTogWzw0MTAwNzFmZT5dIGNhbGxfb25f
c3RhY2srMHgxYi8weDJmCls8NDEwMDcxZmU+XSBjYWxsX29uX3N0YWNrKzB4MWIvMHgyZgpb
ICAgODUuMjI4MTYxXSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRl
ZCAzLjE0LjAtMDg5MzktZzlmODAwMzYgIzEKWyAgIDg1LjIyODE2MV0gQ1BVOiAxIFBJRDog
MSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLTA4OTM5LWc5ZjgwMDM2ICMx
ClsgICA4NS4yMjgxNjFdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBG
WCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDg1LjIyODE2MV0g
SGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5Niks
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgODUuMjI4MTYxXSB0YXNrOiA1MWNhMDAwMCB0
aTogNTFjOWMwMDAgdGFzay50aTogNTFjOWMwMDAKWyAgIDg1LjIyODE2MV0gdGFzazogNTFj
YTAwMDAgdGk6IDUxYzljMDAwIHRhc2sudGk6IDUxYzljMDAwClsgICA4NS4yMjgxNjFdIEVJ
UDogMDA2MDpbPDQxMTFmNzVhPl0gRUZMQUdTOiAwMDAwMDIwNiBDUFU6IDEKWyAgIDg1LjIy
ODE2MV0gRUlQOiAwMDYwOls8NDExMWY3NWE+XSBFRkxBR1M6IDAwMDAwMjA2IENQVTogMQpb
ICAgODUuMjI4MTYxXSBFSVAgaXMgYXQgZ2Nvdl9pbmZvX2ZpbGVuYW1lKzB4ZC8weDE2Clsg
ICA4NS4yMjgxNjFdIEVJUCBpcyBhdCBnY292X2luZm9fZmlsZW5hbWUrMHhkLzB4MTYKWyAg
IDg1LjIyODE2MV0gRUFYOiA0MjMzN2Q4NSBFQlg6IDRjNzYxYWEwIEVDWDogMDAwMDAwMDYg
RURYOiA0MjJlMTg4MwpbICAgODUuMjI4MTYxXSBFQVg6IDQyMzM3ZDg1IEVCWDogNGM3NjFh
YTAgRUNYOiAwMDAwMDAwNiBFRFg6IDQyMmUxODgzClsgICA4NS4yMjgxNjFdIEVTSTogNDIy
ZTE4ODMgRURJOiA0MjRhZDE3NCBFQlA6IDUxYzlkZWRjIEVTUDogNTFjOWRlZGMKWyAgIDg1
LjIyODE2MV0gRVNJOiA0MjJlMTg4MyBFREk6IDQyNGFkMTc0IEVCUDogNTFjOWRlZGMgRVNQ
OiA1MWM5ZGVkYwpbICAgODUuMjI4MTYxXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDgg
R1M6IDAwZTAgU1M6IDAwNjgKWyAgIDg1LjIyODE2MV0gIERTOiAwMDdiIEVTOiAwMDdiIEZT
OiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICA4NS4yMjgxNjFdIENSMDogODAwNTAwM2Ig
Q1IyOiAwMDAwMDAwMCBDUjM6IDAyOGZiMDAwIENSNDogMDAwMDA2YjAKWyAgIDg1LjIyODE2
MV0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDI4ZmIwMDAgQ1I0OiAwMDAw
MDZiMApbICAgODUuMjI4MTYxXSBTdGFjazoKWyAgIDg1LjIyODE2MV0gU3RhY2s6ClsgICA4
NS4yMjgxNjFdICA1MWM5ZGVlYwpbICAgODUuMjI4MTYxXSAgNTFjOWRlZWMgNDExMWRlNzEg
NDExMWRlNzEgNDI0YWQxNzQgNDI0YWQxNzQgMDAwMDAwMDAgMDAwMDAwMDAgNTFjOWRmMTAg
NTFjOWRmMTAgNDExMWVkZjIgNDExMWVkZjIgNTE0Y2I0NDggNTE0Y2I0NDggNTM0MGNlZTAg
NTM0MGNlZTAKCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC85ZjgwMDM2
M2JiMGVhNDU5ZTE1YmVmMDkyOGE3MmM4OGQzNzRlNDg5L2RtZXNnLXlvY3RvLWl2YjQyLTEx
NjoyMDE0MDcwODA1MDI1MzppMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LzlmODAwMzYzYmIwZWE0NTllMTViZWYw
OTI4YTcyYzg4ZDM3NGU0ODkvZG1lc2cteW9jdG8taXZiNDQtNzc6MjAxNDA3MDgwNTAwMzM6
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyODo6CjA6Mjo2IGFsbF9nb29kOmJhZDphbGxf
YmFkIGJvb3RzChtbMTszNW0yMDE0LTA3LTA4IDA1OjAyOjQ5IFJFUEVBVCBDT1VOVDogNDAg
ICMgL2MvYm9vdC1iaXNlY3QvbGludXgvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0
aW5nOiA4OTM5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAx
NCBzdGVwcykKWzFhYWJjNTk5MGQyMDVjZGIwNzg5YTFjMjYxNDNjNTM2MDFlOWJiMDddIHg4
NjogRml4IGR1bXBzdGFja182NCB0byBrZWVwIHN0YXRlIG9mICJ1c2VkIiB2YXJpYWJsZSBp
biBsb29wCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4L25leHQ6bWFz
dGVyOjFhYWJjNTk5MGQyMDVjZGIwNzg5YTFjMjYxNDNjNTM2MDFlOWJiMDc6YmlzZWN0LWxp
bnV4CgoyMDE0LTA3LTA4LTA1OjAyOjUxIDFhYWJjNTk5MGQyMDVjZGIwNzg5YTFjMjYxNDNj
NTM2MDFlOWJiMDcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC0xYWFiYzU5OTBk
MjA1Y2RiMDc4OWExYzI2MTQzYzUzNjAxZTliYjA3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LzFhYWJjNTk5MGQyMDVjZGIwNzg5
YTFjMjYxNDNjNTM2MDFlOWJiMDcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgtMWFhYmM1
OTkwZDIwNWNkYjA3ODlhMWMyNjE0M2M1MzYwMWU5YmIwNwprZXJuZWw6IC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC8xYWFiYzU5OTBkMjA1Y2RiMDc4OWExYzI2MTQz
YzUzNjAxZTliYjA3L3ZtbGludXotMy4xNC4wLTA0NTU2LWcxYWFiYzU5CgoyMDE0LTA3LTA4
LTA1OjA4OjUxIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4gVEVTVCBGQUlMVVJFClsgICAy
My44Njg1MzhdIGZ1dGV4IGhhc2ggdGFibGUgZW50cmllczogMTYgKG9yZGVyOiAtMiwgMTAy
NCBieXRlcykKWyAgIDIzLjg5NDQ0Ml0gSW5pdGlhbGlzZSBzeXN0ZW0gdHJ1c3RlZCBrZXly
aW5nClsgICAyMy44OTQ0NDJdIEluaXRpYWxpc2Ugc3lzdGVtIHRydXN0ZWQga2V5cmluZwpb
ICAgNDkuNjI2OTI0XSBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzAgc3R1Y2sgZm9yIDIzcyEg
W3N3YXBwZXIvMDoxXQpbICAgNDkuNjI2OTI0XSBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzAg
c3R1Y2sgZm9yIDIzcyEgW3N3YXBwZXIvMDoxXQpbICAgNDkuNjI2OTI0XSBpcnEgZXZlbnQg
c3RhbXA6IDk0MDE3MgpbICAgNDkuNjI2OTI0XSBpcnEgZXZlbnQgc3RhbXA6IDk0MDE3Mgpb
ICAgNDkuNjI2OTI0XSBoYXJkaXJxcyBsYXN0ICBlbmFibGVkIGF0ICg5NDAxNzEpOiAKWyAg
IDQ5LjYyNjkyNF0gaGFyZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoOTQwMTcxKTogWzw0MWNm
ZDhiZj5dIHJlc3RvcmVfYWxsX25vdHJhY2UrMHgwLzB4MTgKWzw0MWNmZDhiZj5dIHJlc3Rv
cmVfYWxsX25vdHJhY2UrMHgwLzB4MTgKWyAgIDQ5LjYyNjkyNF0gaGFyZGlycXMgbGFzdCBk
aXNhYmxlZCBhdCAoOTQwMTcyKTogClsgICA0OS42MjY5MjRdIGhhcmRpcnFzIGxhc3QgZGlz
YWJsZWQgYXQgKDk0MDE3Mik6IFs8NDFjZmRiZWY+XSBhcGljX3RpbWVyX2ludGVycnVwdCsw
eDJmLzB4M2MKWzw0MWNmZGJlZj5dIGFwaWNfdGltZXJfaW50ZXJydXB0KzB4MmYvMHgzYwpb
ICAgNDkuNjI2OTI0XSBzb2Z0aXJxcyBsYXN0ICBlbmFibGVkIGF0ICg5NDAxNzApOiAKWyAg
IDQ5LjYyNjkyNF0gc29mdGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoOTQwMTcwKTogWzw0MTA3
MjYzOT5dIF9fZG9fc29mdGlycSsweDMzYS8weDNlYwpbPDQxMDcyNjM5Pl0gX19kb19zb2Z0
aXJxKzB4MzNhLzB4M2VjClsgICA0OS42MjY5MjRdIHNvZnRpcnFzIGxhc3QgZGlzYWJsZWQg
YXQgKDk0MDE2Myk6IApbICAgNDkuNjI2OTI0XSBzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0
ICg5NDAxNjMpOiBbPDQxMDA3MjBhPl0gY2FsbF9vbl9zdGFjaysweDFiLzB4MmYKWzw0MTAw
NzIwYT5dIGNhbGxfb25fc3RhY2srMHgxYi8weDJmClsgICA0OS42MjY5MjRdIENQVTogMCBQ
SUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTQuMC0wNDU1Ni1nMWFhYmM1
OSAjMQpbICAgNDkuNjI2OTI0XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3Qg
dGFpbnRlZCAzLjE0LjAtMDQ1NTYtZzFhYWJjNTkgIzEKWyAgIDQ5LjYyNjkyNF0gSGFyZHdh
cmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgNDkuNjI2OTI0XSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0
YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDEx
ClsgICA0OS42MjY5MjRdIHRhc2s6IDUzMDk4MDAwIHRpOiA1MzBhMDAwMCB0YXNrLnRpOiA1
MzBhMDAwMApbICAgNDkuNjI2OTI0XSB0YXNrOiA1MzA5ODAwMCB0aTogNTMwYTAwMDAgdGFz
ay50aTogNTMwYTAwMDAKWyAgIDQ5LjYyNjkyNF0gRUlQOiAwMDYwOls8NDExMWVjZDQ+XSBF
RkxBR1M6IDAwMDAwMjAyIENQVTogMApbICAgNDkuNjI2OTI0XSBFSVA6IDAwNjA6Wzw0MTEx
ZWNkND5dIEVGTEFHUzogMDAwMDAyMDIgQ1BVOiAwClsgICA0OS42MjY5MjRdIEVJUCBpcyBh
dCBnZXRfbm9kZV9pbmZvKzB4NS8weDMxClsgICA0OS42MjY5MjRdIEVJUCBpcyBhdCBnZXRf
bm9kZV9pbmZvKzB4NS8weDMxClsgICA0OS42MjY5MjRdIEVBWDogNTIzNmFiNDAgRUJYOiA1
MjM2YWI0MCBFQ1g6IDAwMDAwMDA2IEVEWDogNDIyYmYxNTkKWyAgIDQ5LjYyNjkyNF0gRUFY
OiA1MjM2YWI0MCBFQlg6IDUyMzZhYjQwIEVDWDogMDAwMDAwMDYgRURYOiA0MjJiZjE1OQpb
ICAgNDkuNjI2OTI0XSBFU0k6IDQyMmJmMTU5IEVESTogNDI0NDIwZTQgRUJQOiA1MzBhMWVl
YyBFU1A6IDUzMGExZWRjClsgICA0OS42MjY5MjRdIEVTSTogNDIyYmYxNTkgRURJOiA0MjQ0
MjBlNCBFQlA6IDUzMGExZWVjIEVTUDogNTMwYTFlZGMKWyAgIDQ5LjYyNjkyNF0gIERTOiAw
MDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICA0OS42MjY5MjRd
ICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAgNDku
NjI2OTI0XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMjhlOTAwMCBDUjQ6
IDAwMDAwNmIwClsgICA0OS42MjY5MjRdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBD
UjM6IDAyOGU5MDAwIENSNDogMDAwMDA2YjAKWyAgIDQ5LjYyNjkyNF0gU3RhY2s6ClsgICA0
OS42MjY5MjRdIFN0YWNrOgpbICAgNDkuNjI2OTI0XSAgNTMwYTFlZWMKWyAgIDQ5LjYyNjky
NF0gIDUzMGExZWVjIDQxMTFlZDRmIDQxMTFlZDRmIDQyNDQyMGU0IDQyNDQyMGU0IDAwMDAw
MDAwIDAwMDAwMDAwIDUzMGExZjEwIDUzMGExZjEwIDQxMTFmY2Y1IDQxMTFmY2Y1IDUyNTJh
NDQ4IDUyNTJhNDQ4IDUyM2MxZWUwIDUyM2MxZWUwCgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pYjEtMDcwODAzMjgvMWFhYmM1OTkwZDIwNWNkYjA3ODlhMWMyNjE0M2M1MzYwMWU5YmIw
Ny9kbWVzZy15b2N0by1pdmI0MS00NDoyMDE0MDcwODA1MDk0NzppMzg2LXJhbmRjb25maWct
aWIxLTA3MDgwMzI4OjoKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2Vj
dGluZzogNDU1NiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTMgc3RlcHMpClsxNjk0ZjBiYjhmMDQ4MzdmNTIzMmYzNTA1MWY0MGVlZmM0YWQ1NDAyXSBN
ZXJnZSBicmFuY2ggJ3g4Ni1tbS1mb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90aXAvdGlwCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC9v
YmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctaWIxLTA3MDgwMzI4L25leHQ6bWFzdGVyOjE2OTRmMGJiOGYwNDgzN2Y1MjMyZjM1
MDUxZjQwZWVmYzRhZDU0MDI6YmlzZWN0LWxpbnV4CgoyMDE0LTA3LTA4LTA1OjEwOjUzIDE2
OTRmMGJiOGYwNDgzN2Y1MjMyZjM1MDUxZjQwZWVmYzRhZDU0MDIgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzA4MDMyOC0xNjk0ZjBiYjhmMDQ4MzdmNTIzMmYzNTA1MWY0MGVlZmM0YWQ1
NDAyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3
MDgwMzI4LzE2OTRmMGJiOGYwNDgzN2Y1MjMyZjM1MDUxZjQwZWVmYzRhZDU0MDIKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcwODAzMjgtMTY5NGYwYmI4ZjA0ODM3ZjUyMzJmMzUwNTFmNDBlZWZj
NGFkNTQwMgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC0x
Njk0ZjBiYjhmMDQ4MzdmNTIzMmYzNTA1MWY0MGVlZmM0YWQ1NDAyCmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LzE2OTRmMGJiOGYwNDgzN2Y1MjMyZjM1
MDUxZjQwZWVmYzRhZDU0MDIvdm1saW51ei0zLjE0LjAtMDA2MDgtZzE2OTRmMGIKCjIwMTQt
MDctMDgtMDU6MTY6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTEuCTUuCTgJMTAJMTgJ
MjMJMjUJMzQJMzgJMzkJNDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzOTQ4IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzBjOGNmYmFkZTBl
OWJlZjU2Mzc5MDdlZDAwYzdiODFiYzg2YWQzNTldIE1lcmdlIGdpdDovL3d3dy5saW51eC13
YXRjaGRvZy5vcmcvbGludXgtd2F0Y2hkb2cKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcwODAzMjgvbmV4dDptYXN0ZXI6MGM4Y2ZiYWRlMGU5YmVmNTYzNzkwN2VkMDBjN2I4
MWJjODZhZDM1OTpiaXNlY3QtbGludXgKCjIwMTQtMDctMDgtMDU6MjQ6NTQgMGM4Y2ZiYWRl
MGU5YmVmNTYzNzkwN2VkMDBjN2I4MWJjODZhZDM1OSBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIx
LTA3MDgwMzI4LTBjOGNmYmFkZTBlOWJlZjU2Mzc5MDdlZDAwYzdiODFiYzg2YWQzNTkKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgv
MGM4Y2ZiYWRlMGU5YmVmNTYzNzkwN2VkMDBjN2I4MWJjODZhZDM1OQp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzA4MDMyOC0wYzhjZmJhZGUwZTliZWY1NjM3OTA3ZWQwMGM3YjgxYmM4NmFkMzU5
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9s
a3AtaHN4MDEtY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC0wYzhjZmJh
ZGUwZTliZWY1NjM3OTA3ZWQwMGM3YjgxYmM4NmFkMzU5Cmtlcm5lbDogL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LzBjOGNmYmFkZTBlOWJlZjU2Mzc5MDdlZDAwYzdi
ODFiYzg2YWQzNTkvdm1saW51ei0zLjE0LjAtMDE0NjQtZzBjOGNmYmEKCjIwMTQtMDctMDgt
MDU6Mjg6NTQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMgk3CTkJMTUJMTkJMjMJMzAgVEVT
VCBGQUlMVVJFClsgICA0NS44MDU4MDZdIEluaXRpYWxpc2Ugc3lzdGVtIHRydXN0ZWQga2V5
cmluZwpbICAgNDYuMDg2NDM2XSBzcGluX2xvY2stdG9ydHVyZTogbG9ja190b3J0dXJlX3N0
YXRzIHRhc2sgc3RhcnRlZApbICAgNDYuMDg2NDM2XSBzcGluX2xvY2stdG9ydHVyZTogbG9j
a190b3J0dXJlX3N0YXRzIHRhc2sgc3RhcnRlZApbICAgNzIuNTU4MDcxXSBCVUc6IHNvZnQg
bG9ja3VwIC0gQ1BVIzAgc3R1Y2sgZm9yIDIycyEgW3N3YXBwZXIvMDoxXQpbICAgNzIuNTU4
MDcxXSBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzAgc3R1Y2sgZm9yIDIycyEgW3N3YXBwZXIv
MDoxXQpbICAgNzIuNTU4MDcxXSBpcnEgZXZlbnQgc3RhbXA6IDIwODIwMTgKWyAgIDcyLjU1
ODA3MV0gaXJxIGV2ZW50IHN0YW1wOiAyMDgyMDE4ClsgICA3Mi41NTgwNzFdIGhhcmRpcnFz
IGxhc3QgIGVuYWJsZWQgYXQgKDIwODIwMTcpOiAKWyAgIDcyLjU1ODA3MV0gaGFyZGlycXMg
bGFzdCAgZW5hYmxlZCBhdCAoMjA4MjAxNyk6IFs8NDFjZTQzYzc+XSByZXN0b3JlX2FsbF9u
b3RyYWNlKzB4MC8weDE4Cls8NDFjZTQzYzc+XSByZXN0b3JlX2FsbF9ub3RyYWNlKzB4MC8w
eDE4ClsgICA3Mi41NTgwNzFdIGhhcmRpcnFzIGxhc3QgZGlzYWJsZWQgYXQgKDIwODIwMTgp
OiAKWyAgIDcyLjU1ODA3MV0gaGFyZGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoMjA4MjAxOCk6
IFs8NDFjZTQ2Zjc+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDJmLzB4M2MKWzw0MWNlNDZm
Nz5dIGFwaWNfdGltZXJfaW50ZXJydXB0KzB4MmYvMHgzYwpbICAgNzIuNTU4MDcxXSBzb2Z0
aXJxcyBsYXN0ICBlbmFibGVkIGF0ICgyMDgyMDE2KTogClsgICA3Mi41NTgwNzFdIHNvZnRp
cnFzIGxhc3QgIGVuYWJsZWQgYXQgKDIwODIwMTYpOiBbPDQxMDcyOGY5Pl0gX19kb19zb2Z0
aXJxKzB4MzNhLzB4M2VjCls8NDEwNzI4Zjk+XSBfX2RvX3NvZnRpcnErMHgzM2EvMHgzZWMK
WyAgIDcyLjU1ODA3MV0gc29mdGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoMjA4MjAxMSk6IApb
ICAgNzIuNTU4MDcxXSBzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0ICgyMDgyMDExKTogWzw0
MTAwNzIwYT5dIGNhbGxfb25fc3RhY2srMHgxYi8weDJmCls8NDEwMDcyMGE+XSBjYWxsX29u
X3N0YWNrKzB4MWIvMHgyZgpbICAgNzIuNTU4MDcxXSBDUFU6IDAgUElEOiAxIENvbW06IHN3
YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtMDE0NjQtZzBjOGNmYmEgIzIKWyAgIDcyLjU1
ODA3MV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4w
LTAxNDY0LWcwYzhjZmJhICMyClsgICA3Mi41NTgwNzFdIEhhcmR3YXJlIG5hbWU6IFFFTVUg
U3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIw
MTEKWyAgIDcyLjU1ODA3MV0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0
MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgNzIuNTU4MDcx
XSB0YXNrOiA1MWM5ODAwMCB0aTogNTFjYTAwMDAgdGFzay50aTogNTFjYTAwMDAKWyAgIDcy
LjU1ODA3MV0gdGFzazogNTFjOTgwMDAgdGk6IDUxY2EwMDAwIHRhc2sudGk6IDUxY2EwMDAw
ClsgICA3Mi41NTgwNzFdIEVJUDogMDA2MDpbPDQxMTFmMGQwPl0gRUZMQUdTOiAwMDAwMDI0
NiBDUFU6IDAKWyAgIDcyLjU1ODA3MV0gRUlQOiAwMDYwOls8NDExMWYwZDA+XSBFRkxBR1M6
IDAwMDAwMjQ2IENQVTogMApbICAgNzIuNTU4MDcxXSBFSVAgaXMgYXQgZ2V0X25vZGVfaW5m
bysweDUvMHgzMQpbICAgNzIuNTU4MDcxXSBFSVAgaXMgYXQgZ2V0X25vZGVfaW5mbysweDUv
MHgzMQpbICAgNzIuNTU4MDcxXSBFQVg6IDRjNjdiNjkwIEVCWDogNGM2N2I2OTAgRUNYOiAw
MDAwMDAwNiBFRFg6IDQyMjZkOGJkClsgICA3Mi41NTgwNzFdIEVBWDogNGM2N2I2OTAgRUJY
OiA0YzY3YjY5MCBFQ1g6IDAwMDAwMDA2IEVEWDogNDIyNmQ4YmQKWyAgIDcyLjU1ODA3MV0g
RVNJOiA0MjI2ZDhiZCBFREk6IDQyM2M3MjE4IEVCUDogNTFjYTFlZWMgRVNQOiA1MWNhMWVk
YwpbICAgNzIuNTU4MDcxXSBFU0k6IDQyMjZkOGJkIEVESTogNDIzYzcyMTggRUJQOiA1MWNh
MWVlYyBFU1A6IDUxY2ExZWRjClsgICA3Mi41NTgwNzFdICBEUzogMDA3YiBFUzogMDA3YiBG
UzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAgNzIuNTU4MDcxXSAgRFM6IDAwN2IgRVM6
IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDcyLjU1ODA3MV0gQ1IwOiA4
MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDI4OTkwMDAgQ1I0OiAwMDAwMDZiMApbICAg
NzIuNTU4MDcxXSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMjg5OTAwMCBD
UjQ6IDAwMDAwNmIwClsgICA3Mi41NTgwNzFdIFN0YWNrOgpbICAgNzIuNTU4MDcxXSBTdGFj
azoKWyAgIDcyLjU1ODA3MV0gIDUxY2ExZWVjClsgICA3Mi41NTgwNzFdICA1MWNhMWVlYyA0
MTExZjE0YiA0MTExZjE0YiA0MjNjNzIxOCA0MjNjNzIxOCAwMDAwMDAwMCAwMDAwMDAwMCA1
MWNhMWYxMCA1MWNhMWYxMCA0MTEyMDBmMSA0MTEyMDBmMSA1MzQ2NWQyOCA1MzQ2NWQyOCA1
MzQ2Y2VlMCA1MzQ2Y2VlMAoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4
LzBjOGNmYmFkZTBlOWJlZjU2Mzc5MDdlZDAwYzdiODFiYzg2YWQzNTkvZG1lc2ctcXVhbnRh
bC1pdmI0MS0xMDM6MjAxNDA3MDgwNTMyMjI6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMy
ODo6CjI4OjE6MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNy0w
OCAwNTozMzoyNSBSRVBFQVQgQ09VTlQ6IDMwMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDg1NiByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpClsxZWFkNjU4MTI0ODZjZGE2
NTA5MzY4M2E5OWI4OTA3YTcyNDJmYTkzXSBNZXJnZSBicmFuY2ggJ3RpbWVycy1jb3JlLWZv
ci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L3RpcC90aXAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvbmV4
dDptYXN0ZXI6MWVhZDY1ODEyNDg2Y2RhNjUwOTM2ODNhOTliODkwN2E3MjQyZmE5MzpiaXNl
Y3QtbGludXgKCjIwMTQtMDctMDgtMDU6MzM6MjYgMWVhZDY1ODEyNDg2Y2RhNjUwOTM2ODNh
OTliODkwN2E3MjQyZmE5MyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LTFlYWQ2
NTgxMjQ4NmNkYTY1MDkzNjgzYTk5Yjg5MDdhNzI0MmZhOTMKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvMWVhZDY1ODEyNDg2Y2Rh
NjUwOTM2ODNhOTliODkwN2E3MjQyZmE5Mwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC0x
ZWFkNjU4MTI0ODZjZGE2NTA5MzY4M2E5OWI4OTA3YTcyNDJmYTkzCmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LzFlYWQ2NTgxMjQ4NmNkYTY1MDkzNjgz
YTk5Yjg5MDdhNzI0MmZhOTMvdm1saW51ei0zLjE0LjAtMDA2NzctZzFlYWQ2NTgKCjIwMTQt
MDctMDgtMDU6NDA6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLgkzIFRFU1QgRkFJTFVS
RQpbICAgMzEuMTE2MjU2XSBmdXRleCBoYXNoIHRhYmxlIGVudHJpZXM6IDE2IChvcmRlcjog
LTIsIDEwMjQgYnl0ZXMpClsgICAzMS4xNTgwMTVdIEluaXRpYWxpc2Ugc3lzdGVtIHRydXN0
ZWQga2V5cmluZwpbICAgMzEuMTU4MDE1XSBJbml0aWFsaXNlIHN5c3RlbSB0cnVzdGVkIGtl
eXJpbmcKWyAgIDU3LjU3MjAyNV0gQlVHOiBzb2Z0IGxvY2t1cCAtIENQVSMxIHN0dWNrIGZv
ciAyMnMhIFtzd2FwcGVyLzA6MV0KWyAgIDU3LjU3MjAyNV0gQlVHOiBzb2Z0IGxvY2t1cCAt
IENQVSMxIHN0dWNrIGZvciAyMnMhIFtzd2FwcGVyLzA6MV0KWyAgIDU3LjU3MjAyNV0gaXJx
IGV2ZW50IHN0YW1wOiA5MzYwODgKWyAgIDU3LjU3MjAyNV0gaXJxIGV2ZW50IHN0YW1wOiA5
MzYwODgKWyAgIDU3LjU3MjAyNV0gaGFyZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoOTM2MDg3
KTogClsgICA1Ny41NzIwMjVdIGhhcmRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDkzNjA4Nyk6
IFs8NDFjZTliNmY+XSByZXN0b3JlX2FsbF9ub3RyYWNlKzB4MC8weDE4Cls8NDFjZTliNmY+
XSByZXN0b3JlX2FsbF9ub3RyYWNlKzB4MC8weDE4ClsgICA1Ny41NzIwMjVdIGhhcmRpcnFz
IGxhc3QgZGlzYWJsZWQgYXQgKDkzNjA4OCk6IApbICAgNTcuNTcyMDI1XSBoYXJkaXJxcyBs
YXN0IGRpc2FibGVkIGF0ICg5MzYwODgpOiBbPDQxY2U5ZTlmPl0gYXBpY190aW1lcl9pbnRl
cnJ1cHQrMHgyZi8weDNjCls8NDFjZTllOWY+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDJm
LzB4M2MKWyAgIDU3LjU3MjAyNV0gc29mdGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoOTM2MDg2
KTogClsgICA1Ny41NzIwMjVdIHNvZnRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDkzNjA4Nik6
IFs8NDEwNzI4NmQ+XSBfX2RvX3NvZnRpcnErMHgzM2EvMHgzZWMKWzw0MTA3Mjg2ZD5dIF9f
ZG9fc29mdGlycSsweDMzYS8weDNlYwpbICAgNTcuNTcyMDI1XSBzb2Z0aXJxcyBsYXN0IGRp
c2FibGVkIGF0ICg5MzYwODEpOiAKWyAgIDU3LjU3MjAyNV0gc29mdGlycXMgbGFzdCBkaXNh
YmxlZCBhdCAoOTM2MDgxKTogWzw0MTAwNzE1Zj5dIGNhbGxfb25fc3RhY2srMHgxYi8weDJm
Cls8NDEwMDcxNWY+XSBjYWxsX29uX3N0YWNrKzB4MWIvMHgyZgpbICAgNTcuNTcyMDI1XSBD
UFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtMDA2Nzct
ZzFlYWQ2NTggIzEKWyAgIDU3LjU3MjAyNV0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVy
LzAgTm90IHRhaW50ZWQgMy4xNC4wLTAwNjc3LWcxZWFkNjU4ICMxClsgICA1Ny41NzIwMjVd
IEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYp
LCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDU3LjU3MjAyNV0gSGFyZHdhcmUgbmFtZTog
UUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEv
MDEvMjAxMQpbICAgNTcuNTcyMDI1XSB0YXNrOiA1MzA5ODAwMCB0aTogNTMwYTAwMDAgdGFz
ay50aTogNTMwYTAwMDAKWyAgIDU3LjU3MjAyNV0gdGFzazogNTMwOTgwMDAgdGk6IDUzMGEw
MDAwIHRhc2sudGk6IDUzMGEwMDAwClsgICA1Ny41NzIwMjVdIEVJUDogMDA2MDpbPDQxMTIw
NWU1Pl0gRUZMQUdTOiAwMDAwMDIwMiBDUFU6IDEKWyAgIDU3LjU3MjAyNV0gRUlQOiAwMDYw
Ols8NDExMjA1ZTU+XSBFRkxBR1M6IDAwMDAwMjAyIENQVTogMQpbICAgNTcuNTcyMDI1XSBF
SVAgaXMgYXQgZ2Nvdl9pbmZvX2ZpbGVuYW1lKzB4ZC8weDE2ClsgICA1Ny41NzIwMjVdIEVJ
UCBpcyBhdCBnY292X2luZm9fZmlsZW5hbWUrMHhkLzB4MTYKWyAgIDU3LjU3MjAyNV0gRUFY
OiA0MjJmN2Y2OSBFQlg6IDUyMmM5MGYwIEVDWDogMDAwMDAwMDYgRURYOiA0MjI5YTQxMApb
ICAgNTcuNTcyMDI1XSBFQVg6IDQyMmY3ZjY5IEVCWDogNTIyYzkwZjAgRUNYOiAwMDAwMDAw
NiBFRFg6IDQyMjlhNDEwClsgICA1Ny41NzIwMjVdIEVTSTogNDIyOWE0MTAgRURJOiA0MjQ1
YmJjNCBFQlA6IDUzMGExZWRjIEVTUDogNTMwYTFlZGMKWyAgIDU3LjU3MjAyNV0gRVNJOiA0
MjI5YTQxMCBFREk6IDQyNDViYmM0IEVCUDogNTMwYTFlZGMgRVNQOiA1MzBhMWVkYwpbICAg
NTcuNTcyMDI1XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAw
NjgKWyAgIDU3LjU3MjAyNV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUw
IFNTOiAwMDY4ClsgICA1Ny41NzIwMjVdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBD
UjM6IDAyODliMDAwIENSNDogMDAwMDA2YjAKWyAgIDU3LjU3MjAyNV0gQ1IwOiA4MDA1MDAz
YiBDUjI6IDAwMDAwMDAwIENSMzogMDI4OWIwMDAgQ1I0OiAwMDAwMDZiMApbICAgNTcuNTcy
MDI1XSBTdGFjazoKWyAgIDU3LjU3MjAyNV0gU3RhY2s6ClsgICA1Ny41NzIwMjVdICA1MzBh
MWVlYwpbICAgNTcuNTcyMDI1XSAgNTMwYTFlZWMgNDExMWVjZmMgNDExMWVjZmMgNDI0NWJi
YzQgNDI0NWJiYzQgMDAwMDAwMDAgMDAwMDAwMDAgNTMwYTFmMTAgNTMwYTFmMTAgNDExMWZj
N2QgNDExMWZjN2QgNTI4NDY1YTggNTI4NDY1YTggNTIzN2RlZTAgNTIzN2RlZTAKCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC8xZWFkNjU4MTI0ODZjZGE2NTA5MzY4
M2E5OWI4OTA3YTcyNDJmYTkzL2RtZXNnLXlvY3RvLWl2YjQyLTk2OjIwMTQwNzA4MDU0MjM2
OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjg6OgowOjE6NCBhbGxfZ29vZDpiYWQ6YWxs
X2JhZCBib290cwoKQmlzZWN0aW5nOiA2OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNyBzdGVwcykKW2EyMWU0MDg3N2FkMTMwZGU4MzdiMDM5NDU4M2U0
ZjY4ZGMyYWI2YzVdIE1lcmdlIGJyYW5jaCAndGltZXJzLW5vaHotZm9yLWxpbnVzJyBvZiBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2Mv
Ym9vdC1iaXNlY3QvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC9uZXh0Om1hc3RlcjphMjFl
NDA4NzdhZDEzMGRlODM3YjAzOTQ1ODNlNGY2OGRjMmFiNmM1OmJpc2VjdC1saW51eAoKMjAx
NC0wNy0wOC0wNTo0Mjo1NyBhMjFlNDA4NzdhZDEzMGRlODM3YjAzOTQ1ODNlNGY2OGRjMmFi
NmM1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgtYTIxZTQwODc3YWQxMzBkZTgz
N2IwMzk0NTgzZTRmNjhkYzJhYjZjNQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC9hMjFlNDA4NzdhZDEzMGRlODM3YjAzOTQ1ODNl
NGY2OGRjMmFiNmM1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LWEyMWU0MDg3N2FkMTMw
ZGU4MzdiMDM5NDU4M2U0ZjY4ZGMyYWI2YzUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1pYjAzLXNtb2tlL2kzODYtcmFuZGNvbmZp
Zy1pYjEtMDcwODAzMjgtYTIxZTQwODc3YWQxMzBkZTgzN2IwMzk0NTgzZTRmNjhkYzJhYjZj
NQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC9hMjFlNDA4
NzdhZDEzMGRlODM3YjAzOTQ1ODNlNGY2OGRjMmFiNmM1L3ZtbGludXotMy4xNC4wLTAwNjIx
LWdhMjFlNDA4CgoyMDE0LTA3LTA4LTA1OjU2OjU3IGRldGVjdGluZyBib290IHN0YXRlIC4J
NzMJOTAJMTA4CTEzMAkxNDUJMTU2CTE2MwkxOTMJMjEzCTIzMQkyNDcJMjY3CTI4MAkyODkJ
MzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogNTYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCls5OWY3YjAyNWJmYWRkN2ZhYzUyMTZkY2ZiMmEw
ODMxMjgwNDY3NGMwXSBNZXJnZSBicmFuY2ggJ3g4Ni10aHJlYWRpbmZvLWZvci1saW51cycg
b2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90
aXAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvbmV4dDptYXN0ZXI6
OTlmN2IwMjViZmFkZDdmYWM1MjE2ZGNmYjJhMDgzMTI4MDQ2NzRjMDpiaXNlY3QtbGludXgK
CjIwMTQtMDctMDgtMDY6MDQ6NTggOTlmN2IwMjViZmFkZDdmYWM1MjE2ZGNmYjJhMDgzMTI4
MDQ2NzRjMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LTk5ZjdiMDI1YmZhZGQ3
ZmFjNTIxNmRjZmIyYTA4MzEyODA0Njc0YzAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvOTlmN2IwMjViZmFkZDdmYWM1MjE2ZGNm
YjJhMDgzMTI4MDQ2NzRjMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC05OWY3YjAyNWJm
YWRkN2ZhYzUyMTZkY2ZiMmEwODMxMjgwNDY3NGMwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIwMy1zbW9rZS9pMzg2LXJhbmRj
b25maWctaWIxLTA3MDgwMzI4LTk5ZjdiMDI1YmZhZGQ3ZmFjNTIxNmRjZmIyYTA4MzEyODA0
Njc0YzAKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvOTlm
N2IwMjViZmFkZDdmYWM1MjE2ZGNmYjJhMDgzMTI4MDQ2NzRjMC92bWxpbnV6LTMuMTQuMC0w
MDYyOC1nOTlmN2IwMgoKMjAxNC0wNy0wOC0wNjoyMTo1OCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLgk2NQkxNjUJMTgwCTE5NgkyMjgJMjQzCTI2MwkyNzcJMjkxCTI5NC4uLi4uLi4uLi4u
Li4uCTI5NwkyOTkJMzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogNDkgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCltiNmQ3MzllOTU4MTI3MmYw
YmJiZDZlZGQxNTM0MGZiOGUxMDhkZjk2XSBNZXJnZSBicmFuY2ggJ3g4Ni1pb21tdS1mb3It
bGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC90aXAvdGlwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4L25leHQ6
bWFzdGVyOmI2ZDczOWU5NTgxMjcyZjBiYmJkNmVkZDE1MzQwZmI4ZTEwOGRmOTY6YmlzZWN0
LWxpbnV4CgoyMDE0LTA3LTA4LTA2OjM2OjU0IGI2ZDczOWU5NTgxMjcyZjBiYmJkNmVkZDE1
MzQwZmI4ZTEwOGRmOTYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC1iNmQ3Mzll
OTU4MTI3MmYwYmJiZDZlZGQxNTM0MGZiOGUxMDhkZjk2CkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4L2I2ZDczOWU5NTgxMjcyZjBi
YmJkNmVkZDE1MzQwZmI4ZTEwOGRmOTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgtYjZk
NzM5ZTk1ODEyNzJmMGJiYmQ2ZWRkMTUzNDBmYjhlMTA4ZGY5NgprZXJuZWw6IC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC9iNmQ3MzllOTU4MTI3MmYwYmJiZDZlZGQx
NTM0MGZiOGUxMDhkZjk2L3ZtbGludXotMy4xNC4wLTAwNjMwLWdiNmQ3MzllCgoyMDE0LTA3
LTA4LTA2OjM4OjU0IGRldGVjdGluZyBib290IHN0YXRlIAk0CTkJMTkJMjcJMzkJNTEJNTgJ
NzMJODUJOTUJMTA5CTEyMQkxMzAJMTQyCTE1MQkxNjcJMTgxCTE5NgkyMjAJMjM4CTI1Nwky
NjkJMjgwCTI4OQkyOTgJMzAwIFNVQ0NFU1MKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2gg
bWF5IGJlIGJyYW5jaCAndGltZXJzLWNvcmUtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApsaW5lYXItYmlzZWN0
OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qg
c3RhcnQgMWVhZDY1ODEyNDg2Y2RhNjUwOTM2ODNhOTliODkwN2E3MjQyZmE5MyBiNmQ3Mzll
OTU4MTI3MmYwYmJiZDZlZGQxNTM0MGZiOGUxMDhkZjk2IC0tClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIGI2ZDczOWUuLi4gTWVyZ2UgYnJhbmNoICd4ODYtaW9tbXUtZm9yLWxpbnVz
JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlw
L3RpcApIRUFEIGlzIG5vdyBhdCBmY2IyMTMzLi4uIE1lcmdlICdqYmFybmVzL2FzeW5jLWZi
LXByb2JlJyBpbnRvIGRldmVsLXJvYW0taTM4Ni0yMDE0MDUzMDAyMDEKQmlzZWN0aW5nOiAy
MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykK
WzlhZmZiZDI0NThlY2E0NTJlNjNiMTA4ZTFhNjI1OGNmMzcwZjZlYjldIEFSTTogdTMwMDog
bW92ZSB0aW1lciBkcml2ZXIgdG8gY2xvY2tzb3VyY2UKbGluZWFyLWJpc2VjdDogZ2l0IGJp
c2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
Yy9ib290LWJpc2VjdC9saW51eC9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MDgwMzI4L25leHQ6bWFzdGVyOjlhZmZiZDI0NThlY2E0NTJlNjNiMTA4ZTFh
NjI1OGNmMzcwZjZlYjk6YmlzZWN0LWxpbnV4CgoyMDE0LTA3LTA4LTA2OjUzOjM3IDlhZmZi
ZDI0NThlY2E0NTJlNjNiMTA4ZTFhNjI1OGNmMzcwZjZlYjkgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzA4MDMyOC05YWZmYmQyNDU4ZWNhNDUyZTYzYjEwOGUxYTYyNThjZjM3MGY2ZWI5
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgw
MzI4LzlhZmZiZDI0NThlY2E0NTJlNjNiMTA4ZTFhNjI1OGNmMzcwZjZlYjkKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcwODAzMjgtOWFmZmJkMjQ1OGVjYTQ1MmU2M2IxMDhlMWE2MjU4Y2YzNzBm
NmViOQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvbGtwLWliMDMtc21va2UvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC05YWZmYmQy
NDU4ZWNhNDUyZTYzYjEwOGUxYTYyNThjZjM3MGY2ZWI5Cmtlcm5lbDogL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LzlhZmZiZDI0NThlY2E0NTJlNjNiMTA4ZTFhNjI1
OGNmMzcwZjZlYjkvdm1saW51ei0zLjE0LjAtcmMxLTAwMDIzLWc5YWZmYmQyCgoyMDE0LTA3
LTA4LTA3OjAxOjM3IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLgk2CTkJMTQJ
MjgJNDAJNjAJNzQJOTAJOTgJMTE1CTEyMAkxMzcJMTUzCTE2OAkxODEJMTkzCTIxNgkyMzAJ
MjQyCTI1MwkyNjgJMjgyCTI5NQkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMSByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKW2IzZTkwNzIy
ZjZmNTNmYTQ1N2E4ODE0NmE4NzdlMzRlYTcxZDI1ZWFdIGNsb2Nrc291cmNlL2NhZGVuY2Vf
dHRjOiBPdmVyaGF1bCBjbG9ja3NvdXJjZSBmcmVxdWVuY3kgYWRqdXN0bWVudApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC9uZXh0Om1hc3RlcjpiM2U5MDcyMmY2
ZjUzZmE0NTdhODgxNDZhODc3ZTM0ZWE3MWQyNWVhOmJpc2VjdC1saW51eAoKMjAxNC0wNy0w
OC0wNzoxOTozOCBiM2U5MDcyMmY2ZjUzZmE0NTdhODgxNDZhODc3ZTM0ZWE3MWQyNWVhIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgtYjNlOTA3MjJmNmY1M2ZhNDU3YTg4MTQ2
YTg3N2UzNGVhNzFkMjVlYQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzA4MDMyOC9iM2U5MDcyMmY2ZjUzZmE0NTdhODgxNDZhODc3ZTM0ZWE3
MWQyNWVhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LWIzZTkwNzIyZjZmNTNmYTQ1N2E4
ODE0NmE4NzdlMzRlYTcxZDI1ZWEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcwODAzMjgvYjNlOTA3MjJmNmY1M2ZhNDU3YTg4MTQ2YTg3N2UzNGVhNzFkMjVlYS92
bWxpbnV6LTMuMTQuMC1yYzEtMDAwMzUtZ2IzZTkwNzIKCjIwMTQtMDctMDgtMDc6Mjg6Mzgg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMS4JNC4JNS4uCTcJMTAJMTcJMjgJMzkJNDUJNTgJ
NzMJOTEJOTkJMTEyCTEyNQkxNDgJMTU1CTE3MQkxODYJMjA1CTIxNQkyMzQJMjQ0CTI2MAky
NzMJMjg4CTI5OAkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNjIwMWI0ZDYxZmJmMTk0ZGY2
MzcxZmIzMzc2YzUwMjZjYjhmNWVlY10gdGltZXI6IFJlbW92ZSBjb2RlIHJlZHVuZGFuY3kg
d2hpbGUgY2FsbGluZyBnZXRfbm9oel90aW1lcl90YXJnZXQoKQpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGlu
dXgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzA4MDMyOC9uZXh0Om1hc3Rlcjo2MjAxYjRkNjFmYmYxOTRkZjYz
NzFmYjMzNzZjNTAyNmNiOGY1ZWVjOmJpc2VjdC1saW51eAoKMjAxNC0wNy0wOC0wNzo0NToz
OCA2MjAxYjRkNjFmYmYxOTRkZjYzNzFmYjMzNzZjNTAyNmNiOGY1ZWVjIGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcwODAzMjgtNjIwMWI0ZDYxZmJmMTk0ZGY2MzcxZmIzMzc2YzUwMjZj
YjhmNWVlYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzA4MDMyOC82MjAxYjRkNjFmYmYxOTRkZjYzNzFmYjMzNzZjNTAyNmNiOGY1ZWVjCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LTYyMDFiNGQ2MWZiZjE5NGRmNjM3MWZiMzM3NmM1
MDI2Y2I4ZjVlZWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAz
MjgtNjIwMWI0ZDYxZmJmMTk0ZGY2MzcxZmIzMzc2YzUwMjZjYjhmNWVlYwprZXJuZWw6IC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC82MjAxYjRkNjFmYmYxOTRkZjYz
NzFmYjMzNzZjNTAyNmNiOGY1ZWVjL3ZtbGludXotMy4xNC4wLXJjMS0wMDA0MS1nNjIwMWI0
ZAoKMjAxNC0wNy0wOC0wNzo1MDozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMQk5CTE3CTI1
CTMxCTQ2CTUzCTYxCTY5CTgxCTg4CTEwNwkxMjIJMTM5CTE1NQkxNzcJMTk1CTIyOAkyNTkJ
Mjg3CTI5MwkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbYjcxMmM4ZGFlMDU5MzFhNzZiNmMx
N2E0MjU0ZjQwMzc5OGU2Y2FlZl0geDg2OiBocGV0OiBVc2UgcHJvcGVyIGRlc3RydWN0b3Ig
Zm9yIGRlbGF5ZWQgd29yawpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgvb2JqLWJpc2VjdApscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMy
OC9uZXh0Om1hc3RlcjpiNzEyYzhkYWUwNTkzMWE3NmI2YzE3YTQyNTRmNDAzNzk4ZTZjYWVm
OmJpc2VjdC1saW51eAoKMjAxNC0wNy0wOC0wODowMTozOSBiNzEyYzhkYWUwNTkzMWE3NmI2
YzE3YTQyNTRmNDAzNzk4ZTZjYWVmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgt
YjcxMmM4ZGFlMDU5MzFhNzZiNmMxN2E0MjU0ZjQwMzc5OGU2Y2FlZgpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC9iNzEyYzhkYWUw
NTkzMWE3NmI2YzE3YTQyNTRmNDAzNzk4ZTZjYWVmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgw
MzI4LWI3MTJjOGRhZTA1OTMxYTc2YjZjMTdhNDI1NGY0MDM3OThlNmNhZWYKa2VybmVsOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvYjcxMmM4ZGFlMDU5MzFhNzZi
NmMxN2E0MjU0ZjQwMzc5OGU2Y2FlZi92bWxpbnV6LTMuMTQuMC1yYzEtMDAwNDQtZ2I3MTJj
OGQKCjIwMTQtMDctMDgtMDg6MDM6MzkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTMJMTkJMzcJ
NjgJMTI0CTE2OAkyMTAJMjM1CTI3MQkyODUJMjk3CTMwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkK
W2I5N2YwMjkxYTI1MDQyOTFhZWY4NTAwNzdmOThjYWI2OGE1YTJmMzNdIHRpY2s6IFJlbW92
ZSBjb2RlIGR1cGxpY2F0aW9uIGluIHRpY2tfaGFuZGxlX3BlcmlvZGljKCkKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvbmV4dDptYXN0ZXI6Yjk3ZjAyOTFhMjUw
NDI5MWFlZjg1MDA3N2Y5OGNhYjY4YTVhMmYzMzpiaXNlY3QtbGludXgKCjIwMTQtMDctMDgt
MDg6MDk6NTggYjk3ZjAyOTFhMjUwNDI5MWFlZjg1MDA3N2Y5OGNhYjY4YTVhMmYzMyBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LWI5N2YwMjkxYTI1MDQyOTFhZWY4NTAwNzdm
OThjYWI2OGE1YTJmMzMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcwODAzMjgvYjk3ZjAyOTFhMjUwNDI5MWFlZjg1MDA3N2Y5OGNhYjY4YTVh
MmYzMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC1iOTdmMDI5MWEyNTA0MjkxYWVmODUw
MDc3Zjk4Y2FiNjhhNWEyZjMzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzA4MDMyOC1iOTdmMDI5MWEyNTA0MjkxYWVmODUwMDc3Zjk4Y2FiNjhhNWEyZjMzCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4L2I5N2YwMjkxYTI1
MDQyOTFhZWY4NTAwNzdmOThjYWI2OGE1YTJmMzMvdm1saW51ei0zLjE0LjAtcmMxLTAwMDQ2
LWdiOTdmMDI5CgoyMDE0LTA3LTA4LTA4OjE2OjU4IGRldGVjdGluZyBib290IHN0YXRlIC4J
NwkyMgkzNgk2Mwk4OAkxMTYJMTcwCTIxNgkyNTEJMjczCTI5MwkzMDAgU1VDQ0VTUwoKMWVh
ZDY1ODEyNDg2Y2RhNjUwOTM2ODNhOTliODkwN2E3MjQyZmE5MyBpcyB0aGUgZmlyc3QgYmFk
IGNvbW1pdApiaXNlY3QgcnVuIHN1Y2Nlc3MKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMg
Yjk3ZjAyOS4uLiB0aWNrOiBSZW1vdmUgY29kZSBkdXBsaWNhdGlvbiBpbiB0aWNrX2hhbmRs
ZV9wZXJpb2RpYygpCkhFQUQgaXMgbm93IGF0IGI2ZDczOWUuLi4gTWVyZ2UgYnJhbmNoICd4
ODYtaW9tbXUtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvdGlwL3RpcApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC9uZXh0Om1hc3RlcjpiNmQ3MzllOTU4
MTI3MmYwYmJiZDZlZGQxNTM0MGZiOGUxMDhkZjk2OmJpc2VjdC1saW51eAoKMjAxNC0wNy0w
OC0wODoyMzozMCBiNmQ3MzllOTU4MTI3MmYwYmJiZDZlZGQxNTM0MGZiOGUxMDhkZjk2IHJl
dXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC9iNmQ3MzllOTU4MTI3
MmYwYmJiZDZlZGQxNTM0MGZiOGUxMDhkZjk2L3ZtbGludXotMy4xNC4wLTAwNjMwLWdiNmQ3
MzllCgoyMDE0LTA3LTA4LTA4OjIzOjMwIGRldGVjdGluZyBib290IHN0YXRlIC4JMzAzCTMx
NQkzNDYJMzc5CTQwOAk0MzIJNDY3CTQ4Mgk1MTgJNTU0CTU5Mgk2MTcJNjQ1CTczMgk3ODEJ
ODUwCTg2Nwk4OTMJOTAwIFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGI2
ZDczOWUuLi4gTWVyZ2UgYnJhbmNoICd4ODYtaW9tbXUtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApIRUFEIGlz
IG5vdyBhdCBiOTdmMDI5Li4uIHRpY2s6IFJlbW92ZSBjb2RlIGR1cGxpY2F0aW9uIGluIHRp
Y2tfaGFuZGxlX3BlcmlvZGljKCkKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvbmV4dDptYXN0ZXI6Yjk3ZjAyOTFhMjUw
NDI5MWFlZjg1MDA3N2Y5OGNhYjY4YTVhMmYzMzpiaXNlY3QtbGludXgKCjIwMTQtMDctMDgt
MDg6MzM6MzIgYjk3ZjAyOTFhMjUwNDI5MWFlZjg1MDA3N2Y5OGNhYjY4YTVhMmYzMyByZXVz
ZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvYjk3ZjAyOTFhMjUwNDI5
MWFlZjg1MDA3N2Y5OGNhYjY4YTVhMmYzMy92bWxpbnV6LTMuMTQuMC1yYzEtMDAwNDYtZ2I5
N2YwMjkKCjIwMTQtMDctMDgtMDg6MzM6MzMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkzNDIJ
NDMzCTU1Ngk4MjkJODYzCTg5Ngk5MDAgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlv
biB3YXMgYjk3ZjAyOS4uLiB0aWNrOiBSZW1vdmUgY29kZSBkdXBsaWNhdGlvbiBpbiB0aWNr
X2hhbmRsZV9wZXJpb2RpYygpCkhFQUQgaXMgbm93IGF0IGQ1ODRmMmEuLi4gQWRkIGxpbnV4
LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNzA3CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4L25leHQ6bWFzdGVy
OmQ1ODRmMmFjZjVjYzZjNGExNGMzMzA5MzAyMjJkOGU3MGZlMDI0YTY6YmlzZWN0LWxpbnV4
CiBURVNUIEZBSUxVUkUKWyAgMTAxLjE1Mzc1M10gaXJxIGV2ZW50IHN0YW1wOiAyMDA5MTM0
ClsgIDEwMS4xNTM3NTNdIGlycSBldmVudCBzdGFtcDogMjAwOTEzNApbICAxMDEuMTUzNzUz
XSBoYXJkaXJxcyBsYXN0ICBlbmFibGVkIGF0ICgyMDA5MTMzKTogClsgIDEwMS4xNTM3NTNd
IGhhcmRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDIwMDkxMzMpOiBbPDQxZDZmODFhPl0gbXV0
ZXhfbG9ja19uZXN0ZWQrMHg3MmYvMHg4NzQKWzw0MWQ2ZjgxYT5dIG11dGV4X2xvY2tfbmVz
dGVkKzB4NzJmLzB4ODc0ClsgIDEwMS4xNTM3NTNdIGhhcmRpcnFzIGxhc3QgZGlzYWJsZWQg
YXQgKDIwMDkxMzQpOiAKWyAgMTAxLjE1Mzc1M10gaGFyZGlycXMgbGFzdCBkaXNhYmxlZCBh
dCAoMjAwOTEzNCk6IFs8NDFkNzgxMGI+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDJmLzB4
M2MKWzw0MWQ3ODEwYj5dIGFwaWNfdGltZXJfaW50ZXJydXB0KzB4MmYvMHgzYwpbICAxMDEu
MTUzNzUzXSBzb2Z0aXJxcyBsYXN0ICBlbmFibGVkIGF0ICgyMDA5MDk4KTogClsgIDEwMS4x
NTM3NTNdIHNvZnRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDIwMDkwOTgpOiBbPDQxMDcyMjg2
Pl0gX19kb19zb2Z0aXJxKzB4MzM3LzB4M2U5Cls8NDEwNzIyODY+XSBfX2RvX3NvZnRpcnEr
MHgzMzcvMHgzZTkKWyAgMTAxLjE1Mzc1M10gc29mdGlycXMgbGFzdCBkaXNhYmxlZCBhdCAo
MjAwOTA5Myk6IApbICAxMDEuMTUzNzUzXSBzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0ICgy
MDA5MDkzKTogWzw0MTAwNmY1Nz5dIGNhbGxfb25fc3RhY2srMHgxYi8weDJmCls8NDEwMDZm
NTc+XSBjYWxsX29uX3N0YWNrKzB4MWIvMHgyZgpbICAxMDEuMTUzNzUzXSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM0LW5leHQtMjAxNDA3
MDcgIzE5ClsgIDEwMS4xNTM3NTNdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5v
dCB0YWludGVkIDMuMTYuMC1yYzQtbmV4dC0yMDE0MDcwNyAjMTkKWyAgMTAxLjE1Mzc1M10g
SGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5Niks
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAxMDEuMTUzNzUzXSBIYXJkd2FyZSBuYW1lOiBR
RU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8w
MS8yMDExClsgIDEwMS4xNTM3NTNdIHRhc2s6IDUxY2EwMDAwIHRpOiA1MWNhODAwMCB0YXNr
LnRpOiA1MWNhODAwMApbICAxMDEuMTUzNzUzXSB0YXNrOiA1MWNhMDAwMCB0aTogNTFjYTgw
MDAgdGFzay50aTogNTFjYTgwMDAKWyAgMTAxLjE1Mzc1M10gRUlQOiAwMDYwOls8NDEyYjM4
ZmM+XSBFRkxBR1M6IDAwMDAwMjQ2IENQVTogMApbICAxMDEuMTUzNzUzXSBFSVA6IDAwNjA6
Wzw0MTJiMzhmYz5dIEVGTEFHUzogMDAwMDAyNDYgQ1BVOiAwClsgIDEwMS4xNTM3NTNdIEVJ
UCBpcyBhdCBzdHJjbXArMHgxOS8weDM5ClsgIDEwMS4xNTM3NTNdIEVJUCBpcyBhdCBzdHJj
bXArMHgxOS8weDM5ClsgIDEwMS4xNTM3NTNdIEVBWDogNDIzNzIyNmUgRUJYOiA1MzQ3NzNj
MCBFQ1g6IDAwMDAwMDA2IEVEWDogNDIzNjE5NmQKWyAgMTAxLjE1Mzc1M10gRUFYOiA0MjM3
MjI2ZSBFQlg6IDUzNDc3M2MwIEVDWDogMDAwMDAwMDYgRURYOiA0MjM2MTk2ZApbICAxMDEu
MTUzNzUzXSBFU0k6IDQyMzcyMmU5IEVESTogNDIzNjE5ODcgRUJQOiA1MWNhOWVkYyBFU1A6
IDUxY2E5ZWQ0ClsgIDEwMS4xNTM3NTNdIEVTSTogNDIzNzIyZTkgRURJOiA0MjM2MTk4NyBF
QlA6IDUxY2E5ZWRjIEVTUDogNTFjYTllZDQKWyAgMTAxLjE1Mzc1M10gIERTOiAwMDdiIEVT
OiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgIDEwMS4xNTM3NTNdICBEUzog
MDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAxMDEuMTUzNzUz
XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMjljNzAwMCBDUjQ6IDAwMDAw
NmIwClsgIDEwMS4xNTM3NTNdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwMCBDUjM6IDAy
OWM3MDAwIENSNDogMDAwMDA2YjAKWyAgMTAxLjE1Mzc1M10gU3RhY2s6ClsgIDEwMS4xNTM3
NTNdIFN0YWNrOgpbICAxMDEuMTUzNzUzXSAgNDIzNjE5NmQKWyAgMTAxLjE1Mzc1M10gIDQy
MzYxOTZkIDQyNGQ0MmI0IDQyNGQ0MmI0IDUxY2E5ZWVjIDUxY2E5ZWVjIDQxMTIyZTljIDQx
MTIyZTljIDQyNGQ0MmI0IDQyNGQ0MmI0IDAwMDAwMDAwIDAwMDAwMDAwIDUxY2E5ZjEwIDUx
Y2E5ZjEwIDQxMTIzZTE3IDQxMTIzZTE3Cgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcwODAzMjgvZDU4NGYyYWNmNWNjNmM0YTE0YzMzMDkzMDIyMmQ4ZTcwZmUwMjRhNi9kbWVz
Zy1xdWFudGFsLWl2YjQxLTkxOjIwMTQwNzA4MDM0NjA0OmkzODYtcmFuZGNvbmZpZy1pYjEt
MDcwODAzMjg6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvZDU4NGYy
YWNmNWNjNmM0YTE0YzMzMDkzMDIyMmQ4ZTcwZmUwMjRhNi9kbWVzZy15b2N0by1pdmI0Mi02
MjoyMDE0MDcwODAzNDcwNTppMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4L2Q1ODRmMmFjZjVjYzZjNGExNGMzMzA5
MzAyMjJkOGU3MGZlMDI0YTYvZG1lc2cteW9jdG8taXZiNDEtMTE2OjIwMTQwNzA4MDMzMjIx
OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjg6OgozOjM6OCBhbGxfZ29vZDpiYWQ6YWxs
X2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgZDU4NGYyYSBBZGQgbGludXgtbmV4dCBzcGVj
aWZpYyBmaWxlcyBmb3IgMjAxNDA3MDcKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0K
RnJvbSBnaXQ6Ly9naXRtaXJyb3IvbGludXMKICAgY2QzZGU4My4uNDQ4YmZhZCAgbWFzdGVy
ICAgICAtPiBsaW51cy9tYXN0ZXIKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZDU4NGYy
YS4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA3MDcKSEVBRCBp
cyBub3cgYXQgNDQ4YmZhZC4uLiBNZXJnZSBicmFuY2ggJ2Zvci1yYycgb2YgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3J6aGFuZy9saW51eApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4
MDMyOC9saW51czptYXN0ZXI6NDQ4YmZhZDhhMTg1ODc2Y2U4ZGU0ODRhOTIxZDQ5NzY5OTcy
Y2FkNzpiaXNlY3QtbGludXgKCjIwMTQtMDctMDgtMDg6Mzc6NDcgNDQ4YmZhZDhhMTg1ODc2
Y2U4ZGU0ODRhOTIxZDQ5NzY5OTcyY2FkNyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgw
MzI4LTQ0OGJmYWQ4YTE4NTg3NmNlOGRlNDg0YTkyMWQ0OTc2OTk3MmNhZDcKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAzMjgvNDQ4YmZh
ZDhhMTg1ODc2Y2U4ZGU0ODRhOTIxZDQ5NzY5OTcyY2FkNwp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzA4MDMyOC00NDhiZmFkOGExODU4NzZjZThkZTQ4NGE5MjFkNDk3Njk5NzJjYWQ3CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaWIw
My1zbW9rZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MDgwMzI4LTQ0OGJmYWQ4YTE4NTg3NmNl
OGRlNDg0YTkyMWQ0OTc2OTk3MmNhZDcKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pYjEtMDcwODAzMjgvNDQ4YmZhZDhhMTg1ODc2Y2U4ZGU0ODRhOTIxZDQ5NzY5OTcyY2Fk
Ny92bWxpbnV6LTMuMTYuMC1yYzQtMDAwMjAtZzQ0OGJmYWQKCjIwMTQtMDctMDgtMDg6NDE6
NDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uCTEJNAk4CTExCTEzCTIxCTMxCTM0
CTQ3CTYzCTg5CTEwOQkxMTkJMTM3CTE1OAkxODEJMTkxCTE5OQkyMTYJMjMzCTI1NAkyNjQJ
MjgwCTI5OAkzMTIJMzM0CTM0NQkzNTMJMzY1CTM3NAkzOTEJMzk5CTQxNQk0MjEJNDI3CTQ0
Nwk0NzUJNDkwCTUwNQk1MTIJNTQzCTU1OAk1ODAJNjA1CTYyMAk2MzcJNjU3CTY2MQk3MDAJ
NzM5CTc1NAk3NzEJNzg2CTc5Nwk4MjYJODUxCTg2Nwk4ODEJODk0CTkwMCBTVUNDRVNTCgoK
PT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIDQ0OGJmYWQuLi4gTWVyZ2UgYnJhbmNoICdmb3ItcmMnIG9mIGdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9yemhhbmcvbGludXgKSEVBRCBpcyBu
b3cgYXQgZDU4NGYyYS4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAx
NDA3MDcKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1pYjEtMDcwODAzMjgvbmV4dDptYXN0ZXI6ZDU4NGYyYWNmNWNjNmM0YTE0YzMzMDkzMDIy
MmQ4ZTcwZmUwMjRhNjpiaXNlY3QtbGludXgKIFRFU1QgRkFJTFVSRQpbICAxMDEuMTUzNzUz
XSBpcnEgZXZlbnQgc3RhbXA6IDIwMDkxMzQKWyAgMTAxLjE1Mzc1M10gaXJxIGV2ZW50IHN0
YW1wOiAyMDA5MTM0ClsgIDEwMS4xNTM3NTNdIGhhcmRpcnFzIGxhc3QgIGVuYWJsZWQgYXQg
KDIwMDkxMzMpOiAKWyAgMTAxLjE1Mzc1M10gaGFyZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAo
MjAwOTEzMyk6IFs8NDFkNmY4MWE+XSBtdXRleF9sb2NrX25lc3RlZCsweDcyZi8weDg3NApb
PDQxZDZmODFhPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg3MmYvMHg4NzQKWyAgMTAxLjE1Mzc1
M10gaGFyZGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoMjAwOTEzNCk6IApbICAxMDEuMTUzNzUz
XSBoYXJkaXJxcyBsYXN0IGRpc2FibGVkIGF0ICgyMDA5MTM0KTogWzw0MWQ3ODEwYj5dIGFw
aWNfdGltZXJfaW50ZXJydXB0KzB4MmYvMHgzYwpbPDQxZDc4MTBiPl0gYXBpY190aW1lcl9p
bnRlcnJ1cHQrMHgyZi8weDNjClsgIDEwMS4xNTM3NTNdIHNvZnRpcnFzIGxhc3QgIGVuYWJs
ZWQgYXQgKDIwMDkwOTgpOiAKWyAgMTAxLjE1Mzc1M10gc29mdGlycXMgbGFzdCAgZW5hYmxl
ZCBhdCAoMjAwOTA5OCk6IFs8NDEwNzIyODY+XSBfX2RvX3NvZnRpcnErMHgzMzcvMHgzZTkK
Wzw0MTA3MjI4Nj5dIF9fZG9fc29mdGlycSsweDMzNy8weDNlOQpbICAxMDEuMTUzNzUzXSBz
b2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0ICgyMDA5MDkzKTogClsgIDEwMS4xNTM3NTNdIHNv
ZnRpcnFzIGxhc3QgZGlzYWJsZWQgYXQgKDIwMDkwOTMpOiBbPDQxMDA2ZjU3Pl0gY2FsbF9v
bl9zdGFjaysweDFiLzB4MmYKWzw0MTAwNmY1Nz5dIGNhbGxfb25fc3RhY2srMHgxYi8weDJm
ClsgIDEwMS4xNTM3NTNdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWlu
dGVkIDMuMTYuMC1yYzQtbmV4dC0yMDE0MDcwNyAjMTkKWyAgMTAxLjE1Mzc1M10gQ1BVOiAw
IFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjNC1uZXh0LTIw
MTQwNzA3ICMxOQpbICAxMDEuMTUzNzUzXSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJk
IFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsgIDEw
MS4xNTM3NTNdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJ
SVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgMTAxLjE1Mzc1M10gdGFzazog
NTFjYTAwMDAgdGk6IDUxY2E4MDAwIHRhc2sudGk6IDUxY2E4MDAwClsgIDEwMS4xNTM3NTNd
IHRhc2s6IDUxY2EwMDAwIHRpOiA1MWNhODAwMCB0YXNrLnRpOiA1MWNhODAwMApbICAxMDEu
MTUzNzUzXSBFSVA6IDAwNjA6Wzw0MTJiMzhmYz5dIEVGTEFHUzogMDAwMDAyNDYgQ1BVOiAw
ClsgIDEwMS4xNTM3NTNdIEVJUDogMDA2MDpbPDQxMmIzOGZjPl0gRUZMQUdTOiAwMDAwMDI0
NiBDUFU6IDAKWyAgMTAxLjE1Mzc1M10gRUlQIGlzIGF0IHN0cmNtcCsweDE5LzB4MzkKWyAg
MTAxLjE1Mzc1M10gRUlQIGlzIGF0IHN0cmNtcCsweDE5LzB4MzkKWyAgMTAxLjE1Mzc1M10g
RUFYOiA0MjM3MjI2ZSBFQlg6IDUzNDc3M2MwIEVDWDogMDAwMDAwMDYgRURYOiA0MjM2MTk2
ZApbICAxMDEuMTUzNzUzXSBFQVg6IDQyMzcyMjZlIEVCWDogNTM0NzczYzAgRUNYOiAwMDAw
MDAwNiBFRFg6IDQyMzYxOTZkClsgIDEwMS4xNTM3NTNdIEVTSTogNDIzNzIyZTkgRURJOiA0
MjM2MTk4NyBFQlA6IDUxY2E5ZWRjIEVTUDogNTFjYTllZDQKWyAgMTAxLjE1Mzc1M10gRVNJ
OiA0MjM3MjJlOSBFREk6IDQyMzYxOTg3IEVCUDogNTFjYTllZGMgRVNQOiA1MWNhOWVkNApb
ICAxMDEuMTUzNzUzXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6
IDAwNjgKWyAgMTAxLjE1Mzc1M10gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAw
MGUwIFNTOiAwMDY4ClsgIDEwMS4xNTM3NTNdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAw
MCBDUjM6IDAyOWM3MDAwIENSNDogMDAwMDA2YjAKWyAgMTAxLjE1Mzc1M10gQ1IwOiA4MDA1
MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDI5YzcwMDAgQ1I0OiAwMDAwMDZiMApbICAxMDEu
MTUzNzUzXSBTdGFjazoKWyAgMTAxLjE1Mzc1M10gU3RhY2s6ClsgIDEwMS4xNTM3NTNdICA0
MjM2MTk2ZApbICAxMDEuMTUzNzUzXSAgNDIzNjE5NmQgNDI0ZDQyYjQgNDI0ZDQyYjQgNTFj
YTllZWMgNTFjYTllZWMgNDExMjJlOWMgNDExMjJlOWMgNDI0ZDQyYjQgNDI0ZDQyYjQgMDAw
MDAwMDAgMDAwMDAwMDAgNTFjYTlmMTAgNTFjYTlmMTAgNDExMjNlMTcgNDExMjNlMTcKCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyOC9kNTg0ZjJhY2Y1Y2M2YzRhMTRj
MzMwOTMwMjIyZDhlNzBmZTAyNGE2L2RtZXNnLXF1YW50YWwtaXZiNDEtOTE6MjAxNDA3MDgw
MzQ2MDQ6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMyODo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzA4MDMyOC9kNTg0ZjJhY2Y1Y2M2YzRhMTRjMzMwOTMwMjIyZDhlNzBm
ZTAyNGE2L2RtZXNnLXlvY3RvLWl2YjQyLTYyOjIwMTQwNzA4MDM0NzA1OmkzODYtcmFuZGNv
bmZpZy1pYjEtMDcwODAzMjg6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcwODAz
MjgvZDU4NGYyYWNmNWNjNmM0YTE0YzMzMDkzMDIyMmQ4ZTcwZmUwMjRhNi9kbWVzZy15b2N0
by1pdmI0MS0xMTY6MjAxNDA3MDgwMzMyMjE6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzA4MDMy
ODo6CjM6Mzo4IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgo=

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-00677-g1ead658"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_CE is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
# CONFIG_STA2X11 is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_ES7000 is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
# CONFIG_X86_LONGRUN is not set
CONFIG_X86_LONGHAUL=y
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_I82365=y
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
CONFIG_MTD_PCMCIA_ANONYMOUS=y
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_ATMEL_PWM is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_INPORT=y
# CONFIG_MOUSE_ATIXL is not set
# CONFIG_MOUSE_LOGIBM is not set
CONFIG_MOUSE_PC110PAD=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
# CONFIG_TOUCHSCREEN_DA9034 is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_HTCPEN is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_W90X900 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_SUR40=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_HYPERV_KEYBOARD=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MRST_MAX3110=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_ATMEL is not set
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_EXYNOS is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
CONFIG_DTLK=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_MUX_PINCTRL=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_PINMUX is not set
# CONFIG_PINCONF is not set
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_BAYTRAIL is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
CONFIG_ACPI_INT3403_THERMAL=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_RDC321X_WDT is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_DA903X=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_I915_FBDEV is not set
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
# CONFIG_DRM_I915_UMS is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
# CONFIG_DRM_BOCHS is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
CONFIG_FB_HYPERV=y
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=y
CONFIG_SND_PORTMAN2X4=y
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB8_DSP=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=y
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
CONFIG_SND_ALS100=y
CONFIG_SND_AZT1605=y
CONFIG_SND_AZT2316=y
CONFIG_SND_AZT2320=y
CONFIG_SND_CMI8328=y
CONFIG_SND_CMI8330=y
CONFIG_SND_CS4231=y
CONFIG_SND_CS4236=y
CONFIG_SND_ES1688=y
CONFIG_SND_ES18XX=y
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
CONFIG_SND_GUSEXTREME=y
CONFIG_SND_GUSMAX=y
CONFIG_SND_INTERWAVE=y
# CONFIG_SND_INTERWAVE_STB is not set
CONFIG_SND_JAZZ16=y
CONFIG_SND_OPL3SA2=y
CONFIG_SND_OPTI92X_AD1848=y
# CONFIG_SND_OPTI92X_CS4231 is not set
CONFIG_SND_OPTI93X=y
CONFIG_SND_MIRO=y
# CONFIG_SND_SB8 is not set
CONFIG_SND_SB16=y
CONFIG_SND_SBAWE=y
# CONFIG_SND_SB16_CSP is not set
CONFIG_SND_SSCAPE=y
CONFIG_SND_WAVEFRONT=y
# CONFIG_SND_MSND_PINNACLE is not set
# CONFIG_SND_MSND_CLASSIC is not set
# CONFIG_SND_PCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
# CONFIG_SND_USB_CAIAQ_INPUT is not set
CONFIG_SND_USB_US122L=y
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_USB_HIFACE is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
CONFIG_SND_DICE=y
# CONFIG_SND_FIREWIRE_SPEAKERS is not set
CONFIG_SND_ISIGHT=y
CONFIG_SND_SCS1X=y
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
# CONFIG_SND_PDAUDIOCF is not set
CONFIG_SND_SOC=y
# CONFIG_SND_ATMEL_SOC is not set
# CONFIG_SND_DESIGNWARE_I2S is not set
CONFIG_SND_SOC_I2C_AND_SPI=y
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
CONFIG_SOUND_TRIX=y
# CONFIG_TRIX_HAVE_BOOT is not set
CONFIG_SOUND_MSS=y
CONFIG_SOUND_MPU401=y
CONFIG_SOUND_PAS=y
# CONFIG_PAS_JOYSTICK is not set
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=y
# CONFIG_SOUND_YM3812 is not set
CONFIG_SOUND_UART6850=y
CONFIG_SOUND_AEDSP16=y
# CONFIG_SC6600 is not set
CONFIG_SOUND_KAHLUA=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_HYPERV_MOUSE=y
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_RENESAS_USBHS_HCD is not set
CONFIG_USB_WHCI_HCD=y
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_KEYSTONE=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_SIMPLE=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
# CONFIG_USB_SERIAL_FTDI_SIO is not set
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MXUPORT=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
CONFIG_USB_GR_UDC=y
CONFIG_USB_R8A66597=y
CONFIG_USB_RENESAS_USBHS_UDC=y
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
# CONFIG_USB_M66592 is not set
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_SS_LB=y
CONFIG_USB_U_SERIAL=y
CONFIG_USB_F_SERIAL=y
CONFIG_USB_F_OBEX=y
CONFIG_USB_CONFIGFS=y
CONFIG_USB_CONFIGFS_SERIAL=y
# CONFIG_USB_CONFIGFS_ACM is not set
CONFIG_USB_CONFIGFS_OBEX=y
# CONFIG_USB_CONFIGFS_NCM is not set
# CONFIG_USB_CONFIGFS_ECM is not set
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
# CONFIG_USB_CONFIGFS_EEM is not set
CONFIG_USB_CONFIGFS_F_LB_SS=y
# CONFIG_USB_CONFIGFS_F_FS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_BALLOON=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_WMI=y
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_TC1100_WMI is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
CONFIG_HP_WMI=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_CHROMEOS_PSTORE is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_WM831X=y
CONFIG_COMMON_CLK_MAX77686=y
# CONFIG_COMMON_CLK_SI5351 is not set
CONFIG_COMMON_CLK_S2MPS11=y
# CONFIG_CLK_TWL6040 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX8997=y
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--Kj7319i9nmIyA2yE--
