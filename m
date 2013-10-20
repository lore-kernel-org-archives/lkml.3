Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961Ab3JTCug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 22:50:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:57302 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab3JTCue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 22:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,531,1378882800"; 
   d="log'?scan'208";a="413878227"
Date: Sun, 20 Oct 2013 10:50:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [userns-always-map-user-v136] BUG: unable to handle kernel NULL
 pointer dereference at (null)
Message-ID: <20131020025026.GB6737@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Eric,

It's beyond me why this trivial patch will lead to kernel panic.  But
the NULL pointer dereference bug is 100% reproducible since this commit.

commit fd97e87d4112f5ec33223b0bdc3b7b07b273ecbe
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu Oct 3 14:58:53 2013 -0700

    pid: Stop open coding is_idle_task in fork.
    
    This makes the code clearer and it removes one more use of task->pid.
    
    Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

[    0.018865] ACPI: Core revision 20130725
[    0.026468] ACPI: All ACPI Tables successfully acquired
[    0.028112] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.030074] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    0.031525] IP: [<ffffffff8108e3be>] wake_up_process+0xa/0x37
[    0.032623] PGD 0 
[    0.033033] Oops: 0000 [#1] PREEMPT 
[    0.033333] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc3-00071-gea0225a #452
[    0.033333] task: ffff880000050040 ti: ffff88000004e000 task.ti: ffff88000004e000
[    0.033333] RIP: 0010:[<ffffffff8108e3be>]  [<ffffffff8108e3be>] wake_up_process+0xa/0x37
[    0.033333] RSP: 0000:ffff88000004fd10  EFLAGS: 00010246
[    0.033333] RAX: 0000000000000000 RBX: ffff88000004fd60 RCX: 0000000000000058
[    0.033333] RDX: ffffffff81c4be90 RSI: ffffffff81085a52 RDI: 0000000000000000
[    0.033333] RBP: ffff88000004fd18 R08: 0000000000000001 R09: 0000000000000058
[    0.033333] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81adbddf
[    0.033333] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    0.033333] FS:  0000000000000000(0000) GS:ffffffff81c1e000(0000) knlGS:0000000000000000
[    0.033333] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.033333] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000006b0
[    0.033333] Stack:
[    0.033333]  ffff88000004fd60 ffff88000004fe10 ffffffff81085a5e 000000000000000a
[    0.033333]  ffff880000050730 ffffffff810a986e ffffffff8108bc76 ffff880000094920
[    0.033333]  0000000000000000 ffff880000050040 ffff880000000000 dead4ead00000001
[    0.033333] Call Trace:
[    0.033333]  [<ffffffff81085a5e>] kthread_create_on_node+0x92/0x10c
[    0.033333]  [<ffffffff810a986e>] ? mark_lock+0x2e/0x25a
[    0.033333]  [<ffffffff8108bc76>] ? __smpboot_create_thread+0x9d/0x9d
[    0.033333]  [<ffffffff8108bc10>] ? __smpboot_create_thread+0x37/0x9d
[    0.033333]  [<ffffffff8108bc10>] ? __smpboot_create_thread+0x37/0x9d
[    0.033333]  [<ffffffff81085b70>] kthread_create_on_cpu+0x1b/0x4c
[    0.033333]  [<ffffffff8108bc35>] __smpboot_create_thread+0x5c/0x9d
[    0.033333]  [<ffffffff8108bfe5>] smpboot_register_percpu_thread+0x29/0x8d
[    0.033333]  [<ffffffff81f864c8>] ? ftrace_define_fields_softirq+0x30/0x30
[    0.033333]  [<ffffffff81f864d8>] spawn_ksoftirqd+0x10/0x1a
[    0.033333]  [<ffffffff81f76d9f>] do_one_initcall+0xaa/0x139
[    0.033333]  [<ffffffff810da307>] ? trace_preempt_on+0x12/0x2f
[    0.033333]  [<ffffffff8108e83e>] ? sub_preempt_count+0xb7/0xdc
[    0.033333]  [<ffffffff81f76ece>] kernel_init_freeable+0xa0/0x1c9
[    0.033333]  [<ffffffff816e59cd>] ? rest_init+0xc1/0xc1
[    0.033333]  [<ffffffff816e59db>] kernel_init+0xe/0xd6
[    0.033333]  [<ffffffff816f664a>] ret_from_fork+0x7a/0xb0
[    0.033333]  [<ffffffff816e59cd>] ? rest_init+0xc1/0xc1
[    0.033333] Code: 44 89 e0 41 5c 41 5d 41 5e 41 5f 5d c3 e8 9b 80 66 00 55 48 8b 7f 08 48 89 e5 e8 dc fe ff ff 5d c3 e8 87 80 66 00 55 48 89 e5 53 <48> 8b 07 48 89 fb a8 0c 74 11 be 2e 06 00 00 48 c7 c7 e5 ee ad 
[    0.033333] RIP  [<ffffffff8108e3be>] wake_up_process+0xa/0x37
[    0.033333]  RSP <ffff88000004fd10>
[    0.033333] CR2: 0000000000000000
[    0.033356] ---[ end trace 5811b7ce8c4f6c29 ]---
[    0.034206] Kernel panic - not syncing: Attempted to kill the idle task!

As you may see from the below table, its parent commit 87eac4a7f8dd

- boots fine for 3997 times
- has out of memory for 2 times
- has bad pagetable for 1 time (dmesg attached)
                                                                 branch BASE  parent         first bad      branch HEAD
+---------------------------------------------------------------+-----------+--------------+--------------+--------------+
|                                                               | v3.12-rc3 | 87eac4a7f8dd | fd97e87d4112 | ea0225af2eca |
+---------------------------------------------------------------+-----------+--------------+--------------+--------------+
| good_boots                                                    | 30        | 3997         |              |              |
| has_kernel_error_warning                                      | 0         | 3            | 1000         | 29           |
| Out_of_memory:Kill_process                                    | 0         | 2            |              |              |
| Bad_pagetable:d_PREEMPT                                       | 0         | 1            |              |              |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference_at(null) | 0         | 0            | 1000         | 29           |
| Oops:PREEMPT                                                  | 0         | 0            | 1000         | 29           |
| Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task      | 0         | 0            | 0            | 29           |
+---------------------------------------------------------------+-----------+--------------+--------------+--------------+

git bisect start ea0225af2eca6d14e7f1d33bcb12fa1808273b6f 15c03dd4859ab16f9212238f29dd315654aa94f6 --
git bisect good 6f5f7f4025978c2ab083087f7befc368c7c2c23f  # 20:28     20+      0  pid:  Kill task_tgid_nr
git bisect  bad 8b58ff728b1aeba33f24da520a19219dbc3b0c24  # 20:28      0-     20  kgdb: Stop using task->pid and task->tgid
git bisect  bad 3f0f902ca9e2f611a299373d44306d0c491d8898  # 20:33      0-      1  yama: Stop using task->pid
git bisect good 87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5  # 23:32   1000+      1  pid: Modify is_idle_task to test pid pointers instead of pid numbers
git bisect  bad e7cd1fe89c39ccc3af68b6adab648b6b065bc4e1  # 23:33      0-     18  pid:  Modify request_key_auth to use struct pid instead of pid_t values
git bisect  bad fd97e87d4112f5ec33223b0bdc3b7b07b273ecbe  # 23:34      0-      6  pid: Stop open coding is_idle_task in fork.
git bisect good 87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5  # 00:34   3000+      3  pid: Modify is_idle_task to test pid pointers instead of pid numbers
git bisect  bad ea0225af2eca6d14e7f1d33bcb12fa1808273b6f  # 00:34      0-     29  pidns:  Abandoned approach to cleaning up after the first pid
git bisect good 6481c9b08167dd3520a2f4f42c7edd6d8320a403  # 01:20   3000+      3  Revert "pid: Stop open coding is_idle_task in fork."
git bisect good bdeeab62a611f1f7cd48fd285ce568e8dcd0455a  # 02:26   3000+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 03:18   3000+      0  Add linux-next specific files for 20130927

Thanks,
Fengguang

--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-bens-4:20131018085048:x86_64-randconfig-x3----1018:3.12.0-rc3-00071-gea0225a:452"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc3-00071-gea0225a (kbuild@xian) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #452 PREEMPT Fri Oct 18 08:50:07 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-x3----1018/userns:userns-always-=
map-user-v136/.vmlinuz-ea0225af2eca6d14e7f1d33bcb12fa1808273b6f-20131018085=
032-7-bens branch=3Duserns/userns-always-map-user-v136 BOOT_IMAGE=3D/kernel=
/x86_64-randconfig-x3----1018/ea0225af2eca6d14e7f1d33bcb12fa1808273b6f/vmli=
nuz-3.12.0-rc3-00071-gea0225a
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
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02ac2000, 0x02ac2fff] PGTABLE
[    0.000000] BRK [0x02ac3000, 0x02ac3fff] PGTABLE
[    0.000000] BRK [0x02ac4000, 0x02ac4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02ac5000, 0x02ac5fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127900(97%)
[    0.000000] RAMDISK: [mem 0x0fd03000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000e80000=
0-ffff88000ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 896 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c2c040
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-x3----1018/userns:userns-a=
lways-map-user-v136/.vmlinuz-ea0225af2eca6d14e7f1d33bcb12fa1808273b6f-20131=
018085032-7-bens branch=3Duserns/userns-always-map-user-v136 BOOT_IMAGE=3D/=
kernel/x86_64-randconfig-x3----1018/ea0225af2eca6d14e7f1d33bcb12fa1808273b6=
f/vmlinuz-3.12.0-rc3-00071-gea0225a
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 218476K/261744K available (7141K kernel code, 3536K =
rwdata, 3916K rodata, 764K init, 10804K bss, 43268K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.772 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5335.77 Bogo=
MIPS (lpj=3D8889240)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006871] Security Framework initialized
[    0.007689] AppArmor: AppArmor initialized
[    0.008508] Mount-cache hash table entries: 256
[    0.011406] Initializing cgroup subsys devices
[    0.012403] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012403] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012403] tlb_flushall_shift: 6
[    0.013344] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.018865] ACPI: Core revision 20130725
[    0.026468] ACPI: All ACPI Tables successfully acquired
[    0.028112] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.030074] BUG: unable to handle kernel NULL pointer dereference at    =
       (null)
[    0.031525] IP: [<ffffffff8108e3be>] wake_up_process+0xa/0x37
[    0.032623] PGD 0=20
[    0.033033] Oops: 0000 [#1] PREEMPT=20
[    0.033333] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc3-00071-gea=
0225a #452
[    0.033333] task: ffff880000050040 ti: ffff88000004e000 task.ti: ffff880=
00004e000
[    0.033333] RIP: 0010:[<ffffffff8108e3be>]  [<ffffffff8108e3be>] wake_up=
_process+0xa/0x37
[    0.033333] RSP: 0000:ffff88000004fd10  EFLAGS: 00010246
[    0.033333] RAX: 0000000000000000 RBX: ffff88000004fd60 RCX: 00000000000=
00058
[    0.033333] RDX: ffffffff81c4be90 RSI: ffffffff81085a52 RDI: 00000000000=
00000
[    0.033333] RBP: ffff88000004fd18 R08: 0000000000000001 R09: 00000000000=
00058
[    0.033333] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81a=
dbddf
[    0.033333] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[    0.033333] FS:  0000000000000000(0000) GS:ffffffff81c1e000(0000) knlGS:=
0000000000000000
[    0.033333] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.033333] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000=
006b0
[    0.033333] Stack:
[    0.033333]  ffff88000004fd60 ffff88000004fe10 ffffffff81085a5e 00000000=
0000000a
[    0.033333]  ffff880000050730 ffffffff810a986e ffffffff8108bc76 ffff8800=
00094920
[    0.033333]  0000000000000000 ffff880000050040 ffff880000000000 dead4ead=
00000001
[    0.033333] Call Trace:
[    0.033333]  [<ffffffff81085a5e>] kthread_create_on_node+0x92/0x10c
[    0.033333]  [<ffffffff810a986e>] ? mark_lock+0x2e/0x25a
[    0.033333]  [<ffffffff8108bc76>] ? __smpboot_create_thread+0x9d/0x9d
[    0.033333]  [<ffffffff8108bc10>] ? __smpboot_create_thread+0x37/0x9d
[    0.033333]  [<ffffffff8108bc10>] ? __smpboot_create_thread+0x37/0x9d
[    0.033333]  [<ffffffff81085b70>] kthread_create_on_cpu+0x1b/0x4c
[    0.033333]  [<ffffffff8108bc35>] __smpboot_create_thread+0x5c/0x9d
[    0.033333]  [<ffffffff8108bfe5>] smpboot_register_percpu_thread+0x29/0x=
8d
[    0.033333]  [<ffffffff81f864c8>] ? ftrace_define_fields_softirq+0x30/0x=
30
[    0.033333]  [<ffffffff81f864d8>] spawn_ksoftirqd+0x10/0x1a
[    0.033333]  [<ffffffff81f76d9f>] do_one_initcall+0xaa/0x139
[    0.033333]  [<ffffffff810da307>] ? trace_preempt_on+0x12/0x2f
[    0.033333]  [<ffffffff8108e83e>] ? sub_preempt_count+0xb7/0xdc
[    0.033333]  [<ffffffff81f76ece>] kernel_init_freeable+0xa0/0x1c9
[    0.033333]  [<ffffffff816e59cd>] ? rest_init+0xc1/0xc1
[    0.033333]  [<ffffffff816e59db>] kernel_init+0xe/0xd6
[    0.033333]  [<ffffffff816f664a>] ret_from_fork+0x7a/0xb0
[    0.033333]  [<ffffffff816e59cd>] ? rest_init+0xc1/0xc1
[    0.033333] Code: 44 89 e0 41 5c 41 5d 41 5e 41 5f 5d c3 e8 9b 80 66 00 =
55 48 8b 7f 08 48 89 e5 e8 dc fe ff ff 5d c3 e8 87 80 66 00 55 48 89 e5 53 =
<48> 8b 07 48 89 fb a8 0c 74 11 be 2e 06 00 00 48 c7 c7 e5 ee ad=20
[    0.033333] RIP  [<ffffffff8108e3be>] wake_up_process+0xa/0x37
[    0.033333]  RSP <ffff88000004fd10>
[    0.033333] CR2: 0000000000000000
[    0.033356] ---[ end trace 5811b7ce8c4f6c29 ]---
[    0.034206] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.035425] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-x3----1018/ea0225af2eca6d14e7f1d33bcb12fa1808273b6f/vmlinuz-3.12.0-rc3-000=
71-gea0225a -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D10=
0 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_p=
rintk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests=
/run-queue/kvm/x86_64-randconfig-x3----1018/userns:userns-always-map-user-v=
136/.vmlinuz-ea0225af2eca6d14e7f1d33bcb12fa1808273b6f-20131018085032-7-bens=
 branch=3Duserns/userns-always-map-user-v136 BOOT_IMAGE=3D/kernel/x86_64-ra=
ndconfig-x3----1018/ea0225af2eca6d14e7f1d33bcb12fa1808273b6f/vmlinuz-3.12.0=
-rc3-00071-gea0225a'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz=
 -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirti=
o -net user,vlan=3D0,hostfwd=3Dtcp::11557-:22 -net nic,vlan=3D1,model=3De10=
00 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive=
 file=3D/fs/sda7/disk0-yocto-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/sda7/disk1-yocto-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7=
/disk2-yocto-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk3-y=
octo-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk4-yocto-ben=
s-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk5-yocto-bens-4,medi=
a=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-bens-4 -serial file:=
/dev/shm/kboot/serial-yocto-bens-4 -daemonize -display none -monitor null=
=20

