Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaCMB3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:29:54 -0400
Received: from [143.182.124.21] ([143.182.124.21]:48564 "EHLO mga03.intel.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752239AbaCMB3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:29:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,642,1389772800"; 
   d="log'?scan'208";a="490929803"
Date: Thu, 13 Mar 2014 09:27:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [locking/mutexes] WARNING: CPU: 1 PID: 77 at
 kernel/locking/mutex-debug.c:82 debug_mutex_unlock()
Message-ID: <20140313012744.GA7714@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jason,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/locking

commit 1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Tue Jan 28 11:13:14 2014 -0800
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Tue Mar 11 12:14:54 2014 +0100

    locking/mutexes: Unlock the mutex without the wait_lock
    
+----------------------------------------------------------------------+------------+------------+
|                                                                      | 1d8fe7dc80 | 221f19a662 |
+----------------------------------------------------------------------+------------+------------+
| boot_successes                                                       | 2          | 1          |
| boot_failures                                                        | 18         | 18         |
| WARNING:CPU:PID:at_kernel/locking/mutex-debug.c:debug_mutex_unlock() | 18         | 18         |
| backtrace:do_fork                                                    | 3          | 2          |
| backtrace:SyS_clone                                                  | 3          | 2          |
| backtrace:kobject_add_internal                                       | 1          |            |
| backtrace:kobject_init_and_add                                       | 1          |            |
| backtrace:acpi_bus_register_driver                                   | 1          |            |
| backtrace:acpi_battery_init_async                                    | 1          |            |
| backtrace:async_run_entry_fn                                         | 1          |            |
| backtrace:do_execve                                                  | 2          | 1          |
| backtrace:SyS_execve                                                 | 2          | 1          |
| backtrace:user_path_at                                               | 1          |            |
| backtrace:SyS_faccessat                                              | 1          |            |
| backtrace:SyS_access                                                 | 1          |            |
| backtrace:user_statfs                                                | 1          | 1          |
| backtrace:SyS_statfs                                                 | 1          | 1          |
| backtrace:serio_handle_event                                         | 2          | 2          |
| backtrace:vm_mmap_pgoff                                              | 2          | 1          |
| backtrace:SyS_mmap_pgoff                                             | 2          | 1          |
| backtrace:SyS_mmap                                                   | 2          | 1          |
| backtrace:do_group_exit                                              | 1          | 4          |
| backtrace:SyS_exit_group                                             | 1          | 4          |
| backtrace:vfs_stat                                                   | 1          |            |
| backtrace:SyS_newstat                                                | 1          |            |
| backtrace:mprotect_fixup                                             | 3          | 4          |
| backtrace:SyS_mprotect                                               | 3          | 4          |
| backtrace:misc_register                                              | 1          |            |
| backtrace:wafwdt_init                                                | 1          |            |
| backtrace:kernel_init_freeable                                       | 1          |            |
+----------------------------------------------------------------------+------------+------------+

[    5.550712] debug: unmapping init [mem 0xffffffff81c28000-0xffffffff81d5cfff]
[    5.573371] random: init urandom read with 6 bits of entropy available
[    5.636471] ------------[ cut here ]------------
[    5.637033] WARNING: CPU: 1 PID: 77 at kernel/locking/mutex-debug.c:82 debug_mutex_unlock+0x211/0x220()
[    5.637033] DEBUG_LOCKS_WARN_ON(lock->owner != current)
[    5.637033] Modules linked in:
[    5.637033] CPU: 1 PID: 77 Comm: sh Not tainted 3.14.0-rc6-01849-g221f19a #2
[    5.637033] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.637033]  0000000000000009 ffff8800070bfc98 ffffffff816e5665 ffff8800070bfce0
[    5.637033]  ffff8800070bfcd0 ffffffff8106ad6d ffff88000c86d3a0 0000000000000001
[    5.637033]  0000000000000246 00000000000000b0 ffff88000c86d300 ffff8800070bfd30
[    5.637033] Call Trace:
[    5.637033]  [<ffffffff816e5665>] dump_stack+0x4d/0x66
[    5.637033]  [<ffffffff8106ad6d>] warn_slowpath_common+0x7d/0xa0
[    5.637033]  [<ffffffff8106addc>] warn_slowpath_fmt+0x4c/0x50
[    5.637033]  [<ffffffff810be531>] debug_mutex_unlock+0x211/0x220
[    5.637033]  [<ffffffff816f12db>] __mutex_unlock_slowpath+0xdb/0x210
[    5.637033]  [<ffffffff816f141e>] mutex_unlock+0xe/0x10
[    5.637033]  [<ffffffff8116f8ef>] vma_link+0x7f/0xd0
[    5.637033]  [<ffffffff81171a74>] mmap_region+0x494/0x670
[    5.637033]  [<ffffffff810c405e>] ? __lock_acquire+0x48e/0xcc0
[    5.637033]  [<ffffffff81171f62>] do_mmap_pgoff+0x312/0x3e0
[    5.637033]  [<ffffffff81160230>] vm_mmap_pgoff+0x90/0xc0
[    5.637033]  [<ffffffff811705b7>] SyS_mmap_pgoff+0xe7/0x110
[    5.637033]  [<ffffffff810082e2>] SyS_mmap+0x22/0x30
[    5.637033]  [<ffffffff816f4639>] system_call_fastpath+0x16/0x1b
[    5.637033] ---[ end trace 926fb1180f642ed0 ]---
[    5.798610] init: Failed to create pty - disabling logging for job

git bisect start 221f19a662f536aa8640694e744019776d2df584 8712a00514e50aafa7c9bf5cd3955fa60758e53b --
git bisect  bad 8d8ec3963d9d341ca73b817a931f274807ecc5ae  # 15:55      0-      2  Merge branch 'x86/asmlinkage'
git bisect  bad b4a4183f983cfed78029b7ce9a7b809da742b794  # 16:32      0-      5  Merge branch 'perf/urgent'
git bisect  bad 319309fdafea7717522b94e406ea3429fd9498b4  # 16:44      0-      2  Merge branch 'core/types'
git bisect  bad cbdc4aaf1932bbf23934443126f610b64d53e7ce  # 17:39      0-      1  manual merge of core/locking
git bisect good 47be1c1a0e188232b5e5962917b21750053cd3f8  # 18:09     20+      0  lockdep: Change lockdep_set_novalidate_class() to use _and_name
git bisect good c9122da1e2d29bd6a1475a0d1ce2aa6ac6ea25fa  # 18:46     20+      0  locking: Move mcs_spinlock.h into kernel/locking/
git bisect  bad 1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8  # 19:22      0-      9  locking/mutexes: Unlock the mutex without the wait_lock
git bisect good 47667fa1502e4d759df87e9cc7fbc0f202483361  # 20:14     20+      0  locking/mutexes: Modify the way optimistic spinners are queued
# first bad commit: [1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8] locking/mutexes: Unlock the mutex without the wait_lock
git bisect good 47667fa1502e4d759df87e9cc7fbc0f202483361  # 20:28     60+      0  locking/mutexes: Modify the way optimistic spinners are queued
git bisect  bad 221f19a662f536aa8640694e744019776d2df584  # 20:28      0-     18  Merge branch 'tools/kvm'
git bisect good 33807f4f0daec3b00565c2932d95f614f5833adf  # 21:43     60+      0  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
git bisect good 69d5cdda16b3c9767b82d80b07edb9bb056448e3  # 22:40     60+      1  Add linux-next specific files for 20140311
git bisect  bad 6670a8a6f7e711b45114e6c66871d8bbc22a59ed  # 22:41      0-      9  Merge branch 'timers/core'

Thanks,
Fengguang

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-jaketown-35:20140312142835:x86_64-randconfig-c6-0312::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc6-01849-g221f19a (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #2 SMP Wed Mar 12 14:25:00 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c6-0312/tip:master/.vmli=
nuz-221f19a662f536aa8640694e744019776d2df584-20140312142552-6-jaketown bran=
ch=3Dtip/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-c6-0312/221f19a662f5=
36aa8640694e744019776d2df584/vmlinuz-3.14.0-rc6-01849-g221f19a
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x027d0000, 0x027d0fff] PGTABLE
[    0.000000] BRK [0x027d1000, 0x027d1fff] PGTABLE
[    0.000000] BRK [0x027d2000, 0x027d2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x027d3000, 0x027d3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x027d4000, 0x027d4fff] PGTABLE
[    0.000000] BRK [0x027d5000, 0x027d5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:e8bd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88000e400000 s78912 r8192=
 d23488 u1048576
[    0.000000] pcpu-alloc: s78912 r8192 d23488 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:e8bd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e40cc40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c6-0312/tip:maste=
r/.vmlinuz-221f19a662f536aa8640694e744019776d2df584-20140312142552-6-jaketo=
wn branch=3Dtip/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-c6-0312/221f1=
9a662f536aa8640694e744019776d2df584/vmlinuz-3.14.0-rc6-01849-g221f19a
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 207700K/261744K available (7129K kernel code, 1573K =
rwdata, 3732K rodata, 1236K init, 10676K bss, 54044K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc6-01849-g221f19a (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #2 SMP Wed Mar 12 14:25:00 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c6-0312/tip:master/.vmli=
nuz-221f19a662f536aa8640694e744019776d2df584-20140312142552-6-jaketown bran=
ch=3Dtip/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-c6-0312/221f19a662f5=
36aa8640694e744019776d2df584/vmlinuz-3.14.0-rc6-01849-g221f19a
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x027d0000, 0x027d0fff] PGTABLE
[    0.000000] BRK [0x027d1000, 0x027d1fff] PGTABLE
[    0.000000] BRK [0x027d2000, 0x027d2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x027d3000, 0x027d3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x027d4000, 0x027d4fff] PGTABLE
[    0.000000] BRK [0x027d5000, 0x027d5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:e8bd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88000e400000 s78912 r8192=
 d23488 u1048576
[    0.000000] pcpu-alloc: s78912 r8192 d23488 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:e8bd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e40cc40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c6-0312/tip:maste=
r/.vmlinuz-221f19a662f536aa8640694e744019776d2df584-20140312142552-6-jaketo=
wn branch=3Dtip/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-c6-0312/221f1=
9a662f536aa8640694e744019776d2df584/vmlinuz-3.14.0-rc6-01849-g221f19a
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 207700K/261744K available (7129K kernel code, 1573K =
rwdata, 3732K rodata, 1236K init, 10676K bss, 54044K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 11 of 11 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 1599.960 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 3199.92 Bogo=
MIPS (lpj=3D1599960)
[    0.004033] pid_max: default: 32768 minimum: 301
[    0.006738] Security Framework initialized
[    0.008211] Mount-cache hash table entries: 256
[    0.012543] Initializing cgroup subsys devices
[    0.013108] Initializing cgroup subsys blkio
[    0.014422] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014422] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.014422] tlb_flushall_shift: 6
[    0.015152] debug: unmapping init [mem 0xffffffff81d5d000-0xffffffff81d6=
1fff]
[    0.029676] ftrace: allocating 23616 entries in 93 pages
[    0.049927] Getting VERSION: 50014
[    0.050047] Getting VERSION: 50014
[    0.051045] Getting ID: 0
[    0.052058] Getting ID: ff000000
[    0.053054] Getting LVT0: 8700
[    0.054044] Getting LVT1: 8400
[    0.055270] enabled ExtINT on CPU#0
[    0.060600] ENABLING IO-APIC IRQs
[    0.062037] init IO_APIC IRQs
[    0.063027]  apic 0 pin 0 not connected
[    0.064117] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.065139] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.066121] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.067123] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.068107] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.069124] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.071040] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.072111] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.073114] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.074133] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.075120] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.076167] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.077122] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.078131] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.079120] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.080099]  apic 0 pin 16 not connected
[    0.081023]  apic 0 pin 17 not connected
[    0.082024]  apic 0 pin 18 not connected
[    0.083022]  apic 0 pin 19 not connected
[    0.084033]  apic 0 pin 20 not connected
[    0.085022]  apic 0 pin 21 not connected
[    0.086023]  apic 0 pin 22 not connected
[    0.087023]  apic 0 pin 23 not connected
[    0.088260] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.089021] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.093014] Using local APIC timer interrupts.
[    0.093014] calibrating APIC timer ...
[    0.095000] ... lapic delta =3D 6249816
[    0.095000] ... PM-Timer delta =3D 357838
[    0.095000] ... PM-Timer result ok
[    0.095000] ..... delta 6249816
[    0.095000] ..... mult: 268427553
[    0.095000] ..... calibration result: 999970
[    0.095000] ..... CPU clock speed is 1599.0405 MHz.
[    0.095000] ..... host bus clock speed is 999.0970 MHz.
[    0.095269] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.101811] x86: Booting SMP configuration:
[    0.102016] .... node  #0, CPUs:      #1
[    0.003000] kvm-clock: cpu 1, msr 0:e8bd041, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.120328] KVM setup async PF for cpu 1
[    0.120492] x86: Booted up 1 node, 2 CPUs
[    0.120497] smpboot: Total of 2 processors activated (6399.84 BogoMIPS)
[    0.121859] kvm-stealtime: cpu 1, msr e50cc40
[    0.138625] devtmpfs: initialized
[    0.149323] xor: measuring software checksum speed
[    0.160015]    prefetch64-sse:  4432.000 MB/sec
[    0.171015]    generic_sse:  3688.000 MB/sec
[    0.172012] xor: using function: prefetch64-sse (4432.000 MB/sec)
[    0.173044] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.175912] regulator-dummy: no parameters
[    0.177148] NET: Registered protocol family 16
[    0.179767] cpuidle: using governor menu
[    0.180261] ACPI: bus type PCI registered
[    0.181096] PCI: Using configuration type 1 for base access
[    0.195109] bio: create slab <bio-0> at 0
[    0.214028] raid6: sse2x1    3031 MB/s
[    0.232015] raid6: sse2x2    3789 MB/s
[    0.250025] raid6: sse2x4    4371 MB/s
[    0.251013] raid6: using algorithm sse2x4 (4371 MB/s)
[    0.252012] raid6: using intx1 recovery algorithm
[    0.253514] ACPI: Added _OSI(Module Device)
[    0.254015] ACPI: Added _OSI(Processor Device)
[    0.255013] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.256013] ACPI: Added _OSI(Processor Aggregator Device)
[    0.274625] ACPI: Interpreter enabled
[    0.275025] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.278022] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.281098] ACPI: (supports S0 S3 S5)
[    0.282013] ACPI: Using IOAPIC for interrupt routing
[    0.284082] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.317807] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.318029] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.319131] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.322528] PCI host bridge to bus 0000:00
[    0.323021] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.324017] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.325018] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.326016] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.327016] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.329088] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.332721] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.335612] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.343017] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.348696] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.350622] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.351042] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.353832] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.356111] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.359104] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.372107] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.375365] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.378015] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.381018] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.392019] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.394959] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.397014] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.407154] pci_bus 0000:00: on NUMA node 0
[    0.410784] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.414246] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.419114] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.424454] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.429202] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.435000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.438397] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.439031] vgaarb: loaded
[    0.440016] vgaarb: bridge control possible 0000:00:02.0
[    0.443308] SCSI subsystem initialized
[    0.444172] libata version 3.00 loaded.
[    0.445124] ACPI: bus type USB registered
[    0.446276] usbcore: registered new interface driver usbfs
[    0.448121] usbcore: registered new interface driver hub
[    0.450534] usbcore: registered new device driver usb
[    0.451358] pps_core: LinuxPPS API ver. 1 registered
[    0.452013] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.453061] PTP clock support registered
[    0.454391] PCI: Using ACPI for IRQ routing
[    0.455028] PCI: pci_cache_line_size set to 64 bytes
[    0.456362] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.457052] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.460725] NET: Registered protocol family 8
[    0.461014] NET: Registered protocol family 20
[    0.463696] Switched to clocksource kvm-clock
[    0.470770] Warning: could not register annotated branches stats
[    0.570228] pnp: PnP ACPI init
[    0.573430] ACPI: bus type PNP registered
[    0.577091] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.584375] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.589577] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.596447] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.601264] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.608104] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.613163] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.619485] pnp 00:03: [dma 2]
[    0.622832] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.627803] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.634730] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.640089] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.646852] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.653434] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.659401] pnp: PnP ACPI: found 7 devices
[    0.663066] ACPI: bus type PNP unregistered
[    0.703427] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.708077] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.712232] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.717094] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.722266] NET: Registered protocol family 1
[    0.726155] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.730903] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.735536] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.740453] pci 0000:00:02.0: Boot video device
[    0.744450] PCI: CLS 0 bytes, default 64
[    0.749799] Unpacking initramfs...
[    2.855540] debug: unmapping init [mem 0xffff88000e93d000-0xffff88000ffe=
ffff]
[    2.944096] DMA-API: preallocated 65536 debug entries
[    2.946651] DMA-API: debugging enabled by kernel config
[    2.951454] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    2.957223] PCLMULQDQ-NI instructions are not detected.
[    2.959762] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.962616] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.965453] AVX or AES-NI instructions are not detected.
[    2.967975] AVX instructions are not detected.
[    2.970215] AVX2 or AES-NI instructions are not detected.
[    2.974335] futex hash table entries: 512 (order: 4, 65536 bytes)
[    2.977369] Initialise system trusted keyring
[    2.979863] audit: initializing netlink subsys (disabled)
[    2.982718] audit: type=3D2000 audit(1394605646.969:1): initialized
[    2.989216] VFS: Disk quotas dquot_6.5.2
[    2.991614] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.998406] GFS2 installed
[    3.000186] msgmni has been set to 405
[    3.028214] alg: No test for stdrng (krng)
[    3.030645] NET: Registered protocol family 38
[    3.033146] Key type asymmetric registered
[    3.035491] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    3.039658] io scheduler noop registered (default)
[    3.042134] io scheduler deadline registered
[    3.044350] test_string_helpers: Running tests...
[    3.059284] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    3.061739] crc32: self tests passed, processed 225944 bytes in 5974602 =
nsec
[    3.071765] crc32c: CRC_LE_BITS =3D 1
[    3.073711] crc32c: self tests passed, processed 225944 bytes in 3412545=
 nsec
