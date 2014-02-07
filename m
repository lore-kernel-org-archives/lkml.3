Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaBGCYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 21:24:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:47940 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaBGCYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 21:24:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,797,1384329600"; 
   d="scan'208";a="471149429"
Date: Fri, 7 Feb 2014 10:23:32 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org
Subject: [sched/fair] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000078
Message-ID: <20140207022332.GA11369@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.linaro.org/people/dlezcano/linux sched/idle-balance
commit e7b0e894d633a59a5de296b1ec45806993239799
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sat Feb 11 06:05:00 2012 +0100
Commit:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitDate: Wed Feb 5 11:55:42 2014 +0100

    sched/fair: track cgroup depth
    
    Track depth in cgroup tree, this is useful for things like
    find_matching_se() where you need to get to a common parent of two
    sched entities.
    
    Keeping the depth avoids having to calculate it on the spot, which
    saves a number of possible cache-misses.
    
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
    Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

+---------------------------------------------------------+----+
|                                                         |    |
+---------------------------------------------------------+----+
| boot_successes                                          | 0  |
| boot_failures                                           | 19 |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference_at | 19 |
| Oops:SMP                                                | 19 |
| RIP:pick_next_task_fair                                 | 7  |
| Kernel_panic-not_syncing:Fatal_exception                | 19 |
| backtrace:do_group_exit                                 | 19 |
| backtrace:SyS_exit_group                                | 19 |
| RIP:check_preempt_wakeup                                | 12 |
+---------------------------------------------------------+----+

[   11.140305] Freeing unused kernel memory: 648K (ffff88000155e000 - ffff880001600000)
[   11.156403] Freeing unused kernel memory: 1852K (ffff880001831000 - ffff880001a00000)
[   11.177538] random: init urandom read with 5 bits of entropy available
[   11.193582] BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
[   11.194018] IP: [<ffffffff8108eff6>] pick_next_task_fair+0x171/0x238
[   11.194018] PGD 0 
[   11.194018] Oops: 0000 [#1] SMP 
[   11.194018] Modules linked in:
[   11.194018] CPU: 0 PID: 83 Comm: hostname Not tainted 3.14.0-rc1-00092-g92ed244 #33
[   11.194018] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   11.194018] task: ffff880007bea840 ti: ffff88000ef9e000 task.ti: ffff88000ef9e000
[   11.194018] RIP: 0010:[<ffffffff8108eff6>]  [<ffffffff8108eff6>] pick_next_task_fair+0x171/0x238
[   11.194018] RSP: 0018:ffff88000ef9fd70  EFLAGS: 00010046
[   11.194018] RAX: 00000002893d47ce RBX: ffff88000ee6f248 RCX: 0000000000000000
[   11.194018] RDX: 0000000000000000 RSI: ffff88000ef053d8 RDI: ffff88000d928078
[   11.194018] RBP: ffff88000ef9fda0 R08: 000000000000297c R09: 000000000000b6c8
[   11.194018] R10: ffff88000e60a000 R11: 00000000000023d5 R12: ffff88000d928000
[   11.194018] R13: ffff88000e6127b8 R14: 0000000000000000 R15: 0000000000000001
[   11.194018] FS:  0000000000000000(0000) GS:ffff88000e600000(0000) knlGS:0000000000000000
[   11.194018] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   11.194018] CR2: 0000000000000078 CR3: 0000000001a06000 CR4: 00000000000006f0
[   11.194018] Stack:
[   11.194018]  ffff88000e612740 ffff88000e612740 0000000000000000 ffff880007beac38
[   11.194018]  ffff88000d928000 ffff880007bea840 ffff88000ef9fea0 ffffffff8154fa9a
[   11.194018]  ffff88000ef9ffd8 ffff880007bea840 0000000000012740 0000000000000011
[   11.194018] Call Trace:
[   11.194018]  [<ffffffff8154fa9a>] __schedule+0x1be/0x756
[   11.194018]  [<ffffffff81553205>] ? _raw_spin_unlock_irqrestore+0x51/0x7b
[   11.194018]  [<ffffffff8106a2ff>] ? do_notify_parent+0x22b/0x240
[   11.194018]  [<ffffffff810f0e81>] ? task_function_call+0x44/0x4e
[   11.194018]  [<ffffffff810f59b0>] ? __perf_event_task_sched_out+0x329/0x329
[   11.194018]  [<ffffffff81553023>] ? _raw_spin_lock_irqsave+0x25/0x69
[   11.194018]  [<ffffffff815500a1>] schedule+0x6f/0x71
[   11.194018]  [<ffffffff8105ccd7>] do_exit+0x8e8/0x927
[   11.194018]  [<ffffffff810890cb>] ? vtime_account_user+0x52/0x57
[   11.194018]  [<ffffffff8105dc05>] do_group_exit+0x4a/0x110
[   11.194018]  [<ffffffff8105dcdf>] SyS_exit_group+0x14/0x14
[   11.194018]  [<ffffffff8155ad9b>] tracesys+0xdd/0xe2
[   11.194018] Code: e8 f2 d2 ff ff 4c 8b a3 80 00 00 00 4d 85 e4 0f 85 e8 fe ff ff 4c 8d 63 98 4d 39 e6 74 61 4d 85 f6 74 5c 49 83 c6 68 4c 8b 6b 78 <49> 8b 7e 78 49 39 fd 74 30 44 8b 7b 68 45 8b 6e 68 45 39 ef 7f 
[   11.194018] RIP  [<ffffffff8108eff6>] pick_next_task_fair+0x171/0x238
[   11.194018]  RSP <ffff88000ef9fd70>
[   11.194018] CR2: 0000000000000078
[   11.194018] ---[ end trace d8c5bf7ff957e138 ]---
[   11.194018] Kernel panic - not syncing: Fatal exception

git bisect start 92ed2443d0f6e23e9594bb601be3168e272749a0 38dbfb59d1175ef458d006556061adeaa8751b72 --
git bisect good 7b13b156348b40fec269e870b16aa08dbb498e8d  # 18:27     20+      0  Merge 'spi/for-next' into devel-cairo-x86_64-201402052359
git bisect  bad 9fa2e2a660ea38b0d0dc750e804377a81faab387  # 19:20      0-      2  Merge 'dlezcano/sched/idle-balance' into devel-cairo-x86_64-201402052359
git bisect  bad 7ae0268f44c13f451ffdb8577e60e54319d06f0b  # 20:10      0-     10  sched/fair: clean up __clear_buddies_*
git bisect good 58b46da336a9312b2e21bb576d1c2c484dbf6257  # 20:52     20+      0  sched/numa: Rename variables in task_numa_fault()
git bisect good a68f0647428f0adba291ec07bbfad1b6ae68f56b  # 21:36     20+      0  sched: Fix race in idle_balance()
git bisect good a73b2fc4f74ca24e7d9261d6728a554227b7c913  # 22:05     20+      0  sched: Clean up idle task SMP logic
git bisect  bad 2c9b2540b77a3f7d25ef63f2449a9edf9054dd4e  # 22:47      0-      1  sched: Push put_prev_task() into pick_next_task()
git bisect  bad e7b0e894d633a59a5de296b1ec45806993239799  # 23:09      0-      8  sched/fair: track cgroup depth
# first bad commit: [e7b0e894d633a59a5de296b1ec45806993239799] sched/fair: track cgroup depth
git bisect good a73b2fc4f74ca24e7d9261d6728a554227b7c913  # 23:27     60+      0  sched: Clean up idle task SMP logic
git bisect  bad 92ed2443d0f6e23e9594bb601be3168e272749a0  # 23:27      0-     19  0day head guard for 'devel-cairo-x86_64-201402052359'
git bisect good ef42c58a5b4b8060a3931aab36bf2b4f81b44afc  # 00:59     60+      0  Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 0cc2aa51be9d2f2b001c0e070b2e5cdde89b39f4  # 01:55     60+      0  Add linux-next specific files for 20140206

Thanks,
Fengguang

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-snb-27:20140206001642:x86_64-randconfig-c0-0205:3.14.0-rc1-00092-g92ed244:33"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00092-g92ed244 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #33 SMP Thu Feb 6 00:14:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c0-0205/linux-devel:devel-cairo-x86_64-201402052359/.vmlinuz-=
92ed2443d0f6e23e9594bb601be3168e272749a0-20140206001512-7-snb branch=3Dlinu=
x-devel/devel-cairo-x86_64-201402052359 BOOT_IMAGE=3D/kernel/x86_64-randcon=
fig-c0-0205/92ed2443d0f6e23e9594bb601be3168e272749a0/vmlinuz-3.14.0-rc1-000=
92-g92ed244
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
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01cd1000, 0x01cd1fff] PGTABLE
[    0.000000] BRK [0x01cd2000, 0x01cd2fff] PGTABLE
[    0.000000] BRK [0x01cd3000, 0x01cd3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x01cd4000, 0x01cd4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88000e600000 s79248 r8192=
 d23152 u1048576
[    0.000000] pcpu-alloc: s79248 r8192 d23152 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e60cd80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c0-0205/linux-devel:devel-cairo-x86_64-201402052359/.v=
mlinuz-92ed2443d0f6e23e9594bb601be3168e272749a0-20140206001512-7-snb branch=
=3Dlinux-devel/devel-cairo-x86_64-201402052359 BOOT_IMAGE=3D/kernel/x86_64-=
randconfig-c0-0205/92ed2443d0f6e23e9594bb601be3168e272749a0/vmlinuz-3.14.0-=
rc1-00092-g92ed244
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 220904K/261744K available (5491K kernel code, 892K r=
wdata, 2244K rodata, 956K init, 992K bss, 40840K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00092-g92ed244 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #33 SMP Thu Feb 6 00:14:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c0-0205/linux-devel:devel-cairo-x86_64-201402052359/.vmlinuz-=
92ed2443d0f6e23e9594bb601be3168e272749a0-20140206001512-7-snb branch=3Dlinu=
x-devel/devel-cairo-x86_64-201402052359 BOOT_IMAGE=3D/kernel/x86_64-randcon=
fig-c0-0205/92ed2443d0f6e23e9594bb601be3168e272749a0/vmlinuz-3.14.0-rc1-000=
92-g92ed244
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
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01cd1000, 0x01cd1fff] PGTABLE
[    0.000000] BRK [0x01cd2000, 0x01cd2fff] PGTABLE
[    0.000000] BRK [0x01cd3000, 0x01cd3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x01cd4000, 0x01cd4fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
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
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88000e600000 s79248 r8192=
 d23152 u1048576
[    0.000000] pcpu-alloc: s79248 r8192 d23152 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e60cd80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c0-0205/linux-devel:devel-cairo-x86_64-201402052359/.v=
mlinuz-92ed2443d0f6e23e9594bb601be3168e272749a0-20140206001512-7-snb branch=
=3Dlinux-devel/devel-cairo-x86_64-201402052359 BOOT_IMAGE=3D/kernel/x86_64-=
randconfig-c0-0205/92ed2443d0f6e23e9594bb601be3168e272749a0/vmlinuz-3.14.0-=
rc1-00092-g92ed244
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 220904K/261744K available (5491K kernel code, 892K r=
wdata, 2244K rodata, 956K init, 992K bss, 40840K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2300.194 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 4600.38 Bogo=
MIPS (lpj=3D2300194)
[    0.004012] pid_max: default: 32768 minimum: 301
[    0.006567] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.008135] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.010291] Mount-cache hash table entries: 256
[    0.013759] Initializing cgroup subsys freezer
[    0.014023] Initializing cgroup subsys net_cls
[    0.015027] Initializing cgroup subsys perf_event
[    0.016349] mce: CPU supports 10 MCE banks
[    0.017091] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017091] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.017091] tlb_flushall_shift: 6
[    0.018153] Freeing SMP alternatives memory: 32K (ffffffff81bd0000 - fff=
fffff81bd8000)
[    0.027078] Getting VERSION: 50014
[    0.028022] Getting VERSION: 50014
[    0.029022] Getting ID: 0
[    0.030030] Getting ID: ff000000
[    0.031026] Getting LVT0: 8700
[    0.032018] Getting LVT1: 8400
[    0.033123] enabled ExtINT on CPU#0
[    0.035807] ENABLING IO-APIC IRQs
[    0.036019] init IO_APIC IRQs
[    0.037012]  apic 0 pin 0 not connected
[    0.038036] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.039064] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.040069] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.041061] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.043062] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.044059] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.045072] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.046071] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.047063] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.049068] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.050062] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.051073] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.052067] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.053081] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.054065] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.055041]  apic 0 pin 16 not connected
[    0.056010]  apic 0 pin 17 not connected
[    0.057010]  apic 0 pin 18 not connected
[    0.058009]  apic 0 pin 19 not connected
[    0.059009]  apic 0 pin 20 not connected
[    0.060009]  apic 0 pin 21 not connected
[    0.061009]  apic 0 pin 22 not connected
[    0.062009]  apic 0 pin 23 not connected
[    0.063188] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.064011] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.068011] Using local APIC timer interrupts.
[    0.068011] calibrating APIC timer ...
[    0.070000] ... lapic delta =3D 6250159
[    0.070000] ... PM-Timer delta =3D 358012
[    0.070000] ... PM-Timer result ok
[    0.070000] ..... delta 6250159
[    0.070000] ..... mult: 268442284
[    0.070000] ..... calibration result: 1000025
[    0.070000] ..... CPU clock speed is 2300.0327 MHz.
[    0.070000] ..... host bus clock speed is 1000.0025 MHz.
[    0.070121] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.081454] x86: Booting SMP configuration:
[    0.082008] .... node  #0, CPUs:      #1
[    0.080639] kvm-clock: cpu 1, msr 0:fff8041, secondary cpu clock
[    0.080639] masked ExtINT on CPU#1
[    0.097118] x86: Booted up 1 node, 2 CPUs
[    0.097082] KVM setup async PF for cpu 1
[    0.097082] kvm-stealtime: cpu 1, msr e70cd80
[    0.098014] smpboot: Total of 2 processors activated (9200.77 BogoMIPS)
[    0.101307] devtmpfs: initialized
[    0.122169] xor: measuring software checksum speed
[    0.133038]    prefetch64-sse:    80.000 MB/sec
[    0.144038]    generic_sse:    80.000 MB/sec
[    0.145009] xor: using function: generic_sse (80.000 MB/sec)
[    0.146016] prandom: seed boundary self test passed
[    0.148741] prandom: 100 self tests passed
[    0.149014] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.152561] regulator-dummy: no parameters
[    0.154248] RTC time:  0:16:27, date: 02/06/14
[    0.156229] NET: Registered protocol family 16
[    0.161052] cpuidle: using governor ladder
[    0.162009] cpuidle: using governor menu
[    0.163752] ACPI: bus type PCI registered
[    0.165219] PCI: Using configuration type 1 for base access
[    0.227237] bio: create slab <bio-0> at 0
[    0.246020] raid6: sse2x1    2976 MB/s
[    0.264019] raid6: sse2x2    4980 MB/s
[    0.282010] raid6: sse2x4    5558 MB/s
[    0.283009] raid6: using algorithm sse2x4 (5558 MB/s)
[    0.284008] raid6: using intx1 recovery algorithm
[    0.285813] ACPI: Added _OSI(Module Device)
[    0.286008] ACPI: Added _OSI(Processor Device)
[    0.287010] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.288019] ACPI: Added _OSI(Processor Aggregator Device)
[    0.397424] ACPI: Interpreter enabled
[    0.398052] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.402006] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.405161] ACPI: (supports S0 S3 S5)
[    0.406008] ACPI: Using IOAPIC for interrupt routing
[    0.408429] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.623393] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.624071] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.625266] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.638131] PCI host bridge to bus 0000:00
[    0.639033] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.640032] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.641033] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.642031] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.643030] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.644120] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.650747] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.656497] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.662015] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.670443] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.672589] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.673046] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.679559] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.683073] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.687081] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.699076] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.705800] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.708015] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.711023] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.721016] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.727330] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.730013] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.733021] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.749471] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.753009] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.756014] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.772934] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.775013] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.778013] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.794156] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.797012] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.801012] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.817304] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.820013] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.823014] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.839470] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.843014] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.846012] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.861640] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.863014] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.889163] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.895860] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.901602] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.908592] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.913074] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.927908] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.930345] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.933016] vgaarb: loaded
[    0.935007] vgaarb: bridge control possible 0000:00:02.0
[    0.937985] ACPI: bus type USB registered
[    0.940946] usbcore: registered new interface driver usbfs
[    0.943444] usbcore: registered new interface driver hub
[    0.948288] usbcore: registered new device driver usb
[    0.951329] pps_core: LinuxPPS API ver. 1 registered
[    0.954007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.957239] PTP clock support registered
[    0.960447] EDAC MC: Ver: 3.0.0
[    0.964422] PCI: Using ACPI for IRQ routing
[    0.966020] PCI: pci_cache_line_size set to 64 bytes
[    0.969437] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.971047] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.979003] Switched to clocksource kvm-clock
[    1.161155] pnp: PnP ACPI init
[    1.163174] ACPI: bus type PNP registered
[    1.165748] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.170353] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.173556] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.178156] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.181355] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.185956] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.189836] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.193714] pnp 00:03: [dma 2]
[    1.196218] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.200125] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.204672] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.208566] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.213153] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.222168] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.229456] pnp: PnP ACPI: found 7 devices
[    1.231518] ACPI: bus type PNP unregistered
[    1.274852] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.277100] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.279262] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.281617] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.284425] NET: Registered protocol family 2
[    1.288306] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    1.290965] TCP bind hash table entries: 2048 (order: 3, 32768 bytes)
[    1.293313] TCP: Hash tables configured (established 2048 bind 2048)
[    1.295942] TCP: reno registered
[    1.297854] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    1.300303] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    1.303473] NET: Registered protocol family 1
[    1.305841] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.308247] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.310652] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.313051] pci 0000:00:02.0: Boot video device
[    1.315281] PCI: CLS 0 bytes, default 64
[    1.319386] Unpacking initramfs...
[    3.026134] Freeing initrd memory: 23244K (ffff88000e93d000 - ffff88000f=
ff0000)
[    3.032697] Machine check injector initialized
[    3.035417] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.037996] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.040847] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    3.048084] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    3.055307] AVX or AES-NI instructions are not detected.
[    3.057704] AVX instructions are not detected.
[    3.059802] AVX2 instructions are not detected.
[    3.065603] futex hash table entries: 512 (order: 3, 32768 bytes)
[    3.069276] Initialise system trusted keyring
[    3.071559] audit: initializing netlink subsys (disabled)
[    3.074176] audit: type=3D2000 audit(1391616989.981:1): initialized
[    3.330657] VFS: Disk quotas dquot_6.5.2
[    3.334978] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.351904] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.354323] ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.361125] QNX4 filesystem 0.2.3 registered.
[    3.365475] QNX6 filesystem 1.0.0 registered.
[    3.379116] NILFS version 2 loaded
[    3.380909] BeFS version: 0.9.3
[    3.404734] GFS2 installed
[    3.418136] NET: Registered protocol family 38
[    3.420389] async_tx: api initialized (async)
[    3.425115] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    3.428738] io scheduler noop registered (default)
[    3.435313] io scheduler cfq registered
[    3.441564] hgafb: HGA card not detected.
[    3.443614] hgafb: probe of hgafb.0 failed with error -22
[    3.447317] usbcore: registered new interface driver smscufx
[    3.451623] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.455267] ACPI: Power Button [PWRF]
[    3.715502] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.741856] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.756811] lkdtm: No crash points registered, enable through debugfs
[    3.759545] mic_init not running on X100 ret -19
[    3.761775] Uniform Multi-Platform E-IDE driver
[    3.774698] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.778970] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.783249] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.787396] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.791651] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.795895] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.800115] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    3.802681] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    3.804915] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    3.807492] flash size: 128 MiB
[    3.809363] page size: 512 bytes
[    3.810904] OOB area size: 16 bytes
[    3.812855] sector size: 16 KiB
[    3.814662] pages number: 262144
[    3.816484] pages per sector: 32
[    3.818347] bus width: 8
[    3.820024] bits in sector size: 14
[    3.821907] bits in page size: 9
[    3.823739] bits in OOB size: 4
[    3.825563] flash size with OOB: 135168 KiB
[    3.827626] page address bytes: 4
[    3.829494] sector address bytes: 3
[    3.831219] options: 0x42
[    3.836077] Scanning device for bad blocks
[    3.861442] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.864103] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.873617] tun: Universal TUN/TAP device driver, 1.6
[    3.875938] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.879835] usbcore: registered new interface driver kaweth
[    3.882239] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    3.886111] usbcore: registered new interface driver pegasus
[    3.889849] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.892413] ehci-pci: EHCI PCI platform driver
[    3.894763] ehci-platform: EHCI generic platform driver
[    3.898764] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.901447] ohci-pci: OHCI PCI platform driver
[    3.903942] ohci-platform: OHCI generic platform driver
[    3.908217] usbcore: registered new interface driver usbserial
[    3.911048] usbcore: registered new interface driver usbserial_generic
[    3.914065] usbserial: USB Serial support registered for generic
[    3.916700] usbcore: registered new interface driver ark3116
[    3.919267] usbserial: USB Serial support registered for ark3116
[    3.921984] usbcore: registered new interface driver ch341
[    3.924555] usbserial: USB Serial support registered for ch341-uart
[    3.927437] usbcore: registered new interface driver usb_debug
[    3.930229] usbserial: USB Serial support registered for debug
[    3.933040] usbcore: registered new interface driver digi_acceleport
[    3.935976] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[    3.939973] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[    3.944082] usbcore: registered new interface driver ipw
[    3.946722] usbserial: USB Serial support registered for IPWireless conv=
erter
[    3.949828] usbcore: registered new interface driver iuu_phoenix
[    3.952642] usbserial: USB Serial support registered for iuu_phoenix
[    3.955553] usbcore: registered new interface driver metro_usb
[    3.958321] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    3.962279] usbcore: registered new interface driver mos7720
[    3.964966] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    3.968993] usbcore: registered new interface driver navman
[    3.971703] usbserial: USB Serial support registered for navman
[    3.974496] usbcore: registered new interface driver omninet
[    3.977283] usbserial: USB Serial support registered for ZyXEL - omni.ne=
t lcd plus usb
[    3.981451] usbcore: registered new interface driver opticon
[    3.984128] usbserial: USB Serial support registered for opticon
[    3.986844] usbcore: registered new interface driver option
[    3.989470] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[    3.992429] usbcore: registered new interface driver pl2303
[    3.995154] usbserial: USB Serial support registered for pl2303
[    3.997975] usbcore: registered new interface driver quatech2
[    4.000756] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    4.005097] usbcore: registered new interface driver safe_serial
[    4.007909] usbserial: USB Serial support registered for safe_serial
[    4.010794] usbcore: registered new interface driver sierra
[    4.013529] usbserial: USB Serial support registered for Sierra USB modem
[    4.016553] usbcore: registered new interface driver symbolserial
[    4.019415] usbserial: USB Serial support registered for symbol
[    4.021030] usbcore: registered new interface driver ti_usb_3410_5052
[    4.022698] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    4.025112] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    4.027467] usbcore: registered new interface driver visor
[    4.028994] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    4.038754] tsc: Refined TSC clocksource calibration: 2299.966 MHz
[    4.040436] usbserial: USB Serial support registered for Sony Clie 5.0
[    4.042147] usbserial: USB Serial support registered for Sony Clie 3.5
[    4.043819] usbcore: registered new interface driver wishbone_serial
[    4.045484] usbserial: USB Serial support registered for wishbone_serial
[    4.047166] usbcore: registered new interface driver whiteheat
[    4.048757] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    4.051266] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    4.053857] usbcore: registered new interface driver appledisplay
[    4.055536] usbcore: registered new interface driver cypress_cy7c63
[    4.057192] usbcore: registered new interface driver idmouse
[    4.058874] usbcore: registered new interface driver iowarrior
[    4.060484] usbcore: registered new interface driver usblcd
[    4.062166] usbcore: registered new interface driver ldusb
[    4.063709] usbcore: registered new interface driver usb_ehset_test
[    4.065381] usbcore: registered new interface driver yurex
[    4.068421] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.073430] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.075714] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.080913] mousedev: PS/2 mouse device common for all mice
[    4.087185] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.094513] usbcore: registered new interface driver gtco
[    4.097115] usbcore: registered new interface driver hanwang
[    4.099673] usbcore: registered new interface driver kbtab
[    4.103639] usbcore: registered new interface driver sur40
[    4.106728] usbcore: registered new interface driver ati_remote2
[    4.109080] cm109: Keymap for Komunikate KIP1000 phone loaded
[    4.111858] usbcore: registered new interface driver cm109
[    4.114142] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    4.117732] pps pps0: new PPS source ktimer
[    4.119763] pps pps0: ktimer PPS source registered
[    4.121792] pps_ldisc: PPS line discipline registered
[    4.124369] Driver for 1-wire Dallas network protocol.
[    4.128036] applesmc: supported laptop not found!
[    4.130080] applesmc: driver init failed (ret=3D-19)!
[    4.132246] f71882fg: Not a Fintek device
[    4.134238] f71882fg: Not a Fintek device
[    4.137360] md: raid6 personality registered for level 6
[    4.139645] md: raid5 personality registered for level 5
[    4.141885] md: raid4 personality registered for level 4
[    4.148187] hidraw: raw HID events driver (C) Jiri Kosina
[    4.157420] usbcore: registered new interface driver usbhid
[    4.158881] usbhid: USB HID core driver
[    4.160183] usbcore: registered new interface driver serqt_usb2
[    4.161832] usbserial: USB Serial support registered for Quatech USB to =
Serial Driver
[    4.165078] intel_rapl: driver does not support CPU family 15 model 6
[    4.168257] GACT probability NOT on
[    4.169357] Mirror/redirect action on
[    4.170509] netem: version 1.3
[    4.173036] u32 classifier
[    4.174062]     Performance counters on
[    4.175243]     input device check on
[    4.176419]     Actions configured
[    4.177509] IPVS: Registered protocols (TCP, ESP)
[    4.180347] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[    4.182703] IPVS: Creating netns size=3D1464 id=3D0
[    4.184605] IPVS: ipvs loaded.
[    4.186074] IPVS: [rr] scheduler registered.
[    4.188105] IPVS: [wrr] scheduler registered.
[    4.190120] IPVS: [sh] scheduler registered.
[    4.192093] IPVS: [sed] scheduler registered.
[    4.194062] IPVS: [nq] scheduler registered.
[    4.201225] tcp_probe: probe registered (port=3D0/fwmark=3D0) bufsize=3D=
4096
[    4.203972] TCP: cubic registered
[    4.210789] NET: Registered protocol family 33
[    4.212800] Key type rxrpc registered
[    4.214591] Key type rxrpc_s registered
[    4.216597] l2tp_core: L2TP core driver, V2.0
[    4.218776] l2tp_debugfs: L2TP debugfs support
[    4.226846] NET: Registered protocol family 21
[    4.229023] lib80211: common routines for IEEE802.11 drivers
[    4.231280] lib80211_crypt: registered algorithm 'NULL'
[    4.233161] lib80211_crypt: registered algorithm 'WEP'
[    4.235394] lib80211_crypt: registered algorithm 'CCMP'
[    4.237627] lib80211_crypt: registered algorithm 'TKIP'
[    4.239851] tipc: Activated (version 2.0.0)
[    4.245240] NET: Registered protocol family 30
[    4.250223] tipc: Started in single node mode
[    4.251464] 9pnet: Installing 9P2000 support
[    4.252692] NET: Registered protocol family 37
[    4.258631] NET: Registered protocol family 36
[    4.260872] Key type dns_resolver registered
[    4.266273]=20
[    4.266273] printing PIC contents
[    4.269364] ... PIC  IMR: ffff
[    4.270335] ... PIC  IRR: 1013
[    4.272936] ... PIC  ISR: 0000
[    4.274698] ... PIC ELCR: 0c00
[    4.276417] printing local APIC contents on CPU#0/0:
[    4.277394] ... APIC ID:      00000000 (0)
[    4.277394] ... APIC VERSION: 00050014
[    4.277394] ... APIC TASKPRI: 00000000 (00)
[    4.277394] ... APIC PROCPRI: 00000000
[    4.277394] ... APIC LDR: 01000000
[    4.277394] ... APIC DFR: ffffffff
[    4.277394] ... APIC SPIV: 000001ff
[    4.277394] ... APIC ISR field:
[    4.277394] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.277394] ... APIC TMR field:
[    4.277394] 000000000200000000000000000000000000000000000000000000000000=
0000
[    4.277394] ... APIC IRR field:
[    4.277394] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.277394] ... APIC ESR: 00000000
[    4.277394] ... APIC ICR: 000008fd
[    4.277394] ... APIC ICR2: 02000000
[    4.277394] ... APIC LVTT: 000000ef
[    4.277394] ... APIC LVTPC: 00010000
[    4.277394] ... APIC LVT0: 00010700
[    4.277394] ... APIC LVT1: 00000400
[    4.277394] ... APIC LVTERR: 000000fe
[    4.277394] ... APIC TMICT: 0105bfcd
[    4.277394] ... APIC TMCCT: 00cafc08
[    4.277394] ... APIC TDCR: 00000003
[    4.277394]=20
[    4.332236] number of MP IRQ sources: 15.
[    4.334180] number of IO-APIC #0 registers: 24.
[    4.336156] testing the IO APIC.......................
[    4.338272] IO APIC #0......
[    4.339871] .... register #00: 00000000
[    4.341706] .......    : physical APIC id: 00
[    4.343615] .......    : Delivery Type: 0
[    4.345485] .......    : LTS          : 0
[    4.347431] .... register #01: 00170011
[    4.349313] .......     : max redirection entries: 17
[    4.351495] .......     : PRQ implemented: 0
[    4.353478] .......     : IO APIC version: 11
[    4.355456] .... register #02: 00000000
[    4.357344] .......     : arbitration: 00
[    4.359262] .... IRQ redirection table:
[    4.361181] 1    0    0   0   0    0    0    00
[    4.363251] 0    0    0   0   0    1    1    31
[    4.365344] 0    0    0   0   0    1    1    30
[    4.367398] 0    0    0   0   0    1    1    33
[    4.369478] 1    0    0   0   0    1    1    34
[    4.371557] 1    1    0   0   0    1    1    35
[    4.373646] 0    0    0   0   0    1    1    36
[    4.375685] 0    0    0   0   0    1    1    37
[    4.377763] 0    0    0   0   0    1    1    38
[    4.379858] 0    1    0   0   0    1    1    39
[    4.381946] 1    1    0   0   0    1    1    3A
[    4.383999] 1    1    0   0   0    1    1    3B
[    4.386083] 0    0    0   0   0    1    1    3C
[    4.388148] 0    0    0   0   0    1    1    3D
[    4.390242] 0    0    0   0   0    1    1    3E
[    4.392308] 0    0    0   0   0    1    1    3F
[    4.394391] 1    0    0   0   0    0    0    00
[    4.396474] 1    0    0   0   0    0    0    00
[    4.398549] 1    0    0   0   0    0    0    00
[    4.400633] 1    0    0   0   0    0    0    00
[    4.402687] 1    0    0   0   0    0    0    00
[    4.404729] 1    0    0   0   0    0    0    00
[    4.406840] 1    0    0   0   0    0    0    00
[    4.408914] 1    0    0   0   0    0    0    00
[    4.410991] IRQ to pin mappings:
[    4.412765] IRQ0 -> 0:2
[    4.414626] IRQ1 -> 0:1
[    4.416532] IRQ3 -> 0:3
[    4.418430] IRQ4 -> 0:4
[    4.420319] IRQ5 -> 0:5
[    4.422176] IRQ6 -> 0:6
[    4.424032] IRQ7 -> 0:7
[    4.425857] IRQ8 -> 0:8
[    4.427748] IRQ9 -> 0:9
[    4.429616] IRQ10 -> 0:10
[    4.431547] IRQ11 -> 0:11
[    4.433474] IRQ12 -> 0:12
[    4.435328] IRQ13 -> 0:13
[    4.437288] IRQ14 -> 0:14
[    4.439273] IRQ15 -> 0:15
[    4.441283] .................................... done.
[    4.444902] Loading compiled-in X.509 certificates
[    4.447359] registered taskstats version 1
[    4.449350] kAFS: Red Hat AFS client v0.1 registering.
[    4.467764] Key type trusted registered
[    4.469847] raid6test: testing the 4-disk case...
[    4.472069] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    4.474569] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) =
 OK
[    4.477236] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) =
 OK
[    4.479936] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) =
 OK
[    4.482628] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) =
 OK
[    4.485151] raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) =
 OK
[    4.488837] raid6test: testing the 5-disk case...
[    4.491112] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    4.493834] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    4.496454] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) =
 OK
[    4.498873] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) =
 OK
[    4.501340] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    4.503844] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) =
 OK
[    4.506410] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) =
 OK
[    4.508979] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) =
 OK
[    4.511540] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) =
 OK
[    4.514066] raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) =
 OK
[    4.516706] raid6test: testing the 11-disk case...
[    4.518899] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    4.521518] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    4.524143] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    4.526784] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    4.529367] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    4.532002] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    4.534609] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    4.537222] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    4.539839] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) =
 OK
[    4.542492] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)=
  OK
[    4.545148] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    4.547814] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    4.550449] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    4.553102] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    4.555770] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    4.558405] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    4.561054] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    4.563678] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) =
 OK
[    4.566307] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)=
  OK
[    4.568976] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    4.571618] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    4.574242] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    4.576903] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    4.579547] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    4.582183] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    4.584240] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) =
 OK