--tsOsTdHNUZQcU9Ye
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-ea0225af2eca6d14e7f1d33bcb12fa1808273b6f-x86_64-randconfig-x3----1018-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-120087.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDE1YzAzZGQ0ODU5YWIxNmY5MjEyMjM4ZjI5ZGQzMTU2NTRhYTk0ZjYK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZWEwMjI1YS4uLiBwaWRuczogIEFiYW5kb25l
ZCBhcHByb2FjaCB0byBjbGVhbmluZyB1cCBhZnRlciB0aGUgZmlyc3QgcGlkCkhFQUQgaXMg
bm93IGF0IDE1YzAzZGQuLi4gTGludXggMy4xMi1yYzMKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvdXNlcm5zOnVzZXJu
cy1hbHdheXMtbWFwLXVzZXItdjEzNjoxNWMwM2RkNDg1OWFiMTZmOTIxMjIzOGYyOWRkMzE1
NjU0YWE5NGY2OmJpc2VjdC11c2IKIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgMTVj
MDNkZDQ4NTlhYjE2ZjkyMTIyMzhmMjlkZDMxNTY1NGFhOTRmNgpnaXQgYmlzZWN0IHN0YXJ0
IGVhMDIyNWFmMmVjYTZkMTRlN2YxZDMzYmNiMTJmYTE4MDgyNzNiNmYgMTVjMDNkZDQ4NTlh
YjE2ZjkyMTIyMzhmMjlkZDMxNTY1NGFhOTRmNiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9u
IHdhcyAxNWMwM2RkLi4uIExpbnV4IDMuMTItcmMzCkhFQUQgaXMgbm93IGF0IDZlNDY2NDUu
Li4gTGludXggMy4xMQpCaXNlY3Rpbmc6IDM1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbNmY1ZjdmNDAyNTk3OGMyYWIwODMwODdmN2Jl
ZmMzNjhjN2MyYzIzZl0gcGlkOiAgS2lsbCB0YXNrX3RnaWRfbnIKZ2l0IGJpc2VjdCBydW4g
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
dXNiL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC91c2VybnM6
dXNlcm5zLWFsd2F5cy1tYXAtdXNlci12MTM2OjZmNWY3ZjQwMjU5NzhjMmFiMDgzMDg3Zjdi
ZWZjMzY4YzdjMmMyM2Y6YmlzZWN0LXVzYgogU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNyByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzhiNThm
ZjcyOGIxYWViYTMzZjI0ZGE1MjBhMTkyMTlkYmMzYjBjMjRdIGtnZGI6IFN0b3AgdXNpbmcg
dGFzay0+cGlkIGFuZCB0YXNrLT50Z2lkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEw
MTgvdXNlcm5zOnVzZXJucy1hbHdheXMtbWFwLXVzZXItdjEzNjo4YjU4ZmY3MjhiMWFlYmEz
M2YyNGRhNTIwYTE5MjE5ZGJjM2IwYzI0OmJpc2VjdC11c2IKIFRFU1QgRkFJTFVSRQpbICAg
IDAuMDE4NDA1XSBBQ1BJOiBDb3JlIHJldmlzaW9uIDIwMTMwNzI1ClsgICAgMC4wMjkxMjNd
IEFDUEk6IEFsbCBBQ1BJIFRhYmxlcyBzdWNjZXNzZnVsbHkgYWNxdWlyZWQKWyAgICAwLjAz
MDgxN10gUGVyZm9ybWFuY2UgRXZlbnRzOiB1bnN1cHBvcnRlZCBOZXRidXJzdCBDUFUgbW9k
ZWwgNiBubyBQTVUgZHJpdmVyLCBzb2Z0d2FyZSBldmVudHMgb25seS4KWyAgICAwLjAzNDA0
OV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVu
Y2UgYXQgICAgICAgICAgIChudWxsKQpbICAgIDAuMDM1NTAyXSBJUDogWzxmZmZmZmZmZjgx
MDhlM2NkPl0gd2FrZV91cF9wcm9jZXNzKzB4YS8weDM3ClsgICAgMC4wMzY2NTRdIFBHRCAw
IApbICAgIDAuMDM2NjY2XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCAKWyAgICAwLjAzNjY2
Nl0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTIuMC1yYzMt
MDAwNTMtZzhiNThmZjcgIzE4MApbICAgIDAuMDM2NjY2XSB0YXNrOiBmZmZmODgwMDAwMDUw
MDQwIHRpOiBmZmZmODgwMDAwMDRlMDAwIHRhc2sudGk6IGZmZmY4ODAwMDAwNGUwMDAKWyAg
ICAwLjAzNjY2Nl0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTA4ZTNjZD5dICBbPGZmZmZmZmZm
ODEwOGUzY2Q+XSB3YWtlX3VwX3Byb2Nlc3MrMHhhLzB4MzcKWyAgICAwLjAzNjY2Nl0gUlNQ
OiAwMDAwOmZmZmY4ODAwMDAwNGZkMTAgIEVGTEFHUzogMDAwMTAyNDYKWyAgICAwLjAzNjY2
Nl0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4MDAwMDA0ZmQ2MCBSQ1g6IDAw
MDAwMDAwMDAwMDAwNTgKWyAgICAwLjAzNjY2Nl0gUkRYOiAwMDAwMDAwMDAwMDgwMDU5IFJT
STogZmZmZmZmZmY4MTA4NWE2MSBSREk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAzNjY2
Nl0gUkJQOiBmZmZmODgwMDAwMDRmZDE4IFIwODogMDAwMDAwMDAwMDAwMDAwMSBSMDk6IDAw
MDAwMDAwMDAwMDAwNTgKWyAgICAwLjAzNjY2Nl0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIx
MTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IGZmZmZmZmZmODFhZGI4YjMKWyAgICAwLjAzNjY2
Nl0gUjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAw
MDAwMDAwMDAwMDAwMDAKWyAgICAwLjAzNjY2Nl0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAw
MDApIEdTOmZmZmZmZmZmODFjMWUwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApb
ICAgIDAuMDM2NjY2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAw
MDgwMDUwMDNiClsgICAgMC4wMzY2NjZdIENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAw
MDAwMDAwMDFjMGQwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIwClsgICAgMC4wMzY2NjZdIFN0
YWNrOgpbICAgIDAuMDM2NjY2XSAgZmZmZjg4MDAwMDA0ZmQ2MCBmZmZmODgwMDAwMDRmZTEw
IGZmZmZmZmZmODEwODVhNmQgMDAwMDAwMDAwMDAwMDAwYQpbICAgIDAuMDM2NjY2XSAgZmZm
Zjg4MDAwMDA1MDczMCBmZmZmZmZmZjgxMGE5ODkwIGZmZmZmZmZmODEwOGJjODUgZmZmZjg4
MDAwMDA5NDkyMApbICAgIDAuMDM2NjY2XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDAw
MDUwMDQwIGZmZmY4ODAwMDAwMDAwMDAgZGVhZDRlYWQwMDAwMDAwMQpbICAgIDAuMDM2NjY2
XSBDYWxsIFRyYWNlOgpbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxMDg1YTZkPl0ga3Ro
cmVhZF9jcmVhdGVfb25fbm9kZSsweDkyLzB4MTBjClsgICAgMC4wMzY2NjZdICBbPGZmZmZm
ZmZmODEwYTk4OTA+XSA/IG1hcmtfbG9jaysweDJlLzB4MjVhClsgICAgMC4wMzY2NjZdICBb
PGZmZmZmZmZmODEwOGJjODU+XSA/IF9fc21wYm9vdF9jcmVhdGVfdGhyZWFkKzB4OWQvMHg5
ZApbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxMDhiYzFmPl0gPyBfX3NtcGJvb3RfY3Jl
YXRlX3RocmVhZCsweDM3LzB4OWQKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MTA4YmMx
Zj5dID8gX19zbXBib290X2NyZWF0ZV90aHJlYWQrMHgzNy8weDlkClsgICAgMC4wMzY2NjZd
ICBbPGZmZmZmZmZmODEwODViN2Y+XSBrdGhyZWFkX2NyZWF0ZV9vbl9jcHUrMHgxYi8weDRj
ClsgICAgMC4wMzY2NjZdICBbPGZmZmZmZmZmODEwOGJjNDQ+XSBfX3NtcGJvb3RfY3JlYXRl
X3RocmVhZCsweDVjLzB4OWQKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MTA4YmZmND5d
IHNtcGJvb3RfcmVnaXN0ZXJfcGVyY3B1X3RocmVhZCsweDI5LzB4OGQKWyAgICAwLjAzNjY2
Nl0gIFs8ZmZmZmZmZmY4MWY4NjRjZT5dID8gZnRyYWNlX2RlZmluZV9maWVsZHNfc29mdGly
cSsweDMwLzB4MzAKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MWY4NjRkZT5dIHNwYXdu
X2tzb2Z0aXJxZCsweDEwLzB4MWEKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MWY3NmQ5
Zj5dIGRvX29uZV9pbml0Y2FsbCsweGFhLzB4MTM5ClsgICAgMC4wMzY2NjZdICBbPGZmZmZm
ZmZmODEwZGEzNWM+XSA/IHRyYWNlX3ByZWVtcHRfb24rMHgxMi8weDJmClsgICAgMC4wMzY2
NjZdICBbPGZmZmZmZmZmODEwOGU4NGQ+XSA/IHN1Yl9wcmVlbXB0X2NvdW50KzB4YjcvMHhk
YwpbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxZjc2ZWNlPl0ga2VybmVsX2luaXRfZnJl
ZWFibGUrMHhhMC8weDFjOQpbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxNmU0ZjhkPl0g
PyByZXN0X2luaXQrMHhjMS8weGMxClsgICAgMC4wMzY2NjZdICBbPGZmZmZmZmZmODE2ZTRm
OWI+XSBrZXJuZWxfaW5pdCsweGUvMHhkNgpbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgx
NmY1YzRhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICAwLjAzNjY2Nl0gIFs8ZmZm
ZmZmZmY4MTZlNGY4ZD5dID8gcmVzdF9pbml0KzB4YzEvMHhjMQpbICAgIDAuMDM2NjY2XSBD
b2RlOiA0NCA4OSBlMCA0MSA1YyA0MSA1ZCA0MSA1ZSA0MSA1ZiA1ZCBjMyBlOCA4YyA3NiA2
NiAwMCA1NSA0OCA4YiA3ZiAwOCA0OCA4OSBlNSBlOCBkYyBmZSBmZiBmZiA1ZCBjMyBlOCA3
OCA3NiA2NiAwMCA1NSA0OCA4OSBlNSA1MyA8NDg+IDhiIDA3IDQ4IDg5IGZiIGE4IDBjIDc0
IDExIGJlIDJlIDA2IDAwIDAwIDQ4IGM3IGM3IGM5IGU4IGFkIApbICAgIDAuMDM2NjY2XSBS
SVAgIFs8ZmZmZmZmZmY4MTA4ZTNjZD5dIHdha2VfdXBfcHJvY2VzcysweGEvMHgzNwpbICAg
IDAuMDM2NjY2XSAgUlNQIDxmZmZmODgwMDAwMDRmZDEwPgpbICAgIDAuMDM2NjY2XSBDUjI6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAzNjY4OF0gLS0tWyBlbmQgdHJhY2UgNzI5MGQx
MDM5ZmFhNTE1OSBdLS0tClsgICAgMC4wMzY2ODhdIC0tLVsgZW5kIHRyYWNlIDcyOTBkMTAz
OWZhYTUxNTkgXS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvOGI1
OGZmNzI4YjFhZWJhMzNmMjRkYTUyMGExOTIxOWRiYzNiMGMyNC9kbWVzZy1xdWFudGFsLWxr
cC10dDAyLTIzOjIwMTMxMDE4MTIzMzEyOng4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6
My4xMi4wLXJjMy0wMDA1My1nOGI1OGZmNzoxODAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14My0tLS0xMDE4LzhiNThmZjcyOGIxYWViYTMzZjI0ZGE1MjBhMTkyMTlkYmMzYjBjMjQv
ZG1lc2cteW9jdG8teHBzLTU6MjAxMzEwMTkwNTQ1MTE6eDg2XzY0LXJhbmRjb25maWcteDMt
LS0tMTAxODozLjEyLjAtcmMzLTAwMDUzLWc4YjU4ZmY3OjE4MAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXgzLS0tLTEwMTgvOGI1OGZmNzI4YjFhZWJhMzNmMjRkYTUyMGExOTIxOWRi
YzNiMGMyNC9kbWVzZy15b2N0by1pbm4tMTk6MjAxMzEwMTgyMTU4MzM6eDg2XzY0LXJhbmRj
b25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDUzLWc4YjU4ZmY3OjE4MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvOGI1OGZmNzI4YjFhZWJhMzNmMjRkYTUy
MGExOTIxOWRiYzNiMGMyNC9kbWVzZy15b2N0by1hdGhlbnMtMTA6MjAxMzEwMTgyMTU1Mzk6
eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDUzLWc4YjU4ZmY3
OjE4MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvOGI1OGZmNzI4YjFh
ZWJhMzNmMjRkYTUyMGExOTIxOWRiYzNiMGMyNC9kbWVzZy15b2N0by1sa3Atc3QwMS0xMDoy
MDEzMTAxODIxNTYyNDp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMt
MDAwNTMtZzhiNThmZjc6MTgwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAx
OC84YjU4ZmY3MjhiMWFlYmEzM2YyNGRhNTIwYTE5MjE5ZGJjM2IwYzI0L2RtZXNnLXlvY3Rv
LWF0aGVucy0zNjoyMDEzMTAxODIxNTYwNTp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4
OjMuMTIuMC1yYzMtMDAwNTMtZzhiNThmZjc6MTgwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDMtLS0tMTAxOC84YjU4ZmY3MjhiMWFlYmEzM2YyNGRhNTIwYTE5MjE5ZGJjM2IwYzI0
L2RtZXNnLXlvY3RvLXhpYW4tMzg6MjAxMzEwMTgyMTU4MzU6eDg2XzY0LXJhbmRjb25maWct
eDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDUzLWc4YjU4ZmY3OjE4MAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvOGI1OGZmNzI4YjFhZWJhMzNmMjRkYTUyMGExOTIx
OWRiYzNiMGMyNC9kbWVzZy1xdWFudGFsLWxrcC1zdDAxLTExOjIwMTMxMDE4MjE1NTQ3Ong4
Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA1My1nOGI1OGZmNzox
ODAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4LzhiNThmZjcyOGIxYWVi
YTMzZjI0ZGE1MjBhMTkyMTlkYmMzYjBjMjQvZG1lc2cteW9jdG8tbGtwLXN0MDEtODoyMDEz
MTAxODIxNTY1NDp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAw
NTMtZzhiNThmZjc6MTgwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC84
YjU4ZmY3MjhiMWFlYmEzM2YyNGRhNTIwYTE5MjE5ZGJjM2IwYzI0L2RtZXNnLXlvY3RvLWxr
cC1zdDAxLTg6MjAxMzEwMTgyMTU4NDE6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODoz
LjEyLjAtcmMzLTAwMDUzLWc4YjU4ZmY3OjE4MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXgzLS0tLTEwMTgvOGI1OGZmNzI4YjFhZWJhMzNmMjRkYTUyMGExOTIxOWRiYzNiMGMyNC9k
bWVzZy1xdWFudGFsLWxrcC10dDAyLTE2OjIwMTMxMDE4MTIzMjU0Ong4Nl82NC1yYW5kY29u
ZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA1My1nOGI1OGZmNzoxODAKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4LzhiNThmZjcyOGIxYWViYTMzZjI0ZGE1MjBh
MTkyMTlkYmMzYjBjMjQvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0zNToyMDEzMTAxODIxNTYz
ODp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNTMtZzhiNThm
Zjc6MTgwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC84YjU4ZmY3Mjhi
MWFlYmEzM2YyNGRhNTIwYTE5MjE5ZGJjM2IwYzI0L2RtZXNnLXF1YW50YWwtbmhtNC01OjIw
MTMxMDE4MTQxMDEyOng4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0w
MDA1My1nOGI1OGZmNzoxODAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4
LzhiNThmZjcyOGIxYWViYTMzZjI0ZGE1MjBhMTkyMTlkYmMzYjBjMjQvZG1lc2cteW9jdG8t
eHBzLTU6MjAxMzEwMTkwNTQ1Mjk6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEy
LjAtcmMzLTAwMDUzLWc4YjU4ZmY3OjE4MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgz
LS0tLTEwMTgvOGI1OGZmNzI4YjFhZWJhMzNmMjRkYTUyMGExOTIxOWRiYzNiMGMyNC9kbWVz
Zy15b2N0by1sa3Atc3QwMS0xMDoyMDEzMTAxODIxNTgwOTp4ODZfNjQtcmFuZGNvbmZpZy14
My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNTMtZzhiNThmZjc6MTgwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWcteDMtLS0tMTAxOC84YjU4ZmY3MjhiMWFlYmEzM2YyNGRhNTIwYTE5MjE5
ZGJjM2IwYzI0L2RtZXNnLXlvY3RvLWxrcC1zdDAxLTk6MjAxMzEwMTgyMTU3NTA6eDg2XzY0
LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDUzLWc4YjU4ZmY3OjE4MAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvOGI1OGZmNzI4YjFhZWJhMzNm
MjRkYTUyMGExOTIxOWRiYzNiMGMyNC9kbWVzZy1xdWFudGFsLWpha2V0b3duLTM6MjAxMzEw
MTgyMTU2MDE6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDUz
LWc4YjU4ZmY3OjE4MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvOGI1
OGZmNzI4YjFhZWJhMzNmMjRkYTUyMGExOTIxOWRiYzNiMGMyNC9kbWVzZy15b2N0by1pbm4t
MTI6MjAxMzEwMTgyMTU1NDM6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAt
cmMzLTAwMDUzLWc4YjU4ZmY3OjE4MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0t
LTEwMTgvOGI1OGZmNzI4YjFhZWJhMzNmMjRkYTUyMGExOTIxOWRiYzNiMGMyNC9kbWVzZy1x
dWFudGFsLWF0aGVucy0xMzoyMDEzMTAxODIxNTc0MDp4ODZfNjQtcmFuZGNvbmZpZy14My0t
LS0xMDE4OjMuMTIuMC1yYzMtMDAwNTMtZzhiNThmZjc6MTgwCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWcteDMtLS0tMTAxOC84YjU4ZmY3MjhiMWFlYmEzM2YyNGRhNTIwYTE5MjE5ZGJj
M2IwYzI0L2RtZXNnLXF1YW50YWwtYXRoZW5zLTQwOjIwMTMxMDE4MjE1NjAyOng4Nl82NC1y
YW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA1My1nOGI1OGZmNzoxODAKMDoy
MDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFUIENPVU5UOiAy
MCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogOCByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzNmMGY5
MDJjYTllMmY2MTFhMjk5MzczZDQ0MzA2ZDBjNDkxZDg4OThdIHlhbWE6IFN0b3AgdXNpbmcg
dGFzay0+cGlkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvdXNlcm5zOnVzZXJu
cy1hbHdheXMtbWFwLXVzZXItdjEzNjozZjBmOTAyY2E5ZTJmNjExYTI5OTM3M2Q0NDMwNmQw
YzQ5MWQ4ODk4OmJpc2VjdC11c2IKCjIwMTMtMTAtMTktMjA6Mjg6MTEgM2YwZjkwMmNhOWUy
ZjYxMWEyOTkzNzNkNDQzMDZkMGM0OTFkODg5OCBjb21waWxpbmcKMjYzIHJlYWwgIDExMDEg
dXNlciAgMTA2IHN5cyAgNDU3LjQ0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEw
MTgKCjIwMTMtMTAtMTktMjA6MzI6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJj
My0wMDA0NC1nM2YwZjkwMi4gVEVTVCBGQUlMVVJFClsgICAgMC4wMTk1MjBdIEFDUEk6IENv
cmUgcmV2aXNpb24gMjAxMzA3MjUKWyAgICAwLjAyOTg1MF0gQUNQSTogQWxsIEFDUEkgVGFi
bGVzIHN1Y2Nlc3NmdWxseSBhY3F1aXJlZApbICAgIDAuMDMxNDY2XSBQZXJmb3JtYW5jZSBF
dmVudHM6IHVuc3VwcG9ydGVkIE5ldGJ1cnN0IENQVSBtb2RlbCA2IG5vIFBNVSBkcml2ZXIs
IHNvZnR3YXJlIGV2ZW50cyBvbmx5LgpbICAgIDAuMDMzNDIxXSBCVUc6IHVuYWJsZSB0byBo
YW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51
bGwpClsgICAgMC4wMzQ5MDRdIElQOiBbPGZmZmZmZmZmODEwOGUzMDE+XSB3YWtlX3VwX3By
b2Nlc3MrMHhhLzB4MzcKWyAgICAwLjAzNTk4OF0gUEdEIDAgClsgICAgMC4wMzY0OTFdIE9v
cHM6IDAwMDAgWyMxXSBQUkVFTVBUIApbICAgIDAuMDM2NjY2XSBDUFU6IDAgUElEOiAxIENv
bW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMi4wLXJjMy0wMDA0NC1nM2YwZjkwMiAjNjY1
ClsgICAgMC4wMzY2NjZdIHRhc2s6IGZmZmY4ODAwMDAwNTAwNDAgdGk6IGZmZmY4ODAwMDAw
NGUwMDAgdGFzay50aTogZmZmZjg4MDAwMDA0ZTAwMApbICAgIDAuMDM2NjY2XSBSSVA6IDAw
MTA6WzxmZmZmZmZmZjgxMDhlMzAxPl0gIFs8ZmZmZmZmZmY4MTA4ZTMwMT5dIHdha2VfdXBf
cHJvY2VzcysweGEvMHgzNwpbICAgIDAuMDM2NjY2XSBSU1A6IDAwMDA6ZmZmZjg4MDAwMDA0
ZmQxMCAgRUZMQUdTOiAwMDAxMDI0NgpbICAgIDAuMDM2NjY2XSBSQVg6IDAwMDAwMDAwMDAw
MDAwMDAgUkJYOiBmZmZmODgwMDAwMDRmZDYwIFJDWDogMDAwMDAwMDAwMDAwMDA1OApbICAg
IDAuMDM2NjY2XSBSRFg6IDAwMDAwMDAwMDAwODAwNTkgUlNJOiBmZmZmZmZmZjgxMDg1OWY2
IFJESTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDM2NjY2XSBSQlA6IGZmZmY4ODAwMDAw
NGZkMTggUjA4OiAwMDAwMDAwMDAwMDAwMDAxIFIwOTogMDAwMDAwMDAwMDAwMDA1OApbICAg
IDAuMDM2NjY2XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMDAw
IFIxMjogZmZmZmZmZmY4MWFkYjZlOQpbICAgIDAuMDM2NjY2XSBSMTM6IDAwMDAwMDAwMDAw
MDAwMDAgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAg
IDAuMDM2NjY2XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MWMx
ZTAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMzY2NjZdIENTOiAg
MDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAwLjAz
NjY2Nl0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAwMWMwZDAwMCBDUjQ6
IDAwMDAwMDAwMDAwMDA2YjAKWyAgICAwLjAzNjY2Nl0gU3RhY2s6ClsgICAgMC4wMzY2NjZd
ICBmZmZmODgwMDAwMDRmZDYwIGZmZmY4ODAwMDAwNGZlMTAgZmZmZmZmZmY4MTA4NWEwMiAw
MDAwMDAwMDAwMDAwMDBhClsgICAgMC4wMzY2NjZdICBmZmZmODgwMDAwMDUwNzMwIGZmZmZm
ZmZmODEwYTk4NjEgZmZmZmZmZmY4MTA4YmMxYSBmZmZmODgwMDAwMDk0OTIwClsgICAgMC4w
MzY2NjZdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMDAwNTAwNDAgZmZmZjg4MDAwMDAw
MDAwMCBkZWFkNGVhZDAwMDAwMDAxClsgICAgMC4wMzY2NjZdIENhbGwgVHJhY2U6ClsgICAg
MC4wMzY2NjZdICBbPGZmZmZmZmZmODEwODVhMDI+XSBrdGhyZWFkX2NyZWF0ZV9vbl9ub2Rl
KzB4OTIvMHgxMGMKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MTBhOTg2MT5dID8gbWFy
a19sb2NrKzB4MmUvMHgyNWEKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MTA4YmMxYT5d
ID8gX19zbXBib290X2NyZWF0ZV90aHJlYWQrMHg5ZC8weDlkClsgICAgMC4wMzY2NjZdICBb
PGZmZmZmZmZmODEwOGJiYjQ+XSA/IF9fc21wYm9vdF9jcmVhdGVfdGhyZWFkKzB4MzcvMHg5
ZApbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxMDhiYmI0Pl0gPyBfX3NtcGJvb3RfY3Jl
YXRlX3RocmVhZCsweDM3LzB4OWQKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MTA4NWIx
ND5dIGt0aHJlYWRfY3JlYXRlX29uX2NwdSsweDFiLzB4NGMKWyAgICAwLjAzNjY2Nl0gIFs8
ZmZmZmZmZmY4MTA4YmJkOT5dIF9fc21wYm9vdF9jcmVhdGVfdGhyZWFkKzB4NWMvMHg5ZApb
ICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxMDhiZjg5Pl0gc21wYm9vdF9yZWdpc3Rlcl9w
ZXJjcHVfdGhyZWFkKzB4MjkvMHg4ZApbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxZjg2
NGNlPl0gPyBmdHJhY2VfZGVmaW5lX2ZpZWxkc19zb2Z0aXJxKzB4MzAvMHgzMApbICAgIDAu
MDM2NjY2XSAgWzxmZmZmZmZmZjgxZjg2NGRlPl0gc3Bhd25fa3NvZnRpcnFkKzB4MTAvMHgx
YQpbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxZjc2ZDlmPl0gZG9fb25lX2luaXRjYWxs
KzB4YWEvMHgxMzkKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MTBkYTI5ZT5dID8gdHJh
Y2VfcHJlZW1wdF9vbisweDEyLzB4MmYKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MTA4
ZTc4MT5dID8gc3ViX3ByZWVtcHRfY291bnQrMHhiNy8weGRjClsgICAgMC4wMzY2NjZdICBb
PGZmZmZmZmZmODFmNzZlY2U+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGEwLzB4MWM5Clsg
ICAgMC4wMzY2NjZdICBbPGZmZmZmZmZmODE2ZTRkM2Q+XSA/IHJlc3RfaW5pdCsweGMxLzB4
YzEKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MTZlNGQ0Yj5dIGtlcm5lbF9pbml0KzB4
ZS8weGQ2ClsgICAgMC4wMzY2NjZdICBbPGZmZmZmZmZmODE2ZjVhMGE+XSByZXRfZnJvbV9m
b3JrKzB4N2EvMHhiMApbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxNmU0ZDNkPl0gPyBy
ZXN0X2luaXQrMHhjMS8weGMxClsgICAgMC4wMzY2NjZdIENvZGU6IDQ0IDg5IGUwIDQxIDVj
IDQxIDVkIDQxIDVlIDQxIDVmIDVkIGMzIGU4IDE4IDc1IDY2IDAwIDU1IDQ4IDhiIDdmIDA4
IDQ4IDg5IGU1IGU4IGRjIGZlIGZmIGZmIDVkIGMzIGU4IDA0IDc1IDY2IDAwIDU1IDQ4IDg5
IGU1IDUzIDw0OD4gOGIgMDcgNDggODkgZmIgYTggMGMgNzQgMTEgYmUgMmUgMDYgMDAgMDAg
NDggYzcgYzcgNmUgZTYgYWQgClsgICAgMC4wMzY2NjZdIFJJUCAgWzxmZmZmZmZmZjgxMDhl
MzAxPl0gd2FrZV91cF9wcm9jZXNzKzB4YS8weDM3ClsgICAgMC4wMzY2NjZdICBSU1AgPGZm
ZmY4ODAwMDAwNGZkMTA+ClsgICAgMC4wMzY2NjZdIENSMjogMDAwMDAwMDAwMDAwMDAwMApb
ICAgIDAuMDM2Njg5XSAtLS1bIGVuZCB0cmFjZSAzOGMyYjViODg2N2IzYWJhIF0tLS0KWyAg
ICAwLjAzNjY4OV0gLS0tWyBlbmQgdHJhY2UgMzhjMmI1Yjg4NjdiM2FiYSBdLS0tCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC8zZjBmOTAyY2E5ZTJmNjExYTI5OTM3
M2Q0NDMwNmQwYzQ5MWQ4ODk4L2RtZXNnLXF1YW50YWwtYXRoZW5zLTQ1OjIwMTMxMDE5MjAz
MzAzOng4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA0NC1nM2Yw
ZjkwMjo2NjUKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVB
VCBDT1VOVDogMjAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rp
bmc6IDQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3Rl
cHMpCls4N2VhYzRhN2Y4ZGRjYmIzZmJmOWFkZTc2YTk3NWIyNjBkNjdkN2I1XSBwaWQ6IE1v
ZGlmeSBpc19pZGxlX3Rhc2sgdG8gdGVzdCBwaWQgcG9pbnRlcnMgaW5zdGVhZCBvZiBwaWQg
bnVtYmVycwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L3VzZXJuczp1c2VybnMt
YWx3YXlzLW1hcC11c2VyLXYxMzY6ODdlYWM0YTdmOGRkY2JiM2ZiZjlhZGU3NmE5NzViMjYw
ZDY3ZDdiNTpiaXNlY3QtdXNiCgoyMDEzLTEwLTE5LTIwOjMzOjIzIDg3ZWFjNGE3ZjhkZGNi
YjNmYmY5YWRlNzZhOTc1YjI2MGQ2N2Q3YjUgY29tcGlsaW5nCjE0IHJlYWwgIDMzIHVzZXIg
IDEwIHN5cyAgMzA0LjQzJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgKCjIw
MTMtMTAtMTktMjA6MzM6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMy0wMDAz
OS1nODdlYWM0YS4JMS4uLi4uLgkyCTMJNQk3LgkxMAkxMgkxNgkxOQkyMC4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA5ODAbWzBtCi4J
MzUJNDYJNzYJMTEzCTE0NgkxNzkJMjE3CTI0MwkyODIJMzE3CTM0Nwk0MDQJNDMyCTQ2MQk1
MDYJNTQ2CTU3Ngk2MTAJNjQ4CTY5MAk3MzMJNzcxCTgyMQk4NDcJODc1CTkwNQk5MjkJOTU2
CTk3Ngk5ODMJOTkxCTk5Mwk5OTQJOTk1CTk5Nwk5OTgJOTk5CTEwMDAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAx
IHN0ZXApCltlN2NkMWZlODljMzljY2MzYWY2OGI2YWRhYjY0OGI2YjA2NWJjNGUxXSBwaWQ6
ICBNb2RpZnkgcmVxdWVzdF9rZXlfYXV0aCB0byB1c2Ugc3RydWN0IHBpZCBpbnN0ZWFkIG9m
IHBpZF90IHZhbHVlcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L3VzZXJuczp1
c2VybnMtYWx3YXlzLW1hcC11c2VyLXYxMzY6ZTdjZDFmZTg5YzM5Y2NjM2FmNjhiNmFkYWI2
NDhiNmIwNjViYzRlMTpiaXNlY3QtdXNiCgoyMDEzLTEwLTE5LTIzOjMyOjU1IGU3Y2QxZmU4
OWMzOWNjYzNhZjY4YjZhZGFiNjQ4YjZiMDY1YmM0ZTEgY29tcGlsaW5nCjIxIHJlYWwgIDMz
IHVzZXIgIDExIHN5cyAgMjEzLjI3JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEw
MTgKCjIwMTMtMTAtMTktMjM6MzM6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJj
My0wMDA0MS1nZTdjZDFmZS4gVEVTVCBGQUlMVVJFClsgICAgMC4wMTg0NjJdIEFDUEk6IENv
cmUgcmV2aXNpb24gMjAxMzA3MjUKWyAgICAwLjAyOTEwNF0gQUNQSTogQWxsIEFDUEkgVGFi
bGVzIHN1Y2Nlc3NmdWxseSBhY3F1aXJlZApbICAgIDAuMDMwODYyXSBQZXJmb3JtYW5jZSBF
dmVudHM6IHVuc3VwcG9ydGVkIE5ldGJ1cnN0IENQVSBtb2RlbCA2IG5vIFBNVSBkcml2ZXIs
IHNvZnR3YXJlIGV2ZW50cyBvbmx5LgpbICAgIDAuMDMyNTYwXSBCVUc6IHVuYWJsZSB0byBo
YW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51
bGwpClsgICAgMC4wMzMzMzNdIElQOiBbPGZmZmZmZmZmODEwOGUyZWQ+XSB3YWtlX3VwX3By
b2Nlc3MrMHhhLzB4MzcKWyAgICAwLjAzMzMzM10gUEdEIDAgClsgICAgMC4wMzMzMzNdIE9v
cHM6IDAwMDAgWyMxXSBQUkVFTVBUIApbICAgIDAuMDMzMzMzXSBDUFU6IDAgUElEOiAxIENv
bW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMi4wLXJjMy0wMDA0MS1nZTdjZDFmZSAjNjY3
ClsgICAgMC4wMzMzMzNdIHRhc2s6IGZmZmY4ODAwMDAwNTAwNDAgdGk6IGZmZmY4ODAwMDAw
NGUwMDAgdGFzay50aTogZmZmZjg4MDAwMDA0ZTAwMApbICAgIDAuMDMzMzMzXSBSSVA6IDAw
MTA6WzxmZmZmZmZmZjgxMDhlMmVkPl0gIFs8ZmZmZmZmZmY4MTA4ZTJlZD5dIHdha2VfdXBf
cHJvY2VzcysweGEvMHgzNwpbICAgIDAuMDMzMzMzXSBSU1A6IDAwMDA6ZmZmZjg4MDAwMDA0
ZmQxMCAgRUZMQUdTOiAwMDAxMDI0NgpbICAgIDAuMDMzMzMzXSBSQVg6IDAwMDAwMDAwMDAw
MDAwMDAgUkJYOiBmZmZmODgwMDAwMDRmZDYwIFJDWDogMDAwMDAwMDAwMDAwMDA1OApbICAg
IDAuMDMzMzMzXSBSRFg6IDAwMDAwMDAwMDAwODAwNTkgUlNJOiBmZmZmZmZmZjgxMDg1OWY2
IFJESTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDMzMzMzXSBSQlA6IGZmZmY4ODAwMDAw
NGZkMTggUjA4OiAwMDAwMDAwMDAwMDAwMDAxIFIwOTogMDAwMDAwMDAwMDAwMDA1OApbICAg
IDAuMDMzMzMzXSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMDAw
IFIxMjogZmZmZmZmZmY4MWFkYjZlOQpbICAgIDAuMDMzMzMzXSBSMTM6IDAwMDAwMDAwMDAw
MDAwMDAgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAg
IDAuMDMzMzMzXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MWMx
ZTAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMzMzMzNdIENTOiAg
MDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAwLjAz
MzMzM10gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAwMWMwZDAwMCBDUjQ6
IDAwMDAwMDAwMDAwMDA2YjAKWyAgICAwLjAzMzMzM10gU3RhY2s6ClsgICAgMC4wMzMzMzNd
ICBmZmZmODgwMDAwMDRmZDYwIGZmZmY4ODAwMDAwNGZlMTAgZmZmZmZmZmY4MTA4NWEwMiAw
MDAwMDAwMDAwMDAwMDBhClsgICAgMC4wMzMzMzNdICBmZmZmODgwMDAwMDUwNzMwIGZmZmZm
ZmZmODEwYTk4NGQgZmZmZmZmZmY4MTA4YmMwNiBmZmZmODgwMDAwMDk0OTIwClsgICAgMC4w
MzMzMzNdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMDAwNTAwNDAgZmZmZjg4MDAwMDAw
MDAwMCBkZWFkNGVhZDAwMDAwMDAxClsgICAgMC4wMzMzMzNdIENhbGwgVHJhY2U6ClsgICAg
MC4wMzMzMzNdICBbPGZmZmZmZmZmODEwODVhMDI+XSBrdGhyZWFkX2NyZWF0ZV9vbl9ub2Rl
KzB4OTIvMHgxMGMKWyAgICAwLjAzMzMzM10gIFs8ZmZmZmZmZmY4MTBhOTg0ZD5dID8gbWFy
a19sb2NrKzB4MmUvMHgyNWEKWyAgICAwLjAzMzMzM10gIFs8ZmZmZmZmZmY4MTA4YmMwNj5d
ID8gX19zbXBib290X2NyZWF0ZV90aHJlYWQrMHg5ZC8weDlkClsgICAgMC4wMzMzMzNdICBb
PGZmZmZmZmZmODEwOGJiYTA+XSA/IF9fc21wYm9vdF9jcmVhdGVfdGhyZWFkKzB4MzcvMHg5
ZApbICAgIDAuMDMzMzMzXSAgWzxmZmZmZmZmZjgxMDhiYmEwPl0gPyBfX3NtcGJvb3RfY3Jl
YXRlX3RocmVhZCsweDM3LzB4OWQKWyAgICAwLjAzMzMzM10gIFs8ZmZmZmZmZmY4MTA4NWIx
ND5dIGt0aHJlYWRfY3JlYXRlX29uX2NwdSsweDFiLzB4NGMKWyAgICAwLjAzMzMzM10gIFs8
ZmZmZmZmZmY4MTA4YmJjNT5dIF9fc21wYm9vdF9jcmVhdGVfdGhyZWFkKzB4NWMvMHg5ZApb
ICAgIDAuMDMzMzMzXSAgWzxmZmZmZmZmZjgxMDhiZjc1Pl0gc21wYm9vdF9yZWdpc3Rlcl9w
ZXJjcHVfdGhyZWFkKzB4MjkvMHg4ZApbICAgIDAuMDMzMzMzXSAgWzxmZmZmZmZmZjgxZjg2
NGNlPl0gPyBmdHJhY2VfZGVmaW5lX2ZpZWxkc19zb2Z0aXJxKzB4MzAvMHgzMApbICAgIDAu
MDMzMzMzXSAgWzxmZmZmZmZmZjgxZjg2NGRlPl0gc3Bhd25fa3NvZnRpcnFkKzB4MTAvMHgx
YQpbICAgIDAuMDMzMzMzXSAgWzxmZmZmZmZmZjgxZjc2ZDlmPl0gZG9fb25lX2luaXRjYWxs
KzB4YWEvMHgxMzkKWyAgICAwLjAzMzMzM10gIFs8ZmZmZmZmZmY4MTBkYTI4YT5dID8gdHJh
Y2VfcHJlZW1wdF9vbisweDEyLzB4MmYKWyAgICAwLjAzMzMzM10gIFs8ZmZmZmZmZmY4MTA4
ZTc2ZD5dID8gc3ViX3ByZWVtcHRfY291bnQrMHhiNy8weGRjClsgICAgMC4wMzMzMzNdICBb
PGZmZmZmZmZmODFmNzZlY2U+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGEwLzB4MWM5Clsg
ICAgMC4wMzMzMzNdICBbPGZmZmZmZmZmODE2ZTRkMmQ+XSA/IHJlc3RfaW5pdCsweGMxLzB4
YzEKWyAgICAwLjAzMzMzM10gIFs8ZmZmZmZmZmY4MTZlNGQzYj5dIGtlcm5lbF9pbml0KzB4
ZS8weGQ2ClsgICAgMC4wMzMzMzNdICBbPGZmZmZmZmZmODE2ZjU5Y2E+XSByZXRfZnJvbV9m
b3JrKzB4N2EvMHhiMApbICAgIDAuMDMzMzMzXSAgWzxmZmZmZmZmZjgxNmU0ZDJkPl0gPyBy
ZXN0X2luaXQrMHhjMS8weGMxClsgICAgMC4wMzMzMzNdIENvZGU6IDQ0IDg5IGUwIDQxIDVj
IDQxIDVkIDQxIDVlIDQxIDVmIDVkIGMzIGU4IGVjIDc0IDY2IDAwIDU1IDQ4IDhiIDdmIDA4
IDQ4IDg5IGU1IGU4IGRjIGZlIGZmIGZmIDVkIGMzIGU4IGQ4IDc0IDY2IDAwIDU1IDQ4IDg5
IGU1IDUzIDw0OD4gOGIgMDcgNDggODkgZmIgYTggMGMgNzQgMTEgYmUgMmUgMDYgMDAgMDAg
NDggYzcgYzcgNmUgZTYgYWQgClsgICAgMC4wMzMzMzNdIFJJUCAgWzxmZmZmZmZmZjgxMDhl
MmVkPl0gd2FrZV91cF9wcm9jZXNzKzB4YS8weDM3ClsgICAgMC4wMzMzMzNdICBSU1AgPGZm
ZmY4ODAwMDAwNGZkMTA+ClsgICAgMC4wMzMzMzNdIENSMjogMDAwMDAwMDAwMDAwMDAwMApb
ICAgIDAuMDMzMzU5XSAtLS1bIGVuZCB0cmFjZSBjY2Y3MDllMDA4MGU2YmEzIF0tLS0KWyAg
ICAwLjAzMzM1OV0gLS0tWyBlbmQgdHJhY2UgY2NmNzA5ZTAwODBlNmJhMyBdLS0tCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9lN2NkMWZlODljMzljY2MzYWY2OGI2
YWRhYjY0OGI2YjA2NWJjNGUxL2RtZXNnLXF1YW50YWwtaW5uLTM6MjAxMzEwMTkyMzMzMzU6
eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDQxLWdlN2NkMWZl
OjY2Nwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvZTdjZDFmZTg5YzM5
Y2NjM2FmNjhiNmFkYWI2NDhiNmIwNjViYzRlMS9kbWVzZy1xdWFudGFsLWpha2V0b3duLTM6
MjAxMzEwMTkyMzMzMzg6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMz
LTAwMDQxLWdlN2NkMWZlOjY2Nwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEw
MTgvZTdjZDFmZTg5YzM5Y2NjM2FmNjhiNmFkYWI2NDhiNmIwNjViYzRlMS9kbWVzZy1xdWFu
dGFsLW5obTQtMzoyMDEzMTAxOTE1NDU1MTp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4
OjMuMTIuMC1yYzMtMDAwNDEtZ2U3Y2QxZmU6NjY3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDMtLS0tMTAxOC9lN2NkMWZlODljMzljY2MzYWY2OGI2YWRhYjY0OGI2YjA2NWJjNGUx
L2RtZXNnLXlvY3RvLWF0aGVucy0zNjoyMDEzMTAxOTIzMzMzNDp4ODZfNjQtcmFuZGNvbmZp
Zy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNDEtZ2U3Y2QxZmU6NjY3Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9lN2NkMWZlODljMzljY2MzYWY2OGI2YWRhYjY0
OGI2YjA2NWJjNGUxL2RtZXNnLXlvY3RvLWpha2V0b3duLTI5OjIwMTMxMDE5MjMzMzM4Ong4
Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA0MS1nZTdjZDFmZTo2
NjcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2U3Y2QxZmU4OWMzOWNj
YzNhZjY4YjZhZGFiNjQ4YjZiMDY1YmM0ZTEvZG1lc2cteW9jdG8tbGtwLXN0MDEtMjoyMDEz
MTAxOTIzMzMzNjp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAw
NDEtZ2U3Y2QxZmU6NjY3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9l
N2NkMWZlODljMzljY2MzYWY2OGI2YWRhYjY0OGI2YjA2NWJjNGUxL2RtZXNnLXlvY3RvLXdh
aW1lYS0yOjIwMTMxMDIwMDczMjMwOng4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4x
Mi4wLXJjMy0wMDA0MS1nZTdjZDFmZTo2NjcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14
My0tLS0xMDE4L2U3Y2QxZmU4OWMzOWNjYzNhZjY4YjZhZGFiNjQ4YjZiMDY1YmM0ZTEvZG1l
c2ctcXVhbnRhbC1hdGhlbnMtMzI6MjAxMzEwMTkyMzMzNDM6eDg2XzY0LXJhbmRjb25maWct
eDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDQxLWdlN2NkMWZlOjY2Nwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvZTdjZDFmZTg5YzM5Y2NjM2FmNjhiNmFkYWI2NDhi
NmIwNjViYzRlMS9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTExOjIwMTMxMDE5MTQxMTI2Ong4
Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA0MS1nZTdjZDFmZTo2
NjcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2U3Y2QxZmU4OWMzOWNj
YzNhZjY4YjZhZGFiNjQ4YjZiMDY1YmM0ZTEvZG1lc2ctcXVhbnRhbC1zbmItMjg6MjAxMzEw
MTkyMzMzNDA6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDQx
LWdlN2NkMWZlOjY2Nwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvZTdj
ZDFmZTg5YzM5Y2NjM2FmNjhiNmFkYWI2NDhiNmIwNjViYzRlMS9kbWVzZy1xdWFudGFsLXN0
b2FrbGV5LTI6MjAxMzEwMTkyMzMzNDE6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODoz
LjEyLjAtcmMzLTAwMDQxLWdlN2NkMWZlOjY2Nwova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXgzLS0tLTEwMTgvZTdjZDFmZTg5YzM5Y2NjM2FmNjhiNmFkYWI2NDhiNmIwNjViYzRlMS9k
bWVzZy1xdWFudGFsLXhpYW4tODoyMDEzMTAxOTIzMzM0Mjp4ODZfNjQtcmFuZGNvbmZpZy14
My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNDEtZ2U3Y2QxZmU6NjY3Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWcteDMtLS0tMTAxOC9lN2NkMWZlODljMzljY2MzYWY2OGI2YWRhYjY0OGI2
YjA2NWJjNGUxL2RtZXNnLXlvY3RvLWpha2V0b3duLTE5OjIwMTMxMDE5MjMzMzM5Ong4Nl82
NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA0MS1nZTdjZDFmZTo2NjcK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2U3Y2QxZmU4OWMzOWNjYzNh
ZjY4YjZhZGFiNjQ4YjZiMDY1YmM0ZTEvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0yMDoyMDEz
MTAxOTE0MTEyOTp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAw
NDEtZ2U3Y2QxZmU6NjY3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9l
N2NkMWZlODljMzljY2MzYWY2OGI2YWRhYjY0OGI2YjA2NWJjNGUxL2RtZXNnLXF1YW50YWwt
eGlhbi0yNToyMDEzMTAxOTIzMzM0NDp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMu
MTIuMC1yYzMtMDAwNDEtZ2U3Y2QxZmU6NjY3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
eDMtLS0tMTAxOC9lN2NkMWZlODljMzljY2MzYWY2OGI2YWRhYjY0OGI2YjA2NWJjNGUxL2Rt
ZXNnLXF1YW50YWwtYXRoZW5zLTE2OjIwMTMxMDE5MjMzMzQ3Ong4Nl82NC1yYW5kY29uZmln
LXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA0MS1nZTdjZDFmZTo2NjcKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2U3Y2QxZmU4OWMzOWNjYzNhZjY4YjZhZGFiNjQ4
YjZiMDY1YmM0ZTEvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0xNToyMDEzMTAxOTE0MTEzMTp4
ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNDEtZ2U3Y2QxZmU6
NjY3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9lN2NkMWZlODljMzlj
Y2MzYWY2OGI2YWRhYjY0OGI2YjA2NWJjNGUxL2RtZXNnLXlvY3RvLWF0aGVucy0xMToyMDEz
MTAxOTIzMzM0ODp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAw
NDEtZ2U3Y2QxZmU6NjY3CjA6MTg6MTggYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJp
c2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MCBzdGVwcykKW2ZkOTdlODdkNDExMmY1ZWMzMzIyM2IwYmRjM2I3YjA3YjI3M2VjYmVdIHBp
ZDogU3RvcCBvcGVuIGNvZGluZyBpc19pZGxlX3Rhc2sgaW4gZm9yay4KcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Iv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWcteDMtLS0tMTAxOC91c2VybnM6dXNlcm5zLWFsd2F5cy1tYXAtdXNlci12MTM2
OmZkOTdlODdkNDExMmY1ZWMzMzIyM2IwYmRjM2I3YjA3YjI3M2VjYmU6YmlzZWN0LXVzYgoK
MjAxMy0xMC0xOS0yMzozMzo1OCBmZDk3ZTg3ZDQxMTJmNWVjMzMyMjNiMGJkYzNiN2IwN2Iy
NzNlY2JlIGNvbXBpbGluZwoyMCByZWFsICAzMSB1c2VyICAxMCBzeXMgIDIxMS4zMyUgY3B1
IAl4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4CgoyMDEzLTEwLTE5LTIzOjM0OjI4IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzMtMDAwNDAtZ2ZkOTdlODcuIFRFU1QgRkFJ
TFVSRQpbICAgIDAuMDE4NzkzXSBBQ1BJOiBDb3JlIHJldmlzaW9uIDIwMTMwNzI1ClsgICAg
MC4wMjk0NTNdIEFDUEk6IEFsbCBBQ1BJIFRhYmxlcyBzdWNjZXNzZnVsbHkgYWNxdWlyZWQK
WyAgICAwLjAzMDkwM10gUGVyZm9ybWFuY2UgRXZlbnRzOiB1bnN1cHBvcnRlZCBOZXRidXJz
dCBDUFUgbW9kZWwgNiBubyBQTVUgZHJpdmVyLCBzb2Z0d2FyZSBldmVudHMgb25seS4KWyAg
ICAwLjAzMzQzM10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIg
ZGVyZWZlcmVuY2UgYXQgICAgICAgICAgIChudWxsKQpbICAgIDAuMDM0OTI1XSBJUDogWzxm
ZmZmZmZmZjgxMDhlMmVkPl0gd2FrZV91cF9wcm9jZXNzKzB4YS8weDM3ClsgICAgMC4wMzYw
MjBdIFBHRCAwIApbICAgIDAuMDM2NDQ3XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCAKWyAg
ICAwLjAzNjY2Nl0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMu
MTIuMC1yYzMtMDAwNDAtZ2ZkOTdlODcgIzY2OApbICAgIDAuMDM2NjY2XSB0YXNrOiBmZmZm
ODgwMDAwMDUwMDQwIHRpOiBmZmZmODgwMDAwMDRlMDAwIHRhc2sudGk6IGZmZmY4ODAwMDAw
NGUwMDAKWyAgICAwLjAzNjY2Nl0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTA4ZTJlZD5dICBb
PGZmZmZmZmZmODEwOGUyZWQ+XSB3YWtlX3VwX3Byb2Nlc3MrMHhhLzB4MzcKWyAgICAwLjAz
NjY2Nl0gUlNQOiAwMDAwOmZmZmY4ODAwMDAwNGZkMTAgIEVGTEFHUzogMDAwMTAyNDYKWyAg
ICAwLjAzNjY2Nl0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4MDAwMDA0ZmQ2
MCBSQ1g6IDAwMDAwMDAwMDAwMDAwNTgKWyAgICAwLjAzNjY2Nl0gUkRYOiAwMDAwMDAwMDAw
MDgwMDU5IFJTSTogZmZmZmZmZmY4MTA4NTlmNiBSREk6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICAwLjAzNjY2Nl0gUkJQOiBmZmZmODgwMDAwMDRmZDE4IFIwODogMDAwMDAwMDAwMDAwMDAw
MSBSMDk6IDAwMDAwMDAwMDAwMDAwNTgKWyAgICAwLjAzNjY2Nl0gUjEwOiAwMDAwMDAwMDAw
MDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IGZmZmZmZmZmODFhZGI2ZTkKWyAg
ICAwLjAzNjY2Nl0gUjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogMDAwMDAwMDAwMDAwMDAw
MCBSMTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAzNjY2Nl0gRlM6ICAwMDAwMDAwMDAw
MDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODFjMWUwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAw
MDAwMDAwMApbICAgIDAuMDM2NjY2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1Iw
OiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMC4wMzY2NjZdIENSMjogMDAwMDAwMDAwMDAwMDAw
MCBDUjM6IDAwMDAwMDAwMDFjMGQwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIwClsgICAgMC4w
MzY2NjZdIFN0YWNrOgpbICAgIDAuMDM2NjY2XSAgZmZmZjg4MDAwMDA0ZmQ2MCBmZmZmODgw
MDAwMDRmZTEwIGZmZmZmZmZmODEwODVhMDIgMDAwMDAwMDAwMDAwMDAwYQpbICAgIDAuMDM2
NjY2XSAgZmZmZjg4MDAwMDA1MDczMCBmZmZmZmZmZjgxMGE5ODRkIGZmZmZmZmZmODEwOGJj
MDYgZmZmZjg4MDAwMDA5NDkyMApbICAgIDAuMDM2NjY2XSAgMDAwMDAwMDAwMDAwMDAwMCBm
ZmZmODgwMDAwMDUwMDQwIGZmZmY4ODAwMDAwMDAwMDAgZGVhZDRlYWQwMDAwMDAwMQpbICAg
IDAuMDM2NjY2XSBDYWxsIFRyYWNlOgpbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxMDg1
YTAyPl0ga3RocmVhZF9jcmVhdGVfb25fbm9kZSsweDkyLzB4MTBjClsgICAgMC4wMzY2NjZd
ICBbPGZmZmZmZmZmODEwYTk4NGQ+XSA/IG1hcmtfbG9jaysweDJlLzB4MjVhClsgICAgMC4w
MzY2NjZdICBbPGZmZmZmZmZmODEwOGJjMDY+XSA/IF9fc21wYm9vdF9jcmVhdGVfdGhyZWFk
KzB4OWQvMHg5ZApbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxMDhiYmEwPl0gPyBfX3Nt
cGJvb3RfY3JlYXRlX3RocmVhZCsweDM3LzB4OWQKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZm
ZmY4MTA4YmJhMD5dID8gX19zbXBib290X2NyZWF0ZV90aHJlYWQrMHgzNy8weDlkClsgICAg
MC4wMzY2NjZdICBbPGZmZmZmZmZmODEwODViMTQ+XSBrdGhyZWFkX2NyZWF0ZV9vbl9jcHUr
MHgxYi8weDRjClsgICAgMC4wMzY2NjZdICBbPGZmZmZmZmZmODEwOGJiYzU+XSBfX3NtcGJv
b3RfY3JlYXRlX3RocmVhZCsweDVjLzB4OWQKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4
MTA4YmY3NT5dIHNtcGJvb3RfcmVnaXN0ZXJfcGVyY3B1X3RocmVhZCsweDI5LzB4OGQKWyAg
ICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MWY4NjRjZT5dID8gZnRyYWNlX2RlZmluZV9maWVs
ZHNfc29mdGlycSsweDMwLzB4MzAKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZmZmY4MWY4NjRk
ZT5dIHNwYXduX2tzb2Z0aXJxZCsweDEwLzB4MWEKWyAgICAwLjAzNjY2Nl0gIFs8ZmZmZmZm
ZmY4MWY3NmQ5Zj5dIGRvX29uZV9pbml0Y2FsbCsweGFhLzB4MTM5ClsgICAgMC4wMzY2NjZd
ICBbPGZmZmZmZmZmODEwZGEyOGE+XSA/IHRyYWNlX3ByZWVtcHRfb24rMHgxMi8weDJmClsg
ICAgMC4wMzY2NjZdICBbPGZmZmZmZmZmODEwOGU3NmQ+XSA/IHN1Yl9wcmVlbXB0X2NvdW50
KzB4YjcvMHhkYwpbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgxZjc2ZWNlPl0ga2VybmVs
X2luaXRfZnJlZWFibGUrMHhhMC8weDFjOQpbICAgIDAuMDM2NjY2XSAgWzxmZmZmZmZmZjgx
NmU0ZDJkPl0gPyByZXN0X2luaXQrMHhjMS8weGMxClsgICAgMC4wMzY2NjZdICBbPGZmZmZm
ZmZmODE2ZTRkM2I+XSBrZXJuZWxfaW5pdCsweGUvMHhkNgpbICAgIDAuMDM2NjY2XSAgWzxm
ZmZmZmZmZjgxNmY1OWNhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICAwLjAzNjY2
Nl0gIFs8ZmZmZmZmZmY4MTZlNGQyZD5dID8gcmVzdF9pbml0KzB4YzEvMHhjMQpbICAgIDAu
MDM2NjY2XSBDb2RlOiA0NCA4OSBlMCA0MSA1YyA0MSA1ZCA0MSA1ZSA0MSA1ZiA1ZCBjMyBl
OCBlYyA3NCA2NiAwMCA1NSA0OCA4YiA3ZiAwOCA0OCA4OSBlNSBlOCBkYyBmZSBmZiBmZiA1
ZCBjMyBlOCBkOCA3NCA2NiAwMCA1NSA0OCA4OSBlNSA1MyA8NDg+IDhiIDA3IDQ4IDg5IGZi
IGE4IDBjIDc0IDExIGJlIDJlIDA2IDAwIDAwIDQ4IGM3IGM3IDZlIGU2IGFkIApbICAgIDAu
MDM2NjY2XSBSSVAgIFs8ZmZmZmZmZmY4MTA4ZTJlZD5dIHdha2VfdXBfcHJvY2VzcysweGEv
MHgzNwpbICAgIDAuMDM2NjY2XSAgUlNQIDxmZmZmODgwMDAwMDRmZDEwPgpbICAgIDAuMDM2
NjY2XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAzNjY5M10gLS0tWyBlbmQgdHJh
Y2UgZTFkNTIyNjQyYjZiNjJlYiBdLS0tClsgICAgMC4wMzY2OTNdIC0tLVsgZW5kIHRyYWNl
IGUxZDUyMjY0MmI2YjYyZWIgXS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0t
LTEwMTgvZmQ5N2U4N2Q0MTEyZjVlYzMzMjIzYjBiZGMzYjdiMDdiMjczZWNiZS9kbWVzZy1x
dWFudGFsLXhpYW4tMzY6MjAxMzEwMTkyMzM0Mzg6eDg2XzY0LXJhbmRjb25maWcteDMtLS0t
MTAxODozLjEyLjAtcmMzLTAwMDQwLWdmZDk3ZTg3OjY2OAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXgzLS0tLTEwMTgvZmQ5N2U4N2Q0MTEyZjVlYzMzMjIzYjBiZGMzYjdiMDdiMjcz
ZWNiZS9kbWVzZy15b2N0by1uaG00LTI6MjAxMzEwMTkxNTQ2NDg6eDg2XzY0LXJhbmRjb25m
aWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDQwLWdmZDk3ZTg3OjY2OAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvZmQ5N2U4N2Q0MTEyZjVlYzMzMjIzYjBiZGMz
YjdiMDdiMjczZWNiZS9kbWVzZy15b2N0by14Ym0tMzoyMDEzMTAyMDA3MTkzNzp4ODZfNjQt
cmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNDAtZ2ZkOTdlODc6NjY4Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9mZDk3ZTg3ZDQxMTJmNWVjMzMy
MjNiMGJkYzNiN2IwN2IyNzNlY2JlL2RtZXNnLXF1YW50YWwtYXRoZW5zLTI6MjAxMzEwMTky
MzM0NDc6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDQwLWdm
ZDk3ZTg3OjY2OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvZmQ5N2U4
N2Q0MTEyZjVlYzMzMjIzYjBiZGMzYjdiMDdiMjczZWNiZS9kbWVzZy1xdWFudGFsLWpha2V0
b3duLTM5OjIwMTMxMDE5MjMzNDQxOng4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4x
Mi4wLXJjMy0wMDA0MC1nZmQ5N2U4Nzo2NjgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14
My0tLS0xMDE4L2ZkOTdlODdkNDExMmY1ZWMzMzIyM2IwYmRjM2I3YjA3YjI3M2VjYmUvZG1l
c2ctcXVhbnRhbC1sa3AtdHQwMi0xNDoyMDEzMTAxOTE0MTIyODp4ODZfNjQtcmFuZGNvbmZp
Zy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNDAtZ2ZkOTdlODc6NjY4Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9mZDk3ZTg3ZDQxMTJmNWVjMzMyMjNiMGJkYzNi
N2IwN2IyNzNlY2JlL2RtZXNnLXF1YW50YWwtc25iLTE1OjIwMTMxMDE5MjMzNDQ0Ong4Nl82
NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA0MC1nZmQ5N2U4Nzo2NjgK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2ZkOTdlODdkNDExMmY1ZWMz
MzIyM2IwYmRjM2I3YjA3YjI3M2VjYmUvZG1lc2cteW9jdG8tYXRoZW5zLTc6MjAxMzEwMTky
MzM0NDg6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDQwLWdm
ZDk3ZTg3OjY2OAowOjg6NiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKZmQ5N2U4N2Q0
MTEyZjVlYzMzMjIzYjBiZGMzYjdiMDdiMjczZWNiZSBpcyB0aGUgZmlyc3QgYmFkIGNvbW1p
dApjb21taXQgZmQ5N2U4N2Q0MTEyZjVlYzMzMjIzYjBiZGMzYjdiMDdiMjczZWNiZQpBdXRo
b3I6IEVyaWMgVy4gQmllZGVybWFuIDxlYmllZGVybUB4bWlzc2lvbi5jb20+CkRhdGU6ICAg
VGh1IE9jdCAzIDE0OjU4OjUzIDIwMTMgLTA3MDAKCiAgICBwaWQ6IFN0b3Agb3BlbiBjb2Rp
bmcgaXNfaWRsZV90YXNrIGluIGZvcmsuCiAgICAKICAgIFRoaXMgbWFrZXMgdGhlIGNvZGUg
Y2xlYXJlciBhbmQgaXQgcmVtb3ZlcyBvbmUgbW9yZSB1c2Ugb2YgdGFzay0+cGlkLgogICAg
CiAgICBTaWduZWQtb2ZmLWJ5OiAiRXJpYyBXLiBCaWVkZXJtYW4iIDxlYmllZGVybUB4bWlz
c2lvbi5jb20+Cgo6MDQwMDAwIDA0MDAwMCA4M2ViMjcwZjI3NDY5Mjc5MjczMWFiZTM3NmYy
NGQyYTVkOTEzMWU2IDgwYTYzZDE0YTc1Mjk3MDZkN2ZlN2E0NTk5ZWE3N2ZmN2IyOTM1NTgg
TQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L3VzZXJuczp1c2VybnMtYWx3
YXlzLW1hcC11c2VyLXYxMzY6ODdlYWM0YTdmOGRkY2JiM2ZiZjlhZGU3NmE5NzViMjYwZDY3
ZDdiNTpiaXNlY3QtdXNiCgoyMDEzLTEwLTE5LTIzOjM1OjAwIDg3ZWFjNGE3ZjhkZGNiYjNm
YmY5YWRlNzZhOTc1YjI2MGQ2N2Q3YjUgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14My0tLS0xMDE4Lzg3ZWFjNGE3ZjhkZGNiYjNmYmY5YWRlNzZhOTc1YjI2MGQ2N2Q3YjUv
dm1saW51ei0zLjEyLjAtcmMzLTAwMDM5LWc4N2VhYzRhCgoyMDEzLTEwLTE5LTIzOjM1OjAz
IGRldGVjdGluZyBib290IHN0YXRlIC4JNQkxMwkyNwk0OAk1OAk3NAk4NAk4Nwk5NS4JMTAw
LgkxMDkJMTE2CTEyMAkxMjIJMTI4CTE0MwkxNjAuCTIwNC4JMjM3CTI1MwkyODEuLgkzMTUu
CTM1MC4uLgk0MTQJNDQyLi4JNDYxCTUxNgk1NjEuLi4uCTU4OQk2NDEJNjkxCTczNwk3NDcu
Li4uLi4uLi4uCTc4NAk4MjEJODU1CTg5MAk5MjQJOTU3CTk4OAkxMDE4CTEwNTAJMTA4OQkx
MTM3CTExODEJMTIyNAkxMjU4CTEyOTIJMTMyMgkxMzQ4CTEzNzEJMTM5NQkxNDE4CTE0NDUJ
MTQ3NwkxNTIyCTE1NzgJMTYyOAkxNjM3LgkxNjczCTE3MjgJMTc4MwkxODMwCTE4NzQJMTky
NAkxOTg2CTIwMzUJMjA3NQkyMTEyCTIxNTMJMjE5MwkyMjMxCTIyNjUJMjI5NgkyMzI1CTIz
NTIJMjM4MQkyNDEyCTI0NDkJMjQ5NQkyNTQ1CTI1OTkJMjY1MgkyNzAzCTI3NTUJMjgwNQky
ODU5CTI5MTIJMjk2NgkzMDAwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L3VzZXJuczp1c2VybnMtYWx3
YXlzLW1hcC11c2VyLXYxMzY6ZWEwMjI1YWYyZWNhNmQxNGU3ZjFkMzNiY2IxMmZhMTgwODI3
M2I2ZjpiaXNlY3QtdXNiCiBURVNUIEZBSUxVUkUKWyAgICAxLjEzNTE1NV0gbm8gaGFyZHdh
cmUgc2FtcGxpbmcgaW50ZXJydXB0IGF2YWlsYWJsZS4KWyAgICAxLjEzNzkwMl0gQnJva2Vu
IFBNVSBoYXJkd2FyZSBkZXRlY3RlZCwgdXNpbmcgc29mdHdhcmUgZXZlbnRzIG9ubHkuClsg
ICAgMS4xMzg5NDRdIEZhaWxlZCB0byBhY2Nlc3MgcGVyZmN0ciBtc3IgKE1TUiBjMDAxMDAw
NCBpcyAwKQpbICAgIDEuMTQ4OTcxXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5V
TEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgICAgICAgICAgKG51bGwpClsgICAgMS4xNDk5
OTldIElQOiBbPGZmZmZmZmZmODEwOGUzYmU+XSB3YWtlX3VwX3Byb2Nlc3MrMHhhLzB4MzcK
WyAgICAxLjE0OTk5OV0gUEdEIDAgClsgICAgMS4xNDk5OTldIE9vcHM6IDAwMDAgWyMxXSBQ
UkVFTVBUIApbICAgIDEuMTQ5OTk5XSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90
IHRhaW50ZWQgMy4xMi4wLXJjMy0wMDA3MS1nZWEwMjI1YSAjNDUyClsgICAgMS4xNDk5OTld
IHRhc2s6IGZmZmY4ODAwMDAwNTAwNDAgdGk6IGZmZmY4ODAwMDAwNGUwMDAgdGFzay50aTog
ZmZmZjg4MDAwMDA0ZTAwMApbICAgIDEuMTQ5OTk5XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgx
MDhlM2JlPl0gIFs8ZmZmZmZmZmY4MTA4ZTNiZT5dIHdha2VfdXBfcHJvY2VzcysweGEvMHgz
NwpbICAgIDEuMTQ5OTk5XSBSU1A6IDAwMDA6ZmZmZjg4MDAwMDA0ZmQxMCAgRUZMQUdTOiAw
MDAwMDI0NgpbICAgIDEuMTQ5OTk5XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZm
ODgwMDAwMDRmZDYwIFJDWDogMDAwMDAwMDAwMDAwMDA1OApbICAgIDEuMTQ5OTk5XSBSRFg6
IGZmZmZmZmZmODFjNGJlOTAgUlNJOiBmZmZmZmZmZjgxMDg1YTUyIFJESTogMDAwMDAwMDAw
MDAwMDAwMApbICAgIDEuMTQ5OTk5XSBSQlA6IGZmZmY4ODAwMDAwNGZkMTggUjA4OiAwMDAw
MDAwMDAwMDAwMDAxIFIwOTogMDAwMDAwMDAwMDAwMDA1OApbICAgIDEuMTQ5OTk5XSBSMTA6
IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmZmZmZmZmY4
MWFkYmRkZgpbICAgIDEuMTQ5OTk5XSBSMTM6IDAwMDAwMDAwMDAwMDAwMDAgUjE0OiAwMDAw
MDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMApbICAgIDEuMTQ5OTk5XSBGUzog
IDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MWMxZTAwMCgwMDAwKSBrbmxH
UzowMDAwMDAwMDAwMDAwMDAwClsgICAgMS4xNDk5OTldIENTOiAgMDAxMCBEUzogMDAwMCBF
UzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICAxLjE0OTk5OV0gQ1IyOiAwMDAw
MDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAwMWMwZDAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2
YjAKWyAgICAxLjE0OTk5OV0gRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAw
MDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjE0OTk5OV0gRFIzOiAwMDAw
MDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDAwMDAwMDAwMCBEUjc6IDAwMDAwMDAwMDAwMDAw
MDAKWyAgICAxLjE0OTk5OV0gU3RhY2s6ClsgICAgMS4xNDk5OTldICBmZmZmODgwMDAwMDRm
ZDYwIGZmZmY4ODAwMDAwNGZlMTAgZmZmZmZmZmY4MTA4NWE1ZSAwMDAwMDAwMDAwMDAwMDU4
ClsgICAgMS4xNDk5OTldICAwMDAwMDAwMDAwMDAwMDAxIDAwMDAwMDAwMDAwMDAwMDEgZmZm
ZmZmZmY4MTA4YmM3NiBmZmZmODgwMDAwMDk0OTIwClsgICAgMS4xNDk5OTldICBmZmZmODgw
MDAwMDAwMDAwIGZmZmZmZmZmODEwYWEwMTYgZmZmZmZmZmYwMDAwMDAwMCBkZWFkNGVhZDAw
MDAwMDAxClsgICAgMS4xNDk5OTldIENhbGwgVHJhY2U6ClsgICAgMS4xNDk5OTldICBbPGZm
ZmZmZmZmODEwODVhNWU+XSBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4OTIvMHgxMGMKWyAg
ICAxLjE0OTk5OV0gIFs8ZmZmZmZmZmY4MTA4YmM3Nj5dID8gX19zbXBib290X2NyZWF0ZV90
aHJlYWQrMHg5ZC8weDlkClsgICAgMS4xNDk5OTldICBbPGZmZmZmZmZmODEwYWEwMTY+XSA/
IHRyYWNlX2hhcmRpcnFzX29mZisweGQvMHhmClsgICAgMS4xNDk5OTldICBbPGZmZmZmZmZm
ODEwOGJjMTA+XSA/IF9fc21wYm9vdF9jcmVhdGVfdGhyZWFkKzB4MzcvMHg5ZApbICAgIDEu
MTQ5OTk5XSAgWzxmZmZmZmZmZjgxMDhiYzEwPl0gPyBfX3NtcGJvb3RfY3JlYXRlX3RocmVh
ZCsweDM3LzB4OWQKWyAgICAxLjE0OTk5OV0gIFs8ZmZmZmZmZmY4MTA4NWI3MD5dIGt0aHJl
YWRfY3JlYXRlX29uX2NwdSsweDFiLzB4NGMKWyAgICAxLjE0OTk5OV0gIFs8ZmZmZmZmZmY4
MTA4YmMzNT5dIF9fc21wYm9vdF9jcmVhdGVfdGhyZWFkKzB4NWMvMHg5ZApbICAgIDEuMTQ5
OTk5XSAgWzxmZmZmZmZmZjgxMDhiZmU1Pl0gc21wYm9vdF9yZWdpc3Rlcl9wZXJjcHVfdGhy
ZWFkKzB4MjkvMHg4ZApbICAgIDEuMTQ5OTk5XSAgWzxmZmZmZmZmZjgxZjg2NGM4Pl0gPyBm
dHJhY2VfZGVmaW5lX2ZpZWxkc19zb2Z0aXJxKzB4MzAvMHgzMApbICAgIDEuMTQ5OTk5XSAg
WzxmZmZmZmZmZjgxZjg2NGQ4Pl0gc3Bhd25fa3NvZnRpcnFkKzB4MTAvMHgxYQpbICAgIDEu
MTQ5OTk5XSAgWzxmZmZmZmZmZjgxZjc2ZDlmPl0gZG9fb25lX2luaXRjYWxsKzB4YWEvMHgx
MzkKWyAgICAxLjE0OTk5OV0gIFs8ZmZmZmZmZmY4MTBkYTMwNz5dID8gdHJhY2VfcHJlZW1w
dF9vbisweDEyLzB4MmYKWyAgICAxLjE0OTk5OV0gIFs8ZmZmZmZmZmY4MTA4ZTgzZT5dID8g
c3ViX3ByZWVtcHRfY291bnQrMHhiNy8weGRjClsgICAgMS4xNDk5OTldICBbPGZmZmZmZmZm
ODFmNzZlY2U+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGEwLzB4MWM5ClsgICAgMS4xNDk5
OTldICBbPGZmZmZmZmZmODE2ZTU5Y2Q+XSA/IHJlc3RfaW5pdCsweGMxLzB4YzEKWyAgICAx
LjE0OTk5OV0gIFs8ZmZmZmZmZmY4MTZlNTlkYj5dIGtlcm5lbF9pbml0KzB4ZS8weGQ2Clsg
ICAgMS4xNDk5OTldICBbPGZmZmZmZmZmODE2ZjY2NGE+XSByZXRfZnJvbV9mb3JrKzB4N2Ev
MHhiMApbICAgIDEuMTQ5OTk5XSAgWzxmZmZmZmZmZjgxNmU1OWNkPl0gPyByZXN0X2luaXQr
MHhjMS8weGMxClsgICAgMS4xNDk5OTldIENvZGU6IDQ0IDg5IGUwIDQxIDVjIDQxIDVkIDQx
IDVlIDQxIDVmIDVkIGMzIGU4IDliIDgwIDY2IDAwIDU1IDQ4IDhiIDdmIDA4IDQ4IDg5IGU1
IGU4IGRjIGZlIGZmIGZmIDVkIGMzIGU4IDg3IDgwIDY2IDAwIDU1IDQ4IDg5IGU1IDUzIDw0
OD4gOGIgMDcgNDggODkgZmIgYTggMGMgNzQgMTEgYmUgMmUgMDYgMDAgMDAgNDggYzcgYzcg
ZTUgZWUgYWQgClsgICAgMS4xNDk5OTldIFJJUCAgWzxmZmZmZmZmZjgxMDhlM2JlPl0gd2Fr
ZV91cF9wcm9jZXNzKzB4YS8weDM3ClsgICAgMS4xNDk5OTldICBSU1AgPGZmZmY4ODAwMDAw
NGZkMTA+ClsgICAgMS4xNDk5OTldIENSMjogMDAwMDAwMDAwMDAwMDAwMApbICAgIDEuMTYw
NjM1XSAtLS1bIGVuZCB0cmFjZSA0ZWM5NTdkNmM5ZWRhMDVlIF0tLS0KWyAgICAxLjE2MjE5
Ml0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIHRoZSBp
ZGxlIHRhc2shCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9lYTAyMjVh
ZjJlY2E2ZDE0ZTdmMWQzM2JjYjEyZmExODA4MjczYjZmL2RtZXNnLXlvY3RvLWJlbnMtNDoy
MDEzMTAxODA4NTA0ODp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMt
MDAwNzEtZ2VhMDIyNWE6NDUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAx
OC9lYTAyMjVhZjJlY2E2ZDE0ZTdmMWQzM2JjYjEyZmExODA4MjczYjZmL2RtZXNnLXlvY3Rv
LWJheS0xOjIwMTMxMDE4MjEyNzUzOng4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4x
Mi4wLXJjMy0wMDA3MS1nZWEwMjI1YTo0NTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14
My0tLS0xMDE4L2VhMDIyNWFmMmVjYTZkMTRlN2YxZDMzYmNiMTJmYTE4MDgyNzNiNmYvZG1l
c2ctcXVhbnRhbC1uaG00LTM6MjAxMzEwMTgxMzM5MTg6eDg2XzY0LXJhbmRjb25maWcteDMt
LS0tMTAxODozLjEyLjAtcmMzLTAwMDcxLWdlYTAyMjVhOjQ1Mgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXgzLS0tLTEwMTgvZWEwMjI1YWYyZWNhNmQxNGU3ZjFkMzNiY2IxMmZhMTgw
ODI3M2I2Zi9kbWVzZy1xdWFudGFsLWpha2V0b3duLTIyOjIwMTMxMDE5MjAyNjQzOng4Nl82
NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA3MS1nZWEwMjI1YTo0NTIK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2VhMDIyNWFmMmVjYTZkMTRl
N2YxZDMzYmNiMTJmYTE4MDgyNzNiNmYvZG1lc2cteW9jdG8teHBzLTE6MjAxMzEwMTgxNjQw
NDY6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDcxLWdlYTAy
MjVhOjQ1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvZWEwMjI1YWYy
ZWNhNmQxNGU3ZjFkMzNiY2IxMmZhMTgwODI3M2I2Zi9kbWVzZy1xdWFudGFsLWFudC01OjIw
MTMxMDE5MDUyMjM2Ong4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0w
MDA3MS1nZWEwMjI1YTo0NTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4
L2VhMDIyNWFmMmVjYTZkMTRlN2YxZDMzYmNiMTJmYTE4MDgyNzNiNmYvZG1lc2cteW9jdG8t
YmVucy0yOjIwMTMxMDE5MjAyNjMyOng4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4x
Mi4wLXJjMy0wMDA3MS1nZWEwMjI1YTo0NTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14
My0tLS0xMDE4L2VhMDIyNWFmMmVjYTZkMTRlN2YxZDMzYmNiMTJmYTE4MDgyNzNiNmYvZG1l
c2ctcXVhbnRhbC1sa3Atc3QwMS0xMDoyMDEzMTAxOTIwMjY1Mjp4ODZfNjQtcmFuZGNvbmZp
Zy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNzEtZ2VhMDIyNWE6NDUyCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9lYTAyMjVhZjJlY2E2ZDE0ZTdmMWQzM2JjYjEy
ZmExODA4MjczYjZmL2RtZXNnLXlvY3RvLXdhaW1lYS04OjIwMTMxMDE5MDUyMTEyOng4Nl82
NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA3MS1nZWEwMjI1YTo0NTIK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2VhMDIyNWFmMmVjYTZkMTRl
N2YxZDMzYmNiMTJmYTE4MDgyNzNiNmYvZG1lc2cteW9jdG8tYmVucy0yOjIwMTMxMDE5MjAy
NzAyOng4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA3MS1nZWEw
MjI1YTo0NTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2VhMDIyNWFm
MmVjYTZkMTRlN2YxZDMzYmNiMTJmYTE4MDgyNzNiNmYvZG1lc2ctcXVhbnRhbC1uaG00LTU6
MjAxMzEwMTgwMTAxNTk6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMz
LTAwMDcxLWdlYTAyMjVhOjQ1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEw
MTgvZWEwMjI1YWYyZWNhNmQxNGU3ZjFkMzNiY2IxMmZhMTgwODI3M2I2Zi9kbWVzZy15b2N0
by1iZW5zLTI6MjAxMzEwMTkyMDI2NTA6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODoz
LjEyLjAtcmMzLTAwMDcxLWdlYTAyMjVhOjQ1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXgzLS0tLTEwMTgvZWEwMjI1YWYyZWNhNmQxNGU3ZjFkMzNiY2IxMmZhMTgwODI3M2I2Zi9k
bWVzZy1xdWFudGFsLWxrcC1zdDAxLTEwOjIwMTMxMDE5MjAyNzA4Ong4Nl82NC1yYW5kY29u
ZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA3MS1nZWEwMjI1YTo0NTIKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2VhMDIyNWFmMmVjYTZkMTRlN2YxZDMzYmNi
MTJmYTE4MDgyNzNiNmYvZG1lc2cteW9jdG8tbGtwLXR0MDItMTA6MjAxMzEwMTcyMzI3MzQ6
eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDcxLWdlYTAyMjVh
OjQ1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvZWEwMjI1YWYyZWNh
NmQxNGU3ZjFkMzNiY2IxMmZhMTgwODI3M2I2Zi9kbWVzZy15b2N0by1sa3AtdHQwMi0yMToy
MDEzMTAxNzIzMjczODp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMt
MDAwNzEtZ2VhMDIyNWE6NDUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAx
OC9lYTAyMjVhZjJlY2E2ZDE0ZTdmMWQzM2JjYjEyZmExODA4MjczYjZmL2RtZXNnLXlvY3Rv
LWxrcC10dDAyLTk6MjAxMzEwMTkxMTA0NDA6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAx
ODozLjEyLjAtcmMzLTAwMDcxLWdlYTAyMjVhOjQ1Mgova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXgzLS0tLTEwMTgvZWEwMjI1YWYyZWNhNmQxNGU3ZjFkMzNiY2IxMmZhMTgwODI3M2I2
Zi9kbWVzZy1xdWFudGFsLWNhaXJvLTEwOjIwMTMxMDE4MDg1MDUyOng4Nl82NC1yYW5kY29u
ZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA3MS1nZWEwMjI1YTo0NTIKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2VhMDIyNWFmMmVjYTZkMTRlN2YxZDMzYmNi
MTJmYTE4MDgyNzNiNmYvZG1lc2ctcXVhbnRhbC1iZW5zLTE6MjAxMzEwMTkyMDI3MDU6eDg2
XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDcxLWdlYTAyMjVhOjQ1
Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvZWEwMjI1YWYyZWNhNmQx
NGU3ZjFkMzNiY2IxMmZhMTgwODI3M2I2Zi9kbWVzZy1xdWFudGFsLWJheS0xOjIwMTMxMDE4
MjEyNzUzOng4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA3MS1n
ZWEwMjI1YTo0NTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2VhMDIy
NWFmMmVjYTZkMTRlN2YxZDMzYmNiMTJmYTE4MDgyNzNiNmYvZG1lc2cteW9jdG8td2FpbWVh
LTI6MjAxMzEwMjAwNDI1NDQ6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAt
cmMzLTAwMDcxLWdlYTAyMjVhOjQ1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0t
LTEwMTgvZWEwMjI1YWYyZWNhNmQxNGU3ZjFkMzNiY2IxMmZhMTgwODI3M2I2Zi9kbWVzZy15
b2N0by1sa3AtdHQwMi0yNDoyMDEzMTAxODEyMDQ0Nzp4ODZfNjQtcmFuZGNvbmZpZy14My0t
LS0xMDE4OjMuMTIuMC1yYzMtMDAwNzEtZ2VhMDIyNWE6NDUyCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWcteDMtLS0tMTAxOC9lYTAyMjVhZjJlY2E2ZDE0ZTdmMWQzM2JjYjEyZmExODA4
MjczYjZmL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNDoyMDEzMTAxODIxMjc0MTp4ODZfNjQt
cmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNzEtZ2VhMDIyNWE6NDUyCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9lYTAyMjVhZjJlY2E2ZDE0ZTdm
MWQzM2JjYjEyZmExODA4MjczYjZmL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNDoyMDEzMTAx
ODIxMjc1NTp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNzEt
Z2VhMDIyNWE6NDUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9lYTAy
MjVhZjJlY2E2ZDE0ZTdmMWQzM2JjYjEyZmExODA4MjczYjZmL2RtZXNnLXlvY3RvLWpha2V0
b3duLTU6MjAxMzEwMTkyMDI2NTQ6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEy
LjAtcmMzLTAwMDcxLWdlYTAyMjVhOjQ1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgz
LS0tLTEwMTgvZWEwMjI1YWYyZWNhNmQxNGU3ZjFkMzNiY2IxMmZhMTgwODI3M2I2Zi9kbWVz
Zy15b2N0by1hbnQtMzoyMDEzMTAxOTA1MjIzNDp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0x
MDE4OjMuMTIuMC1yYzMtMDAwNzEtZ2VhMDIyNWE6NDUyCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDMtLS0tMTAxOC9lYTAyMjVhZjJlY2E2ZDE0ZTdmMWQzM2JjYjEyZmExODA4Mjcz
YjZmL2RtZXNnLXF1YW50YWwtbmhtNC00OjIwMTMxMDE4MDEwMTU2Ong4Nl82NC1yYW5kY29u
ZmlnLXgzLS0tLTEwMTg6My4xMi4wLXJjMy0wMDA3MS1nZWEwMjI1YTo0NTIKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4L2VhMDIyNWFmMmVjYTZkMTRlN2YxZDMzYmNi
MTJmYTE4MDgyNzNiNmYvZG1lc2cteW9jdG8tYmF5LTE6MjAxMzEwMTgyMTI3NDM6eDg2XzY0
LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMzLTAwMDcxLWdlYTAyMjVhOjQ1Mgov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvZWEwMjI1YWYyZWNhNmQxNGU3
ZjFkMzNiY2IxMmZhMTgwODI3M2I2Zi9kbWVzZy15b2N0by1hbnQtMjoyMDEzMTAxODE2NDYw
MDp4ODZfNjQtcmFuZGNvbmZpZy14My0tLS0xMDE4OjMuMTIuMC1yYzMtMDAwNzEtZ2VhMDIy
NWE6NDUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC9lYTAyMjVhZjJl
Y2E2ZDE0ZTdmMWQzM2JjYjEyZmExODA4MjczYjZmL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTk6
MjAxMzEwMTgwODUwNTA6eDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxODozLjEyLjAtcmMz
LTAwMDcxLWdlYTAyMjVhOjQ1MgowOjI5OjI5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
CgpbZGV0YWNoZWQgSEVBRCA2NDgxYzliXSBSZXZlcnQgInBpZDogU3RvcCBvcGVuIGNvZGlu
ZyBpc19pZGxlX3Rhc2sgaW4gZm9yay4iCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXgzLS0tLTEwMTgvdXNlcm5zOnVzZXJucy1hbHdheXMtbWFwLXVz
ZXItdjEzNjo2NDgxYzliMDgxNjdkZDM1MjBhMmY0ZjQyYzdlZGQ2ZDgzMjBhNDAzOmJpc2Vj
dC11c2IKCjIwMTMtMTAtMjAtMDA6MzQ6MDggNjQ4MWM5YjA4MTY3ZGQzNTIwYTJmNGY0MmM3
ZWRkNmQ4MzIwYTQwMyBjb21waWxpbmcKCjIwMTMtMTAtMjAtMDA6MzY6NDggZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xMi4wLXJjMy0wMDA3Mi1nNjQ4MWM5Yi4JNAkxNAkxOAkyMwk1MAk3
NgkxMzkJMTUzCTE3MwkxOTMJMjE0CTIyMAkyMzcJMjgwCTI5MQkzMDUJMzQzCTM2Mwk0MDEJ
NDU2CTQ5OQk1MzkJNTc2CTYxMwk2NDYJNjgwCTcxNQk3NTAJNzgzCTgxMwk4NDMJODc0CTkw
OQk5NDYJOTkzCTEwNDUJMTA5MAkxMTMxCTExNzUJMTIyMgkxMjY3CTEyNjgJMTMwNgkxMzUz
CTE0MDMJMTQ2MQkxNTE3CTE1NjUJMTYxNgkxNjU3CTE3MDIJMTc2MQkxODIzCTE4NjgJMTkw
MQkxOTMwCTE5NTcJMTk4NgkyMDIwCTIwNjAJMjEwOAkyMTU0CTIyMDIJMjI0OAkyMjg4CTIz
MjcJMjM2NQkyNDA5CTI0NTUJMjQ5NgkyNTMzCTI1NjUJMjU5NgkyNjI0CTI2NTMJMjY4Mgky
NzEzCTI3NDQJMjc3NgkyODA4CTI4NDAJMjg3MgkyOTA0CTI5MzQJMjk2MwkyOTg4CTMwMDAg
U1VDQ0VTUwoKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgz
LS0tLTEwMTgvdXNlcm5zOnVzZXJucy1hbHdheXMtbWFwLXVzZXItdjEzNjpiZGVlYWI2MmE2
MTFmMWY3Y2Q0OGZkMjg1Y2U1NjhlOGRjZDA0NTVhOmJpc2VjdC11c2IKCjIwMTMtMTAtMjAt
MDE6MjA6NTMgYmRlZWFiNjJhNjExZjFmN2NkNDhmZDI4NWNlNTY4ZThkY2QwNDU1YSBjb21w
aWxpbmcKCjIwMTMtMTAtMjAtMDE6Mjk6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4w
LXJjNS0wMDEzOS1nYmRlZWFiNgkxLgkxOQkyMgk1NQk4OAkxMDkJMTM2CTE2MQkxODUJMjA5
CTIzMQkyNTUJMjc4CTMwMQkzMjQJMzQ3CTM2OQkzOTIJNDE1CTQzOQk0NjEJNDg0CTUwNgk1
MzAJNTUzCTU3Nwk2MDAJNjI0CTY0OAk2NzEJNjk1CTcxOQk3NDMJNzY2CTc5MAk4MTMJODM2
CTg1OQk4ODIJOTA1CTkyNwk5NTAJOTczCTk5OAkxMDIxCTEwNDUJMTA2OAkxMDcwLgkxMDkz
CTExMTcJMTE0MQkxMTY5CTExOTkJMTI0MAkxMjkwCTEzNDAJMTM5MgkxNDM4CTE0ODgJMTUz
NQkxNTgzCTE2MzAJMTY4NQkxNzMyCTE3ODEJMTgyMgkxODYyCTE4OTgJMTkzMwkxOTY3CTE5
OTcJMjAyOAkyMDYyCTIwOTMJMjEyMgkyMTQ5CTIxNzYJMjIwMgkyMjI4CTIyNTQJMjI4MAky
MzA3CTIzMzQJMjM2MAkyMzg1CTI0MTAJMjQzNQkyNDYxCTI0ODcJMjUxNgkyNTQ4CTI1NzkJ
MjYxNAkyNjU3CTI2ODkJMjcxOQkyNzQ1CTI3NzAJMjc5MwkyODE3CTI4NDEJMjg2NQkyODg3
CTI5MTAJMjkzMwkyOTU1CTI5NzcJMjk4Mi4JMjk4NwkzMDAwIFNVQ0NFU1MKCgo9PT09PT09
PT0gbGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4dApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDMtLS0tMTAxOC91c2VybnM6
dXNlcm5zLWFsd2F5cy1tYXAtdXNlci12MTM2OmEwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBm
NjM0MTA2NmE4Y2IxY2Y6YmlzZWN0LXVzYgoKMjAxMy0xMC0yMC0wMjoyNjozMCBhMGNmMWFi
YzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmIHJldXNlIC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWcteDMtLS0tMTAxOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEw
NjZhOGNiMWNmL3ZtbGludXotMy4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3CgoyMDEzLTEwLTIw
LTAyOjI3OjAzIGRldGVjdGluZyBib290IHN0YXRlIC4uCTY4Lgk3MQkxMDAJMTI1CTE0OQkx
NzIJMTk1CTIxOAkyNDEJMjQzCTI2NAkyODgJMzEyCTMzNgkzNTkJMzgyCTQwNQk0MjkJNDUz
CTQ3Ngk0OTkJNTIzCTU0Ngk1NjkJNTkzCTYxNgk2NDAJNjY0CTY4Nwk3MTAJNzMzCTc1Nwk3
ODEJODA1CTgyNwk4NDkJODcxCTg5NAk5MTYJOTM4CTk2MQk5ODQJMTAwOAkxMDMxCTEwNTUJ
MTA3OQkxMTAzCTExMjYJMTE1MAkxMTc1CTEyMDMJMTIzOAkxMjczCTEzMTYJMTM3MwkxNDIx
CTE0NTUJMTQ4NAkxNTA5CTE1MzIJMTU1NQkxNTc5CTE2MDIJMTYyNQkxNjQ4CTE2NzEJMTY5
NAkxNzE4CTE3NDIJMTc2OAkxNzk1CTE4MjUJMTg1NwkxODkwCTE5MjEJMTk0OQkxOTczCTE5
OTYJMjAxOAkyMDQyCTIwNjcJMjA5NwkyMTQ1CTIyMDAJMjI0OQkyMzA1CTIzNTkJMjQxOAky
NDgzCTI1NDEJMjYwNAkyNjY3CTI3MjcJMjc4OAkyODQwCTI4OTUJMjk0NwkyOTk5CTMwMDAg
U1VDQ0VTUwoK