[    3.851662] crc32_combine: 8373 self tests passed
[    3.952264] tsc: Refined TSC clocksource calibration: 1599.926 MHz
[    4.573404] crc32c_combine: 8373 self tests passed
[    4.584837] no IO addresses supplied
[    4.586974] usbcore: registered new interface driver smscufx
[    4.589696] ipmi message handler version 39.2
[    4.591983] IPMI System Interface driver.
[    4.594298] ipmi_si: Adding default-specified kcs state machine
[    4.597249] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.601836] ipmi_si: Interface detection failed
[    4.608145] ipmi_si: Adding default-specified smic state machine
[    4.611133] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    4.615760] ipmi_si: Interface detection failed
[    4.622093] ipmi_si: Adding default-specified bt state machine
[    4.624984] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    4.629540] ipmi_si: Interface detection failed
[    4.635478] ipmi_si: Unable to find any System Interface(s)
[    4.638078] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    4.642617] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.646478] ACPI: Power Button [PWRF]
[    4.650175] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.652733] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.681280] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.688400] serial: Freescale lpuart driver
[    4.690757] smapi::smapi_init, ERROR invalid usSmapiID
[    4.693199] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.697549] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.701310] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.704419] parport_pc 00:04: reported by Plug and Play ACPI
[    4.707401] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    4.800866] blk-mq: CPU -> queue map
[    4.804117]   CPU 0 -> Queue 0
[    4.807086]   CPU 1 -> Queue 0
[    4.813249]  nullb0: unknown partition table
[    4.817952] blk-mq: CPU -> queue map
[    4.821160]   CPU 0 -> Queue 0
[    4.824192]   CPU 1 -> Queue 0
[    4.828812]  nullb1: unknown partition table
[    4.833725] null: module loaded
[    4.836980] lkdtm: No crash points registered, enable through debugfs
[    4.841940] usbcore: registered new interface driver viperboard
[    4.846407] Loading iSCSI transport class v2.0-870.
[    4.851636] hp_sw: device handler registered
[    4.855248] emc: device handler registered
[    4.858699] alua: device handler registered
[    4.862322] osst :I: Tape driver with OnStream support version 0.99.4
[    4.862322] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    4.872888] parport_pc 00:04: registered master spi32766 (dynamic)
[    4.878320] spi spi32766.0: spi_bitbang_setup, 166 nsec/bit
[    4.882666] spi spi32766.0: setup mode 0, 3wire, 8 bits/w, 6000000 Hz ma=
x --> 0
[    4.889248] parport_pc 00:04: registered child spi32766.0
[    4.893556] spi spi32766.0: spidev_lm70 at spi32766.0
[    4.897781] paride: aten registered as protocol 0
[    4.901483] paride: comm registered as protocol 1
[    4.905301] paride: epia registered as protocol 2
[    4.908936] paride: frpw registered as protocol 3
[    4.912895] paride: ktti registered as protocol 4
[    4.916999] pcd: pcd version 1.07, major 46, nice 0
[    4.920695] parport0: no more devices allowed
[    4.924509] parport0: no more devices allowed
[    4.928250] parport0: no more devices allowed
[    4.931762] parport0: no more devices allowed
[    4.935155] parport0: no more devices allowed
[    4.938815] pcd0: Autoprobe failed
[    4.941916] pcd: No CD-ROM drive found
[    4.945168] pt: pt version 1.04, major 96
[    4.948602] parport0: no more devices allowed
[    4.952091] parport0: no more devices allowed
[    4.955825] parport0: no more devices allowed
[    4.959274] parport0: no more devices allowed
[    4.962948] parport0: no more devices allowed
[    4.966490] pt0: Autoprobe failed
[    4.969600] pt: No ATAPI tape drive detected
[    4.974374] usbcore: registered new interface driver cdc_acm
[    4.978678] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    4.985196] usbcore: registered new interface driver usbtmc
[    4.989791] usbcore: registered new interface driver usb-storage
[    4.994241] usbcore: registered new interface driver ums-freecom
[    4.998839] usbcore: registered new interface driver ums-jumpshot
[    5.003520] usbcore: registered new interface driver ums-onetouch
[    5.008287] usbcore: registered new interface driver ums-realtek
[    5.012855] usbcore: registered new interface driver ums-usbat
[    5.017280] usbcore: registered new interface driver cytherm
[    5.021657] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    5.026682] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    5.029818] usbcore: registered new interface driver trancevibrator
[    5.032810] usbcore: registered new interface driver cxacru
[    5.035497] usbcore: registered new interface driver speedtch
[    5.038370] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.044460] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.046906] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.183548] usbcore: registered new interface driver iforce
[    5.186486] usbcore: registered new interface driver gtco
[    5.189091] usbcore: registered new interface driver hanwang
[    5.191766] usbcore: registered new interface driver wacom
[    5.194702] pps_parport: parallel port PPS client
[    5.197042] parport0: no more devices allowed
[    5.199236] pps_parport: couldn't register with parport0
[    5.201832] Driver for 1-wire Dallas network protocol.
[    5.204455] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    5.207335] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    5.212517] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    5.217136] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    5.219473] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.224682] sc1200wdt: build 20020303
[    5.226830] sc1200wdt: io parameter must be specified
[    5.229468] pc87413_wdt: Version 1.1 at io 0x2E
[    5.231860] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    5.234964] sbc60xxwdt: I/O address 0x0443 already in use
[    5.237644] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    5.240595] w83697hf_wdt: watchdog not found at address 0x2e
[    5.243347] w83697hf_wdt: No W83697HF/HG could be found
[    5.245966] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    5.249224] ledtrig-cpu: registered to indicate activity on CPUs
[    5.252947] parport0: no more devices allowed
[    5.255273] panel: panel_attach: port->number=3D0 parport=3D0, parport_r=
egister_device() failed
[    5.259467] panel: driver version 0.9.5 not yet registered
[    5.262227] usbcore: registered new interface driver tranzport
[    5.265130] usbcore: registered new interface driver alphatrack
[    5.267902] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    5.271065] Copyright 2010. Beceem Communications Inc
[    5.273754] usbcore: registered new interface driver usbbcm
[    5.277917] usbcore: registered new interface driver cedusb
[    5.280699] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[    5.284053] dgap: For the tools package or updated drivers please visit =
http://www.digi.com
[    5.290844] netem: version 1.3
[    5.292924] NET: Registered protocol family 4
[    5.295401] NET: Registered protocol family 9
[    5.297722] X25: Linux Version 0.2
[    5.299787] lec:lane_module_init: lec.c: initialized
[    5.302269] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    5.306720] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    5.309930] NET: Registered protocol family 12
[    5.312336] 9pnet: Installing 9P2000 support
[    5.314762] NET: Registered protocol family 37
[    5.317526] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[    5.322003]=20
[    5.322003] printing PIC contents
[    5.325090] ... PIC  IMR: ffff
[    5.326053] ... PIC  IRR: 1013
[    5.328838] ... PIC  ISR: 0000
[    5.330755] ... PIC ELCR: 0c00
[    5.332644] printing local APIC contents on CPU#0/0:
[    5.333604] ... APIC ID:      00000000 (0)
[    5.333604] ... APIC VERSION: 00050014
[    5.333604] ... APIC TASKPRI: 00000000 (00)
[    5.333604] ... APIC PROCPRI: 00000000
[    5.333604] ... APIC LDR: 01000000
[    5.333604] ... APIC DFR: ffffffff
[    5.333604] ... APIC SPIV: 000001ff
[    5.333604] ... APIC ISR field:
[    5.333604] 000000000000000000000000000000000000000000000000000000000000=
0000
[    5.333604] ... APIC TMR field:
[    5.333604] 000000000200000000000000000000000000000000000000000000000000=
0000
[    5.333604] ... APIC IRR field:
[    5.333604] 000000000000000000000000000000000000000000000000000000000000=
8000
[    5.333604] ... APIC ESR: 00000000
[    5.333604] ... APIC ICR: 000008fd
[    5.333604] ... APIC ICR2: 02000000
[    5.333604] ... APIC LVTT: 000000ef
[    5.333604] ... APIC LVTPC: 00010000
[    5.333604] ... APIC LVT0: 00010700
[    5.333604] ... APIC LVT1: 00000400
[    5.333604] ... APIC LVTERR: 000000fe
[    5.333604] ... APIC TMICT: 00005ea6
[    5.333604] ... APIC TMCCT: 00000000
[    5.333604] ... APIC TDCR: 00000003
[    5.333604]=20
[    5.401066] number of MP IRQ sources: 15.
[    5.403220] number of IO-APIC #0 registers: 24.
[    5.405553] testing the IO APIC.......................
[    5.408107] IO APIC #0......
[    5.409895] .... register #00: 00000000
[    5.412001] .......    : physical APIC id: 00
[    5.414272] .......    : Delivery Type: 0
[    5.416449] .......    : LTS          : 0
[    5.418590] .... register #01: 00170011
[    5.420694] .......     : max redirection entries: 17
[    5.423187] .......     : PRQ implemented: 0
[    5.425429] .......     : IO APIC version: 11
[    5.427683] .... register #02: 00000000
[    5.429783] .......     : arbitration: 00
[    5.431950] .... IRQ redirection table:
[    5.434083] 1    0    0   0   0    0    0    00
[    5.436429] 0    0    0   0   0    1    1    31
[    5.438772] 0    0    0   0   0    1    1    30
[    5.441124] 0    0    0   0   0    1    1    33
[    5.443471] 1    0    0   0   0    1    1    34
[    5.445823] 1    1    0   0   0    1    1    35
[    5.448169] 0    0    0   0   0    1    1    36
[    5.450522] 0    0    0   0   0    1    1    37
[    5.452866] 0    0    0   0   0    1    1    38
[    5.455223] 0    1    0   0   0    1    1    39
[    5.457581] 1    1    0   0   0    1    1    3A
[    5.459930] 1    1    0   0   0    1    1    3B
[    5.462284] 0    0    0   0   0    1    1    3C
[    5.464627] 0    0    0   0   0    1    1    3D
[    5.466971] 0    0    0   0   0    1    1    3E
[    5.469323] 0    0    0   0   0    1    1    3F
[    5.471674] 1    0    0   0   0    0    0    00
[    5.474043] 1    0    0   0   0    0    0    00
[    5.476382] 1    0    0   0   0    0    0    00
[    5.478731] 1    0    0   0   0    0    0    00
[    5.481081] 1    0    0   0   0    0    0    00
[    5.483430] 1    0    0   0   0    0    0    00
[    5.485771] 1    0    0   0   0    0    0    00
[    5.488144] 1    0    0   0   0    0    0    00
[    5.490466] IRQ to pin mappings:
[    5.492348] IRQ0 -> 0:2
[    5.494468] IRQ1 -> 0:1
[    5.496573] IRQ3 -> 0:3
[    5.498698] IRQ4 -> 0:4
[    5.500812] IRQ5 -> 0:5
[    5.502936] IRQ6 -> 0:6
[    5.505100] IRQ7 -> 0:7
[    5.507208] IRQ8 -> 0:8
[    5.509306] IRQ9 -> 0:9
[    5.511436] IRQ10 -> 0:10
[    5.513609] IRQ11 -> 0:11
[    5.515783] IRQ12 -> 0:12
[    5.517953] IRQ13 -> 0:13
[    5.520161] IRQ14 -> 0:14
[    5.522337] IRQ15 -> 0:15
[    5.524514] .................................... done.
[    5.527981] Loading compiled-in X.509 certificates
[    5.531303] bio: create slab <bio-1> at 1
[    5.535241] Btrfs loaded, debug=3Don, assert=3Don
[    5.540862] regulator-dummy: disabling
[    5.544893] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[    5.550712] debug: unmapping init [mem 0xffffffff81c28000-0xffffffff81d5=
cfff]
[    5.573371] random: init urandom read with 6 bits of entropy available
[    5.636471] ------------[ cut here ]------------
[    5.637033] WARNING: CPU: 1 PID: 77 at kernel/locking/mutex-debug.c:82 d=
ebug_mutex_unlock+0x211/0x220()
[    5.637033] DEBUG_LOCKS_WARN_ON(lock->owner !=3D current)
[    5.637033] Modules linked in:
[    5.637033] CPU: 1 PID: 77 Comm: sh Not tainted 3.14.0-rc6-01849-g221f19=
a #2
[    5.637033] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.637033]  0000000000000009 ffff8800070bfc98 ffffffff816e5665 ffff8800=
070bfce0
[    5.637033]  ffff8800070bfcd0 ffffffff8106ad6d ffff88000c86d3a0 00000000=
00000001
[    5.637033]  0000000000000246 00000000000000b0 ffff88000c86d300 ffff8800=
070bfd30
[    5.637033] Call Trace:
[    5.637033]  [<ffffffff816e5665>] dump_stack+0x4d/0x66
[    5.637033]  [<ffffffff8106ad6d>] warn_slowpath_common+0x7d/0xa0
[    5.637033]  [<ffffffff8106addc>] warn_slowpath_fmt+0x4c/0x50
[    5.637033]  [<ffffffff810be531>] debug_mutex_unlock+0x211/0x220
[    5.637033]  [<ffffffff816f12db>] __mutex_unlock_slowpath+0xdb/0x210
[    5.637033]  [<ffffffff816f141e>] mutex_unlock+0xe/0x10
[    5.637033]  [<ffffffff8116f8ef>] vma_link+0x7f/0xd0
[    5.637033]  [<ffffffff81171a74>] mmap_region+0x494/0x670
[    5.637033]  [<ffffffff810c405e>] ? __lock_acquire+0x48e/0xcc0
[    5.637033]  [<ffffffff81171f62>] do_mmap_pgoff+0x312/0x3e0
[    5.637033]  [<ffffffff81160230>] vm_mmap_pgoff+0x90/0xc0
[    5.637033]  [<ffffffff811705b7>] SyS_mmap_pgoff+0xe7/0x110
[    5.637033]  [<ffffffff810082e2>] SyS_mmap+0x22/0x30
[    5.637033]  [<ffffffff816f4639>] system_call_fastpath+0x16/0x1b
[    5.637033] ---[ end trace 926fb1180f642ed0 ]---
[    5.798610] init: Failed to create pty - disabling logging for job
[    5.801897] init: Temporary process spawn error: No such file or directo=
ry
[    5.829542] init: Failed to create pty - disabling logging for job
[    5.832623] init: Temporary process spawn error: No such file or directo=
ry
[    5.883978] init: Failed to create pty - disabling logging for job
[    5.887171] init: Temporary process spawn error: No such file or directo=
ry
[    5.893152] init: Failed to create pty - disabling logging for job
[    5.896243] init: Temporary process spawn error: No such file or directo=
ry
[    5.968710] init: Failed to create pty - disabling logging for job
[    5.971828] init: Temporary process spawn error: No such file or directo=
ry
[    5.983383] init: Failed to create pty - disabling logging for job
[    5.986958] init: Temporary process spawn error: No such file or directo=
ry
[    6.002093] init: Failed to create pty - disabling logging for job
[    6.021958] init: Failed to create pty - disabling logging for job
[    6.030188] init: Failed to create pty - disabling logging for job
[    6.037687] init: Failed to create pty - disabling logging for job
[    6.044367] init: Failed to create pty - disabling logging for job
[    6.050600] init: Failed to create pty - disabling logging for job
[    6.130203] init: Failed to create pty - disabling logging for job
[    6.138072] init: Failed to create pty - disabling logging for job
[    6.145774] init: Failed to create pty - disabling logging for job
[    6.165145] init: Failed to create pty - disabling logging for job
[    6.394190] init: Failed to create pty - disabling logging for job
[    6.408736] init: Failed to create pty - disabling logging for job
[    6.417732] init: Failed to create pty - disabling logging for job
[    6.425922] init: Failed to create pty - disabling logging for job
[    6.431641] init: Failed to create pty - disabling logging for job
Kernel tests: Boot OK!
[   65.778319] init: Failed to create pty - disabling logging for job
[   66.952819] reboot: Restarting system
Elapsed time: 75
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-c6-0312/221f19a662f536aa8640694e744019776d2df584/vmlinuz-3.14.0-rc6-01849-=
g221f19a -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/x86_64-randconfig-c6-0312/tip:master/.vmlinuz-221f19a=
662f536aa8640694e744019776d2df584-20140312142552-6-jaketown branch=3Dtip/ma=
ster BOOT_IMAGE=3D/kernel/x86_64-randconfig-c6-0312/221f19a662f536aa8640694=
e744019776d2df584/vmlinuz-3.14.0-rc6-01849-g221f19a'  -initrd /kernel-tests=
/initrd/quantal-core-x86_64.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De10=
00 -net user,vlan=3D1,hostfwd=3Dtcp::17103-:22 -boot order=3Dnc -no-reboot =
-watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quanta=
l-jaketown-35 -serial file:/dev/shm/kboot/serial-quantal-jaketown-35 -daemo=
nize -display none -monitor null=20

