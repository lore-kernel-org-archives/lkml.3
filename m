Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3GUAYC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 20:24:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57949 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab3GUAYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 20:24:00 -0400
Message-ID: <51EB29FD.60508@zytor.com>
Date: Sat, 20 Jul 2013 17:23:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [x86] Kernel panic - not syncing: Fatal exception in interrupt
References: <20130720131226.GA13893@localhost>
In-Reply-To: <20130720131226.GA13893@localhost>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2013 06:12 AM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 51b2c07b22261f19188d9a9071943d60a067481c
> Author: Jiri Kosina <jkosina@suse.cz>
> Date:   Fri Jul 12 11:22:09 2013 +0200
> 
>     x86: Make jump_label use int3-based patching
>     
>     Make jump labels use text_poke_bp() for text patching instead of
>     text_poke_smp(), avoiding the need for stop_machine().
>     
>     Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
>     Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>     Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>     Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1307121120250.29788@pobox.suse.cz
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> 
> Parent commit not clean. Look out for wrong bisect!
> 
> BUG: kernel boot crashed
> 
> /kernel/x86_64-randconfig-c05-0718/fd4363fff3d96795d3feb1b3fb48ce590f186bdd/dmesg-kvm-xbm-7912-20130720142415-3.11.0-rc1-00166-g1faabf2-146
> 
> [    0.212429] devtmpfs: initialized
> [    0.236027] int3: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    0.237157] Modules linked in:
> [    0.237765] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-rc1-01429-g04bf576 #8
> [    0.239129] task: ffff88000da1b040 ti: ffff88000da1c000 task.ti: ffff88000da1c000
> [    0.240000] RIP: 0010:[<ffffffff811098cc>]  [<ffffffff811098cc>] ttwu_do_wakeup+0x28/0x225
> [    0.240000] RSP: 0000:ffff88000dd03f10  EFLAGS: 00000006
> [    0.240000] RAX: 0000000000000000 RBX: ffff88000dd12940 RCX: ffffffff81769c40
> [    0.240000] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000001
> [    0.240000] RBP: ffff88000dd03f28 R08: ffffffff8176a8c0 R09: 0000000000000002
> [    0.240000] R10: ffffffff810ff484 R11: ffff88000dd129e8 R12: ffff88000dbc90c0
> [    0.240000] R13: ffff88000dbc90c0 R14: ffff88000da1dfd8 R15: ffff88000da1dfd8
> [    0.240000] FS:  0000000000000000(0000) GS:ffff88000dd00000(0000) knlGS:0000000000000000
> [    0.240000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.240000] CR2: 00000000ffffffff CR3: 0000000001c88000 CR4: 00000000000006e0
> [    0.240000] Stack:
> [    0.240000]  ffff88000dd12940 ffff88000dbc90c0 ffff88000da1dfd8 ffff88000dd03f48
> [    0.240000]  ffffffff81109e2b ffff88000dd12940 0000000000000000 ffff88000dd03f68
> [    0.240000]  ffffffff81109e9e 0000000000000000 0000000000012940 ffff88000dd03f98
> [    0.240000] Call Trace:
> [    0.240000]  <IRQ> 
> [    0.240000]  [<ffffffff81109e2b>] ttwu_do_activate.constprop.56+0x6d/0x79
> [    0.240000]  [<ffffffff81109e9e>] sched_ttwu_pending+0x67/0x84
> [    0.240000]  [<ffffffff8110c845>] scheduler_ipi+0x15a/0x2b0
> [    0.240000]  [<ffffffff8104dfb4>] smp_reschedule_interrupt+0x38/0x41
> [    0.240000]  [<ffffffff8173bf5d>] reschedule_interrupt+0x6d/0x80
> [    0.240000]  <EOI> 
> [    0.240000]  [<ffffffff810ff484>] ? __atomic_notifier_call_chain+0x5/0xc1
> [    0.240000]  [<ffffffff8105cc30>] ? native_safe_halt+0xd/0x16

Well, it is definitely easy to see what happened here.

We took a breakpoint fault that the kernel didn't expect.  This
shouldn't happen... the breakpoint handler should have said "oh, this is
an instruction being patched" and resumed, but that didn't happen.

Jiri, I'm wondering if by any chance we have more than one CPU inside
text_poke_bp() at the same time.  The global variables in text_poke_bp()
don't seem to be protected against reentrancy at all.

	-hpa

P.S. the sync_core() in do_sync_core() should be unnecessary, as IRET is
a synchronizing instruction.