--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc3-00071-gea0225a"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0-rc3 Kernel Configuration
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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
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
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
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
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
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
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

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
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
# CONFIG_VLSI_FIR is not set
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
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
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
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
CONFIG_MTD_TS5500=y
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=y
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
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
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
# CONFIG_ATM_ENI_DEBUG is not set
CONFIG_ATM_ENI_TUNE_BURST=y
CONFIG_ATM_ENI_BURST_TX_16W=y
CONFIG_ATM_ENI_BURST_TX_8W=y
CONFIG_ATM_ENI_BURST_TX_4W=y
# CONFIG_ATM_ENI_BURST_TX_2W is not set
CONFIG_ATM_ENI_BURST_RX_16W=y
CONFIG_ATM_ENI_BURST_RX_8W=y
CONFIG_ATM_ENI_BURST_RX_4W=y
# CONFIG_ATM_ENI_BURST_RX_2W is not set
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=y
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=y
# CONFIG_ATM_IA_DEBUG is not set
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=y
# CONFIG_ATM_HE_USE_SUNI is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PLIP=y
# CONFIG_PPP is not set
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SR9700=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_HSO=y
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IEEE802154_FAKELB=y
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
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
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_88PM860X is not set
CONFIG_TOUCHSCREEN_ADS7846=y
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_PCAP is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MRST_MAX3110=y
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
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
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_FSL_DSPI=y
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
# CONFIG_SPI_DW_MID_DMA is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
# CONFIG_GPIO_DA9055 is not set

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM8350=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM8350 is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

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
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y

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
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_MFD_CROS_EC_SPI=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_AB3100=y
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_S2MPS11=y
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
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
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

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
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

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
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_GADGET is not set
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_OMAP is not set
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=y
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_U_RNDIS=y
CONFIG_USB_F_ECM=y
CONFIG_USB_F_EEM=y
CONFIG_USB_F_SUBSET=y
CONFIG_USB_F_RNDIS=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_QIB is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX8997 is not set
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y
CONFIG_RTC_DRV_AB3100=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_PCAP is not set
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=y
CONFIG_USBIP_CORE=y
# CONFIG_USBIP_VHCI_HCD is not set
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
CONFIG_ECHO=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_TRANZPORT=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=y
CONFIG_ADIS16203=y
CONFIG_ADIS16204=y
CONFIG_ADIS16209=y
CONFIG_ADIS16220=y
# CONFIG_ADIS16240 is not set
CONFIG_LIS3L02DQ=y
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD7606_IFACE_SPI=y
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7780=y
CONFIG_AD7816=y
# CONFIG_AD7192 is not set
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_SPI=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
# CONFIG_AD9832 is not set
# CONFIG_AD9834 is not set
CONFIG_AD9850=y
CONFIG_AD9852=y
# CONFIG_AD9910 is not set
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7753=y
CONFIG_ADE7754=y
CONFIG_ADE7758=y
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
CONFIG_ADE7854_SPI=y

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
# CONFIG_AD2S1200 is not set
CONFIG_AD2S1210=y

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ZSMALLOC is not set
CONFIG_FB_SM7XX=y
# CONFIG_CRYSTALHD is not set
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
CONFIG_FT1000_USB=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
CONFIG_ANDROID_INTF_ALARM_DEV=y
# CONFIG_SYNC is not set
# CONFIG_USB_WPAN_HCD is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
CONFIG_WIMAX_GDM72XX_WIMAX2=y
# CONFIG_WIMAX_GDM72XX_USB is not set
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
CONFIG_DGRP=y
# CONFIG_USB_DWC2 is not set
CONFIG_XILLYBUS=y
# CONFIG_XILLYBUS_PCIE is not set
CONFIG_DGNC=y
CONFIG_DGAP=y
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX8997=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=y
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
# CONFIG_KXSD9 is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
CONFIG_AD7298=y
CONFIG_AD7476=y
CONFIG_AD7791=y
CONFIG_AD7793=y
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_TWL6030_GPADC=y
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
CONFIG_AD5755=y
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
CONFIG_ADXRS450=y
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
CONFIG_HID_SENSOR_ALS=y
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_VME_PIO2 is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
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
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
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
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
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
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
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
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
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
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-tt02-12:20131019140221:x86_64-randconfig-x3----1018:3.12.0-rc3-00039-g87eac4a:666"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc3-00039-g87eac4a (wfg@bee) (gcc versi=
on 4.8.1 (Debian 4.8.1-3) ) #666 PREEMPT Sat Oct 19 20:33:36 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-x3----1018/userns:userns-always-=
map-user-v136:87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5:bisect-usb/.vmlinuz-=
87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5-20131019231322-387-lkp-tt02 branch=
=3Duserns/userns-always-map-user-v136 BOOT_IMAGE=3D/kernel/x86_64-randconfi=
g-x3----1018/87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5/vmlinuz-3.12.0-rc3-00=
039-g87eac4a
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
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02ac2000, 0x02ac2fff] PGTABLE
[    0.000000] BRK [0x02ac3000, 0x02ac3fff] PGTABLE
[    0.000000] BRK [0x02ac4000, 0x02ac4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02ac5000, 0x02ac5fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127848(97%)
[    0.000000] RAMDISK: [mem 0x0fd03000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000e80000=
0-ffff88000ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 896 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c2c040
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-x3----1018/userns:userns-a=
lways-map-user-v136:87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5:bisect-usb/.vm=
linuz-87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5-20131019231322-387-lkp-tt02 =
branch=3Duserns/userns-always-map-user-v136 BOOT_IMAGE=3D/kernel/x86_64-ran=
dconfig-x3----1018/87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5/vmlinuz-3.12.0-=
rc3-00039-g87eac4a
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 218476K/261744K available (7138K kernel code, 3536K =
rwdata, 3896K rodata, 764K init, 10804K bss, 43268K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2393.914 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 4789.32 Bogo=
MIPS (lpj=3D7979713)
[    0.006683] pid_max: default: 32768 minimum: 301
[    0.007938] Security Framework initialized
[    0.008912] AppArmor: AppArmor initialized
[    0.010094] Mount-cache hash table entries: 256
[    0.012565] Initializing cgroup subsys devices
[    0.013560] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013560] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013560] tlb_flushall_shift: 6
[    0.016686] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.021652] ACPI: Core revision 20130725
[    0.030738] ACPI: All ACPI Tables successfully acquired
[    0.032926] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.036928] ftrace: Allocated trace_printk buffers
[    0.042809] Getting VERSION: 50014
[    0.043361] Getting VERSION: 50014
[    0.044136] Getting ID: 0
[    0.044763] Getting ID: ff000000
[    0.045506] Getting LVT0: 8700
[    0.046175] Getting LVT1: 8400
[    0.046783] enabled ExtINT on CPU#0
[    0.049234] ENABLING IO-APIC IRQs
[    0.050023] init IO_APIC IRQs
[    0.050700]  apic 0 pin 0 not connected
[    0.051628] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.053400] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.055221] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.056712] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.058471] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.060046] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.063373] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.065140] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.066717] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.068462] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.070039] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.071798] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.073380] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.075191] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.076711] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.080040]  apic 0 pin 16 not connected
[    0.080921]  apic 0 pin 17 not connected
[    0.081788]  apic 0 pin 18 not connected
[    0.082689]  apic 0 pin 19 not connected
[    0.083346]  apic 0 pin 20 not connected
[    0.084225]  apic 0 pin 21 not connected
[    0.085132]  apic 0 pin 22 not connected
[    0.086032]  apic 0 pin 23 not connected
[    0.086880] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.088381] Using local APIC timer interrupts.
[    0.088381] calibrating APIC timer ...
[    0.093333] ... lapic delta =3D 6249369
[    0.093333] ... PM-Timer delta =3D 357918
[    0.093333] ... PM-Timer result ok
[    0.093333] ..... delta 6249369
[    0.093333] ..... mult: 268408381
[    0.093333] ..... calibration result: 3332996
[    0.093333] ..... CPU clock speed is 2393.3110 MHz.
[    0.093333] ..... host bus clock speed is 999.3329 MHz.
[    0.100215] regulator-dummy: no parameters
[    0.101649] RTC time:  6:00:47, date: 10/19/13
[    0.103111] NET: Registered protocol family 16
[    0.105332] cpuidle: using governor ladder
[    0.106677] cpuidle: using governor menu
[    0.137535] ACPI: bus type PCI registered
[    0.138609] dca service started, version 1.12.1
[    0.139927] PCI: Using configuration type 1 for base access
[    0.165230] ACPI: Added _OSI(Module Device)
[    0.166307] ACPI: Added _OSI(Processor Device)
[    0.166677] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.167812] ACPI: Added _OSI(Processor Aggregator Device)
[    0.174488] ACPI: EC: Look up EC in DSDT
[    0.192333] ACPI: Interpreter enabled
[    0.193261] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.194696] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.197300] ACPI: (supports S0 S3 S5)
[    0.198195] ACPI: Using IOAPIC for interrupt routing
[    0.200128] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.234509] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.236079] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.236677] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.241604] PCI host bridge to bus 0000:00
[    0.242669] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.243348] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.244852] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.246677] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.248345] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.250153] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.254278] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.257584] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.262041] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.265508] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.267549] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.269307] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.271121] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.275308] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.278040] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.287328] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.290337] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.292911] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.294375] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.301578] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.304657] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.307235] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.310009] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.316456] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.317682] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.320616] pci 0000:00:05.0: reg 0x10: [mem 0xfebe2000-0xfebe200f]
[    0.327677] pci_bus 0000:00: on NUMA node 0
[    0.331802] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.333960] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.336099] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.337725] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.340134] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.343333] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.343359] ACPI: \_SB_.PCI0: notify handler is installed
[    0.344907] Found 1 acpi root devices
[    0.352097] ACPI: bus type USB registered
[    0.353246] usbcore: registered new interface driver usbfs
[    0.353429] usbcore: registered new interface driver hub
[    0.354891] usbcore: registered new device driver usb
[    0.357276] pps_core: LinuxPPS API ver. 1 registered
[    0.358455] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.360118] PTP clock support registered
[    0.361878] PCI: Using ACPI for IRQ routing
[    0.363342] PCI: pci_cache_line_size set to 64 bytes
[    0.364841] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.366705] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.369384] NET: Registered protocol family 23
[    0.370161] NET: Registered protocol family 8
[    0.371200] NET: Registered protocol family 20
[    0.374552] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.376559] Switched to clocksource kvm-clock
[    0.511068] FS-Cache: Loaded
[    0.513022] AppArmor: AppArmor Filesystem Enabled
[    0.514736] pnp: PnP ACPI init
[    0.515710] ACPI: bus type PNP registered
[    0.517101] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.519663] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.521433] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.523499] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.525209] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.527332] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.529238] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.531362] pnp 00:03: [dma 2]
[    0.532310] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.534404] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.536975] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.539280] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.541903] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.544831] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.547307] pnp: PnP ACPI: found 7 devices
[    0.548396] ACPI: bus type PNP unregistered
[    0.549430] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.556740] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.558136] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.559521] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.561177] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.562761] NET: Registered protocol family 1
[    0.563960] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.565532] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.567021] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.568660] pci 0000:00:02.0: Boot video device
[    0.570110] PCI: CLS 0 bytes, default 64
[    0.572357] Unpacking initramfs...
[    0.869678] Freeing initrd memory: 2996K (ffff88000fd03000 - ffff88000ff=
f0000)
[    0.873251] Scanning for low memory corruption every 60 seconds
[    0.875446] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.877768] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.880503] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.883045] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.884633] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.886168] AVX or AES-NI instructions are not detected.
[    0.887610] AVX instructions are not detected.
[    0.888816] AVX instructions are not detected.
[    0.889902] AVX instructions are not detected.
[    0.892249] audit: initializing netlink socket (disabled)
[    0.893725] type=3D2000 audit(1382162448.162:1): initialized
[    0.903716] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.906751] fuse init (API version 7.22)
[    0.908077] msgmni has been set to 432
[    0.924849] alg: No test for stdrng (krng)
[    0.941068] NET: Registered protocol family 38
[    0.951322] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    0.952760] crc32: self tests passed, processed 225944 bytes in 3696241 =
nsec
[    0.959216] crc32c: CRC_LE_BITS =3D 1
[    0.960139] crc32c: self tests passed, processed 225944 bytes in 2267172=
 nsec