--fdj2RfSjLxBAspz7
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-c6-0312-221f19a662f536aa8640694e744019776d2df584-WARNING:---at----debug_mutex_unlock+-x-21447.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDg3MTJhMDA1MTRlNTBhYWZhN2M5YmY1Y2QzOTU1ZmE2MDc1OGU1M2IK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM2
LTAzMTIvdGlwOm1hc3Rlcjo4NzEyYTAwNTE0ZTUwYWFmYTdjOWJmNWNkMzk1NWZhNjA3NThl
NTNiOmJpc2VjdC1uZXQKCjIwMTQtMDMtMTItMTQ6NDQ6MTcgODcxMmEwMDUxNGU1MGFhZmE3
YzliZjVjZDM5NTVmYTYwNzU4ZTUzYiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLTg3
MTJhMDA1MTRlNTBhYWZhN2M5YmY1Y2QzOTU1ZmE2MDc1OGU1M2IKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvODcxMmEwMDUxNGU1MGFh
ZmE3YzliZjVjZDM5NTVmYTYwNzU4ZTUzYgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi04NzEy
YTAwNTE0ZTUwYWFmYTdjOWJmNWNkMzk1NWZhNjA3NThlNTNiCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWct
YzYtMDMxMi04NzEyYTAwNTE0ZTUwYWFmYTdjOWJmNWNkMzk1NWZhNjA3NThlNTNiCmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzg3MTJhMDA1MTRlNTBhYWZh
N2M5YmY1Y2QzOTU1ZmE2MDc1OGU1M2Ivdm1saW51ei0zLjE0LjAtcmM2LTAwMDE3LWc4NzEy
YTAwCgoyMDE0LTAzLTEyLTE1OjI1OjE4IGRldGVjdGluZyBib290IHN0YXRlIC4JMQkxMgky
MCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDg3MTJhMDA1MTRlNTBhYWZhN2M5YmY1
Y2QzOTU1ZmE2MDc1OGU1M2IKZ2l0IGJpc2VjdCBzdGFydCAyMjFmMTlhNjYyZjUzNmFhODY0
MDY5NGU3NDQwMTk3NzZkMmRmNTg0IDg3MTJhMDA1MTRlNTBhYWZhN2M5YmY1Y2QzOTU1ZmE2
MDc1OGU1M2IgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiMjIx
ZjE5YTY2MmY1MzZhYTg2NDA2OTRlNzQ0MDE5Nzc2ZDJkZjU4NCIsICItZyIsICI4NzEyYTAw
NTE0ZTUwYWFmYTdjOWJmNWNkMzk1NWZhNjA3NThlNTNiIiwgIi9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0
Il0KQmlzZWN0aW5nOiAxODMyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAxMSBzdGVwcykKWzhkOGVjMzk2M2Q5ZDM0MWNhNzNiODE3YTkzMWYyNzQ4MDdl
Y2M1YWVdIE1lcmdlIGJyYW5jaCAneDg2L2FzbWxpbmthZ2UnCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLWM2LTAzMTIvdGlwOm1hc3Rlcjo4ZDhlYzM5NjNkOWQzNDFjYTczYjgxN2E5MzFmMjc0
ODA3ZWNjNWFlOmJpc2VjdC1uZXQKCjIwMTQtMDMtMTItMTU6Mjc6MjMgOGQ4ZWMzOTYzZDlk
MzQxY2E3M2I4MTdhOTMxZjI3NDgwN2VjYzVhZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1jNi0w
MzEyLThkOGVjMzk2M2Q5ZDM0MWNhNzNiODE3YTkzMWYyNzQ4MDdlY2M1YWUKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvOGQ4ZWMzOTYz
ZDlkMzQxY2E3M2I4MTdhOTMxZjI3NDgwN2VjYzVhZQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYzYtMDMx
Mi04ZDhlYzM5NjNkOWQzNDFjYTczYjgxN2E5MzFmMjc0ODA3ZWNjNWFlCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRj
b25maWctYzYtMDMxMi04ZDhlYzM5NjNkOWQzNDFjYTczYjgxN2E5MzFmMjc0ODA3ZWNjNWFl
Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzhkOGVjMzk2M2Q5
ZDM0MWNhNzNiODE3YTkzMWYyNzQ4MDdlY2M1YWUvdm1saW51ei0zLjE0LjAtcmM2LTAwMzQx
LWc4ZDhlYzM5CgoyMDE0LTAzLTEyLTE1OjU0OjIzIGRldGVjdGluZyBib290IHN0YXRlIC4u
IFRFU1QgRkFJTFVSRQpbICAgIDcuMjYwOTcyXSBpbml0OiBGYWlsZWQgdG8gY3JlYXRlIHB0
eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgICA3LjI2MzA2MF0gaW5pdDogVGVt
cG9yYXJ5IHByb2Nlc3Mgc3Bhd24gZXJyb3I6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkK
WyAgICA3LjI5NjQ0Ml0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsg
ICAgNy4yOTcwMTZdIFdBUk5JTkc6IENQVTogMSBQSUQ6IDEwNCBhdCBrZXJuZWwvbG9ja2lu
Zy9tdXRleC1kZWJ1Zy5jOjgyIGRlYnVnX211dGV4X3VubG9jaysweDIxMS8weDIyMCgpClsg
ICAgNy4yOTcwMTZdIERFQlVHX0xPQ0tTX1dBUk5fT04obG9jay0+b3duZXIgIT0gY3VycmVu
dCkKWyAgICA3LjI5NzAxNl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgNy4yOTcwMTZdIENQ
VTogMSBQSUQ6IDEwNCBDb21tOiBzaCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM2LTAwMzQxLWc4
ZDhlYzM5ICM3ClsgICAgNy4yOTcwMTZdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBC
SU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA3LjI5NzAxNl0gIDAwMDAwMDAwMDAwMDAwMDkg
ZmZmZjg4MDAwNzFlYmIzMCBmZmZmZmZmZjgxNmU1MTQ1IGZmZmY4ODAwMDcxZWJiNzgKWyAg
ICA3LjI5NzAxNl0gIGZmZmY4ODAwMDcxZWJiNjggZmZmZmZmZmY4MTA2YThhZCBmZmZmODgw
MDBjODNiZGQwIDAwMDAwMDAwMDAwMDAwMDEKWyAgICA3LjI5NzAxNl0gIDAwMDAwMDAwMDAw
MDAyNDYgMDAwMDAwMDAwMDAwMDU0ZSBmZmZmODgwMDA3MGZmMjAwIGZmZmY4ODAwMDcxZWJi
YzgKWyAgICA3LjI5NzAxNl0gQ2FsbCBUcmFjZToKWyAgICA3LjI5NzAxNl0gIFs8ZmZmZmZm
ZmY4MTZlNTE0NT5dIGR1bXBfc3RhY2srMHg0ZC8weDY2ClsgICAgNy4yOTcwMTZdICBbPGZm
ZmZmZmZmODEwNmE4YWQ+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDdkLzB4YTAKWyAgICA3
LjI5NzAxNl0gIFs8ZmZmZmZmZmY4MTA2YTkxYz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NGMv
MHg1MApbICAgIDcuMjk3MDE2XSAgWzxmZmZmZmZmZjgxMGJlMDcxPl0gZGVidWdfbXV0ZXhf
dW5sb2NrKzB4MjExLzB4MjIwClsgICAgNy4yOTcwMTZdICBbPGZmZmZmZmZmODE2ZjBkYmI+
XSBfX211dGV4X3VubG9ja19zbG93cGF0aCsweGRiLzB4MjEwClsgICAgNy4yOTcwMTZdICBb
PGZmZmZmZmZmODE2ZjBlZmU+XSBtdXRleF91bmxvY2srMHhlLzB4MTAKWyAgICA3LjI5NzAx
Nl0gIFs8ZmZmZmZmZmY4MTE2ZjMwYT5dIHVubGlua19maWxlX3ZtYSsweDRhLzB4NjAKWyAg
ICA3LjI5NzAxNl0gIFs8ZmZmZmZmZmY4MTE2ODFlMj5dIGZyZWVfcGd0YWJsZXMrMHg5Mi8w
eGUwClsgICAgNy4yOTcwMTZdICBbPGZmZmZmZmZmODExNzFjMzY+XSBleGl0X21tYXArMHhh
Ni8weDE5MApbICAgIDcuMjk3MDE2XSAgWzxmZmZmZmZmZjgxMDY3ODYxPl0gbW1wdXQrMHg2
MS8weGUwClsgICAgNy4yOTcwMTZdICBbPGZmZmZmZmZmODExOTM2NzE+XSBmbHVzaF9vbGRf
ZXhlYysweDZmMS8weDlhMApbICAgIDcuMjk3MDE2XSAgWzxmZmZmZmZmZjgxMWU2NmE4Pl0g
bG9hZF9lbGZfYmluYXJ5KzB4MzE4LzB4ZTUwClsgICAgNy4yOTcwMTZdICBbPGZmZmZmZmZm
ODEwYzdjY2M+XSA/IGRvX3Jhd19yZWFkX3VubG9jaysweDJjLzB4NTAKWyAgICA3LjI5NzAx
Nl0gIFs8ZmZmZmZmZmY4MTE5MzlhOT5dIHNlYXJjaF9iaW5hcnlfaGFuZGxlcisweDg5LzB4
MWEwClsgICAgNy4yOTcwMTZdICBbPGZmZmZmZmZmODExOTQ2NjA+XSBkb19leGVjdmUrMHg2
MjAvMHg3ZTAKWyAgICA3LjI5NzAxNl0gIFs8ZmZmZmZmZmY4MTE5NDVjZj5dID8gZG9fZXhl
Y3ZlKzB4NThmLzB4N2UwClsgICAgNy4yOTcwMTZdICBbPGZmZmZmZmZmODExOTRhODU+XSBT
eVNfZXhlY3ZlKzB4MjUvMHgzMApbICAgIDcuMjk3MDE2XSAgWzxmZmZmZmZmZjgxNmY0NmE5
Pl0gc3R1Yl9leGVjdmUrMHg2OS8weGEwClsgICAgNy4yOTcwMTZdIC0tLVsgZW5kIHRyYWNl
IDc4MTdmOTFiMmJlZDM2OWIgXS0tLQpbICAgIDcuNDUzNzgwXSBpbml0OiBGYWlsZWQgdG8g
Y3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jNi0wMzEyLzhkOGVjMzk2M2Q5ZDM0MWNhNzNiODE3YTkzMWYyNzQ4MDdl
Y2M1YWUvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtNjQ6MjAxNDAzMTIxNTU1MTQ6eDg2XzY0
LXJhbmRjb25maWctYzYtMDMxMjo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMx
Mi84ZDhlYzM5NjNkOWQzNDFjYTczYjgxN2E5MzFmMjc0ODA3ZWNjNWFlL2RtZXNnLXF1YW50
YWwtbGtwLW5leDA0LTE2OjIwMTQwMzEyMTU1NTE4Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAz
MTI6OgowOjI6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0x
MiAxNTo1NToyNSBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvbmV0LWJpc2VjdC8ucmVw
ZWF0G1swbQoKQmlzZWN0aW5nOiAzMjQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDkgc3RlcHMpCltiNGE0MTgzZjk4M2NmZWQ3ODAyOWI3Y2U5YTdiODA5
ZGE3NDJiNzk0XSBNZXJnZSBicmFuY2ggJ3BlcmYvdXJnZW50JwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1jNi0wMzEyL3RpcDptYXN0ZXI6YjRhNDE4M2Y5ODNjZmVkNzgwMjliN2NlOWE3Yjgw
OWRhNzQyYjc5NDpiaXNlY3QtbmV0CgoyMDE0LTAzLTEyLTE1OjU1OjI2IGI0YTQxODNmOTgz
Y2ZlZDc4MDI5YjdjZTlhN2I4MDlkYTc0MmI3OTQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYzYt
MDMxMi1iNGE0MTgzZjk4M2NmZWQ3ODAyOWI3Y2U5YTdiODA5ZGE3NDJiNzk0CkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyL2I0YTQxODNm
OTgzY2ZlZDc4MDI5YjdjZTlhN2I4MDlkYTc0MmI3OTQKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAz
MTItYjRhNDE4M2Y5ODNjZmVkNzgwMjliN2NlOWE3YjgwOWRhNzQyYjc5NAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5k
Y29uZmlnLWM2LTAzMTItYjRhNDE4M2Y5ODNjZmVkNzgwMjliN2NlOWE3YjgwOWRhNzQyYjc5
NAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi9iNGE0MTgzZjk4
M2NmZWQ3ODAyOWI3Y2U5YTdiODA5ZGE3NDJiNzk0L3ZtbGludXotMy4xNC4wLXJjNi0wMDIw
NC1nYjRhNDE4MwoKMjAxNC0wMy0xMi0xNjozMToyNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAu
LiBURVNUIEZBSUxVUkUKWyAgICAzLjUxMDIzNV0gZGVidWc6IHVubWFwcGluZyBpbml0IFtt
ZW0gMHhmZmZmZmZmZjgxYzI0MDAwLTB4ZmZmZmZmZmY4MWQ1OGZmZl0KWyAgICAzLjUyODg5
MV0gcmFuZG9tOiBpbml0IHVyYW5kb20gcmVhZCB3aXRoIDUgYml0cyBvZiBlbnRyb3B5IGF2
YWlsYWJsZQpbICAgIDMuNTQ1MzczXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0KWyAgICAzLjU0NjAxOV0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBrZXJuZWwv
bG9ja2luZy9tdXRleC1kZWJ1Zy5jOjgyIGRlYnVnX211dGV4X3VubG9jaysweDIxMS8weDIy
MCgpClsgICAgMy41NDYwMTldIERFQlVHX0xPQ0tTX1dBUk5fT04obG9jay0+b3duZXIgIT0g
Y3VycmVudCkKWyAgICAzLjU0NjAxOV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMy41NDYw
MTldIENQVTogMCBQSUQ6IDEgQ29tbTogaW5pdCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM2LTAw
MjA0LWdiNGE0MTgzICMxMApbICAgIDMuNTQ2MDE5XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBC
b2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMy41NDYwMTldICAwMDAwMDAwMDAw
MDAwMDA5IGZmZmY4ODAwMTIwY2ZjYzggZmZmZmZmZmY4MTZlNDkyNSBmZmZmODgwMDEyMGNm
ZDEwClsgICAgMy41NDYwMTldICBmZmZmODgwMDEyMGNmZDAwIGZmZmZmZmZmODEwNmE4YWQg
ZmZmZjg4MDAxMDgzYWRkMCAwMDAwMDAwMDAwMDAwMDAxClsgICAgMy41NDYwMTldICAwMDAw
MDAwMDAwMDAwMjQ2IDAwMDAwMDAwMDAwMDAwM2MgZmZmZjg4MDAwYjBiYTAwMCBmZmZmODgw
MDEyMGNmZDYwClsgICAgMy41NDYwMTldIENhbGwgVHJhY2U6ClsgICAgMy41NDYwMTldICBb
PGZmZmZmZmZmODE2ZTQ5MjU+XSBkdW1wX3N0YWNrKzB4NGQvMHg2NgpbICAgIDMuNTQ2MDE5
XSAgWzxmZmZmZmZmZjgxMDZhOGFkPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3ZC8weGEw
ClsgICAgMy41NDYwMTldICBbPGZmZmZmZmZmODEwNmE5MWM+XSB3YXJuX3Nsb3dwYXRoX2Zt
dCsweDRjLzB4NTAKWyAgICAzLjU0NjAxOV0gIFs8ZmZmZmZmZmY4MTBiZDZiMT5dIGRlYnVn
X211dGV4X3VubG9jaysweDIxMS8weDIyMApbICAgIDMuNTQ2MDE5XSAgWzxmZmZmZmZmZjgx
NmYwNWJiPl0gX19tdXRleF91bmxvY2tfc2xvd3BhdGgrMHhkYi8weDIxMApbICAgIDMuNTQ2
MDE5XSAgWzxmZmZmZmZmZjgxNmYwNmZlPl0gbXV0ZXhfdW5sb2NrKzB4ZS8weDEwClsgICAg
My41NDYwMTldICBbPGZmZmZmZmZmODEwNjg4NGY+XSBjb3B5X3Byb2Nlc3MucGFydC40Nysw
eGNlZi8weDFjYzAKWyAgICAzLjU0NjAxOV0gIFs8ZmZmZmZmZmY4MTA2OWEyMD5dIGRvX2Zv
cmsrMHgxMDAvMHg0YTAKWyAgICAzLjU0NjAxOV0gIFs8ZmZmZmZmZmY4MTE2NmZjZj5dID8g
bWlnaHRfZmF1bHQrMHg1Zi8weGIwClsgICAgMy41NDYwMTldICBbPGZmZmZmZmZmODE2ZjM5
MjU+XSA/IHN5c3JldF9jaGVjaysweDIyLzB4NWQKWyAgICAzLjU0NjAxOV0gIFs8ZmZmZmZm
ZmY4MTA2OWU0Nj5dIFN5U19jbG9uZSsweDE2LzB4MjAKWyAgICAzLjU0NjAxOV0gIFs8ZmZm
ZmZmZmY4MTZmM2M1OT5dIHN0dWJfY2xvbmUrMHg2OS8weDkwClsgICAgMy41NDYwMTldICBb
PGZmZmZmZmZmODE2ZjM4Zjk+XSA/IHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpb
ICAgIDMuNTQ2MDE5XSAtLS1bIGVuZCB0cmFjZSBiMWQzODIxMTJhY2JmMTg1IF0tLS0KWyAg
ICAzLjczMDUxOF0gaW5pdDogRmFpbGVkIHRvIGNyZWF0ZSBwdHkgLSBkaXNhYmxpbmcgbG9n
Z2luZyBmb3Igam9iCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi9iNGE0MTgz
Zjk4M2NmZWQ3ODAyOWI3Y2U5YTdiODA5ZGE3NDJiNzk0L2RtZXNnLXF1YW50YWwtaXZ5dG93
bjItMTI6MjAxNDAzMTIxNjMyMTQ6eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMjozLjE0LjAt
cmM2LTAwMjA0LWdiNGE0MTgzOjEwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMx
Mi9iNGE0MTgzZjk4M2NmZWQ3ODAyOWI3Y2U5YTdiODA5ZGE3NDJiNzk0L2RtZXNnLXF1YW50
YWwtaXZ5dG93bjItMTg6MjAxNDAzMTIxNjMyMDg6eDg2XzY0LXJhbmRjb25maWctYzYtMDMx
MjozLjE0LjAtcmM2LTAwMjA0LWdiNGE0MTgzOjEwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzYtMDMxMi9iNGE0MTgzZjk4M2NmZWQ3ODAyOWI3Y2U5YTdiODA5ZGE3NDJiNzk0L2Rt
ZXNnLXlvY3RvLWl2eXRvd24yLTEwOjIwMTQwMzEyMTYzMjEyOng4Nl82NC1yYW5kY29uZmln
LWM2LTAzMTI6My4xNC4wLXJjNi0wMDIwNC1nYjRhNDE4MzoxMAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWM2LTAzMTIvYjRhNDE4M2Y5ODNjZmVkNzgwMjliN2NlOWE3YjgwOWRhNzQy
Yjc5NC9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTI5OjIwMTQwMzEyMTYzMjE2Ong4Nl82NC1y
YW5kY29uZmlnLWM2LTAzMTI6My4xNC4wLXJjNi0wMDIwNC1nYjRhNDE4MzoxMAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvYjRhNDE4M2Y5ODNjZmVkNzgwMjliN2NlOWE3
YjgwOWRhNzQyYjc5NC9kbWVzZy15b2N0by1pdnl0b3duMi0xOToyMDE0MDMxMjE2MzIxNzp4
ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyOjMuMTQuMC1yYzYtMDAyMDQtZ2I0YTQxODM6MTAK
MDo1OjUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMTIgMTY6
MzI6MjggUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mvd2ZnL25ldC1iaXNlY3QvLnJlcGVhdBtb
MG0KCkJpc2VjdGluZzogMTg3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA4IHN0ZXBzKQpbMzE5MzA5ZmRhZmVhNzcxNzUyMmI5NGU0MDZlYTM0MjlmZDk0
OThiNF0gTWVyZ2UgYnJhbmNoICdjb3JlL3R5cGVzJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1j
Ni0wMzEyL3RpcDptYXN0ZXI6MzE5MzA5ZmRhZmVhNzcxNzUyMmI5NGU0MDZlYTM0MjlmZDk0
OThiNDpiaXNlY3QtbmV0CgoyMDE0LTAzLTEyLTE2OjMyOjI5IDMxOTMwOWZkYWZlYTc3MTc1
MjJiOTRlNDA2ZWEzNDI5ZmQ5NDk4YjQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi0z
MTkzMDlmZGFmZWE3NzE3NTIyYjk0ZTQwNmVhMzQyOWZkOTQ5OGI0CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzMxOTMwOWZkYWZlYTc3
MTc1MjJiOTRlNDA2ZWEzNDI5ZmQ5NDk4YjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTItMzE5
MzA5ZmRhZmVhNzcxNzUyMmI5NGU0MDZlYTM0MjlmZDk0OThiNAp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmln
LWM2LTAzMTItMzE5MzA5ZmRhZmVhNzcxNzUyMmI5NGU0MDZlYTM0MjlmZDk0OThiNAprZXJu
ZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8zMTkzMDlmZGFmZWE3NzE3
NTIyYjk0ZTQwNmVhMzQyOWZkOTQ5OGI0L3ZtbGludXotMy4xNC4wLXJjNi0wMDEyMy1nMzE5
MzA5ZgoKMjAxNC0wMy0xMi0xNjo0MzoyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4gVEVT
VCBGQUlMVVJFClsgICAgMi4yMjg3OTZdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5IC0g
ZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgIDIuMjI5OTYxXSBpbml0OiBUZW1wb3Jh
cnkgcHJvY2VzcyBzcGF3biBlcnJvcjogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpbICAg
IDIuMjQ0MjExXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAy
LjI0NTAxNV0gV0FSTklORzogQ1BVOiAwIFBJRDogMTAzIGF0IGtlcm5lbC9sb2NraW5nL211
dGV4LWRlYnVnLmM6ODIgZGVidWdfbXV0ZXhfdW5sb2NrKzB4MjExLzB4MjIwKCkKWyAgICAy
LjI0NTAxNV0gREVCVUdfTE9DS1NfV0FSTl9PTihsb2NrLT5vd25lciAhPSBjdXJyZW50KQpb
ICAgIDIuMjQ1MDE1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAyLjI0NTAxNV0gQ1BVOiAw
IFBJRDogMTAzIENvbW06IHNoIE5vdCB0YWludGVkIDMuMTQuMC1yYzYtMDAxMjMtZzMxOTMw
OWYgIzExClsgICAgMi4yNDUwMTVdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9T
IEJvY2hzIDAxLzAxLzIwMTEKWyAgICAyLjI0NTAxNV0gIDAwMDAwMDAwMDAwMDAwMDkgZmZm
Zjg4MDAwYjFjNWIzMCBmZmZmZmZmZjgxNmUzNzU3IGZmZmY4ODAwMGIxYzViNzgKWyAgICAy
LjI0NTAxNV0gIGZmZmY4ODAwMGIxYzViNjggZmZmZmZmZmY4MTA2OThhZCBmZmZmODgwMDEw
ODNjZGQwIDAwMDAwMDAwMDAwMDAwMDEKWyAgICAyLjI0NTAxNV0gIDAwMDAwMDAwMDAwMDAy
NDYgMDAwMDAwMDAwMDAwMDU1NiBmZmZmODgwMDBiMTZkMTAwIGZmZmY4ODAwMGIxYzViYzgK
WyAgICAyLjI0NTAxNV0gQ2FsbCBUcmFjZToKWyAgICAyLjI0NTAxNV0gIFs8ZmZmZmZmZmY4
MTZlMzc1Nz5dIGR1bXBfc3RhY2srMHg0ZC8weDY2ClsgICAgMi4yNDUwMTVdICBbPGZmZmZm
ZmZmODEwNjk4YWQ+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDdkLzB4YTAKWyAgICAyLjI0
NTAxNV0gIFs8ZmZmZmZmZmY4MTA2OTkxYz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NGMvMHg1
MApbICAgIDIuMjQ1MDE1XSAgWzxmZmZmZmZmZjgxMGJjNmIxPl0gZGVidWdfbXV0ZXhfdW5s
b2NrKzB4MjExLzB4MjIwClsgICAgMi4yNDUwMTVdICBbPGZmZmZmZmZmODE2ZWYzZmI+XSBf
X211dGV4X3VubG9ja19zbG93cGF0aCsweGRiLzB4MjEwClsgICAgMi4yNDUwMTVdICBbPGZm
ZmZmZmZmODE2ZWY1M2U+XSBtdXRleF91bmxvY2srMHhlLzB4MTAKWyAgICAyLjI0NTAxNV0g
IFs8ZmZmZmZmZmY4MTE2ZDdkYT5dIHVubGlua19maWxlX3ZtYSsweDRhLzB4NjAKWyAgICAy
LjI0NTAxNV0gIFs8ZmZmZmZmZmY4MTE2NjZiMj5dIGZyZWVfcGd0YWJsZXMrMHg5Mi8weGUw
ClsgICAgMi4yNDUwMTVdICBbPGZmZmZmZmZmODExNzAxMDY+XSBleGl0X21tYXArMHhhNi8w
eDE5MApbICAgIDIuMjQ1MDE1XSAgWzxmZmZmZmZmZjgxMDY2ODYxPl0gbW1wdXQrMHg2MS8w
eGUwClsgICAgMi4yNDUwMTVdICBbPGZmZmZmZmZmODExOTFiNDE+XSBmbHVzaF9vbGRfZXhl
YysweDZmMS8weDlhMApbICAgIDIuMjQ1MDE1XSAgWzxmZmZmZmZmZjgxMWU0YjY4Pl0gbG9h
ZF9lbGZfYmluYXJ5KzB4MzE4LzB4ZTUwClsgICAgMi4yNDUwMTVdICBbPGZmZmZmZmZmODEw
YzYyYmM+XSA/IGRvX3Jhd19yZWFkX3VubG9jaysweDJjLzB4NTAKWyAgICAyLjI0NTAxNV0g
IFs8ZmZmZmZmZmY4MTE5MWU3OT5dIHNlYXJjaF9iaW5hcnlfaGFuZGxlcisweDg5LzB4MWEw
ClsgICAgMi4yNDUwMTVdICBbPGZmZmZmZmZmODExOTJiMzA+XSBkb19leGVjdmUrMHg2MjAv
MHg3ZTAKWyAgICAyLjI0NTAxNV0gIFs8ZmZmZmZmZmY4MTE5MmE5Zj5dID8gZG9fZXhlY3Zl
KzB4NThmLzB4N2UwClsgICAgMi4yNDUwMTVdICBbPGZmZmZmZmZmODExOTJmNTU+XSBTeVNf
ZXhlY3ZlKzB4MjUvMHgzMApbICAgIDIuMjQ1MDE1XSAgWzxmZmZmZmZmZjgxNmYyY2U5Pl0g
c3R1Yl9leGVjdmUrMHg2OS8weGEwClsgICAgMi4yNDUwMTVdIC0tLVsgZW5kIHRyYWNlIDhk
YTZiYWNjMzc4MmUwNTAgXS0tLQpbICAgIDIuMjgyNjEwXSBpbml0OiBGYWlsZWQgdG8gY3Jl
YXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jNi0wMzEyLzMxOTMwOWZkYWZlYTc3MTc1MjJiOTRlNDA2ZWEzNDI5ZmQ5NDk4
YjQvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0zMToyMDE0MDMxMjE2NDQyODp4ODZfNjQtcmFu
ZGNvbmZpZy1jNi0wMzEyOjMuMTQuMC1yYzYtMDAxMjMtZzMxOTMwOWY6MTEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzMxOTMwOWZkYWZlYTc3MTc1MjJiOTRlNDA2ZWEz
NDI5ZmQ5NDk4YjQvZG1lc2ctcXVhbnRhbC14Z3dvLTQ6MjAxNDAzMTIxNjQ0NDc6eDg2XzY0
LXJhbmRjb25maWctYzYtMDMxMjozLjE0LjAtcmM2LTAwMTIzLWczMTkzMDlmOjExCjA6Mjoy
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTEyIDE2OjQ1OjAx
IFJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy9uZXQtYmlzZWN0Ly5yZXBlYXQbWzBtCgpC
aXNlY3Rpbmc6IDEwNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNyBzdGVwcykKW2NiZGM0YWFmMTkzMmJiZjIzOTM0NDQzMTI2ZjYxMGI2NGQ1M2U3Y2Vd
IG1hbnVhbCBtZXJnZSBvZiBjb3JlL2xvY2tpbmcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzYt
MDMxMi90aXA6bWFzdGVyOmNiZGM0YWFmMTkzMmJiZjIzOTM0NDQzMTI2ZjYxMGI2NGQ1M2U3
Y2U6YmlzZWN0LW5ldAoKMjAxNC0wMy0xMi0xNjo0NTowMiBjYmRjNGFhZjE5MzJiYmYyMzkz
NDQ0MzEyNmY2MTBiNjRkNTNlN2NlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTItY2Jk
YzRhYWYxOTMyYmJmMjM5MzQ0NDMxMjZmNjEwYjY0ZDUzZTdjZQpDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi9jYmRjNGFhZjE5MzJiYmYy
MzkzNDQ0MzEyNmY2MTBiNjRkNTNlN2NlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLWNiZGM0
YWFmMTkzMmJiZjIzOTM0NDQzMTI2ZjYxMGI2NGQ1M2U3Y2UKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1j
Ni0wMzEyLWNiZGM0YWFmMTkzMmJiZjIzOTM0NDQzMTI2ZjYxMGI2NGQ1M2U3Y2UKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvY2JkYzRhYWYxOTMyYmJmMjM5
MzQ0NDMxMjZmNjEwYjY0ZDUzZTdjZS92bWxpbnV6LTMuMTQuMC1yYzYtMDAwNDEtZ2NiZGM0
YWEKCjIwMTQtMDMtMTItMTc6Mzg6MDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4gVEVTVCBG
QUlMVVJFClsgICAgMi43MzQ2MTVdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5IC0gZGlz
YWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgIDIuNzM2NDA0XSBpbml0OiBUZW1wb3Jhcnkg
cHJvY2VzcyBzcGF3biBlcnJvcjogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpbICAgIDIu
NzgxMjgxXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAyLjc4
MjAyNV0gV0FSTklORzogQ1BVOiAxIFBJRDogMTIxIGF0IGtlcm5lbC9sb2NraW5nL211dGV4
LWRlYnVnLmM6ODIgZGVidWdfbXV0ZXhfdW5sb2NrKzB4MjExLzB4MjIwKCkKWyAgICAyLjc4
MjAyNV0gREVCVUdfTE9DS1NfV0FSTl9PTihsb2NrLT5vd25lciAhPSBjdXJyZW50KQpbICAg
IDIuNzgyMDI1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAyLjc4MjAyNV0gQ1BVOiAxIFBJ
RDogMTIxIENvbW06IHN0b3AgTm90IHRhaW50ZWQgMy4xNC4wLXJjNi0wMDA0MS1nY2JkYzRh
YSAjMTMKWyAgICAyLjc4MjAyNV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuNzgyMDI1XSAgMDAwMDAwMDAwMDAwMDAwOSBmZmZm
ODgwMDBiMjAxYzc4IGZmZmZmZmZmODE2ZTM3NTcgZmZmZjg4MDAwYjIwMWNjMApbICAgIDIu
NzgyMDI1XSAgZmZmZjg4MDAwYjIwMWNiMCBmZmZmZmZmZjgxMDY5OGFkIGZmZmY4ODAwMTA4
MzlkZDAgMDAwMDAwMDAwMDAwMDAwMQpbICAgIDIuNzgyMDI1XSAgMDAwMDAwMDAwMDAwMDI0
NiAwMDAwMDAwMDAwMDAwODRjIGZmZmY4ODAwMGIxODJkMDAgZmZmZjg4MDAwYjIwMWQxMApb
ICAgIDIuNzgyMDI1XSBDYWxsIFRyYWNlOgpbICAgIDIuNzgyMDI1XSAgWzxmZmZmZmZmZjgx
NmUzNzU3Pl0gZHVtcF9zdGFjaysweDRkLzB4NjYKWyAgICAyLjc4MjAyNV0gIFs8ZmZmZmZm
ZmY4MTA2OThhZD5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4N2QvMHhhMApbICAgIDIuNzgy
MDI1XSAgWzxmZmZmZmZmZjgxMDY5OTFjPl0gd2Fybl9zbG93cGF0aF9mbXQrMHg0Yy8weDUw
ClsgICAgMi43ODIwMjVdICBbPGZmZmZmZmZmODEwYmM2YjE+XSBkZWJ1Z19tdXRleF91bmxv
Y2srMHgyMTEvMHgyMjAKWyAgICAyLjc4MjAyNV0gIFs8ZmZmZmZmZmY4MTZlZjNmYj5dIF9f
bXV0ZXhfdW5sb2NrX3Nsb3dwYXRoKzB4ZGIvMHgyMTAKWyAgICAyLjc4MjAyNV0gIFs8ZmZm
ZmZmZmY4MTZlZjUzZT5dIG11dGV4X3VubG9jaysweGUvMHgxMApbICAgIDIuNzgyMDI1XSAg
WzxmZmZmZmZmZjgxMTZkN2NhPl0gdW5saW5rX2ZpbGVfdm1hKzB4NGEvMHg2MApbICAgIDIu
NzgyMDI1XSAgWzxmZmZmZmZmZjgxMTY2NmEyPl0gZnJlZV9wZ3RhYmxlcysweDkyLzB4ZTAK
WyAgICAyLjc4MjAyNV0gIFs8ZmZmZmZmZmY4MTE3MDBmNj5dIGV4aXRfbW1hcCsweGE2LzB4
MTkwClsgICAgMi43ODIwMjVdICBbPGZmZmZmZmZmODEwNjY4NjE+XSBtbXB1dCsweDYxLzB4
ZTAKWyAgICAyLjc4MjAyNV0gIFs8ZmZmZmZmZmY4MTA2YjA1Zj5dIGRvX2V4aXQrMHgzZGYv
MHhiYTAKWyAgICAyLjc4MjAyNV0gIFs8ZmZmZmZmZmY4MTZmMjc2NT5dID8gc3lzcmV0X2No
ZWNrKzB4MjIvMHg1ZApbICAgIDIuNzgyMDI1XSAgWzxmZmZmZmZmZjgxMDZjOTA0Pl0gZG9f
Z3JvdXBfZXhpdCsweDY0LzB4ZTAKWyAgICAyLjc4MjAyNV0gIFs8ZmZmZmZmZmY4MTA2Yzk5
ND5dIFN5U19leGl0X2dyb3VwKzB4MTQvMHgyMApbICAgIDIuNzgyMDI1XSAgWzxmZmZmZmZm
ZjgxNmYyNzM5Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsgICAgMi43ODIw
MjVdIC0tLVsgZW5kIHRyYWNlIGQ4ZWYwNjJlZDhkMzUxZDIgXS0tLQpbICAgIDIuODQzODkx
XSBpbml0OiBGYWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBq
b2IKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyL2NiZGM0YWFmMTkzMmJiZjIz
OTM0NDQzMTI2ZjYxMGI2NGQ1M2U3Y2UvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi05OjIwMTQw
MzEyMTczODMzOng4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xNC4wLXJjNi0wMDA0MS1n
Y2JkYzRhYToxMwowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAx
NC0wMy0xMiAxNzozOTowNCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvbmV0LWJpc2Vj
dC8ucmVwZWF0G1swbQoKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2Vj
dApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IGNiZGM0YWFmMTkzMmJiZjIzOTM0
NDQzMTI2ZjYxMGI2NGQ1M2U3Y2UgODcxMmEwMDUxNGU1MGFhZmE3YzliZjVjZDM5NTVmYTYw
NzU4ZTUzYiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBjYmRjNGFhLi4uIG1hbnVh
bCBtZXJnZSBvZiBjb3JlL2xvY2tpbmcKU3dpdGNoZWQgdG8gYnJhbmNoICdtYXN0ZXInCllv
dXIgYnJhbmNoIGlzIGJlaGluZCAnb3JpZ2luL21hc3RlcicgYnkgNDEyMTMgY29tbWl0cywg
YW5kIGNhbiBiZSBmYXN0LWZvcndhcmRlZC4KICAodXNlICJnaXQgcHVsbCIgdG8gdXBkYXRl
IHlvdXIgbG9jYWwgYnJhbmNoKQpCaXNlY3Rpbmc6IDExIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbNDdiZTFjMWEwZTE4ODIzMmI1ZTU5
NjI5MTdiMjE3NTAwNTNjZDNmOF0gbG9ja2RlcDogQ2hhbmdlIGxvY2tkZXBfc2V0X25vdmFs
aWRhdGVfY2xhc3MoKSB0byB1c2UgX2FuZF9uYW1lCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNl
Y3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL25ldC9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvdGlw
Om1hc3Rlcjo0N2JlMWMxYTBlMTg4MjMyYjVlNTk2MjkxN2IyMTc1MDA1M2NkM2Y4OmJpc2Vj
dC1uZXQKCjIwMTQtMDMtMTItMTc6Mzk6NDMgNDdiZTFjMWEwZTE4ODIzMmI1ZTU5NjI5MTdi
MjE3NTAwNTNjZDNmOCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLTQ3YmUxYzFhMGUx
ODgyMzJiNWU1OTYyOTE3YjIxNzUwMDUzY2QzZjgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvNDdiZTFjMWEwZTE4ODIzMmI1ZTU5NjI5
MTdiMjE3NTAwNTNjZDNmOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi00N2JlMWMxYTBlMTg4
MjMyYjVlNTk2MjkxN2IyMTc1MDA1M2NkM2Y4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi00
N2JlMWMxYTBlMTg4MjMyYjVlNTk2MjkxN2IyMTc1MDA1M2NkM2Y4Cmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzQ3YmUxYzFhMGUxODgyMzJiNWU1OTYyOTE3
YjIxNzUwMDUzY2QzZjgvdm1saW51ei0zLjEzLjAtMDI3MTMtZzQ3YmUxYzEKCjIwMTQtMDMt
MTItMTg6MDY6NDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNgkxOAkyMCBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDMgc3RlcHMpCltjOTEyMmRhMWUyZDI5YmQ2YTE0NzVhMGQxY2UyYWE2YWM2ZWEyNWZhXSBs
b2NraW5nOiBNb3ZlIG1jc19zcGlubG9jay5oIGludG8ga2VybmVsL2xvY2tpbmcvCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93
ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvdGlwOm1hc3RlcjpjOTEyMmRhMWUyZDI5YmQ2YTE0
NzVhMGQxY2UyYWE2YWM2ZWEyNWZhOmJpc2VjdC1uZXQKCjIwMTQtMDMtMTItMTg6MDk6MTUg
YzkxMjJkYTFlMmQyOWJkNmExNDc1YTBkMWNlMmFhNmFjNmVhMjVmYSBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFu
ZGNvbmZpZy1jNi0wMzEyLWM5MTIyZGExZTJkMjliZDZhMTQ3NWEwZDFjZTJhYTZhYzZlYTI1
ZmEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAz
MTIvYzkxMjJkYTFlMmQyOWJkNmExNDc1YTBkMWNlMmFhNmFjNmVhMjVmYQp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRj
b25maWctYzYtMDMxMi1jOTEyMmRhMWUyZDI5YmQ2YTE0NzVhMGQxY2UyYWE2YWM2ZWEyNWZh
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi1jOTEyMmRhMWUyZDI5YmQ2YTE0NzVhMGQxY2Uy
YWE2YWM2ZWEyNWZhCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEy
L2M5MTIyZGExZTJkMjliZDZhMTQ3NWEwZDFjZTJhYTZhYzZlYTI1ZmEvdm1saW51ei0zLjEz
LjAtMDI3MTktZ2M5MTIyZGEKCjIwMTQtMDMtMTItMTg6NDI6MTUgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4JMQkyCTcJMTAJMTMJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbMWQ4ZmU3ZGM4
MDc4YjIzZTA2MGVjNjJjY2I0Y2RjMWFjM2M0MWJmOF0gbG9ja2luZy9tdXRleGVzOiBVbmxv
Y2sgdGhlIG11dGV4IHdpdGhvdXQgdGhlIHdhaXRfbG9jawpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1jNi0wMzEyL3RpcDptYXN0ZXI6MWQ4ZmU3ZGM4MDc4YjIzZTA2MGVjNjJjY2I0Y2RjMWFj
M2M0MWJmODpiaXNlY3QtbmV0CgoyMDE0LTAzLTEyLTE4OjQ2OjE2IDFkOGZlN2RjODA3OGIy
M2UwNjBlYzYyY2NiNGNkYzFhYzNjNDFiZjggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYzYtMDMx
Mi0xZDhmZTdkYzgwNzhiMjNlMDYwZWM2MmNjYjRjZGMxYWMzYzQxYmY4CkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzFkOGZlN2RjODA3
OGIyM2UwNjBlYzYyY2NiNGNkYzFhYzNjNDFiZjgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIt
MWQ4ZmU3ZGM4MDc4YjIzZTA2MGVjNjJjY2I0Y2RjMWFjM2M0MWJmOAp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29u
ZmlnLWM2LTAzMTItMWQ4ZmU3ZGM4MDc4YjIzZTA2MGVjNjJjY2I0Y2RjMWFjM2M0MWJmOApr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8xZDhmZTdkYzgwNzhi
MjNlMDYwZWM2MmNjYjRjZGMxYWMzYzQxYmY4L3ZtbGludXotMy4xMy4wLTAyNzIyLWcxZDhm
ZTdkCgoyMDE0LTAzLTEyLTE5OjIxOjE3IGRldGVjdGluZyBib290IHN0YXRlIC4uIFRFU1Qg
RkFJTFVSRQpbICAgIDIuNjc3NTY5XSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGZm
ZmZmZmZmODFjMjEwMDAtMHhmZmZmZmZmZjgxZDU1ZmZmXQpbICAgIDIuNjg5NzAyXSByYW5k
b206IGluaXQgdXJhbmRvbSByZWFkIHdpdGggNSBiaXRzIG9mIGVudHJvcHkgYXZhaWxhYmxl
ClsgICAgMi43MTY1NzVdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpb
ICAgIDIuNzE3MDE5XSBXQVJOSU5HOiBDUFU6IDAgUElEOiA3NSBhdCBrZXJuZWwvbG9ja2lu
Zy9tdXRleC1kZWJ1Zy5jOjgyIGRlYnVnX211dGV4X3VubG9jaysweDIxMS8weDIyMCgpClsg
ICAgMi43MTcwMTldIERFQlVHX0xPQ0tTX1dBUk5fT04obG9jay0+b3duZXIgIT0gY3VycmVu
dCkKWyAgICAyLjcxNzAxOV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMi43MTcwMTldIENQ
VTogMCBQSUQ6IDc1IENvbW06IDk5LXRyaW5pdHkgTm90IHRhaW50ZWQgMy4xMy4wLTAyNzIy
LWcxZDhmZTdkICMxOQpbICAgIDIuNzE3MDE5XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2No
cywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMi43MTcwMTldICAwMDAwMDAwMDAwMDAw
MDA5IGZmZmY4ODAwMGIxMTljYzggZmZmZmZmZmY4MTZlMzY5NyBmZmZmODgwMDBiMTE5ZDEw
ClsgICAgMi43MTcwMTldICBmZmZmODgwMDBiMTE5ZDAwIGZmZmZmZmZmODEwNjlhNmQgZmZm
Zjg4MDAxMDgzYmRkMCAwMDAwMDAwMDAwMDAwMDAxClsgICAgMi43MTcwMTldICAwMDAwMDAw
MDAwMDAwMjQ2IDAwMDAwMDAwMDAwMDAxNmEgZmZmZjg4MDAwYjBjODAwMCBmZmZmODgwMDBi
MTE5ZDYwClsgICAgMi43MTcwMTldIENhbGwgVHJhY2U6ClsgICAgMi43MTcwMTldICBbPGZm
ZmZmZmZmODE2ZTM2OTc+XSBkdW1wX3N0YWNrKzB4NGQvMHg2NgpbICAgIDIuNzE3MDE5XSAg
WzxmZmZmZmZmZjgxMDY5YTZkPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3ZC8weGEwClsg
ICAgMi43MTcwMTldICBbPGZmZmZmZmZmODEwNjlhZGM+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsw
eDRjLzB4NTAKWyAgICAyLjcxNzAxOV0gIFs8ZmZmZmZmZmY4MTBiYzViMT5dIGRlYnVnX211
dGV4X3VubG9jaysweDIxMS8weDIyMApbICAgIDIuNzE3MDE5XSAgWzxmZmZmZmZmZjgxNmVm
MzNiPl0gX19tdXRleF91bmxvY2tfc2xvd3BhdGgrMHhkYi8weDIxMApbICAgIDIuNzE3MDE5
XSAgWzxmZmZmZmZmZjgxNmVmNDdlPl0gbXV0ZXhfdW5sb2NrKzB4ZS8weDEwClsgICAgMi43
MTcwMTldICBbPGZmZmZmZmZmODEwNjdhMGY+XSBjb3B5X3Byb2Nlc3MucGFydC40NysweGNl
Zi8weDFjYzAKWyAgICAyLjcxNzAxOV0gIFs8ZmZmZmZmZmY4MTA2OGJlMD5dIGRvX2Zvcmsr
MHgxMDAvMHg0YTAKWyAgICAyLjcxNzAxOV0gIFs8ZmZmZmZmZmY4MTBjNjBiNz5dID8gZG9f
cmF3X3NwaW5fdW5sb2NrKzB4YzcvMHgxMTAKWyAgICAyLjcxNzAxOV0gIFs8ZmZmZmZmZmY4
MTZmMGU0Nz5dID8gX3Jhd19zcGluX3VubG9jaysweDI3LzB4NDAKWyAgICAyLjcxNzAxOV0g
IFs8ZmZmZmZmZmY4MTZmMjZhNT5dID8gc3lzcmV0X2NoZWNrKzB4MjIvMHg1ZApbICAgIDIu
NzE3MDE5XSAgWzxmZmZmZmZmZjgxMDY5MDA2Pl0gU3lTX2Nsb25lKzB4MTYvMHgyMApbICAg
IDIuNzE3MDE5XSAgWzxmZmZmZmZmZjgxNmYyOWQ5Pl0gc3R1Yl9jbG9uZSsweDY5LzB4OTAK
WyAgICAyLjcxNzAxOV0gIFs8ZmZmZmZmZmY4MTZmMjY3OT5dID8gc3lzdGVtX2NhbGxfZmFz
dHBhdGgrMHgxNi8weDFiClsgICAgMi43MTcwMTldIC0tLVsgZW5kIHRyYWNlIGM4ZjI3MWJk
Y2QxMTVhYzUgXS0tLQpbICAgIDIuODExMzgyXSBpbml0OiBGYWlsZWQgdG8gY3JlYXRlIHB0
eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jNi0wMzEyLzFkOGZlN2RjODA3OGIyM2UwNjBlYzYyY2NiNGNkYzFhYzNjNDFiZjgvZG1l
c2ctcXVhbnRhbC1pdnl0b3duMi0xMToyMDE0MDMxMjE5MjIwNjp4ODZfNjQtcmFuZGNvbmZp
Zy1jNi0wMzEyOjMuMTMuMC0wMjcyMi1nMWQ4ZmU3ZDoxOQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWM2LTAzMTIvMWQ4ZmU3ZGM4MDc4YjIzZTA2MGVjNjJjY2I0Y2RjMWFjM2M0MWJm
OC9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTE2OjIwMTQwMzEyMTkyMjA4Ong4Nl82NC1yYW5k
Y29uZmlnLWM2LTAzMTI6My4xMy4wLTAyNzIyLWcxZDhmZTdkOjE5Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzYtMDMxMi8xZDhmZTdkYzgwNzhiMjNlMDYwZWM2MmNjYjRjZGMxYWMz
YzQxYmY4L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMTk6MjAxNDAzMTIxOTIyMDc6eDg2XzY0
LXJhbmRjb25maWctYzYtMDMxMjozLjEzLjAtMDI3MjItZzFkOGZlN2Q6MTkKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzFkOGZlN2RjODA3OGIyM2UwNjBlYzYyY2NiNGNk
YzFhYzNjNDFiZjgvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yOToyMDE0MDMxMjE5MjIwNzp4
ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyOjMuMTMuMC0wMjcyMi1nMWQ4ZmU3ZDoxOQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvMWQ4ZmU3ZGM4MDc4YjIzZTA2MGVjNjJj
Y2I0Y2RjMWFjM2M0MWJmOC9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTMwOjIwMTQwMzEyMTky
MjA0Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xMy4wLTAyNzIyLWcxZDhmZTdkOjE5
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8xZDhmZTdkYzgwNzhiMjNlMDYw
ZWM2MmNjYjRjZGMxYWMzYzQxYmY4L2RtZXNnLXlvY3RvLWl2eXRvd24yLTIzOjIwMTQwMzEy
MTkyMjEwOng4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xMy4wLTAyNzIyLWcxZDhmZTdk
OjE5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8xZDhmZTdkYzgwNzhiMjNl
MDYwZWM2MmNjYjRjZGMxYWMzYzQxYmY4L2RtZXNnLXlvY3RvLWl2eXRvd24yLTI0OjIwMTQw
MzEyMTkyMjA5Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xMy4wLTAyNzIyLWcxZDhm
ZTdkOjE5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8xZDhmZTdkYzgwNzhi
MjNlMDYwZWM2MmNjYjRjZGMxYWMzYzQxYmY4L2RtZXNnLXlvY3RvLWl2eXRvd24yLTI6MjAx
NDAzMTIxOTIyMDk6eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMjozLjEzLjAtMDI3MjItZzFk
OGZlN2Q6MTkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzFkOGZlN2RjODA3
OGIyM2UwNjBlYzYyY2NiNGNkYzFhYzNjNDFiZjgvZG1lc2cteW9jdG8taXZ5dG93bjItNjoy
MDE0MDMxMjE5MjIwOTp4ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyOjMuMTMuMC0wMjcyMi1n
MWQ4ZmU3ZDoxOQowOjk6OSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAx
NC0wMy0xMiAxOToyMjoxOSBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvbmV0LWJpc2Vj
dC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCls0NzY2N2ZhMTUwMmU0ZDc1OWRmODdlOWNjN2Zi
YzBmMjAyNDgzMzYxXSBsb2NraW5nL211dGV4ZXM6IE1vZGlmeSB0aGUgd2F5IG9wdGltaXN0
aWMgc3Bpbm5lcnMgYXJlIHF1ZXVlZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyL3Rp
cDptYXN0ZXI6NDc2NjdmYTE1MDJlNGQ3NTlkZjg3ZTljYzdmYmMwZjIwMjQ4MzM2MTpiaXNl
Y3QtbmV0CgoyMDE0LTAzLTEyLTE5OjIyOjIwIDQ3NjY3ZmExNTAyZTRkNzU5ZGY4N2U5Y2M3
ZmJjMGYyMDI0ODMzNjEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi00NzY2N2ZhMTUw
MmU0ZDc1OWRmODdlOWNjN2ZiYzBmMjAyNDgzMzYxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzQ3NjY3ZmExNTAyZTRkNzU5ZGY4N2U5
Y2M3ZmJjMGYyMDI0ODMzNjEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTItNDc2NjdmYTE1MDJl
NGQ3NTlkZjg3ZTljYzdmYmMwZjIwMjQ4MzM2MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIt
NDc2NjdmYTE1MDJlNGQ3NTlkZjg3ZTljYzdmYmMwZjIwMjQ4MzM2MQprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi80NzY2N2ZhMTUwMmU0ZDc1OWRmODdlOWNj
N2ZiYzBmMjAyNDgzMzYxL3ZtbGludXotMy4xMy4wLTAyNzIxLWc0NzY2N2ZhCgoyMDE0LTAz
LTEyLTIwOjEyOjIwIGRldGVjdGluZyBib290IHN0YXRlIAkyCTEyCTE2CTE4CTIwIFNVQ0NF
U1MKCjFkOGZlN2RjODA3OGIyM2UwNjBlYzYyY2NiNGNkYzFhYzNjNDFiZjggaXMgdGhlIGZp
cnN0IGJhZCBjb21taXQKY29tbWl0IDFkOGZlN2RjODA3OGIyM2UwNjBlYzYyY2NiNGNkYzFh
YzNjNDFiZjgKQXV0aG9yOiBKYXNvbiBMb3cgPGphc29uLmxvdzJAaHAuY29tPgpEYXRlOiAg
IFR1ZSBKYW4gMjggMTE6MTM6MTQgMjAxNCAtMDgwMAoKICAgIGxvY2tpbmcvbXV0ZXhlczog
VW5sb2NrIHRoZSBtdXRleCB3aXRob3V0IHRoZSB3YWl0X2xvY2sKICAgIAogICAgV2hlbiBy
dW5uaW5nIHdvcmtsb2FkcyB0aGF0IGhhdmUgaGlnaCBjb250ZW50aW9uIGluIG11dGV4ZXMg
b24gYW4gOCBzb2NrZXQKICAgIG1hY2hpbmUsIG11dGV4IHNwaW5uZXJzIHdvdWxkIG9mdGVu
IHNwaW4gZm9yIGEgbG9uZyB0aW1lIHdpdGggbm8gbG9jayBvd25lci4KICAgIAogICAgVGhl
IG1haW4gcmVhc29uIHdoeSB0aGlzIGlzIG9jY3VyaW5nIGlzIGluIF9fbXV0ZXhfdW5sb2Nr
X2NvbW1vbl9zbG93cGF0aCgpLAogICAgaWYgX19tdXRleF9zbG93cGF0aF9uZWVkc190b191
bmxvY2soKSwgdGhlbiB0aGUgb3duZXIgbmVlZHMgdG8gYWNxdWlyZSB0aGUKICAgIG11dGV4
LT53YWl0X2xvY2sgYmVmb3JlIHJlbGVhc2luZyB0aGUgbXV0ZXggKHNldHRpbmcgbG9jay0+
Y291bnQgdG8gMSkuIFdoZW4KICAgIHRoZSB3YWl0X2xvY2sgaXMgY29udGVuZGVkLCB0aGlz
IGRlbGF5cyB0aGUgbXV0ZXggZnJvbSBiZWluZyByZWxlYXNlZC4KICAgIFdlIHNob3VsZCBi
ZSBhYmxlIHRvIHJlbGVhc2UgdGhlIG11dGV4IHdpdGhvdXQgaG9sZGluZyB0aGUgd2FpdF9s
b2NrLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBMb3cgPGphc29uLmxvdzJAaHAu
Y29tPgogICAgQ2M6IGNoZWd1X3Zpbm9kQGhwLmNvbQogICAgQ2M6IHBhdWxtY2tAbGludXgu
dm5ldC5pYm0uY29tCiAgICBDYzogV2FpbWFuLkxvbmdAaHAuY29tCiAgICBDYzogdG9ydmFs
ZHNAbGludXgtZm91bmRhdGlvbi5vcmcKICAgIENjOiB0Z2x4QGxpbnV0cm9uaXguZGUKICAg
IENjOiByaWVsQHJlZGhhdC5jb20KICAgIENjOiBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3Jn
CiAgICBDYzogZGF2aWRsb2hyQGhwLmNvbQogICAgQ2M6IGhwYUB6eXRvci5jb20KICAgIENj
OiBhbmRpQGZpcnN0Zmxvb3Iub3JnCiAgICBDYzogYXN3aW5AaHAuY29tCiAgICBDYzogc2Nv
dHQubm9ydG9uQGhwLmNvbQogICAgU2lnbmVkLW9mZi1ieTogUGV0ZXIgWmlqbHN0cmEgPHBl
dGVyekBpbmZyYWRlYWQub3JnPgogICAgTGluazogaHR0cDovL2xrbWwua2VybmVsLm9yZy9y
LzEzOTA5MzYzOTYtMzk2Mi00LWdpdC1zZW5kLWVtYWlsLWphc29uLmxvdzJAaHAuY29tCiAg
ICBTaWduZWQtb2ZmLWJ5OiBJbmdvIE1vbG5hciA8bWluZ29Aa2VybmVsLm9yZz4KCjowNDAw
MDAgMDQwMDAwIDZiYWQwNTNiY2Q5ZThhZGRiYmMzNjViMjc0YTlmZDc1OGNjZGFhYzYgMzU2
NTczNjE3NzExNjBmODYyNGE3YWIxMjViNjllNjQxMDNiMTI5ZSBNCWtlcm5lbApiaXNlY3Qg
cnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWM2LTAzMTIvdGlwOm1hc3Rlcjo0NzY2N2ZhMTUwMmU0ZDc1OWRmODdlOWNj
N2ZiYzBmMjAyNDgzMzYxOmJpc2VjdC1uZXQKCjIwMTQtMDMtMTItMjA6MTQ6NTIgNDc2Njdm
YTE1MDJlNGQ3NTlkZjg3ZTljYzdmYmMwZjIwMjQ4MzM2MSByZXVzZSAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWM2LTAzMTIvNDc2NjdmYTE1MDJlNGQ3NTlkZjg3ZTljYzdmYmMwZjIw
MjQ4MzM2MS92bWxpbnV6LTMuMTMuMC0wMjcyMS1nNDc2NjdmYQoKMjAxNC0wMy0xMi0yMDox
NDo1MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLgkyMS4uCTIyLgkyNC4JMjUJMjcJMzAJ
MzQJMzcJNDAJNDYJNTEuLi4JNTIJNTYJNTcJNjAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvdGlwOm1hc3Rl
cjoyMjFmMTlhNjYyZjUzNmFhODY0MDY5NGU3NDQwMTk3NzZkMmRmNTg0OmJpc2VjdC1uZXQK
IFRFU1QgRkFJTFVSRQpbICAgIDIuNzU2MDcwXSBkZ2FwOiBkZ2FwLTEuMy0xNiwgRGlnaSBJ
bnRlcm5hdGlvbmFsIFBhcnQgTnVtYmVyIDQwMDAyMzQ3X0MKWyAgICAyLjc1NjA3OF0gZGdh
cDogRm9yIHRoZSB0b29scyBwYWNrYWdlIG9yIHVwZGF0ZWQgZHJpdmVycyBwbGVhc2Ugdmlz
aXQgaHR0cDovL3d3dy5kaWdpLmNvbQpbICAgIDIuNzk1NzA4XSAtLS0tLS0tLS0tLS1bIGN1
dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAyLjc5NjA4Ml0gV0FSTklORzogQ1BVOiAxIFBJ
RDogMjIgYXQga2VybmVsL2xvY2tpbmcvbXV0ZXgtZGVidWcuYzo4MiBkZWJ1Z19tdXRleF91
bmxvY2srMHgyMTEvMHgyMjAoKQpbICAgIDIuNzk2MDgyXSBERUJVR19MT0NLU19XQVJOX09O
KGxvY2stPm93bmVyICE9IGN1cnJlbnQpClsgICAgMi43OTYwODJdIE1vZHVsZXMgbGlua2Vk
IGluOgpbICAgIDIuNzk2MDgyXSBDUFU6IDEgUElEOiAyMiBDb21tOiBrd29ya2VyLzE6MSBO
b3QgdGFpbnRlZCAzLjE0LjAtcmM2LTAxODQ5LWcyMjFmMTlhICMyClsgICAgMi43OTYwODJd
IEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAg
ICAyLjc5NjA4Ml0gV29ya3F1ZXVlOiBldmVudHNfbG9uZyBzZXJpb19oYW5kbGVfZXZlbnQK
WyAgICAyLjc5NjA4Ml0gIDAwMDAwMDAwMDAwMDAwMDkgZmZmZjg4MDAwZDA0NWI3MCBmZmZm
ZmZmZjgxNmU1NjY1IGZmZmY4ODAwMGQwNDViYjgKWyAgICAyLjc5NjA4Ml0gIGZmZmY4ODAw
MGQwNDViYTggZmZmZmZmZmY4MTA2YWQ2ZCBmZmZmZmZmZjgxYjJmMTIwIDAwMDAwMDAwMDAw
MDAwMDEKWyAgICAyLjc5NjA4Ml0gIDAwMDAwMDAwMDAwMDAyNDYgMDAwMDAwMDAwMDAwMmZh
OSAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGQwNDVjMDgKWyAgICAyLjc5NjA4Ml0gQ2Fs
bCBUcmFjZToKWyAgICAyLjc5NjA4Ml0gIFs8ZmZmZmZmZmY4MTZlNTY2NT5dIGR1bXBfc3Rh
Y2srMHg0ZC8weDY2ClsgICAgMi43OTYwODJdICBbPGZmZmZmZmZmODEwNmFkNmQ+XSB3YXJu
X3Nsb3dwYXRoX2NvbW1vbisweDdkLzB4YTAKWyAgICAyLjc5NjA4Ml0gIFs8ZmZmZmZmZmY4
MTA2YWRkYz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NGMvMHg1MApbICAgIDIuNzk2MDgyXSAg
WzxmZmZmZmZmZjgxMGJlNTMxPl0gZGVidWdfbXV0ZXhfdW5sb2NrKzB4MjExLzB4MjIwClsg
ICAgMi43OTYwODJdICBbPGZmZmZmZmZmODE2ZjEyZGI+XSBfX211dGV4X3VubG9ja19zbG93
cGF0aCsweGRiLzB4MjEwClsgICAgMi43OTYwODJdICBbPGZmZmZmZmZmODE2ZjE0MWU+XSBt
dXRleF91bmxvY2srMHhlLzB4MTAKWyAgICAyLjc5NjA4Ml0gIFs8ZmZmZmZmZmY4MTIwMzY4
YT5dIGtlcm5mc19maW5kX2FuZF9nZXRfbnMrMHg0YS8weDYwClsgICAgMi43OTYwODJdICBb
PGZmZmZmZmZmODEyMDE3YTE+XSBzeXNmc19tZXJnZV9ncm91cCsweDIxLzB4ZDAKWyAgICAy
Ljc5NjA4Ml0gIFs8ZmZmZmZmZmY4MTRhZGNmZj5dIGRwbV9zeXNmc19hZGQrMHg4Zi8weGIw
ClsgICAgMi43OTYwODJdICBbPGZmZmZmZmZmODE0YTRmMDY+XSBkZXZpY2VfYWRkKzB4NDY2
LzB4NWQwClsgICAgMi43OTYwODJdICBbPGZmZmZmZmZmODEzYzJhM2Y+XSA/IF9fbGlzdF9h
ZGQrMHhiZi8weDE3MApbICAgIDIuNzk2MDgyXSAgWzxmZmZmZmZmZjgxNTkwNGIwPl0gc2Vy
aW9faGFuZGxlX2V2ZW50KzB4MTAwLzB4MjAwClsgICAgMi43OTYwODJdICBbPGZmZmZmZmZm
ODEwODhiZGI+XSBwcm9jZXNzX29uZV93b3JrKzB4M2ViLzB4NjkwClsgICAgMi43OTYwODJd
ICBbPGZmZmZmZmZmODEwODhiMTk+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgzMjkvMHg2OTAK
WyAgICAyLjc5NjA4Ml0gIFs8ZmZmZmZmZmY4MTA4YTY4ZT5dIHdvcmtlcl90aHJlYWQrMHgz
NmUvMHg2OTAKWyAgICAyLjc5NjA4Ml0gIFs8ZmZmZmZmZmY4MTA4YTMyMD5dID8gbWFuYWdl
X3dvcmtlcnMuaXNyYS4yNCsweDM1MC8weDM1MApbICAgIDIuNzk2MDgyXSAgWzxmZmZmZmZm
ZjgxMDkxOWRkPl0ga3RocmVhZCsweGVkLzB4MTEwClsgICAgMi43OTYwODJdICBbPGZmZmZm
ZmZmODE2ZjJlZGM+XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxKzB4MmMvMHg0MApbICAgIDIu
Nzk2MDgyXSAgWzxmZmZmZmZmZjgxMDkxOGYwPl0gPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2Rl
KzB4MjMwLzB4MjMwClsgICAgMi43OTYwODJdICBbPGZmZmZmZmZmODE2ZjQ1OGM+XSByZXRf
ZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDIuNzk2MDgyXSAgWzxmZmZmZmZmZjgxMDkxOGYw
Pl0gPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MjMwLzB4MjMwClsgICAgMi43OTYwODJd
IC0tLVsgZW5kIHRyYWNlIGY0ZTAxMGE4YWM1MmRmZDUgXS0tLQpbICAgIDIuODYxNjAyXSBu
ZXRlbTogdmVyc2lvbiAxLjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzIy
MWYxOWE2NjJmNTM2YWE4NjQwNjk0ZTc0NDAxOTc3NmQyZGY1ODQvZG1lc2ctcXVhbnRhbC14
Z3dvLTU6MjAxNDAzMTIxNDQ1MTM6eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMjozLjE0LjAt
cmM2LTAxODQ5LWcyMjFmMTlhOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEy
LzIyMWYxOWE2NjJmNTM2YWE4NjQwNjk0ZTc0NDAxOTc3NmQyZGY1ODQvZG1lc2ctcXVhbnRh
bC1qYWtldG93bi0zNToyMDE0MDMxMjE0MjgzNTp4ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEy
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzIyMWYxOWE2NjJmNTM2YWE4
NjQwNjk0ZTc0NDAxOTc3NmQyZGY1ODQvZG1lc2cteW9jdG8teGd3by0zOjIwMTQwMzEyMTQy
ODI3Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xNC4wLXJjNi0wMTg0OS1nMjIxZjE5
YToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8yMjFmMTlhNjYyZjUzNmFh
ODY0MDY5NGU3NDQwMTk3NzZkMmRmNTg0L2RtZXNnLXF1YW50YWwteGd3by0yOjIwMTQwMzEy
MTQ0NDM5Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xNC4wLXJjNi0wMTg0OS1nMjIx
ZjE5YToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8yMjFmMTlhNjYyZjUz
NmFhODY0MDY5NGU3NDQwMTk3NzZkMmRmNTg0L2RtZXNnLXF1YW50YWwteGd3by0zOjIwMTQw
MzEyMTQ0NjI4Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xNC4wLXJjNi0wMTg0OS1n
MjIxZjE5YToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8yMjFmMTlhNjYy
ZjUzNmFhODY0MDY5NGU3NDQwMTk3NzZkMmRmNTg0L2RtZXNnLXlvY3RvLWJlbnMtNzoyMDE0
MDMxMjE0NDYzOTp4ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyOjMuMTQuMC1yYzYtMDE4NDkt
ZzIyMWYxOWE6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvMjIxZjE5YTY2
MmY1MzZhYTg2NDA2OTRlNzQ0MDE5Nzc2ZDJkZjU4NC9kbWVzZy1xdWFudGFsLXhpYW4tMTg6
MjAxNDAzMTIxNDQzNDY6eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMjozLjE0LjAtcmM2LTAx
ODQ5LWcyMjFmMTlhOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzIyMWYx
OWE2NjJmNTM2YWE4NjQwNjk0ZTc0NDAxOTc3NmQyZGY1ODQvZG1lc2ctcXVhbnRhbC1zdG9h
a2xleS00OjIwMTQwMzEyMTQyNzEzOng4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xNC4w
LXJjNi0wMTg0OS1nMjIxZjE5YToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMx
Mi8yMjFmMTlhNjYyZjUzNmFhODY0MDY5NGU3NDQwMTk3NzZkMmRmNTg0L2RtZXNnLXlvY3Rv
LXhwcy0zOjIwMTQwMzEyMTQzMDU2Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xNC4w
LXJjNi0wMTg0OS1nMjIxZjE5YToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMx
Mi8yMjFmMTlhNjYyZjUzNmFhODY0MDY5NGU3NDQwMTk3NzZkMmRmNTg0L2RtZXNnLXF1YW50
YWwteGd3by00OjIwMTQwMzEyMTQyODI3Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4x
NC4wLXJjNi0wMTg0OS1nMjIxZjE5YToyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYt
MDMxMi8yMjFmMTlhNjYyZjUzNmFhODY0MDY5NGU3NDQwMTk3NzZkMmRmNTg0L2RtZXNnLXF1
YW50YWwteGlhbi0yMjoyMDE0MDMxMjE0MjcyMjp4ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEy
OjMuMTQuMC1yYzYtMDE4NDktZzIyMWYxOWE6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWM2LTAzMTIvMjIxZjE5YTY2MmY1MzZhYTg2NDA2OTRlNzQ0MDE5Nzc2ZDJkZjU4NC9kbWVz
Zy1xdWFudGFsLXNuYi0xNDoyMDE0MDMxMjE0NDMxNDp4ODZfNjQtcmFuZGNvbmZpZy1jNi0w
MzEyOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzIyMWYxOWE2NjJmNTM2
YWE4NjQwNjk0ZTc0NDAxOTc3NmQyZGY1ODQvZG1lc2ctcXVhbnRhbC1iZW5zLTU6MjAxNDAz
MTIxNDMxMTg6eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMjozLjE0LjAtcmM2LTAxODQ5LWcy
MjFmMTlhOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzIyMWYxOWE2NjJm
NTM2YWE4NjQwNjk0ZTc0NDAxOTc3NmQyZGY1ODQvZG1lc2cteW9jdG8tamFrZXRvd24tMzM6
MjAxNDAzMTIxNDI3MjY6eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMjo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzYtMDMxMi8yMjFmMTlhNjYyZjUzNmFhODY0MDY5NGU3NDQwMTk3
NzZkMmRmNTg0L2RtZXNnLXF1YW50YWwtYmVucy01OjIwMTQwMzEyMTQ0NTU2Ong4Nl82NC1y
YW5kY29uZmlnLWM2LTAzMTI6My4xNC4wLXJjNi0wMTg0OS1nMjIxZjE5YToyCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8yMjFmMTlhNjYyZjUzNmFhODY0MDY5NGU3NDQw
MTk3NzZkMmRmNTg0L2RtZXNnLXF1YW50YWwtYXRoZW5zLTI5OjIwMTQwMzEyMTQ0MzAwOng4
Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4xNC4wLXJjNi0wMTg0OS1nMjIxZjE5YToyCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8yMjFmMTlhNjYyZjUzNmFhODY0MDY5
NGU3NDQwMTk3NzZkMmRmNTg0L2RtZXNnLXF1YW50YWwtc25iLTI3OjIwMTQwMzEyMTQ0MjUw
Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWM2LTAzMTIvMjIxZjE5YTY2MmY1MzZhYTg2NDA2OTRlNzQ0MDE5Nzc2ZDJkZjU4NC9kbWVz
Zy15b2N0by1iZW5zLTY6MjAxNDAzMTIxNDI5MTc6eDg2XzY0LXJhbmRjb25maWctYzYtMDMx
MjozLjE0LjAtcmM2LTAxODQ5LWcyMjFmMTlhOjIKMToxODoxOCBhbGxfZ29vZDpiYWQ6YWxs
X2JhZCBib290cwoKW2RldGFjaGVkIEhFQUQgM2VmNGEzY10gUmV2ZXJ0ICJsb2NraW5nL211
dGV4ZXM6IFVubG9jayB0aGUgbXV0ZXggd2l0aG91dCB0aGUgd2FpdF9sb2NrIgogMSBmaWxl
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvdGlwOm1h
c3RlcjozZWY0YTNjMWViM2U5ZTZmODJiMDU0MWE5ZDgxMjBhZmUxYzgwMGU4OmJpc2VjdC1u
ZXQKCjIwMTQtMDMtMTItMjA6Mjg6MzEgM2VmNGEzYzFlYjNlOWU2ZjgyYjA1NDFhOWQ4MTIw
YWZlMWM4MDBlOCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLTNlZjRhM2MxZWIzZTll
NmY4MmIwNTQxYTlkODEyMGFmZTFjODAwZTgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvM2VmNGEzYzFlYjNlOWU2ZjgyYjA1NDFhOWQ4
MTIwYWZlMWM4MDBlOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi0zZWY0YTNjMWViM2U5ZTZm
ODJiMDU0MWE5ZDgxMjBhZmUxYzgwMGU4Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jOS0wMzEyLzg5ZTViNWY4YWFhYTlhYjZlZjhhYWI4NTU4OWI3MmM0ZTZlMGJjYmYv
dm1saW51ei0zLjE0LjAtcmMxLTAwMTEzLWc4OWU1YjVmCnN0YXR1czogRkFJTDogbm8gY29t
bWl0IDNlZjRhM2MxZWIzZTllNmY4MmIwNTQxYTlkODEyMGFmZTFjODAwZTggZm9yIGJ1aWxk
IHRhc2sgeDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi0zZWY0YTNjMWViM2U5ZTZmODJiMDU0
MWE5ZDgxMjBhZmUxYzgwMGU4CjIwMTQtMDMtMTItMjE6MTA6MzEgM2VmNGEzYzFlYjNlOWU2
ZjgyYjA1NDFhOWQ4MTIwYWZlMWM4MDBlOCBTS0lQIEJST0tFTiBCVUlMRApObyBrZXJuZWwg
aW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzNlZjRhM2MxZWIzZTllNmY4
MmIwNTQxYTlkODEyMGFmZTFjODAwZTgKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0K
V2FybmluZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0IGJlaGluZCwgbm90IGNvbm5lY3Rl
ZCB0bwphbnkgb2YgeW91ciBicmFuY2hlczoKCiAgM2VmNGEzYyBSZXZlcnQgImxvY2tpbmcv
bXV0ZXhlczogVW5sb2NrIHRoZSBtdXRleCB3aXRob3V0IHRoZSB3YWl0X2xvY2siCgpJZiB5
b3Ugd2FudCB0byBrZWVwIHRoZW0gYnkgY3JlYXRpbmcgYSBuZXcgYnJhbmNoLCB0aGlzIG1h
eSBiZSBhIGdvb2QgdGltZQp0byBkbyBzbyB3aXRoOgoKIGdpdCBicmFuY2ggbmV3X2JyYW5j
aF9uYW1lIDNlZjRhM2MKCkhFQUQgaXMgbm93IGF0IDMzODA3ZjQuLi4gTWVyZ2UgYnJhbmNo
ICdmb3ItbmV4dCcgb2YgZ2l0Oi8vZ2l0LnNhbWJhLm9yZy9zZnJlbmNoL2NpZnMtMi42Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jNi0w
MzEyL3RpcDptYXN0ZXI6MzM4MDdmNGYwZGFlYzNiMDA1NjVjMjkzMmQ5NWY2MTRmNTgzM2Fk
ZjpiaXNlY3QtbmV0CgoyMDE0LTAzLTEyLTIxOjEwOjM0IDMzODA3ZjRmMGRhZWMzYjAwNTY1
YzI5MzJkOTVmNjE0ZjU4MzNhZGYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi0zMzgw
N2Y0ZjBkYWVjM2IwMDU2NWMyOTMyZDk1ZjYxNGY1ODMzYWRmCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzMzODA3ZjRmMGRhZWMzYjAw
NTY1YzI5MzJkOTVmNjE0ZjU4MzNhZGYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTItMzM4MDdm
NGYwZGFlYzNiMDA1NjVjMjkzMmQ5NWY2MTRmNTgzM2FkZgp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWM2
LTAzMTItMzM4MDdmNGYwZGFlYzNiMDA1NjVjMjkzMmQ5NWY2MTRmNTgzM2FkZgprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi8zMzgwN2Y0ZjBkYWVjM2IwMDU2
NWMyOTMyZDk1ZjYxNGY1ODMzYWRmL3ZtbGludXotMy4xNC4wLXJjNi0wMDAyNi1nMzM4MDdm
NAoKMjAxNC0wMy0xMi0yMTozNTozNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMTIJMjAu
LgkyMgkyNy4JMzUJNDMJNTcJNTkJNjAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0
ID09PT09PT09PQpGZXRjaGluZyBuZXh0CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICsg
NTYwMzJmYzUuLi41OGVhYzRkIGFrcG0tYmFzZSAgLT4gbmV4dC9ha3BtLWJhc2UgIChmb3Jj
ZWQgdXBkYXRlKQogKyAxYjBhN2UzLi4uNjlkNWNkZCBtYXN0ZXIgICAgIC0+IG5leHQvbWFz
dGVyICAoZm9yY2VkIHVwZGF0ZSkKICAgYzNiZWJjNy4uMzM4MDdmNCAgc3RhYmxlICAgICAt
PiBuZXh0L3N0YWJsZQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzExIC0+IG5l
eHQtMjAxNDAzMTEKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMzM4MDdmNC4uLiBNZXJn
ZSBicmFuY2ggJ2Zvci1uZXh0JyBvZiBnaXQ6Ly9naXQuc2FtYmEub3JnL3NmcmVuY2gvY2lm
cy0yLjYKSEVBRCBpcyBub3cgYXQgNjlkNWNkZC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZp
YyBmaWxlcyBmb3IgMjAxNDAzMTEKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvdGlwOm1hc3Rlcjo2OWQ1Y2RkYTE2YjNjOTc2
N2I4MmQ4MGIwN2VkYjliYjA1NjQ0OGUzOmJpc2VjdC1uZXQKCjIwMTQtMDMtMTItMjE6NDM6
NTIgNjlkNWNkZGExNmIzYzk3NjdiODJkODBiMDdlZGI5YmIwNTY0NDhlMyBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1jNi0wMzEyLTY5ZDVjZGRhMTZiM2M5NzY3YjgyZDgwYjA3ZWRiOWJiMDU2
NDQ4ZTMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM2
LTAzMTIvNjlkNWNkZGExNmIzYzk3NjdiODJkODBiMDdlZGI5YmIwNTY0NDhlMwp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctYzYtMDMxMi02OWQ1Y2RkYTE2YjNjOTc2N2I4MmQ4MGIwN2VkYjliYjA1NjQ0
OGUzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS8ueDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi02OWQ1Y2RkYTE2YjNjOTc2N2I4MmQ4MGIw
N2VkYjliYjA1NjQ0OGUzCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0w
MzEyLzY5ZDVjZGRhMTZiM2M5NzY3YjgyZDgwYjA3ZWRiOWJiMDU2NDQ4ZTMvdm1saW51ei0z
LjE0LjAtcmM2LW5leHQtMjAxNDAzMTEKCjIwMTQtMDMtMTItMjI6Mjk6NTIgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLgkxLgkyCTMJNS4JNy4uCTEyCTE3CTIyCTI2CTM0CTM1CTM3CTQzCTUw
CTUzCTU4CTYwIFNVQ0NFU1MKCgo9PT09PT09PT0gdGlwL21hc3RlciA9PT09PT09PT0KRmV0
Y2hpbmcgdGlwCkZyb20gZ2l0Oi8vZ2l0bWlycm9yL3RpcAogICA3ZmY0MjQ3Li4xYTc1Yjhl
ICBpcnEvY29yZSAgIC0+IHRpcC9pcnEvY29yZQogICAyMjFmMTlhLi42NjcwYThhICBtYXN0
ZXIgICAgIC0+IHRpcC9tYXN0ZXIKICAgNmJlZGZhYi4uNDE5MWMyOSAgcGVyZi9jb3JlICAt
PiB0aXAvcGVyZi9jb3JlCiAgIDA3MDgyNjguLjYwMzdkZDEgIHNjaGVkL2NvcmUgLT4gdGlw
L3NjaGVkL2NvcmUKICAgZjlhOGEwYS4uMDllMTUxNyAgdGltZXJzL2NvcmUgLT4gdGlwL3Rp
bWVycy9jb3JlClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDY5ZDVjZGQuLi4gQWRkIGxp
bnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwMzExCkhFQUQgaXMgbm93IGF0IDY2
NzBhOGEuLi4gTWVyZ2UgYnJhbmNoICd0aW1lcnMvY29yZScKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTIvdGlwOm1hc3Rlcjo2
NjcwYThhNmY3ZTcxMWI0NTExNGU2YzY2ODcxZDhiYmMyMmE1OWVkOmJpc2VjdC1uZXQKIFRF
U1QgRkFJTFVSRQpbICAgIDQuMTczMzU5XSAxLVdpcmUgZHJpdmVyIGZvciB0aGUgRFMyNzYw
IGJhdHRlcnkgbW9uaXRvciAgY2hpcCAgLSAoYykgMjAwNC0yMDA1LCBTemFib2xjcyBHeXVy
a28KWyAgICA0LjE3NzE2MV0gd2FmZXI1ODIzd2R0OiBXRFQgZHJpdmVyIGZvciBXYWZlciA1
ODIzIHNpbmdsZSBib2FyZCBjb21wdXRlciBpbml0aWFsaXNpbmcKWyAgICA0LjE4MDQwNV0g
LS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgNC4xODEwNzBdIFdB
Uk5JTkc6IENQVTogMCBQSUQ6IDEgYXQga2VybmVsL2xvY2tpbmcvbXV0ZXgtZGVidWcuYzo4
MiBkZWJ1Z19tdXRleF91bmxvY2srMHgyMTEvMHgyMjAoKQpbICAgIDQuMTgxMDcwXSBERUJV
R19MT0NLU19XQVJOX09OKGxvY2stPm93bmVyICE9IGN1cnJlbnQpClsgICAgNC4xODEwNzBd
IE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDQuMTgxMDcwXSBDUFU6IDAgUElEOiAxIENvbW06
IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM2LTAxODc1LWc2NjcwYThhICMyNApb
ICAgIDQuMTgxMDcwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAw
MS8wMS8yMDExClsgICAgNC4xODEwNzBdICAwMDAwMDAwMDAwMDAwMDA5IGZmZmY4ODAwMTIw
Y2ZiZDggZmZmZmZmZmY4MTZlNTcyNiBmZmZmODgwMDEyMGNmYzIwClsgICAgNC4xODEwNzBd
ICBmZmZmODgwMDEyMGNmYzEwIGZmZmZmZmZmODEwNmFkNmQgZmZmZmZmZmY4MWIyZjEyMCAw
MDAwMDAwMDAwMDAwMDAxClsgICAgNC4xODEwNzBdICAwMDAwMDAwMDAwMDAwMjQ2IDAwMDAw
MDAwMDAwMDJkZDIgZmZmZjg4MDAxMjI5YzUwMCBmZmZmODgwMDEyMGNmYzcwClsgICAgNC4x
ODEwNzBdIENhbGwgVHJhY2U6ClsgICAgNC4xODEwNzBdICBbPGZmZmZmZmZmODE2ZTU3MjY+
XSBkdW1wX3N0YWNrKzB4NGQvMHg2NgpbICAgIDQuMTgxMDcwXSAgWzxmZmZmZmZmZjgxMDZh
ZDZkPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3ZC8weGEwClsgICAgNC4xODEwNzBdICBb
PGZmZmZmZmZmODEwNmFkZGM+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDRjLzB4NTAKWyAgICA0
LjE4MTA3MF0gIFs8ZmZmZmZmZmY4MTBiZTVmMT5dIGRlYnVnX211dGV4X3VubG9jaysweDIx
MS8weDIyMApbICAgIDQuMTgxMDcwXSAgWzxmZmZmZmZmZjgxNmYxMzliPl0gX19tdXRleF91
bmxvY2tfc2xvd3BhdGgrMHhkYi8weDIxMApbICAgIDQuMTgxMDcwXSAgWzxmZmZmZmZmZjgx
NmYxNGRlPl0gbXV0ZXhfdW5sb2NrKzB4ZS8weDEwClsgICAgNC4xODEwNzBdICBbPGZmZmZm
ZmZmODEyMDM3NGE+XSBrZXJuZnNfZmluZF9hbmRfZ2V0X25zKzB4NGEvMHg2MApbICAgIDQu
MTgxMDcwXSAgWzxmZmZmZmZmZjgxMjAxODYxPl0gc3lzZnNfbWVyZ2VfZ3JvdXArMHgyMS8w
eGQwClsgICAgNC4xODEwNzBdICBbPGZmZmZmZmZmODE0YWRkYmY+XSBkcG1fc3lzZnNfYWRk
KzB4OGYvMHhiMApbICAgIDQuMTgxMDcwXSAgWzxmZmZmZmZmZjgxNGE0ZmM2Pl0gZGV2aWNl
X2FkZCsweDQ2Ni8weDVkMApbICAgIDQuMTgxMDcwXSAgWzxmZmZmZmZmZjgxNGE1MzgwPl0g
ZGV2aWNlX2NyZWF0ZV9ncm91cHNfdmFyZ3MrMHgxMjAvMHgxNDAKWyAgICA0LjE4MTA3MF0g
IFs8ZmZmZmZmZmY4MTRhNTQwMT5dIGRldmljZV9jcmVhdGUrMHg0MS8weDUwClsgICAgNC4x
ODEwNzBdICBbPGZmZmZmZmZmODE0OTI2YjI+XSBtaXNjX3JlZ2lzdGVyKzB4ZDIvMHgxNDAK
WyAgICA0LjE4MTA3MF0gIFs8ZmZmZmZmZmY4MWM3ZDNjYT5dID8gZml0cGMyX3dkdF9pbml0
KzB4MTRlLzB4MTRlClsgICAgNC4xODEwNzBdICBbPGZmZmZmZmZmODFjN2Q0Yjk+XSB3YWZ3
ZHRfaW5pdCsweGVmLzB4MTY2ClsgICAgNC4xODEwNzBdICBbPGZmZmZmZmZmODEwMDAzNjI+
XSBkb19vbmVfaW5pdGNhbGwrMHgxMjIvMHgxODAKWyAgICA0LjE4MTA3MF0gIFs8ZmZmZmZm
ZmY4MTA4ZjZiOD5dID8gcGFyc2VfYXJncysweDFmOC8weDMzMApbICAgIDQuMTgxMDcwXSAg
WzxmZmZmZmZmZjgxYzNkMWQ5Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxZWQvMHgyNzIK
WyAgICA0LjE4MTA3MF0gIFs8ZmZmZmZmZmY4MWMzYzg4Yj5dID8gZG9fZWFybHlfcGFyYW0r
MHg4OC8weDg4ClsgICAgNC4xODEwNzBdICBbPGZmZmZmZmZmODE2ZDFlOTA+XSA/IHJlc3Rf
aW5pdCsweGQwLzB4ZDAKWyAgICA0LjE4MTA3MF0gIFs8ZmZmZmZmZmY4MTZkMWU5ZT5dIGtl
cm5lbF9pbml0KzB4ZS8weGYwClsgICAgNC4xODEwNzBdICBbPGZmZmZmZmZmODE2ZjQ2NGM+
XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDQuMTgxMDcwXSAgWzxmZmZmZmZmZjgx
NmQxZTkwPl0gPyByZXN0X2luaXQrMHhkMC8weGQwClsgICAgNC4xODEwNzBdIC0tLVsgZW5k
IHRyYWNlIDJlMTcyNTI0NTYyM2YzNmUgXS0tLQpbICAgIDQuMjU1OTg4XSB3YWZlcjU4MjN3
ZHQ6IGluaXRpYWxpemVkLiB0aW1lb3V0PTYwIHNlYyAobm93YXlvdXQ9MCkKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzY2NzBhOGE2ZjdlNzExYjQ1MTE0ZTZjNjY4NzFk
OGJiYzIyYTU5ZWQvZG1lc2ctcXVhbnRhbC14Z3dvLTc6MjAxNDAzMTIyMTM1MTk6eDg2XzY0
LXJhbmRjb25maWctYzYtMDMxMjozLjE0LjAtcmM2LTAxODc1LWc2NjcwYThhOjI0Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi82NjcwYThhNmY3ZTcxMWI0NTExNGU2YzY2
ODcxZDhiYmMyMmE1OWVkL2RtZXNnLXlvY3RvLWJlbnMtMToyMDE0MDMxMjIxMzQ1OTp4ODZf
NjQtcmFuZGNvbmZpZy1jNi0wMzEyOjMuMTQuMC1yYzYtMDE4NzUtZzY2NzBhOGE6MjQKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzY2NzBhOGE2ZjdlNzExYjQ1MTE0ZTZj
NjY4NzFkOGJiYzIyYTU5ZWQvZG1lc2ctcXVhbnRhbC14cHMtMToyMDE0MDMxMjIxMzUyNjp4
ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyOjMuMTQuMC1yYzYtMDE4NzUtZzY2NzBhOGE6MjQK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzY2NzBhOGE2ZjdlNzExYjQ1MTE0
ZTZjNjY4NzFkOGJiYzIyYTU5ZWQvZG1lc2ctcXVhbnRhbC14cHMtNToyMDE0MDMxMjIxMzUy
NTp4ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyOjMuMTQuMC1yYzYtMDE4NzUtZzY2NzBhOGE6
MjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzY2NzBhOGE2ZjdlNzExYjQ1
MTE0ZTZjNjY4NzFkOGJiYzIyYTU5ZWQvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xMToyMDE0
MDMxMjIxMzUxMTp4ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyOjMuMTQuMC1yYzYtMDE4NzUt
ZzY2NzBhOGE6MjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jNi0wMzEyLzY2NzBhOGE2
ZjdlNzExYjQ1MTE0ZTZjNjY4NzFkOGJiYzIyYTU5ZWQvZG1lc2ctcXVhbnRhbC1iZW5zLTU6
MjAxNDAzMTIyMTM1MzM6eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMjozLjE0LjAtcmM2LTAx
ODc1LWc2NjcwYThhOjI0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMxMi82Njcw
YThhNmY3ZTcxMWI0NTExNGU2YzY2ODcxZDhiYmMyMmE1OWVkL2RtZXNnLXlvY3RvLWl2eXRv
d24yLTM6MjAxNDAzMTIyMTM1MTA6eDg2XzY0LXJhbmRjb25maWctYzYtMDMxMjozLjE0LjAt
cmM2LTAxODc1LWc2NjcwYThhOjI0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzYtMDMx
Mi82NjcwYThhNmY3ZTcxMWI0NTExNGU2YzY2ODcxZDhiYmMyMmE1OWVkL2RtZXNnLXF1YW50
YWwteGd3by0xOjIwMTQwMzEyMjEzNTA5Ong4Nl82NC1yYW5kY29uZmlnLWM2LTAzMTI6My4x
NC4wLXJjNi0wMTg3NS1nNjY3MGE4YToyNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM2
LTAzMTIvNjY3MGE4YTZmN2U3MTFiNDUxMTRlNmM2Njg3MWQ4YmJjMjJhNTllZC9kbWVzZy15
b2N0by1pdnl0b3duMi0xMzoyMDE0MDMxMjIxMzQ1OTp4ODZfNjQtcmFuZGNvbmZpZy1jNi0w
MzEyOjMuMTQuMC1yYzYtMDE4NzUtZzY2NzBhOGE6MjQKMDo5OjkgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKCg==

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc6-01849-g221f19a"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc6 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_COMPILE_TEST=y
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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
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
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
CONFIG_LAPB=m
CONFIG_PHONET=m
CONFIG_IEEE802154=m
CONFIG_6LOWPAN_IPHC=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=m
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_FQ=y
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=m
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=m
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=m
CONFIG_HSR=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
# CONFIG_CAN_MCP251X is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=m
# CONFIG_CAN_EMS_PCI is not set
CONFIG_CAN_PEAK_PCMCIA=m
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
# CONFIG_CAN_CC770_PLATFORM is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_KVASER_USB=m
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_8DEV_USB is not set
CONFIG_CAN_SOFTING=m
CONFIG_CAN_SOFTING_CS=m
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_BT_WILINK is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=y