[    4.585780] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)=
  OK
[    4.587314] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    4.588839] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    4.590359] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    4.591863] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    4.593391] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    4.594894] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) =
 OK
[    4.596408] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)=
  OK
[    4.597935] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    4.599454] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    4.600969] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    4.602493] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    4.603997] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) =
 OK
[    4.605514] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)=
  OK
[    4.607048] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    4.608564] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    4.610070] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    4.611584] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) =
 OK
[    4.613082] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)=
  OK
[    4.614604] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    4.616129] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    4.617708] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) =
 OK
[    4.619199] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)=
  OK
[    4.620758] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    4.622265] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) =
 OK
[    4.623792] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)=
  OK
[    4.625367] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) =
 OK
[    4.626857] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)=
  OK
[    4.629180] raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)=
  OK
[    4.632109] raid6test: testing the 12-disk case...
[    4.634381] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    4.637092] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    4.639851] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    4.642627] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    4.645383] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    4.648107] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    4.650812] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    4.653546] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    4.656218] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    4.658929] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)=
  OK
[    4.661649] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)=
  OK
[    4.664361] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    4.667110] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    4.669818] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    4.672569] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    4.675303] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    4.678070] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    4.680805] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    4.683476] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    4.686194] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)=
  OK
[    4.688904] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)=
  OK
[    4.691708] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    4.694459] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    4.697208] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    4.699958] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    4.702723] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    4.705498] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    4.708069] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    4.710304] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)=
  OK
[    4.712635] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)=
  OK
[    4.715263] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    4.717846] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    4.720534] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    4.723196] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    4.725428] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    4.728041] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    4.730612] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)=
  OK
[    4.733156] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)=
  OK
[    4.735747] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    4.738337] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    4.740896] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    4.743556] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    4.746158] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    4.748725] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)=
  OK
[    4.751317] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)=
  OK
[    4.753939] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    4.756530] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    4.759107] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    4.761711] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    4.764312] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)=
  OK
[    4.766911] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)=
  OK
[    4.769527] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    4.772088] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    4.774608] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    4.777168] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)=
  OK
[    4.779728] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)=
  OK
[    4.782292] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    4.784942] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    4.787509] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)=
  OK
[    4.790116] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)=
  OK
[    4.792736] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    4.795358] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)=
  OK
[    4.797958] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)=
  OK
[    4.800611] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)=
  OK
[    4.803272] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)=
  OK
[    4.805858] raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q=
)  OK
[    4.808870] raid6test: testing the 24-disk case...
[    4.811115] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    4.813775] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    4.816433] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    4.819086] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    4.821694] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    4.824319] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    4.826974] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    4.829645] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    4.832244] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    4.834865] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[    4.837539] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[    4.840182] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[    4.842869] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[    4.844636] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[    4.846175] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[    4.847720] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[    4.849278] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[    4.850810] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[    4.852352] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[    4.853894] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[    4.855453] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[    4.856995] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(P)=
  OK
[    4.858552] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(Q)=
  OK
[    4.860090] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    4.861618] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    4.863153] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    4.864699] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    4.866247] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    4.867783] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    4.869330] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    4.870873] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    4.872416] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[    4.873950] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[    4.875527] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[    4.877075] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[    4.878633] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[    4.880182] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[    4.888998] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[    4.890568] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[    4.892100] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[    4.893653] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[    4.895205] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[    4.896778] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[    4.898329] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(P)=
  OK
[    4.899853] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(Q)=
  OK
[    4.901397] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    4.902933] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    4.904478] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    4.906031] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    4.907585] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    4.909113] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    4.910655] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    4.912176] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[    4.913740] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[    4.915302] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[    4.916841] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[    4.918405] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[    4.919944] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[    4.921549] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[    4.923084] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[    4.924634] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[    4.926175] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[    4.927734] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[    4.929294] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[    4.930830] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(P)=
  OK
[    4.932368] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(Q)=
  OK
[    4.933905] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    4.935480] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    4.937026] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    4.938570] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    4.940096] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    4.941645] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    4.943177] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[    4.945152] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[    4.947971] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[    4.950430] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[    4.952965] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[    4.955629] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[    4.958268] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[    4.960967] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[    4.963769] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[    4.966592] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[    4.969333] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[    4.972141] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[    4.974954] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(P)=
  OK
[    4.977696] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(Q)=
  OK
[    4.980467] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    4.983214] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    4.985950] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    4.988710] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    4.991561] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    4.994290] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[    4.997122] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[    4.999845] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[    5.002606] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[    5.005290] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[    5.008106] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[    5.010894] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[    5.013702] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[    5.016496] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[    5.019265] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[    5.022040] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[    5.024824] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[    5.027614] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(P)=
  OK
[    5.030366] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(Q)=
  OK
[    5.033122] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    5.035907] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    5.038677] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    5.041513] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    5.044382] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[    5.047213] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[    5.049973] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[    5.052763] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[    5.055565] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[    5.058343] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[    5.061127] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[    5.063896] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[    5.066676] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[    5.069424] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[    5.072172] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[    5.074933] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[    5.077751] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(P)=
  OK
[    5.080496] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(Q)=
  OK
[    5.083276] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    5.086053] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    5.088787] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    5.091524] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[    5.094265] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[    5.097058] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[    5.099830] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[    5.102623] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[    5.105394] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[    5.108155] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[    5.110932] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[    5.113716] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[    5.116529] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[    5.119295] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[    5.122056] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[    5.124708] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(P)=
  OK
[    5.127499] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(Q)=
  OK
[    5.130301] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    5.132972] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    5.135726] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[    5.138504] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[    5.141301] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[    5.144111] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[    5.146938] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[    5.149757] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[    5.152543] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[    5.155344] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[    5.158116] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[    5.160874] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[    5.163677] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[    5.166489] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[    5.169245] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(P)=
  OK
[    5.171991] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(Q)=
  OK
[    5.174754] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    5.177566] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[    5.180354] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[    5.183122] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[    5.185900] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[    5.188718] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[    5.191572] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[    5.194310] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[    5.197145] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[    5.199951] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[    5.202773] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[    5.205601] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[    5.208411] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[    5.211258] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(P)=
  OK
[    5.213750] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(Q)=
  OK
[    5.216203] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[    5.218770] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[    5.221432] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[    5.224116] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[    5.226819] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[    5.229413] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[    5.232064] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[    5.234711] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[    5.237357] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[    5.239994] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[    5.242636] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[    5.245113] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[    5.247662] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(P)=
  OK
[    5.250075] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(Q)=
  OK
[    5.252538] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[    5.254280] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[    5.256199] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[    5.258837] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[    5.261465] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[    5.264166] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[    5.266848] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[    5.269623] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[    5.272120] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[    5.274681] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[    5.277323] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[    5.279952] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(P=
)  OK
[    5.282593] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(Q=
)  OK
[    5.285177] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[    5.287810] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[    5.290518] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[    5.293287] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[    5.295835] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[    5.298326] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[    5.300838] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[    5.303456] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[    5.306193] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[    5.308960] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[    5.311424] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(P=
)  OK
[    5.313937] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(Q=
)  OK
[    5.316717] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[    5.319513] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[    5.322260] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[    5.324987] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[    5.327506] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[    5.330034] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[    5.332732] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[    5.349122] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[    5.351849] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[    5.354487] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(P=
)  OK
[    5.357081] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(Q=
)  OK
[    5.359738] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[    5.362451] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[    5.365117] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[    5.367848] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[    5.370599] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[    5.373166] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[    5.375845] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[    5.378523] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[    5.381163] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(P=
)  OK
[    5.383794] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(Q=
)  OK
[    5.386466] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[    5.389117] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[    5.391855] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[    5.394361] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[    5.396976] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[    5.399722] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[    5.402500] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[    5.405300] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(P=
)  OK
[    5.408074] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(Q=
)  OK
[    5.410841] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[    5.413597] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[    5.416395] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[    5.419171] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[    5.421888] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[    5.424704] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[    5.427551] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(P=
)  OK
[    5.430294] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(Q=
)  OK
[    5.433080] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[    5.435878] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[    5.438596] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[    5.441325] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[    5.444090] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[    5.446891] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(P=
)  OK
[    5.449635] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(Q=
)  OK
[    5.452424] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[    5.455177] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[    5.457983] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[    5.460803] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[    5.463567] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(P=
)  OK
[    5.466306] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(Q=
)  OK
[    5.469074] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[    5.471843] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[    5.474632] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[    5.477404] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(P=
)  OK
[    5.480066] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(Q=
)  OK
[    5.482801] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[    5.485576] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[    5.488292] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(P=
)  OK
[    5.491086] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(Q=
)  OK
[    5.493878] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[    5.496649] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(P=
)  OK
[    5.499248] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(Q=
)  OK
[    5.502054] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(P=
)  OK
[    5.504720] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(Q=
)  OK
[    5.507467] raid6test: test_disks(22, 23): faila=3D 22(P)  failb=3D 23(Q=
)  OK
[    5.511571] raid6test: testing the 64-disk case...
[    5.513996] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    5.516568] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    5.519145] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    5.521900] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    5.524373] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    5.527203] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    5.529991] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    5.532424] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    5.535284] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    5.538061] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[    5.540868] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[    5.543337] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[    5.546059] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[    5.548867] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[    5.551764] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[    5.554740] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[    5.557548] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[    5.560314] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[    5.563034] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[    5.565846] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[    5.568591] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[    5.571364] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(D)=
  OK
[    5.574223] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(D)=
  OK
[    5.577063] raid6test: test_disks(0, 24): faila=3D  0(D)  failb=3D 24(D)=
  OK
[    5.579886] raid6test: test_disks(0, 25): faila=3D  0(D)  failb=3D 25(D)=
  OK
[    5.582634] raid6test: test_disks(0, 26): faila=3D  0(D)  failb=3D 26(D)=
  OK
[    5.585484] raid6test: test_disks(0, 27): faila=3D  0(D)  failb=3D 27(D)=
  OK
[    5.588341] raid6test: test_disks(0, 28): faila=3D  0(D)  failb=3D 28(D)=
  OK
[    5.591043] raid6test: test_disks(0, 29): faila=3D  0(D)  failb=3D 29(D)=
  OK
[    5.593844] raid6test: test_disks(0, 30): faila=3D  0(D)  failb=3D 30(D)=
  OK
[    5.596698] raid6test: test_disks(0, 31): faila=3D  0(D)  failb=3D 31(D)=
  OK
[    5.599515] raid6test: test_disks(0, 32): faila=3D  0(D)  failb=3D 32(D)=
  OK
[    5.602312] raid6test: test_disks(0, 33): faila=3D  0(D)  failb=3D 33(D)=
  OK
[    5.605213] raid6test: test_disks(0, 34): faila=3D  0(D)  failb=3D 34(D)=
  OK
[    5.607973] raid6test: test_disks(0, 35): faila=3D  0(D)  failb=3D 35(D)=
  OK
[    5.610787] raid6test: test_disks(0, 36): faila=3D  0(D)  failb=3D 36(D)=
  OK
[    5.613582] raid6test: test_disks(0, 37): faila=3D  0(D)  failb=3D 37(D)=
  OK
[    5.616359] raid6test: test_disks(0, 38): faila=3D  0(D)  failb=3D 38(D)=
  OK
[    5.619145] raid6test: test_disks(0, 39): faila=3D  0(D)  failb=3D 39(D)=
  OK
[    5.621942] raid6test: test_disks(0, 40): faila=3D  0(D)  failb=3D 40(D)=
  OK
[    5.624741] raid6test: test_disks(0, 41): faila=3D  0(D)  failb=3D 41(D)=
  OK
[    5.627513] raid6test: test_disks(0, 42): faila=3D  0(D)  failb=3D 42(D)=
  OK
[    5.630351] raid6test: test_disks(0, 43): faila=3D  0(D)  failb=3D 43(D)=
  OK
[    5.633214] raid6test: test_disks(0, 44): faila=3D  0(D)  failb=3D 44(D)=
  OK
[    5.636039] raid6test: test_disks(0, 45): faila=3D  0(D)  failb=3D 45(D)=
  OK
[    5.638786] raid6test: test_disks(0, 46): faila=3D  0(D)  failb=3D 46(D)=
  OK
[    5.641630] raid6test: test_disks(0, 47): faila=3D  0(D)  failb=3D 47(D)=
  OK
[    5.644362] raid6test: test_disks(0, 48): faila=3D  0(D)  failb=3D 48(D)=
  OK
[    5.647213] raid6test: test_disks(0, 49): faila=3D  0(D)  failb=3D 49(D)=
  OK
[    5.650040] raid6test: test_disks(0, 50): faila=3D  0(D)  failb=3D 50(D)=
  OK
[    5.652877] raid6test: test_disks(0, 51): faila=3D  0(D)  failb=3D 51(D)=
  OK
[    5.655675] raid6test: test_disks(0, 52): faila=3D  0(D)  failb=3D 52(D)=
  OK
[    5.658483] raid6test: test_disks(0, 53): faila=3D  0(D)  failb=3D 53(D)=
  OK
[    5.661213] raid6test: test_disks(0, 54): faila=3D  0(D)  failb=3D 54(D)=
  OK
[    5.664038] raid6test: test_disks(0, 55): faila=3D  0(D)  failb=3D 55(D)=
  OK
[    5.666855] raid6test: test_disks(0, 56): faila=3D  0(D)  failb=3D 56(D)=
  OK
[    5.669593] raid6test: test_disks(0, 57): faila=3D  0(D)  failb=3D 57(D)=
  OK
[    5.672427] raid6test: test_disks(0, 58): faila=3D  0(D)  failb=3D 58(D)=
  OK
[    5.675230] raid6test: test_disks(0, 59): faila=3D  0(D)  failb=3D 59(D)=
  OK
[    5.678059] raid6test: test_disks(0, 60): faila=3D  0(D)  failb=3D 60(D)=
  OK
[    5.680828] raid6test: test_disks(0, 61): faila=3D  0(D)  failb=3D 61(D)=
  OK
[    5.683579] raid6test: test_disks(0, 62): faila=3D  0(D)  failb=3D 62(P)=
  OK
[    5.686322] raid6test: test_disks(0, 63): faila=3D  0(D)  failb=3D 63(Q)=
  OK
[    5.689209] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    5.692094] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    5.694832] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    5.697639] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    5.700311] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    5.703235] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    5.706063] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    5.708683] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    5.711372] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[    5.714241] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[    5.717202] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[    5.719943] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[    5.722747] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[    5.725427] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[    5.728201] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[    5.730992] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[    5.733794] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[    5.736590] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[    5.739457] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[    5.742132] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[    5.745047] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(D)=
  OK
[    5.747880] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(D)=
  OK
[    5.750759] raid6test: test_disks(1, 24): faila=3D  1(D)  failb=3D 24(D)=
  OK
[    5.753647] raid6test: test_disks(1, 25): faila=3D  1(D)  failb=3D 25(D)=
  OK
[    5.756413] raid6test: test_disks(1, 26): faila=3D  1(D)  failb=3D 26(D)=
  OK
[    5.759241] raid6test: test_disks(1, 27): faila=3D  1(D)  failb=3D 27(D)=
  OK
[    5.761985] raid6test: test_disks(1, 28): faila=3D  1(D)  failb=3D 28(D)=
  OK
[    5.764803] raid6test: test_disks(1, 29): faila=3D  1(D)  failb=3D 29(D)=
  OK
[    5.767588] raid6test: test_disks(1, 30): faila=3D  1(D)  failb=3D 30(D)=
  OK
[    5.770225] raid6test: test_disks(1, 31): faila=3D  1(D)  failb=3D 31(D)=
  OK
[    5.772878] raid6test: test_disks(1, 32): faila=3D  1(D)  failb=3D 32(D)=
  OK
[    5.775689] raid6test: test_disks(1, 33): faila=3D  1(D)  failb=3D 33(D)=
  OK
[    5.778388] raid6test: test_disks(1, 34): faila=3D  1(D)  failb=3D 34(D)=
  OK
[    5.781285] raid6test: test_disks(1, 35): faila=3D  1(D)  failb=3D 35(D)=
  OK
[    5.784091] raid6test: test_disks(1, 36): faila=3D  1(D)  failb=3D 36(D)=
  OK
[    5.786935] raid6test: test_disks(1, 37): faila=3D  1(D)  failb=3D 37(D)=
  OK
[    5.789612] raid6test: test_disks(1, 38): faila=3D  1(D)  failb=3D 38(D)=
  OK
[    5.792302] raid6test: test_disks(1, 39): faila=3D  1(D)  failb=3D 39(D)=
  OK
[    5.794981] raid6test: test_disks(1, 40): faila=3D  1(D)  failb=3D 40(D)=
  OK
[    5.797814] raid6test: test_disks(1, 41): faila=3D  1(D)  failb=3D 41(D)=
  OK
[    5.800596] raid6test: test_disks(1, 42): faila=3D  1(D)  failb=3D 42(D)=
  OK
[    5.803430] raid6test: test_disks(1, 43): faila=3D  1(D)  failb=3D 43(D)=
  OK
[    5.806260] raid6test: test_disks(1, 44): faila=3D  1(D)  failb=3D 44(D)=
  OK
[    5.809071] raid6test: test_disks(1, 45): faila=3D  1(D)  failb=3D 45(D)=
  OK
[    5.811869] raid6test: test_disks(1, 46): faila=3D  1(D)  failb=3D 46(D)=
  OK
[    5.814634] raid6test: test_disks(1, 47): faila=3D  1(D)  failb=3D 47(D)=
  OK
[    5.817460] raid6test: test_disks(1, 48): faila=3D  1(D)  failb=3D 48(D)=
  OK
[    5.820264] raid6test: test_disks(1, 49): faila=3D  1(D)  failb=3D 49(D)=
  OK
[    5.823134] raid6test: test_disks(1, 50): faila=3D  1(D)  failb=3D 50(D)=
  OK
[    5.825866] raid6test: test_disks(1, 51): faila=3D  1(D)  failb=3D 51(D)=
  OK
[    5.828687] raid6test: test_disks(1, 52): faila=3D  1(D)  failb=3D 52(D)=
  OK
[    5.831350] raid6test: test_disks(1, 53): faila=3D  1(D)  failb=3D 53(D)=
  OK
[    5.834206] raid6test: test_disks(1, 54): faila=3D  1(D)  failb=3D 54(D)=
  OK
[    5.837072] raid6test: test_disks(1, 55): faila=3D  1(D)  failb=3D 55(D)=
  OK
[    5.839879] raid6test: test_disks(1, 56): faila=3D  1(D)  failb=3D 56(D)=
  OK
[    5.842731] raid6test: test_disks(1, 57): faila=3D  1(D)  failb=3D 57(D)=
  OK
[    5.845594] raid6test: test_disks(1, 58): faila=3D  1(D)  failb=3D 58(D)=
  OK
[    5.861766] raid6test: test_disks(1, 59): faila=3D  1(D)  failb=3D 59(D)=
  OK
[    5.864827] raid6test: test_disks(1, 60): faila=3D  1(D)  failb=3D 60(D)=
  OK
[    5.867893] raid6test: test_disks(1, 61): faila=3D  1(D)  failb=3D 61(D)=
  OK
[    5.870616] raid6test: test_disks(1, 62): faila=3D  1(D)  failb=3D 62(P)=
  OK
[    5.873318] raid6test: test_disks(1, 63): faila=3D  1(D)  failb=3D 63(Q)=
  OK
[    5.875956] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    5.878562] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    5.881160] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    5.883722] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    5.886339] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    5.889258] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    5.891884] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    5.894678] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[    5.897635] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[    5.900367] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[    5.903168] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[    5.905868] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[    5.908764] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[    5.911589] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[    5.914253] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[    5.916888] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[    5.919575] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[    5.922221] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[    5.924981] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[    5.927713] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(D)=
  OK
[    5.930541] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(D)=
  OK
[    5.933309] raid6test: test_disks(2, 24): faila=3D  2(D)  failb=3D 24(D)=
  OK
[    5.936170] raid6test: test_disks(2, 25): faila=3D  2(D)  failb=3D 25(D)=
  OK
[    5.938872] raid6test: test_disks(2, 26): faila=3D  2(D)  failb=3D 26(D)=
  OK
[    5.941655] raid6test: test_disks(2, 27): faila=3D  2(D)  failb=3D 27(D)=
  OK
[    5.944502] raid6test: test_disks(2, 28): faila=3D  2(D)  failb=3D 28(D)=
  OK
[    5.947322] raid6test: test_disks(2, 29): faila=3D  2(D)  failb=3D 29(D)=
  OK
[    5.950133] raid6test: test_disks(2, 30): faila=3D  2(D)  failb=3D 30(D)=
  OK
[    5.952980] raid6test: test_disks(2, 31): faila=3D  2(D)  failb=3D 31(D)=
  OK
[    5.955868] raid6test: test_disks(2, 32): faila=3D  2(D)  failb=3D 32(D)=
  OK
[    5.958673] raid6test: test_disks(2, 33): faila=3D  2(D)  failb=3D 33(D)=
  OK
[    5.961427] raid6test: test_disks(2, 34): faila=3D  2(D)  failb=3D 34(D)=
  OK
[    5.964185] raid6test: test_disks(2, 35): faila=3D  2(D)  failb=3D 35(D)=
  OK
[    5.966990] raid6test: test_disks(2, 36): faila=3D  2(D)  failb=3D 36(D)=
  OK
[    5.969824] raid6test: test_disks(2, 37): faila=3D  2(D)  failb=3D 37(D)=
  OK
[    5.972500] raid6test: test_disks(2, 38): faila=3D  2(D)  failb=3D 38(D)=
  OK
[    5.975328] raid6test: test_disks(2, 39): faila=3D  2(D)  failb=3D 39(D)=
  OK
[    5.978153] raid6test: test_disks(2, 40): faila=3D  2(D)  failb=3D 40(D)=
  OK
[    5.980949] raid6test: test_disks(2, 41): faila=3D  2(D)  failb=3D 41(D)=
  OK
[    5.983718] raid6test: test_disks(2, 42): faila=3D  2(D)  failb=3D 42(D)=
  OK
[    5.986521] raid6test: test_disks(2, 43): faila=3D  2(D)  failb=3D 43(D)=
  OK
[    5.989291] raid6test: test_disks(2, 44): faila=3D  2(D)  failb=3D 44(D)=
  OK
[    5.992033] raid6test: test_disks(2, 45): faila=3D  2(D)  failb=3D 45(D)=
  OK
[    5.994969] raid6test: test_disks(2, 46): faila=3D  2(D)  failb=3D 46(D)=
  OK
[    5.997481] raid6test: test_disks(2, 47): faila=3D  2(D)  failb=3D 47(D)=
  OK
[    6.000287] raid6test: test_disks(2, 48): faila=3D  2(D)  failb=3D 48(D)=
  OK
[    6.003101] raid6test: test_disks(2, 49): faila=3D  2(D)  failb=3D 49(D)=
  OK
[    6.005755] raid6test: test_disks(2, 50): faila=3D  2(D)  failb=3D 50(D)=
  OK
[    6.008327] raid6test: test_disks(2, 51): faila=3D  2(D)  failb=3D 51(D)=
  OK
[    6.010858] raid6test: test_disks(2, 52): faila=3D  2(D)  failb=3D 52(D)=
  OK
[    6.013419] raid6test: test_disks(2, 53): faila=3D  2(D)  failb=3D 53(D)=
  OK
[    6.015607] raid6test: test_disks(2, 54): faila=3D  2(D)  failb=3D 54(D)=
  OK
[    6.018273] raid6test: test_disks(2, 55): faila=3D  2(D)  failb=3D 55(D)=
  OK
[    6.020919] raid6test: test_disks(2, 56): faila=3D  2(D)  failb=3D 56(D)=
  OK
[    6.023587] raid6test: test_disks(2, 57): faila=3D  2(D)  failb=3D 57(D)=
  OK
[    6.026278] raid6test: test_disks(2, 58): faila=3D  2(D)  failb=3D 58(D)=
  OK
[    6.028954] raid6test: test_disks(2, 59): faila=3D  2(D)  failb=3D 59(D)=
  OK
[    6.031588] raid6test: test_disks(2, 60): faila=3D  2(D)  failb=3D 60(D)=
  OK
[    6.034399] raid6test: test_disks(2, 61): faila=3D  2(D)  failb=3D 61(D)=
  OK
[    6.037270] raid6test: test_disks(2, 62): faila=3D  2(D)  failb=3D 62(P)=
  OK
[    6.040187] raid6test: test_disks(2, 63): faila=3D  2(D)  failb=3D 63(Q)=
  OK
[    6.043075] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    6.045947] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    6.048800] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    6.051610] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    6.054435] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    6.057307] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    6.060183] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[    6.062882] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[    6.065387] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[    6.067937] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[    6.070586] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[    6.073388] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[    6.076201] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[    6.078921] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[    6.081678] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[    6.084266] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[    6.086731] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[    6.089434] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[    6.092256] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(D)=
  OK
[    6.095072] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(D)=
  OK
[    6.097973] raid6test: test_disks(3, 24): faila=3D  3(D)  failb=3D 24(D)=
  OK
[    6.100877] raid6test: test_disks(3, 25): faila=3D  3(D)  failb=3D 25(D)=
  OK
[    6.103772] raid6test: test_disks(3, 26): faila=3D  3(D)  failb=3D 26(D)=
  OK
[    6.106655] raid6test: test_disks(3, 27): faila=3D  3(D)  failb=3D 27(D)=
  OK
[    6.109609] raid6test: test_disks(3, 28): faila=3D  3(D)  failb=3D 28(D)=
  OK
[    6.112519] raid6test: test_disks(3, 29): faila=3D  3(D)  failb=3D 29(D)=
  OK
[    6.115425] raid6test: test_disks(3, 30): faila=3D  3(D)  failb=3D 30(D)=
  OK
[    6.118359] raid6test: test_disks(3, 31): faila=3D  3(D)  failb=3D 31(D)=
  OK
[    6.121305] raid6test: test_disks(3, 32): faila=3D  3(D)  failb=3D 32(D)=
  OK
[    6.123674] raid6test: test_disks(3, 33): faila=3D  3(D)  failb=3D 33(D)=
  OK
[    6.126516] raid6test: test_disks(3, 34): faila=3D  3(D)  failb=3D 34(D)=
  OK
[    6.129430] raid6test: test_disks(3, 35): faila=3D  3(D)  failb=3D 35(D)=
  OK
[    6.132257] raid6test: test_disks(3, 36): faila=3D  3(D)  failb=3D 36(D)=
  OK
[    6.135207] raid6test: test_disks(3, 37): faila=3D  3(D)  failb=3D 37(D)=
  OK
[    6.138115] raid6test: test_disks(3, 38): faila=3D  3(D)  failb=3D 38(D)=
  OK
[    6.141012] raid6test: test_disks(3, 39): faila=3D  3(D)  failb=3D 39(D)=
  OK
[    6.143894] raid6test: test_disks(3, 40): faila=3D  3(D)  failb=3D 40(D)=
  OK
[    6.146802] raid6test: test_disks(3, 41): faila=3D  3(D)  failb=3D 41(D)=
  OK
[    6.149637] raid6test: test_disks(3, 42): faila=3D  3(D)  failb=3D 42(D)=
  OK
[    6.152569] raid6test: test_disks(3, 43): faila=3D  3(D)  failb=3D 43(D)=
  OK
[    6.155502] raid6test: test_disks(3, 44): faila=3D  3(D)  failb=3D 44(D)=
  OK
[    6.158356] raid6test: test_disks(3, 45): faila=3D  3(D)  failb=3D 45(D)=
  OK
[    6.161260] raid6test: test_disks(3, 46): faila=3D  3(D)  failb=3D 46(D)=
  OK
[    6.164186] raid6test: test_disks(3, 47): faila=3D  3(D)  failb=3D 47(D)=
  OK
[    6.166883] raid6test: test_disks(3, 48): faila=3D  3(D)  failb=3D 48(D)=
  OK
[    6.169792] raid6test: test_disks(3, 49): faila=3D  3(D)  failb=3D 49(D)=
  OK
[    6.172718] raid6test: test_disks(3, 50): faila=3D  3(D)  failb=3D 50(D)=
  OK
[    6.175648] raid6test: test_disks(3, 51): faila=3D  3(D)  failb=3D 51(D)=
  OK
[    6.178559] raid6test: test_disks(3, 52): faila=3D  3(D)  failb=3D 52(D)=
  OK
[    6.181465] raid6test: test_disks(3, 53): faila=3D  3(D)  failb=3D 53(D)=
  OK
[    6.184337] raid6test: test_disks(3, 54): faila=3D  3(D)  failb=3D 54(D)=
  OK
[    6.187296] raid6test: test_disks(3, 55): faila=3D  3(D)  failb=3D 55(D)=
  OK
[    6.190212] raid6test: test_disks(3, 56): faila=3D  3(D)  failb=3D 56(D)=
  OK
[    6.193152] raid6test: test_disks(3, 57): faila=3D  3(D)  failb=3D 57(D)=
  OK
[    6.196053] raid6test: test_disks(3, 58): faila=3D  3(D)  failb=3D 58(D)=
  OK
[    6.198849] raid6test: test_disks(3, 59): faila=3D  3(D)  failb=3D 59(D)=
  OK
[    6.201735] raid6test: test_disks(3, 60): faila=3D  3(D)  failb=3D 60(D)=
  OK
[    6.204667] raid6test: test_disks(3, 61): faila=3D  3(D)  failb=3D 61(D)=
  OK
[    6.207590] raid6test: test_disks(3, 62): faila=3D  3(D)  failb=3D 62(P)=
  OK
[    6.210371] raid6test: test_disks(3, 63): faila=3D  3(D)  failb=3D 63(Q)=
  OK
[    6.213277] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    6.216231] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    6.219142] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    6.221983] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    6.224905] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    6.227846] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[    6.230752] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[    6.233635] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[    6.236597] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[    6.239531] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[    6.242392] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[    6.245321] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[    6.248276] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[    6.251222] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[    6.254149] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[    6.257072] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[    6.259953] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[    6.262817] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(D)=
  OK
[    6.265739] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(D)=
  OK
[    6.268666] raid6test: test_disks(4, 24): faila=3D  4(D)  failb=3D 24(D)=
  OK
[    6.271589] raid6test: test_disks(4, 25): faila=3D  4(D)  failb=3D 25(D)=
  OK
[    6.274497] raid6test: test_disks(4, 26): faila=3D  4(D)  failb=3D 26(D)=
  OK
[    6.277406] raid6test: test_disks(4, 27): faila=3D  4(D)  failb=3D 27(D)=
  OK
[    6.280295] raid6test: test_disks(4, 28): faila=3D  4(D)  failb=3D 28(D)=
  OK
[    6.283222] raid6test: test_disks(4, 29): faila=3D  4(D)  failb=3D 29(D)=
  OK
[    6.286191] raid6test: test_disks(4, 30): faila=3D  4(D)  failb=3D 30(D)=
  OK
[    6.289101] raid6test: test_disks(4, 31): faila=3D  4(D)  failb=3D 31(D)=
  OK
[    6.291992] raid6test: test_disks(4, 32): faila=3D  4(D)  failb=3D 32(D)=
  OK
[    6.294923] raid6test: test_disks(4, 33): faila=3D  4(D)  failb=3D 33(D)=
  OK
[    6.297860] raid6test: test_disks(4, 34): faila=3D  4(D)  failb=3D 34(D)=
  OK
[    6.300726] raid6test: test_disks(4, 35): faila=3D  4(D)  failb=3D 35(D)=
  OK
[    6.303619] raid6test: test_disks(4, 36): faila=3D  4(D)  failb=3D 36(D)=
  OK
[    6.306548] raid6test: test_disks(4, 37): faila=3D  4(D)  failb=3D 37(D)=
  OK
[    6.309487] raid6test: test_disks(4, 38): faila=3D  4(D)  failb=3D 38(D)=
  OK
[    6.312380] raid6test: test_disks(4, 39): faila=3D  4(D)  failb=3D 39(D)=
  OK
[    6.315304] raid6test: test_disks(4, 40): faila=3D  4(D)  failb=3D 40(D)=
  OK
[    6.318234] raid6test: test_disks(4, 41): faila=3D  4(D)  failb=3D 41(D)=
  OK
[    6.321150] raid6test: test_disks(4, 42): faila=3D  4(D)  failb=3D 42(D)=
  OK
[    6.324069] raid6test: test_disks(4, 43): faila=3D  4(D)  failb=3D 43(D)=
  OK
[    6.327001] raid6test: test_disks(4, 44): faila=3D  4(D)  failb=3D 44(D)=
  OK
[    6.329969] raid6test: test_disks(4, 45): faila=3D  4(D)  failb=3D 45(D)=
  OK
[    6.332846] raid6test: test_disks(4, 46): faila=3D  4(D)  failb=3D 46(D)=
  OK
[    6.335764] raid6test: test_disks(4, 47): faila=3D  4(D)  failb=3D 47(D)=
  OK
[    6.338674] raid6test: test_disks(4, 48): faila=3D  4(D)  failb=3D 48(D)=
  OK
[    6.341586] raid6test: test_disks(4, 49): faila=3D  4(D)  failb=3D 49(D)=
  OK
[    6.344449] raid6test: test_disks(4, 50): faila=3D  4(D)  failb=3D 50(D)=
  OK
[    6.347343] raid6test: test_disks(4, 51): faila=3D  4(D)  failb=3D 51(D)=
  OK
[    6.350280] raid6test: test_disks(4, 52): faila=3D  4(D)  failb=3D 52(D)=
  OK
