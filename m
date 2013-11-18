Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3KRPod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:44:33 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38519 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3KRPo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:44:26 -0500
MIME-Version: 1.0
In-Reply-To: <20131118153219.GH3866@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311131739560.5706@vincent-weaver-1.um.maine.edu>
	<20131115145944.GA3694@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1311151223040.11932@vincent-weaver-1.um.maine.edu>
	<20131118085439.GD3866@twins.programming.kicks-ass.net>
	<CABPqkBRe0xK_mf4JE+0e-UDs92Os_3dreHfh-wnG78fquTCRHQ@mail.gmail.com>
	<20131118153219.GH3866@twins.programming.kicks-ass.net>
Date: Mon, 18 Nov 2013 16:44:25 +0100
Message-ID: <CABPqkBQqa_foaozcHkHBU+VFTcVKrkgVcidUQNzWayB53yBa8g@mail.gmail.com>
Subject: Re: perf sw_event related lockup
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince,

What's the config for this test?
Need to host CPU type and the event config.
Otherwise there is not much I can do with the crash dump.
Thanks.

On Mon, Nov 18, 2013 at 4:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Nov 18, 2013 at 04:18:34PM +0100, Stephane Eranian wrote:
>> Peter,
>>
>> I missed the beginning of this thread somehow.
>> What's the initial problem?
>
> lkml.kernel.org/r/alpine.DEB.2.10.1311141412060.8746@vincent-weaver-1.um.maine.edu
> lkml.kernel.org/r/alpine.DEB.2.10.1311151223040.11932@vincent-weaver-1.um.maine.edu
>
> Vince managed to make the intel constraints code go *bang*.
>
> ---
> [  573.054155] BUG: unable to handle kernel NULL pointer dereference at        )
> [  573.057564] IP: [<ffffffff81520a44>] _raw_spin_lock_irqsave+0x11/0x2d
> [  573.057564] PGD c814b067 PUD cb183067 PMD 0
> [  573.057564] Oops: 0002 [#1] SMP
> [  573.057564] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powern
> [  573.057564] CPU: 1 PID: 3926 Comm: perf_fuzzer Tainted: G        W    3.12.04
> [  573.057564] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
> [  573.057564] task: ffff880037cfd0c0 ti: ffff8800ca4ae000 task.ti: ffff8800ca40
> [  573.057564] RIP: 0010:[<ffffffff81520a44>]  [<ffffffff81520a44>] _raw_spin_ld
> [  573.057564] RSP: 0018:ffff8800ca4afa08  EFLAGS: 00010046
> [  573.057564] RAX: 0000000000000046 RBX: ffff8800c813e800 RCX: 0000000000000000
> [  573.057564] RDX: 0000000000010000 RSI: ffff8800c813e800 RDI: 0000000000000000
> [  573.057564] RBP: ffff8800ca4afa08 R08: ffff8800c813e800 R09: ffff8800ca4afdf8
> [  573.057564] R10: ffff88011a2261c0 R11: 0000000000000246 R12: ffff88011fc8b940
> [  573.057564] R13: 0000000000000000 R14: ffff8800c813e948 R15: 0000000000000000
> [  573.057564] FS:  00007fc238e92700(0000) GS:ffff88011fc80000(0000) knlGS:00000
> [  573.057564] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  573.057564] CR2: 0000000000000000 CR3: 00000000c88c4000 CR4: 00000000000407e0
> [  573.057564] DR0: 0000000000033c20 DR1: 0000000000000000 DR2: 0000000000000000
> [  573.057564] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [  573.057564] Stack:
> [  573.057564]  ffff8800ca4afa58 ffffffff810190b0 0000000000000000 0000000000000
> [  573.057564]  ffff88011fff8680 0000000000000000 ffff8800c813e800 ffff88011fc80
> [  573.057564]  0000000000000040 0000000000000000 ffff8800ca4afa88 ffffffff81013
> [  573.057564] Call Trace:
> [  573.057564]  [<ffffffff810190b0>] __intel_shared_reg_get_constraints+0x5e/0xc
> [  573.057564]  [<ffffffff81019273>] intel_get_event_constraints+0x85/0x154
> [  573.057564]  [<ffffffff81013bcc>] x86_schedule_events+0x54/0x185
> [  573.057564]  [<ffffffff8101284f>] ? x86_pmu_add+0xf8/0x110
> [  573.057564]  [<ffffffff810126ee>] x86_pmu_commit_txn+0x51/0x9a
> [  573.057564]  [<ffffffff810d6fef>] ? __alloc_pages_nodemask+0x173/0x718
> [  573.057564]  [<ffffffff810c88bc>] ? event_sched_in+0x7a/0x109
> [  573.057564]  [<ffffffff810c89e3>] group_sched_in+0x98/0x147
> [  573.057564]  [<ffffffff81067436>] ? sched_clock_cpu+0xc3/0xd1
> [  573.057564]  [<ffffffff810c8bf0>] ctx_sched_in+0x15e/0x185
> [  573.057564]  [<ffffffff810c8c80>] perf_event_sched_in+0x69/0x72
> [  573.057564]  [<ffffffff810c8d51>] __perf_install_in_context+0xc8/0xf1
> [  573.057564]  [<ffffffff810c956f>] ? perf_event_task_output+0x13d/0x13d
> [  573.057564]  [<ffffffff810c95ab>] remote_function+0x3c/0x43
> [  573.057564]  [<ffffffff8108c655>] smp_call_function_single+0x8a/0x101
> [  573.057564]  [<ffffffff810c95f6>] task_function_call+0x44/0x4e
> [  573.057564]  [<ffffffff810c8c89>] ? perf_event_sched_in+0x72/0x72
> [  573.057564]  [<ffffffff810c9a0c>] perf_install_in_context+0x81/0xbc
> [  573.057564]  [<ffffffff8151dddc>] ? mutex_lock+0x16/0x37
> [  573.057564]  [<ffffffff810cd56b>] SYSC_perf_event_open+0x634/0x7e9
> [  573.057564]  [<ffffffff810cd729>] SyS_perf_event_open+0x9/0xb
> [  573.057564]  [<ffffffff81527b56>] system_call_fastpath+0x1a/0x1f
> [  573.057564] Code: c1 07 89 c2 c1 ea 10 66 39 c2 74 0c 66 8b 07 66 39 d0 74 0
> [  573.057564] RIP  [<ffffffff81520a44>] _raw_spin_lock_irqsave+0x11/0x2d
> [  573.057564]  RSP <ffff8800ca4afa08>
> [  573.057564] CR2: 0000000000000000
> [  573.057564] ---[ end trace ee0dc4a441b301c0 ]---