#
# Parallel IDE high-level drivers
#
# CONFIG_PARIDE_PD is not set
CONFIG_PARIDE_PCD=y
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=y
# CONFIG_PARIDE_PG is not set

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=y
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=y
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=y
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=y
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=y
# CONFIG_PARIDE_ON20 is not set
CONFIG_PARIDE_ON26=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=m
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=m
# CONFIG_GENWQE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
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
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
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
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=m
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=m
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=m
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_ATMEL=y
CONFIG_SPI_BCM2835=m
# CONFIG_SPI_BCM63XX_HSSPI is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_EP93XX=m
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_IMX is not set
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_FSL_DSPI=m
CONFIG_SPI_OC_TINY=m
CONFIG_SPI_TI_QSPI=m
CONFIG_SPI_OMAP_100K=m
CONFIG_SPI_ORION=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
CONFIG_SPI_SH=m
CONFIG_SPI_SH_HSPI=m
# CONFIG_SPI_TEGRA114 is not set
CONFIG_SPI_TEGRA20_SFLASH=y
CONFIG_SPI_TEGRA20_SLINK=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_TXX9 is not set
CONFIG_SPI_XCOMM=m
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_CLPS711X is not set
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65912=m
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
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
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=m
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=m
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7310=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=m
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=m

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=m
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
CONFIG_ABX500_CORE=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_DA9210=m
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS6524X=m
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
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
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=m
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=m
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_L4F00242T03=m
# CONFIG_LCD_LMS283GF05 is not set
CONFIG_LCD_LTV350QV=m
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=m
CONFIG_LCD_AMS369FG06=m
CONFIG_LCD_LMS501KF03=m
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=m
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=m
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_SL811_CS is not set
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_RENESAS_USBHS_HCD=m
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=y
# CONFIG_REALTEK_AUTOPM is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=y
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_STORAGE_ENE_UB6250=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=m
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
# CONFIG_KEYSTONE_USB_PHY is not set
CONFIG_NOP_USB_XCEIV=m
CONFIG_OMAP_CONTROL_USB=m
CONFIG_OMAP_USB3=m
# CONFIG_AM335X_PHY_USB is not set
CONFIG_SAMSUNG_USBPHY=m
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_USB_GPIO_VBUS=y
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_RCAR_PHY=m
# CONFIG_USB_RCAR_GEN2_PHY is not set
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_VERBOSE is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=m
# CONFIG_USB_GR_UDC is not set
CONFIG_USB_R8A66597=m
CONFIG_USB_RENESAS_USBHS_UDC=m
CONFIG_USB_PXA27X=m
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=m
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_PHONET=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_CONFIGFS=m
CONFIG_USB_CONFIGFS_SERIAL=y
CONFIG_USB_CONFIGFS_ACM=y
CONFIG_USB_CONFIGFS_OBEX=y
CONFIG_USB_CONFIGFS_NCM=y
CONFIG_USB_CONFIGFS_ECM=y
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
CONFIG_USB_CONFIGFS_RNDIS=y
CONFIG_USB_CONFIGFS_EEM=y
CONFIG_USB_CONFIGFS_PHONET=y
# CONFIG_USB_CONFIGFS_MASS_STORAGE is not set
# CONFIG_USB_CONFIGFS_F_LB_SS is not set
# CONFIG_USB_CONFIGFS_F_FS is not set
CONFIG_USB_ZERO=m
# CONFIG_USB_ETH is not set
CONFIG_USB_G_NCM=m
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_ACM_MS=m
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
CONFIG_USB_G_DBGP=m
# CONFIG_USB_G_DBGP_PRINTK is not set
CONFIG_USB_G_DBGP_SERIAL=y
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_PCA9685=m
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF2127=m
CONFIG_RTC_DRV_PCF8523=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=y
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
# CONFIG_COMEDI is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_RTS5139 is not set
# CONFIG_RTS5208 is not set
CONFIG_TRANZPORT=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
CONFIG_ADIS16203=m
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
# CONFIG_ADIS16220 is not set
# CONFIG_ADIS16240 is not set
# CONFIG_LIS3L02DQ is not set
CONFIG_SCA3000=m

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
CONFIG_AD7606_IFACE_SPI=m
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7780=m
# CONFIG_AD7816 is not set
CONFIG_AD7192=m
# CONFIG_AD7280 is not set
# CONFIG_LPC32XX_ADC is not set
# CONFIG_MXS_LRADC is not set
CONFIG_SPEAR_ADC=m

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
CONFIG_ADT7316_SPI=m
CONFIG_ADT7316_I2C=m

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
# CONFIG_AD9832 is not set
# CONFIG_AD9834 is not set
CONFIG_AD9850=m
# CONFIG_AD9852 is not set
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16060 is not set

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7753=m
# CONFIG_ADE7754 is not set
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=m
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m
CONFIG_ADE7854_SPI=m