[    6.353191] raid6test: test_disks(4, 53): faila=3D  4(D)  failb=3D 53(D)=
  OK
[    6.356126] raid6test: test_disks(4, 54): faila=3D  4(D)  failb=3D 54(D)=
  OK
[    6.359047] raid6test: test_disks(4, 55): faila=3D  4(D)  failb=3D 55(D)=
  OK
[    6.361967] raid6test: test_disks(4, 56): faila=3D  4(D)  failb=3D 56(D)=
  OK
[    6.364898] raid6test: test_disks(4, 57): faila=3D  4(D)  failb=3D 57(D)=
  OK
[    6.367874] raid6test: test_disks(4, 58): faila=3D  4(D)  failb=3D 58(D)=
  OK
[    6.385202] raid6test: test_disks(4, 59): faila=3D  4(D)  failb=3D 59(D)=
  OK
[    6.388178] raid6test: test_disks(4, 60): faila=3D  4(D)  failb=3D 60(D)=
  OK
[    6.391152] raid6test: test_disks(4, 61): faila=3D  4(D)  failb=3D 61(D)=
  OK
[    6.393992] raid6test: test_disks(4, 62): faila=3D  4(D)  failb=3D 62(P)=
  OK
[    6.396792] raid6test: test_disks(4, 63): faila=3D  4(D)  failb=3D 63(Q)=
  OK
[    6.399659] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    6.402533] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    6.405395] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    6.408297] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    6.411266] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[    6.414162] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[    6.417083] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[    6.419991] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[    6.422936] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[    6.425902] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[    6.428832] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[    6.431729] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[    6.434637] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[    6.437639] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[    6.440512] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[    6.443437] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[    6.446346] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(D)=
  OK
[    6.449257] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(D)=
  OK
[    6.452183] raid6test: test_disks(5, 24): faila=3D  5(D)  failb=3D 24(D)=
  OK
[    6.455155] raid6test: test_disks(5, 25): faila=3D  5(D)  failb=3D 25(D)=
  OK
[    6.458071] raid6test: test_disks(5, 26): faila=3D  5(D)  failb=3D 26(D)=
  OK
[    6.460990] raid6test: test_disks(5, 27): faila=3D  5(D)  failb=3D 27(D)=
  OK
[    6.463892] raid6test: test_disks(5, 28): faila=3D  5(D)  failb=3D 28(D)=
  OK
[    6.466816] raid6test: test_disks(5, 29): faila=3D  5(D)  failb=3D 29(D)=
  OK
[    6.469717] raid6test: test_disks(5, 30): faila=3D  5(D)  failb=3D 30(D)=
  OK
[    6.472607] raid6test: test_disks(5, 31): faila=3D  5(D)  failb=3D 31(D)=
  OK
[    6.475142] raid6test: test_disks(5, 32): faila=3D  5(D)  failb=3D 32(D)=
  OK
[    6.477561] raid6test: test_disks(5, 33): faila=3D  5(D)  failb=3D 33(D)=
  OK
[    6.479970] raid6test: test_disks(5, 34): faila=3D  5(D)  failb=3D 34(D)=
  OK
[    6.482800] raid6test: test_disks(5, 35): faila=3D  5(D)  failb=3D 35(D)=
  OK
[    6.485662] raid6test: test_disks(5, 36): faila=3D  5(D)  failb=3D 36(D)=
  OK
[    6.488514] raid6test: test_disks(5, 37): faila=3D  5(D)  failb=3D 37(D)=
  OK
[    6.491339] raid6test: test_disks(5, 38): faila=3D  5(D)  failb=3D 38(D)=
  OK
[    6.494199] raid6test: test_disks(5, 39): faila=3D  5(D)  failb=3D 39(D)=
  OK
[    6.497104] raid6test: test_disks(5, 40): faila=3D  5(D)  failb=3D 40(D)=
  OK
[    6.499595] raid6test: test_disks(5, 41): faila=3D  5(D)  failb=3D 41(D)=
  OK
[    6.502153] raid6test: test_disks(5, 42): faila=3D  5(D)  failb=3D 42(D)=
  OK
[    6.504930] raid6test: test_disks(5, 43): faila=3D  5(D)  failb=3D 43(D)=
  OK
[    6.507761] raid6test: test_disks(5, 44): faila=3D  5(D)  failb=3D 44(D)=
  OK
[    6.510530] raid6test: test_disks(5, 45): faila=3D  5(D)  failb=3D 45(D)=
  OK
[    6.513309] raid6test: test_disks(5, 46): faila=3D  5(D)  failb=3D 46(D)=
  OK
[    6.516118] raid6test: test_disks(5, 47): faila=3D  5(D)  failb=3D 47(D)=
  OK
[    6.518884] raid6test: test_disks(5, 48): faila=3D  5(D)  failb=3D 48(D)=
  OK
[    6.521669] raid6test: test_disks(5, 49): faila=3D  5(D)  failb=3D 49(D)=
  OK
[    6.524439] raid6test: test_disks(5, 50): faila=3D  5(D)  failb=3D 50(D)=
  OK
[    6.527230] raid6test: test_disks(5, 51): faila=3D  5(D)  failb=3D 51(D)=
  OK
[    6.529996] raid6test: test_disks(5, 52): faila=3D  5(D)  failb=3D 52(D)=
  OK
[    6.532792] raid6test: test_disks(5, 53): faila=3D  5(D)  failb=3D 53(D)=
  OK
[    6.535583] raid6test: test_disks(5, 54): faila=3D  5(D)  failb=3D 54(D)=
  OK
[    6.538304] raid6test: test_disks(5, 55): faila=3D  5(D)  failb=3D 55(D)=
  OK
[    6.541074] raid6test: test_disks(5, 56): faila=3D  5(D)  failb=3D 56(D)=
  OK
[    6.543828] raid6test: test_disks(5, 57): faila=3D  5(D)  failb=3D 57(D)=
  OK
[    6.546626] raid6test: test_disks(5, 58): faila=3D  5(D)  failb=3D 58(D)=
  OK
[    6.549421] raid6test: test_disks(5, 59): faila=3D  5(D)  failb=3D 59(D)=
  OK
[    6.552215] raid6test: test_disks(5, 60): faila=3D  5(D)  failb=3D 60(D)=
  OK
[    6.554967] raid6test: test_disks(5, 61): faila=3D  5(D)  failb=3D 61(D)=
  OK
[    6.557737] raid6test: test_disks(5, 62): faila=3D  5(D)  failb=3D 62(P)=
  OK
[    6.560459] raid6test: test_disks(5, 63): faila=3D  5(D)  failb=3D 63(Q)=
  OK
[    6.563208] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    6.565902] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    6.568552] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    6.571171] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[    6.573837] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[    6.576489] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[    6.579207] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[    6.581873] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[    6.584517] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[    6.587299] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[    6.590049] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[    6.592768] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[    6.595566] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[    6.598358] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[    6.601156] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[    6.603924] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(D)=
  OK
[    6.606729] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(D)=
  OK
[    6.609500] raid6test: test_disks(6, 24): faila=3D  6(D)  failb=3D 24(D)=
  OK
[    6.612284] raid6test: test_disks(6, 25): faila=3D  6(D)  failb=3D 25(D)=
  OK
[    6.615151] raid6test: test_disks(6, 26): faila=3D  6(D)  failb=3D 26(D)=
  OK
[    6.617897] raid6test: test_disks(6, 27): faila=3D  6(D)  failb=3D 27(D)=
  OK
[    6.620684] raid6test: test_disks(6, 28): faila=3D  6(D)  failb=3D 28(D)=
  OK
[    6.623473] raid6test: test_disks(6, 29): faila=3D  6(D)  failb=3D 29(D)=
  OK
[    6.626267] raid6test: test_disks(6, 30): faila=3D  6(D)  failb=3D 30(D)=
  OK
[    6.629054] raid6test: test_disks(6, 31): faila=3D  6(D)  failb=3D 31(D)=
  OK
[    6.631824] raid6test: test_disks(6, 32): faila=3D  6(D)  failb=3D 32(D)=
  OK
[    6.634637] raid6test: test_disks(6, 33): faila=3D  6(D)  failb=3D 33(D)=
  OK
[    6.637424] raid6test: test_disks(6, 34): faila=3D  6(D)  failb=3D 34(D)=
  OK
[    6.640218] raid6test: test_disks(6, 35): faila=3D  6(D)  failb=3D 35(D)=
  OK
[    6.643038] raid6test: test_disks(6, 36): faila=3D  6(D)  failb=3D 36(D)=
  OK
[    6.645893] raid6test: test_disks(6, 37): faila=3D  6(D)  failb=3D 37(D)=
  OK
[    6.648676] raid6test: test_disks(6, 38): faila=3D  6(D)  failb=3D 38(D)=
  OK
[    6.651420] raid6test: test_disks(6, 39): faila=3D  6(D)  failb=3D 39(D)=
  OK
[    6.654210] raid6test: test_disks(6, 40): faila=3D  6(D)  failb=3D 40(D)=
  OK
[    6.657101] raid6test: test_disks(6, 41): faila=3D  6(D)  failb=3D 41(D)=
  OK
[    6.659810] raid6test: test_disks(6, 42): faila=3D  6(D)  failb=3D 42(D)=
  OK
[    6.662553] raid6test: test_disks(6, 43): faila=3D  6(D)  failb=3D 43(D)=
  OK
[    6.665374] raid6test: test_disks(6, 44): faila=3D  6(D)  failb=3D 44(D)=
  OK
[    6.668237] raid6test: test_disks(6, 45): faila=3D  6(D)  failb=3D 45(D)=
  OK
[    6.670984] raid6test: test_disks(6, 46): faila=3D  6(D)  failb=3D 46(D)=
  OK
[    6.673763] raid6test: test_disks(6, 47): faila=3D  6(D)  failb=3D 47(D)=
  OK
[    6.676593] raid6test: test_disks(6, 48): faila=3D  6(D)  failb=3D 48(D)=
  OK
[    6.679379] raid6test: test_disks(6, 49): faila=3D  6(D)  failb=3D 49(D)=
  OK
[    6.682159] raid6test: test_disks(6, 50): faila=3D  6(D)  failb=3D 50(D)=
  OK
[    6.684968] raid6test: test_disks(6, 51): faila=3D  6(D)  failb=3D 51(D)=
  OK
[    6.687807] raid6test: test_disks(6, 52): faila=3D  6(D)  failb=3D 52(D)=
  OK
[    6.690616] raid6test: test_disks(6, 53): faila=3D  6(D)  failb=3D 53(D)=
  OK
[    6.693473] raid6test: test_disks(6, 54): faila=3D  6(D)  failb=3D 54(D)=
  OK
[    6.696234] raid6test: test_disks(6, 55): faila=3D  6(D)  failb=3D 55(D)=
  OK
[    6.699066] raid6test: test_disks(6, 56): faila=3D  6(D)  failb=3D 56(D)=
  OK
[    6.701790] raid6test: test_disks(6, 57): faila=3D  6(D)  failb=3D 57(D)=
  OK
[    6.704615] raid6test: test_disks(6, 58): faila=3D  6(D)  failb=3D 58(D)=
  OK
[    6.707444] raid6test: test_disks(6, 59): faila=3D  6(D)  failb=3D 59(D)=
  OK
[    6.710263] raid6test: test_disks(6, 60): faila=3D  6(D)  failb=3D 60(D)=
  OK
[    6.713106] raid6test: test_disks(6, 61): faila=3D  6(D)  failb=3D 61(D)=
  OK
[    6.715901] raid6test: test_disks(6, 62): faila=3D  6(D)  failb=3D 62(P)=
  OK
[    6.718721] raid6test: test_disks(6, 63): faila=3D  6(D)  failb=3D 63(Q)=
  OK
[    6.721570] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    6.724302] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    6.727094] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[    6.729810] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[    6.732641] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[    6.735442] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[    6.738274] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[    6.741044] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[    6.743760] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[    6.746617] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[    6.749376] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[    6.752195] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[    6.754959] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[    6.757825] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[    6.760586] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(D)=
  OK
[    6.763346] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(D)=
  OK
[    6.766250] raid6test: test_disks(7, 24): faila=3D  7(D)  failb=3D 24(D)=
  OK
[    6.769105] raid6test: test_disks(7, 25): faila=3D  7(D)  failb=3D 25(D)=
  OK
[    6.771834] raid6test: test_disks(7, 26): faila=3D  7(D)  failb=3D 26(D)=
  OK
[    6.774590] raid6test: test_disks(7, 27): faila=3D  7(D)  failb=3D 27(D)=
  OK
[    6.777491] raid6test: test_disks(7, 28): faila=3D  7(D)  failb=3D 28(D)=
  OK
[    6.780185] raid6test: test_disks(7, 29): faila=3D  7(D)  failb=3D 29(D)=
  OK
[    6.782873] raid6test: test_disks(7, 30): faila=3D  7(D)  failb=3D 30(D)=
  OK
[    6.785717] raid6test: test_disks(7, 31): faila=3D  7(D)  failb=3D 31(D)=
  OK
[    6.788587] raid6test: test_disks(7, 32): faila=3D  7(D)  failb=3D 32(D)=
  OK
[    6.791453] raid6test: test_disks(7, 33): faila=3D  7(D)  failb=3D 33(D)=
  OK
[    6.794157] raid6test: test_disks(7, 34): faila=3D  7(D)  failb=3D 34(D)=
  OK
[    6.796852] raid6test: test_disks(7, 35): faila=3D  7(D)  failb=3D 35(D)=
  OK
[    6.799690] raid6test: test_disks(7, 36): faila=3D  7(D)  failb=3D 36(D)=
  OK
[    6.802472] raid6test: test_disks(7, 37): faila=3D  7(D)  failb=3D 37(D)=
  OK
[    6.805340] raid6test: test_disks(7, 38): faila=3D  7(D)  failb=3D 38(D)=
  OK
[    6.808189] raid6test: test_disks(7, 39): faila=3D  7(D)  failb=3D 39(D)=
  OK
[    6.810967] raid6test: test_disks(7, 40): faila=3D  7(D)  failb=3D 40(D)=
  OK
[    6.813842] raid6test: test_disks(7, 41): faila=3D  7(D)  failb=3D 41(D)=
  OK
[    6.816627] raid6test: test_disks(7, 42): faila=3D  7(D)  failb=3D 42(D)=
  OK
[    6.819459] raid6test: test_disks(7, 43): faila=3D  7(D)  failb=3D 43(D)=
  OK
[    6.822277] raid6test: test_disks(7, 44): faila=3D  7(D)  failb=3D 44(D)=
  OK
[    6.825209] raid6test: test_disks(7, 45): faila=3D  7(D)  failb=3D 45(D)=
  OK
[    6.827857] raid6test: test_disks(7, 46): faila=3D  7(D)  failb=3D 46(D)=
  OK
[    6.830507] raid6test: test_disks(7, 47): faila=3D  7(D)  failb=3D 47(D)=
  OK
[    6.833333] raid6test: test_disks(7, 48): faila=3D  7(D)  failb=3D 48(D)=
  OK
[    6.836173] raid6test: test_disks(7, 49): faila=3D  7(D)  failb=3D 49(D)=
  OK
[    6.839099] raid6test: test_disks(7, 50): faila=3D  7(D)  failb=3D 50(D)=
  OK
[    6.841933] raid6test: test_disks(7, 51): faila=3D  7(D)  failb=3D 51(D)=
  OK
[    6.844712] raid6test: test_disks(7, 52): faila=3D  7(D)  failb=3D 52(D)=
  OK
[    6.847373] raid6test: test_disks(7, 53): faila=3D  7(D)  failb=3D 53(D)=
  OK
[    6.850156] raid6test: test_disks(7, 54): faila=3D  7(D)  failb=3D 54(D)=
  OK
[    6.852982] raid6test: test_disks(7, 55): faila=3D  7(D)  failb=3D 55(D)=
  OK
[    6.855766] raid6test: test_disks(7, 56): faila=3D  7(D)  failb=3D 56(D)=
  OK
[    6.858632] raid6test: test_disks(7, 57): faila=3D  7(D)  failb=3D 57(D)=
  OK
[    6.861376] raid6test: test_disks(7, 58): faila=3D  7(D)  failb=3D 58(D)=
  OK
[    6.864204] raid6test: test_disks(7, 59): faila=3D  7(D)  failb=3D 59(D)=
  OK
[    6.866997] raid6test: test_disks(7, 60): faila=3D  7(D)  failb=3D 60(D)=
  OK
[    6.869698] raid6test: test_disks(7, 61): faila=3D  7(D)  failb=3D 61(D)=
  OK
[    6.872535] raid6test: test_disks(7, 62): faila=3D  7(D)  failb=3D 62(P)=
  OK
[    6.875329] raid6test: test_disks(7, 63): faila=3D  7(D)  failb=3D 63(Q)=
  OK
[    6.878152] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    6.880898] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[    6.883681] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[    6.886503] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[    6.902974] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[    6.905835] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[    6.908671] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[    6.911422] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[    6.914264] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[    6.917121] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[    6.919938] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[    6.922809] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[    6.925605] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[    6.928387] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(D)=
  OK
[    6.931181] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(D)=
  OK
[    6.934067] raid6test: test_disks(8, 24): faila=3D  8(D)  failb=3D 24(D)=
  OK
[    6.936815] raid6test: test_disks(8, 25): faila=3D  8(D)  failb=3D 25(D)=
  OK
[    6.939579] raid6test: test_disks(8, 26): faila=3D  8(D)  failb=3D 26(D)=
  OK
[    6.942389] raid6test: test_disks(8, 27): faila=3D  8(D)  failb=3D 27(D)=
  OK
[    6.945088] raid6test: test_disks(8, 28): faila=3D  8(D)  failb=3D 28(D)=
  OK
[    6.947897] raid6test: test_disks(8, 29): faila=3D  8(D)  failb=3D 29(D)=
  OK
[    6.950700] raid6test: test_disks(8, 30): faila=3D  8(D)  failb=3D 30(D)=
  OK
[    6.953465] raid6test: test_disks(8, 31): faila=3D  8(D)  failb=3D 31(D)=
  OK
[    6.956388] raid6test: test_disks(8, 32): faila=3D  8(D)  failb=3D 32(D)=
  OK
[    6.959132] raid6test: test_disks(8, 33): faila=3D  8(D)  failb=3D 33(D)=
  OK
[    6.961886] raid6test: test_disks(8, 34): faila=3D  8(D)  failb=3D 34(D)=
  OK
[    6.964807] raid6test: test_disks(8, 35): faila=3D  8(D)  failb=3D 35(D)=
  OK
[    6.967502] raid6test: test_disks(8, 36): faila=3D  8(D)  failb=3D 36(D)=
  OK
[    6.970272] raid6test: test_disks(8, 37): faila=3D  8(D)  failb=3D 37(D)=
  OK
[    6.973266] raid6test: test_disks(8, 38): faila=3D  8(D)  failb=3D 38(D)=
  OK
[    6.976049] raid6test: test_disks(8, 39): faila=3D  8(D)  failb=3D 39(D)=
  OK
[    6.978695] raid6test: test_disks(8, 40): faila=3D  8(D)  failb=3D 40(D)=
  OK
[    6.981316] raid6test: test_disks(8, 41): faila=3D  8(D)  failb=3D 41(D)=
  OK
[    6.983944] raid6test: test_disks(8, 42): faila=3D  8(D)  failb=3D 42(D)=
  OK
[    6.986623] raid6test: test_disks(8, 43): faila=3D  8(D)  failb=3D 43(D)=
  OK
[    6.989250] raid6test: test_disks(8, 44): faila=3D  8(D)  failb=3D 44(D)=
  OK
[    6.992135] raid6test: test_disks(8, 45): faila=3D  8(D)  failb=3D 45(D)=
  OK
[    6.994750] raid6test: test_disks(8, 46): faila=3D  8(D)  failb=3D 46(D)=
  OK
[    6.997707] raid6test: test_disks(8, 47): faila=3D  8(D)  failb=3D 47(D)=
  OK
[    7.000504] raid6test: test_disks(8, 48): faila=3D  8(D)  failb=3D 48(D)=
  OK
[    7.003254] raid6test: test_disks(8, 49): faila=3D  8(D)  failb=3D 49(D)=
  OK
[    7.006213] raid6test: test_disks(8, 50): faila=3D  8(D)  failb=3D 50(D)=
  OK
[    7.009124] raid6test: test_disks(8, 51): faila=3D  8(D)  failb=3D 51(D)=
  OK
[    7.011759] raid6test: test_disks(8, 52): faila=3D  8(D)  failb=3D 52(D)=
  OK
[    7.014395] raid6test: test_disks(8, 53): faila=3D  8(D)  failb=3D 53(D)=
  OK
[    7.017098] raid6test: test_disks(8, 54): faila=3D  8(D)  failb=3D 54(D)=
  OK
[    7.019822] raid6test: test_disks(8, 55): faila=3D  8(D)  failb=3D 55(D)=
  OK
[    7.022607] raid6test: test_disks(8, 56): faila=3D  8(D)  failb=3D 56(D)=
  OK
[    7.025452] raid6test: test_disks(8, 57): faila=3D  8(D)  failb=3D 57(D)=
  OK
[    7.028250] raid6test: test_disks(8, 58): faila=3D  8(D)  failb=3D 58(D)=
  OK
[    7.030953] raid6test: test_disks(8, 59): faila=3D  8(D)  failb=3D 59(D)=
  OK
[    7.033815] raid6test: test_disks(8, 60): faila=3D  8(D)  failb=3D 60(D)=
  OK
[    7.036708] raid6test: test_disks(8, 61): faila=3D  8(D)  failb=3D 61(D)=
  OK
[    7.039522] raid6test: test_disks(8, 62): faila=3D  8(D)  failb=3D 62(P)=
  OK
[    7.042276] raid6test: test_disks(8, 63): faila=3D  8(D)  failb=3D 63(Q)=
  OK
[    7.045170] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[    7.048015] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[    7.050874] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[    7.053692] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[    7.056589] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[    7.059308] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[    7.062131] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[    7.064863] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[    7.067723] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[    7.070489] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[    7.073096] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[    7.075962] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[    7.079000] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(D)=
  OK
[    7.081709] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(D)=
  OK
[    7.084506] raid6test: test_disks(9, 24): faila=3D  9(D)  failb=3D 24(D)=
  OK
[    7.087273] raid6test: test_disks(9, 25): faila=3D  9(D)  failb=3D 25(D)=
  OK
[    7.089900] raid6test: test_disks(9, 26): faila=3D  9(D)  failb=3D 26(D)=
  OK
[    7.092487] raid6test: test_disks(9, 27): faila=3D  9(D)  failb=3D 27(D)=
  OK
[    7.095245] raid6test: test_disks(9, 28): faila=3D  9(D)  failb=3D 28(D)=
  OK
[    7.097919] raid6test: test_disks(9, 29): faila=3D  9(D)  failb=3D 29(D)=
  OK
[    7.100636] raid6test: test_disks(9, 30): faila=3D  9(D)  failb=3D 30(D)=
  OK
[    7.103253] raid6test: test_disks(9, 31): faila=3D  9(D)  failb=3D 31(D)=
  OK
[    7.105898] raid6test: test_disks(9, 32): faila=3D  9(D)  failb=3D 32(D)=
  OK
[    7.108810] raid6test: test_disks(9, 33): faila=3D  9(D)  failb=3D 33(D)=
  OK
[    7.111480] raid6test: test_disks(9, 34): faila=3D  9(D)  failb=3D 34(D)=
  OK
[    7.114267] raid6test: test_disks(9, 35): faila=3D  9(D)  failb=3D 35(D)=
  OK
[    7.117308] raid6test: test_disks(9, 36): faila=3D  9(D)  failb=3D 36(D)=
  OK
[    7.120109] raid6test: test_disks(9, 37): faila=3D  9(D)  failb=3D 37(D)=
  OK
[    7.122717] raid6test: test_disks(9, 38): faila=3D  9(D)  failb=3D 38(D)=
  OK
[    7.125619] raid6test: test_disks(9, 39): faila=3D  9(D)  failb=3D 39(D)=
  OK
[    7.128533] raid6test: test_disks(9, 40): faila=3D  9(D)  failb=3D 40(D)=
  OK
[    7.131437] raid6test: test_disks(9, 41): faila=3D  9(D)  failb=3D 41(D)=
  OK
[    7.134106] raid6test: test_disks(9, 42): faila=3D  9(D)  failb=3D 42(D)=
  OK
[    7.136756] raid6test: test_disks(9, 43): faila=3D  9(D)  failb=3D 43(D)=
  OK
[    7.139499] raid6test: test_disks(9, 44): faila=3D  9(D)  failb=3D 44(D)=
  OK
[    7.142198] raid6test: test_disks(9, 45): faila=3D  9(D)  failb=3D 45(D)=
  OK
[    7.144788] raid6test: test_disks(9, 46): faila=3D  9(D)  failb=3D 46(D)=
  OK
[    7.147667] raid6test: test_disks(9, 47): faila=3D  9(D)  failb=3D 47(D)=
  OK
[    7.150563] raid6test: test_disks(9, 48): faila=3D  9(D)  failb=3D 48(D)=
  OK
[    7.153290] raid6test: test_disks(9, 49): faila=3D  9(D)  failb=3D 49(D)=
  OK
[    7.156063] raid6test: test_disks(9, 50): faila=3D  9(D)  failb=3D 50(D)=
  OK
[    7.158745] raid6test: test_disks(9, 51): faila=3D  9(D)  failb=3D 51(D)=
  OK
[    7.161611] raid6test: test_disks(9, 52): faila=3D  9(D)  failb=3D 52(D)=
  OK
[    7.164460] raid6test: test_disks(9, 53): faila=3D  9(D)  failb=3D 53(D)=
  OK
[    7.167277] raid6test: test_disks(9, 54): faila=3D  9(D)  failb=3D 54(D)=
  OK
[    7.170094] raid6test: test_disks(9, 55): faila=3D  9(D)  failb=3D 55(D)=
  OK
[    7.172898] raid6test: test_disks(9, 56): faila=3D  9(D)  failb=3D 56(D)=
  OK
[    7.175748] raid6test: test_disks(9, 57): faila=3D  9(D)  failb=3D 57(D)=
  OK
[    7.178376] raid6test: test_disks(9, 58): faila=3D  9(D)  failb=3D 58(D)=
  OK
[    7.181238] raid6test: test_disks(9, 59): faila=3D  9(D)  failb=3D 59(D)=
  OK
[    7.184015] raid6test: test_disks(9, 60): faila=3D  9(D)  failb=3D 60(D)=
  OK
[    7.186563] raid6test: test_disks(9, 61): faila=3D  9(D)  failb=3D 61(D)=
  OK
[    7.188868] raid6test: test_disks(9, 62): faila=3D  9(D)  failb=3D 62(P)=
  OK
[    7.191301] raid6test: test_disks(9, 63): faila=3D  9(D)  failb=3D 63(Q)=
  OK
