Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab3HGRAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:00:15 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39699 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3HGRAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:00:13 -0400
Date: Wed, 7 Aug 2013 10:00:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu stall warning, again.
Message-ID: <20130807170000.GE4306@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130807050511.GA26942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807050511.GA26942@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080717-7282-0000-0000-00001A27E2E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 01:05:11AM -0400, Dave Jones wrote:
> Still seeing these (though not as frequently)
> 
> 
> INFO: rcu_preempt self-detected stall on CPU { 2}  (t=6500 jiffies g=4433279 c=4433278 q=0)
> sending NMI to all CPUs:
> NMI backtrace for cpu 0
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-rc4+ #1
> task: ffffffff81c10440 ti: ffffffff81c00000 task.ti: ffffffff81c00000
> RIP: 0010:[<ffffffff8159085a>]  [<ffffffff8159085a>] poll_idle+0x3a/0x80
> RSP: 0018:ffffffff81c01e70  EFLAGS: 00000246
> RAX: 0000000000080000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81c01fd8 RDI: ffffffff81c10440
> RBP: ffffffff81c01e88 R08: ffff8802449d0740 R09: 0000000000000000
> R10: 7fffffffffffffff R11: 0000000000000001 R12: ffffe8ffff604518
> R13: 0000562edf050df9 R14: 0000562edf050de9 R15: ffffffff81c9a938
> FS:  0000000000000000(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f32dc0e2000 CR3: 0000000235b43000 CR4: 00000000001407f0
> DR0: 0000000003ca6e60 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  ffffe8ffff604518 ffffffff81c9a920 0000000000000000 ffffffff81c01ec0
>  ffffffff81590ff0 0000000000000000 ffffe8ffff604518 ffffffff81c9a920
>  0000000000000000 0000000000000000 ffffffff81c01f00 ffffffff81591135
> Call Trace:
>  [<ffffffff81590ff0>] cpuidle_enter_state+0x40/0xc0
>  [<ffffffff81591135>] cpuidle_idle_call+0xc5/0x3f0
>  [<ffffffff8100c9ae>] arch_cpu_idle+0xe/0x30
>  [<ffffffff810b09e7>] cpu_startup_entry+0xd7/0x460
>  [<ffffffff81093e4d>] ? get_parent_ip+0xd/0x50
>  [<ffffffff816f6cb7>] rest_init+0x137/0x140
>  [<ffffffff816f6b85>] ? rest_init+0x5/0x140
>  [<ffffffff81edbe44>] start_kernel+0x3f1/0x3fe
>  [<ffffffff81edb85b>] ? repair_env_string+0x5c/0x5c
>  [<ffffffff81edb56f>] x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff81edb662>] x86_64_start_kernel+0xf1/0xf4
> Code: fc 53 89 d3 e8 f8 2a b2 ff 49 89 c5 e8 30 16 b3 ff fb 65 48 8b 34 25 f0 b9 00 00 48 8b 86 38 e0 ff ff a8 08 75 11 0f 1f 00 f3 90 <48> 8b 8e 38 e0 ff ff 83 e1 08 74 f2 e8 c5 2a b2 ff 4c 29 e8 48 
> INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 25.513 msecs
> NMI backtrace for cpu 2
> CPU: 2 PID: 14291 Comm: trinity-child3 Not tainted 3.11.0-rc4+ #1
> task: ffff8801e2a36a40 ti: ffff8801a95e6000 task.ti: ffff8801a95e6000
> RIP: 0010:[<ffffffff81033c88>]  [<ffffffff81033c88>] __x2apic_send_IPI_mask+0x188/0x1c0
> RSP: 0000:ffff880244c03b10  EFLAGS: 00000046
> RAX: 0000000000000004 RBX: 0000000000000001 RCX: 000000000000003c
> RDX: 000000000000000f RSI: 0000000000000004 RDI: 0000000000000000
> RBP: ffff880244c03b60 R08: ffff880243289650 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff880243289650
> R13: ffff8802437eda40 R14: 0000000000080000 R15: 000000000000d010
> FS:  00007fe84a890740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000005b255b8 CR3: 00000001b4871000 CR4: 00000000001407e0
> DR0: 00000000013ae000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  0000000000000082 000000000000d008 0000000200000002 0000000000000004
>  0000000000000002 0000000000002710 ffffffff81c50940 ffffffff81c50940
>  ffff880244dcde00 0000000000000000 ffff880244c03b70 ffffffff81033cdc
> Call Trace:
>  <IRQ> 
>  [<ffffffff81033cdc>] x2apic_send_IPI_all+0x1c/0x20
>  [<ffffffff81030115>] arch_trigger_all_cpu_backtrace+0x65/0xa0
>  [<ffffffff81111ce1>] rcu_check_callbacks+0x331/0x8e0
>  [<ffffffff81064f97>] update_process_times+0x47/0x80
>  [<ffffffff810bbf25>] tick_sched_handle.isra.16+0x25/0x60
>  [<ffffffff810bc041>] tick_sched_timer+0x41/0x60
>  [<ffffffff81085f71>] __run_hrtimer+0x81/0x4e0
>  [<ffffffff810bc000>] ? tick_sched_do_timer+0x60/0x60
>  [<ffffffff81086bcf>] hrtimer_interrupt+0xff/0x240
>  [<ffffffff8102de84>] local_apic_timer_interrupt+0x34/0x60
>  [<ffffffff81715c0a>] smp_trace_apic_timer_interrupt+0x4a/0x2be
>  [<ffffffff817148af>] trace_apic_timer_interrupt+0x6f/0x80
>  [<ffffffff8170b9a0>] ? retint_restore_args+0xe/0xe
>  [<ffffffff810b5b89>] ? clocksource_watchdog+0xa9/0x2e0
>  [<ffffffff810b5b84>] ? clocksource_watchdog+0xa4/0x2e0
>  [<ffffffff810b5ae0>] ? clocksource_watchdog_kthread+0x40/0x40
>  [<ffffffff81063b3a>] call_timer_fn+0x8a/0x370