#
# Resolver to digital converters
#
CONFIG_AD2S90=m
CONFIG_AD2S1200=m
CONFIG_AD2S1210=m

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=m
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_USB_ENESTORAGE is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
# CONFIG_FT1000_USB is not set
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_ANDROID_INTF_ALARM_DEV=y
# CONFIG_SYNC is not set
# CONFIG_ION is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
CONFIG_LTE_GDM724X=m
CONFIG_CED1401=y
# CONFIG_DGRP is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_KXSD9 is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
CONFIG_AD7266=m
CONFIG_AD7298=m
CONFIG_AD7476=m
CONFIG_AD7791=m
CONFIG_AD7793=m
# CONFIG_AD7887 is not set
CONFIG_AD7923=m
CONFIG_MAX1363=m
CONFIG_MCP320X=m
CONFIG_MCP3422=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
CONFIG_AD5421=m
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
CONFIG_AD5504=m
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5686=m
CONFIG_AD5755=m
# CONFIG_AD5764 is not set
CONFIG_AD5791=m
CONFIG_AD7303=m
CONFIG_MAX517=m
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=m
CONFIG_ADIS16136=m
CONFIG_ADIS16260=m
CONFIG_ADXRS450=m
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
# CONFIG_DHT11 is not set

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=m
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=m
# CONFIG_CM32181 is not set
CONFIG_CM36651=m
# CONFIG_GP2AP020A00F is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_SENSORS_LM3533=m
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_MAG3110=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
CONFIG_IIO_ST_MAGN_SPI_3AXIS=m

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_IIO_ST_PRESS_SPI=m

#
# Temperature sensors
#
CONFIG_TMP006=m
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
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
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_TEST=m
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
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
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
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--fdj2RfSjLxBAspz7--