[    7.193707] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[    7.196489] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[    7.199159] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[    7.201860] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[    7.204642] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[    7.207570] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[    7.210497] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[    7.213348] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[    7.216215] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[    7.219157] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[    7.221826] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[    7.224571] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(D=
)  OK
[    7.227481] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(D=
)  OK
[    7.230414] raid6test: test_disks(10, 24): faila=3D 10(D)  failb=3D 24(D=
)  OK
[    7.233195] raid6test: test_disks(10, 25): faila=3D 10(D)  failb=3D 25(D=
)  OK
[    7.236003] raid6test: test_disks(10, 26): faila=3D 10(D)  failb=3D 26(D=
)  OK
[    7.238887] raid6test: test_disks(10, 27): faila=3D 10(D)  failb=3D 27(D=
)  OK
[    7.241689] raid6test: test_disks(10, 28): faila=3D 10(D)  failb=3D 28(D=
)  OK
[    7.244467] raid6test: test_disks(10, 29): faila=3D 10(D)  failb=3D 29(D=
)  OK
[    7.247312] raid6test: test_disks(10, 30): faila=3D 10(D)  failb=3D 30(D=
)  OK
[    7.250132] raid6test: test_disks(10, 31): faila=3D 10(D)  failb=3D 31(D=
)  OK
[    7.252922] raid6test: test_disks(10, 32): faila=3D 10(D)  failb=3D 32(D=
)  OK
[    7.255722] raid6test: test_disks(10, 33): faila=3D 10(D)  failb=3D 33(D=
)  OK
[    7.258467] raid6test: test_disks(10, 34): faila=3D 10(D)  failb=3D 34(D=
)  OK
[    7.261321] raid6test: test_disks(10, 35): faila=3D 10(D)  failb=3D 35(D=
)  OK
[    7.264305] raid6test: test_disks(10, 36): faila=3D 10(D)  failb=3D 36(D=
)  OK
[    7.267165] raid6test: test_disks(10, 37): faila=3D 10(D)  failb=3D 37(D=
)  OK
[    7.269908] raid6test: test_disks(10, 38): faila=3D 10(D)  failb=3D 38(D=
)  OK
[    7.272908] raid6test: test_disks(10, 39): faila=3D 10(D)  failb=3D 39(D=
)  OK
[    7.275851] raid6test: test_disks(10, 40): faila=3D 10(D)  failb=3D 40(D=
)  OK
[    7.278573] raid6test: test_disks(10, 41): faila=3D 10(D)  failb=3D 41(D=
)  OK
[    7.281416] raid6test: test_disks(10, 42): faila=3D 10(D)  failb=3D 42(D=
)  OK
[    7.284269] raid6test: test_disks(10, 43): faila=3D 10(D)  failb=3D 43(D=
)  OK
[    7.287102] raid6test: test_disks(10, 44): faila=3D 10(D)  failb=3D 44(D=
)  OK
[    7.289845] raid6test: test_disks(10, 45): faila=3D 10(D)  failb=3D 45(D=
)  OK
[    7.292481] raid6test: test_disks(10, 46): faila=3D 10(D)  failb=3D 46(D=
)  OK
[    7.295408] raid6test: test_disks(10, 47): faila=3D 10(D)  failb=3D 47(D=
)  OK
[    7.298242] raid6test: test_disks(10, 48): faila=3D 10(D)  failb=3D 48(D=
)  OK
[    7.300984] raid6test: test_disks(10, 49): faila=3D 10(D)  failb=3D 49(D=
)  OK
[    7.303622] raid6test: test_disks(10, 50): faila=3D 10(D)  failb=3D 50(D=
)  OK
[    7.306262] raid6test: test_disks(10, 51): faila=3D 10(D)  failb=3D 51(D=
)  OK
[    7.308923] raid6test: test_disks(10, 52): faila=3D 10(D)  failb=3D 52(D=
)  OK
[    7.311786] raid6test: test_disks(10, 53): faila=3D 10(D)  failb=3D 53(D=
)  OK
[    7.314467] raid6test: test_disks(10, 54): faila=3D 10(D)  failb=3D 54(D=
)  OK
[    7.317408] raid6test: test_disks(10, 55): faila=3D 10(D)  failb=3D 55(D=
)  OK
[    7.320204] raid6test: test_disks(10, 56): faila=3D 10(D)  failb=3D 56(D=
)  OK
[    7.322938] raid6test: test_disks(10, 57): faila=3D 10(D)  failb=3D 57(D=
)  OK
[    7.325890] raid6test: test_disks(10, 58): faila=3D 10(D)  failb=3D 58(D=
)  OK
[    7.328564] raid6test: test_disks(10, 59): faila=3D 10(D)  failb=3D 59(D=
)  OK
[    7.331244] raid6test: test_disks(10, 60): faila=3D 10(D)  failb=3D 60(D=
)  OK
[    7.333928] raid6test: test_disks(10, 61): faila=3D 10(D)  failb=3D 61(D=
)  OK
[    7.336587] raid6test: test_disks(10, 62): faila=3D 10(D)  failb=3D 62(P=
)  OK
[    7.339451] raid6test: test_disks(10, 63): faila=3D 10(D)  failb=3D 63(Q=
)  OK
[    7.342247] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[    7.344917] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[    7.347791] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[    7.350567] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[    7.353469] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[    7.356344] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[    7.359036] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[    7.361847] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[    7.364638] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[    7.367432] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[    7.370233] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(D=
)  OK
[    7.372962] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(D=
)  OK
[    7.375631] raid6test: test_disks(11, 24): faila=3D 11(D)  failb=3D 24(D=
)  OK
[    7.378348] raid6test: test_disks(11, 25): faila=3D 11(D)  failb=3D 25(D=
)  OK
[    7.381249] raid6test: test_disks(11, 26): faila=3D 11(D)  failb=3D 26(D=
)  OK
[    7.383838] raid6test: test_disks(11, 27): faila=3D 11(D)  failb=3D 27(D=
)  OK
[    7.386419] raid6test: test_disks(11, 28): faila=3D 11(D)  failb=3D 28(D=
)  OK
[    7.388951] raid6test: test_disks(11, 29): faila=3D 11(D)  failb=3D 29(D=
)  OK
[    7.391579] raid6test: test_disks(11, 30): faila=3D 11(D)  failb=3D 30(D=
)  OK
[    7.394968] raid6test: test_disks(11, 31): faila=3D 11(D)  failb=3D 31(D=
)  OK
[    7.397852] raid6test: test_disks(11, 32): faila=3D 11(D)  failb=3D 32(D=
)  OK
[    7.400602] raid6test: test_disks(11, 33): faila=3D 11(D)  failb=3D 33(D=
)  OK
[    7.417732] raid6test: test_disks(11, 34): faila=3D 11(D)  failb=3D 34(D=
)  OK
[    7.420682] raid6test: test_disks(11, 35): faila=3D 11(D)  failb=3D 35(D=
)  OK
[    7.423555] raid6test: test_disks(11, 36): faila=3D 11(D)  failb=3D 36(D=
)  OK
[    7.426380] raid6test: test_disks(11, 37): faila=3D 11(D)  failb=3D 37(D=
)  OK
[    7.429064] raid6test: test_disks(11, 38): faila=3D 11(D)  failb=3D 38(D=
)  OK
[    7.431864] raid6test: test_disks(11, 39): faila=3D 11(D)  failb=3D 39(D=
)  OK
[    7.434559] raid6test: test_disks(11, 40): faila=3D 11(D)  failb=3D 40(D=
)  OK
[    7.437464] raid6test: test_disks(11, 41): faila=3D 11(D)  failb=3D 41(D=
)  OK
[    7.440350] raid6test: test_disks(11, 42): faila=3D 11(D)  failb=3D 42(D=
)  OK
[    7.442944] raid6test: test_disks(11, 43): faila=3D 11(D)  failb=3D 43(D=
)  OK
[    7.445682] raid6test: test_disks(11, 44): faila=3D 11(D)  failb=3D 44(D=
)  OK
[    7.448288] raid6test: test_disks(11, 45): faila=3D 11(D)  failb=3D 45(D=
)  OK
[    7.451222] raid6test: test_disks(11, 46): faila=3D 11(D)  failb=3D 46(D=
)  OK
[    7.454148] raid6test: test_disks(11, 47): faila=3D 11(D)  failb=3D 47(D=
)  OK
[    7.456960] raid6test: test_disks(11, 48): faila=3D 11(D)  failb=3D 48(D=
)  OK
[    7.459578] raid6test: test_disks(11, 49): faila=3D 11(D)  failb=3D 49(D=
)  OK
[    7.462369] raid6test: test_disks(11, 50): faila=3D 11(D)  failb=3D 50(D=
)  OK
[    7.465169] raid6test: test_disks(11, 51): faila=3D 11(D)  failb=3D 51(D=
)  OK
[    7.468077] raid6test: test_disks(11, 52): faila=3D 11(D)  failb=3D 52(D=
)  OK
[    7.470960] raid6test: test_disks(11, 53): faila=3D 11(D)  failb=3D 53(D=
)  OK
[    7.473857] raid6test: test_disks(11, 54): faila=3D 11(D)  failb=3D 54(D=
)  OK
[    7.476713] raid6test: test_disks(11, 55): faila=3D 11(D)  failb=3D 55(D=
)  OK
[    7.479418] raid6test: test_disks(11, 56): faila=3D 11(D)  failb=3D 56(D=
)  OK
[    7.482331] raid6test: test_disks(11, 57): faila=3D 11(D)  failb=3D 57(D=
)  OK
[    7.485282] raid6test: test_disks(11, 58): faila=3D 11(D)  failb=3D 58(D=
)  OK
[    7.488245] raid6test: test_disks(11, 59): faila=3D 11(D)  failb=3D 59(D=
)  OK
[    7.491215] raid6test: test_disks(11, 60): faila=3D 11(D)  failb=3D 60(D=
)  OK
[    7.494115] raid6test: test_disks(11, 61): faila=3D 11(D)  failb=3D 61(D=
)  OK
[    7.497062] raid6test: test_disks(11, 62): faila=3D 11(D)  failb=3D 62(P=
)  OK
[    7.499973] raid6test: test_disks(11, 63): faila=3D 11(D)  failb=3D 63(Q=
)  OK
[    7.502844] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[    7.505772] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[    7.508712] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[    7.511642] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[    7.514546] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[    7.517526] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[    7.520473] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[    7.523396] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[    7.526354] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[    7.529251] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(D=
)  OK
[    7.532074] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(D=
)  OK
[    7.535047] raid6test: test_disks(12, 24): faila=3D 12(D)  failb=3D 24(D=
)  OK
[    7.537966] raid6test: test_disks(12, 25): faila=3D 12(D)  failb=3D 25(D=
)  OK
[    7.540888] raid6test: test_disks(12, 26): faila=3D 12(D)  failb=3D 26(D=
)  OK
[    7.543816] raid6test: test_disks(12, 27): faila=3D 12(D)  failb=3D 27(D=
)  OK
[    7.546621] raid6test: test_disks(12, 28): faila=3D 12(D)  failb=3D 28(D=
)  OK
[    7.549589] raid6test: test_disks(12, 29): faila=3D 12(D)  failb=3D 29(D=
)  OK
[    7.552511] raid6test: test_disks(12, 30): faila=3D 12(D)  failb=3D 30(D=
)  OK
[    7.555460] raid6test: test_disks(12, 31): faila=3D 12(D)  failb=3D 31(D=
)  OK
[    7.558373] raid6test: test_disks(12, 32): faila=3D 12(D)  failb=3D 32(D=
)  OK
[    7.561273] raid6test: test_disks(12, 33): faila=3D 12(D)  failb=3D 33(D=
)  OK
[    7.564109] raid6test: test_disks(12, 34): faila=3D 12(D)  failb=3D 34(D=
)  OK
[    7.567037] raid6test: test_disks(12, 35): faila=3D 12(D)  failb=3D 35(D=
)  OK
[    7.569918] raid6test: test_disks(12, 36): faila=3D 12(D)  failb=3D 36(D=
)  OK
[    7.572863] raid6test: test_disks(12, 37): faila=3D 12(D)  failb=3D 37(D=
)  OK
[    7.575756] raid6test: test_disks(12, 38): faila=3D 12(D)  failb=3D 38(D=
)  OK
[    7.578708] raid6test: test_disks(12, 39): faila=3D 12(D)  failb=3D 39(D=
)  OK
[    7.581668] raid6test: test_disks(12, 40): faila=3D 12(D)  failb=3D 40(D=
)  OK
[    7.584553] raid6test: test_disks(12, 41): faila=3D 12(D)  failb=3D 41(D=
)  OK
[    7.587516] raid6test: test_disks(12, 42): faila=3D 12(D)  failb=3D 42(D=
)  OK
[    7.590403] raid6test: test_disks(12, 43): faila=3D 12(D)  failb=3D 43(D=
)  OK
[    7.593351] raid6test: test_disks(12, 44): faila=3D 12(D)  failb=3D 44(D=
)  OK
[    7.596274] raid6test: test_disks(12, 45): faila=3D 12(D)  failb=3D 45(D=
)  OK
[    7.599089] raid6test: test_disks(12, 46): faila=3D 12(D)  failb=3D 46(D=
)  OK
[    7.601941] raid6test: test_disks(12, 47): faila=3D 12(D)  failb=3D 47(D=
)  OK
[    7.604863] raid6test: test_disks(12, 48): faila=3D 12(D)  failb=3D 48(D=
)  OK
[    7.607733] raid6test: test_disks(12, 49): faila=3D 12(D)  failb=3D 49(D=
)  OK
[    7.610659] raid6test: test_disks(12, 50): faila=3D 12(D)  failb=3D 50(D=
)  OK
[    7.613604] raid6test: test_disks(12, 51): faila=3D 12(D)  failb=3D 51(D=
)  OK
[    7.616433] raid6test: test_disks(12, 52): faila=3D 12(D)  failb=3D 52(D=
)  OK
[    7.619262] raid6test: test_disks(12, 53): faila=3D 12(D)  failb=3D 53(D=
)  OK
[    7.622206] raid6test: test_disks(12, 54): faila=3D 12(D)  failb=3D 54(D=
)  OK
[    7.625213] raid6test: test_disks(12, 55): faila=3D 12(D)  failb=3D 55(D=
)  OK
[    7.628153] raid6test: test_disks(12, 56): faila=3D 12(D)  failb=3D 56(D=
)  OK
[    7.631090] raid6test: test_disks(12, 57): faila=3D 12(D)  failb=3D 57(D=
)  OK
[    7.634002] raid6test: test_disks(12, 58): faila=3D 12(D)  failb=3D 58(D=
)  OK
[    7.636489] raid6test: test_disks(12, 59): faila=3D 12(D)  failb=3D 59(D=
)  OK
[    7.639415] raid6test: test_disks(12, 60): faila=3D 12(D)  failb=3D 60(D=
)  OK
[    7.642357] raid6test: test_disks(12, 61): faila=3D 12(D)  failb=3D 61(D=
)  OK
[    7.645356] raid6test: test_disks(12, 62): faila=3D 12(D)  failb=3D 62(P=
)  OK
[    7.648275] raid6test: test_disks(12, 63): faila=3D 12(D)  failb=3D 63(Q=
)  OK
[    7.651158] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[    7.654176] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[    7.657199] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[    7.659717] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[    7.662237] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[    7.665012] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[    7.667753] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[    7.670565] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[    7.673345] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(D=
)  OK
[    7.676172] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(D=
)  OK
[    7.679014] raid6test: test_disks(13, 24): faila=3D 13(D)  failb=3D 24(D=
)  OK
[    7.681807] raid6test: test_disks(13, 25): faila=3D 13(D)  failb=3D 25(D=
)  OK
[    7.684641] raid6test: test_disks(13, 26): faila=3D 13(D)  failb=3D 26(D=
)  OK
[    7.687421] raid6test: test_disks(13, 27): faila=3D 13(D)  failb=3D 27(D=
)  OK
[    7.690257] raid6test: test_disks(13, 28): faila=3D 13(D)  failb=3D 28(D=
)  OK
[    7.693071] raid6test: test_disks(13, 29): faila=3D 13(D)  failb=3D 29(D=
)  OK
[    7.695889] raid6test: test_disks(13, 30): faila=3D 13(D)  failb=3D 30(D=
)  OK
[    7.698650] raid6test: test_disks(13, 31): faila=3D 13(D)  failb=3D 31(D=
)  OK
[    7.701479] raid6test: test_disks(13, 32): faila=3D 13(D)  failb=3D 32(D=
)  OK
[    7.704316] raid6test: test_disks(13, 33): faila=3D 13(D)  failb=3D 33(D=
)  OK
[    7.707126] raid6test: test_disks(13, 34): faila=3D 13(D)  failb=3D 34(D=
)  OK
[    7.709772] raid6test: test_disks(13, 35): faila=3D 13(D)  failb=3D 35(D=
)  OK
[    7.712469] raid6test: test_disks(13, 36): faila=3D 13(D)  failb=3D 36(D=
)  OK
[    7.715253] raid6test: test_disks(13, 37): faila=3D 13(D)  failb=3D 37(D=
)  OK
[    7.717877] raid6test: test_disks(13, 38): faila=3D 13(D)  failb=3D 38(D=
)  OK
[    7.720655] raid6test: test_disks(13, 39): faila=3D 13(D)  failb=3D 39(D=
)  OK
[    7.723461] raid6test: test_disks(13, 40): faila=3D 13(D)  failb=3D 40(D=
)  OK
[    7.726295] raid6test: test_disks(13, 41): faila=3D 13(D)  failb=3D 41(D=
)  OK
[    7.729141] raid6test: test_disks(13, 42): faila=3D 13(D)  failb=3D 42(D=
)  OK
[    7.731994] raid6test: test_disks(13, 43): faila=3D 13(D)  failb=3D 43(D=
)  OK
[    7.734994] raid6test: test_disks(13, 44): faila=3D 13(D)  failb=3D 44(D=
)  OK
[    7.736784] raid6test: test_disks(13, 45): faila=3D 13(D)  failb=3D 45(D=
)  OK
[    7.738435] raid6test: test_disks(13, 46): faila=3D 13(D)  failb=3D 46(D=
)  OK
[    7.740080] raid6test: test_disks(13, 47): faila=3D 13(D)  failb=3D 47(D=
)  OK
[    7.741698] raid6test: test_disks(13, 48): faila=3D 13(D)  failb=3D 48(D=
)  OK
[    7.743331] raid6test: test_disks(13, 49): faila=3D 13(D)  failb=3D 49(D=
)  OK
[    7.744961] raid6test: test_disks(13, 50): faila=3D 13(D)  failb=3D 50(D=
)  OK
[    7.747741] raid6test: test_disks(13, 51): faila=3D 13(D)  failb=3D 51(D=
)  OK
[    7.750590] raid6test: test_disks(13, 52): faila=3D 13(D)  failb=3D 52(D=
)  OK
[    7.753485] raid6test: test_disks(13, 53): faila=3D 13(D)  failb=3D 53(D=
)  OK
[    7.756434] raid6test: test_disks(13, 54): faila=3D 13(D)  failb=3D 54(D=
)  OK
[    7.759325] raid6test: test_disks(13, 55): faila=3D 13(D)  failb=3D 55(D=
)  OK
[    7.762255] raid6test: test_disks(13, 56): faila=3D 13(D)  failb=3D 56(D=
)  OK
[    7.765247] raid6test: test_disks(13, 57): faila=3D 13(D)  failb=3D 57(D=
)  OK
[    7.768182] raid6test: test_disks(13, 58): faila=3D 13(D)  failb=3D 58(D=
)  OK
[    7.771085] raid6test: test_disks(13, 59): faila=3D 13(D)  failb=3D 59(D=
)  OK
[    7.773988] raid6test: test_disks(13, 60): faila=3D 13(D)  failb=3D 60(D=
)  OK
[    7.776818] raid6test: test_disks(13, 61): faila=3D 13(D)  failb=3D 61(D=
)  OK
[    7.779621] raid6test: test_disks(13, 62): faila=3D 13(D)  failb=3D 62(P=
)  OK
[    7.782420] raid6test: test_disks(13, 63): faila=3D 13(D)  failb=3D 63(Q=
)  OK
[    7.785251] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[    7.788164] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[    7.791134] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[    7.794034] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[    7.796747] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[    7.799241] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[    7.802180] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[    7.804636] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(D=
)  OK
[    7.807289] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(D=
)  OK
[    7.810112] raid6test: test_disks(14, 24): faila=3D 14(D)  failb=3D 24(D=
)  OK
[    7.812726] raid6test: test_disks(14, 25): faila=3D 14(D)  failb=3D 25(D=
)  OK
[    7.815512] raid6test: test_disks(14, 26): faila=3D 14(D)  failb=3D 26(D=
)  OK
[    7.818279] raid6test: test_disks(14, 27): faila=3D 14(D)  failb=3D 27(D=
)  OK
[    7.821050] raid6test: test_disks(14, 28): faila=3D 14(D)  failb=3D 28(D=
)  OK
[    7.823804] raid6test: test_disks(14, 29): faila=3D 14(D)  failb=3D 29(D=
)  OK
[    7.826553] raid6test: test_disks(14, 30): faila=3D 14(D)  failb=3D 30(D=
)  OK
[    7.829315] raid6test: test_disks(14, 31): faila=3D 14(D)  failb=3D 31(D=
)  OK
[    7.832176] raid6test: test_disks(14, 32): faila=3D 14(D)  failb=3D 32(D=
)  OK
[    7.834933] raid6test: test_disks(14, 33): faila=3D 14(D)  failb=3D 33(D=
)  OK
[    7.837743] raid6test: test_disks(14, 34): faila=3D 14(D)  failb=3D 34(D=
)  OK
[    7.840536] raid6test: test_disks(14, 35): faila=3D 14(D)  failb=3D 35(D=
)  OK
[    7.843361] raid6test: test_disks(14, 36): faila=3D 14(D)  failb=3D 36(D=
)  OK
[    7.846195] raid6test: test_disks(14, 37): faila=3D 14(D)  failb=3D 37(D=
)  OK
[    7.848938] raid6test: test_disks(14, 38): faila=3D 14(D)  failb=3D 38(D=
)  OK
[    7.851797] raid6test: test_disks(14, 39): faila=3D 14(D)  failb=3D 39(D=
)  OK
[    7.854490] raid6test: test_disks(14, 40): faila=3D 14(D)  failb=3D 40(D=
)  OK
[    7.857309] raid6test: test_disks(14, 41): faila=3D 14(D)  failb=3D 41(D=
)  OK
[    7.860144] raid6test: test_disks(14, 42): faila=3D 14(D)  failb=3D 42(D=
)  OK
[    7.862925] raid6test: test_disks(14, 43): faila=3D 14(D)  failb=3D 43(D=
)  OK
[    7.865737] raid6test: test_disks(14, 44): faila=3D 14(D)  failb=3D 44(D=
)  OK
[    7.868548] raid6test: test_disks(14, 45): faila=3D 14(D)  failb=3D 45(D=
)  OK
[    7.871376] raid6test: test_disks(14, 46): faila=3D 14(D)  failb=3D 46(D=
)  OK
[    7.874188] raid6test: test_disks(14, 47): faila=3D 14(D)  failb=3D 47(D=
)  OK
[    7.877065] raid6test: test_disks(14, 48): faila=3D 14(D)  failb=3D 48(D=
)  OK
[    7.879870] raid6test: test_disks(14, 49): faila=3D 14(D)  failb=3D 49(D=
)  OK
[    7.882675] raid6test: test_disks(14, 50): faila=3D 14(D)  failb=3D 50(D=
)  OK
[    7.885533] raid6test: test_disks(14, 51): faila=3D 14(D)  failb=3D 51(D=
)  OK
[    7.888226] raid6test: test_disks(14, 52): faila=3D 14(D)  failb=3D 52(D=
)  OK
[    7.890978] raid6test: test_disks(14, 53): faila=3D 14(D)  failb=3D 53(D=
)  OK
[    7.893825] raid6test: test_disks(14, 54): faila=3D 14(D)  failb=3D 54(D=
)  OK
[    7.896559] raid6test: test_disks(14, 55): faila=3D 14(D)  failb=3D 55(D=
)  OK
[    7.899313] raid6test: test_disks(14, 56): faila=3D 14(D)  failb=3D 56(D=
)  OK
[    7.902124] raid6test: test_disks(14, 57): faila=3D 14(D)  failb=3D 57(D=
)  OK
[    7.904898] raid6test: test_disks(14, 58): faila=3D 14(D)  failb=3D 58(D=
)  OK
[    7.907746] raid6test: test_disks(14, 59): faila=3D 14(D)  failb=3D 59(D=
)  OK
[    7.910587] raid6test: test_disks(14, 60): faila=3D 14(D)  failb=3D 60(D=
)  OK
[    7.913329] raid6test: test_disks(14, 61): faila=3D 14(D)  failb=3D 61(D=
)  OK
[    7.916237] raid6test: test_disks(14, 62): faila=3D 14(D)  failb=3D 62(P=
)  OK
[    7.918929] raid6test: test_disks(14, 63): faila=3D 14(D)  failb=3D 63(Q=
)  OK
[    7.935426] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[    7.938334] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[    7.941165] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[    7.944040] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[    7.946839] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[    7.949593] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[    7.952536] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(D=
)  OK
[    7.955287] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(D=
)  OK
[    7.957926] raid6test: test_disks(15, 24): faila=3D 15(D)  failb=3D 24(D=
)  OK
[    7.960616] raid6test: test_disks(15, 25): faila=3D 15(D)  failb=3D 25(D=
)  OK
[    7.963356] raid6test: test_disks(15, 26): faila=3D 15(D)  failb=3D 26(D=
)  OK
[    7.966302] raid6test: test_disks(15, 27): faila=3D 15(D)  failb=3D 27(D=
)  OK
[    7.969067] raid6test: test_disks(15, 28): faila=3D 15(D)  failb=3D 28(D=
)  OK
[    7.971865] raid6test: test_disks(15, 29): faila=3D 15(D)  failb=3D 29(D=
)  OK
[    7.974514] raid6test: test_disks(15, 30): faila=3D 15(D)  failb=3D 30(D=
)  OK
[    7.977248] raid6test: test_disks(15, 31): faila=3D 15(D)  failb=3D 31(D=
)  OK
[    7.980098] raid6test: test_disks(15, 32): faila=3D 15(D)  failb=3D 32(D=
)  OK
[    7.982829] raid6test: test_disks(15, 33): faila=3D 15(D)  failb=3D 33(D=
)  OK
[    7.985693] raid6test: test_disks(15, 34): faila=3D 15(D)  failb=3D 34(D=
)  OK
[    7.988495] raid6test: test_disks(15, 35): faila=3D 15(D)  failb=3D 35(D=
)  OK
[    7.990935] raid6test: test_disks(15, 36): faila=3D 15(D)  failb=3D 36(D=
)  OK
[    7.993509] raid6test: test_disks(15, 37): faila=3D 15(D)  failb=3D 37(D=
)  OK
[    7.996064] raid6test: test_disks(15, 38): faila=3D 15(D)  failb=3D 38(D=
)  OK
[    7.998839] raid6test: test_disks(15, 39): faila=3D 15(D)  failb=3D 39(D=
)  OK
[    8.001744] raid6test: test_disks(15, 40): faila=3D 15(D)  failb=3D 40(D=
)  OK
[    8.004483] raid6test: test_disks(15, 41): faila=3D 15(D)  failb=3D 41(D=
)  OK
[    8.007402] raid6test: test_disks(15, 42): faila=3D 15(D)  failb=3D 42(D=
)  OK
[    8.010312] raid6test: test_disks(15, 43): faila=3D 15(D)  failb=3D 43(D=
)  OK
[    8.013233] raid6test: test_disks(15, 44): faila=3D 15(D)  failb=3D 44(D=
)  OK
[    8.016232] raid6test: test_disks(15, 45): faila=3D 15(D)  failb=3D 45(D=
)  OK
[    8.019163] raid6test: test_disks(15, 46): faila=3D 15(D)  failb=3D 46(D=
)  OK
[    8.022124] raid6test: test_disks(15, 47): faila=3D 15(D)  failb=3D 47(D=
)  OK
[    8.025105] raid6test: test_disks(15, 48): faila=3D 15(D)  failb=3D 48(D=
)  OK
[    8.027981] raid6test: test_disks(15, 49): faila=3D 15(D)  failb=3D 49(D=
)  OK
[    8.030906] raid6test: test_disks(15, 50): faila=3D 15(D)  failb=3D 50(D=
)  OK
[    8.033820] raid6test: test_disks(15, 51): faila=3D 15(D)  failb=3D 51(D=
)  OK
[    8.036769] raid6test: test_disks(15, 52): faila=3D 15(D)  failb=3D 52(D=
)  OK
[    8.039679] raid6test: test_disks(15, 53): faila=3D 15(D)  failb=3D 53(D=
)  OK
[    8.042586] raid6test: test_disks(15, 54): faila=3D 15(D)  failb=3D 54(D=
)  OK
[    8.045468] raid6test: test_disks(15, 55): faila=3D 15(D)  failb=3D 55(D=
)  OK
[    8.048382] raid6test: test_disks(15, 56): faila=3D 15(D)  failb=3D 56(D=
)  OK
[    8.051293] raid6test: test_disks(15, 57): faila=3D 15(D)  failb=3D 57(D=
)  OK
[    8.054253] raid6test: test_disks(15, 58): faila=3D 15(D)  failb=3D 58(D=
)  OK
[    8.057252] raid6test: test_disks(15, 59): faila=3D 15(D)  failb=3D 59(D=
)  OK
[    8.060186] raid6test: test_disks(15, 60): faila=3D 15(D)  failb=3D 60(D=
)  OK
[    8.063182] raid6test: test_disks(15, 61): faila=3D 15(D)  failb=3D 61(D=
)  OK
[    8.066133] raid6test: test_disks(15, 62): faila=3D 15(D)  failb=3D 62(P=
)  OK
[    8.069097] raid6test: test_disks(15, 63): faila=3D 15(D)  failb=3D 63(Q=
)  OK
[    8.072057] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[    8.074999] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[    8.077911] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[    8.080830] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[    8.083569] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[    8.086523] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(D=
)  OK
[    8.089475] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(D=
)  OK
[    8.092431] raid6test: test_disks(16, 24): faila=3D 16(D)  failb=3D 24(D=
)  OK
[    8.095388] raid6test: test_disks(16, 25): faila=3D 16(D)  failb=3D 25(D=
)  OK
[    8.098276] raid6test: test_disks(16, 26): faila=3D 16(D)  failb=3D 26(D=
)  OK
[    8.101210] raid6test: test_disks(16, 27): faila=3D 16(D)  failb=3D 27(D=
)  OK
[    8.104179] raid6test: test_disks(16, 28): faila=3D 16(D)  failb=3D 28(D=
)  OK
[    8.107128] raid6test: test_disks(16, 29): faila=3D 16(D)  failb=3D 29(D=
)  OK
[    8.110068] raid6test: test_disks(16, 30): faila=3D 16(D)  failb=3D 30(D=
)  OK
[    8.113014] raid6test: test_disks(16, 31): faila=3D 16(D)  failb=3D 31(D=
)  OK
[    8.115959] raid6test: test_disks(16, 32): faila=3D 16(D)  failb=3D 32(D=
)  OK
[    8.118877] raid6test: test_disks(16, 33): faila=3D 16(D)  failb=3D 33(D=
)  OK
[    8.121809] raid6test: test_disks(16, 34): faila=3D 16(D)  failb=3D 34(D=
)  OK
[    8.124685] raid6test: test_disks(16, 35): faila=3D 16(D)  failb=3D 35(D=
)  OK
[    8.127640] raid6test: test_disks(16, 36): faila=3D 16(D)  failb=3D 36(D=
)  OK
[    8.130598] raid6test: test_disks(16, 37): faila=3D 16(D)  failb=3D 37(D=
)  OK
[    8.133611] raid6test: test_disks(16, 38): faila=3D 16(D)  failb=3D 38(D=
)  OK
[    8.136574] raid6test: test_disks(16, 39): faila=3D 16(D)  failb=3D 39(D=
)  OK
[    8.139505] raid6test: test_disks(16, 40): faila=3D 16(D)  failb=3D 40(D=
)  OK
[    8.142303] raid6test: test_disks(16, 41): faila=3D 16(D)  failb=3D 41(D=
)  OK
[    8.145265] raid6test: test_disks(16, 42): faila=3D 16(D)  failb=3D 42(D=
)  OK
[    8.148229] raid6test: test_disks(16, 43): faila=3D 16(D)  failb=3D 43(D=
)  OK
[    8.151096] raid6test: test_disks(16, 44): faila=3D 16(D)  failb=3D 44(D=
)  OK
[    8.154017] raid6test: test_disks(16, 45): faila=3D 16(D)  failb=3D 45(D=
)  OK
[    8.156979] raid6test: test_disks(16, 46): faila=3D 16(D)  failb=3D 46(D=
)  OK
[    8.159670] raid6test: test_disks(16, 47): faila=3D 16(D)  failb=3D 47(D=
)  OK
[    8.162410] raid6test: test_disks(16, 48): faila=3D 16(D)  failb=3D 48(D=
)  OK
[    8.165319] raid6test: test_disks(16, 49): faila=3D 16(D)  failb=3D 49(D=
)  OK
[    8.168221] raid6test: test_disks(16, 50): faila=3D 16(D)  failb=3D 50(D=
)  OK
[    8.171172] raid6test: test_disks(16, 51): faila=3D 16(D)  failb=3D 51(D=
)  OK
[    8.174150] raid6test: test_disks(16, 52): faila=3D 16(D)  failb=3D 52(D=
)  OK
[    8.177139] raid6test: test_disks(16, 53): faila=3D 16(D)  failb=3D 53(D=
)  OK
[    8.180132] raid6test: test_disks(16, 54): faila=3D 16(D)  failb=3D 54(D=
)  OK
[    8.183146] raid6test: test_disks(16, 55): faila=3D 16(D)  failb=3D 55(D=
)  OK
[    8.186150] raid6test: test_disks(16, 56): faila=3D 16(D)  failb=3D 56(D=
)  OK
[    8.189210] raid6test: test_disks(16, 57): faila=3D 16(D)  failb=3D 57(D=
)  OK
[    8.192152] raid6test: test_disks(16, 58): faila=3D 16(D)  failb=3D 58(D=
)  OK
[    8.195147] raid6test: test_disks(16, 59): faila=3D 16(D)  failb=3D 59(D=
)  OK
[    8.198102] raid6test: test_disks(16, 60): faila=3D 16(D)  failb=3D 60(D=
)  OK
[    8.201072] raid6test: test_disks(16, 61): faila=3D 16(D)  failb=3D 61(D=
)  OK
[    8.204042] raid6test: test_disks(16, 62): faila=3D 16(D)  failb=3D 62(P=
)  OK
[    8.206890] raid6test: test_disks(16, 63): faila=3D 16(D)  failb=3D 63(Q=
)  OK
[    8.209730] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[    8.212565] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[    8.215412] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[    8.218283] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[    8.221255] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(D=
)  OK
[    8.224217] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(D=
)  OK
[    8.227221] raid6test: test_disks(17, 24): faila=3D 17(D)  failb=3D 24(D=
)  OK
[    8.230204] raid6test: test_disks(17, 25): faila=3D 17(D)  failb=3D 25(D=
)  OK
[    8.233145] raid6test: test_disks(17, 26): faila=3D 17(D)  failb=3D 26(D=
)  OK
[    8.236059] raid6test: test_disks(17, 27): faila=3D 17(D)  failb=3D 27(D=
)  OK
[    8.239060] raid6test: test_disks(17, 28): faila=3D 17(D)  failb=3D 28(D=
)  OK
[    8.241973] raid6test: test_disks(17, 29): faila=3D 17(D)  failb=3D 29(D=
)  OK
[    8.244876] raid6test: test_disks(17, 30): faila=3D 17(D)  failb=3D 30(D=
)  OK
[    8.247933] raid6test: test_disks(17, 31): faila=3D 17(D)  failb=3D 31(D=
)  OK
[    8.250867] raid6test: test_disks(17, 32): faila=3D 17(D)  failb=3D 32(D=
)  OK
[    8.253757] raid6test: test_disks(17, 33): faila=3D 17(D)  failb=3D 33(D=
)  OK
[    8.256710] raid6test: test_disks(17, 34): faila=3D 17(D)  failb=3D 34(D=
)  OK
[    8.259505] raid6test: test_disks(17, 35): faila=3D 17(D)  failb=3D 35(D=
)  OK
[    8.262326] raid6test: test_disks(17, 36): faila=3D 17(D)  failb=3D 36(D=
)  OK
[    8.265176] raid6test: test_disks(17, 37): faila=3D 17(D)  failb=3D 37(D=
)  OK
[    8.267994] raid6test: test_disks(17, 38): faila=3D 17(D)  failb=3D 38(D=
)  OK
[    8.270941] raid6test: test_disks(17, 39): faila=3D 17(D)  failb=3D 39(D=
)  OK
[    8.273824] raid6test: test_disks(17, 40): faila=3D 17(D)  failb=3D 40(D=
)  OK
[    8.276757] raid6test: test_disks(17, 41): faila=3D 17(D)  failb=3D 41(D=
)  OK
[    8.279700] raid6test: test_disks(17, 42): faila=3D 17(D)  failb=3D 42(D=
)  OK
[    8.282651] raid6test: test_disks(17, 43): faila=3D 17(D)  failb=3D 43(D=
)  OK
[    8.285643] raid6test: test_disks(17, 44): faila=3D 17(D)  failb=3D 44(D=
)  OK
[    8.288309] raid6test: test_disks(17, 45): faila=3D 17(D)  failb=3D 45(D=
)  OK
[    8.290785] raid6test: test_disks(17, 46): faila=3D 17(D)  failb=3D 46(D=
)  OK
[    8.293535] raid6test: test_disks(17, 47): faila=3D 17(D)  failb=3D 47(D=
)  OK
[    8.296404] raid6test: test_disks(17, 48): faila=3D 17(D)  failb=3D 48(D=
)  OK
[    8.299164] raid6test: test_disks(17, 49): faila=3D 17(D)  failb=3D 49(D=
)  OK
[    8.301927] raid6test: test_disks(17, 50): faila=3D 17(D)  failb=3D 50(D=
)  OK
[    8.304707] raid6test: test_disks(17, 51): faila=3D 17(D)  failb=3D 51(D=
)  OK
[    8.307526] raid6test: test_disks(17, 52): faila=3D 17(D)  failb=3D 52(D=
)  OK
[    8.310329] raid6test: test_disks(17, 53): faila=3D 17(D)  failb=3D 53(D=
)  OK
[    8.312815] raid6test: test_disks(17, 54): faila=3D 17(D)  failb=3D 54(D=
)  OK
[    8.315572] raid6test: test_disks(17, 55): faila=3D 17(D)  failb=3D 55(D=
)  OK
[    8.318378] raid6test: test_disks(17, 56): faila=3D 17(D)  failb=3D 56(D=
)  OK
[    8.321111] raid6test: test_disks(17, 57): faila=3D 17(D)  failb=3D 57(D=
)  OK
[    8.323833] raid6test: test_disks(17, 58): faila=3D 17(D)  failb=3D 58(D=
)  OK
[    8.326612] raid6test: test_disks(17, 59): faila=3D 17(D)  failb=3D 59(D=
)  OK
[    8.329391] raid6test: test_disks(17, 60): faila=3D 17(D)  failb=3D 60(D=
)  OK
[    8.332204] raid6test: test_disks(17, 61): faila=3D 17(D)  failb=3D 61(D=
)  OK
[    8.334996] raid6test: test_disks(17, 62): faila=3D 17(D)  failb=3D 62(P=
)  OK
[    8.337752] raid6test: test_disks(17, 63): faila=3D 17(D)  failb=3D 63(Q=
)  OK
[    8.340502] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[    8.343280] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[    8.346055] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[    8.348808] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(D=
)  OK
[    8.351499] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(D=
)  OK
[    8.354250] raid6test: test_disks(18, 24): faila=3D 18(D)  failb=3D 24(D=
)  OK
[    8.356994] raid6test: test_disks(18, 25): faila=3D 18(D)  failb=3D 25(D=
)  OK
[    8.359773] raid6test: test_disks(18, 26): faila=3D 18(D)  failb=3D 26(D=
)  OK
[    8.362514] raid6test: test_disks(18, 27): faila=3D 18(D)  failb=3D 27(D=
)  OK
[    8.365272] raid6test: test_disks(18, 28): faila=3D 18(D)  failb=3D 28(D=
)  OK
[    8.368050] raid6test: test_disks(18, 29): faila=3D 18(D)  failb=3D 29(D=
)  OK
[    8.370745] raid6test: test_disks(18, 30): faila=3D 18(D)  failb=3D 30(D=
)  OK
[    8.373535] raid6test: test_disks(18, 31): faila=3D 18(D)  failb=3D 31(D=
)  OK
[    8.376245] raid6test: test_disks(18, 32): faila=3D 18(D)  failb=3D 32(D=
)  OK
[    8.378999] raid6test: test_disks(18, 33): faila=3D 18(D)  failb=3D 33(D=
)  OK
[    8.381738] raid6test: test_disks(18, 34): faila=3D 18(D)  failb=3D 34(D=
)  OK
[    8.384477] raid6test: test_disks(18, 35): faila=3D 18(D)  failb=3D 35(D=
)  OK
[    8.387174] raid6test: test_disks(18, 36): faila=3D 18(D)  failb=3D 36(D=
)  OK
[    8.389843] raid6test: test_disks(18, 37): faila=3D 18(D)  failb=3D 37(D=
)  OK
[    8.392549] raid6test: test_disks(18, 38): faila=3D 18(D)  failb=3D 38(D=
)  OK
[    8.395309] raid6test: test_disks(18, 39): faila=3D 18(D)  failb=3D 39(D=
)  OK
[    8.398065] raid6test: test_disks(18, 40): faila=3D 18(D)  failb=3D 40(D=
)  OK
[    8.400732] raid6test: test_disks(18, 41): faila=3D 18(D)  failb=3D 41(D=
)  OK
[    8.403568] raid6test: test_disks(18, 42): faila=3D 18(D)  failb=3D 42(D=
)  OK
[    8.406378] raid6test: test_disks(18, 43): faila=3D 18(D)  failb=3D 43(D=
)  OK
[    8.409136] raid6test: test_disks(18, 44): faila=3D 18(D)  failb=3D 44(D=
)  OK
[    8.411936] raid6test: test_disks(18, 45): faila=3D 18(D)  failb=3D 45(D=
)  OK
[    8.414716] raid6test: test_disks(18, 46): faila=3D 18(D)  failb=3D 46(D=
)  OK
[    8.417518] raid6test: test_disks(18, 47): faila=3D 18(D)  failb=3D 47(D=
)  OK
[    8.420278] raid6test: test_disks(18, 48): faila=3D 18(D)  failb=3D 48(D=
)  OK
[    8.423144] raid6test: test_disks(18, 49): faila=3D 18(D)  failb=3D 49(D=
)  OK
[    8.425969] raid6test: test_disks(18, 50): faila=3D 18(D)  failb=3D 50(D=
)  OK
[    8.428709] raid6test: test_disks(18, 51): faila=3D 18(D)  failb=3D 51(D=
)  OK
[    8.431499] raid6test: test_disks(18, 52): faila=3D 18(D)  failb=3D 52(D=
)  OK
[    8.434231] raid6test: test_disks(18, 53): faila=3D 18(D)  failb=3D 53(D=
)  OK
[    8.437048] raid6test: test_disks(18, 54): faila=3D 18(D)  failb=3D 54(D=
)  OK
[    8.439818] raid6test: test_disks(18, 55): faila=3D 18(D)  failb=3D 55(D=
)  OK
[    8.442591] raid6test: test_disks(18, 56): faila=3D 18(D)  failb=3D 56(D=
)  OK
[    8.445451] raid6test: test_disks(18, 57): faila=3D 18(D)  failb=3D 57(D=
)  OK
[    8.462238] raid6test: test_disks(18, 58): faila=3D 18(D)  failb=3D 58(D=
)  OK
[    8.465074] raid6test: test_disks(18, 59): faila=3D 18(D)  failb=3D 59(D=
)  OK
[    8.467841] raid6test: test_disks(18, 60): faila=3D 18(D)  failb=3D 60(D=
)  OK
[    8.470597] raid6test: test_disks(18, 61): faila=3D 18(D)  failb=3D 61(D=
)  OK
[    8.473397] raid6test: test_disks(18, 62): faila=3D 18(D)  failb=3D 62(P=
)  OK
[    8.476199] raid6test: test_disks(18, 63): faila=3D 18(D)  failb=3D 63(Q=
)  OK
[    8.478966] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[    8.481799] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[    8.484667] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(D=
)  OK
[    8.487517] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(D=
)  OK
[    8.490373] raid6test: test_disks(19, 24): faila=3D 19(D)  failb=3D 24(D=
)  OK
[    8.493058] raid6test: test_disks(19, 25): faila=3D 19(D)  failb=3D 25(D=
)  OK
[    8.495823] raid6test: test_disks(19, 26): faila=3D 19(D)  failb=3D 26(D=
)  OK
[    8.498651] raid6test: test_disks(19, 27): faila=3D 19(D)  failb=3D 27(D=
)  OK
[    8.501451] raid6test: test_disks(19, 28): faila=3D 19(D)  failb=3D 28(D=
)  OK
[    8.504180] raid6test: test_disks(19, 29): faila=3D 19(D)  failb=3D 29(D=
)  OK
[    8.507054] raid6test: test_disks(19, 30): faila=3D 19(D)  failb=3D 30(D=
)  OK
[    8.509869] raid6test: test_disks(19, 31): faila=3D 19(D)  failb=3D 31(D=
)  OK
[    8.512672] raid6test: test_disks(19, 32): faila=3D 19(D)  failb=3D 32(D=
)  OK
[    8.515477] raid6test: test_disks(19, 33): faila=3D 19(D)  failb=3D 33(D=
)  OK
[    8.518288] raid6test: test_disks(19, 34): faila=3D 19(D)  failb=3D 34(D=
)  OK
[    8.521083] raid6test: test_disks(19, 35): faila=3D 19(D)  failb=3D 35(D=
)  OK
[    8.523837] raid6test: test_disks(19, 36): faila=3D 19(D)  failb=3D 36(D=
)  OK
[    8.526617] raid6test: test_disks(19, 37): faila=3D 19(D)  failb=3D 37(D=
)  OK
[    8.529406] raid6test: test_disks(19, 38): faila=3D 19(D)  failb=3D 38(D=
)  OK
[    8.532119] raid6test: test_disks(19, 39): faila=3D 19(D)  failb=3D 39(D=
)  OK
[    8.534960] raid6test: test_disks(19, 40): faila=3D 19(D)  failb=3D 40(D=
)  OK
[    8.537811] raid6test: test_disks(19, 41): faila=3D 19(D)  failb=3D 41(D=
)  OK
[    8.540660] raid6test: test_disks(19, 42): faila=3D 19(D)  failb=3D 42(D=
)  OK
[    8.543397] raid6test: test_disks(19, 43): faila=3D 19(D)  failb=3D 43(D=
)  OK
[    8.546201] raid6test: test_disks(19, 44): faila=3D 19(D)  failb=3D 44(D=
)  OK
[    8.548904] raid6test: test_disks(19, 45): faila=3D 19(D)  failb=3D 45(D=
)  OK
[    8.551731] raid6test: test_disks(19, 46): faila=3D 19(D)  failb=3D 46(D=
)  OK
[    8.554537] raid6test: test_disks(19, 47): faila=3D 19(D)  failb=3D 47(D=
)  OK
[    8.557385] raid6test: test_disks(19, 48): faila=3D 19(D)  failb=3D 48(D=
)  OK
[    8.560160] raid6test: test_disks(19, 49): faila=3D 19(D)  failb=3D 49(D=
)  OK
[    8.562998] raid6test: test_disks(19, 50): faila=3D 19(D)  failb=3D 50(D=
)  OK
[    8.565732] raid6test: test_disks(19, 51): faila=3D 19(D)  failb=3D 51(D=
)  OK
[    8.568510] raid6test: test_disks(19, 52): faila=3D 19(D)  failb=3D 52(D=
)  OK
[    8.571317] raid6test: test_disks(19, 53): faila=3D 19(D)  failb=3D 53(D=
)  OK
[    8.574013] raid6test: test_disks(19, 54): faila=3D 19(D)  failb=3D 54(D=
)  OK
[    8.576801] raid6test: test_disks(19, 55): faila=3D 19(D)  failb=3D 55(D=
)  OK
[    8.579659] raid6test: test_disks(19, 56): faila=3D 19(D)  failb=3D 56(D=
)  OK
[    8.582489] raid6test: test_disks(19, 57): faila=3D 19(D)  failb=3D 57(D=
)  OK
[    8.585323] raid6test: test_disks(19, 58): faila=3D 19(D)  failb=3D 58(D=
)  OK
[    8.588135] raid6test: test_disks(19, 59): faila=3D 19(D)  failb=3D 59(D=
)  OK
[    8.591004] raid6test: test_disks(19, 60): faila=3D 19(D)  failb=3D 60(D=
)  OK
[    8.593768] raid6test: test_disks(19, 61): faila=3D 19(D)  failb=3D 61(D=
)  OK
[    8.596637] raid6test: test_disks(19, 62): faila=3D 19(D)  failb=3D 62(P=
)  OK
[    8.599404] raid6test: test_disks(19, 63): faila=3D 19(D)  failb=3D 63(Q=
)  OK
[    8.602212] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[    8.605083] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(D=
)  OK
[    8.607951] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(D=
)  OK
[    8.610596] raid6test: test_disks(20, 24): faila=3D 20(D)  failb=3D 24(D=
)  OK
[    8.613259] raid6test: test_disks(20, 25): faila=3D 20(D)  failb=3D 25(D=
)  OK
[    8.616080] raid6test: test_disks(20, 26): faila=3D 20(D)  failb=3D 26(D=
)  OK
[    8.618760] raid6test: test_disks(20, 27): faila=3D 20(D)  failb=3D 27(D=
)  OK
[    8.621696] raid6test: test_disks(20, 28): faila=3D 20(D)  failb=3D 28(D=
)  OK
[    8.624393] raid6test: test_disks(20, 29): faila=3D 20(D)  failb=3D 29(D=
)  OK
[    8.627284] raid6test: test_disks(20, 30): faila=3D 20(D)  failb=3D 30(D=
)  OK
[    8.630053] raid6test: test_disks(20, 31): faila=3D 20(D)  failb=3D 31(D=
)  OK
[    8.632670] raid6test: test_disks(20, 32): faila=3D 20(D)  failb=3D 32(D=
)  OK
[    8.635417] raid6test: test_disks(20, 33): faila=3D 20(D)  failb=3D 33(D=
)  OK
[    8.638203] raid6test: test_disks(20, 34): faila=3D 20(D)  failb=3D 34(D=
)  OK
[    8.641072] raid6test: test_disks(20, 35): faila=3D 20(D)  failb=3D 35(D=
)  OK
[    8.643782] raid6test: test_disks(20, 36): faila=3D 20(D)  failb=3D 36(D=
)  OK
[    8.646686] raid6test: test_disks(20, 37): faila=3D 20(D)  failb=3D 37(D=
)  OK
[    8.649428] raid6test: test_disks(20, 38): faila=3D 20(D)  failb=3D 38(D=
)  OK
[    8.652247] raid6test: test_disks(20, 39): faila=3D 20(D)  failb=3D 39(D=
)  OK
[    8.655141] raid6test: test_disks(20, 40): faila=3D 20(D)  failb=3D 40(D=
)  OK
[    8.657999] raid6test: test_disks(20, 41): faila=3D 20(D)  failb=3D 41(D=
)  OK
[    8.660780] raid6test: test_disks(20, 42): faila=3D 20(D)  failb=3D 42(D=
)  OK
[    8.663504] raid6test: test_disks(20, 43): faila=3D 20(D)  failb=3D 43(D=
)  OK
[    8.666315] raid6test: test_disks(20, 44): faila=3D 20(D)  failb=3D 44(D=
)  OK
[    8.669165] raid6test: test_disks(20, 45): faila=3D 20(D)  failb=3D 45(D=
)  OK
[    8.671993] raid6test: test_disks(20, 46): faila=3D 20(D)  failb=3D 46(D=
)  OK
[    8.674785] raid6test: test_disks(20, 47): faila=3D 20(D)  failb=3D 47(D=
)  OK
[    8.677572] raid6test: test_disks(20, 48): faila=3D 20(D)  failb=3D 48(D=
)  OK
[    8.680402] raid6test: test_disks(20, 49): faila=3D 20(D)  failb=3D 49(D=
)  OK
[    8.683124] raid6test: test_disks(20, 50): faila=3D 20(D)  failb=3D 50(D=
)  OK
[    8.685928] raid6test: test_disks(20, 51): faila=3D 20(D)  failb=3D 51(D=
)  OK
[    8.688707] raid6test: test_disks(20, 52): faila=3D 20(D)  failb=3D 52(D=
)  OK
[    8.691404] raid6test: test_disks(20, 53): faila=3D 20(D)  failb=3D 53(D=
)  OK
[    8.694233] raid6test: test_disks(20, 54): faila=3D 20(D)  failb=3D 54(D=
)  OK
[    8.697122] raid6test: test_disks(20, 55): faila=3D 20(D)  failb=3D 55(D=
)  OK
[    8.699891] raid6test: test_disks(20, 56): faila=3D 20(D)  failb=3D 56(D=
)  OK
[    8.702689] raid6test: test_disks(20, 57): faila=3D 20(D)  failb=3D 57(D=
)  OK
[    8.705536] raid6test: test_disks(20, 58): faila=3D 20(D)  failb=3D 58(D=
)  OK
[    8.708424] raid6test: test_disks(20, 59): faila=3D 20(D)  failb=3D 59(D=
)  OK
[    8.711222] raid6test: test_disks(20, 60): faila=3D 20(D)  failb=3D 60(D=
)  OK
[    8.714114] raid6test: test_disks(20, 61): faila=3D 20(D)  failb=3D 61(D=
)  OK
[    8.716891] raid6test: test_disks(20, 62): faila=3D 20(D)  failb=3D 62(P=
)  OK
[    8.719670] raid6test: test_disks(20, 63): faila=3D 20(D)  failb=3D 63(Q=
)  OK
[    8.722518] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(D=
)  OK
[    8.725374] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(D=
)  OK
[    8.728049] raid6test: test_disks(21, 24): faila=3D 21(D)  failb=3D 24(D=
)  OK
[    8.730705] raid6test: test_disks(21, 25): faila=3D 21(D)  failb=3D 25(D=
)  OK
[    8.733489] raid6test: test_disks(21, 26): faila=3D 21(D)  failb=3D 26(D=
)  OK
[    8.736213] raid6test: test_disks(21, 27): faila=3D 21(D)  failb=3D 27(D=
)  OK
[    8.739187] raid6test: test_disks(21, 28): faila=3D 21(D)  failb=3D 28(D=
)  OK
[    8.741892] raid6test: test_disks(21, 29): faila=3D 21(D)  failb=3D 29(D=
)  OK
[    8.744774] raid6test: test_disks(21, 30): faila=3D 21(D)  failb=3D 30(D=
)  OK
[    8.747575] raid6test: test_disks(21, 31): faila=3D 21(D)  failb=3D 31(D=
)  OK
[    8.750241] raid6test: test_disks(21, 32): faila=3D 21(D)  failb=3D 32(D=
)  OK
[    8.752952] raid6test: test_disks(21, 33): faila=3D 21(D)  failb=3D 33(D=
)  OK
[    8.755757] raid6test: test_disks(21, 34): faila=3D 21(D)  failb=3D 34(D=
)  OK
[    8.758594] raid6test: test_disks(21, 35): faila=3D 21(D)  failb=3D 35(D=
)  OK
[    8.761330] raid6test: test_disks(21, 36): faila=3D 21(D)  failb=3D 36(D=
)  OK
[    8.764219] raid6test: test_disks(21, 37): faila=3D 21(D)  failb=3D 37(D=
)  OK
[    8.767034] raid6test: test_disks(21, 38): faila=3D 21(D)  failb=3D 38(D=
)  OK
[    8.769854] raid6test: test_disks(21, 39): faila=3D 21(D)  failb=3D 39(D=
)  OK
[    8.772690] raid6test: test_disks(21, 40): faila=3D 21(D)  failb=3D 40(D=
)  OK
[    8.775545] raid6test: test_disks(21, 41): faila=3D 21(D)  failb=3D 41(D=
)  OK
[    8.778357] raid6test: test_disks(21, 42): faila=3D 21(D)  failb=3D 42(D=
)  OK
[    8.781208] raid6test: test_disks(21, 43): faila=3D 21(D)  failb=3D 43(D=
)  OK
[    8.783904] raid6test: test_disks(21, 44): faila=3D 21(D)  failb=3D 44(D=
)  OK
[    8.786698] raid6test: test_disks(21, 45): faila=3D 21(D)  failb=3D 45(D=
)  OK
[    8.789565] raid6test: test_disks(21, 46): faila=3D 21(D)  failb=3D 46(D=
)  OK
[    8.792379] raid6test: test_disks(21, 47): faila=3D 21(D)  failb=3D 47(D=
)  OK
[    8.795118] raid6test: test_disks(21, 48): faila=3D 21(D)  failb=3D 48(D=
)  OK
[    8.797937] raid6test: test_disks(21, 49): faila=3D 21(D)  failb=3D 49(D=
)  OK
[    8.800726] raid6test: test_disks(21, 50): faila=3D 21(D)  failb=3D 50(D=
)  OK
[    8.803473] raid6test: test_disks(21, 51): faila=3D 21(D)  failb=3D 51(D=
)  OK
[    8.806265] raid6test: test_disks(21, 52): faila=3D 21(D)  failb=3D 52(D=
)  OK
[    8.809093] raid6test: test_disks(21, 53): faila=3D 21(D)  failb=3D 53(D=
)  OK
[    8.811928] raid6test: test_disks(21, 54): faila=3D 21(D)  failb=3D 54(D=
)  OK
[    8.814693] raid6test: test_disks(21, 55): faila=3D 21(D)  failb=3D 55(D=
)  OK
[    8.817585] raid6test: test_disks(21, 56): faila=3D 21(D)  failb=3D 56(D=
)  OK
[    8.820254] raid6test: test_disks(21, 57): faila=3D 21(D)  failb=3D 57(D=
)  OK
[    8.823042] raid6test: test_disks(21, 58): faila=3D 21(D)  failb=3D 58(D=
)  OK
[    8.825914] raid6test: test_disks(21, 59): faila=3D 21(D)  failb=3D 59(D=
)  OK
[    8.828734] raid6test: test_disks(21, 60): faila=3D 21(D)  failb=3D 60(D=
)  OK
[    8.831405] raid6test: test_disks(21, 61): faila=3D 21(D)  failb=3D 61(D=
)  OK
[    8.834211] raid6test: test_disks(21, 62): faila=3D 21(D)  failb=3D 62(P=
)  OK
[    8.837014] raid6test: test_disks(21, 63): faila=3D 21(D)  failb=3D 63(Q=
)  OK
[    8.839764] raid6test: test_disks(22, 23): faila=3D 22(D)  failb=3D 23(D=
)  OK
[    8.842406] raid6test: test_disks(22, 24): faila=3D 22(D)  failb=3D 24(D=
)  OK
[    8.845136] raid6test: test_disks(22, 25): faila=3D 22(D)  failb=3D 25(D=
)  OK
[    8.848066] raid6test: test_disks(22, 26): faila=3D 22(D)  failb=3D 26(D=
)  OK
[    8.850692] raid6test: test_disks(22, 27): faila=3D 22(D)  failb=3D 27(D=
)  OK
[    8.853222] raid6test: test_disks(22, 28): faila=3D 22(D)  failb=3D 28(D=
)  OK
[    8.855788] raid6test: test_disks(22, 29): faila=3D 22(D)  failb=3D 29(D=
)  OK
[    8.858384] raid6test: test_disks(22, 30): faila=3D 22(D)  failb=3D 30(D=
)  OK
[    8.860169] raid6test: test_disks(22, 31): faila=3D 22(D)  failb=3D 31(D=
)  OK
[    8.861791] raid6test: test_disks(22, 32): faila=3D 22(D)  failb=3D 32(D=
)  OK
[    8.863441] raid6test: test_disks(22, 33): faila=3D 22(D)  failb=3D 33(D=
)  OK
[    8.865121] raid6test: test_disks(22, 34): faila=3D 22(D)  failb=3D 34(D=
)  OK
[    8.866753] raid6test: test_disks(22, 35): faila=3D 22(D)  failb=3D 35(D=
)  OK
[    8.868383] raid6test: test_disks(22, 36): faila=3D 22(D)  failb=3D 36(D=
)  OK
[    8.870028] raid6test: test_disks(22, 37): faila=3D 22(D)  failb=3D 37(D=
)  OK
[    8.871659] raid6test: test_disks(22, 38): faila=3D 22(D)  failb=3D 38(D=
)  OK
[    8.873294] raid6test: test_disks(22, 39): faila=3D 22(D)  failb=3D 39(D=
)  OK
[    8.874949] raid6test: test_disks(22, 40): faila=3D 22(D)  failb=3D 40(D=
)  OK
[    8.876575] raid6test: test_disks(22, 41): faila=3D 22(D)  failb=3D 41(D=
)  OK
[    8.878215] raid6test: test_disks(22, 42): faila=3D 22(D)  failb=3D 42(D=
)  OK
[    8.879836] raid6test: test_disks(22, 43): faila=3D 22(D)  failb=3D 43(D=
)  OK
[    8.881467] raid6test: test_disks(22, 44): faila=3D 22(D)  failb=3D 44(D=
)  OK
[    8.883110] raid6test: test_disks(22, 45): faila=3D 22(D)  failb=3D 45(D=
)  OK
[    8.884742] raid6test: test_disks(22, 46): faila=3D 22(D)  failb=3D 46(D=
)  OK
[    8.886399] raid6test: test_disks(22, 47): faila=3D 22(D)  failb=3D 47(D=
)  OK
[    8.888063] raid6test: test_disks(22, 48): faila=3D 22(D)  failb=3D 48(D=
)  OK
[    8.889677] raid6test: test_disks(22, 49): faila=3D 22(D)  failb=3D 49(D=
)  OK
[    8.891308] raid6test: test_disks(22, 50): faila=3D 22(D)  failb=3D 50(D=
)  OK
[    8.892936] raid6test: test_disks(22, 51): faila=3D 22(D)  failb=3D 51(D=
)  OK
[    8.894566] raid6test: test_disks(22, 52): faila=3D 22(D)  failb=3D 52(D=
)  OK
[    8.896224] raid6test: test_disks(22, 53): faila=3D 22(D)  failb=3D 53(D=
)  OK
[    8.897840] raid6test: test_disks(22, 54): faila=3D 22(D)  failb=3D 54(D=
)  OK
[    8.899484] raid6test: test_disks(22, 55): faila=3D 22(D)  failb=3D 55(D=
)  OK
[    8.901126] raid6test: test_disks(22, 56): faila=3D 22(D)  failb=3D 56(D=
)  OK
[    8.902755] raid6test: test_disks(22, 57): faila=3D 22(D)  failb=3D 57(D=
)  OK
[    8.904392] raid6test: test_disks(22, 58): faila=3D 22(D)  failb=3D 58(D=
)  OK
[    8.906059] raid6test: test_disks(22, 59): faila=3D 22(D)  failb=3D 59(D=
)  OK
[    8.907666] raid6test: test_disks(22, 60): faila=3D 22(D)  failb=3D 60(D=
)  OK
[    8.909299] raid6test: test_disks(22, 61): faila=3D 22(D)  failb=3D 61(D=
)  OK
[    8.910927] raid6test: test_disks(22, 62): faila=3D 22(D)  failb=3D 62(P=
)  OK
[    8.912548] raid6test: test_disks(22, 63): faila=3D 22(D)  failb=3D 63(Q=
)  OK
[    8.914181] raid6test: test_disks(23, 24): faila=3D 23(D)  failb=3D 24(D=
)  OK
[    8.915817] raid6test: test_disks(23, 25): faila=3D 23(D)  failb=3D 25(D=
)  OK
[    8.917450] raid6test: test_disks(23, 26): faila=3D 23(D)  failb=3D 26(D=
)  OK
[    8.919087] raid6test: test_disks(23, 27): faila=3D 23(D)  failb=3D 27(D=
)  OK
[    8.927927] raid6test: test_disks(23, 28): faila=3D 23(D)  failb=3D 28(D=
)  OK
[    8.929555] raid6test: test_disks(23, 29): faila=3D 23(D)  failb=3D 29(D=
)  OK
[    8.931192] raid6test: test_disks(23, 30): faila=3D 23(D)  failb=3D 30(D=
)  OK
[    8.932820] raid6test: test_disks(23, 31): faila=3D 23(D)  failb=3D 31(D=
)  OK
[    8.934464] raid6test: test_disks(23, 32): faila=3D 23(D)  failb=3D 32(D=
)  OK
[    8.936139] raid6test: test_disks(23, 33): faila=3D 23(D)  failb=3D 33(D=
)  OK
[    8.937764] raid6test: test_disks(23, 34): faila=3D 23(D)  failb=3D 34(D=
)  OK
[    8.939416] raid6test: test_disks(23, 35): faila=3D 23(D)  failb=3D 35(D=
)  OK
[    8.941070] raid6test: test_disks(23, 36): faila=3D 23(D)  failb=3D 36(D=
)  OK
[    8.942712] raid6test: test_disks(23, 37): faila=3D 23(D)  failb=3D 37(D=
)  OK
[    8.944341] raid6test: test_disks(23, 38): faila=3D 23(D)  failb=3D 38(D=
)  OK
[    8.945988] raid6test: test_disks(23, 39): faila=3D 23(D)  failb=3D 39(D=
)  OK
[    8.947610] raid6test: test_disks(23, 40): faila=3D 23(D)  failb=3D 40(D=
)  OK
[    8.949241] raid6test: test_disks(23, 41): faila=3D 23(D)  failb=3D 41(D=
)  OK
[    8.950874] raid6test: test_disks(23, 42): faila=3D 23(D)  failb=3D 42(D=
)  OK
[    8.952505] raid6test: test_disks(23, 43): faila=3D 23(D)  failb=3D 43(D=
)  OK
[    8.954144] raid6test: test_disks(23, 44): faila=3D 23(D)  failb=3D 44(D=
)  OK
[    8.955771] raid6test: test_disks(23, 45): faila=3D 23(D)  failb=3D 45(D=
)  OK
[    8.957396] raid6test: test_disks(23, 46): faila=3D 23(D)  failb=3D 46(D=
)  OK
[    8.959023] raid6test: test_disks(23, 47): faila=3D 23(D)  failb=3D 47(D=
)  OK
[    8.960652] raid6test: test_disks(23, 48): faila=3D 23(D)  failb=3D 48(D=
)  OK
[    8.962320] raid6test: test_disks(23, 49): faila=3D 23(D)  failb=3D 49(D=
)  OK
[    8.963949] raid6test: test_disks(23, 50): faila=3D 23(D)  failb=3D 50(D=
)  OK
[    8.965580] raid6test: test_disks(23, 51): faila=3D 23(D)  failb=3D 51(D=
)  OK
[    8.967215] raid6test: test_disks(23, 52): faila=3D 23(D)  failb=3D 52(D=
)  OK
[    8.968822] raid6test: test_disks(23, 53): faila=3D 23(D)  failb=3D 53(D=
)  OK
[    8.970446] raid6test: test_disks(23, 54): faila=3D 23(D)  failb=3D 54(D=
)  OK
[    8.972081] raid6test: test_disks(23, 55): faila=3D 23(D)  failb=3D 55(D=
)  OK
[    8.973695] raid6test: test_disks(23, 56): faila=3D 23(D)  failb=3D 56(D=
)  OK
[    8.975330] raid6test: test_disks(23, 57): faila=3D 23(D)  failb=3D 57(D=
)  OK
[    8.976951] raid6test: test_disks(23, 58): faila=3D 23(D)  failb=3D 58(D=
)  OK
[    8.978570] raid6test: test_disks(23, 59): faila=3D 23(D)  failb=3D 59(D=
)  OK
[    8.980182] raid6test: test_disks(23, 60): faila=3D 23(D)  failb=3D 60(D=
)  OK
[    8.981802] raid6test: test_disks(23, 61): faila=3D 23(D)  failb=3D 61(D=
)  OK
[    8.983425] raid6test: test_disks(23, 62): faila=3D 23(D)  failb=3D 62(P=
)  OK
[    8.985074] raid6test: test_disks(23, 63): faila=3D 23(D)  failb=3D 63(Q=
)  OK
[    8.986687] raid6test: test_disks(24, 25): faila=3D 24(D)  failb=3D 25(D=
)  OK
[    8.988313] raid6test: test_disks(24, 26): faila=3D 24(D)  failb=3D 26(D=
)  OK
[    8.989932] raid6test: test_disks(24, 27): faila=3D 24(D)  failb=3D 27(D=
)  OK
[    8.991545] raid6test: test_disks(24, 28): faila=3D 24(D)  failb=3D 28(D=
)  OK
[    8.993157] raid6test: test_disks(24, 29): faila=3D 24(D)  failb=3D 29(D=
)  OK
[    8.994768] raid6test: test_disks(24, 30): faila=3D 24(D)  failb=3D 30(D=
)  OK
[    8.996411] raid6test: test_disks(24, 31): faila=3D 24(D)  failb=3D 31(D=
)  OK
[    8.998055] raid6test: test_disks(24, 32): faila=3D 24(D)  failb=3D 32(D=
)  OK
[    8.999668] raid6test: test_disks(24, 33): faila=3D 24(D)  failb=3D 33(D=
)  OK
[    9.001295] raid6test: test_disks(24, 34): faila=3D 24(D)  failb=3D 34(D=
)  OK
[    9.002959] raid6test: test_disks(24, 35): faila=3D 24(D)  failb=3D 35(D=
)  OK
[    9.004590] raid6test: test_disks(24, 36): faila=3D 24(D)  failb=3D 36(D=
)  OK
[    9.006475] raid6test: test_disks(24, 37): faila=3D 24(D)  failb=3D 37(D=
)  OK
[    9.008122] raid6test: test_disks(24, 38): faila=3D 24(D)  failb=3D 38(D=
)  OK
[    9.009745] raid6test: test_disks(24, 39): faila=3D 24(D)  failb=3D 39(D=
)  OK
[    9.011385] raid6test: test_disks(24, 40): faila=3D 24(D)  failb=3D 40(D=
)  OK
[    9.013034] raid6test: test_disks(24, 41): faila=3D 24(D)  failb=3D 41(D=
)  OK
[    9.014682] raid6test: test_disks(24, 42): faila=3D 24(D)  failb=3D 42(D=
)  OK
[    9.016359] raid6test: test_disks(24, 43): faila=3D 24(D)  failb=3D 43(D=
)  OK
[    9.018027] raid6test: test_disks(24, 44): faila=3D 24(D)  failb=3D 44(D=
)  OK
[    9.019658] raid6test: test_disks(24, 45): faila=3D 24(D)  failb=3D 45(D=
)  OK
[    9.021283] raid6test: test_disks(24, 46): faila=3D 24(D)  failb=3D 46(D=
)  OK
[    9.022912] raid6test: test_disks(24, 47): faila=3D 24(D)  failb=3D 47(D=
)  OK
[    9.024544] raid6test: test_disks(24, 48): faila=3D 24(D)  failb=3D 48(D=
)  OK
[    9.026200] raid6test: test_disks(24, 49): faila=3D 24(D)  failb=3D 49(D=
)  OK
[    9.027852] raid6test: test_disks(24, 50): faila=3D 24(D)  failb=3D 50(D=
)  OK
[    9.029476] raid6test: test_disks(24, 51): faila=3D 24(D)  failb=3D 51(D=
)  OK
[    9.031110] raid6test: test_disks(24, 52): faila=3D 24(D)  failb=3D 52(D=
)  OK
[    9.032722] raid6test: test_disks(24, 53): faila=3D 24(D)  failb=3D 53(D=
)  OK
[    9.034344] raid6test: test_disks(24, 54): faila=3D 24(D)  failb=3D 54(D=
)  OK
[    9.035989] raid6test: test_disks(24, 55): faila=3D 24(D)  failb=3D 55(D=
)  OK
[    9.037611] raid6test: test_disks(24, 56): faila=3D 24(D)  failb=3D 56(D=
)  OK
[    9.039232] raid6test: test_disks(24, 57): faila=3D 24(D)  failb=3D 57(D=
)  OK
[    9.040865] raid6test: test_disks(24, 58): faila=3D 24(D)  failb=3D 58(D=
)  OK
[    9.042482] raid6test: test_disks(24, 59): faila=3D 24(D)  failb=3D 59(D=
)  OK
[    9.044114] raid6test: test_disks(24, 60): faila=3D 24(D)  failb=3D 60(D=
)  OK
[    9.045731] raid6test: test_disks(24, 61): faila=3D 24(D)  failb=3D 61(D=
)  OK
[    9.047354] raid6test: test_disks(24, 62): faila=3D 24(D)  failb=3D 62(P=
)  OK
[    9.048962] raid6test: test_disks(24, 63): faila=3D 24(D)  failb=3D 63(Q=
)  OK
[    9.050574] raid6test: test_disks(25, 26): faila=3D 25(D)  failb=3D 26(D=
)  OK
[    9.052191] raid6test: test_disks(25, 27): faila=3D 25(D)  failb=3D 27(D=
)  OK
[    9.053802] raid6test: test_disks(25, 28): faila=3D 25(D)  failb=3D 28(D=
)  OK
[    9.055435] raid6test: test_disks(25, 29): faila=3D 25(D)  failb=3D 29(D=
)  OK
[    9.057065] raid6test: test_disks(25, 30): faila=3D 25(D)  failb=3D 30(D=
)  OK
[    9.058677] raid6test: test_disks(25, 31): faila=3D 25(D)  failb=3D 31(D=
)  OK
[    9.060302] raid6test: test_disks(25, 32): faila=3D 25(D)  failb=3D 32(D=
)  OK
[    9.061939] raid6test: test_disks(25, 33): faila=3D 25(D)  failb=3D 33(D=
)  OK
[    9.063562] raid6test: test_disks(25, 34): faila=3D 25(D)  failb=3D 34(D=
)  OK
[    9.065193] raid6test: test_disks(25, 35): faila=3D 25(D)  failb=3D 35(D=
)  OK
[    9.066806] raid6test: test_disks(25, 36): faila=3D 25(D)  failb=3D 36(D=
)  OK
[    9.068433] raid6test: test_disks(25, 37): faila=3D 25(D)  failb=3D 37(D=
)  OK
[    9.070074] raid6test: test_disks(25, 38): faila=3D 25(D)  failb=3D 38(D=
)  OK
[    9.071681] raid6test: test_disks(25, 39): faila=3D 25(D)  failb=3D 39(D=
)  OK
[    9.073306] raid6test: test_disks(25, 40): faila=3D 25(D)  failb=3D 40(D=
)  OK
[    9.074936] raid6test: test_disks(25, 41): faila=3D 25(D)  failb=3D 41(D=
)  OK
[    9.076566] raid6test: test_disks(25, 42): faila=3D 25(D)  failb=3D 42(D=
)  OK
[    9.078195] raid6test: test_disks(25, 43): faila=3D 25(D)  failb=3D 43(D=
)  OK
[    9.079817] raid6test: test_disks(25, 44): faila=3D 25(D)  failb=3D 44(D=
)  OK
[    9.081447] raid6test: test_disks(25, 45): faila=3D 25(D)  failb=3D 45(D=
)  OK
[    9.083083] raid6test: test_disks(25, 46): faila=3D 25(D)  failb=3D 46(D=
)  OK
[    9.084689] raid6test: test_disks(25, 47): faila=3D 25(D)  failb=3D 47(D=
)  OK
[    9.086329] raid6test: test_disks(25, 48): faila=3D 25(D)  failb=3D 48(D=
)  OK
[    9.087947] raid6test: test_disks(25, 49): faila=3D 25(D)  failb=3D 49(D=
)  OK
[    9.089560] raid6test: test_disks(25, 50): faila=3D 25(D)  failb=3D 50(D=
)  OK
[    9.091182] raid6test: test_disks(25, 51): faila=3D 25(D)  failb=3D 51(D=
)  OK
[    9.092800] raid6test: test_disks(25, 52): faila=3D 25(D)  failb=3D 52(D=
)  OK
[    9.094415] raid6test: test_disks(25, 53): faila=3D 25(D)  failb=3D 53(D=
)  OK
[    9.096069] raid6test: test_disks(25, 54): faila=3D 25(D)  failb=3D 54(D=
)  OK
[    9.097678] raid6test: test_disks(25, 55): faila=3D 25(D)  failb=3D 55(D=
)  OK
[    9.099306] raid6test: test_disks(25, 56): faila=3D 25(D)  failb=3D 56(D=
)  OK
[    9.100924] raid6test: test_disks(25, 57): faila=3D 25(D)  failb=3D 57(D=
)  OK
[    9.102542] raid6test: test_disks(25, 58): faila=3D 25(D)  failb=3D 58(D=
)  OK
[    9.104165] raid6test: test_disks(25, 59): faila=3D 25(D)  failb=3D 59(D=
)  OK
[    9.105795] raid6test: test_disks(25, 60): faila=3D 25(D)  failb=3D 60(D=
)  OK
[    9.107418] raid6test: test_disks(25, 61): faila=3D 25(D)  failb=3D 61(D=
)  OK
[    9.109053] raid6test: test_disks(25, 62): faila=3D 25(D)  failb=3D 62(P=
)  OK
[    9.110661] raid6test: test_disks(25, 63): faila=3D 25(D)  failb=3D 63(Q=
)  OK
[    9.112287] raid6test: test_disks(26, 27): faila=3D 26(D)  failb=3D 27(D=
)  OK
[    9.113909] raid6test: test_disks(26, 28): faila=3D 26(D)  failb=3D 28(D=
)  OK
[    9.115533] raid6test: test_disks(26, 29): faila=3D 26(D)  failb=3D 29(D=
)  OK
[    9.117147] raid6test: test_disks(26, 30): faila=3D 26(D)  failb=3D 30(D=
)  OK
[    9.118755] raid6test: test_disks(26, 31): faila=3D 26(D)  failb=3D 31(D=
)  OK
[    9.120375] raid6test: test_disks(26, 32): faila=3D 26(D)  failb=3D 32(D=
)  OK
[    9.121987] raid6test: test_disks(26, 33): faila=3D 26(D)  failb=3D 33(D=
)  OK
[    9.124102] raid6test: test_disks(26, 34): faila=3D 26(D)  failb=3D 34(D=
)  OK
[    9.126873] raid6test: test_disks(26, 35): faila=3D 26(D)  failb=3D 35(D=
)  OK
[    9.129655] raid6test: test_disks(26, 36): faila=3D 26(D)  failb=3D 36(D=
)  OK
[    9.132445] raid6test: test_disks(26, 37): faila=3D 26(D)  failb=3D 37(D=
)  OK
[    9.135241] raid6test: test_disks(26, 38): faila=3D 26(D)  failb=3D 38(D=
)  OK
[    9.137977] raid6test: test_disks(26, 39): faila=3D 26(D)  failb=3D 39(D=
)  OK
[    9.140733] raid6test: test_disks(26, 40): faila=3D 26(D)  failb=3D 40(D=
)  OK
[    9.143436] raid6test: test_disks(26, 41): faila=3D 26(D)  failb=3D 41(D=
)  OK
[    9.146236] raid6test: test_disks(26, 42): faila=3D 26(D)  failb=3D 42(D=
)  OK
[    9.149046] raid6test: test_disks(26, 43): faila=3D 26(D)  failb=3D 43(D=
)  OK
[    9.151876] raid6test: test_disks(26, 44): faila=3D 26(D)  failb=3D 44(D=
)  OK
[    9.154612] raid6test: test_disks(26, 45): faila=3D 26(D)  failb=3D 45(D=
)  OK
[    9.157331] raid6test: test_disks(26, 46): faila=3D 26(D)  failb=3D 46(D=
)  OK
[    9.160103] raid6test: test_disks(26, 47): faila=3D 26(D)  failb=3D 47(D=
)  OK
[    9.162862] raid6test: test_disks(26, 48): faila=3D 26(D)  failb=3D 48(D=
)  OK
[    9.165614] raid6test: test_disks(26, 49): faila=3D 26(D)  failb=3D 49(D=
)  OK
[    9.168422] raid6test: test_disks(26, 50): faila=3D 26(D)  failb=3D 50(D=
)  OK
[    9.171223] raid6test: test_disks(26, 51): faila=3D 26(D)  failb=3D 51(D=
)  OK
[    9.173980] raid6test: test_disks(26, 52): faila=3D 26(D)  failb=3D 52(D=
)  OK
[    9.176708] raid6test: test_disks(26, 53): faila=3D 26(D)  failb=3D 53(D=
)  OK
[    9.179499] raid6test: test_disks(26, 54): faila=3D 26(D)  failb=3D 54(D=
)  OK
[    9.182242] raid6test: test_disks(26, 55): faila=3D 26(D)  failb=3D 55(D=
)  OK
[    9.185067] raid6test: test_disks(26, 56): faila=3D 26(D)  failb=3D 56(D=
)  OK
[    9.187808] raid6test: test_disks(26, 57): faila=3D 26(D)  failb=3D 57(D=
)  OK
[    9.190585] raid6test: test_disks(26, 58): faila=3D 26(D)  failb=3D 58(D=
)  OK
[    9.193386] raid6test: test_disks(26, 59): faila=3D 26(D)  failb=3D 59(D=
)  OK
[    9.196191] raid6test: test_disks(26, 60): faila=3D 26(D)  failb=3D 60(D=
)  OK
[    9.198965] raid6test: test_disks(26, 61): faila=3D 26(D)  failb=3D 61(D=
)  OK
[    9.201728] raid6test: test_disks(26, 62): faila=3D 26(D)  failb=3D 62(P=
)  OK
[    9.204513] raid6test: test_disks(26, 63): faila=3D 26(D)  failb=3D 63(Q=
)  OK
[    9.207300] raid6test: test_disks(27, 28): faila=3D 27(D)  failb=3D 28(D=
)  OK
[    9.210101] raid6test: test_disks(27, 29): faila=3D 27(D)  failb=3D 29(D=
)  OK
[    9.212910] raid6test: test_disks(27, 30): faila=3D 27(D)  failb=3D 30(D=
)  OK
[    9.215674] raid6test: test_disks(27, 31): faila=3D 27(D)  failb=3D 31(D=
)  OK
[    9.218403] raid6test: test_disks(27, 32): faila=3D 27(D)  failb=3D 32(D=
)  OK
[    9.221195] raid6test: test_disks(27, 33): faila=3D 27(D)  failb=3D 33(D=
)  OK
[    9.223974] raid6test: test_disks(27, 34): faila=3D 27(D)  failb=3D 34(D=
)  OK
[    9.226759] raid6test: test_disks(27, 35): faila=3D 27(D)  failb=3D 35(D=
)  OK
[    9.229513] raid6test: test_disks(27, 36): faila=3D 27(D)  failb=3D 36(D=
)  OK
[    9.232356] raid6test: test_disks(27, 37): faila=3D 27(D)  failb=3D 37(D=
)  OK
[    9.235157] raid6test: test_disks(27, 38): faila=3D 27(D)  failb=3D 38(D=
)  OK
[    9.237932] raid6test: test_disks(27, 39): faila=3D 27(D)  failb=3D 39(D=
)  OK
[    9.240707] raid6test: test_disks(27, 40): faila=3D 27(D)  failb=3D 40(D=
)  OK
[    9.243360] raid6test: test_disks(27, 41): faila=3D 27(D)  failb=3D 41(D=
)  OK
[    9.246153] raid6test: test_disks(27, 42): faila=3D 27(D)  failb=3D 42(D=
)  OK
[    9.248891] raid6test: test_disks(27, 43): faila=3D 27(D)  failb=3D 43(D=
)  OK
[    9.251738] raid6test: test_disks(27, 44): faila=3D 27(D)  failb=3D 44(D=
)  OK
[    9.254473] raid6test: test_disks(27, 45): faila=3D 27(D)  failb=3D 45(D=
)  OK
[    9.257186] raid6test: test_disks(27, 46): faila=3D 27(D)  failb=3D 46(D=
)  OK
[    9.259809] raid6test: test_disks(27, 47): faila=3D 27(D)  failb=3D 47(D=
)  OK
[    9.262407] raid6test: test_disks(27, 48): faila=3D 27(D)  failb=3D 48(D=
)  OK
[    9.265079] raid6test: test_disks(27, 49): faila=3D 27(D)  failb=3D 49(D=
)  OK
[    9.267740] raid6test: test_disks(27, 50): faila=3D 27(D)  failb=3D 50(D=
)  OK
[    9.270348] raid6test: test_disks(27, 51): faila=3D 27(D)  failb=3D 51(D=
)  OK
[    9.273077] raid6test: test_disks(27, 52): faila=3D 27(D)  failb=3D 52(D=
)  OK
[    9.275771] raid6test: test_disks(27, 53): faila=3D 27(D)  failb=3D 53(D=
)  OK
[    9.278528] raid6test: test_disks(27, 54): faila=3D 27(D)  failb=3D 54(D=
)  OK
[    9.281292] raid6test: test_disks(27, 55): faila=3D 27(D)  failb=3D 55(D=
)  OK
[    9.284079] raid6test: test_disks(27, 56): faila=3D 27(D)  failb=3D 56(D=
)  OK
[    9.286670] raid6test: test_disks(27, 57): faila=3D 27(D)  failb=3D 57(D=
)  OK
[    9.302883] raid6test: test_disks(27, 58): faila=3D 27(D)  failb=3D 58(D=
)  OK
[    9.305687] raid6test: test_disks(27, 59): faila=3D 27(D)  failb=3D 59(D=
)  OK
[    9.308477] raid6test: test_disks(27, 60): faila=3D 27(D)  failb=3D 60(D=
)  OK
[    9.311251] raid6test: test_disks(27, 61): faila=3D 27(D)  failb=3D 61(D=
)  OK
[    9.314043] raid6test: test_disks(27, 62): faila=3D 27(D)  failb=3D 62(P=
)  OK
[    9.316826] raid6test: test_disks(27, 63): faila=3D 27(D)  failb=3D 63(Q=
)  OK
[    9.319647] raid6test: test_disks(28, 29): faila=3D 28(D)  failb=3D 29(D=
)  OK
[    9.322423] raid6test: test_disks(28, 30): faila=3D 28(D)  failb=3D 30(D=
)  OK
[    9.325222] raid6test: test_disks(28, 31): faila=3D 28(D)  failb=3D 31(D=
)  OK
[    9.328041] raid6test: test_disks(28, 32): faila=3D 28(D)  failb=3D 32(D=
)  OK
[    9.330770] raid6test: test_disks(28, 33): faila=3D 28(D)  failb=3D 33(D=
)  OK
[    9.333535] raid6test: test_disks(28, 34): faila=3D 28(D)  failb=3D 34(D=
)  OK
[    9.336275] raid6test: test_disks(28, 35): faila=3D 28(D)  failb=3D 35(D=
)  OK
[    9.339082] raid6test: test_disks(28, 36): faila=3D 28(D)  failb=3D 36(D=
)  OK
[    9.341860] raid6test: test_disks(28, 37): faila=3D 28(D)  failb=3D 37(D=
)  OK
[    9.344661] raid6test: test_disks(28, 38): faila=3D 28(D)  failb=3D 38(D=
)  OK
[    9.347442] raid6test: test_disks(28, 39): faila=3D 28(D)  failb=3D 39(D=
)  OK
[    9.350216] raid6test: test_disks(28, 40): faila=3D 28(D)  failb=3D 40(D=
)  OK
[    9.353043] raid6test: test_disks(28, 41): faila=3D 28(D)  failb=3D 41(D=
)  OK
[    9.355841] raid6test: test_disks(28, 42): faila=3D 28(D)  failb=3D 42(D=
)  OK
[    9.358587] raid6test: test_disks(28, 43): faila=3D 28(D)  failb=3D 43(D=
)  OK
[    9.361352] raid6test: test_disks(28, 44): faila=3D 28(D)  failb=3D 44(D=
)  OK
[    9.364186] raid6test: test_disks(28, 45): faila=3D 28(D)  failb=3D 45(D=
)  OK
[    9.366986] raid6test: test_disks(28, 46): faila=3D 28(D)  failb=3D 46(D=
)  OK
[    9.369782] raid6test: test_disks(28, 47): faila=3D 28(D)  failb=3D 47(D=
)  OK
[    9.372599] raid6test: test_disks(28, 48): faila=3D 28(D)  failb=3D 48(D=
)  OK
[    9.375453] raid6test: test_disks(28, 49): faila=3D 28(D)  failb=3D 49(D=
)  OK
[    9.378199] raid6test: test_disks(28, 50): faila=3D 28(D)  failb=3D 50(D=
)  OK
[    9.381048] raid6test: test_disks(28, 51): faila=3D 28(D)  failb=3D 51(D=
)  OK
[    9.383783] raid6test: test_disks(28, 52): faila=3D 28(D)  failb=3D 52(D=
)  OK
[    9.386535] raid6test: test_disks(28, 53): faila=3D 28(D)  failb=3D 53(D=
)  OK
[    9.389355] raid6test: test_disks(28, 54): faila=3D 28(D)  failb=3D 54(D=
)  OK
[    9.392223] raid6test: test_disks(28, 55): faila=3D 28(D)  failb=3D 55(D=
)  OK
[    9.394922] raid6test: test_disks(28, 56): faila=3D 28(D)  failb=3D 56(D=
)  OK
[    9.397673] raid6test: test_disks(28, 57): faila=3D 28(D)  failb=3D 57(D=
)  OK
[    9.400440] raid6test: test_disks(28, 58): faila=3D 28(D)  failb=3D 58(D=
)  OK
[    9.403254] raid6test: test_disks(28, 59): faila=3D 28(D)  failb=3D 59(D=
)  OK
[    9.405994] raid6test: test_disks(28, 60): faila=3D 28(D)  failb=3D 60(D=
)  OK
[    9.408890] raid6test: test_disks(28, 61): faila=3D 28(D)  failb=3D 61(D=
)  OK
[    9.411709] raid6test: test_disks(28, 62): faila=3D 28(D)  failb=3D 62(P=
)  OK
[    9.414546] raid6test: test_disks(28, 63): faila=3D 28(D)  failb=3D 63(Q=
)  OK
[    9.417326] raid6test: test_disks(29, 30): faila=3D 29(D)  failb=3D 30(D=
)  OK
[    9.420123] raid6test: test_disks(29, 31): faila=3D 29(D)  failb=3D 31(D=
)  OK
[    9.422894] raid6test: test_disks(29, 32): faila=3D 29(D)  failb=3D 32(D=
)  OK
[    9.425622] raid6test: test_disks(29, 33): faila=3D 29(D)  failb=3D 33(D=
)  OK
[    9.428309] raid6test: test_disks(29, 34): faila=3D 29(D)  failb=3D 34(D=
)  OK
[    9.431179] raid6test: test_disks(29, 35): faila=3D 29(D)  failb=3D 35(D=
)  OK
[    9.433957] raid6test: test_disks(29, 36): faila=3D 29(D)  failb=3D 36(D=
)  OK
[    9.436785] raid6test: test_disks(29, 37): faila=3D 29(D)  failb=3D 37(D=
)  OK
[    9.439522] raid6test: test_disks(29, 38): faila=3D 29(D)  failb=3D 38(D=
)  OK
[    9.442328] raid6test: test_disks(29, 39): faila=3D 29(D)  failb=3D 39(D=
)  OK
[    9.445143] raid6test: test_disks(29, 40): faila=3D 29(D)  failb=3D 40(D=
)  OK
[    9.447931] raid6test: test_disks(29, 41): faila=3D 29(D)  failb=3D 41(D=
)  OK
[    9.450687] raid6test: test_disks(29, 42): faila=3D 29(D)  failb=3D 42(D=
)  OK
[    9.453494] raid6test: test_disks(29, 43): faila=3D 29(D)  failb=3D 43(D=
)  OK
[    9.456234] raid6test: test_disks(29, 44): faila=3D 29(D)  failb=3D 44(D=
)  OK
[    9.458999] raid6test: test_disks(29, 45): faila=3D 29(D)  failb=3D 45(D=
)  OK
[    9.461792] raid6test: test_disks(29, 46): faila=3D 29(D)  failb=3D 46(D=
)  OK
[    9.464555] raid6test: test_disks(29, 47): faila=3D 29(D)  failb=3D 47(D=
)  OK
[    9.467359] raid6test: test_disks(29, 48): faila=3D 29(D)  failb=3D 48(D=
)  OK
[    9.470524] raid6test: test_disks(29, 49): faila=3D 29(D)  failb=3D 49(D=
)  OK
[    9.473732] raid6test: test_disks(29, 50): faila=3D 29(D)  failb=3D 50(D=
)  OK
[    9.476513] raid6test: test_disks(29, 51): faila=3D 29(D)  failb=3D 51(D=
)  OK
[    9.479313] raid6test: test_disks(29, 52): faila=3D 29(D)  failb=3D 52(D=
)  OK
[    9.482089] raid6test: test_disks(29, 53): faila=3D 29(D)  failb=3D 53(D=
)  OK
[    9.484946] raid6test: test_disks(29, 54): faila=3D 29(D)  failb=3D 54(D=
)  OK
[    9.487719] raid6test: test_disks(29, 55): faila=3D 29(D)  failb=3D 55(D=
)  OK
[    9.490521] raid6test: test_disks(29, 56): faila=3D 29(D)  failb=3D 56(D=
)  OK
[    9.493301] raid6test: test_disks(29, 57): faila=3D 29(D)  failb=3D 57(D=
)  OK
[    9.496159] raid6test: test_disks(29, 58): faila=3D 29(D)  failb=3D 58(D=
)  OK
[    9.499044] raid6test: test_disks(29, 59): faila=3D 29(D)  failb=3D 59(D=
)  OK
[    9.501833] raid6test: test_disks(29, 60): faila=3D 29(D)  failb=3D 60(D=
)  OK
[    9.504678] raid6test: test_disks(29, 61): faila=3D 29(D)  failb=3D 61(D=
)  OK
[    9.507403] raid6test: test_disks(29, 62): faila=3D 29(D)  failb=3D 62(P=
)  OK
[    9.510294] raid6test: test_disks(29, 63): faila=3D 29(D)  failb=3D 63(Q=
)  OK
[    9.513128] raid6test: test_disks(30, 31): faila=3D 30(D)  failb=3D 31(D=
)  OK
[    9.515891] raid6test: test_disks(30, 32): faila=3D 30(D)  failb=3D 32(D=
)  OK
[    9.518694] raid6test: test_disks(30, 33): faila=3D 30(D)  failb=3D 33(D=
)  OK
[    9.521517] raid6test: test_disks(30, 34): faila=3D 30(D)  failb=3D 34(D=
)  OK
[    9.524276] raid6test: test_disks(30, 35): faila=3D 30(D)  failb=3D 35(D=
)  OK
[    9.527101] raid6test: test_disks(30, 36): faila=3D 30(D)  failb=3D 36(D=
)  OK
[    9.529921] raid6test: test_disks(30, 37): faila=3D 30(D)  failb=3D 37(D=
)  OK
[    9.532771] raid6test: test_disks(30, 38): faila=3D 30(D)  failb=3D 38(D=
)  OK
[    9.535522] raid6test: test_disks(30, 39): faila=3D 30(D)  failb=3D 39(D=
)  OK
[    9.538299] raid6test: test_disks(30, 40): faila=3D 30(D)  failb=3D 40(D=
)  OK
[    9.541198] raid6test: test_disks(30, 41): faila=3D 30(D)  failb=3D 41(D=
)  OK
[    9.543844] raid6test: test_disks(30, 42): faila=3D 30(D)  failb=3D 42(D=
)  OK
[    9.546639] raid6test: test_disks(30, 43): faila=3D 30(D)  failb=3D 43(D=
)  OK
[    9.549485] raid6test: test_disks(30, 44): faila=3D 30(D)  failb=3D 44(D=
)  OK
[    9.552316] raid6test: test_disks(30, 45): faila=3D 30(D)  failb=3D 45(D=
)  OK
[    9.555036] raid6test: test_disks(30, 46): faila=3D 30(D)  failb=3D 46(D=
)  OK
[    9.557847] raid6test: test_disks(30, 47): faila=3D 30(D)  failb=3D 47(D=
)  OK
[    9.560616] raid6test: test_disks(30, 48): faila=3D 30(D)  failb=3D 48(D=
)  OK
[    9.563426] raid6test: test_disks(30, 49): faila=3D 30(D)  failb=3D 49(D=
)  OK
[    9.566256] raid6test: test_disks(30, 50): faila=3D 30(D)  failb=3D 50(D=
)  OK
[    9.569099] raid6test: test_disks(30, 51): faila=3D 30(D)  failb=3D 51(D=
)  OK
[    9.571853] raid6test: test_disks(30, 52): faila=3D 30(D)  failb=3D 52(D=
)  OK
[    9.574698] raid6test: test_disks(30, 53): faila=3D 30(D)  failb=3D 53(D=
)  OK
[    9.577453] raid6test: test_disks(30, 54): faila=3D 30(D)  failb=3D 54(D=
)  OK
[    9.580287] raid6test: test_disks(30, 55): faila=3D 30(D)  failb=3D 55(D=
)  OK
[    9.583131] raid6test: test_disks(30, 56): faila=3D 30(D)  failb=3D 56(D=
)  OK
[    9.585872] raid6test: test_disks(30, 57): faila=3D 30(D)  failb=3D 57(D=
)  OK
[    9.588701] raid6test: test_disks(30, 58): faila=3D 30(D)  failb=3D 58(D=
)  OK
[    9.591541] raid6test: test_disks(30, 59): faila=3D 30(D)  failb=3D 59(D=
)  OK
[    9.594386] raid6test: test_disks(30, 60): faila=3D 30(D)  failb=3D 60(D=
)  OK
[    9.597222] raid6test: test_disks(30, 61): faila=3D 30(D)  failb=3D 61(D=
)  OK
[    9.600131] raid6test: test_disks(30, 62): faila=3D 30(D)  failb=3D 62(P=
)  OK
[    9.602885] raid6test: test_disks(30, 63): faila=3D 30(D)  failb=3D 63(Q=
)  OK
[    9.605750] raid6test: test_disks(31, 32): faila=3D 31(D)  failb=3D 32(D=
)  OK
[    9.608505] raid6test: test_disks(31, 33): faila=3D 31(D)  failb=3D 33(D=
)  OK
[    9.611343] raid6test: test_disks(31, 34): faila=3D 31(D)  failb=3D 34(D=
)  OK
[    9.613965] raid6test: test_disks(31, 35): faila=3D 31(D)  failb=3D 35(D=
)  OK
[    9.616728] raid6test: test_disks(31, 36): faila=3D 31(D)  failb=3D 36(D=
)  OK
[    9.619494] raid6test: test_disks(31, 37): faila=3D 31(D)  failb=3D 37(D=
)  OK
[    9.622419] raid6test: test_disks(31, 38): faila=3D 31(D)  failb=3D 38(D=
)  OK
[    9.625272] raid6test: test_disks(31, 39): faila=3D 31(D)  failb=3D 39(D=
)  OK
[    9.628116] raid6test: test_disks(31, 40): faila=3D 31(D)  failb=3D 40(D=
)  OK
[    9.630758] raid6test: test_disks(31, 41): faila=3D 31(D)  failb=3D 41(D=
)  OK
[    9.633468] raid6test: test_disks(31, 42): faila=3D 31(D)  failb=3D 42(D=
)  OK
[    9.636295] raid6test: test_disks(31, 43): faila=3D 31(D)  failb=3D 43(D=
)  OK
[    9.639073] raid6test: test_disks(31, 44): faila=3D 31(D)  failb=3D 44(D=
)  OK
[    9.641887] raid6test: test_disks(31, 45): faila=3D 31(D)  failb=3D 45(D=
)  OK
[    9.644699] raid6test: test_disks(31, 46): faila=3D 31(D)  failb=3D 46(D=
)  OK
[    9.647501] raid6test: test_disks(31, 47): faila=3D 31(D)  failb=3D 47(D=
)  OK
[    9.650332] raid6test: test_disks(31, 48): faila=3D 31(D)  failb=3D 48(D=
)  OK
[    9.653137] raid6test: test_disks(31, 49): faila=3D 31(D)  failb=3D 49(D=
)  OK
[    9.655916] raid6test: test_disks(31, 50): faila=3D 31(D)  failb=3D 50(D=
)  OK
[    9.658685] raid6test: test_disks(31, 51): faila=3D 31(D)  failb=3D 51(D=
)  OK
[    9.661456] raid6test: test_disks(31, 52): faila=3D 31(D)  failb=3D 52(D=
)  OK
[    9.664230] raid6test: test_disks(31, 53): faila=3D 31(D)  failb=3D 53(D=
)  OK
[    9.667018] raid6test: test_disks(31, 54): faila=3D 31(D)  failb=3D 54(D=
)  OK
[    9.669842] raid6test: test_disks(31, 55): faila=3D 31(D)  failb=3D 55(D=
)  OK
[    9.672597] raid6test: test_disks(31, 56): faila=3D 31(D)  failb=3D 56(D=
)  OK
[    9.675357] raid6test: test_disks(31, 57): faila=3D 31(D)  failb=3D 57(D=
)  OK
[    9.678146] raid6test: test_disks(31, 58): faila=3D 31(D)  failb=3D 58(D=
)  OK
[    9.680971] raid6test: test_disks(31, 59): faila=3D 31(D)  failb=3D 59(D=
)  OK
[    9.683715] raid6test: test_disks(31, 60): faila=3D 31(D)  failb=3D 60(D=
)  OK
[    9.686516] raid6test: test_disks(31, 61): faila=3D 31(D)  failb=3D 61(D=
)  OK
[    9.689244] raid6test: test_disks(31, 62): faila=3D 31(D)  failb=3D 62(P=
)  OK
[    9.691982] raid6test: test_disks(31, 63): faila=3D 31(D)  failb=3D 63(Q=
)  OK
[    9.694749] raid6test: test_disks(32, 33): faila=3D 32(D)  failb=3D 33(D=
)  OK
[    9.697524] raid6test: test_disks(32, 34): faila=3D 32(D)  failb=3D 34(D=
)  OK
[    9.700301] raid6test: test_disks(32, 35): faila=3D 32(D)  failb=3D 35(D=
)  OK
[    9.703168] raid6test: test_disks(32, 36): faila=3D 32(D)  failb=3D 36(D=
)  OK
[    9.706049] raid6test: test_disks(32, 37): faila=3D 32(D)  failb=3D 37(D=
)  OK
[    9.708808] raid6test: test_disks(32, 38): faila=3D 32(D)  failb=3D 38(D=
)  OK
[    9.711611] raid6test: test_disks(32, 39): faila=3D 32(D)  failb=3D 39(D=
)  OK
[    9.714316] raid6test: test_disks(32, 40): faila=3D 32(D)  failb=3D 40(D=
)  OK
[    9.717173] raid6test: test_disks(32, 41): faila=3D 32(D)  failb=3D 41(D=
)  OK
[    9.719975] raid6test: test_disks(32, 42): faila=3D 32(D)  failb=3D 42(D=
)  OK
[    9.722814] raid6test: test_disks(32, 43): faila=3D 32(D)  failb=3D 43(D=
)  OK
[    9.725645] raid6test: test_disks(32, 44): faila=3D 32(D)  failb=3D 44(D=
)  OK
[    9.728422] raid6test: test_disks(32, 45): faila=3D 32(D)  failb=3D 45(D=
)  OK
[    9.731161] raid6test: test_disks(32, 46): faila=3D 32(D)  failb=3D 46(D=
)  OK
[    9.733975] raid6test: test_disks(32, 47): faila=3D 32(D)  failb=3D 47(D=
)  OK
[    9.736850] raid6test: test_disks(32, 48): faila=3D 32(D)  failb=3D 48(D=
)  OK
[    9.739553] raid6test: test_disks(32, 49): faila=3D 32(D)  failb=3D 49(D=
)  OK
[    9.742348] raid6test: test_disks(32, 50): faila=3D 32(D)  failb=3D 50(D=
)  OK
[    9.745159] raid6test: test_disks(32, 51): faila=3D 32(D)  failb=3D 51(D=
)  OK
[    9.749025] raid6test: test_disks(32, 52): faila=3D 32(D)  failb=3D 52(D=
)  OK
[    9.751841] raid6test: test_disks(32, 53): faila=3D 32(D)  failb=3D 53(D=
)  OK
[    9.754554] raid6test: test_disks(32, 54): faila=3D 32(D)  failb=3D 54(D=
)  OK
[    9.757384] raid6test: test_disks(32, 55): faila=3D 32(D)  failb=3D 55(D=
)  OK
[    9.760194] raid6test: test_disks(32, 56): faila=3D 32(D)  failb=3D 56(D=
)  OK
[    9.762973] raid6test: test_disks(32, 57): faila=3D 32(D)  failb=3D 57(D=
)  OK
[    9.765823] raid6test: test_disks(32, 58): faila=3D 32(D)  failb=3D 58(D=
)  OK
[    9.768585] raid6test: test_disks(32, 59): faila=3D 32(D)  failb=3D 59(D=
)  OK
[    9.771394] raid6test: test_disks(32, 60): faila=3D 32(D)  failb=3D 60(D=
)  OK
[    9.774239] raid6test: test_disks(32, 61): faila=3D 32(D)  failb=3D 61(D=
)  OK
[    9.777047] raid6test: test_disks(32, 62): faila=3D 32(D)  failb=3D 62(P=
)  OK
[    9.779657] raid6test: test_disks(32, 63): faila=3D 32(D)  failb=3D 63(Q=
)  OK
[    9.782387] raid6test: test_disks(33, 34): faila=3D 33(D)  failb=3D 34(D=
)  OK
[    9.785216] raid6test: test_disks(33, 35): faila=3D 33(D)  failb=3D 35(D=
)  OK
[    9.787965] raid6test: test_disks(33, 36): faila=3D 33(D)  failb=3D 36(D=
)  OK
[    9.790675] raid6test: test_disks(33, 37): faila=3D 33(D)  failb=3D 37(D=
)  OK
[    9.793524] raid6test: test_disks(33, 38): faila=3D 33(D)  failb=3D 38(D=
)  OK
[    9.796231] raid6test: test_disks(33, 39): faila=3D 33(D)  failb=3D 39(D=
)  OK
[    9.798781] raid6test: test_disks(33, 40): faila=3D 33(D)  failb=3D 40(D=
)  OK
[    9.801483] raid6test: test_disks(33, 41): faila=3D 33(D)  failb=3D 41(D=
)  OK
[    9.804218] raid6test: test_disks(33, 42): faila=3D 33(D)  failb=3D 42(D=
)  OK
[    9.820714] raid6test: test_disks(33, 43): faila=3D 33(D)  failb=3D 43(D=
)  OK
[    9.823541] raid6test: test_disks(33, 44): faila=3D 33(D)  failb=3D 44(D=
)  OK
[    9.826413] raid6test: test_disks(33, 45): faila=3D 33(D)  failb=3D 45(D=
)  OK
[    9.829238] raid6test: test_disks(33, 46): faila=3D 33(D)  failb=3D 46(D=
)  OK
[    9.831923] raid6test: test_disks(33, 47): faila=3D 33(D)  failb=3D 47(D=
)  OK
[    9.834793] raid6test: test_disks(33, 48): faila=3D 33(D)  failb=3D 48(D=
)  OK
[    9.837610] raid6test: test_disks(33, 49): faila=3D 33(D)  failb=3D 49(D=
)  OK
[    9.840391] raid6test: test_disks(33, 50): faila=3D 33(D)  failb=3D 50(D=
)  OK
[    9.843182] raid6test: test_disks(33, 51): faila=3D 33(D)  failb=3D 51(D=
)  OK
[    9.845949] raid6test: test_disks(33, 52): faila=3D 33(D)  failb=3D 52(D=
)  OK
[    9.848810] raid6test: test_disks(33, 53): faila=3D 33(D)  failb=3D 53(D=
)  OK
[    9.851542] raid6test: test_disks(33, 54): faila=3D 33(D)  failb=3D 54(D=
)  OK
[    9.854343] raid6test: test_disks(33, 55): faila=3D 33(D)  failb=3D 55(D=
)  OK
[    9.857188] raid6test: test_disks(33, 56): faila=3D 33(D)  failb=3D 56(D=
)  OK
[    9.859961] raid6test: test_disks(33, 57): faila=3D 33(D)  failb=3D 57(D=
)  OK
[    9.862726] raid6test: test_disks(33, 58): faila=3D 33(D)  failb=3D 58(D=
)  OK
[    9.865579] raid6test: test_disks(33, 59): faila=3D 33(D)  failb=3D 59(D=
)  OK
[    9.868363] raid6test: test_disks(33, 60): faila=3D 33(D)  failb=3D 60(D=
)  OK
[    9.871209] raid6test: test_disks(33, 61): faila=3D 33(D)  failb=3D 61(D=
)  OK
[    9.873968] raid6test: test_disks(33, 62): faila=3D 33(D)  failb=3D 62(P=
)  OK
[    9.876777] raid6test: test_disks(33, 63): faila=3D 33(D)  failb=3D 63(Q=
)  OK
[    9.879551] raid6test: test_disks(34, 35): faila=3D 34(D)  failb=3D 35(D=
)  OK
[    9.882297] raid6test: test_disks(34, 36): faila=3D 34(D)  failb=3D 36(D=
)  OK
[    9.885163] raid6test: test_disks(34, 37): faila=3D 34(D)  failb=3D 37(D=
)  OK
[    9.887964] raid6test: test_disks(34, 38): faila=3D 34(D)  failb=3D 38(D=
)  OK
[    9.890658] raid6test: test_disks(34, 39): faila=3D 34(D)  failb=3D 39(D=
)  OK
[    9.893505] raid6test: test_disks(34, 40): faila=3D 34(D)  failb=3D 40(D=
)  OK
[    9.896288] raid6test: test_disks(34, 41): faila=3D 34(D)  failb=3D 41(D=
)  OK
[    9.899115] raid6test: test_disks(34, 42): faila=3D 34(D)  failb=3D 42(D=
)  OK
[    9.901953] raid6test: test_disks(34, 43): faila=3D 34(D)  failb=3D 43(D=
)  OK
[    9.904779] raid6test: test_disks(34, 44): faila=3D 34(D)  failb=3D 44(D=
)  OK
[    9.907585] raid6test: test_disks(34, 45): faila=3D 34(D)  failb=3D 45(D=
)  OK
[    9.910319] raid6test: test_disks(34, 46): faila=3D 34(D)  failb=3D 46(D=
)  OK
[    9.913153] raid6test: test_disks(34, 47): faila=3D 34(D)  failb=3D 47(D=
)  OK
[    9.915979] raid6test: test_disks(34, 48): faila=3D 34(D)  failb=3D 48(D=
)  OK
[    9.918748] raid6test: test_disks(34, 49): faila=3D 34(D)  failb=3D 49(D=
)  OK
[    9.921511] raid6test: test_disks(34, 50): faila=3D 34(D)  failb=3D 50(D=
)  OK
[    9.924289] raid6test: test_disks(34, 51): faila=3D 34(D)  failb=3D 51(D=
)  OK
[    9.927133] raid6test: test_disks(34, 52): faila=3D 34(D)  failb=3D 52(D=
)  OK
[    9.929920] raid6test: test_disks(34, 53): faila=3D 34(D)  failb=3D 53(D=
)  OK
[    9.932680] raid6test: test_disks(34, 54): faila=3D 34(D)  failb=3D 54(D=
)  OK
[    9.935476] raid6test: test_disks(34, 55): faila=3D 34(D)  failb=3D 55(D=
)  OK
[    9.938264] raid6test: test_disks(34, 56): faila=3D 34(D)  failb=3D 56(D=
)  OK
[    9.941057] raid6test: test_disks(34, 57): faila=3D 34(D)  failb=3D 57(D=
)  OK
[    9.943800] raid6test: test_disks(34, 58): faila=3D 34(D)  failb=3D 58(D=
)  OK
[    9.946617] raid6test: test_disks(34, 59): faila=3D 34(D)  failb=3D 59(D=
)  OK
[    9.949374] raid6test: test_disks(34, 60): faila=3D 34(D)  failb=3D 60(D=
)  OK
[    9.952162] raid6test: test_disks(34, 61): faila=3D 34(D)  failb=3D 61(D=
)  OK
[    9.954974] raid6test: test_disks(34, 62): faila=3D 34(D)  failb=3D 62(P=
)  OK
[    9.957734] raid6test: test_disks(34, 63): faila=3D 34(D)  failb=3D 63(Q=
)  OK
[    9.960559] raid6test: test_disks(35, 36): faila=3D 35(D)  failb=3D 36(D=
)  OK
[    9.963321] raid6test: test_disks(35, 37): faila=3D 35(D)  failb=3D 37(D=
)  OK
[    9.966182] raid6test: test_disks(35, 38): faila=3D 35(D)  failb=3D 38(D=
)  OK
[    9.968976] raid6test: test_disks(35, 39): faila=3D 35(D)  failb=3D 39(D=
)  OK
[    9.971798] raid6test: test_disks(35, 40): faila=3D 35(D)  failb=3D 40(D=
)  OK
[    9.974612] raid6test: test_disks(35, 41): faila=3D 35(D)  failb=3D 41(D=
)  OK
[    9.977402] raid6test: test_disks(35, 42): faila=3D 35(D)  failb=3D 42(D=
)  OK
[    9.980226] raid6test: test_disks(35, 43): faila=3D 35(D)  failb=3D 43(D=
)  OK
[    9.983085] raid6test: test_disks(35, 44): faila=3D 35(D)  failb=3D 44(D=
)  OK
[    9.985880] raid6test: test_disks(35, 45): faila=3D 35(D)  failb=3D 45(D=
)  OK
[    9.988611] raid6test: test_disks(35, 46): faila=3D 35(D)  failb=3D 46(D=
)  OK
[    9.991434] raid6test: test_disks(35, 47): faila=3D 35(D)  failb=3D 47(D=
)  OK
[    9.994217] raid6test: test_disks(35, 48): faila=3D 35(D)  failb=3D 48(D=
)  OK
[    9.996984] raid6test: test_disks(35, 49): faila=3D 35(D)  failb=3D 49(D=
)  OK
[    9.999722] raid6test: test_disks(35, 50): faila=3D 35(D)  failb=3D 50(D=
)  OK
[   10.002475] raid6test: test_disks(35, 51): faila=3D 35(D)  failb=3D 51(D=
)  OK
[   10.005246] raid6test: test_disks(35, 52): faila=3D 35(D)  failb=3D 52(D=
)  OK
[   10.008016] raid6test: test_disks(35, 53): faila=3D 35(D)  failb=3D 53(D=
)  OK
[   10.010770] raid6test: test_disks(35, 54): faila=3D 35(D)  failb=3D 54(D=
)  OK
[   10.013554] raid6test: test_disks(35, 55): faila=3D 35(D)  failb=3D 55(D=
)  OK
[   10.016347] raid6test: test_disks(35, 56): faila=3D 35(D)  failb=3D 56(D=
)  OK
[   10.019177] raid6test: test_disks(35, 57): faila=3D 35(D)  failb=3D 57(D=
)  OK
[   10.021970] raid6test: test_disks(35, 58): faila=3D 35(D)  failb=3D 58(D=
)  OK
[   10.024774] raid6test: test_disks(35, 59): faila=3D 35(D)  failb=3D 59(D=
)  OK
[   10.027498] raid6test: test_disks(35, 60): faila=3D 35(D)  failb=3D 60(D=
)  OK
[   10.030247] raid6test: test_disks(35, 61): faila=3D 35(D)  failb=3D 61(D=
)  OK
[   10.033083] raid6test: test_disks(35, 62): faila=3D 35(D)  failb=3D 62(P=
)  OK
[   10.035880] raid6test: test_disks(35, 63): faila=3D 35(D)  failb=3D 63(Q=
)  OK
[   10.038700] raid6test: test_disks(36, 37): faila=3D 36(D)  failb=3D 37(D=
)  OK
[   10.041493] raid6test: test_disks(36, 38): faila=3D 36(D)  failb=3D 38(D=
)  OK
[   10.044309] raid6test: test_disks(36, 39): faila=3D 36(D)  failb=3D 39(D=
)  OK
[   10.047199] raid6test: test_disks(36, 40): faila=3D 36(D)  failb=3D 40(D=
)  OK
[   10.049998] raid6test: test_disks(36, 41): faila=3D 36(D)  failb=3D 41(D=
)  OK
[   10.052824] raid6test: test_disks(36, 42): faila=3D 36(D)  failb=3D 42(D=
)  OK
[   10.055583] raid6test: test_disks(36, 43): faila=3D 36(D)  failb=3D 43(D=
)  OK
[   10.058461] raid6test: test_disks(36, 44): faila=3D 36(D)  failb=3D 44(D=
)  OK
[   10.061294] raid6test: test_disks(36, 45): faila=3D 36(D)  failb=3D 45(D=
)  OK
[   10.064131] raid6test: test_disks(36, 46): faila=3D 36(D)  failb=3D 46(D=
)  OK
[   10.066962] raid6test: test_disks(36, 47): faila=3D 36(D)  failb=3D 47(D=
)  OK
[   10.069706] raid6test: test_disks(36, 48): faila=3D 36(D)  failb=3D 48(D=
)  OK
[   10.072522] raid6test: test_disks(36, 49): faila=3D 36(D)  failb=3D 49(D=
)  OK
[   10.075353] raid6test: test_disks(36, 50): faila=3D 36(D)  failb=3D 50(D=
)  OK
[   10.078153] raid6test: test_disks(36, 51): faila=3D 36(D)  failb=3D 51(D=
)  OK
[   10.080909] raid6test: test_disks(36, 52): faila=3D 36(D)  failb=3D 52(D=
)  OK
[   10.083699] raid6test: test_disks(36, 53): faila=3D 36(D)  failb=3D 53(D=
)  OK
[   10.086489] raid6test: test_disks(36, 54): faila=3D 36(D)  failb=3D 54(D=
)  OK
[   10.089259] raid6test: test_disks(36, 55): faila=3D 36(D)  failb=3D 55(D=
)  OK
[   10.091978] raid6test: test_disks(36, 56): faila=3D 36(D)  failb=3D 56(D=
)  OK
[   10.094964] raid6test: test_disks(36, 57): faila=3D 36(D)  failb=3D 57(D=
)  OK
[   10.097711] raid6test: test_disks(36, 58): faila=3D 36(D)  failb=3D 58(D=
)  OK
[   10.100154] raid6test: test_disks(36, 59): faila=3D 36(D)  failb=3D 59(D=
)  OK
[   10.103082] raid6test: test_disks(36, 60): faila=3D 36(D)  failb=3D 60(D=
)  OK
[   10.105827] raid6test: test_disks(36, 61): faila=3D 36(D)  failb=3D 61(D=
)  OK
[   10.108403] raid6test: test_disks(36, 62): faila=3D 36(D)  failb=3D 62(P=
)  OK
[   10.110932] raid6test: test_disks(36, 63): faila=3D 36(D)  failb=3D 63(Q=
)  OK
[   10.113433] raid6test: test_disks(37, 38): faila=3D 37(D)  failb=3D 38(D=
)  OK
[   10.116069] raid6test: test_disks(37, 39): faila=3D 37(D)  failb=3D 39(D=
)  OK
[   10.118818] raid6test: test_disks(37, 40): faila=3D 37(D)  failb=3D 40(D=
)  OK
[   10.121595] raid6test: test_disks(37, 41): faila=3D 37(D)  failb=3D 41(D=
)  OK
[   10.124307] raid6test: test_disks(37, 42): faila=3D 37(D)  failb=3D 42(D=
)  OK
[   10.127113] raid6test: test_disks(37, 43): faila=3D 37(D)  failb=3D 43(D=
)  OK
[   10.129863] raid6test: test_disks(37, 44): faila=3D 37(D)  failb=3D 44(D=
)  OK
[   10.132565] raid6test: test_disks(37, 45): faila=3D 37(D)  failb=3D 45(D=
)  OK
[   10.135355] raid6test: test_disks(37, 46): faila=3D 37(D)  failb=3D 46(D=
)  OK
[   10.138086] raid6test: test_disks(37, 47): faila=3D 37(D)  failb=3D 47(D=
)  OK
[   10.140833] raid6test: test_disks(37, 48): faila=3D 37(D)  failb=3D 48(D=
)  OK
[   10.143544] raid6test: test_disks(37, 49): faila=3D 37(D)  failb=3D 49(D=
)  OK
[   10.146305] raid6test: test_disks(37, 50): faila=3D 37(D)  failb=3D 50(D=
)  OK
[   10.149087] raid6test: test_disks(37, 51): faila=3D 37(D)  failb=3D 51(D=
)  OK
[   10.151834] raid6test: test_disks(37, 52): faila=3D 37(D)  failb=3D 52(D=
)  OK
[   10.154529] raid6test: test_disks(37, 53): faila=3D 37(D)  failb=3D 53(D=
)  OK
[   10.157278] raid6test: test_disks(37, 54): faila=3D 37(D)  failb=3D 54(D=
)  OK
[   10.159939] raid6test: test_disks(37, 55): faila=3D 37(D)  failb=3D 55(D=
)  OK
[   10.162631] raid6test: test_disks(37, 56): faila=3D 37(D)  failb=3D 56(D=
)  OK
[   10.165371] raid6test: test_disks(37, 57): faila=3D 37(D)  failb=3D 57(D=
)  OK
[   10.168128] raid6test: test_disks(37, 58): faila=3D 37(D)  failb=3D 58(D=
)  OK
[   10.170846] raid6test: test_disks(37, 59): faila=3D 37(D)  failb=3D 59(D=
)  OK
[   10.173522] raid6test: test_disks(37, 60): faila=3D 37(D)  failb=3D 60(D=
)  OK
[   10.176291] raid6test: test_disks(37, 61): faila=3D 37(D)  failb=3D 61(D=
)  OK
[   10.179004] raid6test: test_disks(37, 62): faila=3D 37(D)  failb=3D 62(P=
)  OK
[   10.181703] raid6test: test_disks(37, 63): faila=3D 37(D)  failb=3D 63(Q=
)  OK
[   10.184422] raid6test: test_disks(38, 39): faila=3D 38(D)  failb=3D 39(D=
)  OK
[   10.187130] raid6test: test_disks(38, 40): faila=3D 38(D)  failb=3D 40(D=
)  OK
[   10.189859] raid6test: test_disks(38, 41): faila=3D 38(D)  failb=3D 41(D=
)  OK
[   10.192610] raid6test: test_disks(38, 42): faila=3D 38(D)  failb=3D 42(D=
)  OK
[   10.195354] raid6test: test_disks(38, 43): faila=3D 38(D)  failb=3D 43(D=
)  OK
[   10.198165] raid6test: test_disks(38, 44): faila=3D 38(D)  failb=3D 44(D=
)  OK
[   10.200851] raid6test: test_disks(38, 45): faila=3D 38(D)  failb=3D 45(D=
)  OK
[   10.203600] raid6test: test_disks(38, 46): faila=3D 38(D)  failb=3D 46(D=
)  OK
[   10.206369] raid6test: test_disks(38, 47): faila=3D 38(D)  failb=3D 47(D=
)  OK
[   10.209189] raid6test: test_disks(38, 48): faila=3D 38(D)  failb=3D 48(D=
)  OK
[   10.211921] raid6test: test_disks(38, 49): faila=3D 38(D)  failb=3D 49(D=
)  OK
[   10.214696] raid6test: test_disks(38, 50): faila=3D 38(D)  failb=3D 50(D=
)  OK
[   10.217451] raid6test: test_disks(38, 51): faila=3D 38(D)  failb=3D 51(D=
)  OK
[   10.220230] raid6test: test_disks(38, 52): faila=3D 38(D)  failb=3D 52(D=
)  OK
[   10.222937] raid6test: test_disks(38, 53): faila=3D 38(D)  failb=3D 53(D=
)  OK
[   10.225658] raid6test: test_disks(38, 54): faila=3D 38(D)  failb=3D 54(D=
)  OK
[   10.228389] raid6test: test_disks(38, 55): faila=3D 38(D)  failb=3D 55(D=
)  OK
[   10.231118] raid6test: test_disks(38, 56): faila=3D 38(D)  failb=3D 56(D=
)  OK
[   10.233859] raid6test: test_disks(38, 57): faila=3D 38(D)  failb=3D 57(D=
)  OK
[   10.236589] raid6test: test_disks(38, 58): faila=3D 38(D)  failb=3D 58(D=
)  OK
[   10.239336] raid6test: test_disks(38, 59): faila=3D 38(D)  failb=3D 59(D=
)  OK
[   10.242240] raid6test: test_disks(38, 60): faila=3D 38(D)  failb=3D 60(D=
)  OK
[   10.244985] raid6test: test_disks(38, 61): faila=3D 38(D)  failb=3D 61(D=
)  OK
[   10.247612] raid6test: test_disks(38, 62): faila=3D 38(D)  failb=3D 62(P=
)  OK
[   10.250309] raid6test: test_disks(38, 63): faila=3D 38(D)  failb=3D 63(Q=
)  OK
[   10.253146] raid6test: test_disks(39, 40): faila=3D 39(D)  failb=3D 40(D=
)  OK
[   10.256060] raid6test: test_disks(39, 41): faila=3D 39(D)  failb=3D 41(D=
)  OK
[   10.258941] raid6test: test_disks(39, 42): faila=3D 39(D)  failb=3D 42(D=
)  OK
[   10.261829] raid6test: test_disks(39, 43): faila=3D 39(D)  failb=3D 43(D=
)  OK
[   10.264755] raid6test: test_disks(39, 44): faila=3D 39(D)  failb=3D 44(D=
)  OK
[   10.267679] raid6test: test_disks(39, 45): faila=3D 39(D)  failb=3D 45(D=
)  OK
[   10.270534] raid6test: test_disks(39, 46): faila=3D 39(D)  failb=3D 46(D=
)  OK
[   10.273460] raid6test: test_disks(39, 47): faila=3D 39(D)  failb=3D 47(D=
)  OK
[   10.276220] raid6test: test_disks(39, 48): faila=3D 39(D)  failb=3D 48(D=
)  OK
[   10.278879] raid6test: test_disks(39, 49): faila=3D 39(D)  failb=3D 49(D=
)  OK
[   10.281733] raid6test: test_disks(39, 50): faila=3D 39(D)  failb=3D 50(D=
)  OK
[   10.284585] raid6test: test_disks(39, 51): faila=3D 39(D)  failb=3D 51(D=
)  OK
[   10.287459] raid6test: test_disks(39, 52): faila=3D 39(D)  failb=3D 52(D=
)  OK
[   10.290394] raid6test: test_disks(39, 53): faila=3D 39(D)  failb=3D 53(D=
)  OK
[   10.293296] raid6test: test_disks(39, 54): faila=3D 39(D)  failb=3D 54(D=
)  OK
[   10.296142] raid6test: test_disks(39, 55): faila=3D 39(D)  failb=3D 55(D=
)  OK
[   10.299039] raid6test: test_disks(39, 56): faila=3D 39(D)  failb=3D 56(D=
)  OK
[   10.301938] raid6test: test_disks(39, 57): faila=3D 39(D)  failb=3D 57(D=
)  OK
[   10.304913] raid6test: test_disks(39, 58): faila=3D 39(D)  failb=3D 58(D=
)  OK
[   10.307812] raid6test: test_disks(39, 59): faila=3D 39(D)  failb=3D 59(D=
)  OK
[   10.310709] raid6test: test_disks(39, 60): faila=3D 39(D)  failb=3D 60(D=
)  OK
[   10.313582] raid6test: test_disks(39, 61): faila=3D 39(D)  failb=3D 61(D=
)  OK
[   10.316500] raid6test: test_disks(39, 62): faila=3D 39(D)  failb=3D 62(P=
)  OK
[   10.319367] raid6test: test_disks(39, 63): faila=3D 39(D)  failb=3D 63(Q=
)  OK
[   10.335611] raid6test: test_disks(40, 41): faila=3D 40(D)  failb=3D 41(D=
)  OK
[   10.338255] raid6test: test_disks(40, 42): faila=3D 40(D)  failb=3D 42(D=
)  OK
[   10.341047] raid6test: test_disks(40, 43): faila=3D 40(D)  failb=3D 43(D=
)  OK
[   10.343903] raid6test: test_disks(40, 44): faila=3D 40(D)  failb=3D 44(D=
)  OK
[   10.346652] raid6test: test_disks(40, 45): faila=3D 40(D)  failb=3D 45(D=
)  OK
[   10.349325] raid6test: test_disks(40, 46): faila=3D 40(D)  failb=3D 46(D=
)  OK
[   10.352077] raid6test: test_disks(40, 47): faila=3D 40(D)  failb=3D 47(D=
)  OK
[   10.354794] raid6test: test_disks(40, 48): faila=3D 40(D)  failb=3D 48(D=
)  OK
[   10.357614] raid6test: test_disks(40, 49): faila=3D 40(D)  failb=3D 49(D=
)  OK
[   10.360417] raid6test: test_disks(40, 50): faila=3D 40(D)  failb=3D 50(D=
)  OK
[   10.363240] raid6test: test_disks(40, 51): faila=3D 40(D)  failb=3D 51(D=
)  OK
[   10.366045] raid6test: test_disks(40, 52): faila=3D 40(D)  failb=3D 52(D=
)  OK
[   10.368869] raid6test: test_disks(40, 53): faila=3D 40(D)  failb=3D 53(D=
)  OK
[   10.371678] raid6test: test_disks(40, 54): faila=3D 40(D)  failb=3D 54(D=
)  OK
[   10.374411] raid6test: test_disks(40, 55): faila=3D 40(D)  failb=3D 55(D=
)  OK
[   10.377355] raid6test: test_disks(40, 56): faila=3D 40(D)  failb=3D 56(D=
)  OK
[   10.380058] raid6test: test_disks(40, 57): faila=3D 40(D)  failb=3D 57(D=
)  OK
[   10.382931] raid6test: test_disks(40, 58): faila=3D 40(D)  failb=3D 58(D=
)  OK
[   10.385805] raid6test: test_disks(40, 59): faila=3D 40(D)  failb=3D 59(D=
)  OK
[   10.388481] raid6test: test_disks(40, 60): faila=3D 40(D)  failb=3D 60(D=
)  OK
[   10.391320] raid6test: test_disks(40, 61): faila=3D 40(D)  failb=3D 61(D=
)  OK
[   10.394123] raid6test: test_disks(40, 62): faila=3D 40(D)  failb=3D 62(P=
)  OK
[   10.396956] raid6test: test_disks(40, 63): faila=3D 40(D)  failb=3D 63(Q=
)  OK
[   10.399782] raid6test: test_disks(41, 42): faila=3D 41(D)  failb=3D 42(D=
)  OK
[   10.402571] raid6test: test_disks(41, 43): faila=3D 41(D)  failb=3D 43(D=
)  OK
[   10.405315] raid6test: test_disks(41, 44): faila=3D 41(D)  failb=3D 44(D=
)  OK
[   10.408136] raid6test: test_disks(41, 45): faila=3D 41(D)  failb=3D 45(D=
)  OK
[   10.410920] raid6test: test_disks(41, 46): faila=3D 41(D)  failb=3D 46(D=
)  OK
[   10.413617] raid6test: test_disks(41, 47): faila=3D 41(D)  failb=3D 47(D=
)  OK
[   10.416359] raid6test: test_disks(41, 48): faila=3D 41(D)  failb=3D 48(D=
)  OK
[   10.419180] raid6test: test_disks(41, 49): faila=3D 41(D)  failb=3D 49(D=
)  OK
[   10.421982] raid6test: test_disks(41, 50): faila=3D 41(D)  failb=3D 50(D=
)  OK
[   10.424769] raid6test: test_disks(41, 51): faila=3D 41(D)  failb=3D 51(D=
)  OK
[   10.427577] raid6test: test_disks(41, 52): faila=3D 41(D)  failb=3D 52(D=
)  OK
[   10.430383] raid6test: test_disks(41, 53): faila=3D 41(D)  failb=3D 53(D=
)  OK
[   10.433207] raid6test: test_disks(41, 54): faila=3D 41(D)  failb=3D 54(D=
)  OK
[   10.436050] raid6test: test_disks(41, 55): faila=3D 41(D)  failb=3D 55(D=
)  OK
[   10.438641] raid6test: test_disks(41, 56): faila=3D 41(D)  failb=3D 56(D=
)  OK
[   10.441417] raid6test: test_disks(41, 57): faila=3D 41(D)  failb=3D 57(D=
)  OK
[   10.444133] raid6test: test_disks(41, 58): faila=3D 41(D)  failb=3D 58(D=
)  OK
[   10.446541] raid6test: test_disks(41, 59): faila=3D 41(D)  failb=3D 59(D=
)  OK
[   10.449464] raid6test: test_disks(41, 60): faila=3D 41(D)  failb=3D 60(D=
)  OK
[   10.452300] raid6test: test_disks(41, 61): faila=3D 41(D)  failb=3D 61(D=
)  OK
[   10.454932] raid6test: test_disks(41, 62): faila=3D 41(D)  failb=3D 62(P=
)  OK
[   10.457612] raid6test: test_disks(41, 63): faila=3D 41(D)  failb=3D 63(Q=
)  OK
[   10.460460] raid6test: test_disks(42, 43): faila=3D 42(D)  failb=3D 43(D=
)  OK
[   10.463266] raid6test: test_disks(42, 44): faila=3D 42(D)  failb=3D 44(D=
)  OK
[   10.466061] raid6test: test_disks(42, 45): faila=3D 42(D)  failb=3D 45(D=
)  OK
[   10.468957] raid6test: test_disks(42, 46): faila=3D 42(D)  failb=3D 46(D=
)  OK
[   10.471821] raid6test: test_disks(42, 47): faila=3D 42(D)  failb=3D 47(D=
)  OK
[   10.474432] raid6test: test_disks(42, 48): faila=3D 42(D)  failb=3D 48(D=
)  OK
[   10.477421] raid6test: test_disks(42, 49): faila=3D 42(D)  failb=3D 49(D=
)  OK
[   10.480204] raid6test: test_disks(42, 50): faila=3D 42(D)  failb=3D 50(D=
)  OK
[   10.482857] raid6test: test_disks(42, 51): faila=3D 42(D)  failb=3D 51(D=
)  OK
[   10.485548] raid6test: test_disks(42, 52): faila=3D 42(D)  failb=3D 52(D=
)  OK
[   10.488250] raid6test: test_disks(42, 53): faila=3D 42(D)  failb=3D 53(D=
)  OK
[   10.490934] raid6test: test_disks(42, 54): faila=3D 42(D)  failb=3D 54(D=
)  OK
[   10.493621] raid6test: test_disks(42, 55): faila=3D 42(D)  failb=3D 55(D=
)  OK
[   10.496272] raid6test: test_disks(42, 56): faila=3D 42(D)  failb=3D 56(D=
)  OK
[   10.498924] raid6test: test_disks(42, 57): faila=3D 42(D)  failb=3D 57(D=
)  OK
[   10.501657] raid6test: test_disks(42, 58): faila=3D 42(D)  failb=3D 58(D=
)  OK
[   10.504270] raid6test: test_disks(42, 59): faila=3D 42(D)  failb=3D 59(D=
)  OK
[   10.506943] raid6test: test_disks(42, 60): faila=3D 42(D)  failb=3D 60(D=
)  OK
[   10.509643] raid6test: test_disks(42, 61): faila=3D 42(D)  failb=3D 61(D=
)  OK
[   10.512288] raid6test: test_disks(42, 62): faila=3D 42(D)  failb=3D 62(P=
)  OK
[   10.515012] raid6test: test_disks(42, 63): faila=3D 42(D)  failb=3D 63(Q=
)  OK
[   10.517630] raid6test: test_disks(43, 44): faila=3D 43(D)  failb=3D 44(D=
)  OK
[   10.520236] raid6test: test_disks(43, 45): faila=3D 43(D)  failb=3D 45(D=
)  OK
[   10.522892] raid6test: test_disks(43, 46): faila=3D 43(D)  failb=3D 46(D=
)  OK
[   10.525525] raid6test: test_disks(43, 47): faila=3D 43(D)  failb=3D 47(D=
)  OK
[   10.528179] raid6test: test_disks(43, 48): faila=3D 43(D)  failb=3D 48(D=
)  OK
[   10.530908] raid6test: test_disks(43, 49): faila=3D 43(D)  failb=3D 49(D=
)  OK
[   10.533597] raid6test: test_disks(43, 50): faila=3D 43(D)  failb=3D 50(D=
)  OK
[   10.536252] raid6test: test_disks(43, 51): faila=3D 43(D)  failb=3D 51(D=
)  OK
[   10.538977] raid6test: test_disks(43, 52): faila=3D 43(D)  failb=3D 52(D=
)  OK
[   10.541567] raid6test: test_disks(43, 53): faila=3D 43(D)  failb=3D 53(D=
)  OK
[   10.544300] raid6test: test_disks(43, 54): faila=3D 43(D)  failb=3D 54(D=
)  OK
[   10.546945] raid6test: test_disks(43, 55): faila=3D 43(D)  failb=3D 55(D=
)  OK
[   10.549521] raid6test: test_disks(43, 56): faila=3D 43(D)  failb=3D 56(D=
)  OK
[   10.552196] raid6test: test_disks(43, 57): faila=3D 43(D)  failb=3D 57(D=
)  OK
[   10.554926] raid6test: test_disks(43, 58): faila=3D 43(D)  failb=3D 58(D=
)  OK
[   10.557622] raid6test: test_disks(43, 59): faila=3D 43(D)  failb=3D 59(D=
)  OK
[   10.560384] raid6test: test_disks(43, 60): faila=3D 43(D)  failb=3D 60(D=
)  OK
[   10.563188] raid6test: test_disks(43, 61): faila=3D 43(D)  failb=3D 61(D=
)  OK
[   10.565972] raid6test: test_disks(43, 62): faila=3D 43(D)  failb=3D 62(P=
)  OK
[   10.568705] raid6test: test_disks(43, 63): faila=3D 43(D)  failb=3D 63(Q=
)  OK
[   10.571441] raid6test: test_disks(44, 45): faila=3D 44(D)  failb=3D 45(D=
)  OK
[   10.574223] raid6test: test_disks(44, 46): faila=3D 44(D)  failb=3D 46(D=
)  OK
[   10.577099] raid6test: test_disks(44, 47): faila=3D 44(D)  failb=3D 47(D=
)  OK
[   10.579950] raid6test: test_disks(44, 48): faila=3D 44(D)  failb=3D 48(D=
)  OK
[   10.582847] raid6test: test_disks(44, 49): faila=3D 44(D)  failb=3D 49(D=
)  OK
[   10.585765] raid6test: test_disks(44, 50): faila=3D 44(D)  failb=3D 50(D=
)  OK
[   10.588628] raid6test: test_disks(44, 51): faila=3D 44(D)  failb=3D 51(D=
)  OK
[   10.591484] raid6test: test_disks(44, 52): faila=3D 44(D)  failb=3D 52(D=
)  OK
[   10.594350] raid6test: test_disks(44, 53): faila=3D 44(D)  failb=3D 53(D=
)  OK
[   10.597258] raid6test: test_disks(44, 54): faila=3D 44(D)  failb=3D 54(D=
)  OK
[   10.600171] raid6test: test_disks(44, 55): faila=3D 44(D)  failb=3D 55(D=
)  OK
[   10.603085] raid6test: test_disks(44, 56): faila=3D 44(D)  failb=3D 56(D=
)  OK
[   10.605982] raid6test: test_disks(44, 57): faila=3D 44(D)  failb=3D 57(D=
)  OK
[   10.608884] raid6test: test_disks(44, 58): faila=3D 44(D)  failb=3D 58(D=
)  OK
[   10.611755] raid6test: test_disks(44, 59): faila=3D 44(D)  failb=3D 59(D=
)  OK
[   10.614608] raid6test: test_disks(44, 60): faila=3D 44(D)  failb=3D 60(D=
)  OK
[   10.617536] raid6test: test_disks(44, 61): faila=3D 44(D)  failb=3D 61(D=
)  OK
[   10.620431] raid6test: test_disks(44, 62): faila=3D 44(D)  failb=3D 62(P=
)  OK
[   10.623261] raid6test: test_disks(44, 63): faila=3D 44(D)  failb=3D 63(Q=
)  OK
[   10.626148] raid6test: test_disks(45, 46): faila=3D 45(D)  failb=3D 46(D=
)  OK
[   10.629035] raid6test: test_disks(45, 47): faila=3D 45(D)  failb=3D 47(D=
)  OK
[   10.631767] raid6test: test_disks(45, 48): faila=3D 45(D)  failb=3D 48(D=
)  OK
[   10.634492] raid6test: test_disks(45, 49): faila=3D 45(D)  failb=3D 49(D=
)  OK
[   10.637278] raid6test: test_disks(45, 50): faila=3D 45(D)  failb=3D 50(D=
)  OK
[   10.640116] raid6test: test_disks(45, 51): faila=3D 45(D)  failb=3D 51(D=
)  OK
[   10.642892] raid6test: test_disks(45, 52): faila=3D 45(D)  failb=3D 52(D=
)  OK
[   10.645821] raid6test: test_disks(45, 53): faila=3D 45(D)  failb=3D 53(D=
)  OK
[   10.648719] raid6test: test_disks(45, 54): faila=3D 45(D)  failb=3D 54(D=
)  OK
[   10.651559] raid6test: test_disks(45, 55): faila=3D 45(D)  failb=3D 55(D=
)  OK
[   10.654313] raid6test: test_disks(45, 56): faila=3D 45(D)  failb=3D 56(D=
)  OK
[   10.657127] raid6test: test_disks(45, 57): faila=3D 45(D)  failb=3D 57(D=
)  OK
[   10.659868] raid6test: test_disks(45, 58): faila=3D 45(D)  failb=3D 58(D=
)  OK
[   10.662697] raid6test: test_disks(45, 59): faila=3D 45(D)  failb=3D 59(D=
)  OK
[   10.665465] raid6test: test_disks(45, 60): faila=3D 45(D)  failb=3D 60(D=
)  OK
[   10.668143] raid6test: test_disks(45, 61): faila=3D 45(D)  failb=3D 61(D=
)  OK
[   10.670722] raid6test: test_disks(45, 62): faila=3D 45(D)  failb=3D 62(P=
)  OK
[   10.673265] raid6test: test_disks(45, 63): faila=3D 45(D)  failb=3D 63(Q=
)  OK
[   10.675882] raid6test: test_disks(46, 47): faila=3D 46(D)  failb=3D 47(D=
)  OK
[   10.678552] raid6test: test_disks(46, 48): faila=3D 46(D)  failb=3D 48(D=
)  OK
[   10.681310] raid6test: test_disks(46, 49): faila=3D 46(D)  failb=3D 49(D=
)  OK
[   10.684115] raid6test: test_disks(46, 50): faila=3D 46(D)  failb=3D 50(D=
)  OK
[   10.686913] raid6test: test_disks(46, 51): faila=3D 46(D)  failb=3D 51(D=
)  OK
[   10.689794] raid6test: test_disks(46, 52): faila=3D 46(D)  failb=3D 52(D=
)  OK
[   10.692642] raid6test: test_disks(46, 53): faila=3D 46(D)  failb=3D 53(D=
)  OK
[   10.695421] raid6test: test_disks(46, 54): faila=3D 46(D)  failb=3D 54(D=
)  OK
[   10.698297] raid6test: test_disks(46, 55): faila=3D 46(D)  failb=3D 55(D=
)  OK
[   10.701128] raid6test: test_disks(46, 56): faila=3D 46(D)  failb=3D 56(D=
)  OK
[   10.703868] raid6test: test_disks(46, 57): faila=3D 46(D)  failb=3D 57(D=
)  OK
[   10.706584] raid6test: test_disks(46, 58): faila=3D 46(D)  failb=3D 58(D=
)  OK
[   10.709232] raid6test: test_disks(46, 59): faila=3D 46(D)  failb=3D 59(D=
)  OK
[   10.712090] raid6test: test_disks(46, 60): faila=3D 46(D)  failb=3D 60(D=
)  OK
[   10.714864] raid6test: test_disks(46, 61): faila=3D 46(D)  failb=3D 61(D=
)  OK
[   10.717759] raid6test: test_disks(46, 62): faila=3D 46(D)  failb=3D 62(P=
)  OK
[   10.720462] raid6test: test_disks(46, 63): faila=3D 46(D)  failb=3D 63(Q=
)  OK
[   10.723330] raid6test: test_disks(47, 48): faila=3D 47(D)  failb=3D 48(D=
)  OK
[   10.726225] raid6test: test_disks(47, 49): faila=3D 47(D)  failb=3D 49(D=
)  OK
[   10.728899] raid6test: test_disks(47, 50): faila=3D 47(D)  failb=3D 50(D=
)  OK
[   10.731543] raid6test: test_disks(47, 51): faila=3D 47(D)  failb=3D 51(D=
)  OK
[   10.734237] raid6test: test_disks(47, 52): faila=3D 47(D)  failb=3D 52(D=
)  OK
[   10.736939] raid6test: test_disks(47, 53): faila=3D 47(D)  failb=3D 53(D=
)  OK
[   10.739835] raid6test: test_disks(47, 54): faila=3D 47(D)  failb=3D 54(D=
)  OK
[   10.742617] raid6test: test_disks(47, 55): faila=3D 47(D)  failb=3D 55(D=
)  OK
[   10.745352] raid6test: test_disks(47, 56): faila=3D 47(D)  failb=3D 56(D=
)  OK
[   10.749216] raid6test: test_disks(47, 57): faila=3D 47(D)  failb=3D 57(D=
)  OK
[   10.752073] raid6test: test_disks(47, 58): faila=3D 47(D)  failb=3D 58(D=
)  OK
[   10.754868] raid6test: test_disks(47, 59): faila=3D 47(D)  failb=3D 59(D=
)  OK
[   10.757711] raid6test: test_disks(47, 60): faila=3D 47(D)  failb=3D 60(D=
)  OK
[   10.760513] raid6test: test_disks(47, 61): faila=3D 47(D)  failb=3D 61(D=
)  OK
[   10.763190] raid6test: test_disks(47, 62): faila=3D 47(D)  failb=3D 62(P=
)  OK
[   10.765839] raid6test: test_disks(47, 63): faila=3D 47(D)  failb=3D 63(Q=
)  OK
[   10.768631] raid6test: test_disks(48, 49): faila=3D 48(D)  failb=3D 49(D=
)  OK
[   10.771391] raid6test: test_disks(48, 50): faila=3D 48(D)  failb=3D 50(D=
)  OK
[   10.774103] raid6test: test_disks(48, 51): faila=3D 48(D)  failb=3D 51(D=
)  OK
[   10.777056] raid6test: test_disks(48, 52): faila=3D 48(D)  failb=3D 52(D=
)  OK
[   10.779958] raid6test: test_disks(48, 53): faila=3D 48(D)  failb=3D 53(D=
)  OK
[   10.782887] raid6test: test_disks(48, 54): faila=3D 48(D)  failb=3D 54(D=
)  OK
[   10.785798] raid6test: test_disks(48, 55): faila=3D 48(D)  failb=3D 55(D=
)  OK
[   10.788737] raid6test: test_disks(48, 56): faila=3D 48(D)  failb=3D 56(D=
)  OK
[   10.791605] raid6test: test_disks(48, 57): faila=3D 48(D)  failb=3D 57(D=
)  OK
[   10.794553] raid6test: test_disks(48, 58): faila=3D 48(D)  failb=3D 58(D=
)  OK
[   10.797373] raid6test: test_disks(48, 59): faila=3D 48(D)  failb=3D 59(D=
)  OK
[   10.800043] raid6test: test_disks(48, 60): faila=3D 48(D)  failb=3D 60(D=
)  OK
[   10.802753] raid6test: test_disks(48, 61): faila=3D 48(D)  failb=3D 61(D=
)  OK
[   10.805445] raid6test: test_disks(48, 62): faila=3D 48(D)  failb=3D 62(P=
)  OK
[   10.808270] raid6test: test_disks(48, 63): faila=3D 48(D)  failb=3D 63(Q=
)  OK
[   10.810955] raid6test: test_disks(49, 50): faila=3D 49(D)  failb=3D 50(D=
)  OK
[   10.813787] raid6test: test_disks(49, 51): faila=3D 49(D)  failb=3D 51(D=
)  OK
[   10.816494] raid6test: test_disks(49, 52): faila=3D 49(D)  failb=3D 52(D=
)  OK
[   10.819211] raid6test: test_disks(49, 53): faila=3D 49(D)  failb=3D 53(D=
)  OK
[   10.822183] raid6test: test_disks(49, 54): faila=3D 49(D)  failb=3D 54(D=
)  OK
[   10.825113] raid6test: test_disks(49, 55): faila=3D 49(D)  failb=3D 55(D=
)  OK
[   10.828089] raid6test: test_disks(49, 56): faila=3D 49(D)  failb=3D 56(D=
)  OK
[   10.831039] raid6test: test_disks(49, 57): faila=3D 49(D)  failb=3D 57(D=
)  OK
[   10.833984] raid6test: test_disks(49, 58): faila=3D 49(D)  failb=3D 58(D=
)  OK
[   10.850984] raid6test: test_disks(49, 59): faila=3D 49(D)  failb=3D 59(D=
)  OK
[   10.853731] raid6test: test_disks(49, 60): faila=3D 49(D)  failb=3D 60(D=
)  OK
[   10.856351] raid6test: test_disks(49, 61): faila=3D 49(D)  failb=3D 61(D=
)  OK
[   10.858997] raid6test: test_disks(49, 62): faila=3D 49(D)  failb=3D 62(P=
)  OK
[   10.861577] raid6test: test_disks(49, 63): faila=3D 49(D)  failb=3D 63(Q=
)  OK
[   10.864370] raid6test: test_disks(50, 51): faila=3D 50(D)  failb=3D 51(D=
)  OK
[   10.867037] raid6test: test_disks(50, 52): faila=3D 50(D)  failb=3D 52(D=
)  OK
[   10.869768] raid6test: test_disks(50, 53): faila=3D 50(D)  failb=3D 53(D=
)  OK
[   10.872501] raid6test: test_disks(50, 54): faila=3D 50(D)  failb=3D 54(D=
)  OK
[   10.875333] raid6test: test_disks(50, 55): faila=3D 50(D)  failb=3D 55(D=
)  OK
[   10.877984] raid6test: test_disks(50, 56): faila=3D 50(D)  failb=3D 56(D=
)  OK
[   10.880741] raid6test: test_disks(50, 57): faila=3D 50(D)  failb=3D 57(D=
)  OK
[   10.883614] raid6test: test_disks(50, 58): faila=3D 50(D)  failb=3D 58(D=
)  OK
[   10.886272] raid6test: test_disks(50, 59): faila=3D 50(D)  failb=3D 59(D=
)  OK
[   10.888884] raid6test: test_disks(50, 60): faila=3D 50(D)  failb=3D 60(D=
)  OK
[   10.891602] raid6test: test_disks(50, 61): faila=3D 50(D)  failb=3D 61(D=
)  OK
[   10.894489] raid6test: test_disks(50, 62): faila=3D 50(D)  failb=3D 62(P=
)  OK
[   10.897369] raid6test: test_disks(50, 63): faila=3D 50(D)  failb=3D 63(Q=
)  OK
[   10.900227] raid6test: test_disks(51, 52): faila=3D 51(D)  failb=3D 52(D=
)  OK
[   10.903103] raid6test: test_disks(51, 53): faila=3D 51(D)  failb=3D 53(D=
)  OK
[   10.905849] raid6test: test_disks(51, 54): faila=3D 51(D)  failb=3D 54(D=
)  OK
[   10.908542] raid6test: test_disks(51, 55): faila=3D 51(D)  failb=3D 55(D=
)  OK
[   10.911186] raid6test: test_disks(51, 56): faila=3D 51(D)  failb=3D 56(D=
)  OK
[   10.913721] raid6test: test_disks(51, 57): faila=3D 51(D)  failb=3D 57(D=
)  OK
[   10.916324] raid6test: test_disks(51, 58): faila=3D 51(D)  failb=3D 58(D=
)  OK
[   10.918992] raid6test: test_disks(51, 59): faila=3D 51(D)  failb=3D 59(D=
)  OK
[   10.922073] raid6test: test_disks(51, 60): faila=3D 51(D)  failb=3D 60(D=
)  OK
[   10.925154] raid6test: test_disks(51, 61): faila=3D 51(D)  failb=3D 61(D=
)  OK
[   10.927793] raid6test: test_disks(51, 62): faila=3D 51(D)  failb=3D 62(P=
)  OK
[   10.930803] raid6test: test_disks(51, 63): faila=3D 51(D)  failb=3D 63(Q=
)  OK
[   10.933724] raid6test: test_disks(52, 53): faila=3D 52(D)  failb=3D 53(D=
)  OK
[   10.936291] raid6test: test_disks(52, 54): faila=3D 52(D)  failb=3D 54(D=
)  OK
[   10.938854] raid6test: test_disks(52, 55): faila=3D 52(D)  failb=3D 55(D=
)  OK
[   10.941589] raid6test: test_disks(52, 56): faila=3D 52(D)  failb=3D 56(D=
)  OK
[   10.944173] raid6test: test_disks(52, 57): faila=3D 52(D)  failb=3D 57(D=
)  OK
[   10.947140] raid6test: test_disks(52, 58): faila=3D 52(D)  failb=3D 58(D=
)  OK
[   10.949803] raid6test: test_disks(52, 59): faila=3D 52(D)  failb=3D 59(D=
)  OK
[   10.952325] raid6test: test_disks(52, 60): faila=3D 52(D)  failb=3D 60(D=
)  OK
[   10.954983] raid6test: test_disks(52, 61): faila=3D 52(D)  failb=3D 61(D=
)  OK
[   10.957689] raid6test: test_disks(52, 62): faila=3D 52(D)  failb=3D 62(P=
)  OK
[   10.960288] raid6test: test_disks(52, 63): faila=3D 52(D)  failb=3D 63(Q=
)  OK
[   10.962935] raid6test: test_disks(53, 54): faila=3D 53(D)  failb=3D 54(D=
)  OK
[   10.965521] raid6test: test_disks(53, 55): faila=3D 53(D)  failb=3D 55(D=
)  OK
[   10.968185] raid6test: test_disks(53, 56): faila=3D 53(D)  failb=3D 56(D=
)  OK
[   10.970735] raid6test: test_disks(53, 57): faila=3D 53(D)  failb=3D 57(D=
)  OK
[   10.973133] raid6test: test_disks(53, 58): faila=3D 53(D)  failb=3D 58(D=
)  OK
[   10.975997] raid6test: test_disks(53, 59): faila=3D 53(D)  failb=3D 59(D=
)  OK
[   10.978700] raid6test: test_disks(53, 60): faila=3D 53(D)  failb=3D 60(D=
)  OK
[   10.981398] raid6test: test_disks(53, 61): faila=3D 53(D)  failb=3D 61(D=
)  OK
[   10.984114] raid6test: test_disks(53, 62): faila=3D 53(D)  failb=3D 62(P=
)  OK
[   10.986824] raid6test: test_disks(53, 63): faila=3D 53(D)  failb=3D 63(Q=
)  OK
[   10.989490] raid6test: test_disks(54, 55): faila=3D 54(D)  failb=3D 55(D=
)  OK
[   10.992237] raid6test: test_disks(54, 56): faila=3D 54(D)  failb=3D 56(D=
)  OK
[   10.994962] raid6test: test_disks(54, 57): faila=3D 54(D)  failb=3D 57(D=
)  OK
[   10.997654] raid6test: test_disks(54, 58): faila=3D 54(D)  failb=3D 58(D=
)  OK
[   11.000336] raid6test: test_disks(54, 59): faila=3D 54(D)  failb=3D 59(D=
)  OK
[   11.003067] raid6test: test_disks(54, 60): faila=3D 54(D)  failb=3D 60(D=
)  OK
[   11.005804] raid6test: test_disks(54, 61): faila=3D 54(D)  failb=3D 61(D=
)  OK
[   11.008483] raid6test: test_disks(54, 62): faila=3D 54(D)  failb=3D 62(P=
)  OK
[   11.011135] raid6test: test_disks(54, 63): faila=3D 54(D)  failb=3D 63(Q=
)  OK
[   11.013657] raid6test: test_disks(55, 56): faila=3D 55(D)  failb=3D 56(D=
)  OK
[   11.016113] raid6test: test_disks(55, 57): faila=3D 55(D)  failb=3D 57(D=
)  OK
[   11.018543] raid6test: test_disks(55, 58): faila=3D 55(D)  failb=3D 58(D=
)  OK
[   11.021264] raid6test: test_disks(55, 59): faila=3D 55(D)  failb=3D 59(D=
)  OK
[   11.023718] raid6test: test_disks(55, 60): faila=3D 55(D)  failb=3D 60(D=
)  OK
[   11.026316] raid6test: test_disks(55, 61): faila=3D 55(D)  failb=3D 61(D=
)  OK
[   11.028757] raid6test: test_disks(55, 62): faila=3D 55(D)  failb=3D 62(P=
)  OK
[   11.031347] raid6test: test_disks(55, 63): faila=3D 55(D)  failb=3D 63(Q=
)  OK
[   11.034357] raid6test: test_disks(56, 57): faila=3D 56(D)  failb=3D 57(D=
)  OK
[   11.037361] raid6test: test_disks(56, 58): faila=3D 56(D)  failb=3D 58(D=
)  OK
[   11.039955] raid6test: test_disks(56, 59): faila=3D 56(D)  failb=3D 59(D=
)  OK
[   11.042618] raid6test: test_disks(56, 60): faila=3D 56(D)  failb=3D 60(D=
)  OK
[   11.045308] raid6test: test_disks(56, 61): faila=3D 56(D)  failb=3D 61(D=
)  OK
[   11.047907] raid6test: test_disks(56, 62): faila=3D 56(D)  failb=3D 62(P=
)  OK
[   11.050504] raid6test: test_disks(56, 63): faila=3D 56(D)  failb=3D 63(Q=
)  OK
[   11.053114] raid6test: test_disks(57, 58): faila=3D 57(D)  failb=3D 58(D=
)  OK
[   11.055807] raid6test: test_disks(57, 59): faila=3D 57(D)  failb=3D 59(D=
)  OK
[   11.058321] raid6test: test_disks(57, 60): faila=3D 57(D)  failb=3D 60(D=
)  OK
[   11.060883] raid6test: test_disks(57, 61): faila=3D 57(D)  failb=3D 61(D=
)  OK
[   11.063379] raid6test: test_disks(57, 62): faila=3D 57(D)  failb=3D 62(P=
)  OK
[   11.066156] raid6test: test_disks(57, 63): faila=3D 57(D)  failb=3D 63(Q=
)  OK
[   11.068949] raid6test: test_disks(58, 59): faila=3D 58(D)  failb=3D 59(D=
)  OK
[   11.071877] raid6test: test_disks(58, 60): faila=3D 58(D)  failb=3D 60(D=
)  OK
[   11.074881] raid6test: test_disks(58, 61): faila=3D 58(D)  failb=3D 61(D=
)  OK
[   11.077843] raid6test: test_disks(58, 62): faila=3D 58(D)  failb=3D 62(P=
)  OK
[   11.080295] raid6test: test_disks(58, 63): faila=3D 58(D)  failb=3D 63(Q=
)  OK
[   11.082943] raid6test: test_disks(59, 60): faila=3D 59(D)  failb=3D 60(D=
)  OK
[   11.085573] raid6test: test_disks(59, 61): faila=3D 59(D)  failb=3D 61(D=
)  OK
[   11.088369] raid6test: test_disks(59, 62): faila=3D 59(D)  failb=3D 62(P=
)  OK
[   11.091209] raid6test: test_disks(59, 63): faila=3D 59(D)  failb=3D 63(Q=
)  OK
[   11.093929] raid6test: test_disks(60, 61): faila=3D 60(D)  failb=3D 61(D=
)  OK
[   11.096445] raid6test: test_disks(60, 62): faila=3D 60(D)  failb=3D 62(P=
)  OK
[   11.099041] raid6test: test_disks(60, 63): faila=3D 60(D)  failb=3D 63(Q=
)  OK
[   11.101554] raid6test: test_disks(61, 62): faila=3D 61(D)  failb=3D 62(P=
)  OK
[   11.104141] raid6test: test_disks(61, 63): faila=3D 61(D)  failb=3D 63(Q=
)  OK
[   11.106981] raid6test: test_disks(62, 63): faila=3D 62(P)  failb=3D 63(Q=
)  OK
[   11.109646] raid6test:=20
[   11.111242] raid6test: complete (2429 tests, 0 failures)
[   11.119778]   Magic number: 2:141:253
[   11.121797] tty ttyw9: hash matches
[   11.123730] tty ttytc: hash matches
[   11.128997] Freeing unused kernel memory: 956K (ffffffff81ae1000 - fffff=
fff81bd0000)
[   11.132726] Write protecting the kernel read-only data: 10240k
[   11.140305] Freeing unused kernel memory: 648K (ffff88000155e000 - ffff8=
80001600000)
[   11.156403] Freeing unused kernel memory: 1852K (ffff880001831000 - ffff=
880001a00000)
[   11.177538] random: init urandom read with 5 bits of entropy available
[   11.193582] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000078
[   11.194018] IP: [<ffffffff8108eff6>] pick_next_task_fair+0x171/0x238
[   11.194018] PGD 0=20
[   11.194018] Oops: 0000 [#1] SMP=20
[   11.194018] Modules linked in:
[   11.194018] CPU: 0 PID: 83 Comm: hostname Not tainted 3.14.0-rc1-00092-g=
92ed244 #33
[   11.194018] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   11.194018] task: ffff880007bea840 ti: ffff88000ef9e000 task.ti: ffff880=
00ef9e000
[   11.194018] RIP: 0010:[<ffffffff8108eff6>]  [<ffffffff8108eff6>] pick_ne=
xt_task_fair+0x171/0x238
[   11.194018] RSP: 0018:ffff88000ef9fd70  EFLAGS: 00010046
[   11.194018] RAX: 00000002893d47ce RBX: ffff88000ee6f248 RCX: 00000000000=
00000
[   11.194018] RDX: 0000000000000000 RSI: ffff88000ef053d8 RDI: ffff88000d9=
28078
[   11.194018] RBP: ffff88000ef9fda0 R08: 000000000000297c R09: 00000000000=
0b6c8
[   11.194018] R10: ffff88000e60a000 R11: 00000000000023d5 R12: ffff88000d9=
28000
[   11.194018] R13: ffff88000e6127b8 R14: 0000000000000000 R15: 00000000000=
00001
[   11.194018] FS:  0000000000000000(0000) GS:ffff88000e600000(0000) knlGS:=
0000000000000000
[   11.194018] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   11.194018] CR2: 0000000000000078 CR3: 0000000001a06000 CR4: 00000000000=
006f0
[   11.194018] Stack:
[   11.194018]  ffff88000e612740 ffff88000e612740 0000000000000000 ffff8800=
07beac38
[   11.194018]  ffff88000d928000 ffff880007bea840 ffff88000ef9fea0 ffffffff=
8154fa9a
[   11.194018]  ffff88000ef9ffd8 ffff880007bea840 0000000000012740 00000000=
00000011
[   11.194018] Call Trace:
[   11.194018]  [<ffffffff8154fa9a>] __schedule+0x1be/0x756
[   11.194018]  [<ffffffff81553205>] ? _raw_spin_unlock_irqrestore+0x51/0x7b
[   11.194018]  [<ffffffff8106a2ff>] ? do_notify_parent+0x22b/0x240
[   11.194018]  [<ffffffff810f0e81>] ? task_function_call+0x44/0x4e
[   11.194018]  [<ffffffff810f59b0>] ? __perf_event_task_sched_out+0x329/0x=
329
[   11.194018]  [<ffffffff81553023>] ? _raw_spin_lock_irqsave+0x25/0x69
[   11.194018]  [<ffffffff815500a1>] schedule+0x6f/0x71
[   11.194018]  [<ffffffff8105ccd7>] do_exit+0x8e8/0x927
[   11.194018]  [<ffffffff810890cb>] ? vtime_account_user+0x52/0x57
[   11.194018]  [<ffffffff8105dc05>] do_group_exit+0x4a/0x110
[   11.194018]  [<ffffffff8105dcdf>] SyS_exit_group+0x14/0x14
[   11.194018]  [<ffffffff8155ad9b>] tracesys+0xdd/0xe2
[   11.194018] Code: e8 f2 d2 ff ff 4c 8b a3 80 00 00 00 4d 85 e4 0f 85 e8 =
fe ff ff 4c 8d 63 98 4d 39 e6 74 61 4d 85 f6 74 5c 49 83 c6 68 4c 8b 6b 78 =
<49> 8b 7e 78 49 39 fd 74 30 44 8b 7b 68 45 8b 6e 68 45 39 ef 7f=20
[   11.194018] RIP  [<ffffffff8108eff6>] pick_next_task_fair+0x171/0x238
[   11.194018]  RSP <ffff88000ef9fd70>
[   11.194018] CR2: 0000000000000078
[   11.194018] ---[ end trace d8c5bf7ff957e138 ]---
[   11.194018] Kernel panic - not syncing: Fatal exception
[   11.194018] Shutting down cpus with NMI
[   11.194018] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   11.194018] Rebooting in 10 seconds..
Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-c0-0205/92ed2443d0f6e23e9594bb601be3168e272749a0/vmlinuz-3.14.0-rc1-00092-=
g92ed244 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dno=
rmal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randcon=
fig-c0-0205/linux-devel:devel-cairo-x86_64-201402052359/.vmlinuz-92ed2443d0=
f6e23e9594bb601be3168e272749a0-20140206001512-7-snb branch=3Dlinux-devel/de=
vel-cairo-x86_64-201402052359 BOOT_IMAGE=3D/kernel/x86_64-randconfig-c0-020=
5/92ed2443d0f6e23e9594bb601be3168e272749a0/vmlinuz-3.14.0-rc1-00092-g92ed24=
4'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 256M -smp 2 -ne=
t nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::13540-:22 -b=
oot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive f=
ile=3D/fs/LABEL=3DKVM/disk0-quantal-snb-27,media=3Ddisk,if=3Dvirtio -drive =
file=3D/fs/LABEL=3DKVM/disk1-quantal-snb-27,media=3Ddisk,if=3Dvirtio -drive=
 file=3D/fs/LABEL=3DKVM/disk2-quantal-snb-27,media=3Ddisk,if=3Dvirtio -driv=
