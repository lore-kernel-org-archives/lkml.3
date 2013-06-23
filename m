Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3FWAc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 20:32:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:8358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab3FWAcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 20:32:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,920,1363158000"; 
   d="log'?scan'208";a="354156421"
Date: Sun, 23 Jun 2013 08:32:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [tracing or timer] WARNING: at kernel/lockdep.c:3539 check_flags()
Message-ID: <20130623003214.GA7541@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Greetings,

FYI, an old WARNING that still exists in upstream and linux-next.  Note that
the second "NULL pointer dereference" bug has been fixed in latest upstream and
linux-next.

[    1.717904] Testing tracer wakeup_rt: ret = 0
[    1.960950] PASSED
[    1.990036] Testing tracer branch:
[    2.123408] ------------[ cut here ]------------
[    2.124080] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3539 check_flags.part.41+0xc0/0x200()

[    2.125245] DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)
[    2.125984] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.0-rc1-00058-g57b8c53 #16
[    2.126666]  0000000000000009 ffff88000dc03cf8 ffffffff81aef1b9 ffff88000dc03d30
[    2.126666]  ffffffff810c0113 ffff88000d2e1fd8 0000000000000000 0000000000000000
[    2.126666]  0000000000000002 0000000000000000 ffff88000dc03d90 ffffffff810c019c
[    2.126666] Call Trace:
[    2.126666]  <IRQ>  [<ffffffff81aef1b9>] dump_stack+0x19/0x1b
[    2.126666]  [<ffffffff810c0113>] warn_slowpath_common+0x73/0x90
[    2.126666]  [<ffffffff810c019c>] warn_slowpath_fmt+0x4c/0x50
[    2.126666]  [<ffffffff8114dd40>] check_flags.part.41+0xc0/0x200
[    2.126666]  [<ffffffff81152a09>] lock_acquire+0x119/0x240
[    2.126666]  [<ffffffff81188173>] ? ring_buffer_unlock_commit+0x33/0x290
[    2.126666]  [<ffffffff810dbfa0>] ? ftrace_raw_output_itimer_expire+0x80/0x80
[    2.126666]  [<ffffffff810dd8c3>] call_timer_fn+0x83/0x530
[    2.126666]  [<ffffffff810dd845>] ? call_timer_fn+0x5/0x530
[    2.126666]  [<ffffffff810de084>] run_timer_softirq+0x314/0x520
[    2.126666]  [<ffffffff8114e0ed>] ? trace_hardirqs_on+0xd/0x10
[    2.126666]  [<ffffffff810dbfa0>] ? ftrace_raw_output_itimer_expire+0x80/0x80
[    2.126666]  [<ffffffff810cfc48>] __do_softirq+0x1f8/0x6f0
[    2.126666]  [<ffffffff810d03e5>] irq_exit+0xd5/0xe0
[    2.126666]  [<ffffffff81063bc6>] smp_apic_timer_interrupt+0x86/0xc0
[    2.126666]  [<ffffffff81aff76f>] apic_timer_interrupt+0x6f/0x80
[    2.126666]  <EOI>  [<ffffffff8119aa7e>] ? ftrace_likely_update+0x11e/0x250
[    2.126666]  [<ffffffff8106dbc6>] ? native_safe_halt+0x6/0x10
[    2.126666]  [<ffffffff810314a4>] default_idle+0x124/0x440
[    2.126666]  [<ffffffff810329d6>] arch_cpu_idle+0x36/0x40
[    2.126666]  [<ffffffff8113d096>] cpu_startup_entry+0x436/0x7e0
[    2.126666]  [<ffffffff811478cc>] ? clockevents_register_device+0x11c/0x1d0
[    2.126666]  [<ffffffff81adafd2>] start_secondary+0x2b8/0x2c0
[    2.126666] ---[ end trace 7bbf806df5469d34 ]---
[    2.126666] possible reason: unannotated irqs-on.
[    2.126666] irq event stamp: 16541
[    2.126666] hardirqs last  enabled at (16540): [<ffffffff81afccee>] _raw_spin_unlock_irq+0x2e/0x80
[    2.126666] hardirqs last disabled at (16541): [<ffffffff8119a9e7>] ftrace_likely_update+0x87/0x250
[    2.126666] softirqs last  enabled at (16532): [<ffffffff810d0300>] irq_enter+0x90/0xa0
[    2.126666] softirqs last disabled at (16533): [<ffffffff810d03e5>] irq_exit+0xd5/0xe0
[    2.183568] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    2.186666] IP: [<ffffffff81382fc1>] find_next_bit+0x141/0x190
[    2.186666] PGD 0
[    2.186666] Oops: 0000 [#1] SMP
[    2.186666] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-rc1-00058-g57b8c53 #16
[    2.186666] task: ffff88000d0d8000 ti: ffff88000d140000 task.ti: ffff88000d140000
[    2.186666] RIP: 0010:[<ffffffff81382fc1>]  [<ffffffff81382fc1>] find_next_bit+0x141/0x190
[    2.186666] RSP: 0000:ffff88000d141de0  EFLAGS: 00010046
[    2.186666] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[    2.186666] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
[    2.186666] RBP: ffff88000d141de0 R08: 0000000000000000 R09: 0000000000000000
[    2.186666] R10: 0000000000000000 R11: 00012f2478ebe8ab R12: ffffffff82478830
[    2.186666] R13: 00000000ffffffff R14: ffffffff82a08020 R15: 0000000000000000
[    2.186666] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    2.186666] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.186666] CR2: 0000000000000000 CR3: 0000000002409000 CR4: 00000000000006e0
[    2.186666] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.186666] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    2.186666] Stack:
[    2.186666]  ffff88000d141e10 ffffffff8118900c ffff88000d15b200 ffffffff83705860
[    2.186666]  0000000000000000 ffffffff83705860 ffff88000d141e60 ffffffff8118e48f
[    2.186666]  ffff88000d141e70 ffff88000d141e48 0000000000000282 ffffffff83705860              
[    2.186666] Call Trace:
[    2.186666]  [<ffffffff8118900c>] ring_buffer_entries+0x6c/0xb0
[    2.186666]  [<ffffffff8118e48f>] trace_test_buffer+0x7f/0x250
[    2.186666]  [<ffffffff81193eb7>] trace_selftest_startup_branch+0x47/0xc0
[    2.186666]  [<ffffffff81194a87>] register_tracer+0x1f7/0x300
[    2.186666]  [<ffffffff82c11023>] ? init_mmio_trace+0x12/0x12
[    2.186666]  [<ffffffff82c11056>] init_branch_tracer+0x33/0x35
[    2.186666]  [<ffffffff82be14ff>] do_one_initcall+0x87/0x191
[    2.186666]  [<ffffffff82be1716>] kernel_init_freeable+0x10d/0x1c5
[    2.186666]  [<ffffffff82be0a79>] ? do_early_param+0xc1/0xc1
[    2.186666]  [<ffffffff81ac91d0>] ? rest_init+0x180/0x180
[    2.186666]  [<ffffffff81ac91de>] kernel_init+0xe/0x210
[    2.186666]  [<ffffffff81afeabc>] ret_from_fork+0x7c/0xb0
[    2.186666]  [<ffffffff81ac91d0>] ? rest_init+0x180/0x180
[    2.186666] Code: ff ff ff 0f 1f 80 00 00 00 00 48 85 f6 0f 94 c1 0f b6 c1 48 83 c0 02 48 83 04 c5 68 66 73 82 01 84 c9 4c 89 c
0 0f 85 78 ff ff ff <48> 8b 02 b9 40 00 00 00 48 c7 c2 ff ff ff ff 29 f1 48 d3 ea 48
[    2.186666] RIP  [<ffffffff81382fc1>] find_next_bit+0x141/0x190
[    2.186666]  RSP <ffff88000d141de0>
[    2.186666] CR2: 0000000000000000
[    2.186666] ---[ end trace 7bbf806df5469d35 ]---
[    2.186666] Kernel panic - not syncing: Fatal exception

git bisect  bad 57b8c53a06365253d83d4fae03353107dd059884  # 22:00      0-  KVM: MMU: document fast invalidate all mmio sptes
git bisect  bad 8915aa27d5efbb9185357175b0acf884325565f9  # 22:01      0-  KVM: x86: handle idiv overflow at kvm_write_tsc
git bisect  bad c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1  # 22:07      0-  Linux 3.9
git bisect  bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200  # 22:11      0-  Linux 3.8
git bisect  bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e  # 22:16      0-  Linux 3.7
git bisect  bad a0d271cbfed1dd50278c6b06bead3d00ba0a88f9  # 22:21      0-  Linux 3.6
git bisect  bad 28a33cbc24e4256c143dce96c7d93bf423229f92  # 22:25      0-  Linux 3.5
git bisect  bad 76e10d158efb6d4516018846f60c2ab5501900bc  # 22:29      0-  Linux 3.4
git bisect  bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7  # 22:33      0-  Linux 3.3
git bisect  bad 805a6af8dba5dfdd35ec35dc52ec0122400b2610  # 22:37      0-  Linux 3.2
git bisect  bad c3b92c8787367a8bb53d57d9789b558f1295cc96  # 22:40      0-  Linux 3.1
git bisect  bad 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe  # 22:44      0-  Linux 3.0
git bisect  bad 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf  # 22:48      0-  Linux 2.6.39
git bisect  bad f71194a7d47c1da787555d27aac63973ca72323b  # 23:30      0-  Merge branch 'x86/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad e1a86578747376f08985627c84df088a5d0d1e92  # 23:34      0-  Add linux-next specific files for 20130621

Thanks,
Fengguang

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-inn-34410-20130620125621-3.10.0-rc1-00058-g57b8c53-16"

[    0.000000] Linux version 3.10.0-rc1-00058-g57b8c53 (kbuild@xian) (gcc version 4.8.1 (Debian 4.8.1-3) ) #16 SMP Thu Jun 20 12:53:29 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-x04-0620/kvm:queue/.vmlinuz-57b8c53a06365253d83d4fae03353107dd059884-20130620125413-1-inn branch=kvm/queue  BOOT_IMAGE=/kernel/x86_64-randconfig-x04-0620/57b8c53a06365253d83d4fae03353107dd059884/vmlinuz-3.10.0-rc1-00058-g57b8c53
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x037ba000, 0x037bafff] PGTABLE
[    0.000000] BRK [0x037bb000, 0x037bbfff] PGTABLE
[    0.000000] BRK [0x037bc000, 0x037bcfff] PGTABLE
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
[    0.000000] BRK [0x037bd000, 0x037bdfff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127380(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5ba000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0e0af000-0x0e0d5fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:e06f001, boot clock
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
[    0.000000] mapped APIC to ffffffffff5ba000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5b9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff88000da00000 s1919104 r0 d22400 u2097152
[    0.000000] pcpu-alloc: s1919104 r0 d22400 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:e06f001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr da0df00
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-x04-0620/kvm:queue/.vmlinuz-57b8c53a06365253d83d4fae03353107dd059884-20130620125413-1-inn branch=kvm/queue  BOOT_IMAGE=/kernel/x86_64-randconfig-x04-0620/57b8c53a06365253d83d4fae03353107dd059884/vmlinuz-3.10.0-rc1-00058-g57b8c53
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 180084k/262136k available (11274k kernel code, 392k absent, 81660k reserved, 15389k data, 3476k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.546 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.55 BogoMIPS (lpj=8978486)
[    0.007047] pid_max: default: 32768 minimum: 301
[    0.010073] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.011071] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.011996] Mount-cache hash table entries: 256
[    0.013560] mce: CPU supports 10 MCE banks
[    0.014142] numa_add_cpu cpu 0 node 0: mask now 0
[    0.014752] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014752] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014752] tlb_flushall_shift: 6
[    0.016646] Freeing SMP alternatives: 16k freed
[    0.022694] ACPI: Core revision 20130328
[    0.030723] ACPI: All ACPI Tables successfully acquired
[    0.031485] ftrace: allocating 27945 entries in 110 pages
[    0.043779] Getting VERSION: 50014
[    0.046694] Getting VERSION: 50014
[    0.047184] Getting ID: 0
[    0.047566] Getting ID: ff000000
[    0.048041] Getting LVT0: 8700
[    0.048490] Getting LVT1: 8400
[    0.049015] enabled ExtINT on CPU#0
[    0.050859] ENABLING IO-APIC IRQs
[    0.051330] init IO_APIC IRQs
[    0.051768]  apic 0 pin 0 not connected
[    0.052311] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.053374] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.054406] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.055434] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.056472] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.056702] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.057720] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.058731] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.060035] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.061049] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.062395] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.063368] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.064562] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.066703] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.067837] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.069154]  apic 0 pin 16 not connected
[    0.069697]  apic 0 pin 17 not connected
[    0.070010]  apic 0 pin 18 not connected
[    0.070551]  apic 0 pin 19 not connected
[    0.071090]  apic 0 pin 20 not connected
[    0.071632]  apic 0 pin 21 not connected
[    0.072127]  apic 0 pin 22 not connected
[    0.072631]  apic 0 pin 23 not connected
[    0.073512] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.074712] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.076676] Using local APIC timer interrupts.
[    0.076676] calibrating APIC timer ...
[    0.079999] ... lapic delta = 9165995
[    0.079999] ... PM-Timer delta = 524958
[    0.079999] APIC calibration not consistent with PM-Timer: 146ms instead of 100ms
[    0.079999] APIC delta adjusted to PM-Timer: 6250032 (9165995)
[    0.079999] TSC delta adjusted to PM-Timer: 269345460 (395009007)
[    0.079999] ..... delta 6250032
[    0.079999] ..... mult: 268436857
[    0.079999] ..... calibration result: 3333350
[    0.079999] ..... CPU clock speed is 2693.2413 MHz.
[    0.079999] ..... host bus clock speed is 1000.0350 MHz.
[    0.080113] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.084242] ftrace: Allocated trace_printk buffers
[    0.090305] Testing tracer nop: PASSED
[    0.094423] SMP alternatives: lockdep: fixing up alternatives
[    0.095601] smpboot: Booting Node   0, Processors  #1 OK
[    0.006666] kvm-clock: cpu 1, msr 0:e06f041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.006666] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.126681] Brought up 2 CPUs
[    0.127075] ----------------
[    0.127446] | NMI testsuite:
[    0.127806] --------------------
[    0.128208]   remote IPI:
[    0.126451] KVM setup async PF for cpu 1
[    0.126451] kvm-stealtime: cpu 1, msr dc0df00
  ok  |
[    0.146863]    local IPI:  ok  |
[    0.166688] --------------------
[    0.167109] Good, all   2 testcases passed! |
[    0.167642] ---------------------------------
[    0.168187] smpboot: Total of 2 processors activated (10778.10 BogoMIPS)
[    0.169655] CPU0 attaching sched-domain:
[    0.170021]  domain 0: span 0-1 level CPU
[    0.170546]   groups: 0 1
[    0.170952] CPU1 attaching sched-domain:
[    0.171437]  domain 0: span 0-1 level CPU
[    0.171962]   groups: 1 0
[    0.206714] Testing tracer function: PASSED
[    0.393368] Testing dynamic ftrace: PASSED
[    0.703516] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 10) (2 2 4 1 125) PASSED
[    0.958296] Testing dynamic ftrace ops #2: (1 0 1 11 0) (1 1 2 120 0) (2 1 3 2 11) (2 2 4 110 119) PASSED
[    1.314151] Testing ftrace recursion: PASSED
[    1.337410] Testing ftrace recursion safe: PASSED
[    1.360768] Testing ftrace regs: PASSED
[    1.448521] Testing tracer wakeup: ret = 0
[    1.656749] ftrace-test (16) used greatest stack depth: 6216 bytes left
[    1.687783] PASSED
[    1.717904] Testing tracer wakeup_rt: ret = 0
[    1.960950] PASSED
[    1.990036] Testing tracer branch: 
[    2.123408] ------------[ cut here ]------------
[    2.124080] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3539 check_flags.part.41+0xc0/0x200()