[    0.962050] rbtree testing -> 19433 cycles
[    1.831459] augmented rbtree testing
[    1.873454] tsc: Refined TSC clocksource calibration: 2393.914 MHz
 -> 31799 cycles
[    3.244290] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.245742] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.248547] nvidiafb_setup START
[    3.249773] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.252279] vmlfb: initializing
[    3.253281] Could not find Carillo Ranch MCH device.
[    3.255881] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.269409] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension,=
 1.0, OEM: VGABIOS Cirrus extension, VBE v2.0
[    3.276590] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    3.278927] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    3.281021] uvesafb: scrolling: redraw
[    3.282095] uvesafb: request region 0x3c0-0x3e0 failed
[    3.283602] uvesafb: probe of uvesafb.0 failed with error -5
[    3.285483] ipmi message handler version 39.2
[    3.286778] ipmi device interface
[    3.287889] IPMI System Interface driver.
[    3.289234] ipmi_si: Adding default-specified kcs state machine
[    3.290886] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.293653] ipmi_si: Interface detection failed
[    3.294919] ipmi_si: Adding default-specified smic state machine
[    3.296640] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.299400] ipmi_si: Interface detection failed
[    3.300684] ipmi_si: Adding default-specified bt state machine
[    3.302323] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.304953] ipmi_si: Interface detection failed
[    3.306462] ipmi_si: Unable to find any System Interface(s)
[    3.307999] IPMI Watchdog: driver initialized
[    3.309235] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.311280] IPMI poweroff: Unable to register powercycle sysctl
[    3.313495] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.315561] ACPI: Power Button [PWRF]
[    3.317425] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.368113] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.399821] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.405356] serial: Freescale lpuart driver
[    3.407167] Non-volatile memory driver v1.3
[    3.408877] ppdev: user-space parallel port driver
[    3.410341] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.411831] smapi::smapi_init, ERROR invalid usSmapiID
[    3.413379] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    3.416031] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    3.418135] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.423317] parport_pc 00:04: reported by Plug and Play ACPI
[    3.425319] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    3.511884] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.514249] dummy-irq: no IRQ given.  Use irq=3DN
[    3.515866] Phantom Linux Driver, version n0.9.8, init OK
[    3.520981] Guest personality initialized and is inactive
[    3.522758] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[    3.524713] Initialized host personality
[    3.527225] usbcore: registered new interface driver viperboard
[    3.529637] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    3.531572] device id =3D 2440
[    3.532432] device id =3D 2480
[    3.533316] device id =3D 24c0
[    3.534151] device id =3D 24d0
[    3.535018] device id =3D 25a1
[    3.535882] device id =3D 2670
[    3.536901] platform physmap-flash.0: failed to claim resource 0
[    3.538686] Failed to ioremap_nocache
[    3.539941] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.541900] slram: not enough parameters.
[    3.660221] parport0: AVR Butterfly
[    3.661539] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    3.663586] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.665694] HSI/SSI char device loaded
[    3.668870] libphy: Fixed MDIO Bus: probed
[    3.670393] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    3.673033] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[    3.675582] slcan: serial line CAN interface driver
[    3.677001] slcan: 10 dynamic interface channels.
[    3.678482] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    3.679947] AX.25: 6pack driver, Revision: 0.3.0
[    3.681302] YAM driver version 0.8 by F1OAT/F6FBB
[    3.684484] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.684484] baycom_ser_fdx: version 0.10
[    3.690042] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    3.691780] hdlcdrv: version 0.8
[    3.692729] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.692729] baycom_ser_hdx: version 0.10
[    3.698254] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.698254] baycom_par: version 0.9
[    3.702751] usbcore: registered new interface driver irda-usb
[    3.704527] usbcore: registered new interface driver stir4200
[    3.706582] usbcore: registered new interface driver kingsun-sir
[    3.708459] usbcore: registered new interface driver ksdazzle-sir
[    3.710725] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    3.712383] plip0: Parallel port at 0x378, using IRQ 7.
[    3.713955] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    3.715995] SLIP linefill/keepalive option.
[    3.718236] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMA=
C hardware
[    3.721128] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
[    3.723252] usbcore: registered new interface driver catc
[    3.724870] usbcore: registered new interface driver kaweth
[    3.726524] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    3.728717] usbcore: registered new interface driver pegasus
[    3.730464] usbcore: registered new interface driver rtl8150
[    3.732151] usbcore: registered new interface driver r8152
[    3.733770] hso: drivers/net/usb/hso.c: Option Wireless
[    3.736260] usbcore: registered new interface driver hso
[    3.737876] usbcore: registered new interface driver asix
[    3.739528] usbcore: registered new interface driver cdc_ether
[    3.743178] usbcore: registered new interface driver r815x
[    3.744856] usbcore: registered new interface driver cdc_eem
[    3.746592] usbcore: registered new interface driver dm9601
[    3.748293] usbcore: registered new interface driver sr9700
[    3.749977] usbcore: registered new interface driver smsc75xx
[    3.751716] usbcore: registered new interface driver smsc95xx
[    3.753485] usbcore: registered new interface driver gl620a
[    3.755156] usbcore: registered new interface driver rndis_host
[    3.756976] usbcore: registered new interface driver cdc_subset
[    3.758800] usbcore: registered new interface driver int51x1
[    3.760538] usbcore: registered new interface driver cdc_phonet
[    3.762335] usbcore: registered new interface driver kalmia
[    3.764035] usbcore: registered new interface driver sierra_net
[    3.765824] usbcore: registered new interface driver cdc_ncm
[    3.767565] usbcore: registered new interface driver lg-vl600
[    3.769403] Madge ATM Ambassador driver version 1.2.4
[    3.770963] Madge ATM Horizon [Ultra] driver version 1.2.1
[    3.772574] hrz: debug bitmap is 0
[    3.773822] idt77252_init: at ffffffff81faa75f
[    3.775226] adummy: version 1.0
[    3.776702] I2O subsystem v1.325
[    3.777657] i2o: max drivers =3D 8
[    3.779003] I2O Configuration OSM v1.323
[    3.780268] I2O ProcFS OSM v1.316
[    3.781360] parport0: cannot grant exclusive access for device ks0108
[    3.783285] ks0108: ERROR: parport didn't register new device
[    3.784938] cfag12864b: ERROR: ks0108 is not initialized
[    3.786505] cfag12864bfb: ERROR: cfag12864b is not initialized
[    3.788810] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.790628] ohci-pci: OHCI PCI platform driver
[    3.791992] ohci-platform: OHCI generic platform driver
[    3.793627] uhci_hcd: USB Universal Host Controller Interface driver
[    3.795785] driver u132_hcd
[    3.797067] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    3.798757]=20
[    3.801661] usbcore: registered new interface driver cdc_acm
[    3.803330] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    3.805691] usbcore: registered new interface driver usblp
[    3.807381] usbcore: registered new interface driver cdc_wdm
[    3.809069] usbcore: registered new interface driver adutux
[    3.810799] usbcore: registered new interface driver cytherm
[    3.812508] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    3.814618] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.816651] driver ftdi-elan
[    3.818095] usbcore: registered new interface driver ftdi-elan
[    3.819982] usbcore: registered new interface driver idmouse
[    3.821709] usbcore: registered new interface driver iowarrior
[    3.823508] usbcore: registered new interface driver ldusb
[    3.825153] usbcore: registered new interface driver usbled
[    3.826863] usbcore: registered new interface driver usb_ehset_test
[    3.828748] usbcore: registered new interface driver uss720
[    3.830395] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    3.833056] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    3.835165] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    3.837297] uss720: If you just want to connect to a printer, use usblp =
instead
[    3.839461] usbcore: registered new interface driver usbsevseg
[    3.841246] usbcore: registered new interface driver yurex
[    3.843396] usbcore: registered new interface driver cxacru
[    3.845067] usbcore: registered new interface driver speedtch
[    3.846756] xusbatm: malformed module parameters
[    3.848952] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    3.851089] dummy_hcd dummy_hcd.0: Dummy host controller
[    3.853054] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    3.856471] hub 1-0:1.0: USB hub found
[    3.859782] hub 1-0:1.0: 1 port detected
[    3.862780] udc dummy_udc.0: registering UDC driver [g_ether]
[    3.864586] using random self ethernet address
[    3.865889] using random host ethernet address
[    3.867711] usb0: HOST MAC aa:51:7d:90:e3:73
[    3.869850] usb0: MAC da:19:74:51:1d:cf
[    3.871019] using random self ethernet address
[    3.872377] using random host ethernet address
[    3.873700] g_ether gadget: adding config #2 'RNDIS'/ffffffff81ea3240
[    3.875581] rndis_register: configNr =3D 0
[    3.876795] g_ether gadget: adding 'rndis'/ffff88000ccb8000 to config 'R=
NDIS'/ffffffff81ea3240
[    3.879289] rndis_set_param_medium: 0 0
[    3.880454] g_ether gadget: RNDIS: super speed IN/ep1in-bulk OUT/ep2out-=
bulk NOTIFY/ep5in-int
[    3.882886] g_ether gadget: cfg 2/ffffffff81ea3240 speeds: super high fu=
ll
[    3.884888] g_ether gadget:   interface 0 =3D rndis/ffff88000ccb8000
[    3.886705] g_ether gadget:   interface 1 =3D rndis/ffff88000ccb8000
[    3.888485] g_ether gadget: adding config #1 'CDC Ethernet (EEM)'/ffffff=
ff81ea3150
[    3.890705] g_ether gadget: adding 'cdc_eem'/ffff88000ccbfe00 to config =
'CDC Ethernet (EEM)'/ffffffff81ea3150
[    3.893572] g_ether gadget: CDC Ethernet (EEM): super speed IN/ep1in-bul=
k OUT/ep2out-bulk
[    3.895912] g_ether gadget: cfg 1/ffffffff81ea3150 speeds: super high fu=
ll
[    3.897926] g_ether gadget:   interface 0 =3D cdc_eem/ffff88000ccbfe00
[    3.899786] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    3.901684] g_ether gadget: g_ether ready
[    3.902835] dummy_udc dummy_udc.0: binding gadget driver 'g_ether'
[    3.904635] dummy_udc dummy_udc.0: This device can perform faster if you=
 connect it to a super-speed port...