e file=3D/fs/LABEL=3DKVM/disk3-quantal-snb-27,media=3Ddisk,if=3Dvirtio -dri=
ve file=3D/fs/LABEL=3DKVM/disk4-quantal-snb-27,media=3Ddisk,if=3Dvirtio -dr=
ive file=3D/fs/LABEL=3DKVM/disk5-quantal-snb-27,media=3Ddisk,if=3Dvirtio -p=
idfile /dev/shm/kboot/pid-quantal-snb-27 -serial file:/dev/shm/kboot/serial=
-quantal-snb-27 -daemonize -display none -monitor null=20

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc1-00092-g92ed244"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc1 Kernel Configuration
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
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_RCU_USER_QS is not set
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
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
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
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
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
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
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_INJECT=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

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
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=m
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=m
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=m
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=y
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=y
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_IPTABLES is not set
CONFIG_BRIDGE_NF_EBTABLES=m
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=m
# CONFIG_BRIDGE_EBT_T_NAT is not set
CONFIG_BRIDGE_EBT_802_3=m
# CONFIG_BRIDGE_EBT_AMONG is not set
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_LIMIT=m
# CONFIG_BRIDGE_EBT_MARK is not set
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
# CONFIG_BRIDGE_EBT_REDIRECT is not set
# CONFIG_BRIDGE_EBT_SNAT is not set
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=y
# CONFIG_RDS_TCP is not set
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
# CONFIG_L2TP_V3 is not set
CONFIG_STP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_6LOWPAN_IPHC=m
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_ATM is not set
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=m
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=m
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=y
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=m
# CONFIG_NET_CLS_BPF is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
# CONFIG_OPENVSWITCH_VXLAN is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=m
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_TCPPROBE=y
CONFIG_NET_DROP_MONITOR=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=m
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
CONFIG_BT_ATH3K=m
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=m
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=m
CONFIG_NFC_SIM=m
# CONFIG_NFC_PORT100 is not set
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=m
# CONFIG_NFC_MRVL is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_MMIO=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=m
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=m
# CONFIG_MTD_NAND_SH_FLCTL is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
CONFIG_ZRAM_DEBUG=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#