[    2.125245] DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)
[    2.125984] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.0-rc1-00058-g57b8c53 #16
[    2.126666]  0000000000000009 ffff88000dc03cf8 ffffffff81aef1b9 ffff88000dc03d30
[    2.126666]  ffffffff810c0113 ffff88000d2e1fd8 0000000000000000 0000000000000000
[    2.126666]  0000000000000002 0000000000000000 ffff88000dc03d90 ffffffff810c019c
[    2.126666] Call Trace:
[    2.126666]  <IRQ>  [<ffffffff81aef1b9>] dump_stack+0x19/0x1b
[    2.126666]  [<ffffffff810c0113>] warn_slowpath_common+0x73/0x90
[    2.126666]  [<ffffffff810c019c>] warn_slowpath_fmt+0x4c/0x50
[    2.126666]  [<ffffffff8114dd40>] check_flags.part.41+0xc0/0x200
[    2.126666]  [<ffffffff81152a09>] lock_acquire+0x119/0x240
[    2.126666]  [<ffffffff81188173>] ? ring_buffer_unlock_commit+0x33/0x290
[    2.126666]  [<ffffffff810dbfa0>] ? ftrace_raw_output_itimer_expire+0x80/0x80
[    2.126666]  [<ffffffff810dd8c3>] call_timer_fn+0x83/0x530
[    2.126666]  [<ffffffff810dd845>] ? call_timer_fn+0x5/0x530
[    2.126666]  [<ffffffff810de084>] run_timer_softirq+0x314/0x520
[    2.126666]  [<ffffffff8114e0ed>] ? trace_hardirqs_on+0xd/0x10
[    2.126666]  [<ffffffff810dbfa0>] ? ftrace_raw_output_itimer_expire+0x80/0x80
[    2.126666]  [<ffffffff810cfc48>] __do_softirq+0x1f8/0x6f0
[    2.126666]  [<ffffffff810d03e5>] irq_exit+0xd5/0xe0
[    2.126666]  [<ffffffff81063bc6>] smp_apic_timer_interrupt+0x86/0xc0
[    2.126666]  [<ffffffff81aff76f>] apic_timer_interrupt+0x6f/0x80
[    2.126666]  <EOI>  [<ffffffff8119aa7e>] ? ftrace_likely_update+0x11e/0x250
[    2.126666]  [<ffffffff8106dbc6>] ? native_safe_halt+0x6/0x10
[    2.126666]  [<ffffffff810314a4>] default_idle+0x124/0x440
[    2.126666]  [<ffffffff810329d6>] arch_cpu_idle+0x36/0x40
[    2.126666]  [<ffffffff8113d096>] cpu_startup_entry+0x436/0x7e0
[    2.126666]  [<ffffffff811478cc>] ? clockevents_register_device+0x11c/0x1d0
[    2.126666]  [<ffffffff81adafd2>] start_secondary+0x2b8/0x2c0
[    2.126666] ---[ end trace 7bbf806df5469d34 ]---
[    2.126666] possible reason: unannotated irqs-on.
[    2.126666] irq event stamp: 16541
[    2.126666] hardirqs last  enabled at (16540): [<ffffffff81afccee>] _raw_spin_unlock_irq+0x2e/0x80
[    2.126666] hardirqs last disabled at (16541): [<ffffffff8119a9e7>] ftrace_likely_update+0x87/0x250
[    2.126666] softirqs last  enabled at (16532): [<ffffffff810d0300>] irq_enter+0x90/0xa0
[    2.126666] softirqs last disabled at (16533): [<ffffffff810d03e5>] irq_exit+0xd5/0xe0
[    2.183568] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    2.186666] IP: [<ffffffff81382fc1>] find_next_bit+0x141/0x190
[    2.186666] PGD 0 
[    2.186666] Oops: 0000 [#1] SMP 
[    2.186666] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-rc1-00058-g57b8c53 #16
[    2.186666] task: ffff88000d0d8000 ti: ffff88000d140000 task.ti: ffff88000d140000
[    2.186666] RIP: 0010:[<ffffffff81382fc1>]  [<ffffffff81382fc1>] find_next_bit+0x141/0x190
[    2.186666] RSP: 0000:ffff88000d141de0  EFLAGS: 00010046
[    2.186666] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[    2.186666] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
[    2.186666] RBP: ffff88000d141de0 R08: 0000000000000000 R09: 0000000000000000
[    2.186666] R10: 0000000000000000 R11: 00012f2478ebe8ab R12: ffffffff82478830
[    2.186666] R13: 00000000ffffffff R14: ffffffff82a08020 R15: 0000000000000000
[    2.186666] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    2.186666] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.186666] CR2: 0000000000000000 CR3: 0000000002409000 CR4: 00000000000006e0
[    2.186666] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.186666] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    2.186666] Stack:
[    2.186666]  ffff88000d141e10 ffffffff8118900c ffff88000d15b200 ffffffff83705860
[    2.186666]  0000000000000000 ffffffff83705860 ffff88000d141e60 ffffffff8118e48f
[    2.186666]  ffff88000d141e70 ffff88000d141e48 0000000000000282 ffffffff83705860
[    2.186666] Call Trace:
[    2.186666]  [<ffffffff8118900c>] ring_buffer_entries+0x6c/0xb0
[    2.186666]  [<ffffffff8118e48f>] trace_test_buffer+0x7f/0x250
[    2.186666]  [<ffffffff81193eb7>] trace_selftest_startup_branch+0x47/0xc0
[    2.186666]  [<ffffffff81194a87>] register_tracer+0x1f7/0x300
[    2.186666]  [<ffffffff82c11023>] ? init_mmio_trace+0x12/0x12
[    2.186666]  [<ffffffff82c11056>] init_branch_tracer+0x33/0x35
[    2.186666]  [<ffffffff82be14ff>] do_one_initcall+0x87/0x191
[    2.186666]  [<ffffffff82be1716>] kernel_init_freeable+0x10d/0x1c5
[    2.186666]  [<ffffffff82be0a79>] ? do_early_param+0xc1/0xc1
[    2.186666]  [<ffffffff81ac91d0>] ? rest_init+0x180/0x180
[    2.186666]  [<ffffffff81ac91de>] kernel_init+0xe/0x210
[    2.186666]  [<ffffffff81afeabc>] ret_from_fork+0x7c/0xb0
[    2.186666]  [<ffffffff81ac91d0>] ? rest_init+0x180/0x180
[    2.186666] Code: ff ff ff 0f 1f 80 00 00 00 00 48 85 f6 0f 94 c1 0f b6 c1 48 83 c0 02 48 83 04 c5 68 66 73 82 01 84 c9 4c 89 c0 0f 85 78 ff ff ff <48> 8b 02 b9 40 00 00 00 48 c7 c2 ff ff ff ff 29 f1 48 d3 ea 48 
[    2.186666] RIP  [<ffffffff81382fc1>] find_next_bit+0x141/0x190
[    2.186666]  RSP <ffff88000d141de0>
[    2.186666] CR2: 0000000000000000
[    2.186666] ---[ end trace 7bbf806df5469d35 ]---
[    2.186666] Kernel panic - not syncing: Fatal exception
[    2.186666] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 25

