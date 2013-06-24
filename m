Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab3FXELH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 00:11:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24931 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3FXELE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 00:11:04 -0400
Message-ID: <51C7C6A0.1040906@oracle.com>
Date: Mon, 24 Jun 2013 00:10:08 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: sched: hang on boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've tried booting a KVM guest with 32 vcpus, and am getting the hang below.

I'll dig further into that tomorrow, just hoping it sounds familiar to anyone.

[   36.770000] BUG: soft lockup - CPU#1 stuck for 23s! [watchdog/1:111]
[   36.770000] Modules linked in:
[   36.770000] irq event stamp: 7275
[   36.770000] hardirqs last  enabled at (7274): [<ffffffff854fa3b7>] restore_args+0x0/0x30
[   36.770000] hardirqs last disabled at (7275): [<ffffffff85507f2d>] apic_timer_interrupt+0x6d/0x80
[   36.770000] softirqs last  enabled at (7170): [<ffffffff811801b1>] __do_softirq+0x641/0x700
[   36.770000] softirqs last disabled at (7173): [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   36.770000] CPU: 1 PID: 111 Comm: watchdog/1 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   36.770000] task: ffff880fcc57b000 ti: ffff880fcc580000 task.ti: ffff880fcc580000
[   36.770000] RIP: 0010:[<ffffffff811ed77a>]  [<ffffffff811ed77a>] load_balance+0x5ba/0xb10
[   36.770000] RSP: 0000:ffff880fe3803d38  EFLAGS: 00000246
[   36.770000] RAX: 0000000000000000 RBX: ffffffff854fa3b7 RCX: 0000000000001a1c
[   36.770000] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000246
[   36.770000] RBP: ffff880fe3803e18 R08: 0000000000000000 R09: 0000000000000000
[   36.770000] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880fe3803ca8
[   36.770000] R13: ffffffff85507f32 R14: ffff880fe3803e18 R15: ffff880fe55d7940
[   36.770000] FS:  0000000000000000(0000) GS:ffff880fe3800000(0000) knlGS:0000000000000000
[   36.770000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   36.770000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   36.770000] Stack:
[   36.770000]  0000000000000000 ffff880fe3803d98 0000000000000082 ffff880f00000000
[   36.770000]  00000000001d7940 ffff880fe3803e64 ffffffff81291e89 00000001854fa3b7
[   36.770000]  00000000001d7940 0000000100000102 ffff880fe3018600 0000000000000246
[   36.770000] Call Trace:
[   36.770000]  <IRQ>
[   36.770000]  [<ffffffff81291e89>] ? rcu_irq_exit+0x339/0x3b0
[   36.770000]  [<ffffffff811edfc0>] rebalance_domains+0x2f0/0x4e0
[   36.770000]  [<ffffffff811edcd0>] ? load_balance+0xb10/0xb10
[   36.770000]  [<ffffffff811ee418>] run_rebalance_domains+0x48/0x60
[   36.770000]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   36.770000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   36.770000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   36.770000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   36.770000]  <EOI>
[   36.770000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   36.770000]  [<ffffffff854f913e>] ? _raw_spin_unlock_irq+0x6e/0xc0
[   36.770000]  [<ffffffff854f911d>] ? _raw_spin_unlock_irq+0x4d/0xc0
[   36.770000]  [<ffffffff811d36ef>] finish_task_switch+0xcf/0x1f0
[   36.770000]  [<ffffffff811d36b1>] ? finish_task_switch+0x91/0x1f0
[   36.770000]  [<ffffffff854f6160>] __schedule+0xcc0/0xe80
[   36.770000]  [<ffffffff811e0e38>] ? local_clock+0x118/0x170
[   36.770000]  [<ffffffff854f6575>] schedule+0x65/0x90
[   36.770000]  [<ffffffff811cd1da>] smpboot_thread_fn+0x4da/0x570
[   36.770000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   36.770000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   36.770000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   36.770000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   36.770000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   36.770000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   36.770000] Code: 48 63 d0 48 83 c2 02 48 8b 0c d5 d8 23 bc 88 48 ff c1 85 c0 48 89 0c d5 d8 23 
bc 88 74 04 0f 0b eb fe 48 8b bd 78 ff ff ff 57 9d <66> 66 90 66 90 45 85 ff 0f 84 b9 04 00 00 8b 45 
94 89 85 78 ff
[   36.770000] sending NMI to all CPUs:
[   37.100870] NMI backtrace for cpu 0
[   37.102942] CPU: 0 PID: 110 Comm: watchdog/0 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.106276] task: ffff880fccb93000 ti: ffff880fcc488000 task.ti: ffff880fcc488000
[   37.108506] RIP: 0010:[<ffffffff811cd731>]  [<ffffffff811cd731>] sched_avg_update+0x1/0x70
[   37.110000] RSP: 0000:ffff880fe3603cc0  EFLAGS: 00000002
[   37.110000] RAX: 0000000000000003 RBX: ffffffff88bbd510 RCX: 0000000000000004
[   37.110000] RDX: 000000000006d438 RSI: 0000000000000400 RDI: ffff880fe37d7940
[   37.110000] RBP: ffff880fe3603d30 R08: ffff880fe37d7960 R09: ffffffff85662d25
[   37.110000] R10: 0000000000000010 R11: 0000000000000001 R12: 0000000000000400
[   37.110000] R13: 0000000000000400 R14: 000000000005f47a R15: 0000000000000000
[   37.110000] FS:  0000000000000000(0000) GS:ffff880fe3600000(0000) knlGS:0000000000000000
[   37.110000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.110000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006f0
[   37.110000] Stack:
[   37.110000]  ffff880fe3603d30 ffffffff811e01fd ffff880fe3603d30 00ffffff811e0cdf
[   37.110000]  000000000006d434 0000000000000000 0000000000000001 0000000000000000
[   37.110000]  ffff880fe37d7940 ffff880fe37d7940 0000000000000000 ffff880fccb93000
[   37.110000] Call Trace:
[   37.110000]  <IRQ>
[   37.110000]  [<ffffffff811e01fd>] ? __update_cpu_load+0x1dd/0x1f0
[   37.110000]  [<ffffffff811e023d>] update_cpu_load_active+0x2d/0xe0
[   37.110000]  [<ffffffff811d16c6>] scheduler_tick+0x56/0xb0
[   37.110000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.110000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.110000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.110000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.110000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.110000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.110000]  [<ffffffff8117fc76>] ? __do_softirq+0x106/0x700
[   37.110000]  [<ffffffff8117fc50>] ? __do_softirq+0xe0/0x700
[   37.110000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.110000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.110000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.110000]  <EOI>
[   37.110000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.110000]  [<ffffffff811e0e77>] ? local_clock+0x157/0x170
[   37.110000]  [<ffffffff812796d0>] watchdog+0x20/0x30
[   37.110000]  [<ffffffff811cd24e>] smpboot_thread_fn+0x54e/0x570
[   37.110000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.110000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.110000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.110000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.110000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.110000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.110000] Code: 96 d5 00 48 c7 c7 e0 85 c6 87 e8 cb 51 32 04 48 83 c4 28 44 89 e0 5b 41 5c 41 
5d 41 5e 41 5f c9 c3 90 90 90 90 90 90 90 90 90 55 <48> 89 e5 66 66 66 66 90 8b 0d 99 d1 2b 09 48 8b 
87 b0 09 00 00
[   36.770000] NMI backtrace for cpu 1
[   36.770000] CPU: 1 PID: 111 Comm: watchdog/1 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   36.770000] task: ffff880fcc57b000 ti: ffff880fcc580000 task.ti: ffff880fcc580000
[   36.770000] RIP: 0010:[<ffffffff810e558a>]  [<ffffffff810e558a>] native_write_msr_safe+0xa/0x10
[   36.770000] RSP: 0000:ffff880fe3803a50  EFLAGS: 00000046
[   36.770000] RAX: 0000000000000400 RBX: 0000000000000001 RCX: 0000000000000830
[   36.770000] RDX: 0000000000000001 RSI: 0000000000000400 RDI: 0000000000000830
[   36.770000] RBP: ffff880fe3803a50 R08: ffffffff8a48a280 R09: 0000000000000000
[   36.770000] R10: 0000000000000001 R11: 0000000000000001 R12: 000000000000b024
[   36.770000] R13: 0000000000000046 R14: 0000000000000002 R15: ffffffff88b71f70
[   36.770000] FS:  0000000000000000(0000) GS:ffff880fe3800000(0000) knlGS:0000000000000000
[   36.770000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   36.770000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   36.770000] Stack:
[   36.770000]  ffff880fe3803ae0 ffffffff810dbeb3 ffff880fe3803a70 0000000000000000
[   36.770000]  ffffffff88b6ea28 ffff880f00000000 0000000000000400 0000000000000002
[   36.770000]  00080000e3803af0 ffffffff8a48a280 0000000000000001 00000001e3803b00
[   36.770000] Call Trace:
[   36.770000]  <IRQ>
[   36.770000]  [<ffffffff810dbeb3>] __x2apic_send_IPI_mask+0x193/0x330
[   36.770000]  [<ffffffff810dc06c>] x2apic_send_IPI_all+0x1c/0x20
[   36.770000]  [<ffffffff810d4f26>] arch_trigger_all_cpu_backtrace+0x96/0x100
[   36.770000]  [<ffffffff812798e9>] watchdog_timer_fn+0x209/0x270
[   36.770000]  [<ffffffff811c35a2>] __run_hrtimer+0x382/0x630
[   36.770000]  [<ffffffff812796e0>] ? watchdog+0x30/0x30
[   36.770000]  [<ffffffff811c39c8>] hrtimer_run_queues+0x178/0x1b0
[   36.770000]  [<ffffffff811e2241>] ? vtime_account_system+0x61/0x70
[   36.770000]  [<ffffffff8118be4e>] run_local_timers+0xe/0x20
[   36.770000]  [<ffffffff8118be9d>] update_process_times+0x3d/0xa0
[   36.770000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   36.770000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   36.770000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   36.770000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   36.770000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   36.770000]  [<ffffffff811ed77a>] ? load_balance+0x5ba/0xb10
[   36.770000]  [<ffffffff81291e89>] ? rcu_irq_exit+0x339/0x3b0
[   36.770000]  [<ffffffff811edfc0>] rebalance_domains+0x2f0/0x4e0
[   36.770000]  [<ffffffff811edcd0>] ? load_balance+0xb10/0xb10
[   36.770000]  [<ffffffff811ee418>] run_rebalance_domains+0x48/0x60
[   36.770000]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   36.770000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   36.770000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   36.770000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   36.770000]  <EOI>
[   36.770000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   36.770000]  [<ffffffff854f913e>] ? _raw_spin_unlock_irq+0x6e/0xc0
[   36.770000]  [<ffffffff854f911d>] ? _raw_spin_unlock_irq+0x4d/0xc0
[   36.770000]  [<ffffffff811d36ef>] finish_task_switch+0xcf/0x1f0
[   36.770000]  [<ffffffff811d36b1>] ? finish_task_switch+0x91/0x1f0
[   36.770000]  [<ffffffff854f6160>] __schedule+0xcc0/0xe80
[   36.770000]  [<ffffffff811e0e38>] ? local_clock+0x118/0x170
[   36.770000]  [<ffffffff854f6575>] schedule+0x65/0x90
[   36.770000]  [<ffffffff811cd1da>] smpboot_thread_fn+0x4da/0x570
[   36.770000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   36.770000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   36.770000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   36.770000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   36.770000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   36.770000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   36.770000] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 
c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 
c9 48 89 d0 89
[   37.453919] NMI backtrace for cpu 2
[   37.453919] CPU: 2 PID: 120 Comm: ksoftirqd/2 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.453919] task: ffff880fcc5c8000 ti: ffff880fcc5be000 task.ti: ffff880fcc5be000
[   37.453919] RIP: 0010:[<ffffffff812ceef0>]  [<ffffffff812ceef0>] all_branch_stat_next+0x30/0x30
[   37.453919] RSP: 0000:ffff880fe3a03df0  EFLAGS: 00000046
[   37.453919] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000002
[   37.453919] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff88806610
[   37.454617] RBP: ffff880fe3a03e18 R08: ffffffff88b77178 R09: 0000000000000001
[   37.455599] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880fcc5bffd8
[   37.456515] R13: 0000000000000000 R14: ffffffff811d16e0 R15: 0000000000000001
[   37.457466] FS:  0000000000000000(0000) GS:ffff880fe3a00000(0000) knlGS:0000000000000000
[   37.458560] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.459314] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffffffff85500450 00000000000103a0 0000000000000000 ffff880fcc5c8978
[   37.460000]  0000000000000001 ffff880fe3a03e28 ffffffff81224f9e ffff880fe3a03e48
[   37.460000]  ffffffff812294e0 ffff880fcc5c8000 ffff880fcc5c8000 ffff880fe3a03e78
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff85500450>] ? sub_preempt_count+0x190/0x200
[   37.460000]  [<ffffffff81224f9e>] put_lock_stats+0xe/0x40
[   37.460000]  [<ffffffff812294e0>] lock_release_holdtime+0x130/0x140
[   37.460000]  [<ffffffff8122beab>] __lock_release+0x18b/0x1f0
[   37.460000]  [<ffffffff811d16e0>] ? scheduler_tick+0x70/0xb0
[   37.460000]  [<ffffffff8122c05e>] lock_release+0x14e/0x1a0
[   37.460000]  [<ffffffff854f9073>] _raw_spin_unlock+0x23/0x80
[   37.460000]  [<ffffffff811d16e0>] scheduler_tick+0x70/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff811d36ef>] ? finish_task_switch+0xcf/0x1f0
[   37.460000]  [<ffffffff854f913e>] ? _raw_spin_unlock_irq+0x6e/0xc0
[   37.460000]  [<ffffffff854f911d>] ? _raw_spin_unlock_irq+0x4d/0xc0
[   37.460000]  [<ffffffff811d36ef>] finish_task_switch+0xcf/0x1f0
[   37.460000]  [<ffffffff811d36b1>] ? finish_task_switch+0x91/0x1f0
[   37.460000]  [<ffffffff854f6160>] __schedule+0xcc0/0xe80
[   37.460000]  [<ffffffff854f6575>] schedule+0x65/0x90
[   37.460000]  [<ffffffff811cd1da>] smpboot_thread_fn+0x4da/0x570
[   37.460000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.460000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.460000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000] Code: 31 d2 48 89 e5 48 81 ff 38 de 47 8a 0f 93 c2 48 63 c2 48 83 c0 02 48 ff 04 c5 
98 86 c1 88 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 <31> c0 55 39 d6 48 89 e5 0f 94 c0 48 63 d0 48 83 
c2 02 48 ff 04
[   37.460000] NMI backtrace for cpu 3
[   37.460000] CPU: 3 PID: 126 Comm: ksoftirqd/3 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc5f8000 ti: ffff880fcc5f2000 task.ti: ffff880fcc5f2000
[   37.460000] RIP: 0010:[<ffffffff81f26858>]  [<ffffffff81f26858>] debug_smp_processor_id+0x18/0x1c0
[   37.460000] RSP: 0000:ffff880fe3c03e70  EFLAGS: 00000046
[   37.460000] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000001
[   37.460000] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff888e5860
[   37.460000] RBP: ffff880fe3c03e88 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880fe3dd7940
[   37.460000] R13: 0000000000000000 R14: 00000000001d7940 R15: 0000000000000003
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe3c00000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  0000000000000003 ffff880fe3dd7940 00000000ffff9971 ffff880fe3c03ed8
[   37.460000]  ffffffff811eee0a ffff880fe3c03ed8 ffffffff812f1306 0000000000000003
[   37.460000]  ffff880fe3dd7940 0000000000000003 ffff880fcc5f8000 ffff880fcc5f2000
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff811eee0a>] trigger_load_balance+0x12a/0x670
[   37.460000]  [<ffffffff812f1306>] ? perf_event_task_tick+0xc6/0x170
[   37.460000]  [<ffffffff811d16fe>] scheduler_tick+0x8e/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff811cd1f7>] ? smpboot_thread_fn+0x4f7/0x570
[   37.460000]  [<ffffffff811cd171>] ? smpboot_thread_fn+0x471/0x570
[   37.460000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.460000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.460000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000] Code: e8 ee 8a 47 ff c9 c3 90 90 90 90 90 90 90 90 90 90 90 90 55 ba 01 00 00 00 48 
89 e5 48 c7 c7 60 58 8e 88 41 55 45 31 ed 41 54 53 <65> 4c 8b 24 25 08 d9 00 00 48 83 ec 08 65 8b 1c 
25 20 b0 00 00
[   37.460000] NMI backtrace for cpu 4
[   37.460000] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc4ab000 ti: ffff880fcc4a4000 task.ti: ffff880fcc4a4000
[   37.460000] RIP: 0010:[<ffffffff812cef0a>]  [<ffffffff812cef0a>] ftrace_likely_update+0x1a/0x30
[   37.460000] RSP: 0000:ffff880fe3e038f0  EFLAGS: 00000002
[   37.460000] RAX: 0000000000000000 RBX: ffff880fcc4ab000 RCX: 0000000000000001
[   37.460000] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffffffff888141c0
[   37.460000] RBP: ffff880fe3e038f0 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[   37.460000] R13: 0000000000000000 R14: 0000000102e41dca R15: 0000000000000000
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe3e00000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe3e03940 ffffffff812a1042 ffff880fcc4ab000 0000000000000004
[   37.460000]  ffff880fe3e03950 ffff880fcc4ab000 00000000002393e7 0000000000000004
[   37.460000]  ffff880fe3e0fc80 0000000000000000 ffff880fe3e03950 ffffffff812a11dc
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff812a1042>] __acct_update_integrals+0x42/0x1c0
[   37.460000]  [<ffffffff812a11dc>] acct_account_cputime+0x1c/0x20
[   37.460000]  [<ffffffff811e17da>] account_system_time+0x1ba/0x230
[   37.460000]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.460000]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.460000]  [<ffffffff811e21c1>] vtime_account_irq_exit+0x81/0xa0
[   37.460000]  [<ffffffff811803ff>] irq_exit+0x5f/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff81f0b24e>] ? find_next_bit+0x1e/0x190
[   37.460000]  [<ffffffff81eed966>] cpumask_next_and+0x286/0x2b0
[   37.460000]  [<ffffffff811e6ace>] ? update_group_power+0x7e/0x170
[   37.460000]  [<ffffffff811eab79>] update_sd_lb_stats+0x619/0xa30
[   37.460000]  [<ffffffff811eafca>] find_busiest_group+0x3a/0x3f0
[   37.460000]  [<ffffffff811ed2e7>] load_balance+0x127/0xb10
[   37.460000]  [<ffffffff854f98f0>] ? _raw_spin_unlock_irqrestore+0xa0/0x140
[   37.460000]  [<ffffffff811edfc0>] rebalance_domains+0x2f0/0x4e0
[   37.460000]  [<ffffffff811edcd0>] ? load_balance+0xb10/0xb10
[   37.460000]  [<ffffffff811ee418>] run_rebalance_domains+0x48/0x60
[   37.460000]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   37.460000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: 98 86 c1 88 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 
94 c0 48 63 d0 48 83 c2 02 48 ff 04 d5 c0 86 c1 88 <85> c0 74 0a 48 ff 47 18 eb 08 0f 1f 40 00 48 ff 
47 20 c9 c3 66
[   37.460000] NMI backtrace for cpu 7
[   37.460000] CPU: 7 PID: 11 Comm: rcu_preempt Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc8b8000 ti: ffff880fcc8a6000 task.ti: ffff880fcc8a6000
[   37.460000] RIP: 0010:[<ffffffff812cef0a>]  [<ffffffff812cef0a>] ftrace_likely_update+0x1a/0x30
[   37.460000] RSP: 0000:ffff880fe4403e08  EFLAGS: 00000002
[   37.460000] RAX: 0000000000000001 RBX: ffff880fe45d7a00 RCX: 000000001dcd6500
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88807100
[   37.460000] RBP: ffff880fe4403e08 R08: ffff880fe45d7960 R09: ffffffff85662d25
[   37.460000] R10: 0000000000000010 R11: 0000000000000001 R12: 0000000000000000
[   37.460000] R13: ffff880fcc8b8048 R14: 00000008b831a680 R15: 0000000000000007
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe4400000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe4403e48 ffffffff811e59d1 0000000000000000 ffff880fe45d7a00
[   37.460000]  ffff880fcc8b8048 0000000000000000 ffff880fcc8b8000 0000000000000007
[   37.460000]  ffff880fe4403e78 ffffffff811e7827 ffff880fe4403eb8 ffff880fe45d7940
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff811e59d1>] update_curr+0x51/0x2e0
[   37.460000]  [<ffffffff811e7827>] entity_tick+0x27/0xf0
[   37.460000]  [<ffffffff811efeb3>] task_tick_fair+0x43/0x370
[   37.460000]  [<ffffffff81290ad0>] ? rcu_sched_qs+0x60/0x60
[   37.460000]  [<ffffffff81290ad0>] ? rcu_sched_qs+0x60/0x60
[   37.460000]  [<ffffffff811d16d8>] scheduler_tick+0x68/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff81290ad0>] ? rcu_sched_qs+0x60/0x60
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff81298346>] ? force_qs_rnp+0x1b6/0x240
[   37.460000]  [<ffffffff854f9937>] ? _raw_spin_unlock_irqrestore+0xe7/0x140
[   37.460000]  [<ffffffff81298346>] force_qs_rnp+0x1b6/0x240
[   37.460000]  [<ffffffff8129842c>] rcu_gp_fqs+0x5c/0xa0
[   37.460000]  [<ffffffff812987eb>] rcu_gp_kthread+0x37b/0x540
[   37.460000]  [<ffffffff811bdee0>] ? wake_up_bit+0x40/0x40
[   37.460000]  [<ffffffff81298470>] ? rcu_gp_fqs+0xa0/0xa0
[   37.460000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000] Code: 98 86 c1 88 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 
94 c0 48 63 d0 48 83 c2 02 48 ff 04 d5 c0 86 c1 88 <85> c0 74 0a 48 ff 47 18 eb 08 0f 1f 40 00 48 ff 
47 20 c9 c3 66
[   37.450000] NMI backtrace for cpu 5
[   37.450000] CPU: 5 PID: 138 Comm: ksoftirqd/5 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.450000] task: ffff880fcc680000 ti: ffff880fcc67c000 task.ti: ffff880fcc67c000
[   37.450000] RIP: 0010:[<ffffffff811e0675>]  [<ffffffff811e0675>] sched_clock_local+0xc5/0x100
[   37.450000] RSP: 0000:ffff880fe4003cc8  EFLAGS: 00000046
[   37.450000] RAX: 00000008b82976f0 RBX: ffff880fe41d8440 RCX: 00000008b82976f0
[   37.450000] RDX: 00000008b82976f0 RSI: ffffffffffe207ad RDI: 00000008b82976f0
[   37.450000] RBP: ffff880fe4003d08 R08: ffffffff88b77178 R09: 0000000000000003
[   37.450000] R10: 00000000001bc4f2 R11: 0000000000000000 R12: ffff880fe41d8450
[   37.450000] R13: 0000000000000000 R14: ffffffff88bbda38 R15: ffffffff88bbda60
[   37.450000] FS:  0000000000000000(0000) GS:ffff880fe4000000(0000) knlGS:0000000000000000
[   37.450000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.450000] CR2: ffff880fcbd5e000 CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.450000] Stack:
[   37.450000]  0000000000726e9d ffff880f00000000 ffff880fe4003d08 0000000000000000
[   37.450000]  0000000000000005 ffff880fe41d8440 00000000001d8440 0000000000000000
[   37.450000]  ffff880fe4003d68 ffffffff811e0cdf ffff880fe4003d38 ffffffff81098237
[   37.450000] Call Trace:
[   37.450000]  <IRQ>
[   37.450000]  [<ffffffff811e0cdf>] sched_clock_cpu+0x27f/0x2a0
[   37.450000]  [<ffffffff81098237>] ? sched_clock+0x47/0x50
[   37.450000]  [<ffffffff811e0dc2>] local_clock+0xa2/0x170
[   37.450000]  [<ffffffff8122b528>] __lock_acquire+0x2a8/0x580
[   37.450000]  [<ffffffff81098237>] ? sched_clock+0x47/0x50
[   37.450000]  [<ffffffff8122b98a>] lock_acquire+0x18a/0x1e0
[   37.450000]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.450000]  [<ffffffff811e0cdf>] ? sched_clock_cpu+0x27f/0x2a0
[   37.450000]  [<ffffffff811fcfc8>] cpuacct_account_field+0x48/0x280
[   37.450000]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.450000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.450000]  [<ffffffff811e17d2>] account_system_time+0x1b2/0x230
[   37.450000]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.450000]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.450000]  [<ffffffff811e2233>] vtime_account_system+0x53/0x70
[   37.450000]  [<ffffffff811e24e5>] vtime_account_irq_enter+0xb5/0xc0
[   37.450000]  [<ffffffff8117ee7f>] irq_enter+0x6f/0xa0
[   37.450000]  [<ffffffff855090fe>] smp_apic_timer_interrupt+0x3e/0xb0
[   37.450000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.450000]  <EOI>
[   37.450000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.450000]  [<ffffffff81180336>] ? run_ksoftirqd+0xc6/0x130
[   37.450000]  [<ffffffff81180317>] ? run_ksoftirqd+0xa7/0x130
[   37.450000]  [<ffffffff811cd24e>] smpboot_thread_fn+0x54e/0x570
[   37.450000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.450000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.450000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.450000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.450000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.450000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.450000] Code: fe 48 89 ce 48 29 c6 48 85 f6 48 89 d6 48 0f 4f c1 48 29 fe 48 85 f6 48 0f 4e 
d7 48 39 c2 48 0f 49 d0 48 89 c8 f0 49 0f b1 14 24 <48> 39 c1 0f 95 c0 0f b6 c0 48 63 c8 48 83 c1 02 
48 8b 34 cd 40
[   37.460000] NMI backtrace for cpu 8
[   37.460000] CPU: 8 PID: 0 Comm: swapper/8 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc4c3000 ti: ffff880fcc4bc000 task.ti: ffff880fcc4bc000
[   37.460000] RIP: 0010:[<ffffffff81098225>]  [<ffffffff81098225>] sched_clock+0x35/0x50
[   37.460000] RSP: 0000:ffff880fe4603d28  EFLAGS: 00000006
[   37.460000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000008
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff887f03d8
[   37.460000] RBP: ffff880fe4603d38 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880fe47d8450
[   37.460000] R13: 0000000000000000 R14: ffffffff88bbda38 R15: ffffffff88bbda60
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe4600000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  0000000000000000 ffff880fe47d8440 ffff880fe4603d88 ffffffff811e05e5
[   37.460000]  ffff880fe4603d78 ffff880fcc4c3000 ffff880fe4603d88 0000000000000000
[   37.460000]  0000000000000008 ffff880fe47d8440 00000000001d8440 0000000000000101
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff811e05e5>] sched_clock_local+0x35/0x100
[   37.460000]  [<ffffffff811e0cdf>] sched_clock_cpu+0x27f/0x2a0
[   37.460000]  [<ffffffff85500450>] ? sub_preempt_count+0x190/0x200
[   37.460000]  [<ffffffff811e0dc2>] local_clock+0xa2/0x170
[   37.460000]  [<ffffffff811e1226>] vtime_delta+0x16/0x50
[   37.460000]  [<ffffffff811e2185>] ? vtime_account_irq_exit+0x45/0xa0
[   37.460000]  [<ffffffff811e150c>] get_vtime_delta+0x2c/0x120
[   37.460000]  [<ffffffff811e1866>] __vtime_account_system+0x16/0x40
[   37.460000]  [<ffffffff811e21c1>] vtime_account_irq_exit+0x81/0xa0
[   37.460000]  [<ffffffff811801a7>] __do_softirq+0x637/0x700
[   37.460000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: e5 53 31 db 48 83 ec 08 48 83 3d b6 e8 ba 06 00 0f 94 c3 31 d2 89 de e8 da 6c 
23 00 48 63 c3 48 83 c0 02 48 ff 04 c5 a8 ce b4 88 <85> db 74 09 0f 0b 0f 1f 44 00 00 eb fe e8 29 d1 
04 00 66 90 59
[   37.450000] NMI backtrace for cpu 6
[   37.450000] CPU: 6 PID: 144 Comm: ksoftirqd/6 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.450000] task: ffff880fcc6c0000 ti: ffff880fcc6bc000 task.ti: ffff880fcc6bc000
[   37.450000] RIP: 0010:[<ffffffff810e6b94>]  [<ffffffff810e6b94>] pvclock_clocksource_read+0x84/0x140
[   37.450000] RSP: 0000:ffff880fe42039d0  EFLAGS: 00000017
[   37.450000] RAX: 0000000013cb888b RBX: 0000000016613e8a RCX: 0000000000000001
[   37.450000] RDX: 0000000000000000 RSI: 0000000000000012 RDI: ffff881027f52180
[   37.450000] RBP: ffff880fe42039f0 R08: ffffffff88b77178 R09: 0000000000000003
[   37.450000] R10: 00000000001bc4f3 R11: 0000000000000000 R12: ffff880fe43d8450
[   37.450000] R13: ffff880fcc6bdfd8 R14: ffffffff88bbda38 R15: ffffffff88bbda60
[   37.450000] FS:  0000000000000000(0000) GS:ffff880fe4200000(0000) knlGS:0000000000000000
[   37.450000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.450000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.450000] Stack:
[   37.450000]  ffff880fcc6bc000 ffff880fe43d8450 ffff880fcc6bdfd8 ffffffff88bbda38
[   37.450000]  ffff880fe4203a20 ffffffff810e539f ffff880fe4203a30 0000000000000000
[   37.450000]  ffff880fe43d8450 0000000000000000 ffff880fe4203a40 ffffffff81098237
[   37.450000] Call Trace:
[   37.450000]  <IRQ>
[   37.450000]  [<ffffffff810e539f>] kvm_clock_read+0x3f/0x90
[   37.450000]  [<ffffffff81098237>] sched_clock+0x47/0x50
[   37.450000]  [<ffffffff811e05e5>] sched_clock_local+0x35/0x100
[   37.450000]  [<ffffffff811e0cdf>] sched_clock_cpu+0x27f/0x2a0
[   37.450000]  [<ffffffff811e0604>] ? sched_clock_local+0x54/0x100
[   37.450000]  [<ffffffff811e0dc2>] local_clock+0xa2/0x170
[   37.450000]  [<ffffffff8122b528>] __lock_acquire+0x2a8/0x580
[   37.450000]  [<ffffffff811e0604>] ? sched_clock_local+0x54/0x100
[   37.450000]  [<ffffffff8122b98a>] lock_acquire+0x18a/0x1e0
[   37.450000]  [<ffffffff811c3933>] ? hrtimer_run_queues+0xe3/0x1b0
[   37.450000]  [<ffffffff854f89c0>] _raw_spin_lock+0x40/0x90
[   37.450000]  [<ffffffff811c3933>] ? hrtimer_run_queues+0xe3/0x1b0
[   37.450000]  [<ffffffff811c3933>] hrtimer_run_queues+0xe3/0x1b0
[   37.450000]  [<ffffffff811e2241>] ? vtime_account_system+0x61/0x70
[   37.450000]  [<ffffffff8118be4e>] run_local_timers+0xe/0x20
[   37.450000]  [<ffffffff8118be9d>] update_process_times+0x3d/0xa0
[   37.450000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.450000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.450000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.450000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.450000]  [<ffffffff8118f234>] ? run_timer_softirq+0x4c4/0x530
[   37.450000]  [<ffffffff854f913e>] ? _raw_spin_unlock_irq+0x6e/0xc0
[   37.450000]  [<ffffffff854f911d>] ? _raw_spin_unlock_irq+0x4d/0xc0
[   37.450000]  [<ffffffff8118f234>] run_timer_softirq+0x4c4/0x530
[   37.450000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.450000]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   37.450000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.450000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.450000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.450000]  <EOI>
[   37.450000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.450000]  [<ffffffff812cef0a>] ? ftrace_likely_update+0x1a/0x30
[   37.450000]  [<ffffffff8550057f>] add_preempt_count+0xbf/0x1c0
[   37.450000]  [<ffffffff811ccd64>] smpboot_thread_fn+0x64/0x570
[   37.450000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.450000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.450000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.450000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.450000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.450000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.450000] Code: c0 4f 89 54 c8 08 74 0f f7 d9 48 d3 eb eb 0b 0f 1f 84 00 00 00 00 00 48 d3 e3 
48 89 d8 89 d2 48 f7 e2 48 0f ac d0 20 0f b6 57 1d <48> 89 c3 48 03 5f 10 0f 1f 00 0f ae e8 8b 07 a8 
01 75 89 39 f0
[   37.460000] NMI backtrace for cpu 11
[   37.460000] CPU: 11 PID: 0 Comm: swapper/11 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc4d8000 ti: ffff880fcc4d2000 task.ti: ffff880fcc4d2000
[   37.460000] RIP: 0010:[<ffffffff811e0675>]  [<ffffffff811e0675>] sched_clock_local+0xc5/0x100
[   37.460000] RSP: 0000:ffff880fe4c03ce8  EFLAGS: 00000046
[   37.460000] RAX: 00000008b845b5d4 RBX: ffff880fe4dd8440 RCX: 00000008b845b5d4
[   37.460000] RDX: 00000008b845b5d4 RSI: fffffffffff3964a RDI: 00000008b845b5d4
[   37.460000] RBP: ffff880fe4c03d28 R08: ffffffff88b77178 R09: 0000000000000003
[   37.460000] R10: 00000000001bc4fa R11: 0000000000000000 R12: ffff880fe4dd8450
[   37.460000] R13: 0000000000000000 R14: ffffffff88bbda38 R15: ffffffff88bbda60
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe4c00000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  000000000007a59e 0000000000000000 ffff880fe4c03d28 0000000000000000
[   37.460000]  000000000000000b ffff880fe4dd8440 00000000001d8440 0000000000000000
[   37.460000]  ffff880fe4c03d88 ffffffff811e0cdf ffff880fe4c03d68 0000000000000000
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff811e0cdf>] sched_clock_cpu+0x27f/0x2a0
[   37.460000]  [<ffffffff811e0dc2>] local_clock+0xa2/0x170
[   37.460000]  [<ffffffff8122b528>] __lock_acquire+0x2a8/0x580
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff8122b98a>] lock_acquire+0x18a/0x1e0
[   37.460000]  [<ffffffff811d16b6>] ? scheduler_tick+0x46/0xb0
[   37.460000]  [<ffffffff854f89c0>] _raw_spin_lock+0x40/0x90
[   37.460000]  [<ffffffff811d16b6>] ? scheduler_tick+0x46/0xb0
[   37.460000]  [<ffffffff811d16b6>] scheduler_tick+0x46/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: fe 48 89 ce 48 29 c6 48 85 f6 48 89 d6 48 0f 4f c1 48 29 fe 48 85 f6 48 0f 4e 
d7 48 39 c2 48 0f 49 d0 48 89 c8 f0 49 0f b1 14 24 <48> 39 c1 0f 95 c0 0f b6 c0 48 63 c8 48 83 c1 02 
48 8b 34 cd 40
[   37.460000] NMI backtrace for cpu 9
[   37.460000] CPU: 9 PID: 162 Comm: ksoftirqd/9 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc750000 ti: ffff880fcc758000 task.ti: ffff880fcc758000
[   37.460000] RIP: 0010:[<ffffffff812cef12>]  [<ffffffff812cef12>] ftrace_likely_update+0x22/0x30
[   37.460000] RSP: 0000:ffff880fe4803e18  EFLAGS: 00000006
[   37.460000] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88806638
[   37.460000] RBP: ffff880fe4803e18 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880fcc759fd8
[   37.460000] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000009
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe4800000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe4803e48 ffffffff85500314 ffff880fe4803e48 ffff880fe49d0520
[   37.460000]  000000000000079d 00000000ffff9971 ffff880fe4803e68 ffffffff8128ebaa
[   37.460000]  0000000000000009 ffff880fe49d7940 ffff880fe4803e88 ffffffff811e3f8a
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff85500314>] sub_preempt_count+0x54/0x200
[   37.460000]  [<ffffffff8128ebaa>] rcu_is_cpu_idle+0x3a/0x90
[   37.460000]  [<ffffffff811e3f8a>] rcu_read_lock+0x4a/0x90
[   37.460000]  [<ffffffff811e3f40>] ? wake_affine+0x280/0x280
[   37.460000]  [<ffffffff811eedfe>] trigger_load_balance+0x11e/0x670
[   37.460000]  [<ffffffff812f1306>] ? perf_event_task_tick+0xc6/0x170
[   37.460000]  [<ffffffff811d16fe>] scheduler_tick+0x8e/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff854f6179>] ? __schedule+0xcd9/0xe80
[   37.460000]  [<ffffffff854f913e>] ? _raw_spin_unlock_irq+0x6e/0xc0
[   37.460000]  [<ffffffff854f911d>] ? _raw_spin_unlock_irq+0x4d/0xc0
[   37.460000]  [<ffffffff854f6179>] __schedule+0xcd9/0xe80
[   37.460000]  [<ffffffff81291e89>] ? rcu_irq_exit+0x339/0x3b0
[   37.460000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.460000]  [<ffffffff854f6ce1>] preempt_schedule_irq+0xc1/0x1b0
[   37.460000]  [<ffffffff854fa4e6>] retint_kernel+0x26/0x30
[   37.460000]  [<ffffffff81180336>] ? run_ksoftirqd+0xc6/0x130
[   37.460000]  [<ffffffff81180317>] ? run_ksoftirqd+0xa7/0x130
[   37.460000]  [<ffffffff811cd24e>] smpboot_thread_fn+0x54e/0x570
[   37.460000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.460000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.460000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000] Code: d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 94 c0 48 63 d0 48 83 c2 
02 48 ff 04 d5 c0 86 c1 88 85 c0 74 0a 48 ff 47 18 <eb> 08 0f 1f 40 00 48 ff 47 20 c9 c3 66 90 55 48 
c7 c6 dc d0 48
[   37.460000] NMI backtrace for cpu 14
[   37.460000] CPU: 14 PID: 0 Comm: swapper/14 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc4eb000 ti: ffff880fcc4f0000 task.ti: ffff880fcc4f0000
[   37.460000] RIP: 0010:[<ffffffff812cef0a>]  [<ffffffff812cef0a>] ftrace_likely_update+0x1a/0x30
[   37.460000] RSP: 0000:ffff880fe5203e58  EFLAGS: 00000006
[   37.460000] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88806688
[   37.460000] RBP: ffff880fe5203e58 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[   37.460000] R13: 0000000000000002 R14: ffff880fe520fc80 R15: 0000000000000000
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe5200000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe5203e78 ffffffff85500501 00000000000a03e0 ffff880fcc4eb000
[   37.460000]  ffff880fe5203e98 ffffffff8128eb86 00000000000a03e0 ffff880fcc4eb000
[   37.460000]  ffff880fe5203ed8 ffffffff811fcfe7 ffffffff811fcf80 ffffffff81f26882
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff85500501>] add_preempt_count+0x41/0x1c0
[   37.460000]  [<ffffffff8128eb86>] rcu_is_cpu_idle+0x16/0x90
[   37.460000]  [<ffffffff811fcfe7>] cpuacct_account_field+0x67/0x280
[   37.460000]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff811e17d2>] account_system_time+0x1b2/0x230
[   37.460000]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.460000]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.460000]  [<ffffffff811e21c1>] vtime_account_irq_exit+0x81/0xa0
[   37.460000]  [<ffffffff811803ff>] irq_exit+0x5f/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: 98 86 c1 88 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 
94 c0 48 63 d0 48 83 c2 02 48 ff 04 d5 c0 86 c1 88 <85> c0 74 0a 48 ff 47 18 eb 08 0f 1f 40 00 48 ff 
47 20 c9 c3 66
[   37.460000] NMI backtrace for cpu 15
[   37.460000] CPU: 15 PID: 198 Comm: ksoftirqd/15 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc0e0000 ti: ffff880fcc0da000 task.ti: ffff880fcc0da000
[   37.460000] RIP: 0010:[<ffffffff812cef12>]  [<ffffffff812cef12>] ftrace_likely_update+0x22/0x30
[   37.460000] RSP: 0000:ffff880fe5403c30  EFLAGS: 00000002
[   37.460000] RAX: 0000000000000001 RBX: ffff880fe55d7940 RCX: 0000000000000002
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff888e5518
[   37.460000] RBP: ffff880fe5403c30 R08: ffffffff88b77178 R09: 0000000000000001
[   37.460000] R10: 0000000000010102 R11: 0000000000000001 R12: 0000000000000000
[   37.460000] R13: ffff880fcc0e0000 R14: ffffffff88b9cfb8 R15: 000000000000000f
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe5400000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe5403c50 ffffffff81f243d6 ffff880fe55d7940 000000000000000f
[   37.460000]  ffff880fe5403c70 ffffffff854f907b ffffffff88b9cfb8 ffff880fe55d7940
[   37.460000]  ffff880fe5403ca0 ffffffff811d16e0 ffff880fe5403ca0 ffff880fcc0e0000
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff81f243d6>] do_raw_spin_unlock+0xf6/0x1c0
[   37.460000]  [<ffffffff854f907b>] _raw_spin_unlock+0x2b/0x80
[   37.460000]  [<ffffffff811d16e0>] scheduler_tick+0x70/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.460000]  [<ffffffff854f913e>] ? _raw_spin_unlock_irq+0x6e/0xc0
[   37.460000]  [<ffffffff854f911d>] ? _raw_spin_unlock_irq+0x4d/0xc0
[   37.460000]  [<ffffffff8118f234>] run_timer_softirq+0x4c4/0x530
[   37.460000]  [<ffffffff85500450>] ? sub_preempt_count+0x190/0x200
[   37.460000]  [<ffffffff8117fc35>] ? __do_softirq+0xc5/0x700
[   37.460000]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   37.460000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.460000]  [<ffffffff81180336>] ? run_ksoftirqd+0xc6/0x130
[   37.460000]  [<ffffffff81180317>] ? run_ksoftirqd+0xa7/0x130
[   37.460000]  [<ffffffff811cd24e>] smpboot_thread_fn+0x54e/0x570
[   37.460000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.460000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.460000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000] Code: d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 94 c0 48 63 d0 48 83 c2 
02 48 ff 04 d5 c0 86 c1 88 85 c0 74 0a 48 ff 47 18 <eb> 08 0f 1f 40 00 48 ff 47 20 c9 c3 66 90 55 48 
c7 c6 dc d0 48
[   37.460000] NMI backtrace for cpu 10
[   37.460000] CPU: 10 PID: 168 Comm: ksoftirqd/10 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc7a8000 ti: ffff880fcc7a4000 task.ti: ffff880fcc7a4000
[   37.460000] RIP: 0010:[<ffffffff810e5361>]  [<ffffffff810e5361>] kvm_clock_read+0x1/0x90
[   37.460000] RSP: 0000:ffff880fe4a03de8  EFLAGS: 00000046
[   37.460000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 000000000000000a
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff887f03d8
[   37.460000] RBP: ffff880fe4a03e08 R08: 0000000000000001 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000001 R12: ffff880fe4bd8450
[   37.460000] R13: 0000000000000000 R14: ffffffff88bbda38 R15: ffffffff88bbda60
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe4a00000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe4a03e08 ffffffff81098237 ffff880fcc7a8000 ffff880fe4bd8440
[   37.460000]  ffff880fe4a03e58 ffffffff811e05e5 ffff880fe4a03e78 ffffffff81227754
[   37.460000]  ffff880fe4a03e58 0000000000000000 000000000000000a ffff880fe4bd8440
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff81098237>] ? sched_clock+0x47/0x50
[   37.460000]  [<ffffffff811e05e5>] sched_clock_local+0x35/0x100
[   37.460000]  [<ffffffff81227754>] ? __lock_acquired+0x2b4/0x2f0
[   37.460000]  [<ffffffff811e0cdf>] sched_clock_cpu+0x27f/0x2a0
[   37.460000]  [<ffffffff811d16b6>] ? scheduler_tick+0x46/0xb0
[   37.460000]  [<ffffffff811d133b>] update_rq_clock+0x3b/0x60
[   37.460000]  [<ffffffff811d16be>] scheduler_tick+0x4e/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff811d36ef>] ? finish_task_switch+0xcf/0x1f0
[   37.460000]  [<ffffffff854f913e>] ? _raw_spin_unlock_irq+0x6e/0xc0
[   37.460000]  [<ffffffff854f911d>] ? _raw_spin_unlock_irq+0x4d/0xc0
[   37.460000]  [<ffffffff811d36ef>] finish_task_switch+0xcf/0x1f0
[   37.460000]  [<ffffffff811d36b1>] ? finish_task_switch+0x91/0x1f0
[   37.460000]  [<ffffffff854f6160>] __schedule+0xcc0/0xe80
[   37.460000]  [<ffffffff854f6575>] schedule+0x65/0x90
[   37.460000]  [<ffffffff811cd1da>] smpboot_thread_fn+0x4da/0x570
[   37.460000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.460000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.460000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000] Code: 48 8b 5d e8 4c 8b 6d f8 c9 c3 55 48 c7 c7 84 77 46 87 48 89 e5 e8 40 ff ff ff 
c9 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 <48> 89 e5 48 83 ec 20 48 89 5d e8 4c 89 6d f8 4c 
89 65 f0 65 4c
[   37.450000] NMI backtrace for cpu 12
[   37.450000] CPU: 12 PID: 0 Comm: swapper/12 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.450000] task: ffff880fcc4db000 ti: ffff880fcc4d4000 task.ti: ffff880fcc4d4000
[   37.450000] RIP: 0010:[<ffffffff812cef0a>]  [<ffffffff812cef0a>] ftrace_likely_update+0x1a/0x30
[   37.450000] RSP: 0000:ffff880fe4e03b70  EFLAGS: 00000002
[   37.450000] RAX: 0000000000000001 RBX: 0000000000000046 RCX: 0000000000000002
[   37.450000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88806b10
[   37.450000] RBP: ffff880fe4e03b70 R08: ffffffff88b77178 R09: 0000000000000003
[   37.450000] R10: 00000000001bc4fa R11: 0000000000000000 R12: 00000008b831a680
[   37.450000] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   37.450000] FS:  0000000000000000(0000) GS:ffff880fe4e00000(0000) knlGS:0000000000000000
[   37.450000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.450000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.450000] Stack:
[   37.450000]  ffff880fe4e03ba0 ffffffff811e0e06 0000000c00000000 ffff880fcc4db000
[   37.450000]  0000000000000000 0000000000000000 ffff880fe4e03bc0 ffffffff811e1226
[   37.450000]  ffffffff811e2225 ffff880fcc4db000 ffff880fe4e03c00 ffffffff811e150c
[   37.450000] Call Trace:
[   37.450000]  <IRQ>
[   37.450000]  [<ffffffff811e0e06>] local_clock+0xe6/0x170
[   37.450000]  [<ffffffff811e1226>] vtime_delta+0x16/0x50
[   37.450000]  [<ffffffff811e2225>] ? vtime_account_system+0x45/0x70
[   37.450000]  [<ffffffff811e150c>] get_vtime_delta+0x2c/0x120
[   37.450000]  [<ffffffff811e1866>] __vtime_account_system+0x16/0x40
[   37.450000]  [<ffffffff811e2233>] vtime_account_system+0x53/0x70
[   37.450000]  [<ffffffff811e24e5>] vtime_account_irq_enter+0xb5/0xc0
[   37.450000]  [<ffffffff8117ee7f>] irq_enter+0x6f/0xa0
[   37.450000]  [<ffffffff855090fe>] smp_apic_timer_interrupt+0x3e/0xb0
[   37.450000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.450000]  [<ffffffff81229c19>] ? mark_held_locks+0x109/0x140
[   37.450000]  [<ffffffff811ed77a>] ? load_balance+0x5ba/0xb10
[   37.450000]  [<ffffffff854f98f0>] ? _raw_spin_unlock_irqrestore+0xa0/0x140
[   37.450000]  [<ffffffff811edfc0>] rebalance_domains+0x2f0/0x4e0
[   37.450000]  [<ffffffff811edcd0>] ? load_balance+0xb10/0xb10
[   37.450000]  [<ffffffff811ee418>] run_rebalance_domains+0x48/0x60
[   37.450000]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   37.450000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.450000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.450000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.450000]  <EOI>
[   37.450000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.450000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.450000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.450000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.450000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.450000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.450000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.450000] Code: 98 86 c1 88 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 
94 c0 48 63 d0 48 83 c2 02 48 ff 04 d5 c0 86 c1 88 <85> c0 74 0a 48 ff 47 18 eb 08 0f 1f 40 00 48 ff 
47 20 c9 c3 66
[   37.440000] NMI backtrace for cpu 13
[   37.440000] CPU: 13 PID: 0 Comm: swapper/13 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.440000] task: ffff880fcc4e8000 ti: ffff880fcc4d6000 task.ti: ffff880fcc4d6000
[   37.440000] RIP: 0010:[<ffffffff812cef0a>]  [<ffffffff812cef0a>] ftrace_likely_update+0x1a/0x30
[   37.440000] RSP: 0000:ffff880fcc4d7bb8  EFLAGS: 00000006
[   37.440000] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
[   37.440000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88806688
[   37.440000] RBP: ffff880fcc4d7bb8 R08: 0000000000000000 R09: 0000000000000000
[   37.440000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[   37.440000] R13: 0000000000000002 R14: ffffffff87c6a420 R15: 0000000000000001
[   37.440000] FS:  0000000000000000(0000) GS:ffff880fe5000000(0000) knlGS:0000000000000000
[   37.440000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.440000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.440000] Stack:
[   37.440000]  ffff880fcc4d7bd8 ffffffff85500501 ffff880fcc4e8000 0000000000005854
[   37.440000]  ffff880fcc4d7c38 ffffffff81f02433 ffff880fcc4e8000 ffff880fcc4e8038
[   37.440000]  0000000000000001 ffffffff811fd170 ffff880fcc4d7c38 ffff880fcc4e8000
[   37.440000] Call Trace:
[   37.440000]  [<ffffffff85500501>] add_preempt_count+0x41/0x1c0
[   37.440000]  [<ffffffff81f02433>] delay_tsc+0x23/0x290
[   37.440000]  [<ffffffff811fd170>] ? cpuacct_account_field+0x1f0/0x280
[   37.440000]  [<ffffffff81f02319>] __const_udelay+0x29/0x30
[   37.440000]  [<ffffffff811b4b84>] __rcu_read_unlock+0x64/0x190
[   37.440000]  [<ffffffff811fd18d>] cpuacct_account_field+0x20d/0x280
[   37.440000]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.440000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.440000]  [<ffffffff811e17d2>] account_system_time+0x1b2/0x230
[   37.440000]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.440000]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.440000]  [<ffffffff811e2233>] vtime_account_system+0x53/0x70
[   37.440000]  [<ffffffff811e22b5>] vtime_task_switch+0x65/0x80
[   37.440000]  [<ffffffff811d365c>] finish_task_switch+0x3c/0x1f0
[   37.440000]  [<ffffffff854f6160>] __schedule+0xcc0/0xe80
[   37.440000]  [<ffffffff8122022c>] ? tick_nohz_idle_exit+0x22c/0x2b0
[   37.440000]  [<ffffffff854f6575>] schedule+0x65/0x90
[   37.440000]  [<ffffffff854f6c08>] schedule_preempt_disabled+0x18/0x30
[   37.440000]  [<ffffffff8120d60e>] cpu_idle_loop+0x8ae/0x9a0
[   37.440000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.440000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.440000] Code: 98 86 c1 88 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 
94 c0 48 63 d0 48 83 c2 02 48 ff 04 d5 c0 86 c1 88 <85> c0 74 0a 48 ff 47 18 eb 08 0f 1f 40 00 48 ff 
47 20 c9 c3 66
[   37.460000] NMI backtrace for cpu 16
[   37.460000] CPU: 16 PID: 0 Comm: swapper/16 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc4fb000 ti: ffff880fcc4f4000 task.ti: ffff880fcc4f4000
[   37.460000] RIP: 0010:[<ffffffff810e56c6>]  [<ffffffff810e56c6>] native_safe_halt+0x6/0x10
[   37.460000] RSP: 0000:ffff880fcc4f5e28  EFLAGS: 00000246
[   37.460000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff887f0608
[   37.460000] RBP: ffff880fcc4f5e28 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000010
[   37.460000] R13: ffff880fcc4f4000 R14: ffffffff88bce5b8 R15: 0000000000000000
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe5600000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fcc4f5e58 ffffffff8109b6f7 ffff880fcc4f4000 ffff880fcc4f4000
[   37.460000]  ffff880fcc4f4010 ffff880fcc4f4000 ffff880fcc4f5e78 ffffffff8109ae74
[   37.460000]  ffff880fcc4f4000 ffff880fcc4f4000 ffff880fcc4f5ef8 ffffffff8120d425
[   37.460000] Call Trace:
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: 00 00 00 00 00 55 48 89 e5 fa c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 
c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <c9> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 c9 
c3 66 0f 1f 84
[   37.460000] NMI backtrace for cpu 17
[   37.460000] CPU: 17 PID: 0 Comm: swapper/17 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc500000 ti: ffff880fcc4f6000 task.ti: ffff880fcc4f6000
[   37.460000] RIP: 0010:[<ffffffff812cef0a>]  [<ffffffff812cef0a>] ftrace_likely_update+0x1a/0x30
[   37.460000] RSP: 0000:ffff880fe5803df8  EFLAGS: 00000002
[   37.460000] RAX: 0000000000000001 RBX: 0000000000000046 RCX: 0000000000000000
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88806ae8
[   37.460000] RBP: ffff880fe5803df8 R08: 0000000000000000 R09: 0000000000000001
[   37.460000] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[   37.460000] R13: 0000000000000001 R14: ffffffff811d16e0 R15: 0000000000000001
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe5800000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe5803e28 ffffffff811e0d8c ffff880fe5803e58 ffff880fcc500000
[   37.460000]  ffff880fcc500978 0000000000000001 ffff880fe5803e48 ffffffff812293d7
[   37.460000]  ffff880fcc500000 ffff880fcc500000 ffff880fe5803e78 ffffffff8122beab
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff811e0d8c>] local_clock+0x6c/0x170
[   37.460000]  [<ffffffff812293d7>] lock_release_holdtime+0x27/0x140
[   37.460000]  [<ffffffff8122beab>] __lock_release+0x18b/0x1f0
[   37.460000]  [<ffffffff811d16e0>] ? scheduler_tick+0x70/0xb0
[   37.460000]  [<ffffffff8122c05e>] lock_release+0x14e/0x1a0
[   37.460000]  [<ffffffff854f9073>] _raw_spin_unlock+0x23/0x80
[   37.460000]  [<ffffffff811d16e0>] scheduler_tick+0x70/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: 98 86 c1 88 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 
94 c0 48 63 d0 48 83 c2 02 48 ff 04 d5 c0 86 c1 88 <85> c0 74 0a 48 ff 47 18 eb 08 0f 1f 40 00 48 ff 
47 20 c9 c3 66
[   37.460000] NMI backtrace for cpu 20
[   37.460000] CPU: 20 PID: 0 Comm: swapper/20 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc51b000 ti: ffff880fcc524000 task.ti: ffff880fcc524000
[   37.460000] RIP: 0010:[<ffffffff811e0675>]  [<ffffffff811e0675>] sched_clock_local+0xc5/0x100
[   37.460000] RSP: 0000:ffff880fe5e03e68  EFLAGS: 00000046
[   37.460000] RAX: 00000008b841bfd0 RBX: ffff880fe5fd8440 RCX: 00000008b841bfd0
[   37.460000] RDX: 00000008b841bfd0 RSI: ffffffffffefe6b0 RDI: 00000008b841bfd0
[   37.460000] RBP: ffff880fe5e03ea8 R08: ffffffff88b77178 R09: 0000000000000003
[   37.460000] R10: 00000000001bc505 R11: 0000000000000001 R12: ffff880fe5fd8450
[   37.460000] R13: 0000000000000000 R14: ffffffff88bbda38 R15: ffffffff88bbda60
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe5e00000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  0000000000000000 0000000000000000 00000008b831a680 ffff880fe5fd8440
[   37.460000]  00000008b831a680 ffff880fcc51b000 ffffffff88bce5b8 0000000000000014
[   37.460000]  ffff880fe5e03ed8 ffffffff811e083e ffff880fe5e03ed8 ffff880fe5fd7940
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff811e083e>] sched_clock_tick+0x18e/0x1a0
[   37.460000]  [<ffffffff811d16ae>] scheduler_tick+0x3e/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: fe 48 89 ce 48 29 c6 48 85 f6 48 89 d6 48 0f 4f c1 48 29 fe 48 85 f6 48 0f 4e 
d7 48 39 c2 48 0f 49 d0 48 89 c8 f0 49 0f b1 14 24 <48> 39 c1 0f 95 c0 0f b6 c0 48 63 c8 48 83 c1 02 
48 8b 34 cd 40
[   37.460000] NMI backtrace for cpu 19
[   37.460000] CPU: 19 PID: 0 Comm: swapper/19 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc518000 ti: ffff880fcc512000 task.ti: ffff880fcc512000
[   37.460000] RIP: 0010:[<ffffffff85500485>]  [<ffffffff85500485>] sub_preempt_count+0x1c5/0x200
[   37.460000] RSP: 0000:ffff880fe5c03930  EFLAGS: 00000002
[   37.460000] RAX: ffff880fcc513fd8 RBX: 0000000000000001 RCX: 0000000000000001
[   37.460000] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffffffff88806610
[   37.460000] RBP: ffff880fe5c03950 R08: 0000000000000001 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880fcc513fd8
[   37.460000] R13: 0000000000000000 R14: ffffffff87c6a420 R15: 0000000000000001
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe5c00000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe5c03950 ffff880fe5dd0520 0000000000000ec1 0000000000000004
[   37.460000]  ffff880fe5c03970 ffffffff8128ebaa 000000000031e363 ffff880fcc518000
[   37.460000]  ffff880fe5c039b0 ffffffff811fd13d ffffffff811fcf80 ffffffff81f26882
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff8128ebaa>] rcu_is_cpu_idle+0x3a/0x90
[   37.460000]  [<ffffffff811fd13d>] cpuacct_account_field+0x1bd/0x280
[   37.460000]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff811e17d2>] account_system_time+0x1b2/0x230
[   37.460000]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.460000]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.460000]  [<ffffffff811e21c1>] vtime_account_irq_exit+0x81/0xa0
[   37.460000]  [<ffffffff811803ff>] irq_exit+0x5f/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff812cef0a>] ? ftrace_likely_update+0x1a/0x30
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff811ea6c5>] update_sd_lb_stats+0x165/0xa30
[   37.460000]  [<ffffffff810e53c3>] ? kvm_clock_read+0x63/0x90
[   37.460000]  [<ffffffff811e0cdf>] ? sched_clock_cpu+0x27f/0x2a0
[   37.460000]  [<ffffffff8122b74a>] ? __lock_acquire+0x4ca/0x580
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff85500450>] ? sub_preempt_count+0x190/0x200
[   37.460000]  [<ffffffff811eafca>] find_busiest_group+0x3a/0x3f0
[   37.460000]  [<ffffffff811ed2e7>] load_balance+0x127/0xb10
[   37.460000]  [<ffffffff854f98f0>] ? _raw_spin_unlock_irqrestore+0xa0/0x140
[   37.460000]  [<ffffffff811edfc0>] rebalance_domains+0x2f0/0x4e0
[   37.460000]  [<ffffffff811edcd0>] ? load_balance+0xb10/0xb10
[   37.460000]  [<ffffffff811ee418>] run_rebalance_domains+0x48/0x60
[   37.460000]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   37.460000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: 2a c1 6b 03 65 48 8b 04 25 08 d9 00 00 39 98 44 e0 ff ff 0f 94 c2 83 e2 01 48 
83 c2 02 48 ff 04 d5 d8 c4 bb 88 29 98 44 e0 ff ff <e9> 76 ff ff ff 66 0f 1f 44 00 00 48 ff 05 a1 c0 
6b 03 48 ff 05
[   37.460000] NMI backtrace for cpu 21
[   37.460000] CPU: 21 PID: 0 Comm: swapper/21 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc528000 ti: ffff880fcc526000 task.ti: ffff880fcc526000
[   37.460000] RIP: 0010:[<ffffffff812cef0a>]  [<ffffffff812cef0a>] ftrace_likely_update+0x1a/0x30
[   37.460000] RSP: 0000:ffff880fe6003e58  EFLAGS: 00000002
[   37.460000] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88806688
[   37.460000] RBP: ffff880fe6003e58 R08: 0000000000000001 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[   37.460000] R13: 0000000000000002 R14: ffffffff87c6a420 R15: 0000000000000000
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe6000000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe6003e78 ffffffff85500501 00000000001219e8 ffff880fcc528000
[   37.460000]  ffff880fe6003e98 ffffffff8128eb86 00000000001219e8 ffff880fcc528000
[   37.460000]  ffff880fe6003ed8 ffffffff811fd13d ffffffff811fcf80 ffffffff81f26882
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff85500501>] add_preempt_count+0x41/0x1c0
[   37.460000]  [<ffffffff8128eb86>] rcu_is_cpu_idle+0x16/0x90
[   37.460000]  [<ffffffff811fd13d>] cpuacct_account_field+0x1bd/0x280
[   37.460000]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff811e17d2>] account_system_time+0x1b2/0x230
[   37.460000]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.460000]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.460000]  [<ffffffff811e21c1>] vtime_account_irq_exit+0x81/0xa0
[   37.460000]  [<ffffffff811803ff>] irq_exit+0x5f/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: 98 86 c1 88 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 
94 c0 48 63 d0 48 83 c2 02 48 ff 04 d5 c0 86 c1 88 <85> c0 74 0a 48 ff 47 18 eb 08 0f 1f 40 00 48 ff 
47 20 c9 c3 66
[   37.460000] NMI backtrace for cpu 18
[   37.460000] CPU: 18 PID: 0 Comm: swapper/18 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc503000 ti: ffff880fcc510000 task.ti: ffff880fcc510000
[   37.460000] RIP: 0010:[<ffffffff81f26858>]  [<ffffffff81f26858>] debug_smp_processor_id+0x18/0x1c0
[   37.460000] RSP: 0000:ffff880fe5a03d60  EFLAGS: 00000046
[   37.460000] RAX: 0000000000000012 RBX: 0000000000000000 RCX: 0000000000000001
[   37.460000] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff888e5860
[   37.460000] RBP: ffff880fe5a03d78 R08: 0000000000000000 R09: 0000000000000001
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000012
[   37.460000] R13: 0000000000000000 R14: 00000000001d8440 R15: 0000000000000001
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe5a00000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  0000000000000000 0000000000000012 ffff880fe5bd8440 ffff880fe5a03dd8
[   37.460000]  ffffffff811e0bf3 ffff880fcc503000 000000000040e019 ffffffff87c66880
[   37.460000]  0000000000000001 ffff880fe5a03dd8 0000000000000046 0000000000000000
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff811e0bf3>] sched_clock_cpu+0x193/0x2a0
[   37.460000]  [<ffffffff811fd170>] ? cpuacct_account_field+0x1f0/0x280
[   37.460000]  [<ffffffff811e0dc2>] local_clock+0xa2/0x170
[   37.460000]  [<ffffffff812293d7>] lock_release_holdtime+0x27/0x140
[   37.460000]  [<ffffffff8122beab>] __lock_release+0x18b/0x1f0
[   37.460000]  [<ffffffff811fd170>] ? cpuacct_account_field+0x1f0/0x280
[   37.460000]  [<ffffffff8122c05e>] lock_release+0x14e/0x1a0
[   37.460000]  [<ffffffff811fd188>] cpuacct_account_field+0x208/0x280
[   37.460000]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff811e17d2>] account_system_time+0x1b2/0x230
[   37.460000]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.460000]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.460000]  [<ffffffff811e21c1>] vtime_account_irq_exit+0x81/0xa0
[   37.460000]  [<ffffffff811803ff>] irq_exit+0x5f/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: e8 ee 8a 47 ff c9 c3 90 90 90 90 90 90 90 90 90 90 90 90 55 ba 01 00 00 00 48 
89 e5 48 c7 c7 60 58 8e 88 41 55 45 31 ed 41 54 53 <65> 4c 8b 24 25 08 d9 00 00 48 83 ec 08 65 8b 1c 
25 20 b0 00 00
[   37.450000] NMI backtrace for cpu 23
[   37.450000] CPU: 23 PID: 0 Comm: swapper/23 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.450000] task: ffff880fcc538000 ti: ffff880fcc532000 task.ti: ffff880fcc532000
[   37.450000] RIP: 0010:[<ffffffff812cef0e>]  [<ffffffff812cef0e>] ftrace_likely_update+0x1e/0x30
[   37.450000] RSP: 0000:ffff880fe6403dc8  EFLAGS: 00000002
[   37.450000] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
[   37.450000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88813338
[   37.450000] RBP: ffff880fe6403dc8 R08: 0000000000000000 R09: 0000000000000000
[   37.450000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[   37.450000] R13: 0000000000000004 R14: ffffffff87c6a420 R15: 0000000000000101
[   37.450000] FS:  0000000000000000(0000) GS:ffff880fe6400000(0000) knlGS:0000000000000000
[   37.450000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.450000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.450000] Stack:
[   37.450000]  ffff880fe6403de8 ffffffff8128e515 0000000000062891 ffff880fcc538000
[   37.450000]  ffff880fe6403e28 ffffffff811fd087 ffffffff811fcf80 ffffffff81f26882
[   37.450000]  ffff880fcc538000 0000000000062891 0000000000000004 ffff880fe640fc80
[   37.450000] Call Trace:
[   37.450000]  <IRQ>
[   37.450000]  [<ffffffff8128e515>] rcu_lockdep_current_cpu_online+0xb5/0xe0
[   37.450000]  [<ffffffff811fd087>] cpuacct_account_field+0x107/0x280
[   37.450000]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.450000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.450000]  [<ffffffff811e17d2>] account_system_time+0x1b2/0x230
[   37.450000]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.450000]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.450000]  [<ffffffff811e21c1>] vtime_account_irq_exit+0x81/0xa0
[   37.450000]  [<ffffffff811801a7>] __do_softirq+0x637/0x700
[   37.450000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.450000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.450000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.450000]  <EOI>
[   37.450000]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.450000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.450000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.450000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.450000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.450000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.450000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.450000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.450000] Code: 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 31 c0 55 39 d6 48 89 e5 0f 94 c0 48 63 
d0 48 83 c2 02 48 ff 04 d5 c0 86 c1 88 85 c0 74 0a <48> ff 47 18 eb 08 0f 1f 40 00 48 ff 47 20 c9 c3 
66 90 55 48 c7
[   37.460000] NMI backtrace for cpu 22
[   37.460000] CPU: 22 PID: 240 Comm: ksoftirqd/22 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc268000 ti: ffff880fcc262000 task.ti: ffff880fcc262000
[   37.460000] RIP: 0010:[<ffffffff812ceef0>]  [<ffffffff812ceef0>] all_branch_stat_next+0x30/0x30
[   37.460000] RSP: 0000:ffff880fe6203a98  EFLAGS: 00000046
[   37.460000] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000002
[   37.460000] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff88806610
[   37.460000] RBP: ffff880fe6203ac0 R08: ffffffff88b77178 R09: 0000000000000001
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880fcc263fd8
[   37.460000] R13: 0000000000000000 R14: ffffffff811fcdd0 R15: 0000000000000001
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe6200000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffffffff85500450 00000000000103a0 000000000007a59e ffff880fcc2689b0
[   37.460000]  0000000000000001 ffff880fe6203ad0 ffffffff81224f9e ffff880fe6203af0
[   37.460000]  ffffffff812294e0 ffff880fcc268000 ffff880fcc268038 ffff880fe6203b20
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff85500450>] ? sub_preempt_count+0x190/0x200
[   37.460000]  [<ffffffff81224f9e>] put_lock_stats+0xe/0x40
[   37.460000]  [<ffffffff812294e0>] lock_release_holdtime+0x130/0x140
[   37.460000]  [<ffffffff8122beab>] __lock_release+0x18b/0x1f0
[   37.460000]  [<ffffffff811fcdd0>] ? cpuacct_charge+0x240/0x2e0
[   37.460000]  [<ffffffff8122c05e>] lock_release+0x14e/0x1a0
[   37.460000]  [<ffffffff811fcde8>] cpuacct_charge+0x258/0x2e0
[   37.460000]  [<ffffffff811fcb90>] ? cpuacct_css_free+0x40/0x40
[   37.460000]  [<ffffffff811e4137>] ? task_of+0xe7/0x110
[   37.460000]  [<ffffffff811e5bac>] update_curr+0x22c/0x2e0
[   37.460000]  [<ffffffff811e7827>] entity_tick+0x27/0xf0
[   37.460000]  [<ffffffff811efeb3>] task_tick_fair+0x43/0x370
[   37.460000]  [<ffffffff811d16d8>] scheduler_tick+0x68/0xb0
[   37.460000]  [<ffffffff8118bee0>] update_process_times+0x80/0xa0
[   37.460000]  [<ffffffff811ee0f0>] ? rebalance_domains+0x420/0x4e0
[   37.460000]  [<ffffffff8121b7be>] tick_periodic+0x7e/0x90
[   37.460000]  [<ffffffff8121b7f8>] tick_handle_periodic+0x28/0xf0
[   37.460000]  [<ffffffff811ee0f0>] ? rebalance_domains+0x420/0x4e0
[   37.460000]  [<ffffffff8550915d>] smp_apic_timer_interrupt+0x9d/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  [<ffffffff8122c08d>] ? lock_release+0x17d/0x1a0
[   37.460000]  [<ffffffff811ee108>] rebalance_domains+0x438/0x4e0
[   37.460000]  [<ffffffff811edcd0>] ? load_balance+0xb10/0xb10
[   37.460000]  [<ffffffff811ee418>] run_rebalance_domains+0x48/0x60
[   37.460000]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   37.460000]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff811d36ef>] ? finish_task_switch+0xcf/0x1f0
[   37.460000]  [<ffffffff854f913e>] ? _raw_spin_unlock_irq+0x6e/0xc0
[   37.460000]  [<ffffffff854f911d>] ? _raw_spin_unlock_irq+0x4d/0xc0
[   37.460000]  [<ffffffff811d36ef>] finish_task_switch+0xcf/0x1f0
[   37.460000]  [<ffffffff811d36b1>] ? finish_task_switch+0x91/0x1f0
[   37.460000]  [<ffffffff854f6160>] __schedule+0xcc0/0xe80
[   37.460000]  [<ffffffff854f6575>] schedule+0x65/0x90
[   37.460000]  [<ffffffff811cd1da>] smpboot_thread_fn+0x4da/0x570
[   37.460000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.460000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.460000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000] Code: 31 d2 48 89 e5 48 81 ff 38 de 47 8a 0f 93 c2 48 63 c2 48 83 c0 02 48 ff 04 c5 
98 86 c1 88 31 c0 c9 85 d2 48 0f 44 c7 c3 0f 1f 00 <31> c0 55 39 d6 48 89 e5 0f 94 c0 48 63 d0 48 83 
c2 02 48 ff 04
[   37.463738] NMI backtrace for cpu 24
[   37.463738] CPU: 24 PID: 252 Comm: ksoftirqd/24 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.463738] task: ffff880fcc2d0000 ti: ffff880fcc2c6000 task.ti: ffff880fcc2c6000
[   37.463738] RIP: 0010:[<ffffffff8550045e>]  [<ffffffff8550045e>] sub_preempt_count+0x19e/0x200
[   37.463738] RSP: 0000:ffff880fe6603dc8  EFLAGS: 00000006
[   37.463738] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000076189
[   37.463738] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88806610
[   37.463738] RBP: ffff880fe6603de8 R08: 0000000000000000 R09: 0000000000000000
[   37.463738] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880fcc2c7fd8
[   37.463738] R13: 0000000000000000 R14: 0000000000000018 R15: ffffffff890df2f0
[   37.463738] FS:  0000000000000000(0000) GS:ffff880fe6600000(0000) knlGS:0000000000000000
[   37.463738] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.463738] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.463738] Stack:
[   37.463738]  ffff880fe6603de8 0000000035f6438e 0000000000005854 ffffffff890df250
[   37.463738]  ffff880fe6603e48 ffffffff81f02643 ffff880fcc2d0000 ffff880f00000000
[   37.463738]  ffff880fcc2c6010 35f6c972811fd170 ffff880fe6603e48 ffff880fcc2d0000
[   37.463738] Call Trace:
[   37.463738]  <IRQ>
[   37.463738]  [<ffffffff81f02643>] delay_tsc+0x233/0x290
[   37.463738]  [<ffffffff81f02319>] __const_udelay+0x29/0x30
[   37.463738]  [<ffffffff811b4b84>] __rcu_read_unlock+0x64/0x190
[   37.463738]  [<ffffffff811fd18d>] cpuacct_account_field+0x20d/0x280
[   37.463738]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.463738]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.463738]  [<ffffffff811e17d2>] account_system_time+0x1b2/0x230
[   37.463738]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.463738]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.463738]  [<ffffffff811e2233>] vtime_account_system+0x53/0x70
[   37.463738]  [<ffffffff811e24e5>] vtime_account_irq_enter+0xb5/0xc0
[   37.463738]  [<ffffffff8117ee7f>] irq_enter+0x6f/0xa0
[   37.463738]  [<ffffffff855090fe>] smp_apic_timer_interrupt+0x3e/0xb0
[   37.463738]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.463738]  <EOI>
[   37.463738]  [<ffffffff85500450>] ? sub_preempt_count+0x190/0x200
[   37.463738]  [<ffffffff8117fc76>] ? __do_softirq+0x106/0x700
[   37.463738]  [<ffffffff8117fc50>] ? __do_softirq+0xe0/0x700
[   37.463738]  [<ffffffff811802ee>] run_ksoftirqd+0x7e/0x130
[   37.463738]  [<ffffffff811cd24e>] smpboot_thread_fn+0x54e/0x570
[   37.463738]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.463738]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.463738]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.463738]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.463738]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.463738]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.463738] Code: a1 c1 6b 03 48 ff 05 f2 c1 6b 03 eb c0 31 d2 31 f6 48 c7 c7 10 66 80 88 e8 a0 
ea dc fb 48 ff 05 09 c1 6b 03 48 ff 05 2a c1 6b 03 <65> 48 8b 04 25 08 d9 00 00 39 98 44 e0 ff ff 0f 
94 c2 83 e2 01
[   37.460000] NMI backtrace for cpu 26
[   37.460000] CPU: 26 PID: 0 Comm: swapper/26 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc54b000 ti: ffff880fcc550000 task.ti: ffff880fcc550000
[   37.460000] RIP: 0010:[<ffffffff81098225>]  [<ffffffff81098225>] sched_clock+0x35/0x50
[   37.460000] RSP: 0000:ffff880fe6a03e48  EFLAGS: 00000006
[   37.460000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000008
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff887f03d8
[   37.460000] RBP: ffff880fe6a03e58 R08: ffffffff88b77178 R09: 0000000000000000
[   37.460000] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880fe6bd8450
[   37.460000] R13: 0000000000000000 R14: ffffffff88bbda38 R15: ffffffff88bbda60
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe6a00000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fe6a03e78 ffff880fe6bd8440 ffff880fe6a03ea8 ffffffff811e05e5
[   37.460000]  ffff880fcc54b5f0 0000000000000100 ffff880fe6a03ea8 0000000000000000
[   37.460000]  000000000000001a ffff880fe6bd8440 00000000001d8440 0000000000000000
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff811e05e5>] sched_clock_local+0x35/0x100
[   37.460000]  [<ffffffff811e0cdf>] sched_clock_cpu+0x27f/0x2a0
[   37.460000]  [<ffffffff811801b1>] ? __do_softirq+0x641/0x700
[   37.460000]  [<ffffffff811e0d10>] sched_clock_idle_sleep_event+0x10/0x20
[   37.460000]  [<ffffffff81220d99>] __tick_nohz_idle_enter+0x49/0xf0
[   37.460000]  [<ffffffff81221d5d>] tick_nohz_irq_exit+0x4d/0x70
[   37.460000]  [<ffffffff811804f5>] irq_exit+0x155/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.460000]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: e5 53 31 db 48 83 ec 08 48 83 3d b6 e8 ba 06 00 0f 94 c3 31 d2 89 de e8 da 6c 
23 00 48 63 c3 48 83 c0 02 48 ff 04 c5 a8 ce b4 88 <85> db 74 09 0f 0b 0f 1f 44 00 00 eb fe e8 29 d1 
04 00 66 90 59
[   37.450000] NMI backtrace for cpu 25
[   37.450000] CPU: 25 PID: 0 Comm: swapper/25 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.450000] task: ffff880fcc548000 ti: ffff880fcc536000 task.ti: ffff880fcc536000
[   37.450000] RIP: 0010:[<ffffffff810e56c6>]  [<ffffffff810e56c6>] native_safe_halt+0x6/0x10
[   37.450000] RSP: 0000:ffff880fcc537e28  EFLAGS: 00000246
[   37.450000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[   37.450000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff887f0608
[   37.450000] RBP: ffff880fcc537e28 R08: 0000000000000000 R09: 0000000000000000
[   37.450000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000019
[   37.450000] R13: ffff880fcc536000 R14: ffffffff88bce5b8 R15: 0000000000000000
[   37.450000] FS:  0000000000000000(0000) GS:ffff880fe6800000(0000) knlGS:0000000000000000
[   37.450000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.450000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.450000] Stack:
[   37.450000]  ffff880fcc537e58 ffffffff8109b6f7 ffff880fcc536000 ffff880fcc536000
[   37.450000]  ffff880fcc536010 ffff880fcc536000 ffff880fcc537e78 ffffffff8109ae74
[   37.450000]  ffff880fcc536000 ffff880fcc536000 ffff880fcc537ef8 ffffffff8120d425
[   37.450000] Call Trace:
[   37.450000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.450000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.450000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.450000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.450000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.450000] Code: 00 00 00 00 00 55 48 89 e5 fa c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 
c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <c9> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 c9 
c3 66 0f 1f 84
[   37.460000] NMI backtrace for cpu 29
[   37.460000] CPU: 29 PID: 282 Comm: ksoftirqd/29 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc3f8000 ti: ffff880fcbc00000 task.ti: ffff880fcbc00000
[   37.460000] RIP: 0010:[<ffffffff81f02579>]  [<ffffffff81f02579>] delay_tsc+0x169/0x290
[   37.460000] RSP: 0000:ffff880fe7003e08  EFLAGS: 00000046
[   37.460000] RAX: 0000000000000000 RBX: 0000000035fbb3ea RCX: 000000000037bb8f
[   37.460000] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffffffff888e1508
[   37.460000] RBP: ffff880fe7003e58 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000005854
[   37.460000] R13: ffffffff890df250 R14: 000000000000001d R15: ffffffff890df2f0
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe7000000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fcc3f8000 ffff880f00000000 ffff880fcbc00010 35fbb5ae811fd170
[   37.460000]  ffff880fe7003e58 ffff880fcc3f8000 ffff880fcc3f8000 0000000000000004
[   37.460000]  ffffffff87c6a420 0000000000000246 ffff880fe7003e68 ffffffff81f02319
[   37.460000] Call Trace:
[   37.460000]  <IRQ>
[   37.460000]  [<ffffffff81f02319>] __const_udelay+0x29/0x30
[   37.460000]  [<ffffffff811b4b84>] __rcu_read_unlock+0x64/0x190
[   37.460000]  [<ffffffff811fd18d>] cpuacct_account_field+0x20d/0x280
[   37.460000]  [<ffffffff811fcf80>] ? cpuacct_css_alloc+0xf0/0xf0
[   37.460000]  [<ffffffff81f26882>] ? debug_smp_processor_id+0x42/0x1c0
[   37.460000]  [<ffffffff811e17d2>] account_system_time+0x1b2/0x230
[   37.460000]  [<ffffffff811e15d8>] ? get_vtime_delta+0xf8/0x120
[   37.460000]  [<ffffffff811e1889>] __vtime_account_system+0x39/0x40
[   37.460000]  [<ffffffff811e21c1>] vtime_account_irq_exit+0x81/0xa0
[   37.460000]  [<ffffffff811803ff>] irq_exit+0x5f/0x180
[   37.460000]  [<ffffffff85509162>] smp_apic_timer_interrupt+0xa2/0xb0
[   37.460000]  [<ffffffff85507f32>] apic_timer_interrupt+0x72/0x80
[   37.460000]  <EOI>
[   37.460000]  [<ffffffff811ebdf2>] ? update_blocked_averages+0x202/0x220
[   37.460000]  [<ffffffff854f9937>] ? _raw_spin_unlock_irqrestore+0xe7/0x140
[   37.460000]  [<ffffffff811ebdf2>] update_blocked_averages+0x202/0x220
[   37.460000]  [<ffffffff811edd25>] rebalance_domains+0x55/0x4e0
[   37.460000]  [<ffffffff811ee418>] run_rebalance_domains+0x48/0x60
[   37.460000]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   37.460000]  [<ffffffff811802ee>] run_ksoftirqd+0x7e/0x130
[   37.460000]  [<ffffffff811cd24e>] smpboot_thread_fn+0x54e/0x570
[   37.460000]  [<ffffffff811ccd00>] ? T.1265+0x20/0x20
[   37.460000]  [<ffffffff811bce7f>] kthread+0xff/0x110
[   37.460000]  [<ffffffff854f5301>] ? wait_for_completion+0xe1/0x140
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000]  [<ffffffff8550716c>] ret_from_fork+0x7c/0xb0
[   37.460000]  [<ffffffff811bcd80>] ? __init_kthread_worker+0x70/0x70
[   37.460000] Code: c9 3c ff 8b 45 b8 48 63 d0 48 83 c2 02 48 8b 0c d5 d0 f2 0d 89 48 ff c1 85 c0 
48 89 0c d5 d0 f2 0d 89 74 05 e8 d9 3e 5f 03 f3 90 <bf> 01 00 00 00 e8 3d df 5f 03 e8 b8 42 02 00 48 
c7 c7 e0 14 8e
[   37.462258] NMI backtrace for cpu 28
[   37.462258] CPU: 28 PID: 0 Comm: swapper/28 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.462258] task: ffff880fcc55b000 ti: ffff880fcc554000 task.ti: ffff880fcc554000
[   37.462258] RIP: 0010:[<ffffffff8550060f>]  [<ffffffff8550060f>] add_preempt_count+0x14f/0x1c0
[   37.462258] RSP: 0000:ffff880fe6e03dc8  EFLAGS: 00000202
[   37.462258] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
[   37.462258] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff88806688
[   37.462258] RBP: ffff880fe6e03dd8 R08: 0000000000000000 R09: 0000000000000000
[   37.462258] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[   37.462258] R13: 0000000000000007 R14: 0000000000000000 R15: 0000000000000001
[   37.462258] FS:  0000000000000000(0000) GS:ffff880fe6e00000(0000) knlGS:0000000000000000
[   37.462258] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.462258] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.462258] Stack:
[   37.462258]  000000000000001c 00000000001d7940 ffff880fe6e03df8 ffffffff8128eb86
[   37.462258]  000000000000001c 00000000001d7940 ffff880fe6e03e78 ffffffff811edd6f
[   37.462258]  ffffffff811edcd0 ffff880fcc3e5468 ffff880fcc554000 0000001c854fa3b7
[   37.462258] Call Trace:
[   37.462258]  <IRQ>
[   37.462258]  [<ffffffff8128eb86>] rcu_is_cpu_idle+0x16/0x90
[   37.462258]  [<ffffffff811edd6f>] rebalance_domains+0x9f/0x4e0
[   37.462258]  [<ffffffff811edcd0>] ? load_balance+0xb10/0xb10
[   37.462258]  [<ffffffff811ee418>] run_rebalance_domains+0x48/0x60
[   37.462258]  [<ffffffff8117fe98>] __do_softirq+0x328/0x700
[   37.462258]  [<ffffffff8118045f>] irq_exit+0xbf/0x180
[   37.462258]  [<ffffffff811d734c>] scheduler_ipi+0x11c/0x1c0
[   37.462258]  [<ffffffff810d030a>] smp_reschedule_interrupt+0x2a/0x30
[   37.462258]  [<ffffffff855082b2>] reschedule_interrupt+0x72/0x80
[   37.462258]  <EOI>
[   37.462258]  [<ffffffff854fa3b7>] ? retint_restore_args+0x13/0x13
[   37.462258]  [<ffffffff810e56c6>] ? native_safe_halt+0x6/0x10
[   37.462258]  [<ffffffff8122a1dd>] ? trace_hardirqs_on+0xd/0x10
[   37.462258]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.462258]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.462258]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.462258]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.462258]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.462258] Code: 25 08 d9 00 00 39 98 44 e0 ff ff 0f 94 c0 83 e0 01 48 83 c0 02 48 ff 04 c5 40 
c6 bb 88 eb 6d 0f 1f 44 00 00 48 ff 05 31 c1 6b 03 <48> ff 05 52 c1 6b 03 65 48 8b 04 25 08 d9 00 00 
01 98 44 e0 ff
[   37.460000] NMI backtrace for cpu 27
[   37.460000] CPU: 27 PID: 0 Comm: swapper/27 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc558000 ti: ffff880fcc552000 task.ti: ffff880fcc552000
[   37.460000] RIP: 0010:[<ffffffff810e56c6>]  [<ffffffff810e56c6>] native_safe_halt+0x6/0x10
[   37.460000] RSP: 0000:ffff880fcc553e28  EFLAGS: 00000246
[   37.460000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff887f0608
[   37.460000] RBP: ffff880fcc553e28 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: 000000000000001b
[   37.460000] R13: ffff880fcc552000 R14: ffffffff88bce5b8 R15: 0000000000000000
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe6c00000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fcc553e58 ffffffff8109b6f7 ffff880fcc552000 ffff880fcc552000
[   37.460000]  ffff880fcc552010 ffff880fcc552000 ffff880fcc553e78 ffffffff8109ae74
[   37.460000]  ffff880fcc552000 ffff880fcc552000 ffff880fcc553ef8 ffffffff8120d425
[   37.460000] Call Trace:
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: 00 00 00 00 00 55 48 89 e5 fa c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 
c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <c9> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 c9 
c3 66 0f 1f 84
[   37.460000] NMI backtrace for cpu 30
[   37.460000] CPU: 30 PID: 0 Comm: swapper/30 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc563000 ti: ffff880fcc56c000 task.ti: ffff880fcc56c000
[   37.460000] RIP: 0010:[<ffffffff810e56c6>]  [<ffffffff810e56c6>] native_safe_halt+0x6/0x10
[   37.460000] RSP: 0000:ffff880fcc56de28  EFLAGS: 00000246
[   37.460000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff887f0608
[   37.460000] RBP: ffff880fcc56de28 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: 000000000000001e
[   37.460000] R13: ffff880fcc56c000 R14: ffffffff88bce5b8 R15: 0000000000000000
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe7200000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fcc56de58 ffffffff8109b6f7 ffff880fcc56c000 ffff880fcc56c000
[   37.460000]  ffff880fcc56c010 ffff880fcc56c000 ffff880fcc56de78 ffffffff8109ae74
[   37.460000]  ffff880fcc56c000 ffff880fcc56c000 ffff880fcc56def8 ffffffff8120d425
[   37.460000] Call Trace:
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: 00 00 00 00 00 55 48 89 e5 fa c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 
c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <c9> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 c9 
c3 66 0f 1f 84
[   37.460000] NMI backtrace for cpu 31
[   37.460000] CPU: 31 PID: 0 Comm: swapper/31 Not tainted 
3.10.0-rc6-next-20130621-sasha-00011-geddfead #1101
[   37.460000] task: ffff880fcc578000 ti: ffff880fcc56e000 task.ti: ffff880fcc56e000
[   37.460000] RIP: 0010:[<ffffffff810e56c6>]  [<ffffffff810e56c6>] native_safe_halt+0x6/0x10
[   37.460000] RSP: 0000:ffff880fcc56fe28  EFLAGS: 00000246
[   37.460000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[   37.460000] RDX: 0000000000000003 RSI: 0000000000000000 RDI: ffffffff887f0608
[   37.460000] RBP: ffff880fcc56fe28 R08: 0000000000000000 R09: 0000000000000000
[   37.460000] R10: 0000000000000001 R11: 0000000000000000 R12: 000000000000001f
[   37.460000] R13: ffff880fcc56e000 R14: ffffffff88bce5b8 R15: 0000000000000000
[   37.460000] FS:  0000000000000000(0000) GS:ffff880fe7400000(0000) knlGS:0000000000000000
[   37.460000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   37.460000] CR2: 00000000ffffffff CR3: 0000000007c24000 CR4: 00000000000006e0
[   37.460000] Stack:
[   37.460000]  ffff880fcc56fe58 ffffffff8109b6f7 ffff880fcc56e000 ffff880fcc56e000
[   37.460000]  ffff880fcc56e010 ffff880fcc56e000 ffff880fcc56fe78 ffffffff8109ae74
[   37.460000]  ffff880fcc56e000 ffff880fcc56e000 ffff880fcc56fef8 ffffffff8120d425
[   37.460000] Call Trace:
[   37.460000]  [<ffffffff8109b6f7>] default_idle+0x247/0x4e0
[   37.460000]  [<ffffffff8109ae74>] arch_cpu_idle+0x34/0x80
[   37.460000]  [<ffffffff8120d425>] cpu_idle_loop+0x6c5/0x9a0
[   37.460000]  [<ffffffff8120d770>] cpu_startup_entry+0x70/0x80
[   37.460000]  [<ffffffff854e3aaa>] start_secondary+0x10b/0x112
[   37.460000] Code: 00 00 00 00 00 55 48 89 e5 fa c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 
c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <c9> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 c9 
c3 66 0f 1f 84


Thanks,
Sasha