#
# Altera FPGA firmware download module
#
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=m
# CONFIG_BCACHE_DEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=m
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_VXLAN=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
CONFIG_CAIF_SPI_SLAVE=m
# CONFIG_CAIF_SPI_SYNC is not set
# CONFIG_CAIF_HSI is not set
CONFIG_CAIF_VIRTIO=y
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=y
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
CONFIG_NET_DSA_MV88E6123_61_65=m
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=m
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=m
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=m
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SR9700=m
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=m
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_ATH_CARDS=m
CONFIG_ATH_DEBUG=y
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH6KL=m
CONFIG_ATH6KL_SDIO=m
# CONFIG_ATH6KL_USB is not set
# CONFIG_ATH6KL_DEBUG is not set
# CONFIG_ATH6KL_TRACING is not set
# CONFIG_WIL6210 is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCMFMAC_USB is not set
CONFIG_BRCM_TRACING=y
CONFIG_BRCMDBG=y
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_IPW2100 is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_SDIO=m
# CONFIG_LIBERTAS_DEBUG is not set
# CONFIG_LIBERTAS_MESH is not set
CONFIG_WL_TI=y
CONFIG_MWIFIEX=m
# CONFIG_MWIFIEX_SDIO is not set
# CONFIG_MWIFIEX_PCIE is not set
# CONFIG_MWIFIEX_USB is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_SH_KEYSC=m
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=m
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=m
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=m
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_ADXL34X=m
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_IDEAPAD_SLIDEBAR=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
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
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
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
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
# CONFIG_TRACE_ROUTER is not set
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
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
CONFIG_SERIAL_ST_ASC=m
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

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
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS1WM=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_CHARGER_ISP1704=m
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_HTC_PASIC3=m
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_SM501 is not set
CONFIG_ABX500_CORE=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_ANATOP=y
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_JVC_DECODER is not set
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_MCE_KBD_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGUANA is not set
CONFIG_IR_TTUSBIR=m
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_GPIO_CIR=m
CONFIG_MEDIA_USB_SUPPORT=y
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_CYPRESS_FIRMWARE=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_ATTACH=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# Customize TV tuners
#