--8t9RHnE3ZwKMSgU+
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-57b8c53a06365253d83d4fae03353107dd059884-x86_64-randconfig-x04-0620-check_flags-117920.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDg5MTVhYTI3ZDVlZmJiOTE4NTM1NzE3NWIwYWNmODg0MzI1NTY1ZjkK
V2FybmluZzogeW91IGFyZSBsZWF2aW5nIDEzIGNvbW1pdHMgYmVoaW5kLCBub3QgY29ubmVj
dGVkIHRvCmFueSBvZiB5b3VyIGJyYW5jaGVzOgoKICA1N2I4YzUzIEtWTTogTU1VOiBkb2N1
bWVudCBmYXN0IGludmFsaWRhdGUgYWxsIG1taW8gc3B0ZXMKICA4NmIxZWM0IEtWTTogTU1V
OiBkb2N1bWVudCBmYXN0IGludmFsaWRhdGUgYWxsIHBhZ2VzCiAgOTg3OTg5NiBLVk06IE1N
VTogZG9jdW1lbnQgZmFzdCBwYWdlIGZhdWx0CiAgOTdkMWRmMyBLVk06IE1NVTogZG9jdW1l
bnQgbW1pbyBwYWdlIGZhdWx0CiAuLi4gYW5kIDkgbW9yZS4KCklmIHlvdSB3YW50IHRvIGtl
ZXAgdGhlbSBieSBjcmVhdGluZyBhIG5ldyBicmFuY2gsIHRoaXMgbWF5IGJlIGEgZ29vZCB0
aW1lCnRvIGRvIHNvIHdpdGg6CgogZ2l0IGJyYW5jaCBuZXdfYnJhbmNoX25hbWUgNTdiOGM1
M2EwNjM2NTI1M2Q4M2Q0ZmFlMDMzNTMxMDdkZDA1OTg4NAoKSEVBRCBpcyBub3cgYXQgODkx
NWFhMi4uLiBLVk06IHg4NjogaGFuZGxlIGlkaXYgb3ZlcmZsb3cgYXQga3ZtX3dyaXRlX3Rz
YwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
eDA0LTA2MjAva3ZtOnF1ZXVlOjg5MTVhYTI3ZDVlZmJiOTE4NTM1NzE3NWIwYWNmODg0MzI1
NTY1Zjk6YmlzZWN0LW1tCiBURVNUIEZBSUxVUkUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14MDQtMDYyMC84OTE1YWEyN2Q1ZWZiYjkxODUzNTcxNzViMGFjZjg4NDMyNTU2NWY5L2Rt
ZXNnLWt2bS1hdGhlbnMtMjk1OTAtMjAxMzA2MjAxMzAyMTEtMy4xMC4wLXJjMS0wMDAzNy1n
ODkxNWFhMi0xNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwLzg5MTVhYTI3
ZDVlZmJiOTE4NTM1NzE3NWIwYWNmODg0MzI1NTY1ZjkvZG1lc2cta3ZtLWF0aGVucy00NTI4
OC0yMDEzMDYyMDEzMDIyMC0zLjEwLjAtcmMxLTAwMDM3LWc4OTE1YWEyLTE1Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAvODkxNWFhMjdkNWVmYmI5MTg1MzU3MTc1YjBh
Y2Y4ODQzMjU1NjVmOS9kbWVzZy1rdm0tYXRoZW5zLTUwMjYxLTIwMTMwNjIwMTMwMjEyLTMu
MTAuMC1yYzEtMDAwMzctZzg5MTVhYTItMTUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14
MDQtMDYyMC84OTE1YWEyN2Q1ZWZiYjkxODUzNTcxNzViMGFjZjg4NDMyNTU2NWY5L2RtZXNn
LWt2bS1iYXktMzQ3Ny0yMDEzMDYyMDEyMzMzMy0zLjEwLjAtcmMxLTAwMDM3LWc4OTE1YWEy
LTE1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAvODkxNWFhMjdkNWVmYmI5
MTg1MzU3MTc1YjBhY2Y4ODQzMjU1NjVmOS9kbWVzZy1rdm0tYmF5LTM3OTEtMjAxMzA2MjAx
MjE2MzgtMy4xMC4wLXJjMS0wMDAzNy1nODkxNWFhMi0xNQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXgwNC0wNjIwLzg5MTVhYTI3ZDVlZmJiOTE4NTM1NzE3NWIwYWNmODg0MzI1NTY1
ZjkvZG1lc2cta3ZtLWlubi0yMTU3Ni0yMDEzMDYyMDEzMDE0My0zLjEwLjAtcmMxLTAwMDM3
LWc4OTE1YWEyLTE1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAvODkxNWFh
MjdkNWVmYmI5MTg1MzU3MTc1YjBhY2Y4ODQzMjU1NjVmOS9kbWVzZy1rdm0taW5uLTM4Njg3
LTIwMTMwNjIwMTMwMTQ4LTMuMTAuMC1yYzEtMDAwMzctZzg5MTVhYTItMTUKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC84OTE1YWEyN2Q1ZWZiYjkxODUzNTcxNzViMGFj
Zjg4NDMyNTU2NWY5L2RtZXNnLWt2bS1zbmItMjQxNzctMjAxMzA2MjAxMjE3MzMtMy4xMC4w
LXJjMS0wMDAzNy1nODkxNWFhMi0xNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0w
NjIwLzg5MTVhYTI3ZDVlZmJiOTE4NTM1NzE3NWIwYWNmODg0MzI1NTY1ZjkvZG1lc2cta3Zt
LXZwLTEwNzcwLTIwMTMwNjIwMTIxNTUzLTMuMTAuMC1yYzEtMDAwMzctZzg5MTVhYTItMTUK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC84OTE1YWEyN2Q1ZWZiYjkxODUz
NTcxNzViMGFjZjg4NDMyNTU2NWY5L2RtZXNnLWt2bS12cC0xMTExOC0yMDEzMDYyMDEyMTYw
NC0zLjEwLjAtcmMxLTAwMDM3LWc4OTE1YWEyLTE1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDA0LTA2MjAvODkxNWFhMjdkNWVmYmI5MTg1MzU3MTc1YjBhY2Y4ODQzMjU1NjVmOS9k
bWVzZy1rdm0tdnAtMTM5ODMtMjAxMzA2MjAxMjE1NDctMy4xMC4wLXJjMS0wMDAzNy1nODkx
NWFhMi0xNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwLzg5MTVhYTI3ZDVl
ZmJiOTE4NTM1NzE3NWIwYWNmODg0MzI1NTY1ZjkvZG1lc2cta3ZtLXZwLTE0MTM0LTIwMTMw
NjIwMTIxNjA2LTMuMTAuMC1yYzEtMDAwMzctZzg5MTVhYTItMTUKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy14MDQtMDYyMC84OTE1YWEyN2Q1ZWZiYjkxODUzNTcxNzViMGFjZjg4NDMy
NTU2NWY5L2RtZXNnLWt2bS12cC02NjY5LTIwMTMwNjIwMTMwMzM5LTMuMTAuMC1yYzEtMDAw
MzctZzg5MTVhYTItMTUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC84OTE1
YWEyN2Q1ZWZiYjkxODUzNTcxNzViMGFjZjg4NDMyNTU2NWY5L2RtZXNnLWt2bS12cC05NDQy
LTIwMTMwNjIwMTIxNTUyLTMuMTAuMC1yYzEtMDAwMzctZzg5MTVhYTItMTUKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC84OTE1YWEyN2Q1ZWZiYjkxODUzNTcxNzViMGFj
Zjg4NDMyNTU2NWY5L2RtZXNnLWt2bS14Ym0tNzAxNi0yMDEzMDYyMDEyMTY1NS0zLjEwLjAt
cmMxLTAwMDM3LWc4OTE1YWEyLTE1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDA0LTA2
MjAvODkxNWFhMjdkNWVmYmI5MTg1MzU3MTc1YjBhY2Y4ODQzMjU1NjVmOS9kbWVzZy1rdm0t
eGlhbi0xMzAxNi0yMDEzMDYyMDEzMDIwNy0zLjEwLjAtcmMxLTAwMDM3LWc4OTE1YWEyLTE1
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAvODkxNWFhMjdkNWVmYmI5MTg1
MzU3MTc1YjBhY2Y4ODQzMjU1NjVmOS9kbWVzZy1rdm0teGlhbi0yMzI4MS0yMDEzMDYyMDEz
MDIwMS0zLjEwLjAtcmMxLTAwMDM3LWc4OTE1YWEyLTE1Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDA0LTA2MjAvODkxNWFhMjdkNWVmYmI5MTg1MzU3MTc1YjBhY2Y4ODQzMjU1NjVm
OS9kbWVzZy1rdm0teGlhbi00NzE0My0yMDEzMDYyMDEzMDIwMy0zLjEwLjAtcmMxLTAwMDM3
LWc4OTE1YWEyLTE1CgpiaXNlY3Q6IGJhZCBjb21taXQgODkxNWFhMjdkNWVmYmI5MTg1MzU3
MTc1YjBhY2Y4ODQzMjU1NjVmOQpnaXQgY2hlY2tvdXQgdjMuOQpQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyA4OTE1YWEyLi4uIEtWTTogeDg2OiBoYW5kbGUgaWRpdiBvdmVyZmxvdyBh
dCBrdm1fd3JpdGVfdHNjCkhFQUQgaXMgbm93IGF0IGMxYmU1YTUuLi4gTGludXggMy45Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MDQt
MDYyMC9rdm06cXVldWU6YzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFk
MTpiaXNlY3QtbW0KCjIwMTMtMDYtMjItMjI6MDE6MzcgYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3
OWNjOTc5ZWI2NmRhZmEyNGFkMSBjb21waWxpbmcKMjI1IHJlYWwgIDE3MjAgdXNlciAgMTMz
IHN5cyAgODIyLjYwJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwCgoyMDEzLTA2
LTIyLTIyOjA1OjM3IGRldGVjdGluZyBib290IHN0YXRlIDMuOS4wLi4uIFRFU1QgRkFJTFVS
RQpkbWVzZy1rdm0tbGtwLW5leDA0LTUxMTczLTIwMTMwNjIyMjIwNzU0LTMuOS4wLTY2CmRt
ZXNnLWt2bS1sa3Atc2J4MDQtMzYzOS0yMDEzMDYyMzAyMTAzMS0zLjkuMC02NgpkbWVzZy1r
dm0tbGtwLW5leDA0LTI0MDEyLTIwMTMwNjIyMjIwNzQyLTMuOS4wLTY2CmRtZXNnLWt2bS1h
dGhlbnMtMjYxNTQtMjAxMzA2MjIyMjA2MzAtMy45LjAtNjYKZG1lc2cta3ZtLWxrcC1uZXgw
NC01MzA1Ni0yMDEzMDYyMjIyMDc1NS0zLjkuMC02NgpkbWVzZy1rdm0tbGtwLW5leDA0LTI0
NzEzLTIwMTMwNjIyMjIwNzUzLTMuOS4wLTY2CmRtZXNnLWt2bS1sa3Atc2J4MDQtNzgxNy0y
MDEzMDYyMzAyMTAyNi0zLjkuMC02NgpkbWVzZy1rdm0tbGtwLXNieDA0LTQwMzE0LTIwMTMw
NjIzMDIxMDI2LTMuOS4wLTY2CmRtZXNnLWt2bS1sa3AtbmV4MDQtNjMwOTItMjAxMzA2MjIy
MjA3NTUtMy45LjAtNjYKZG1lc2cta3ZtLWxrcC1zYngwNC01NDc1Ny0yMDEzMDYyMzAyMTAz
NC0zLjkuMC02NgpkbWVzZy1rdm0tbGtwLW5leDA0LTYzNTktMjAxMzA2MjIyMjA3NTUtMy45
LjAtNjYKZG1lc2cta3ZtLWxrcC1zYngwNC0yNDkzMC0yMDEzMDYyMzAyMTAyNi0zLjkuMC02
NgpkbWVzZy1rdm0tbGtwLXNieDA0LTU2NDUtMjAxMzA2MjMwMjEwMjYtMy45LjAtNjYKZG1l
c2cta3ZtLWxrcC1zYngwNC00MTkzOS0yMDEzMDYyMzAyMTAyNy0zLjkuMC02NgpkbWVzZy1r
dm0tbGtwLW5leDA0LTE2MzE2LTIwMTMwNjIyMjIwNzU2LTMuOS4wLTY2CmRtZXNnLWt2bS1s
a3Atc2J4MDQtNDIzOTUtMjAxMzA2MjMwMjEwMzItMy45LjAtNjYKZG1lc2cta3ZtLWxrcC1u
ZXgwNC0zNjg3Mi0yMDEzMDYyMjIyMDc1NC0zLjkuMC02NgpkbWVzZy1rdm0tbGtwLW5leDA0
LTE2NjgyLTIwMTMwNjIyMjIwNzU0LTMuOS4wLTY2CmRtZXNnLWt2bS1sa3Atc2J4MDQtODM4
Mi0yMDEzMDYyMzAyMTAyNi0zLjkuMC02NgpkbWVzZy1rdm0tbGtwLW5leDA0LTM3MjcwLTIw
MTMwNjIyMjIwODAwLTMuOS4wLTY2CmRtZXNnLWt2bS1hdGhlbnMtNjIzMzMtMjAxMzA2MjIy
MjA2MjctMy45LjAtNjYKZG1lc2cta3ZtLWF0aGVucy02MjQ1Mi0yMDEzMDYyMjIyMDYyOS0z
LjkuMC02NgpkbWVzZy1rdm0tYXRoZW5zLTYyNjU2LTIwMTMwNjIyMjIwNjI4LTMuOS4wLTY2
CgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuOQpnaXQgY2hlY2tvdXQgdjMuOApQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyBjMWJlNWE1Li4uIExpbnV4IDMuOQpIRUFEIGlzIG5vdyBhdCAx
OWY5NDlmLi4uIExpbnV4IDMuOApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAva3ZtOnF1ZXVlOjE5Zjk0OWY1MjU5OWJhN2Mz
ZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDA6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIyOjA3OjE0
IDE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAgY29tcGlsaW5nCjE1
NiByZWFsICAxNjY1IHVzZXIgIDEyOCBzeXMgIDExNDYuOTElIGNwdSAJeDg2XzY0LXJhbmRj
b25maWcteDA0LTA2MjAKCjIwMTMtMDYtMjItMjI6MTA6MDcgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy44LjAuLi4gVEVTVCBGQUlMVVJFCmRtZXNnLWt2bS1sa3AtbmV4MDQtMjM5MC0yMDEz
MDYyMjIyMTIyNC0zLjguMC02NwpkbWVzZy1rdm0tbGtwLW5leDA0LTU4NzE2LTIwMTMwNjIy
MjIxMjM3LTMuOC4wLTY3CmRtZXNnLWt2bS1sa3Atc2J4MDQtMjE0NDktMjAxMzA2MjMwMjE1
MDMtMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1zYngwNC05Njc4LTIwMTMwNjIzMDIxNTA5LTMu
OC4wLTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtNjE3NTEtMjAxMzA2MjIyMjEyMjQtMy44LjAt
NjcKZG1lc2cta3ZtLWxrcC1uZXgwNC0yNjQxNS0yMDEzMDYyMjIyMTIzMy0zLjguMC02Nwpk
bWVzZy1rdm0tbGtwLXNieDA0LTIxOTQ3LTIwMTMwNjIzMDIxNTEwLTMuOC4wLTY3CmRtZXNn
LWt2bS1sa3Atc2J4MDQtMjMyMDgtMjAxMzA2MjMwMjE1MTQtMy44LjAtNjcKZG1lc2cta3Zt
LWxrcC1zYngwNC0yNDQ0NC0yMDEzMDYyMzAyMTQ0OS0zLjguMC02NwpkbWVzZy1rdm0tcm9h
bS0xNzQ1Ny0yMDEzMDYyMjIyMDk1OC0zLjguMC02NwpkbWVzZy1rdm0tbGtwLXNieDA0LTI4
Njg1LTIwMTMwNjIzMDIxNTA4LTMuOC4wLTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtNjM0NTct
MjAxMzA2MjIyMjEyMjgtMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1uZXgwNC02MzQ3LTIwMTMw
NjIyMjIxMjI4LTMuOC4wLTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtNjM3NTgtMjAxMzA2MjIy
MjEyMjgtMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1uZXgwNC02NDExMC0yMDEzMDYyMjIyMTIx
MS0zLjguMC02NwpkbWVzZy1rdm0tbGtwLXNieDA0LTQxNDk2LTIwMTMwNjIzMDIxNTEwLTMu
OC4wLTY3CmRtZXNnLWt2bS1sa3Atc2J4MDQtNDIzOTUtMjAxMzA2MjMwMjE0NDktMy44LjAt
NjcKZG1lc2cta3ZtLWxrcC1uZXgwNC0zMTc4OS0yMDEzMDYyMjIyMTIyOC0zLjguMC02Nwpk
bWVzZy1rdm0tbGtwLW5leDA0LTY2ODEtMjAxMzA2MjIyMjEyMTEtMy44LjAtNjcKZG1lc2ct
a3ZtLWxrcC1uZXgwNC02ODA2LTIwMTMwNjIyMjIxMjMxLTMuOC4wLTY3CmRtZXNnLWt2bS1s
a3AtbmV4MDQtNjkxMC0yMDEzMDYyMjIyMTIyOC0zLjguMC02NwpkbWVzZy1rdm0teGJtLTMz
NDgtMjAxMzA2MjIyMjEzNTMtMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1uZXgwNC03NjY0LTIw
MTMwNjIyMjIxMjI4LTMuOC4wLTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtODM2MS0yMDEzMDYy
MjIyMTIyOC0zLjguMC02NwpkbWVzZy1rdm0tbGtwLW5leDA0LTk0NDQtMjAxMzA2MjIyMjEy
MzctMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1zYngwNC01NDE2Mi0yMDEzMDYyMzAyMTUxMS0z
LjguMC02NwpkbWVzZy1rdm0tbGtwLW5leDA0LTM3NjcyLTIwMTMwNjIyMjIxMjMxLTMuOC4w
LTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtMzg2MjMtMjAxMzA2MjIyMjEyMjgtMy44LjAtNjcK
ZG1lc2cta3ZtLWxrcC1uZXgwNC0xMDI1MS0yMDEzMDYyMjIyMTIyOS0zLjguMC02NwpkbWVz
Zy1rdm0tbGtwLW5leDA0LTk2NjctMjAxMzA2MjIyMjEyMjgtMy44LjAtNjcKZG1lc2cta3Zt
LWxrcC1uZXgwNC05ODY3LTIwMTMwNjIyMjIxMjI4LTMuOC4wLTY3CmRtZXNnLWt2bS1sa3At
bmV4MDQtMTEyNTktMjAxMzA2MjIyMjEyMjgtMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1uZXgw
NC0xMjA5My0yMDEzMDYyMjIyMTIyOS0zLjguMC02NwpkbWVzZy1rdm0tbGtwLW5leDA0LTEz
MjUwLTIwMTMwNjIyMjIxMjM2LTMuOC4wLTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtMTM1NDQt
MjAxMzA2MjIyMjEyMjQtMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1zYngwNC0xMzE0NC0yMDEz
MDYyMzAyMTUwMy0zLjguMC02NwpkbWVzZy1rdm0tbGtwLW5leDA0LTEzODE4LTIwMTMwNjIy
MjIxMjI4LTMuOC4wLTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtNDUyOTAtMjAxMzA2MjIyMjEy
MjktMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1zYngwNC02MjAwNC0yMDEzMDYyMzAyMTUwMy0z
LjguMC02NwpkbWVzZy1rdm0tbGtwLXNieDA0LTEzOTkxLTIwMTMwNjIzMDIxNDQ5LTMuOC4w
LTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtMTUzNTMtMjAxMzA2MjIyMjEyMjgtMy44LjAtNjcK
ZG1lc2cta3ZtLWxrcC1uZXgwNC0xNjY4Mi0yMDEzMDYyMjIyMTIyNy0zLjguMC02NwpkbWVz
Zy1rdm0tbGtwLW5leDA0LTQ3NzYwLTIwMTMwNjIyMjIxMjMxLTMuOC4wLTY3CmRtZXNnLWt2
bS1sa3AtbmV4MDQtMTY5NzYtMjAxMzA2MjIyMjEyMTEtMy44LjAtNjcKZG1lc2cta3ZtLWxr
cC1zYngwNC03MjA1LTIwMTMwNjIzMDIxNTAzLTMuOC4wLTY3CmRtZXNnLWt2bS1sa3Atc2J4
MDQtMTQ4NTAtMjAxMzA2MjMwMjE1MDktMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1zYngwNC0x
ODIzOS0yMDEzMDYyMzAyMTQ1My0zLjguMC02NwpkbWVzZy1rdm0tbGtwLXNieDA0LTgyMjAt
MjAxMzA2MjMwMjE1MDMtMy44LjAtNjcKZG1lc2cta3ZtLWxrcC1zYngwNC0xOTUxMC0yMDEz
MDYyMzAyMTUwNS0zLjguMC02NwpkbWVzZy1rdm0tbGtwLW5leDA0LTUyNTk4LTIwMTMwNjIy
MjIxMjIwLTMuOC4wLTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtNTM5Mi0yMDEzMDYyMjIyMTIx
MS0zLjguMC02NwpkbWVzZy1rdm0tbGtwLW5leDA0LTU0MDM2LTIwMTMwNjIyMjIxMjI3LTMu
OC4wLTY3CmRtZXNnLWt2bS1sa3AtbmV4MDQtNTQzNi0yMDEzMDYyMjIyMTIyOC0zLjguMC02
NwpkbWVzZy1rdm0tYmF5LTE4OTc2LTIwMTMwNjIyMjIxMzI0LTMuOC4wLTY3CmRtZXNnLWt2
bS1sa3AtbmV4MDQtNTU3MDAtMjAxMzA2MjIyMjEyMzEtMy44LjAtNjcKZG1lc2cta3ZtLWJh
eS0yMDI2MC0yMDEzMDYyMjIyMTMyNS0zLjguMC02NwoKYmlzZWN0OiBiYWQgY29tbWl0IHYz
LjgKZ2l0IGNoZWNrb3V0IHYzLjcKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTlmOTQ5
Zi4uLiBMaW51eCAzLjgKSEVBRCBpcyBub3cgYXQgMjk1OTQ0MC4uLiBMaW51eCAzLjcKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0w
NjIwL2t2bTpxdWV1ZToyOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBl
OmJpc2VjdC1tbQoKMjAxMy0wNi0yMi0yMjoxMTo0NSAyOTU5NDQwNGQ3ZmU3M2NkODBlYWE0
ZWU4YzQzZGNjNTM5NzBjNjBlIGNvbXBpbGluZwoxOTIgcmVhbCAgMTY0NSB1c2VyICAxMjcg
c3lzICA5MjMuNzMlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAKCjIwMTMtMDYt
MjItMjI6MTU6MDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy43LjAuLi4gVEVTVCBGQUlMVVJF
CmRtZXNnLWt2bS1sa3AtbmV4MDQtMjI0NjktMjAxMzA2MjIyMjE3NDAtMy43LjAtNjgKZG1l
c2cta3ZtLWxrcC1uZXgwNC03MDMxLTIwMTMwNjIyMjIxNzQxLTMuNy4wLTY4CmRtZXNnLWt2
bS1iYXktMTg5NzYtMjAxMzA2MjIyMjE4MjAtMy43LjAtNjgKZG1lc2cta3ZtLWxrcC1uZXgw
NC03NDEyLTIwMTMwNjIyMjIxNzMxLTMuNy4wLTY4CmRtZXNnLWt2bS1sa3AtbmV4MDQtMjI4
NzgtMjAxMzA2MjIyMjE3MzktMy43LjAtNjgKZG1lc2cta3ZtLWxrcC1uZXgwNC03NTI3LTIw
MTMwNjIyMjIxNzQ0LTMuNy4wLTY4CmRtZXNnLWt2bS1sa3AtbmV4MDQtMjQzMDEtMjAxMzA2
MjIyMjE3NDQtMy43LjAtNjgKZG1lc2cta3ZtLWxrcC1uZXgwNC03NjY0LTIwMTMwNjIyMjIx
NzM4LTMuNy4wLTY4CmRtZXNnLWt2bS1sa3AtbmV4MDQtMjQ3MTMtMjAxMzA2MjIyMjE3Mjct
My43LjAtNjgKZG1lc2cta3ZtLWxrcC1uZXgwNC04MDg5LTIwMTMwNjIyMjIxNzM4LTMuNy4w
LTY4CmRtZXNnLWt2bS1sa3AtbmV4MDQtMjY0MTUtMjAxMzA2MjIyMjE3NDQtMy43LjAtNjgK
ZG1lc2cta3ZtLWxrcC1uZXgwNC04NTIzLTIwMTMwNjIyMjIxNzQwLTMuNy4wLTY4CmRtZXNn
LWt2bS1sa3AtbmV4MDQtMjY3NTktMjAxMzA2MjIyMjE3MzctMy43LjAtNjgKZG1lc2cta3Zt
LWxrcC1uZXgwNC05ODY3LTIwMTMwNjIyMjIxNzM5LTMuNy4wLTY4CmRtZXNnLWt2bS1sa3At
bmV4MDQtMjY5NS0yMDEzMDYyMjIyMTcyNi0zLjcuMC02OApkbWVzZy1rdm0tYmF5LTMxNDY3
LTIwMTMwNjIyMjIxODI1LTMuNy4wLTY4CmRtZXNnLWt2bS1sa3AtbmV4MDQtMjg4MzUtMjAx
MzA2MjIyMjE3NDQtMy43LjAtNjgKZG1lc2cta3ZtLWxrcC1uZXgwNC0zMDY2OC0yMDEzMDYy
MjIyMTczNy0zLjcuMC02OApkbWVzZy1rdm0tbGtwLW5leDA0LTMxNzg5LTIwMTMwNjIyMjIx
NzM2LTMuNy4wLTY4CmRtZXNnLWt2bS1sa3AtbmV4MDQtMzM2NzgtMjAxMzA2MjIyMjE3Mzgt
My43LjAtNjgKZG1lc2cta3ZtLWxrcC1uZXgwNC0zNTU5NC0yMDEzMDYyMjIyMTc0NC0zLjcu
MC02OApkbWVzZy1rdm0tbGtwLW5leDA0LTM2ODcyLTIwMTMwNjIyMjIxNzI0LTMuNy4wLTY4
CmRtZXNnLWt2bS1sa3AtbmV4MDQtMzcyNzAtMjAxMzA2MjIyMjE3NDEtMy43LjAtNjgKZG1l
c2cta3ZtLWxrcC1uZXgwNC0zODYyMy0yMDEzMDYyMjIyMTczOC0zLjcuMC02OApkbWVzZy1r
dm0tbGtwLW5leDA0LTM5NjI0LTIwMTMwNjIyMjIxNzM3LTMuNy4wLTY4CmRtZXNnLWt2bS1s
a3AtbmV4MDQtNDIwMzgtMjAxMzA2MjIyMjE3MjUtMy43LjAtNjgKZG1lc2cta3ZtLWxrcC1u
ZXgwNC00NDgyLTIwMTMwNjIyMjIxNzI0LTMuNy4wLTY4CmRtZXNnLWt2bS1sa3AtbmV4MDQt
NDUyOTAtMjAxMzA2MjIyMjE3NDItMy43LjAtNjgKZG1lc2cta3ZtLWxrcC1uZXgwNC00ODQx
NS0yMDEzMDYyMjIyMTcyOS0zLjcuMC02OApkbWVzZy1rdm0tbGtwLW5leDA0LTUwMDYtMjAx
MzA2MjIyMjE3NDAtMy43LjAtNjgKZG1lc2cta3ZtLWxrcC1uZXgwNC01MTE3My0yMDEzMDYy
MjIyMTcyNi0zLjcuMC02OApkbWVzZy1rdm0tbGtwLW5leDA0LTUxNjkxLTIwMTMwNjIyMjIx
NzM4LTMuNy4wLTY4CmRtZXNnLWt2bS1sa3AtbmV4MDQtNTU3MS0yMDEzMDYyMjIyMTc0Mi0z
LjcuMC02OApkbWVzZy1rdm0tbGtwLW5leDA0LTU4NzE2LTIwMTMwNjIyMjIxNzM5LTMuNy4w
LTY4CmRtZXNnLWt2bS1sa3AtbmV4MDQtNjA2NTktMjAxMzA2MjIyMjE3NDQtMy43LjAtNjgK
ZG1lc2cta3ZtLWxrcC1uZXgwNC02MzA5Mi0yMDEzMDYyMjIyMTcyNC0zLjcuMC02OApkbWVz
Zy1rdm0tbGtwLW5leDA0LTYzNDctMjAxMzA2MjIyMjE3MzctMy43LjAtNjgKZG1lc2cta3Zt
LWxrcC1uZXgwNC02NDQ0My0yMDEzMDYyMjIyMTc0NC0zLjcuMC02OApkbWVzZy1rdm0tbGtw
LW5leDA0LTY1MTYwLTIwMTMwNjIyMjIxNzQwLTMuNy4wLTY4CgpiaXNlY3Q6IGJhZCBjb21t
aXQgdjMuNwpnaXQgY2hlY2tvdXQgdjMuNgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAy
OTU5NDQwLi4uIExpbnV4IDMuNwpIRUFEIGlzIG5vdyBhdCBhMGQyNzFjLi4uIExpbnV4IDMu
NgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
eDA0LTA2MjAva3ZtOnF1ZXVlOmEwZDI3MWNiZmVkMWRkNTAyNzhjNmIwNmJlYWQzZDAwYmEw
YTg4Zjk6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIyOjE2OjQ2IGEwZDI3MWNiZmVkMWRkNTAy
NzhjNmIwNmJlYWQzZDAwYmEwYTg4ZjkgY29tcGlsaW5nCjE0NSByZWFsICAxNTU1IHVzZXIg
IDExNSBzeXMgIDExNTEuMzQlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAKCjIw
MTMtMDYtMjItMjI6MTk6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy42LjAuLi4uIFRFU1Qg
RkFJTFVSRQpkbWVzZy1rdm0tbGtwLW5leDA0LTMxMDE0LTIwMTMwNjIyMjIyMjAyLTMuNi4w
LTY5CmRtZXNnLWt2bS1sa3AtbmV4MDQtNzE1Mi0yMDEzMDYyMjIyMjIyNC0zLjYuMC02OQpk
bWVzZy1rdm0tbGtwLW5leDA0LTEzNTQ0LTIwMTMwNjIyMjIyMjE0LTMuNi4wLTY5CmRtZXNn
LWt2bS1sa3AtbmV4MDQtNzUyNy0yMDEzMDYyMjIyMjIyMS0zLjYuMC02OQpkbWVzZy1rdm0t
bGtwLW5leDA0LTc5NDQtMjAxMzA2MjIyMjIyMDMtMy42LjAtNjkKZG1lc2cta3ZtLWxrcC1z
YngwNC01NjQ1LTIwMTMwNjIzMDIyNTA4LTMuNi4wLTY5CmRtZXNnLWt2bS1sa3Atc2J4MDQt
NzUwNS0yMDEzMDYyMzAyMjQ1OC0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLXNieDA0LTc5NjIt
MjAxMzA2MjMwMjI1MDItMy42LjAtNjkKZG1lc2cta3ZtLWxrcC1zYngwNC01NzY1OS0yMDEz
MDYyMzAyMjQ1Ni0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLXNieDA0LTU3NjctMjAxMzA2MjMw
MjI1MDgtMy42LjAtNjkKZG1lc2cta3ZtLWxrcC1zYngwNC01OTU0OC0yMDEzMDYyMzAyMjQ1
OC0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLXNieDA0LTYwMDY4LTIwMTMwNjIzMDIyNDQ4LTMu
Ni4wLTY5CmRtZXNnLWt2bS1sa3Atc2J4MDQtNjA1NC0yMDEzMDYyMzAyMjQ0Ni0zLjYuMC02
OQpkbWVzZy1rdm0tbGtwLW5leDA0LTMzNDE5LTIwMTMwNjIyMjIyMjIzLTMuNi4wLTY5CmRt
ZXNnLWt2bS1sa3AtbmV4MDQtODc1My0yMDEzMDYyMjIyMjIyNC0zLjYuMC02OQpkbWVzZy1r
dm0tbGtwLW5leDA0LTE1OTk3LTIwMTMwNjIyMjIyMjIxLTMuNi4wLTY5CmRtZXNnLWt2bS1s
a3AtbmV4MDQtOTQ0NC0yMDEzMDYyMjIyMjIxOC0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLXNi
eDA0LTE2NTM3LTIwMTMwNjIzMDIyNDQzLTMuNi4wLTY5CmRtZXNnLWt2bS1sa3AtbmV4MDQt
MzcyNzAtMjAxMzA2MjIyMjIyMjEtMy42LjAtNjkKZG1lc2cta3ZtLWxrcC1zYngwNC0xMDI0
My0yMDEzMDYyMzAyMjQ1Ny0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLW5leDA0LTM4NjIzLTIw
MTMwNjIyMjIyMjIwLTMuNi4wLTY5CmRtZXNnLWt2bS1sa3AtbmV4MDQtNTQzNi0yMDEzMDYy
MjIyMjIwNS0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLW5leDA0LTE2NjgyLTIwMTMwNjIyMjIy
MjIxLTMuNi4wLTY5CmRtZXNnLWt2bS1sa3AtbmV4MDQtMzk2MjQtMjAxMzA2MjIyMjIyMjAt
My42LjAtNjkKZG1lc2cta3ZtLWxrcC1uZXgwNC00MDE3Ny0yMDEzMDYyMjIyMjIyNC0zLjYu
MC02OQpkbWVzZy1rdm0tbGtwLW5leDA0LTU3NTEtMjAxMzA2MjIyMjIyMDItMy42LjAtNjkK
ZG1lc2cta3ZtLWxrcC1zYngwNC02NDg2Ny0yMDEzMDYyMzAyMjUwMy0zLjYuMC02OQpkbWVz
Zy1rdm0tbGtwLXNieDA0LTE5MjAwLTIwMTMwNjIzMDIyNDU3LTMuNi4wLTY5CmRtZXNnLWt2
bS1sa3Atc2J4MDQtMTk1MTAtMjAxMzA2MjMwMjI0NDgtMy42LjAtNjkKZG1lc2cta3ZtLWxr
cC1uZXgwNC01ODMyOC0yMDEzMDYyMjIyMjIyMC0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLW5l
eDA0LTE5MzM0LTIwMTMwNjIyMjIyMjE4LTMuNi4wLTY5CmRtZXNnLWt2bS1sa3AtbmV4MDQt
MTk2NjItMjAxMzA2MjIyMjIyMjEtMy42LjAtNjkKZG1lc2cta3ZtLWxrcC1uZXgwNC0yMDAz
MC0yMDEzMDYyMjIyMjIxNi0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLW5leDA0LTQxNTc0LTIw
MTMwNjIyMjIyMjEzLTMuNi4wLTY5CmRtZXNnLWt2bS1sa3AtbmV4MDQtMjA5MTktMjAxMzA2
MjIyMjIyMTAtMy42LjAtNjkKZG1lc2cta3ZtLWxrcC1zYngwNC0xMTQ0OS0yMDEzMDYyMzAy
MjUwNy0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLXNieDA0LTIxMDgzLTIwMTMwNjIzMDIyNTAy
LTMuNi4wLTY5CmRtZXNnLWt2bS1sa3AtbmV4MDQtMTA0MTQtMjAxMzA2MjIyMjIyMjEtMy42
LjAtNjkKZG1lc2cta3ZtLWxrcC1zYngwNC0yMjE5LTIwMTMwNjIzMDIyNTAzLTMuNi4wLTY5
CmRtZXNnLWt2bS1sa3AtbmV4MDQtNDU3ODAtMjAxMzA2MjIyMjIyMDYtMy42LjAtNjkKZG1l
c2cta3ZtLWxrcC1uZXgwNC02MDQyLTIwMTMwNjIyMjIyMjA0LTMuNi4wLTY5CmRtZXNnLWt2
bS1sa3AtbmV4MDQtMTEyNTktMjAxMzA2MjIyMjIyMjEtMy42LjAtNjkKZG1lc2cta3ZtLWxr
cC1uZXgwNC02MTAzNS0yMDEzMDYyMjIyMjIxOS0zLjYuMC02OQpkbWVzZy1rdm0tbGtwLXNi
eDA0LTIyNjI0LTIwMTMwNjIzMDIyNTAyLTMuNi4wLTY5CmRtZXNnLWt2bS1sa3AtbmV4MDQt
NjM0Ny0yMDEzMDYyMjIyMjIyMS0zLjYuMC02OQpkbWVzZy1rdm0tYmF5LTE4OTc2LTIwMTMw
NjIyMjIyMjQ3LTMuNi4wLTY5CmRtZXNnLWt2bS1iYXktMjAyMjEtMjAxMzA2MjIyMjIyNTUt
My42LjAtNjkKZG1lc2cta3ZtLWxrcC1uZXgwNC02NDQ0My0yMDEzMDYyMjIyMjIyMS0zLjYu
MC02OQpkbWVzZy1rdm0tbGtwLXNieDA0LTMzNTk0LTIwMTMwNjIzMDIyNDQ3LTMuNi4wLTY5
CmRtZXNnLWt2bS1sa3AtbmV4MDQtMjI0NjktMjAxMzA2MjIyMjIyMjAtMy42LjAtNjkKZG1l
c2cta3ZtLWxrcC1zYngwNC0zNTAzNC0yMDEzMDYyMzAyMjUwMS0zLjYuMC02OQpkbWVzZy1r
dm0tbGtwLW5leDA0LTIzNjQ1LTIwMTMwNjIyMjIyMjAzLTMuNi4wLTY5CmRtZXNnLWt2bS1s
a3AtbmV4MDQtNjkxMC0yMDEzMDYyMjIyMjIxOS0zLjYuMC02OQoKYmlzZWN0OiBiYWQgY29t
bWl0IHYzLjYKZ2l0IGNoZWNrb3V0IHYzLjUKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMg
YTBkMjcxYy4uLiBMaW51eCAzLjYKSEVBRCBpcyBub3cgYXQgMjhhMzNjYi4uLiBMaW51eCAz
LjUKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXgwNC0wNjIwL2t2bTpxdWV1ZToyOGEzM2NiYzI0ZTQyNTZjMTQzZGNlOTZjN2Q5M2JmNDIz
MjI5ZjkyOmJpc2VjdC1tbQoKMjAxMy0wNi0yMi0yMjoyMTozMyAyOGEzM2NiYzI0ZTQyNTZj
MTQzZGNlOTZjN2Q5M2JmNDIzMjI5ZjkyIGNvbXBpbGluZwoxMzcgcmVhbCAgMTUyMiB1c2Vy
ICAxMTYgc3lzICAxMTkyLjY1JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwCgoy
MDEzLTA2LTIyLTIyOjI0OjAzIGRldGVjdGluZyBib290IHN0YXRlIDMuNS4wLi4uIFRFU1Qg
RkFJTFVSRQpkbWVzZy1rdm0teGJtLTMyMzM3LTIwMTMwNjIyMjIyNzQ4LTMuNS4wLTcwCmRt
ZXNnLWt2bS1sa3AtbmV4MDQtMTE0NTQtMjAxMzA2MjIyMjI2MjYtMy41LjAtNzAKZG1lc2ct
a3ZtLWxrcC1uZXgwNC0xOTMzNC0yMDEzMDYyMjIyMjYyNi0zLjUuMC03MApkbWVzZy1rdm0t
bGtwLW5leDA0LTE5NjYyLTIwMTMwNjIyMjIyNjI4LTMuNS4wLTcwCmRtZXNnLWt2bS1sa3At
bmV4MDQtNDAxNzctMjAxMzA2MjIyMjI2MjktMy41LjAtNzAKZG1lc2cta3ZtLWxrcC1uZXgw
NC01MDE0Mi0yMDEzMDYyMjIyMjYyOS0zLjUuMC03MApkbWVzZy1rdm0tbGtwLW5leDA0LTU3
NTEtMjAxMzA2MjIyMjI2MjgtMy41LjAtNzAKZG1lc2cta3ZtLXJvYW0tMjM3NTMtMjAxMzA2
MjIyMjI0MDQtMy41LjAtNzAKZG1lc2cta3ZtLWxrcC1uZXgwNC02NDQ0My0yMDEzMDYyMjIy
MjYyOC0zLjUuMC03MApkbWVzZy1rdm0tbGtwLW5leDA0LTgyMTYtMjAxMzA2MjIyMjI2MjEt
My41LjAtNzAKZG1lc2cta3ZtLWxrcC1uZXgwNC05MTE3LTIwMTMwNjIyMjIyNjI5LTMuNS4w
LTcwCmRtZXNnLWt2bS1sa3Atc2J4MDQtMTE0NDktMjAxMzA2MjMwMjI5MDctMy41LjAtNzAK
ZG1lc2cta3ZtLXN0b2FrbGV5LTU2MTktMjAxMzA2MjIyMjI0NDgtMy41LjAtNzAKZG1lc2ct
a3ZtLWxrcC1zYngwNC0xNzkwNy0yMDEzMDYyMzAyMjkwNy0zLjUuMC03MApkbWVzZy1rdm0t
bGtwLXNieDA0LTIyNjI0LTIwMTMwNjIzMDIyOTA5LTMuNS4wLTcwCmRtZXNnLWt2bS1sa3At
c2J4MDQtMzgxMDEtMjAxMzA2MjMwMjI5MTItMy41LjAtNzAKZG1lc2cta3ZtLXJvYW0tMTMw
NDUtMjAxMzA2MjIyMjI0MDItMy41LjAtNzAKCmJpc2VjdDogYmFkIGNvbW1pdCB2My41Cmdp
dCBjaGVja291dCB2My40ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDI4YTMzY2IuLi4g
TGludXggMy41CkhFQUQgaXMgbm93IGF0IDc2ZTEwZDEuLi4gTGludXggMy40CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC9r
dm06cXVldWU6NzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYzpiaXNl
Y3QtbW0KCjIwMTMtMDYtMjItMjI6MjU6NDAgNzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYw
YzJhYjU1MDE5MDBiYyBjb21waWxpbmcKMTQwIHJlYWwgIDE0NjkgdXNlciAgMTExIHN5cyAg
MTEyMy4zNCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMAoKMjAxMy0wNi0yMi0y
MjoyODowOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjQuMC4uIFRFU1QgRkFJTFVSRQpkbWVz
Zy1rdm0teGJtLTMyNjc2LTIwMTMwNjIyMjIzMjAwLTMuNC4wLTcxCgpiaXNlY3Q6IGJhZCBj
b21taXQgdjMuNApnaXQgY2hlY2tvdXQgdjMuMwpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyA3NmUxMGQxLi4uIExpbnV4IDMuNApIRUFEIGlzIG5vdyBhdCBjMTZmYTRmLi4uIExpbnV4
IDMuMwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWcteDA0LTA2MjAva3ZtOnF1ZXVlOmMxNmZhNGYyYWQxOTkwOGE0N2M2M2Q4ZmE0MzZhMTE3
ODQzOGM3ZTc6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIyOjI5OjE0IGMxNmZhNGYyYWQxOTkw
OGE0N2M2M2Q4ZmE0MzZhMTE3ODQzOGM3ZTcgY29tcGlsaW5nCjEzNiByZWFsICAxNDcyIHVz
ZXIgIDExMiBzeXMgIDExNTguMTUlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAK
CjIwMTMtMDYtMjItMjI6MzE6NDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4zLjAuLi4gVEVT
VCBGQUlMVVJFCmRtZXNnLWt2bS1yb2FtLTk2MC0yMDEzMDYyMjIyMzE1Mi0zLjMuMC03Mgpk
bWVzZy1rdm0tbGtwLW5leDA0LTIxNzMxLTIwMTMwNjIyMjIzNDE1LTMuMy4wLTcyCmRtZXNn
LWt2bS1sa3AtbmV4MDQtMjI4NzgtMjAxMzA2MjIyMjM0MTktMy4zLjAtNzIKZG1lc2cta3Zt
LWxrcC1uZXgwNC0yNDcxMy0yMDEzMDYyMjIyMzQxNC0zLjMuMC03MgpkbWVzZy1rdm0tbGtw
LW5leDA0LTM5NjI0LTIwMTMwNjIyMjIzNDIzLTMuMy4wLTcyCmRtZXNnLWt2bS1sa3AtbmV4
MDQtNDk0NDMtMjAxMzA2MjIyMjM0MDgtMy4zLjAtNzIKZG1lc2cta3ZtLWxrcC1uZXgwNC01
NDkxMy0yMDEzMDYyMjIyMzQxOS0zLjMuMC03MgpkbWVzZy1rdm0tbGtwLW5leDA0LTYwNDIt
MjAxMzA2MjIyMjM0MTktMy4zLjAtNzIKZG1lc2cta3ZtLWxrcC1zYngwNC0xMDgyMC0yMDEz
MDYyMzAyMzcwNS0zLjMuMC03MgpkbWVzZy1rdm0tbGtwLXNieDA0LTEzNzA1LTIwMTMwNjIz
MDIzNzA3LTMuMy4wLTcyCmRtZXNnLWt2bS1sa3Atc2J4MDQtMTgyMzktMjAxMzA2MjMwMjM2
NTYtMy4zLjAtNzIKZG1lc2cta3ZtLWxrcC1zYngwNC0yMTk0Ny0yMDEzMDYyMzAyMzcxMC0z
LjMuMC03MgpkbWVzZy1rdm0tbGtwLXNieDA0LTIzMjA4LTIwMTMwNjIzMDIzNzA3LTMuMy4w
LTcyCmRtZXNnLWt2bS1sa3Atc2J4MDQtMjQ0NDQtMjAxMzA2MjMwMjM3MDYtMy4zLjAtNzIK
ZG1lc2cta3ZtLWxrcC1zYngwNC0yNjgxOC0yMDEzMDYyMzAyMzY1Ni0zLjMuMC03MgoKYmlz
ZWN0OiBiYWQgY29tbWl0IHYzLjMKZ2l0IGNoZWNrb3V0IHYzLjIKUHJldmlvdXMgSEVBRCBw
b3NpdGlvbiB3YXMgYzE2ZmE0Zi4uLiBMaW51eCAzLjMKSEVBRCBpcyBub3cgYXQgODA1YTZh
Zi4uLiBMaW51eCAzLjIKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTo4MDVhNmFmOGRiYTVkZmRkMzVlYzM1
ZGM1MmVjMDEyMjQwMGIyNjEwOmJpc2VjdC1tbQoKMjAxMy0wNi0yMi0yMjozMzoxNyA4MDVh
NmFmOGRiYTVkZmRkMzVlYzM1ZGM1MmVjMDEyMjQwMGIyNjEwIGNvbXBpbGluZwoxMjcgcmVh
bCAgMTM3NCB1c2VyICAxMTAgc3lzICAxMTY1Ljc4JSBjcHUgCXg4Nl82NC1yYW5kY29uZmln
LXgwNC0wNjIwCgoyMDEzLTA2LTIyLTIyOjM1OjM3IGRldGVjdGluZyBib290IHN0YXRlIDMu
Mi4wLi4uIFRFU1QgRkFJTFVSRQpkbWVzZy1rdm0tbGtwLXNieDA0LTExODM4LTIwMTMwNjIz
MDI0MDM2LTMuMi4wLTczCmRtZXNnLWt2bS1sa3Atc2J4MDQtODA4Ny0yMDEzMDYyMzAyNDAz
Ny0zLjIuMC03MwpkbWVzZy1rdm0tbGtwLXNieDA0LTExODc1LTIwMTMwNjIzMDI0MDM2LTMu
Mi4wLTczCmRtZXNnLWt2bS1sa3Atc2J4MDQtODg0MS0yMDEzMDYyMzAyNDAzNi0zLjIuMC03
MwpkbWVzZy1rdm0tbGtwLXNieDA0LTkyMTItMjAxMzA2MjMwMjQwMzctMy4yLjAtNzMKZG1l
c2cta3ZtLWxrcC1zYngwNC0xMjIyMS0yMDEzMDYyMzAyNDAzNi0zLjIuMC03MwpkbWVzZy1r
dm0tbGtwLXNieDA0LTE0MjU5LTIwMTMwNjIzMDI0MDM0LTMuMi4wLTczCmRtZXNnLWt2bS1s
a3Atc2J4MDQtMTU1MTUtMjAxMzA2MjMwMjQwMzYtMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1z
YngwNC0xNjgyNy0yMDEzMDYyMzAyNDA0Mi0zLjIuMC03MwpkbWVzZy1rdm0tbGtwLXNieDA0
LTE5NTEwLTIwMTMwNjIzMDI0MDM1LTMuMi4wLTczCmRtZXNnLWt2bS1sa3Atc2J4MDQtMjM5
OTgtMjAxMzA2MjMwMjQwMzYtMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1zYngwNC0yODY4NS0y
MDEzMDYyMzAyNDAzNS0zLjIuMC03MwpkbWVzZy1rdm0tbGtwLXNieDA0LTI5MTY0LTIwMTMw
NjIzMDI0MDM2LTMuMi4wLTczCmRtZXNnLWt2bS1sa3Atc2J4MDQtMjk4MzMtMjAxMzA2MjMw
MjQwMzQtMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1zYngwNC0zMDQzMC0yMDEzMDYyMzAyNDAz
NS0zLjIuMC03MwpkbWVzZy1rdm0tYmF5LTIwMjIxLTIwMTMwNjIyMjIzOTAwLTMuMi4wLTcz
CmRtZXNnLWt2bS1sa3Atc2J4MDQtMzI5MjgtMjAxMzA2MjMwMjQwMzQtMy4yLjAtNzMKZG1l
c2cta3ZtLWJheS0zMTQ2Ny0yMDEzMDYyMjIyMzkwMC0zLjIuMC03MwpkbWVzZy1rdm0tbGtw
LXNieDA0LTM0MDQzLTIwMTMwNjIzMDI0MDM2LTMuMi4wLTczCmRtZXNnLWt2bS1sa3Atc2J4
MDQtMzU0NDgtMjAxMzA2MjMwMjQwMzctMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1zYngwNC0z
NTk2MC0yMDEzMDYyMzAyNDAzMy0zLjIuMC03MwpkbWVzZy1rdm0taW5uLTE5MjgwLTIwMTMw
NjIyMjIzNjI5LTMuMi4wLTczCmRtZXNnLWt2bS1pbm4tMjM4MDctMjAxMzA2MjIyMjM2MjYt
My4yLjAtNzMKZG1lc2cta3ZtLWxrcC1zYngwNC0zNzA2Ni0yMDEzMDYyMzAyNDAzNS0zLjIu
MC03MwpkbWVzZy1rdm0taW5uLTI1MTAwLTIwMTMwNjIyMjIzNjI2LTMuMi4wLTczCmRtZXNn
LWt2bS1sa3Atc2J4MDQtMzg2NjctMjAxMzA2MjMwMjQwMzMtMy4yLjAtNzMKZG1lc2cta3Zt
LWlubi0zNzg1LTIwMTMwNjIyMjIzNjM1LTMuMi4wLTczCmRtZXNnLWt2bS1sa3Atc2J4MDQt
NDM5NDgtMjAxMzA2MjMwMjQwMzUtMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1zYngwNC00NTk2
My0yMDEzMDYyMzAyNDAzNy0zLjIuMC03MwpkbWVzZy1rdm0tbGtwLXNieDA0LTQ2NjIwLTIw
MTMwNjIzMDI0MDM2LTMuMi4wLTczCmRtZXNnLWt2bS1sa3Atc2J4MDQtNTIyNi0yMDEzMDYy
MzAyNDAzNC0zLjIuMC03MwpkbWVzZy1rdm0tbGtwLXNieDA0LTUzMTYtMjAxMzA2MjMwMjQw
MzctMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1zYngwNC01OTU0OC0yMDEzMDYyMzAyNDAzNC0z
LjIuMC03MwpkbWVzZy1rdm0tbGtwLXNieDA0LTYwNzYxLTIwMTMwNjIzMDI0MDMzLTMuMi4w
LTczCmRtZXNnLWt2bS1sa3Atc2J4MDQtNjI2MTktMjAxMzA2MjMwMjQwNDEtMy4yLjAtNzMK
ZG1lc2cta3ZtLWxrcC1zYngwNC02MzI2NC0yMDEzMDYyMzAyNDAzNS0zLjIuMC03MwpkbWVz
Zy1rdm0taW5uLTUxMzUyLTIwMTMwNjIyMjIzNjI2LTMuMi4wLTczCmRtZXNnLWt2bS1pbm4t
NTIwOTYtMjAxMzA2MjIyMjM2MjctMy4yLjAtNzMKZG1lc2cta3ZtLWlubi01MjcwOS0yMDEz
MDYyMjIyMzYyNi0zLjIuMC03MwpkbWVzZy1rdm0taW5uLTU5NjEzLTIwMTMwNjIyMjIzNjM0
LTMuMi4wLTczCmRtZXNnLWt2bS14Ym0tMzI2NzctMjAxMzA2MjIyMjM5MTctMy4yLjAtNzMK
ZG1lc2cta3ZtLXhibS0zMjY4MC0yMDEzMDYyMjIyMzkxNy0zLjIuMC03MwpkbWVzZy1rdm0t
eGJtLTM0MzAtMjAxMzA2MjIyMjM5MTYtMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1zYngwNC03
NDg2LTIwMTMwNjIzMDI0MDM1LTMuMi4wLTczCmRtZXNnLWt2bS1sa3Atc2J4MDQtNzUwNS0y
MDEzMDYyMzAyNDAzNy0zLjIuMC03MwpkbWVzZy1rdm0tbGtwLXNieDA0LTc5NzktMjAxMzA2
MjMwMjQwMzMtMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1uZXgwNC0xODM3OC0yMDEzMDYyMjIy
Mzc1Mi0zLjIuMC03MwpkbWVzZy1rdm0tbGtwLW5leDA0LTE4OTQ0LTIwMTMwNjIyMjIzNzUz
LTMuMi4wLTczCmRtZXNnLWt2bS1sa3AtbmV4MDQtMjY0MTUtMjAxMzA2MjIyMjM3NTEtMy4y
LjAtNzMKZG1lc2cta3ZtLWxrcC1uZXgwNC0zMDIxMC0yMDEzMDYyMjIyMzc1Mi0zLjIuMC03
MwpkbWVzZy1rdm0tbGtwLW5leDA0LTM1OTM3LTIwMTMwNjIyMjIzNzUyLTMuMi4wLTczCmRt
ZXNnLWt2bS1sa3AtbmV4MDQtNDY4MzQtMjAxMzA2MjIyMjM3NTItMy4yLjAtNzMKZG1lc2ct
a3ZtLWxrcC1uZXgwNC01MDA2LTIwMTMwNjIyMjIzNzUzLTMuMi4wLTczCmRtZXNnLWt2bS1s
a3AtbmV4MDQtNTgzMjgtMjAxMzA2MjIyMjM3NTgtMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1u
ZXgwNC01ODcxNi0yMDEzMDYyMjIyMzc1My0zLjIuMC03MwpkbWVzZy1rdm0tbGtwLW5leDA0
LTYxMDM1LTIwMTMwNjIyMjIzNzUzLTMuMi4wLTczCmRtZXNnLWt2bS1sa3AtbmV4MDQtNjE3
NTEtMjAxMzA2MjIyMjM3NTEtMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1uZXgwNC02NDExMC0y
MDEzMDYyMjIyMzc1Ni0zLjIuMC03MwpkbWVzZy1rdm0tbGtwLW5leDA0LTg1MjMtMjAxMzA2
MjIyMjM3NTMtMy4yLjAtNzMKZG1lc2cta3ZtLWxrcC1zYngwNC0xMDA4Ni0yMDEzMDYyMzAy
NDAzNS0zLjIuMC03MwoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjIKZ2l0IGNoZWNrb3V0IHYz
LjEKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgODA1YTZhZi4uLiBMaW51eCAzLjIKSEVB
RCBpcyBub3cgYXQgYzNiOTJjOC4uLiBMaW51eCAzLjEKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTpjM2I5
MmM4Nzg3MzY3YThiYjUzZDU3ZDk3ODliNTU4ZjEyOTVjYzk2OmJpc2VjdC1tbQoKMjAxMy0w
Ni0yMi0yMjozNzoxMiBjM2I5MmM4Nzg3MzY3YThiYjUzZDU3ZDk3ODliNTU4ZjEyOTVjYzk2
IGNvbXBpbGluZwoxMjYgcmVhbCAgMTMyMSB1c2VyICA5OSBzeXMgIDExMjAuMTklIGNwdSAJ
eDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAKCjIwMTMtMDYtMjItMjI6Mzk6MzEgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xLjAuLiBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLXZwLTE1ODgz
LTIwMTMwNjIyMjI0MTU3LTMuMS4wLTc0CgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMQpnaXQg
Y2hlY2tvdXQgdjMuMApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBjM2I5MmM4Li4uIExp
bnV4IDMuMQpIRUFEIGlzIG5vdyBhdCAwMmY4YzZhLi4uIExpbnV4IDMuMApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAva3Zt
OnF1ZXVlOjAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVkYmU6YmlzZWN0
LW1tCgoyMDEzLTA2LTIyLTIyOjQwOjM1IDAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQw
MjAzMDYwMzVkYmUgY29tcGlsaW5nCjEyOCByZWFsICAxMjkyIHVzZXIgIDEwMSBzeXMgIDEw
ODIuNjUlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAKCjIwMTMtMDYtMjItMjI6
NDI6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4wLjAuLi4gVEVTVCBGQUlMVVJFCmRtZXNn
LWt2bS1rYnVpbGQtNTc2MzYtMjAxMzA2MjIyMjM5MDUtMy4wLjAtNzUKZG1lc2cta3ZtLWti
dWlsZC02MTAwNi0yMDEzMDYyMjIyMzkwNS0zLjAuMC03NQoKYmlzZWN0OiBiYWQgY29tbWl0
IHYzLjAKZ2l0IGNoZWNrb3V0IHYyLjYuMzkKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMg
MDJmOGM2YS4uLiBMaW51eCAzLjAKSEVBRCBpcyBub3cgYXQgNjFjNGYyYy4uLiBMaW51eCAy
LjYuMzkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTo2MWM0ZjJjODFjNjFmNzM1NDk5MjhkZmQ5ZjNlOGYy
NmFhMzZhOGNmOmJpc2VjdC1tbQoKMjAxMy0wNi0yMi0yMjo0NDozMiA2MWM0ZjJjODFjNjFm
NzM1NDk5MjhkZmQ5ZjNlOGYyNmFhMzZhOGNmIGNvbXBpbGluZwoxMTggcmVhbCAgMTIyNSB1
c2VyICA5NyBzeXMgIDExMTYuMTAlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAK
CjIwMTMtMDYtMjItMjI6NDY6NDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMi42LjM5Li4uIFRF
U1QgRkFJTFVSRQpkbWVzZy1rdm0tcm9hbS00NzEyLTIwMTMwNjIyMjI0NjMwLTIuNi4zOS03
NgpkbWVzZy1rdm0tbGtwLW5leDA0LTYzNDU3LTIwMTMwNjIyMjI0ODUzLTIuNi4zOS03Ngpk
bWVzZy1rdm0tbGtwLW5leDA0LTYzNDctMjAxMzA2MjIyMjQ5MDQtMi42LjM5LTc2CmRtZXNn
LWt2bS1sa3AtbmV4MDQtMzY0NDAtMjAxMzA2MjIyMjQ4NTItMi42LjM5LTc2CmRtZXNnLWt2
bS1sa3AtbmV4MDQtMTA1ODktMjAxMzA2MjIyMjQ4NTYtMi42LjM5LTc2CmRtZXNnLWt2bS1s
a3Atc2J4MDQtMzA3OTUtMjAxMzA2MjMwMjUxNDItMi42LjM5LTc2CmRtZXNnLWt2bS1sa3At
bmV4MDQtMzc2NzItMjAxMzA2MjIyMjQ4NTQtMi42LjM5LTc2CmRtZXNnLWt2bS1sa3AtbmV4
MDQtMzgwNTUtMjAxMzA2MjIyMjQ4NTgtMi42LjM5LTc2CmRtZXNnLWt2bS1sa3AtbmV4MDQt
MTE0NTQtMjAxMzA2MjIyMjQ4NTYtMi42LjM5LTc2CmRtZXNnLWt2bS1yb2FtLTcyOC0yMDEz
MDYyMjIyNDYzNi0yLjYuMzktNzYKZG1lc2cta3ZtLWxrcC1zYngwNC00ODI3OS0yMDEzMDYy
MzAyNTE0MS0yLjYuMzktNzYKZG1lc2cta3ZtLWxrcC1uZXgwNC02NTE2MC0yMDEzMDYyMjIy
NDg1Mi0yLjYuMzktNzYKZG1lc2cta3ZtLWxrcC1uZXgwNC0zODQ0LTIwMTMwNjIyMjI0ODU4
LTIuNi4zOS03NgpkbWVzZy1rdm0tbGtwLW5leDA0LTEzNTQ0LTIwMTMwNjIyMjI0ODUzLTIu
Ni4zOS03NgpkbWVzZy1rdm0tbGtwLW5leDA0LTE0NjM4LTIwMTMwNjIyMjI0ODUzLTIuNi4z
OS03NgpkbWVzZy1rdm0tbGtwLW5leDA0LTE0OTk1LTIwMTMwNjIyMjI0ODU2LTIuNi4zOS03
NgpkbWVzZy1rdm0tbGtwLXNieDA0LTYwOTYtMjAxMzA2MjMwMjUxMzQtMi42LjM5LTc2CmRt
ZXNnLWt2bS1sa3AtbmV4MDQtNjkxMC0yMDEzMDYyMjIyNDg1Mi0yLjYuMzktNzYKZG1lc2ct
a3ZtLWxrcC1zYngwNC0xMDM5NC0yMDEzMDYyMzAyNTEzNS0yLjYuMzktNzYKZG1lc2cta3Zt
LWxrcC1zYngwNC0xMDk4NC0yMDEzMDYyMzAyNTE0MS0yLjYuMzktNzYKZG1lc2cta3ZtLWxr
cC1zYngwNC02MjAwNC0yMDEzMDYyMzAyNTE0My0yLjYuMzktNzYKZG1lc2cta3ZtLWxrcC1z
YngwNC02NDg2Ny0yMDEzMDYyMzAyNTE0MC0yLjYuMzktNzYKZG1lc2cta3ZtLWxrcC1zYngw
NC02NzMxLTIwMTMwNjIzMDI1MTM5LTIuNi4zOS03NgpkbWVzZy1rdm0tbGtwLXNieDA0LTgz
ODItMjAxMzA2MjMwMjUxMzgtMi42LjM5LTc2CmRtZXNnLWt2bS1sa3Atc2J4MDQtOTE3MS0y
MDEzMDYyMzAyNTEzNi0yLjYuMzktNzYKZG1lc2cta3ZtLWxrcC1zYngwNC0xMjc4NS0yMDEz
MDYyMzAyNTE0MS0yLjYuMzktNzYKZG1lc2cta3ZtLWxrcC1zYngwNC0xMjk3Mi0yMDEzMDYy
MzAyNTE0My0yLjYuMzktNzYKZG1lc2cta3ZtLWJheS0yMDIyMS0yMDEzMDYyMjIyNDk0OC0y
LjYuMzktNzYKZG1lc2cta3ZtLWxrcC1uZXgwNC0xNzk1Ni0yMDEzMDYyMjIyNDg1Mi0yLjYu
MzktNzYKZG1lc2cta3ZtLWxrcC1uZXgwNC0xOTMzNC0yMDEzMDYyMjIyNDg1MS0yLjYuMzkt
NzYKZG1lc2cta3ZtLWxrcC1uZXgwNC0yMDkxOS0yMDEzMDYyMjIyNDg1OS0yLjYuMzktNzYK
ZG1lc2cta3ZtLWxrcC1uZXgwNC00NDc4Ni0yMDEzMDYyMjIyNDg1My0yLjYuMzktNzYKZG1l
c2cta3ZtLWxrcC1uZXgwNC00NDgyLTIwMTMwNjIyMjI0ODUyLTIuNi4zOS03NgpkbWVzZy1r
dm0teGJtLTMyMzQ0LTIwMTMwNjIyMjI1MDEyLTIuNi4zOS03NgpkbWVzZy1rdm0teGJtLTMy
Njc3LTIwMTMwNjIyMjI1MDExLTIuNi4zOS03NgpkbWVzZy1rdm0tbGtwLW5leDA0LTQ3MzQ0
LTIwMTMwNjIyMjI0ODUzLTIuNi4zOS03NgpkbWVzZy1rdm0tbGtwLW5leDA0LTQ4NDE1LTIw
MTMwNjIyMjI0ODUxLTIuNi4zOS03NgpkbWVzZy1rdm0tbGtwLW5leDA0LTIyNDY5LTIwMTMw
NjIyMjI0ODUxLTIuNi4zOS03NgpkbWVzZy1rdm0tbGtwLW5leDA0LTQ5NDQzLTIwMTMwNjIy
MjI0ODU4LTIuNi4zOS03NgpkbWVzZy1rdm0tbGtwLXNieDA0LTE2ODI3LTIwMTMwNjIzMDI1
MTM5LTIuNi4zOS03NgpkbWVzZy1rdm0tbGtwLXNieDA0LTE3NDE2LTIwMTMwNjIzMDI1MTM5
LTIuNi4zOS03NgpkbWVzZy1rdm0tbGtwLXNieDA0LTE4ODQ2LTIwMTMwNjIzMDI1MTQzLTIu
Ni4zOS03NgpkbWVzZy1rdm0tbGtwLW5leDA0LTUwMDYtMjAxMzA2MjIyMjQ4NTMtMi42LjM5
LTc2CgpiaXNlY3Q6IGJhZCBjb21taXQgdjIuNi4zOQpnaXQgY2hlY2tvdXQgdjIuNi4zOApQ
cmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA2MWM0ZjJjLi4uIExpbnV4IDIuNi4zOQpIRUFE
IGlzIG5vdyBhdCA1MjFjYjQwLi4uIExpbnV4IDIuNi4zOApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAva3ZtOnF1ZXVlOjUy
MWNiNDBiMGM0NDQxOGE0ZmQzNmRjNjMzZjU3NTgxM2Q1OWE0M2Q6YmlzZWN0LW1tCgoyMDEz
LTA2LTIyLTIyOjQ4OjIwIDUyMWNiNDBiMGM0NDQxOGE0ZmQzNmRjNjMzZjU3NTgxM2Q1OWE0
M2QgY29tcGlsaW5nCjk3IHJlYWwgIDExNDggdXNlciAgODUgc3lzICAxMjYwLjA5JSBjcHUg
CXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwCjIwMTMtMDYtMjItMjI6NTA6MDcgNTIxY2I0
MGIwYzQ0NDE4YTRmZDM2ZGM2MzNmNTc1ODEzZDU5YTQzZCBTS0lQIEJST0tFTiBCVUlMRApD
aGVjayBlcnJvcyBpbiAvY2Mvd2ZnL21tLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWcteDA0LTA2MjAvNTIxY2I0MGIwYzQ0NDE4YTRmZDM2ZGM2MzNmNTc1ODEz
ZDU5YTQzZApiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM4CmdpdCBjaGVj
a291dCB2Mi42LjM3ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDUyMWNiNDAuLi4gTGlu
dXggMi42LjM4CkhFQUQgaXMgbm93IGF0IDNjMGVlZTMuLi4gTGludXggMi42LjM3CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYy
MC9rdm06cXVldWU6M2MwZWVlM2ZlNmEzYTFjNzQ1Mzc5NTQ3YzdlN2M5MDRhYTY0ZjZkNTpi
aXNlY3QtbW0KCjIwMTMtMDYtMjItMjI6NTA6MTQgM2MwZWVlM2ZlNmEzYTFjNzQ1Mzc5NTQ3
YzdlN2M5MDRhYTY0ZjZkNSBjb21waWxpbmcKOTYgcmVhbCAgMTE0NiB1c2VyICA4MiBzeXMg
IDEyNzQuMTElIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAKMjAxMy0wNi0yMi0y
Mjo1MjowNiAzYzBlZWUzZmU2YTNhMWM3NDUzNzk1NDdjN2U3YzkwNGFhNjRmNmQ1IFNLSVAg
QlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93ZmcvbW0tYmlzZWN0IGFuZCAvdG1w
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC8zYzBlZWUzZmU2YTNhMWM3NDUz
Nzk1NDdjN2U3YzkwNGFhNjRmNmQ1CmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYy
LjYuMzcKZ2l0IGNoZWNrb3V0IHYyLjYuMzYKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMg
M2MwZWVlMy4uLiBMaW51eCAyLjYuMzcKSEVBRCBpcyBub3cgYXQgZjZmOTRlMi4uLiBMaW51
eCAyLjYuMzYKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTpmNmY5NGUyYWIxYjMzZjAwODJhYzIyZDcxZjY2
Mzg1YTYwZDgxNTdmOmJpc2VjdC1tbQoKMjAxMy0wNi0yMi0yMjo1MjoxMSBmNmY5NGUyYWIx
YjMzZjAwODJhYzIyZDcxZjY2Mzg1YTYwZDgxNTdmIGNvbXBpbGluZwo5NCByZWFsICAxMTI4
IHVzZXIgIDg5IHN5cyAgMTI4Mi43OSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYy
MAoyMDEzLTA2LTIyLTIyOjUzOjU3IGY2Zjk0ZTJhYjFiMzNmMDA4MmFjMjJkNzFmNjYzODVh
NjBkODE1N2YgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9tbS1i
aXNlY3QgYW5kIC90bXAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwL2Y2Zjk0
ZTJhYjFiMzNmMDA4MmFjMjJkNzFmNjYzODVhNjBkODE1N2YKYmlzZWN0OiBza2lwIGJyb2tl
biBidWlsZCBmb3IgdjIuNi4zNgpnaXQgY2hlY2tvdXQgdjIuNi4zNQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyBmNmY5NGUyLi4uIExpbnV4IDIuNi4zNgpIRUFEIGlzIG5vdyBhdCA5
ZmU2MjA2Li4uIExpbnV4IDIuNi4zNQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAva3ZtOnF1ZXVlOjlmZTYyMDZmNDAwNjQ2
YTIzMjIwOTZiNTZjNTk4OTFkNTMwZThkNTE6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIyOjU0
OjAzIDlmZTYyMDZmNDAwNjQ2YTIzMjIwOTZiNTZjNTk4OTFkNTMwZThkNTEgY29tcGlsaW5n
ChtbMTszNW14ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRub2NvbmZpZyBm
YWlsZWQbWzBtChtbMTszNW14ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRj
b25maWcgc3VjY2VlZGVkG1swbQo5MCByZWFsICAxMTE1IHVzZXIgIDkxIHN5cyAgMTMyOC4x
MyUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMAoyMDEzLTA2LTIyLTIyOjU1OjQ3
IDlmZTYyMDZmNDAwNjQ2YTIzMjIwOTZiNTZjNTk4OTFkNTMwZThkNTEgU0tJUCBCUk9LRU4g
QlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9tbS1iaXNlY3QgYW5kIC90bXAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwLzlmZTYyMDZmNDAwNjQ2YTIzMjIwOTZiNTZj
NTk4OTFkNTMwZThkNTEKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zNQpn
aXQgY2hlY2tvdXQgdjIuNi4zNApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA5ZmU2MjA2
Li4uIExpbnV4IDIuNi4zNQpIRUFEIGlzIG5vdyBhdCBlNDAxNTJlLi4uIExpbnVzIDIuNi4z
NApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
eDA0LTA2MjAva3ZtOnF1ZXVlOmU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2MzIxNWUzZmFh
MzdhODY6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIyOjU1OjUzIGU0MDE1MmVlMWUxYzdhNjNm
NDc3Nzc5MTg2MzIxNWUzZmFhMzdhODYgY29tcGlsaW5nChtbMTszNW14ODZfNjQtcmFuZGNv
bmZpZy14MDQtMDYyMDogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW14ODZf
NjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo5
MCByZWFsICAxMDY1IHVzZXIgIDkwIHN5cyAgMTI4My44NyUgY3B1IAl4ODZfNjQtcmFuZGNv
bmZpZy14MDQtMDYyMAoyMDEzLTA2LTIyLTIyOjU3OjQxIGU0MDE1MmVlMWUxYzdhNjNmNDc3
Nzc5MTg2MzIxNWUzZmFhMzdhODYgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4g
L2NjL3dmZy9tbS1iaXNlY3QgYW5kIC90bXAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgw
NC0wNjIwL2U0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2MzIxNWUzZmFhMzdhODYKYmlzZWN0
OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zNApnaXQgY2hlY2tvdXQgdjIuNi4zMwpQ
cmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBlNDAxNTJlLi4uIExpbnVzIDIuNi4zNApIRUFE
IGlzIG5vdyBhdCA2MGIzNDFiLi4uIExpbnV4IDIuNi4zMwpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAva3ZtOnF1ZXVlOjYw
YjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQ6YmlzZWN0LW1tCgoyMDEz
LTA2LTIyLTIyOjU3OjQ4IDYwYjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIxYjNjNmE0
YWQgY29tcGlsaW5nChtbMTszNW14ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBv
bGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW14ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYy
MDogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo5MSByZWFsICAxMDE4IHVzZXIgIDg3
IHN5cyAgMTIxNC4xNSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMAoyMDEzLTA2
LTIyLTIyOjU5OjMyIDYwYjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQg
U0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9tbS1iaXNlY3QgYW5k
IC90bXAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwLzYwYjM0MWI3NzhjYzI5
MjlkZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBm
b3IgdjIuNi4zMwpnaXQgY2hlY2tvdXQgdjIuNi4zMgpQcmV2aW91cyBIRUFEIHBvc2l0aW9u
IHdhcyA2MGIzNDFiLi4uIExpbnV4IDIuNi4zMwpIRUFEIGlzIG5vdyBhdCAyMjc2M2M1Li4u
IExpbnV4IDIuNi4zMgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWcteDA0LTA2MjAva3ZtOnF1ZXVlOjIyNzYzYzVjZjM2OTBhNjgxNTUxMTYy
YzE1ZDM0ZDkzNTMwOGM4ZDc6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIyOjU5OjM3IDIyNzYz
YzVjZjM2OTBhNjgxNTUxMTYyYzE1ZDM0ZDkzNTMwOGM4ZDcgY29tcGlsaW5nChtbMTszNW14
ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBt
ChtbMTszNW14ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRjb25maWcgc3Vj
Y2VlZGVkG1swbQo4NyByZWFsICA5NzcgdXNlciAgODAgc3lzICAxMjExLjE4JSBjcHUgCXg4
Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwCjIwMTMtMDYtMjItMjM6MDE6MjAgMjI3NjNjNWNm
MzY5MGE2ODE1NTExNjJjMTVkMzRkOTM1MzA4YzhkNyBTS0lQIEJST0tFTiBCVUlMRApDaGVj
ayBlcnJvcyBpbiAvY2Mvd2ZnL21tLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWcteDA0LTA2MjAvMjI3NjNjNWNmMzY5MGE2ODE1NTExNjJjMTVkMzRkOTM1MzA4
YzhkNwpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjMyCmdpdCBjaGVja291
dCB2Mi42LjMxClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDIyNzYzYzUuLi4gTGludXgg
Mi42LjMyCkhFQUQgaXMgbm93IGF0IDc0ZmNhNmEuLi4gTGludXggMi42LjMxCmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC9r
dm06cXVldWU6NzRmY2E2YTQyODYzZmZhY2FmN2JhNmYxOTM2YTlmMjI4OTUwZjY1NzpiaXNl
Y3QtbW0KCjIwMTMtMDYtMjItMjM6MDE6MjUgNzRmY2E2YTQyODYzZmZhY2FmN2JhNmYxOTM2
YTlmMjI4OTUwZjY1NyBjb21waWxpbmcKG1sxOzM1bXg4Nl82NC1yYW5kY29uZmlnLXgwNC0w
NjIwOiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bXg4Nl82NC1yYW5kY29u
ZmlnLXgwNC0wNjIwOiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjc5IHJlYWwgIDg3
MSB1c2VyICA3NCBzeXMgIDExOTcuNDIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDA0LTA2
MjAKMjAxMy0wNi0yMi0yMzowMjo1OCA3NGZjYTZhNDI4NjNmZmFjYWY3YmE2ZjE5MzZhOWYy
Mjg5NTBmNjU3IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93ZmcvbW0t
YmlzZWN0IGFuZCAvdG1wL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC83NGZj
YTZhNDI4NjNmZmFjYWY3YmE2ZjE5MzZhOWYyMjg5NTBmNjU3CmJpc2VjdDogc2tpcCBicm9r
ZW4gYnVpbGQgZm9yIHYyLjYuMzEKZ2l0IGNoZWNrb3V0IHYyLjYuMzAKUHJldmlvdXMgSEVB
RCBwb3NpdGlvbiB3YXMgNzRmY2E2YS4uLiBMaW51eCAyLjYuMzEKSEVBRCBpcyBub3cgYXQg
MDdhMjAzOS4uLiBMaW51eCAyLjYuMzAKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTowN2EyMDM5YjhlYjBh
ZjRmZjQ2NGVmZDNkZmQ5NWRlNWMwMjY0OGM2OmJpc2VjdC1tbQoKMjAxMy0wNi0yMi0yMzow
MzowMyAwN2EyMDM5YjhlYjBhZjRmZjQ2NGVmZDNkZmQ5NWRlNWMwMjY0OGM2IGNvbXBpbGlu
ZwobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6IG1ha2Ugb2xkbm9jb25maWcg
ZmFpbGVkG1swbQobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6IG1ha2Ugb2xk
Y29uZmlnIHN1Y2NlZWRlZBtbMG0KNjcgcmVhbCAgNjc3IHVzZXIgIDU3IHN5cyAgMTA4MS44
MCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMAoyMDEzLTA2LTIyLTIzOjA0OjI1
IDA3YTIwMzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYgU0tJUCBCUk9LRU4g
QlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9tbS1iaXNlY3QgYW5kIC90bXAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwLzA3YTIwMzliOGViMGFmNGZmNDY0ZWZkM2Rm
ZDk1ZGU1YzAyNjQ4YzYKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zMApn
aXQgY2hlY2tvdXQgdjIuNi4yOQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAwN2EyMDM5
Li4uIExpbnV4IDIuNi4zMApIRUFEIGlzIG5vdyBhdCA4ZTBlZTQzLi4uIExpbnV4IDIuNi4y
OQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
eDA0LTA2MjAva3ZtOnF1ZXVlOjhlMGVlNDNiYzJjM2UxOWRiNTZhNGFkYWE5YTliMDRjZTg4
NWNkODQ6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIzOjA0OjMwIDhlMGVlNDNiYzJjM2UxOWRi
NTZhNGFkYWE5YTliMDRjZTg4NWNkODQgY29tcGlsaW5nChtbMTszNW14ODZfNjQtcmFuZGNv
bmZpZy14MDQtMDYyMDogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW14ODZf
NjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo3
MiByZWFsICA2MTggdXNlciAgNTUgc3lzICA5MzEuODUlIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWcteDA0LTA2MjAKMjAxMy0wNi0yMi0yMzowNjoxNSA4ZTBlZTQzYmMyYzNlMTlkYjU2YTRh
ZGFhOWE5YjA0Y2U4ODVjZDg0IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9j
Yy93ZmcvbW0tYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQt
MDYyMC84ZTBlZTQzYmMyYzNlMTlkYjU2YTRhZGFhOWE5YjA0Y2U4ODVjZDg0CmJpc2VjdDog
c2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjkKZ2l0IGNoZWNrb3V0IHYyLjYuMjgKUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgOGUwZWU0My4uLiBMaW51eCAyLjYuMjkKSEVBRCBp
cyBub3cgYXQgNGE2OTA4YS4uLiBMaW51eCAyLjYuMjgKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTo0YTY5
MDhhM2EwNTBhYWNjOWMzYTJmMzZiMjc2YjQ2YzA2MjlhZDkxOmJpc2VjdC1tbQoKMjAxMy0w
Ni0yMi0yMzowNjoyMCA0YTY5MDhhM2EwNTBhYWNjOWMzYTJmMzZiMjc2YjQ2YzA2MjlhZDkx
IGNvbXBpbGluZwobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6IG1ha2Ugb2xk
bm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6
IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KNjkgcmVhbCAgNDc2IHVzZXIgIDUzIHN5
cyAgNzY0LjgxJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwCjIwMTMtMDYtMjIt
MjM6MDc6NTggNGE2OTA4YTNhMDUwYWFjYzljM2EyZjM2YjI3NmI0NmMwNjI5YWQ5MSBTS0lQ
IEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL21tLWJpc2VjdCBhbmQgL3Rt
cC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAvNGE2OTA4YTNhMDUwYWFjYzlj
M2EyZjM2YjI3NmI0NmMwNjI5YWQ5MQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2
Mi42LjI4CmdpdCBjaGVja291dCB2Mi42LjI3ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IDRhNjkwOGEuLi4gTGludXggMi42LjI4CkhFQUQgaXMgbm93IGF0IDNmYTg3NDkuLi4gTGlu
dXggMi42LjI3CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy14MDQtMDYyMC9rdm06cXVldWU6M2ZhODc0OWU1ODRiNTVmMTE4MDQxMWFiMWI1
MTExNzE5MGJhYzFlNTpiaXNlY3QtbW0KCjIwMTMtMDYtMjItMjM6MDg6MDMgM2ZhODc0OWU1
ODRiNTVmMTE4MDQxMWFiMWI1MTExNzE5MGJhYzFlNSBjb21waWxpbmcKG1sxOzM1bXg4Nl82
NC1yYW5kY29uZmlnLXgwNC0wNjIwOiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sx
OzM1bXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwOiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVk
ZWQbWzBtChtbMTszNW14ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBwcmVwYXJl
IGZhaWxlZBtbMG0KMjAxMy0wNi0yMi0yMzoxMDozNCAzZmE4NzQ5ZTU4NGI1NWYxMTgwNDEx
YWIxYjUxMTE3MTkwYmFjMWU1IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9j
Yy93ZmcvbW0tYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQt
MDYyMC8zZmE4NzQ5ZTU4NGI1NWYxMTgwNDExYWIxYjUxMTE3MTkwYmFjMWU1CmJpc2VjdDog
c2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjcKZ2l0IGNoZWNrb3V0IHYyLjYuMjYKUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgM2ZhODc0OS4uLiBMaW51eCAyLjYuMjcKSEVBRCBp
cyBub3cgYXQgYmNlN2Y3OS4uLiBMaW51eCAyLjYuMjYKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTpiY2U3
Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1OmJpc2VjdC1tbQoKMjAxMy0w
Ni0yMi0yMzoxMDo0MCBiY2U3Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1
IGNvbXBpbGluZwobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6IG1ha2Ugb2xk
bm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6
IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KNjYgcmVhbCAgMzgwIHVzZXIgIDM2IHN5
cyAgNjI4LjE5JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwCjIwMTMtMDYtMjIt
MjM6MTI6MTMgYmNlN2Y3OTNkYWVjM2U2NWVjNWM1NzA1ZDI0NTdiODFmZTdiNTcyNSBTS0lQ
IEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL21tLWJpc2VjdCBhbmQgL3Rt
cC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAvYmNlN2Y3OTNkYWVjM2U2NWVj
NWM1NzA1ZDI0NTdiODFmZTdiNTcyNQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2
Mi42LjI2CmdpdCBjaGVja291dCB2Mi42LjI1ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IGJjZTdmNzkuLi4gTGludXggMi42LjI2CkhFQUQgaXMgbm93IGF0IDRiMTE5ZTIuLi4gTGlu
dXggMi42LjI1CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy14MDQtMDYyMC9rdm06cXVldWU6NGIxMTllMjFkMGM2NmMyMmU4Y2EwM2RmMDVk
OWRlNjIzZDBlYjUwZjpiaXNlY3QtbW0KCjIwMTMtMDYtMjItMjM6MTI6MTcgNGIxMTllMjFk
MGM2NmMyMmU4Y2EwM2RmMDVkOWRlNjIzZDBlYjUwZiBjb21waWxpbmcKG1sxOzM1bXg4Nl82
NC1yYW5kY29uZmlnLXgwNC0wNjIwOiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sx
OzM1bXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwOiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVk
ZWQbWzBtCjYyIHJlYWwgIDM3MCB1c2VyICAzNSBzeXMgIDY0NC4zNCUgY3B1IAl4ODZfNjQt
cmFuZGNvbmZpZy14MDQtMDYyMAoyMDEzLTA2LTIyLTIzOjEzOjM5IDRiMTE5ZTIxZDBjNjZj
MjJlOGNhMDNkZjA1ZDlkZTYyM2QwZWI1MGYgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJy
b3MgaW4gL2NjL3dmZy9tbS1iaXNlY3QgYW5kIC90bXAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXgwNC0wNjIwLzRiMTE5ZTIxZDBjNjZjMjJlOGNhMDNkZjA1ZDlkZTYyM2QwZWI1MGYK
YmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yNQpnaXQgY2hlY2tvdXQgdjIu
Ni4yNApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA0YjExOWUyLi4uIExpbnV4IDIuNi4y
NQpIRUFEIGlzIG5vdyBhdCA0OTkxNDA4Li4uIExpbnV4IDIuNi4yNApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAva3ZtOnF1
ZXVlOjQ5OTE0MDg0ZTc5NzUzMGQ5YmFhZjUxZGY5ZWRhNzdiYWJjOThmYTg6YmlzZWN0LW1t
CgoyMDEzLTA2LTIyLTIzOjEzOjQ0IDQ5OTE0MDg0ZTc5NzUzMGQ5YmFhZjUxZGY5ZWRhNzdi
YWJjOThmYTggY29tcGlsaW5nChtbMTszNW14ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMDog
bWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW14ODZfNjQtcmFuZGNvbmZpZy14
MDQtMDYyMDogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo1MCByZWFsICAzMjAgdXNl
ciAgMzAgc3lzICA2OTcuMzclIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAKMjAx
My0wNi0yMi0yMzoxNDo1OSA0OTkxNDA4NGU3OTc1MzBkOWJhYWY1MWRmOWVkYTc3YmFiYzk4
ZmE4IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93ZmcvbW0tYmlzZWN0
IGFuZCAvdG1wL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC80OTkxNDA4NGU3
OTc1MzBkOWJhYWY1MWRmOWVkYTc3YmFiYzk4ZmE4CmJpc2VjdDogc2tpcCBicm9rZW4gYnVp
bGQgZm9yIHYyLjYuMjQKZ2l0IGNoZWNrb3V0IHYyLjYuMjMKUHJldmlvdXMgSEVBRCBwb3Np
dGlvbiB3YXMgNDk5MTQwOC4uLiBMaW51eCAyLjYuMjQKSEVBRCBpcyBub3cgYXQgYmJmMjUw
MTBmLi4uIExpbnV4IDIuNi4yMwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAva3ZtOnF1ZXVlOmJiZjI1MDEwZjFhNmI3NjE5
MTQ0MzBmNWZjYTA4MWVjOGM3YWNjZDE6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIzOjE1OjA1
IGJiZjI1MDEwZjFhNmI3NjE5MTQ0MzBmNWZjYTA4MWVjOGM3YWNjZDEgY29tcGlsaW5nChtb
MTszNW14ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRub2NvbmZpZyBmYWls
ZWQbWzBtChtbMTszNW14ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRjb25m
aWcgc3VjY2VlZGVkG1swbQo1NyByZWFsICAyOTkgdXNlciAgMjkgc3lzICA1NzUuNTUlIGNw
dSAJeDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAKMjAxMy0wNi0yMi0yMzoxNjozMCBiYmYy
NTAxMGYxYTZiNzYxOTE0NDMwZjVmY2EwODFlYzhjN2FjY2QxIFNLSVAgQlJPS0VOIEJVSUxE
CkNoZWNrIGVycm9zIGluIC9jYy93ZmcvbW0tYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy14MDQtMDYyMC9iYmYyNTAxMGYxYTZiNzYxOTE0NDMwZjVmY2EwODFl
YzhjN2FjY2QxCmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjMKZ2l0IGNo
ZWNrb3V0IHYyLjYuMjIKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYmJmMjUwMTBmLi4u
IExpbnV4IDIuNi4yMwpIRUFEIGlzIG5vdyBhdCA3ZGNjYTMwLi4uIExpbnV4IDIuNi4yMgps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDA0
LTA2MjAva3ZtOnF1ZXVlOjdkY2NhMzBhMzJhYWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUw
NWM6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIzOjE2OjM1IDdkY2NhMzBhMzJhYWRiMDUyMDQx
NzUyMWIwYzQ0ZjQyZDA5ZmUwNWMgY29tcGlsaW5nChtbMTszNW14ODZfNjQtcmFuZGNvbmZp
Zy14MDQtMDYyMDogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW14ODZfNjQt
cmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo0OCBy
ZWFsICAyODcgdXNlciAgMjYgc3lzICA2NTMuMDklIGNwdSAJeDg2XzY0LXJhbmRjb25maWct
eDA0LTA2MjAKMjAxMy0wNi0yMi0yMzoxNzo0NCA3ZGNjYTMwYTMyYWFkYjA1MjA0MTc1MjFi
MGM0NGY0MmQwOWZlMDVjIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93
ZmcvbW0tYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYy
MC83ZGNjYTMwYTMyYWFkYjA1MjA0MTc1MjFiMGM0NGY0MmQwOWZlMDVjCmJpc2VjdDogc2tp
cCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjIKZ2l0IGNoZWNrb3V0IHYyLjYuMjEKUHJldmlv
dXMgSEVBRCBwb3NpdGlvbiB3YXMgN2RjY2EzMC4uLiBMaW51eCAyLjYuMjIKSEVBRCBpcyBu
b3cgYXQgZGU0NmMzMy4uLiBMaW51eCAyLjYuMjEKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTpkZTQ2YzMz
NzQ1ZjVlMmFkNTk0YzcyZjJjZjVmNDkwODYxYjE2Y2UxOmJpc2VjdC1tbQoKMjAxMy0wNi0y
Mi0yMzoxNzo0OSBkZTQ2YzMzNzQ1ZjVlMmFkNTk0YzcyZjJjZjVmNDkwODYxYjE2Y2UxIGNv
bXBpbGluZwobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6IG1ha2Ugb2xkbm9j
b25maWcgZmFpbGVkG1swbQobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6IG1h
a2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMTIgcmVhbCAgMTEgdXNlciAgMCBzeXMgIDk5
Ljc1JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwCjIwMTMtMDYtMjItMjM6MTg6
MjIgZGU0NmMzMzc0NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5MDg2MWIxNmNlMSBTS0lQIEJST0tF
TiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL21tLWJpc2VjdCBhbmQgL3RtcC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjAvZGU0NmMzMzc0NWY1ZTJhZDU5NGM3MmYy
Y2Y1ZjQ5MDg2MWIxNmNlMQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjIx
CmdpdCBjaGVja291dCB2Mi42LjIwClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGRlNDZj
MzMuLi4gTGludXggMi42LjIxCkhFQUQgaXMgbm93IGF0IDYyZDBjZmMuLi4gTGludXggMi42
LjIwCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy14MDQtMDYyMC9rdm06cXVldWU6NjJkMGNmY2IyN2NmNzU1Y2ViZGM5M2NhOTVkYWJjODM2
MDgwMDdjZDpiaXNlY3QtbW0KCjIwMTMtMDYtMjItMjM6MTg6MjYgNjJkMGNmY2IyN2NmNzU1
Y2ViZGM5M2NhOTVkYWJjODM2MDgwMDdjZCBjb21waWxpbmcKG1sxOzM1bXg4Nl82NC1yYW5k
Y29uZmlnLXgwNC0wNjIwOiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bXg4
Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwOiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBt
CjEzIHJlYWwgIDEyIHVzZXIgIDAgc3lzICAxMDIuOTglIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWcteDA0LTA2MjAKMjAxMy0wNi0yMi0yMzoxODo1OCA2MmQwY2ZjYjI3Y2Y3NTVjZWJkYzkz
Y2E5NWRhYmM4MzYwODAwN2NkIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9j
Yy93ZmcvbW0tYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQt
MDYyMC82MmQwY2ZjYjI3Y2Y3NTVjZWJkYzkzY2E5NWRhYmM4MzYwODAwN2NkCmJpc2VjdDog
c2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjAKZ2l0IGNoZWNrb3V0IHYyLjYuMTkKUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNjJkMGNmYy4uLiBMaW51eCAyLjYuMjAKSEVBRCBp
cyBub3cgYXQgMDIxNWZmYi4uLiBMaW51eCAyLjYuMTkKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTowMjE1
ZmZiMDhjZTk5ZTJiYjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0OmJpc2VjdC1tbQoKMjAxMy0w
Ni0yMi0yMzoxOTowMiAwMjE1ZmZiMDhjZTk5ZTJiYjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0
IGNvbXBpbGluZwobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6IG1ha2Ugb2xk
bm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6
IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMTYgcmVhbCAgMTUgdXNlciAgMSBzeXMg
IDEwMS42MyUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMAoyMDEzLTA2LTIyLTIz
OjE5OjM2IDAyMTVmZmIwOGNlOTllMmJiNTllY2ExMTRhOTk0OTlhNGQwNmU3MDQgU0tJUCBC
Uk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9tbS1iaXNlY3QgYW5kIC90bXAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwLzAyMTVmZmIwOGNlOTllMmJiNTll
Y2ExMTRhOTk0OTlhNGQwNmU3MDQKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIu
Ni4xOQpnaXQgY2hlY2tvdXQgdjIuNi4xOApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAw
MjE1ZmZiLi4uIExpbnV4IDIuNi4xOQpIRUFEIGlzIG5vdyBhdCBlNDc4YmVjLi4uIExpbnV4
IHYyLjYuMTguIEFycnIhCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy14MDQtMDYyMC9rdm06cXVldWU6ZTQ3OGJlYzBiYTBhODNhNDhhMGY2
OTgyOTM0YjZkZTA3OWU3ZTZiMzpiaXNlY3QtbW0KCjIwMTMtMDYtMjItMjM6MTk6NDEgZTQ3
OGJlYzBiYTBhODNhNDhhMGY2OTgyOTM0YjZkZTA3OWU3ZTZiMyBjb21waWxpbmcKG1sxOzM1
bXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwOiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtb
MG0KG1sxOzM1bXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwOiBtYWtlIG9sZGNvbmZpZyBz
dWNjZWVkZWQbWzBtCjM4IHJlYWwgIDI1NyB1c2VyICAyMyBzeXMgIDcyNS45NSUgY3B1IAl4
ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMAoyMDEzLTA2LTIyLTIzOjIwOjQxIGU0NzhiZWMw
YmEwYTgzYTQ4YTBmNjk4MjkzNGI2ZGUwNzllN2U2YjMgU0tJUCBCUk9LRU4gQlVJTEQKQ2hl
Y2sgZXJyb3MgaW4gL2NjL3dmZy9tbS1iaXNlY3QgYW5kIC90bXAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXgwNC0wNjIwL2U0NzhiZWMwYmEwYTgzYTQ4YTBmNjk4MjkzNGI2ZGUwNzll
N2U2YjMKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4xOApnaXQgY2hlY2tv
dXQgdjIuNi4xNwpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBlNDc4YmVjLi4uIExpbnV4
IHYyLjYuMTguIEFycnIhCkhFQUQgaXMgbm93IGF0IDQyN2FiZmEuLi4gTGludXggdjIuNi4x
NwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
eDA0LTA2MjAva3ZtOnF1ZXVlOjQyN2FiZmEyOGFmZWRmZmFkZmNhOWRkOGIwNjdlYjZkMzZi
YWM1M2Y6YmlzZWN0LW1tCgoyMDEzLTA2LTIyLTIzOjIwOjQ1IDQyN2FiZmEyOGFmZWRmZmFk
ZmNhOWRkOGIwNjdlYjZkMzZiYWM1M2YgY29tcGlsaW5nChtbMTszNW14ODZfNjQtcmFuZGNv
bmZpZy14MDQtMDYyMDogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW14ODZf
NjQtcmFuZGNvbmZpZy14MDQtMDYyMDogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo3
MyByZWFsICAyNzIgdXNlciAgMjMgc3lzICA0MDMuNzElIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWcteDA0LTA2MjAKMjAxMy0wNi0yMi0yMzoyMjo0NyA0MjdhYmZhMjhhZmVkZmZhZGZjYTlk
ZDhiMDY3ZWI2ZDM2YmFjNTNmIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9j
Yy93ZmcvbW0tYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MDQt
MDYyMC80MjdhYmZhMjhhZmVkZmZhZGZjYTlkZDhiMDY3ZWI2ZDM2YmFjNTNmCmJpc2VjdDog
c2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMTcKZ2l0IGNoZWNrb3V0IHYyLjYuMTYKUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNDI3YWJmYS4uLiBMaW51eCB2Mi42LjE3CkhFQUQg
aXMgbm93IGF0IDc3MDVhODcuLi4gTGludXggMi42LjE2CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC9rdm06cXVldWU6Nzcw
NWE4NzkyYjBmYzgyZmQ3ZDRkZDkyMzcyNDYwNmJiZmQ5ZmIyMDpiaXNlY3QtbW0KCjIwMTMt
MDYtMjItMjM6MjI6NTIgNzcwNWE4NzkyYjBmYzgyZmQ3ZDRkZDkyMzcyNDYwNmJiZmQ5ZmIy
MCBjb21waWxpbmcKG1sxOzM1bXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwOiBtYWtlIG9s
ZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bXg4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIw
OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjMyIHJlYWwgIDI0OCB1c2VyICAyMSBz
eXMgIDgyMy4yOSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMAoyMDEzLTA2LTIy
LTIzOjI0OjA1IDc3MDVhODc5MmIwZmM4MmZkN2Q0ZGQ5MjM3MjQ2MDZiYmZkOWZiMjAgU0tJ
UCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9tbS1iaXNlY3QgYW5kIC90
bXAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwLzc3MDVhODc5MmIwZmM4MmZk
N2Q0ZGQ5MjM3MjQ2MDZiYmZkOWZiMjAKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3Ig
djIuNi4xNgpnaXQgY2hlY2tvdXQgdjIuNi4xNQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyA3NzA1YTg3Li4uIExpbnV4IDIuNi4xNgpIRUFEIGlzIG5vdyBhdCA4ODAyNjg0Li4uIExp
bnV4IHYyLjYuMTUKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTo4ODAyNjg0MmIwYTc2MDE0NWFhNzFkNjll
NzRmYmM5ZWMxMThjYTQ0OmJpc2VjdC1tbQoKMjAxMy0wNi0yMi0yMzoyNDowOCA4ODAyNjg0
MmIwYTc2MDE0NWFhNzFkNjllNzRmYmM5ZWMxMThjYTQ0IGNvbXBpbGluZwobWzE7MzVteDg2
XzY0LXJhbmRjb25maWcteDA0LTA2MjA6IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQob
WzE7MzVteDg2XzY0LXJhbmRjb25maWcteDA0LTA2MjA6IG1ha2Ugb2xkY29uZmlnIHN1Y2Nl
ZWRlZBtbMG0KMjkgcmVhbCAgMjMwIHVzZXIgIDIwIHN5cyAgODUxLjg3JSBjcHUgCXg4Nl82
NC1yYW5kY29uZmlnLXgwNC0wNjIwCjIwMTMtMDYtMjItMjM6MjU6MDMgODgwMjY4NDJiMGE3
NjAxNDVhYTcxZDY5ZTc0ZmJjOWVjMTE4Y2E0NCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBl
cnJvcyBpbiAvY2Mvd2ZnL21tLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDA0LTA2MjAvODgwMjY4NDJiMGE3NjAxNDVhYTcxZDY5ZTc0ZmJjOWVjMTE4Y2E0
NApiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjE1ChtbMTszNW1jYW5ub3Qg
ZmluZCB0aGUgZmlyc3QgYmFkIGNvbW1pdBtbMG0KCj09PT09PT09PSB1cHN0cmVhbSA9PT09
PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLXgwNC0wNjIwL2t2bTpxdWV1ZTpmNzExOTRhN2Q0N2MxZGE3
ODc1NTVkMjdhYWM2Mzk3M2NhNzIzMjNiOmJpc2VjdC1tbQoKMjAxMy0wNi0yMi0yMzoyNToy
MCBmNzExOTRhN2Q0N2MxZGE3ODc1NTVkMjdhYWM2Mzk3M2NhNzIzMjNiIGNvbXBpbGluZwoK
MjAxMy0wNi0yMi0yMzoyODoxOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM2LTAw
MTMyLWdmNzExOTRhLi4uLiBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLWxrcC1zYngwNC0zNzA2
Ni0yMDEzMDYyMzAzMzM0MS0zLjEwLjAtcmM2LTAwMTMyLWdmNzExOTRhLTc3CmRtZXNnLWt2
bS1sa3Atc2J4MDQtMjM5OTgtMjAxMzA2MjMwMzM0MDgtMy4xMC4wLXJjNi0wMDEzMi1nZjcx
MTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTU0OTQtMjAxMzA2MjMwMzMzNDYtMy4xMC4w
LXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTM3NTk5LTIwMTMw
NjIzMDMzMzUwLTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2cta3ZtLWxrcC1z
YngwNC01ODI2Mi0yMDEzMDYyMzAzMzM1NS0zLjEwLjAtcmM2LTAwMTMyLWdmNzExOTRhLTc3
CmRtZXNnLWt2bS1sa3Atc2J4MDQtNDA5MTUtMjAxMzA2MjMwMzM0MDEtMy4xMC4wLXJjNi0w
MDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTE1NTE1LTIwMTMwNjIzMDMz
MzU4LTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2cta3ZtLWxrcC1zYngwNC0y
NzY3NS0yMDEzMDYyMzAzMzM1Mi0zLjEwLjAtcmM2LTAwMTMyLWdmNzExOTRhLTc3CmRtZXNn
LWt2bS1sa3Atc2J4MDQtMjgyMDAtMjAxMzA2MjMwMzMzNTktMy4xMC4wLXJjNi0wMDEzMi1n
ZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTExMzczLTIwMTMwNjIzMDMzMzUyLTMu
MTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2cta3ZtLWxrcC1zYngwNC04MzUzLTIw
MTMwNjIzMDMzMzQ5LTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2cta3ZtLWxr
cC1zYngwNC01OTU0OC0yMDEzMDYyMzAzMzM0NS0zLjEwLjAtcmM2LTAwMTMyLWdmNzExOTRh
LTc3CmRtZXNnLWt2bS1sa3Atc2J4MDQtMTE2Ny0yMDEzMDYyMzAzMzM1MS0zLjEwLjAtcmM2
LTAwMTMyLWdmNzExOTRhLTc3CmRtZXNnLWt2bS1sa3Atc2J4MDQtMjk0NjctMjAxMzA2MjMw
MzMzMzgtMy4xMC4wLXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0
LTExNzA2LTIwMTMwNjIzMDMzMzUyLTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1l
c2cta3ZtLWxrcC1zYngwNC0xNjgyNy0yMDEzMDYyMzAzMzMzNi0zLjEwLjAtcmM2LTAwMTMy
LWdmNzExOTRhLTc3CmRtZXNnLWt2bS1sa3Atc2J4MDQtMTcxMDMtMjAxMzA2MjMwMzMzNTYt
My4xMC4wLXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTE3NDE2
LTIwMTMwNjIzMDMzMzQ2LTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2cta3Zt
LWxrcC1zYngwNC0xNzYzNi0yMDEzMDYyMzAzMzM1Mi0zLjEwLjAtcmM2LTAwMTMyLWdmNzEx
OTRhLTc3CmRtZXNnLWt2bS1sa3Atc2J4MDQtMzA3OTUtMjAxMzA2MjMwMzMzNTctMy4xMC4w
LXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTkxNzEtMjAxMzA2
MjMwMzMzNTItMy4xMC4wLXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNi
eDA0LTQ2NjIwLTIwMTMwNjIzMDMzMzU3LTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcK
ZG1lc2cta3ZtLWxrcC1zYngwNC0xMjIyMS0yMDEzMDYyMzAzMzM0NS0zLjEwLjAtcmM2LTAw
MTMyLWdmNzExOTRhLTc3CmRtZXNnLWt2bS1sa3Atc2J4MDQtMTgyMzktMjAxMzA2MjMwMzMz
MzctMy4xMC4wLXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTQ3
NjgxLTIwMTMwNjIzMDMzMzUyLTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2ct
a3ZtLWxrcC1zYngwNC0xMjMxNC0yMDEzMDYyMzAzMzM1Mi0zLjEwLjAtcmM2LTAwMTMyLWdm
NzExOTRhLTc3CmRtZXNnLWt2bS1sa3Atc2J4MDQtMTI0OTctMjAxMzA2MjMwMzMzNDYtMy4x
MC4wLXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTEyOTcyLTIw
MTMwNjIzMDMzMzM5LTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2cta3ZtLWxr
cC1zYngwNC02Mzg2MC0yMDEzMDYyMzAzMzMzNS0zLjEwLjAtcmM2LTAwMTMyLWdmNzExOTRh
LTc3CmRtZXNnLWt2bS1sa3Atc2J4MDQtNTA0NjgtMjAxMzA2MjMwMzMzNTAtMy4xMC4wLXJj
Ni0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTY0NDEtMjAxMzA2MjMw
MzMzNTQtMy4xMC4wLXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tYmVucy00MzI5
LTIwMTMwNjIyMjMyODIwLTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2cta3Zt
LXJvYW0tNDkzOS0yMDEzMDYyMjIzMjgxOS0zLjEwLjAtcmM2LTAwMTMyLWdmNzExOTRhLTc3
CmRtZXNnLWt2bS1sa3Atc2J4MDQtMjA1MDYtMjAxMzA2MjMwMzMzNTAtMy4xMC4wLXJjNi0w
MDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tcm9hbS02MDgtMjAxMzA2MjIyMzI4NDAtMy4x
MC4wLXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTMzNTk0LTIw
MTMwNjIzMDMzMzU4LTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2cta3ZtLWxr
cC1zYngwNC01MjI2LTIwMTMwNjIzMDMzMzU2LTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEt
NzcKZG1lc2cta3ZtLWxrcC1zYngwNC01MzAxNy0yMDEzMDYyMzAzMzM1OS0zLjEwLjAtcmM2
LTAwMTMyLWdmNzExOTRhLTc3CmRtZXNnLWt2bS1yb2FtLTEzMDQ1LTIwMTMwNjIyMjMyODI1
LTMuMTAuMC1yYzYtMDAxMzItZ2Y3MTE5NGEtNzcKZG1lc2cta3ZtLWxrcC1zYngwNC0xMzcw
NS0yMDEzMDYyMzAzMzMzOS0zLjEwLjAtcmM2LTAwMTMyLWdmNzExOTRhLTc3CmRtZXNnLWt2
bS1sa3Atc2J4MDQtNTQwNS0yMDEzMDYyMzAzMzQwMC0zLjEwLjAtcmM2LTAwMTMyLWdmNzEx
OTRhLTc3CmRtZXNnLWt2bS1sa3Atc2J4MDQtMTM5OTEtMjAxMzA2MjMwMzMzNTgtMy4xMC4w
LXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNieDA0LTY4NTItMjAxMzA2
MjMwMzMzMzgtMy4xMC4wLXJjNi0wMDEzMi1nZjcxMTk0YS03NwpkbWVzZy1rdm0tbGtwLXNi
eDA0LTcyMDUtMjAxMzA2MjMwMzM0MDAtMy4xMC4wLXJjNi0wMDEzMi1nZjcxMTk0YS03NwoK
Cj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MDQtMDYyMC9r
dm06cXVldWU6ZTFhODY1Nzg3NDczNzZmMDg5ODU2MjdjODRkZjA4OGE1ZDBkMWU5MjpiaXNl
Y3QtbW0KCjIwMTMtMDYtMjItMjM6MzA6MjYgZTFhODY1Nzg3NDczNzZmMDg5ODU2MjdjODRk
ZjA4OGE1ZDBkMWU5MiBjb21waWxpbmcKCjIwMTMtMDYtMjItMjM6MzM6MTggZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xMC4wLXJjNi1uZXh0LTIwMTMwNjIxLi4uIFRFU1QgRkFJTFVSRQpk
bWVzZy1rdm0tbGtwLXNieDA0LTY4MC0yMDEzMDYyMzAzMzgxMC0zLjEwLjAtcmM2LW5leHQt
MjAxMzA2MjEtNzgKZG1lc2cta3ZtLWxrcC1zYngwNC03Mzc3LTIwMTMwNjIzMDMzNzU5LTMu
MTAuMC1yYzYtbmV4dC0yMDEzMDYyMS03OApkbWVzZy1rdm0tbGtwLXNieDA0LTM2MzktMjAx
MzA2MjMwMzM4MDEtMy4xMC4wLXJjNi1uZXh0LTIwMTMwNjIxLTc4CmRtZXNnLWt2bS1iZW5z
LTM0NDktMjAxMzA2MjIyMzMzMTktMy4xMC4wLXJjNi1uZXh0LTIwMTMwNjIxLTc4CmRtZXNn
LWt2bS1sa3AtbmV4MDQtNDg0MTUtMjAxMzA2MjIyMzM1MjItMy4xMC4wLXJjNi1uZXh0LTIw
MTMwNjIxLTc4CmRtZXNnLWt2bS1sa3AtbmV4MDQtNTA3NTctMjAxMzA2MjIyMzM1MjEtMy4x
MC4wLXJjNi1uZXh0LTIwMTMwNjIxLTc4CmRtZXNnLWt2bS1sa3AtbmV4MDQtNTIxMjEtMjAx
MzA2MjIyMzM1MjItMy4xMC4wLXJjNi1uZXh0LTIwMTMwNjIxLTc4CmRtZXNnLWt2bS1sa3At
bmV4MDQtNTMwNTYtMjAxMzA2MjIyMzM1MjItMy4xMC4wLXJjNi1uZXh0LTIwMTMwNjIxLTc4
CmRtZXNnLWt2bS12cC0yMTcxNy0yMDEzMDYyMjIzMzU0OC0zLjEwLjAtcmM2LW5leHQtMjAx
MzA2MjEtNzgKZG1lc2cta3ZtLWxrcC1uZXgwNC01NDAzNi0yMDEzMDYyMjIzMzUyMi0zLjEw
LjAtcmM2LW5leHQtMjAxMzA2MjEtNzgKZG1lc2cta3ZtLWxrcC1zYngwNC0zODY2Ny0yMDEz
MDYyMzAzMzgwNC0zLjEwLjAtcmM2LW5leHQtMjAxMzA2MjEtNzgKZG1lc2cta3ZtLWxrcC1z
YngwNC00MDkxNS0yMDEzMDYyMzAzMzgxMC0zLjEwLjAtcmM2LW5leHQtMjAxMzA2MjEtNzgK
ZG1lc2cta3ZtLWxrcC1uZXgwNC01NTcwMC0yMDEzMDYyMjIzMzUzMS0zLjEwLjAtcmM2LW5l
eHQtMjAxMzA2MjEtNzgKZG1lc2cta3ZtLWJlbnMtNDMyOS0yMDEzMDYyMjIzMzMyNi0zLjEw
LjAtcmM2LW5leHQtMjAxMzA2MjEtNzgKZG1lc2cta3ZtLWxrcC1zYngwNC00NTAxMy0yMDEz
MDYyMzAzMzgwMC0zLjEwLjAtcmM2LW5leHQtMjAxMzA2MjEtNzgKZG1lc2cta3ZtLWxrcC1u
ZXgwNC0xMDA3OC0yMDEzMDYyMjIzMzUyMi0zLjEwLjAtcmM2LW5leHQtMjAxMzA2MjEtNzgK
ZG1lc2cta3ZtLWxrcC1zYngwNC04ODQxLTIwMTMwNjIzMDMzODA0LTMuMTAuMC1yYzYtbmV4
dC0yMDEzMDYyMS03OApkbWVzZy1rdm0tbGtwLW5leDA0LTYwNjU5LTIwMTMwNjIyMjMzNTMw
LTMuMTAuMC1yYzYtbmV4dC0yMDEzMDYyMS03OApkbWVzZy1rdm0tbGtwLW5leDA0LTYxMzc3
LTIwMTMwNjIyMjMzNTIzLTMuMTAuMC1yYzYtbmV4dC0yMDEzMDYyMS03OApkbWVzZy1rdm0t
dnAtMjcxNzMtMjAxMzA2MjIyMzM1NTctMy4xMC4wLXJjNi1uZXh0LTIwMTMwNjIxLTc4CmRt
ZXNnLWt2bS1sa3AtbmV4MDQtMTE3MTItMjAxMzA2MjIyMzM1MzEtMy4xMC4wLXJjNi1uZXh0
LTIwMTMwNjIxLTc4CmRtZXNnLWt2bS1sa3AtbmV4MDQtMTMyNTAtMjAxMzA2MjIyMzM1MjIt
My4xMC4wLXJjNi1uZXh0LTIwMTMwNjIxLTc4CmRtZXNnLWt2bS1sa3Atc2J4MDQtOTU0MS0y
MDEzMDYyMzAzMzgwOS0zLjEwLjAtcmM2LW5leHQtMjAxMzA2MjEtNzgKZG1lc2cta3ZtLWxr
cC1zYngwNC00NzEzMy0yMDEzMDYyMzAzMzgwNC0zLjEwLjAtcmM2LW5leHQtMjAxMzA2MjEt
NzgKZG1lc2cta3ZtLWxrcC1zYngwNC0xMzE0NC0yMDEzMDYyMzAzMzgwNS0zLjEwLjAtcmM2
LW5leHQtMjAxMzA2MjEtNzgKZG1lc2cta3ZtLWxrcC1uZXgwNC02NTQ5MS0yMDEzMDYyMjIz
MzUyMS0zLjEwLjAtcmM2LW5leHQtMjAxMzA2MjEtNzgKZG1lc2cta3ZtLXN0b2FrbGV5LTU4
MzktMjAxMzA2MjIyMzMzNTUtMy4xMC4wLXJjNi1uZXh0LTIwMTMwNjIxLTc4CmRtZXNnLWt2
bS1sa3Atc2J4MDQtMTQ1ODMtMjAxMzA2MjMwMzM4MDEtMy4xMC4wLXJjNi1uZXh0LTIwMTMw
NjIxLTc4CmRtZXNnLWt2bS1sa3AtbmV4MDQtNjkxMC0yMDEzMDYyMjIzMzUzMS0zLjEwLjAt
cmM2LW5leHQtMjAxMzA2MjEtNzgKZG1lc2cta3ZtLWxrcC1uZXgwNC03MDMxLTIwMTMwNjIy
MjMzNTE2LTMuMTAuMC1yYzYtbmV4dC0yMDEzMDYyMS03OApkbWVzZy1rdm0tbGtwLW5leDA0
LTcyNzktMjAxMzA2MjIyMzM1MjItMy4xMC4wLXJjNi1uZXh0LTIwMTMwNjIxLTc4Cgo=

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc1 Kernel Configuration
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_ALWAYS_USE_PERSISTENT_CLOCK=y
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
# CONFIG_NO_HZ_FULL is not set
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
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_RCU_USER_QS is not set
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
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
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
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
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_KVM_GUEST=y
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
# CONFIG_X86_64_ACPI_NUMA is not set
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_MIGRATION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
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
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_PCIEAER is not set
# CONFIG_ACPI_APEI_EINJ is not set
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_BINFMT_SCRIPT is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
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
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
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
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
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
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
CONFIG_MTD_MAP_BANK_WIDTH_8=y
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
CONFIG_MTD_TS5500=y
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=y
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ALAUDA=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
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
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

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
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM80X_ONKEY is not set
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_DA9055_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_IMS_PCU=y
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y

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
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
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
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
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
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
# CONFIG_IPMI_SI is not set
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
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
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_INTEL_MID=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
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
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
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
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_TWL4030_MADC is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_DA9055=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_REGULATOR_WM8400 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_TTM is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
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
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_HYPERV is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_PANDORA=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_PS3REMOTE=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_WIIMOTE_EXT is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
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
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
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
CONFIG_USB_MDC800=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=y
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_MAX77686=y
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
# CONFIG_RTC_DRV_TPS80031 is not set
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DA9055 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_WM831X is not set
# CONFIG_RTC_DRV_WM8350 is not set
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
# CONFIG_DW_DMAC is not set
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
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_BALLOON=y

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_MCE_LOG=y
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
CONFIG_ASUS_OLED=y
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

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ZSMALLOC is not set
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
CONFIG_SYNC=y
# CONFIG_SW_SYNC is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX8997=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
# CONFIG_TI_ADC081C is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5380=y
CONFIG_AD5446=y
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_SENSORS_LM3533 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y
CONFIG_HID_SENSOR_ALS=y

#
# Magnetometer sensors
#
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
CONFIG_PWM=y
CONFIG_PWM_TWL=y
# CONFIG_PWM_TWL_LED is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
# CONFIG_EFI_VARS_PSTORE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
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
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
CONFIG_EFIVAR_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_MEMORY_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_PAGEALLOC is not set
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
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
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
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
# CONFIG_CRYPTO_TWOFISH_AVX2_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
# CONFIG_XZ_DEC_BCJ is not set
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_UCS2_STRING=y
# CONFIG_ATA_SFF is not set
# CONFIG_ISDN_DRV_LOOP is not set

--8t9RHnE3ZwKMSgU+--