[    3.907474] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    3.909557] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.913598] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.915394] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.917071] parport0: cannot grant exclusive access for device parkbd
[    3.959859] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    4.039798] mousedev: PS/2 mouse device common for all mice
[    4.043019] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.045651] usbcore: registered new interface driver appletouch
[    4.048557] usbcore: registered new interface driver synaptics_usb
[    4.054419] usbcore: registered new interface driver xpad
[    4.059298] mk712: device not present
[    4.060508] usbcore: registered new interface driver usbtouchscreen
[    4.066694] rtc rtc0: test: dev (254:0)
[    4.067870] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    4.070072] rtc rtc1: test: dev (254:1)
[    4.071223] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    4.073444] i2c /dev entries driver
[    4.075298] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    4.116458] g_ether gadget: resume
[    4.117497] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    4.173764] usbcore: registered new interface driver i2c-diolan-u2c
[    4.175617] i2c-parport: adapter type unspecified
[    4.177081] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    4.179928] i2c-parport-light: adapter type unspecified
[    4.181627] usbcore: registered new interface driver i2c-tiny-usb
[    4.183686] pps_ldisc: PPS line discipline registered
[    4.185289] Driver for 1-wire Dallas network protocol.
[    4.233094] g_ether gadget: resume
[    4.234132] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    4.293059] dummy_udc dummy_udc.0: set_address =3D 2
[    4.343064] g_ether gadget: high-speed config #1: CDC Ethernet (EEM)
[    4.344929] g_ether gadget: init eem
[    4.345971] g_ether gadget: activate eem
[    4.346371] dummy_udc dummy_udc.0: enabled ep1in-bulk (ep1in-bulk) maxpa=
cket 512 stream disabled
[    4.346371] dummy_udc dummy_udc.0: enabled ep2out-bulk (ep2out-bulk) max=
packet 512 stream disabled
[    4.346371] usb0: qlen 10
[    4.363042] g_ether gadget: reset eem
[    4.364127] usb0: gether_disconnect
[    4.365141] dummy_udc dummy_udc.0: disabled ep1in-bulk
[    4.366366] dummy_udc dummy_udc.0: disabled ep2out-bulk
[    4.366366] g_ether gadget: init eem
[    4.366366] g_ether gadget: activate eem
[    4.366366] dummy_udc dummy_udc.0: enabled ep1in-bulk (ep1in-bulk) maxpa=
cket 512 stream disabled
[    4.366366] dummy_udc dummy_udc.0: enabled ep2out-bulk (ep2out-bulk) max=
packet 512 stream disabled
[    4.366366] usb0: qlen 10
[    4.377081] cdc_eem 1-1:1.0 usb1: register 'cdc_eem' at usb-dummy_hcd.0-=
1, CDC EEM Device, fa:5c:42:78:78:57
[    4.906429] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2
[    4.916385] i2c i2c-0: detect fail: address match, 0x2c
[    4.929710] i2c i2c-0: detect fail: address match, 0x2d
[    4.943082] i2c i2c-0: detect fail: address match, 0x2e
[    4.956376] i2c i2c-0: detect fail: address match, 0x2f
[    5.123043] applesmc: supported laptop not found!
[    5.124508] applesmc: driver init failed (ret=3D-19)!
[   11.492923] pc87360: PC8736x not detected, module not inserted
[   11.652855] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   11.655067] usbcore: registered new interface driver ushc
[   15.671974]  (null): enodev DEV ADDR =3D 0xFF
[   15.674488] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   15.680735] usbcore: registered new interface driver usbhid
[   15.682285] usbhid: USB HID core driver
[   15.683655] usbip_core: USB/IP Core v1.0.0
[   15.697926] panel: could not claim access to parport0. Aborting.
[   15.699731] panel: driver version 0.9.5 not yet registered
[   15.701455] usbcore: registered new interface driver tranzport
[   15.703371] usbcore: registered new interface driver alphatrack
[   15.705177] vme_user: VME User Space Access Driver
[   15.706724] vme_user: No cards, skipping registration
[   15.711057] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[   15.714264] Copyright 2010. Beceem Communications Inc
[   15.717527] usbcore: registered new interface driver usbbcm
[   15.721105] usbcore: registered new interface driver ft1000usb
[   15.724902] logger: created 256K log 'log_main'
[   15.728116] logger: created 256K log 'log_events'
[   15.731996] logger: created 256K log 'log_radio'
[   15.736714] logger: created 256K log 'log_system'
[   15.738916] usbcore: registered new interface driver cedusb
[   15.743269] dgnc: dgnc-1.3-16, Digi International Part Number 40002369_F
[   15.758269] dgnc: For the tools package or updated drivers please visit =
http://www.digi.com
[   15.761177] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[   15.763233] dgap: For the tools package or updated drivers please visit =
http://www.digi.com
[   15.770265]  fake-fmc-carrier: mezzanine 0
[   15.784392]       Manufacturer: fake-vendor
[   15.785526]       Product name: fake-design-for-testing
[   15.787000] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   15.789078] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   15.791799] NET: Registered protocol family 26
[   15.793173] NET: Registered protocol family 4
[   15.794510] NET: Registered protocol family 5
[   15.813060] NET: Registered protocol family 11
[   15.814472] NET: Registered protocol family 3
[   15.815685] can: controller area network core (rev 20120528 abi 9)
[   15.817506] NET: Registered protocol family 29
[   15.818737] can: raw protocol (rev 20120528)
[   15.819943] can: broadcast manager protocol (rev 20120528 t)
[   15.821527] can: netlink gateway (rev 20130117) max_hops=3D1
[   15.836703] IrCOMM protocol (Dag Brattli)
[   15.840959] NET: Registered protocol family 35
[   15.842362] 9pnet: Installing 9P2000 support
[   15.843549] NET: Registered protocol family 36
[   15.844712] openvswitch: Open vSwitch switching datapath
[   15.847315]=20
[   15.847315] printing PIC contents
[   15.861679] ... PIC  IMR: ffff
[   15.862516] ... PIC  IRR: 1013
[   15.863367] ... PIC  ISR: 0000
[   15.864154] ... PIC ELCR: 0c00
[   15.864973] printing local APIC contents on CPU#0/0:
[   15.866337] ... APIC ID:      00000000 (0)
[   15.866693] ... APIC VERSION: 00050014
[   15.866693] ... APIC TASKPRI: 00000000 (00)
[   15.866693] ... APIC PROCPRI: 00000000
[   15.866693] ... APIC LDR: 01000000
[   15.866693] ... APIC DFR: ffffffff
[   15.866693] ... APIC SPIV: 000001ff
[   15.866693] ... APIC ISR field:
[   15.866693] 000000000000000000000000000000000000000000000000000000000000=
0000
[   15.866693] ... APIC TMR field:
[   15.866693] 000000000200000000000000000000000000000000000000000000000000=
0000
[   15.866693] ... APIC IRR field:
[   15.866693] 000000000000000000000000000000000000000000000000000000000000=
8000
[   15.866693] ... APIC ESR: 00000000
[   15.866693] ... APIC ICR: 00000831
[   15.866693] ... APIC ICR2: 01000000
[   15.866693] ... APIC LVTT: 000200ef
[   15.866693] ... APIC LVTPC: 00010000
[   15.866693] ... APIC LVT0: 00010700
[   15.866693] ... APIC LVT1: 00000400
[   15.866693] ... APIC LVTERR: 000000fe
[   15.866693] ... APIC TMICT: 00032db8
[   15.866693] ... APIC TMCCT: 00017b7a
[   15.866693] ... APIC TDCR: 00000003
[   15.866693]=20
[   15.919589] number of MP IRQ sources: 15.
[   15.920768] number of IO-APIC #0 registers: 24.
[   15.922093] testing the IO APIC.......................
[   15.923650] IO APIC #0......
[   15.924517] .... register #00: 00000000
[   15.926905] .......    : physical APIC id: 00
[   15.928217] .......    : Delivery Type: 0
[   15.929422] .......    : LTS          : 0
[   15.930602] .... register #01: 00170011
[   15.931722] .......     : max redirection entries: 17
[   15.933235] .......     : PRQ implemented: 0
[   15.934484] .......     : IO APIC version: 11
[   15.935771] .... register #02: 00000000
[   15.936896] .......     : arbitration: 00
[   15.938070] .... IRQ redirection table:
[   15.940559] 1    0    0   0   0    0    0    00
[   15.941926] 0    0    0   0   0    1    1    31
[   15.943304] 0    0    0   0   0    1    1    30
[   15.944648] 0    0    0   0   0    1    1    33
[   15.946051] 1    0    0   0   0    1    1    34
[   15.947427] 1    1    0   0   0    1    1    35
[   15.950560] 0    0    0   0   0    1    1    36
[   15.951921] 0    0    0   0   0    1    1    37
[   15.953398] 0    0    0   0   0    1    1    38
[   15.954727] 0    1    0   0   0    1    1    39
[   15.956085] 1    1    0   0   0    1    1    3A
[   15.957434] 1    1    0   0   0    1    1    3B
[   15.958790] 0    0    0   0   0    1    1    3C
[   15.960538] 0    0    0   0   0    1    1    3D
[   15.961900] 0    0    0   0   0    1    1    3E
[   15.963288] 0    0    0   0   0    1    1    3F
[   15.964610] 1    0    0   0   0    0    0    00
[   15.965957] 1    0    0   0   0    0    0    00
[   15.967321] 1    0    0   0   0    0    0    00
[   15.968672] 1    0    0   0   0    0    0    00
[   15.970001] 1    0    0   0   0    0    0    00
[   15.971372] 1    0    0   0   0    0    0    00
[   15.972739] 1    0    0   0   0    0    0    00
[   15.974072] 1    0    0   0   0    0    0    00
[   15.975439] IRQ to pin mappings:
[   15.976399] IRQ0 -> 0:2
[   15.977214] IRQ1 -> 0:1
[   15.978004] IRQ3 -> 0:3
[   15.978851] IRQ4 -> 0:4
[   15.979667] IRQ5 -> 0:5
[   15.980649] IRQ6 -> 0:6
[   15.981465] IRQ7 -> 0:7
[   15.982305] IRQ8 -> 0:8
[   15.983089] IRQ9 -> 0:9
[   15.983904] IRQ10 -> 0:10
[   15.984775] IRQ11 -> 0:11
[   15.985665] IRQ12 -> 0:12
[   15.986523] IRQ13 -> 0:13
[   15.987385] IRQ14 -> 0:14
[   15.988247] IRQ15 -> 0:15
[   15.989103] .................................... done.
[   15.991082] AppArmor: AppArmor sha1 policy hashing enabled
[   15.993263] RIO: rio_register_scan for mport_id=3D-1
[   15.995025]   Magic number: 1:49:14
[   15.996077] tty ircomm26: hash matches
[   15.997260] tty ttycb: hash matches
[   15.998900] rtc-test rtc-test.0: setting system clock to 2013-10-19 06:0=
1:03 UTC (1382162463)
[   16.001675] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   16.003474] EDD information not available.
[   16.009330] Freeing unused kernel memory: 764K (ffffffff81f76000 - fffff=
fff82035000)
[   16.012894] Write protecting the kernel read-only data: 12288k
[   16.028548] Freeing unused kernel memory: 1044K (ffff8800016fb000 - ffff=
880001800000)
[   16.032336] Freeing unused kernel memory: 200K (ffff880001bce000 - ffff8=
80001c00000)