#
# Customise DVB Frontends
#

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
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
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PWM=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=m
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_OMAP is not set
# CONFIG_USB_DWC3_EXYNOS is not set
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_KEYSTONE=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=m
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=m
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
# CONFIG_USB_SERIAL_XSENS_MT is not set
CONFIG_USB_SERIAL_WISHBONE=y
CONFIG_USB_SERIAL_ZTE=m
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
# CONFIG_KEYSTONE_USB_PHY is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=m
CONFIG_OMAP_USB3=m
CONFIG_AM335X_CONTROL_USB=m
CONFIG_AM335X_PHY_USB=m
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_RCAR_GEN2_PHY=m
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_OMAP_HS=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_OT200 is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=m
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=m
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
# CONFIG_RTLLIB_CRYPTO_WEP is not set
# CONFIG_RTL8192E is not set
# CONFIG_R8712U is not set
CONFIG_R8188EU=m
CONFIG_88EU_AP_MODE=y
CONFIG_88EU_P2P=y
# CONFIG_R8821AE is not set
CONFIG_RTS5139=m
# CONFIG_RTS5139_DEBUG is not set
# CONFIG_RTS5208 is not set
# CONFIG_TRANZPORT is not set
CONFIG_USB_SERIAL_QUATECH2=y
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_DX_SEP is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_USB_ENESTORAGE=m
CONFIG_BCM_WIMAX=m
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_VIDEO_DT3155 is not set
CONFIG_USB_MSI3101=m
# CONFIG_USB_SN9C102 is not set
# CONFIG_LIRC_STAGING is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=m
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
# CONFIG_LUSTRE_FS is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=m
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
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
CONFIG_SAMSUNG_LAPTOP=m
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

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
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_RENESAS_TPU is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=m
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_LOGFS=m
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_F2FS_FS=m
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=m
# CONFIG_NFSD_V3 is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
# CONFIG_CEPH_FS_POSIX_ACL is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_SMB2=y
CONFIG_CIFS_FSCACHE=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_9P_FS=m
CONFIG_9P_FSCACHE=y
# CONFIG_9P_FS_POSIX_ACL is not set
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
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
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
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
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
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
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=m
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=m
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
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
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
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
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_OID_REGISTRY=m
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
# CONFIG_FONT_PEARL_8x8 is not set
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
# CONFIG_FONT_SUN8x16 is not set
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--xHFwDpU9dbj6ez1V--