Hmmm...  Just how many timers did you have stacked up waiting to
be invoked, anyway?  ;-)

My best guess as to what happened.

							Thanx, Paul

>  [<ffffffff81063ab5>] ? call_timer_fn+0x5/0x370
>  [<ffffffff810b5ae0>] ? clocksource_watchdog_kthread+0x40/0x40
>  [<ffffffff8106405c>] run_timer_softirq+0x23c/0x390
>  [<ffffffff8105ac1f>] __do_softirq+0xff/0x440
>  [<ffffffff8105b11d>] irq_exit+0xcd/0xe0
>  [<ffffffff81715c1a>] smp_trace_apic_timer_interrupt+0x5a/0x2be
>  [<ffffffff817148af>] trace_apic_timer_interrupt+0x6f/0x80
>  <EOI> 
>  [<ffffffff81153a67>] ? user_enter+0x87/0xd0
>  [<ffffffff8170f2a5>] do_page_fault+0x45/0x50
>  [<ffffffff8170bbe2>] page_fault+0x22/0x30
> Code: 27 ff ff ff 39 c6 0f 87 1f ff ff ff e8 62 fe ff ff 48 63 35 b3 74 cc 00 e9 0e ff ff ff 66 0f 1f 44 00 00 48 f7 45 b0 00 02 00 00 <74> 18 e8 e1 e1 08 00 ff 75 b0 9d 48 83 c4 28 5b 41 5c 41 5d 41 
> INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 25.605 msecs
> NMI backtrace for cpu 3
> CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.11.0-rc4+ #1
> task: ffff880243291540 ti: ffff88024329a000 task.ti: ffff88024329a000
> RIP: 0010:[<ffffffff81376d95>]  [<ffffffff81376d95>] intel_idle+0xa5/0x100
> RSP: 0018:ffff88024329be18  EFLAGS: 00000046
> RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffffff81c9a920 RDI: 0000000000000003
> RBP: ffff88024329be40 R08: ffff880244fd0758 R09: 0000000000000000
> R10: 7fffffffffffffff R11: 0000000000000001 R12: 0000000000000005
> R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9aaf0
> FS:  0000000000000000(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f32dc0e2000 CR3: 0000000001c0b000 CR4: 00000000001407e0
> DR0: 0000000000aec000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  000000034329be40 ffffe8ffffc04518 ffffffff81c9a920 0000000000000005
>  0000562edf05cd3b ffff88024329be78 ffffffff81590ff0 0000000000000005
>  ffffe8ffffc04518 ffffffff81c9a920 0000000000000000 0000000000000005
> Call Trace:
>  [<ffffffff81590ff0>] cpuidle_enter_state+0x40/0xc0
>  [<ffffffff81591135>] cpuidle_idle_call+0xc5/0x3f0
>  [<ffffffff8100c9ae>] arch_cpu_idle+0xe/0x30
>  [<ffffffff810b09e7>] cpu_startup_entry+0xd7/0x460
>  [<ffffffff810b9748>] ? clockevents_config_and_register+0x28/0x30
>  [<ffffffff8102c274>] start_secondary+0x244/0x340
> Code: 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 65 48 8b 04 25 f0 b9 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 75 3b 92 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 d5 2a d4 
> INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 25.641 msecs
> NMI backtrace for cpu 1
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-rc4+ #1
> task: ffff880243290000 ti: ffff88024328c000 task.ti: ffff88024328c000
> RIP: 0010:[<ffffffff81376d95>]  [<ffffffff81376d95>] intel_idle+0xa5/0x100
> RSP: 0018:ffff88024328de18  EFLAGS: 00000046
> RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffffff81c9a920 RDI: 0000000000000001
> RBP: ffff88024328de40 R08: ffff880244bd0768 R09: 0000000000000000
> R10: 7fffffffffffffff R11: 0000000000000001 R12: 0000000000000005
> R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9aaf0
> FS:  0000000000000000(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f32dc0e2000 CR3: 0000000001c0b000 CR4: 00000000001407e0
> DR0: 0000000000e8e000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  000000014328de40 ffffe8ffff804518 ffffffff81c9a920 0000000000000005
>  0000562edf065306 ffff88024328de78 ffffffff81590ff0 0000000000000005
>  ffffe8ffff804518 ffffffff81c9a920 0000000000000000 0000000000000005
> Call Trace:
>  [<ffffffff81590ff0>] cpuidle_enter_state+0x40/0xc0
>  [<ffffffff81591135>] cpuidle_idle_call+0xc5/0x3f0
>  [<ffffffff8100c9ae>] arch_cpu_idle+0xe/0x30
>  [<ffffffff810b09e7>] cpu_startup_entry+0xd7/0x460
>  [<ffffffff810b9748>] ? clockevents_config_and_register+0x28/0x30
>  [<ffffffff8102c274>] start_secondary+0x244/0x340
> Code: 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 65 48 8b 04 25 f0 b9 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <85> 1d 75 3b 92 00 75 0e 48 8d 75 dc bf 05 00 00 00 e8 d5 2a d4 
> INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 25.688 msecs
> INFO: rcu_preempt detected stalls on CPUs/tasks: { 2} (detected by 1, t=6502 jiffies, g=4433279, c=4433278, q=0)
> INFO: rcu_preempt self-detected stall on CPU { 2}  (t=6500 jiffies g=4433283 c=4433282 q=0)
> 
> and then it repeats... (though 'too long' is now 60 msecs)
> 
> 	Dave
> 