/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
Starting udev
/etc/rcS.d/S03udev: line 72: can't create /proc/sys/kernel/hotplug: nonexis=
tent directory
error getting signalfd
error sending message: Connection refused
error sending message: Connection refused
Starting Bootlog daemon: bootlogd: cannot find console device 4:64 under /d=
ev
bootlogd.
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
[   21.777944] update-modules: Corrupted page table at address 7fb5a28eecf0
[   21.779752] PGD 9d583 PUD 0=20
[   21.780614] Bad pagetable: 001d [#1] PREEMPT=20
[   21.781236] CPU: 0 PID: 254 Comm: update-modules Not tainted 3.12.0-rc3-=
00039-g87eac4a #666
[   21.781236] task: ffff88000c475100 ti: ffff88000cff2000 task.ti: ffff880=
00cff2000
[   21.781236] RIP: 0033:[<00007fb5a28eecf0>]  [<00007fb5a28eecf0>] 0x7fb5a=
28eecef
[   21.781236] RSP: 002b:00007fff506df0e8  EFLAGS: 00010246
[   21.781236] RAX: 0000000000000000 RBX: 0000000000000080 RCX: fffffffffff=
fffff
[   21.781236] RDX: 0000000000000080 RSI: 00007fff506df190 RDI: 00000000000=
00003
[   21.781236] RBP: 00007fff506df190 R08: 0000000000000000 R09: 00000000000=
000fe
[   21.781236] R10: 00007fb5a2dc89d0 R11: 0000000000000246 R12: 00000000000=
00003
[   21.781236] R13: 0000000000000001 R14: 0000000000000001 R15: 00000000000=
00003
[   21.781236] FS:  00007fb5a2dc8700(0000) GS:ffffffff81c1e000(0000) knlGS:=
0000000000000000
[   21.781236] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   21.781236] CR2: 00007fb5a28eecf0 CR3: 000000000c463000 CR4: 00000000000=
006b0
[   21.781236]=20
[   21.781236] RIP  [<00007fb5a28eecf0>] 0x7fb5a28eecef
[   21.781236]  RSP <00007fff506df0e8>
[   21.814568] ---[ end trace 09146db959ca9a18 ]---
Killed
ERROR: postinst /etc/rpm-postinsts/100 failed.
[   90.561150] Unregister pv shared memory for cpu 0
[   90.563782] reboot: Restarting system
[   90.564868] reboot: machine restart
Elapsed time: 95
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-x3----1018/87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5/vmlinuz-3.12.0-rc3-000=
39-g87eac4a -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D10=
0 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_p=
rintk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests=
/run-queue/kvm/x86_64-randconfig-x3----1018/userns:userns-always-map-user-v=
136:87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5:bisect-usb/.vmlinuz-87eac4a7f8=
ddcbb3fbf9ade76a975b260d67d7b5-20131019231322-387-lkp-tt02 branch=3Duserns/=
userns-always-map-user-v136 BOOT_IMAGE=3D/kernel/x86_64-randconfig-x3----10=
18/87eac4a7f8ddcbb3fbf9ade76a975b260d67d7b5/vmlinuz-3.12.0-rc3-00039-g87eac=
4a'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 256M -smp 2 -=
net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio -net user,vlan=
=3D0,hostfwd=3Dtcp::6972-:22 -net nic,vlan=3D1,model=3De1000 -net user,vlan=
=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -pidfile /dev/shm/kboot=
/pid-yocto-lkp-tt02-12 -serial file:/dev/shm/kboot/serial-yocto-lkp-tt02-12=
 -daemonize -display none -monitor null=20

--tsOsTdHNUZQcU9Ye--
