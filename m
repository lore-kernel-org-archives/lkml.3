Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966825Ab3DRVGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 17:06:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37048 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3DRVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 17:06:45 -0400
Message-ID: <5170602E.3050206@oracle.com>
Date: Thu, 18 Apr 2013 17:05:50 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130408 Thunderbird/17.0.5
MIME-Version: 1.0
To: chuansheng.liu@intel.com, Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>, eag0628@gmail.com,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/smp.c:385 smp_call_function_many
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

It seems that with commit "smp: Give WARN()ing when calling
smp_call_function_many()/single() in serving irq" I'm getting a bunch of these:

[  467.250851] WARNING: at kernel/smp.c:385 smp_call_function_many+0xda/0x400()
[  467.251990] Modules linked in:
[  467.252496] CPU: 1 PID: 12638 Comm: trinity-child1 Tainted: G        W    3.9.0-rc7-next-20130418-sasha-00013-g333a5d2 #340
[  467.259691]  0000000000000009 ffff8800bb603d98 ffffffff83deed7a ffff8800bb603dd8
[  467.261157]  ffffffff81112ecb ffff88009d229fd8 ffffffff81148430 0000000000000001
[  467.262478]  ffffffff861922e0 0000000000000008 ffffffff861922e0 ffff8800bb603de8
[  467.263758] Call Trace:
[  467.266447]  <IRQ>  [<ffffffff83deed7a>] dump_stack+0x19/0x1b
[  467.267437]  [<ffffffff81112ecb>] warn_slowpath_common+0x6b/0xa0
[  467.268418]  [<ffffffff81148430>] ? hrtimer_wakeup+0x30/0x30
[  467.269838]  [<ffffffff81112f15>] warn_slowpath_null+0x15/0x20
[  467.270844]  [<ffffffff81197b8a>] smp_call_function_many+0xda/0x400
[  467.272287]  [<ffffffff8115c055>] ? sched_clock_local+0x25/0xa0
[  467.273259]  [<ffffffff81148430>] ? hrtimer_wakeup+0x30/0x30
[  467.274590]  [<ffffffff81148430>] ? hrtimer_wakeup+0x30/0x30
[  467.275519]  [<ffffffff81198001>] smp_call_function+0x41/0x80
[  467.276801]  [<ffffffff81148430>] ? hrtimer_wakeup+0x30/0x30
[  467.277756]  [<ffffffff81198099>] on_each_cpu+0x39/0x110
[  467.278604]  [<ffffffff81149197>] clock_was_set+0x17/0x20
[  467.280198]  [<ffffffff81149bb2>] run_hrtimer_softirq+0x32/0x40
[  467.281530]  [<ffffffff8111cb07>] __do_softirq+0x1d7/0x460
[  467.282434]  [<ffffffff8111cf26>] irq_exit+0x76/0xd0
[  467.283243]  [<ffffffff8109287a>] smp_apic_timer_interrupt+0x8a/0xa0
[  467.284707]  [<ffffffff83e369f2>] apic_timer_interrupt+0x72/0x80
[  467.285674]  <EOI>  [<ffffffff81071ef5>] ? sched_clock+0x15/0x20
[  467.287132]  [<ffffffff83e31dd6>] ? add_preempt_count+0xa6/0xc0
[  467.288089]  [<ffffffff81a1db2c>] delay_tsc+0xac/0x120
[  467.289342]  [<ffffffff8127cbd8>] ? __mem_cgroup_count_vm_event+0x178/0x1a0
[  467.290522]  [<ffffffff81a1da19>] __const_udelay+0x29/0x30
[  467.291425]  [<ffffffff8113ee14>] __rcu_read_unlock+0x44/0xb0
[  467.292829]  [<ffffffff8127cbf5>] __mem_cgroup_count_vm_event+0x195/0x1a0
[  467.293994]  [<ffffffff8127ca60>] ? mem_cgroup_from_task+0xd0/0xd0
[  467.295456]  [<ffffffff81240e82>] handle_mm_fault+0x632/0x660
[  467.296692]  [<ffffffff8118b40a>] ? __lock_is_held+0x5a/0x80
[  467.297647]  [<ffffffff83e318f0>] __do_page_fault+0x570/0x5e0
[  467.298622]  [<ffffffff811d3e2d>] ? rcu_try_advance_all_cbs+0x3d/0xb0
[  467.300213]  [<ffffffff811d3f1d>] ? rcu_eqs_exit_common+0x7d/0x260
[  467.301241]  [<ffffffff811d4e0e>] ? rcu_eqs_enter_common+0x33e/0x3b0
[  467.302760]  [<ffffffff811d419c>] ? rcu_eqs_exit+0x9c/0xb0
[  467.303649]  [<ffffffff83e31992>] do_page_fault+0x32/0x50
[  467.304526]  [<ffffffff83e30f60>] do_async_page_fault+0x30/0xc0
[  467.306556]  [<ffffffff83e2e228>] async_page_fault+0x28/0x30

So either the new commit is broken, or hrtimer is horribly broken?


Thanks,
Sasha
