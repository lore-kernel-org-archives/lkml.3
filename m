Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaLNXrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:47:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaLNXrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:47:41 -0500
Date: Sun, 14 Dec 2014 18:46:54 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141214234654.GA396@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 02:40:51PM -0800, Linus Torvalds wrote:
 > On Sat, Dec 13, 2014 at 2:36 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Ok, I think we can rule out preemption. I just checked on it, and
 > > found it wedged.
 > 
 > Ok, one more. Mind checking what happens without CONFIG_DEBUG_PAGEALLOC?

Crap. Looks like it wedged. It's stuck that way until I get back to it
on Wednesday.


[ 6188.985536] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c175:14205]
[ 6188.985612] CPU: 1 PID: 14205 Comm: trinity-c175 Not tainted 3.18.0+ #103 [loadavg: 200.63 151.07 150.40 179/407 17316]
[ 6188.985652] task: ffff880056ac96d0 ti: ffff8800975d8000 task.ti: ffff8800975d8000
[ 6188.985680] RIP: 0010:[<ffffffff810c6430>]  [<ffffffff810c6430>] lock_release+0xc0/0x240
[ 6188.985714] RSP: 0018:ffff8800975dbaa8  EFLAGS: 00000292
[ 6188.985734] RAX: ffff880056ac96d0 RBX: ffff8800975dbaf0 RCX: 00000000000003a0
[ 6188.985759] RDX: ffff88024500dd20 RSI: 0000000000000000 RDI: ffff880056ac9e40
[ 6188.985785] RBP: ffff8800975dbad8 R08: 0000000000000000 R09: 0000000000000000
[ 6188.985810] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000292
[ 6188.985835] R13: ffff8800975dba28 R14: 0000000000000292 R15: 0000000000000292
[ 6188.985861] FS:  00007f107fc69740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[ 6188.985890] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6188.985912] CR2: 00007fff7457af40 CR3: 00000000145ed000 CR4: 00000000001407e0
[ 6188.985937] DR0: 00007f322081b000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6188.985963] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 6188.985988] Stack:
[ 6188.986000]  ffff8800975dbb08 0000000000000000 0000000000000000 00000000001ce380
[ 6188.986034]  ffff8800975dbd08 ffff8802451ce380 ffff8800975dbbd8 ffffffff8116f928
[ 6188.986067]  ffffffff8116f842 ffff8800975dbaf0 ffff8800975dbaf0 0000000000000001
[ 6188.986101] Call Trace:
[ 6188.986116]  [<ffffffff8116f928>] __perf_sw_event+0x168/0x240
[ 6188.987079]  [<ffffffff8116f842>] ? __perf_sw_event+0x82/0x240
[ 6188.988045]  [<ffffffff81178ab2>] ? __lock_page_or_retry+0xb2/0xc0
[ 6188.989008]  [<ffffffff811a68f8>] ? handle_mm_fault+0x458/0xe90
[ 6188.989986]  [<ffffffff8104250e>] __do_page_fault+0x28e/0x5c0
[ 6188.990940]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6188.991884]  [<ffffffff8107c25d>] ? __do_softirq+0x1ed/0x310
[ 6188.992826]  [<ffffffff817d09e0>] ? retint_restore_args+0xe/0xe
[ 6188.993773]  [<ffffffff8137511d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 6188.994715]  [<ffffffff8104284c>] do_page_fault+0xc/0x10
[ 6188.995658]  [<ffffffff817d1a32>] page_fault+0x22/0x30
[ 6188.996590]  [<ffffffff81375266>] ? __clear_user+0x36/0x60
[ 6188.997518]  [<ffffffff81375247>] ? __clear_user+0x17/0x60
[ 6188.998440]  [<ffffffff8100f3f1>] save_xstate_sig+0x81/0x220
[ 6188.999362]  [<ffffffff817cf1cf>] ? _raw_spin_unlock_irqrestore+0x4f/0x60
[ 6189.000291]  [<ffffffff810029e7>] do_signal+0x5c7/0x740
[ 6189.001220]  [<ffffffff81209acf>] ? mnt_drop_write+0x2f/0x40
[ 6189.002164]  [<ffffffff811e527e>] ? chmod_common+0xfe/0x150
[ 6189.003096]  [<ffffffff81002bc5>] do_notify_resume+0x65/0x80
[ 6189.004038]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6189.004972]  [<ffffffff817d00ff>] int_signal+0x12/0x17
[ 6189.005899] Code: ff 0f 85 7c 00 00 00 4c 89 ea 4c 89 e6 48 89 df e8 26 fc ff ff 65 48 8b 04 25 00 aa 00 00 c7 80 6c 07 00 00 00 00 00 00 41 56 9d <48> 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d f3 c3 65 ff 04 25 e0 
[ 6189.007935] sending NMI to other CPUs:
[ 6189.008904] NMI backtrace for cpu 2
[ 6189.009755] CPU: 2 PID: 14224 Comm: trinity-c194 Not tainted 3.18.0+ #103 [loadavg: 200.63 151.07 150.40 179/407 17316]
[ 6189.010618] task: ffff880224af5b40 ti: ffff880225aec000 task.ti: ffff880225aec000
[ 6189.011555] RIP: 0010:[<ffffffff81176890>]  [<ffffffff81176890>] pagecache_get_page+0x0/0x220
[ 6189.012501] RSP: 0018:ffff880225aefb50  EFLAGS: 00000282
[ 6189.013442] RAX: ffff88023f4b9d00 RBX: 00007fff7457b07f RCX: 0000000000000000
[ 6189.014396] RDX: 0000000000000000 RSI: 000000000001dda7 RDI: ffffffff81c6aa80
[ 6189.015357] RBP: ffff880225aefb58 R08: 0000000000000000 R09: 0000000007769c80
[ 6189.016317] R10: 0000000000000000 R11: 0000000000000029 R12: ffff88022a63be00
[ 6189.017283] R13: ffff8801c64afd10 R14: ffff880000000bd8 R15: ffff880187efea40
[ 6189.018253] FS:  00007f107fc69740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[ 6189.019247] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6189.020245] CR2: 00007fff7457b07f CR3: 000000022789e000 CR4: 00000000001407e0
[ 6189.021230] DR0: 00007f322081b000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6189.022193] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 6189.023155] Stack:
[ 6189.024104]  ffffffff811b99da ffff880225aefbf8 ffffffff811a68a1 ffff880225aefbd8
[ 6189.025084]  0000000000000246 ffffffff81042418 ffffffff00000000 0000000000000000
[ 6189.026063]  0000000000000246 0000000100000000 ffff880187efeb58 0000000000000080
[ 6189.027025] Call Trace:
[ 6189.027962]  [<ffffffff811b99da>] ? lookup_swap_cache+0x2a/0x70
[ 6189.028897]  [<ffffffff811a68a1>] handle_mm_fault+0x401/0xe90
[ 6189.029819]  [<ffffffff81042418>] ? __do_page_fault+0x198/0x5c0
[ 6189.030731]  [<ffffffff8104247c>] __do_page_fault+0x1fc/0x5c0
[ 6189.031635]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6189.032537]  [<ffffffff8107c25d>] ? __do_softirq+0x1ed/0x310
[ 6189.033432]  [<ffffffff817d09e0>] ? retint_restore_args+0xe/0xe
[ 6189.034334]  [<ffffffff8137511d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 6189.035238]  [<ffffffff8104284c>] do_page_fault+0xc/0x10
[ 6189.036146]  [<ffffffff817d1a32>] page_fault+0x22/0x30
[ 6189.037043]  [<ffffffff8100f408>] ? save_xstate_sig+0x98/0x220
[ 6189.037934]  [<ffffffff8100f3f1>] ? save_xstate_sig+0x81/0x220
[ 6189.038819]  [<ffffffff810029e7>] do_signal+0x5c7/0x740
[ 6189.039699]  [<ffffffff817cf210>] ? _raw_spin_unlock_irq+0x30/0x40
[ 6189.040583]  [<ffffffff81002bc5>] do_notify_resume+0x65/0x80
[ 6189.041464]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6189.042340]  [<ffffffff817d00ff>] int_signal+0x12/0x17
[ 6189.043210] Code: f0 80 a6 81 48 89 df e8 7f a5 02 00 0f 0b 48 89 df e8 45 fd ff ff 48 89 df e8 8d e4 00 00 eb 83 66 66 2e 0f 1f 84 00 00 00 00 00 <0f> 1f 44 00 00 55 48 89 e5 41 57 45 89 c7 41 56 49 89 f6 41 55 
[ 6189.045130] NMI backtrace for cpu 3
[ 6189.045244] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 36.225 msecs
[ 6189.046980] CPU: 3 PID: 14076 Comm: trinity-c46 Not tainted 3.18.0+ #103 [loadavg: 200.63 151.07 150.40 181/407 17316]
[ 6189.047934] task: ffff88008a6c4470 ti: ffff8801cdb58000 task.ti: ffff8801cdb58000
[ 6189.048893] RIP: 0010:[<ffffffff810c63a4>]  [<ffffffff810c63a4>] lock_release+0x34/0x240
[ 6189.049867] RSP: 0000:ffff8801cdb5bad0  EFLAGS: 00000296
[ 6189.050834] RAX: ffff88008a6c4470 RBX: ffff88013f39e4a8 RCX: 00000000000003a0
[ 6189.051815] RDX: ffffffff81178a7f RSI: 0000000000000001 RDI: ffff88013f39e518
[ 6189.052799] RBP: ffff8801cdb5bb08 R08: 0000000000000000 R09: 00000000073e8480
[ 6189.053781] R10: ffffea0007927a80 R11: 0000000000000029 R12: ffff88013f39e518
[ 6189.054764] R13: ffffffff81178a7f R14: ffff880000000bd8 R15: 0000000000000001
[ 6189.055748] FS:  00007f107fc69740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[ 6189.056746] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6189.057751] CR2: 00007fff7457b07f CR3: 0000000226f46000 CR4: 00000000001407e0
[ 6189.058770] DR0: 00007f322081b000 DR1: 0000000000[ 6216.969357] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c175:14205]
[ 6216.970331] CPU: 1 PID: 14205 Comm: trinity-c175 Tainted: G             L 3.18.0+ #103 [loadavg: 221.85 160.04 153.39 183/407 17316]
[ 6216.971359] task: ffff880056ac96d0 ti: ffff8800975d8000 task.ti: ffff8800975d8000
[ 6216.972366] RIP: 0010:[<ffffffff817cf1b8>]  [<ffffffff817cf1b8>] _raw_spin_unlock_irqrestore+0x38/0x60
[ 6216.973391] RSP: 0018:ffff8800975dba18  EFLAGS: 00000292
[ 6216.974423] RAX: 0000000000000001 RBX: ffff880056ac96d0 RCX: 0000000000005040
[ 6216.975459] RDX: ffff88024502f580 RSI: 0000000000000000 RDI: ffff88024e581e28
[ 6216.976507] RBP: ffff8800975dba28 R08: 0000000000000000 R09: ffff8800975dbaf0
[ 6216.977551] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000046
[ 6216.978594] R13: ffff8800975db9e8 R14: 0000000000000000 R15: 0000000000000000
[ 6216.979635] FS:  00007f107fc69740(0000) GS:ffff880245000000(0000) knlGS:0000000000000000
[ 6216.980686] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6216.981735] CR2: 00007fff7457af40 CR3: 00000000145ed000 CR4: 00000000001407e0
[ 6216.982774] DR0: 00007f322081b000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6216.983792] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 6216.984799] Stack:
[ 6216.985785]  ffff8800975dbad8 ffff8800975dbaf0 ffff8800975dba58 ffffffff810bcd56
[ 6216.986789]  ffff8800975dbac0 ffff8800975dbad8 ffff88024e581e28 0000000000000082
[ 6216.987794]  ffff8800975dbaa8 ffffffff817c9f4e ffff8800975dba78 000000010073e800
[ 6216.988770] Call Trace:
[ 6216.989729]  [<ffffffff810bcd56>] finish_wait+0x56/0x70
[ 6216.990693]  [<ffffffff817c9f4e>] __wait_on_bit+0x7e/0x90
[ 6216.991661]  [<ffffffff811789d7>] wait_on_page_bit_killable+0xc7/0xf0
[ 6216.992632]  [<ffffffff810bd050>] ? autoremove_wake_function+0x40/0x40
[ 6216.993609]  [<ffffffff81178ab2>] __lock_page_or_retry+0xb2/0xc0
[ 6216.994586]  [<ffffffff811a6e5c>] handle_mm_fault+0x9bc/0xe90
[ 6216.995555]  [<ffffffff81042418>] ? __do_page_fault+0x198/0x5c0
[ 6216.996516]  [<ffffffff8104247c>] __do_page_fault+0x1fc/0x5c0
[ 6216.997468]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6216.998428]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6216.999386]  [<ffffffff8107c25d>] ? __do_softirq+0x1ed/0x310
[ 6217.000330]  [<ffffffff817d09e0>] ? retint_restore_args+0xe/0xe
[ 6217.001269]  [<ffffffff8137511d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 6217.002205]  [<ffffffff8104284c>] do_page_fault+0xc/0x10
[ 6217.003136]  [<ffffffff817d1a32>] page_fault+0x22/0x30
[ 6217.004055]  [<ffffffff81375266>] ? __clear_user+0x36/0x60
[ 6217.004972]  [<ffffffff81375247>] ? __clear_user+0x17/0x60
[ 6217.005882]  [<ffffffff8100f3f1>] save_xstate_sig+0x81/0x220
[ 6217.006800]  [<ffffffff817cf1cf>] ? _raw_spin_unlock_irqrestore+0x4f/0x60
[ 6217.007716]  [<ffffffff810029e7>] do_signal+0x5c7/0x740
[ 6217.008635]  [<ffffffff81209acf>] ? mnt_drop_write+0x2f/0x40
[ 6217.009555]  [<ffffffff811e527e>] ? chmod_common+0xfe/0x150
[ 6217.010470]  [<ffffffff81002bc5>] do_notify_resume+0x65/0x80
[ 6217.011382]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6217.012297]  [<ffffffff817d00ff>] int_signal+0x12/0x17
[ 6217.013210] Code: fc 48 8b 55 08 53 48 8d 7f 18 48 89 f3 be 01 00 00 00 e8 cc 71 8f ff 4c 89 e7 e8 f4 a4 8f ff f6 c7 02 74 17 e8 0a b0 97 ff 53 9d <5b> 65 ff 0c 25 e0 a9 00 00 41 5c 5d c3 0f 1f 00 53 9d e8 f1 ae 
[ 6217.015229] sending NMI to other CPUs:
[ 6217.016191] NMI backtrace for cpu 3
[ 6217.017110] CPU: 3 PID: 14076 Comm: trinity-c46 Tainted: G             L 3.18.0+ #103 [loadavg: 221.85 160.04 153.39 183/407 17316]
[ 6217.018066] task: ffff88008a6c4470 ti: ffff8801cdb58000 task.ti: ffff8801cdb58000
[ 6217.019021] RIP: 0010:[<ffffffff810c5071>]  [<ffffffff810c5071>] __lock_acquire.isra.31+0x1b1/0x9f0
[ 6217.019997] RSP: 0000:ffff8801cdb5b9d8  EFLAGS: 00000083
[ 6217.020972] RAX: 000000000000001e RBX: ffff88008a6c4470 RCX: 0000000000000002
[ 6217.021966] RDX: 0000000000000157 RSI: 0000000000000008 RDI: 0000000000000000
[ 6217.022961] RBP: ffff8801cdb5ba48 R08: 0000000000000000 R09: 0000000000000000
[ 6217.023953] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000001d
[ 6217.024945] R13: 0000000000000001 R14: ffffffff81c50e60 R15: ffff88008a6c4c18
[ 6217.025939] FS:  00007f107fc69740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[ 6217.026943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6217.027943] CR2: 00007fff7457b07f CR3: 0000000226f46000 CR4: 00000000001407e0
[ 6217.028933] DR0: 00007f322081b000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6217.029896] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 6217.030846] Stack:
[ 6217.031772]  ffff88008a6c4470 ffff88024e52e040 ffff8801cdb5ba28 0000000000000092
[ 6217.032708]  ffff8801cdb5ba08 ffffffff810abab5 ffff8801cdb5ba88 ffffffff810c50ec
[ 6217.033625]  0000000000000296 0000000000000246 0000000000000000 0000000000000000
[ 6217.034537] Call Trace:
[ 6217.035425]  [<ffffffff810abab5>] ? local_clock+0x25/0x30
[ 6217.036316]  [<ffffffff810c50ec>] ? __lock_acquire.isra.31+0x22c/0x9f0
[ 6217.037210]  [<ffffffff810c5fbf>] lock_acquire+0x9f/0x120
[ 6217.038103]  [<ffffffff811766d5>] ? find_get_entry+0x5/0x120
[ 6217.038995]  [<ffffffff81176717>] find_get_entry+0x47/0x120
[ 6217.039891]  [<ffffffff811766d5>] ? find_get_entry+0x5/0x120
[ 6217.040776]  [<ffffffff811768bf>] pagecache_get_page+0x2f/0x220
[ 6217.041653]  [<ffffffff8116f842>] ? __perf_sw_event+0x82/0x240
[ 6217.042527]  [<ffffffff811b99da>] lookup_swap_cache+0x2a/0x70
[ 6217.043399]  [<ffffffff811a68a1>] handle_mm_fault+0x401/0xe90
[ 6217.044273]  [<ffffffff81042418>] ? __do_page_fault+0x198/0x5c0
[ 6217.045140]  [<ffffffff8104247c>] __do_page_fault+0x1fc/0x5c0
[ 6217.045999]  [<ffffffff8107c25d>] ? __do_softirq+0x1ed/0x310
[ 6217.046857]  [<ffffffff817d09e0>] ? retint_restore_args+0xe/0xe
[ 6217.047713]  [<ffffffff81042358>] ? __do_page_fault+0xd8/0x5c0
[ 6217.048562]  [<ffffffff8137511d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 6217.049414]  [<ffffffff8104284c>] do_page_fault+0xc/0x10
[ 6217.050263]  [<ffffffff817d1a32>] page_fault+0x22/0x30
[ 6217.051108]  [<ffffffff8100f408>] ? save_xstate_sig+0x98/0x220
[ 6217.051953]  [<ffffffff8100f3f1>] ? save_xstate_sig+0x81/0x220
[ 6217.052787]  [<ffffffff810029e7>] do_signal+0x5c7/0x740
[ 6217.053620]  [<ffffffff817cf210>] ? _raw_spin_unlock_irq+0x30/0x40
[ 6217.054457]  [<ffffffff81002bc5>] do_notify_resume+0x65/0x80
[ 6217.055294]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6217.056133]  [<ffffffff817d00ff>] int_signal+0x12/0x17
[ 6217.056977] Code: ea 48 8d 34 d5 00 00 00 00 48 c1 e2 06 48 29 f2 4c 8d bc 13 70 07 00 00 41 0f b7 57 f8 81 e2 ff 1f 00 00 39 d0 0f 84 3f 01 00 00 <41> 0f b7 57 30 66 25 ff 1f 4c 89 4d c8 41 c1 e2 07 83 e1 03 4d 
[ 6217.058855] NMI backtrace for cpu 2
[ 6217.059739] CPU: 2 PID: 14224 Comm: trinity-c194 Tainted: G             L 3.18.0+ #103 [loadavg: 221.85 160.04 153.39 183/407 17316]
[ 6217.060662] task: ffff880224af5b40 ti: ffff880225aec000 task.ti: ffff880225aec000
[ 6217.061589] RIP: 0010:[<ffffffff810c6396>]  [<ffffffff810c6396>] lock_release+0x26/0x240
[ 6217.062533] RSP: 0018:ffff880225aefa10  EFLAGS: 00000046
[ 6217.063477] RAX: ffff880224af5b40 RBX: 0000000000000296 RCX: 0000000000000002
[ 6217.064435] RDX: ffffffff810bcd56 RSI: 0000000000000001 RDI: ffff88024e54da40
[ 6217.065392] RBP: ffff880225aefa28 R08: 0000000000000000 R09: ffff880225aefb10
[ 6217.066342] R[ 6217.158570] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 142.293 msecs
[ 6225.814243] INFO: rcu_sched self-detected stall on CPU
[ 6225.815127] 	3: (5990 ticks this GP) idle=f83/140000000000001/0 softirq=390686/390686 
[ 6225.816000] 	 (t=6000 jiffies g=166553 c=166552 q=0)
[ 6225.816870] Task dump for CPU 3:
[ 6225.817736] trinity-c46     R  running task    13568 14076  13551 0x1000000c
[ 6225.818626]  ffff88008a6c4470 00000000ef08e0c8 ffff880245403d68 ffffffff810a73fc
[ 6225.819531]  ffffffff810a7362 0000000000000003 0000000000000008 0000000000000003
[ 6225.820432]  ffffffff81c523c0 0000000000000092 ffff880245403d88 ffffffff810ab4ad
[ 6225.821340] Call Trace:
[ 6225.822218]  <IRQ>  [<ffffffff810a73fc>] sched_show_task+0x11c/0x190
[ 6225.823122]  [<ffffffff810a7362>] ? sched_show_task+0x82/0x190
[ 6225.824021]  [<ffffffff810ab4ad>] dump_cpu_task+0x3d/0x50
[ 6225.824916]  [<ffffffff810d9bf0>] rcu_dump_cpu_stacks+0x90/0xd0
[ 6225.825813]  [<ffffffff810e0783>] rcu_check_callbacks+0x503/0x770
[ 6225.826697]  [<ffffffff811304dc>] ? acct_account_cputime+0x1c/0x20
[ 6225.827581]  [<ffffffff810abde7>] ? account_system_time+0x97/0x180
[ 6225.828464]  [<ffffffff810e645b>] update_process_times+0x4b/0x80
[ 6225.829350]  [<ffffffff810f6e13>] ? tick_sched_timer+0x23/0x1b0
[ 6225.830233]  [<ffffffff810f6e3f>] tick_sched_timer+0x4f/0x1b0
[ 6225.831108]  [<ffffffff810e72ff>] __run_hrtimer+0xaf/0x240
[ 6225.831977]  [<ffffffff810e76eb>] ? hrtimer_interrupt+0x16b/0x260
[ 6225.832844]  [<ffffffff810f6df0>] ? tick_init_highres+0x20/0x20
[ 6225.833709]  [<ffffffff810e7687>] hrtimer_interrupt+0x107/0x260
[ 6225.834565]  [<ffffffff81031e9b>] local_apic_timer_interrupt+0x3b/0x70
[ 6225.835384]  [<ffffffff817d28c5>] smp_apic_timer_interrupt+0x45/0x60
[ 6225.836203]  [<ffffffff817d0caf>] apic_timer_interrupt+0x6f/0x80
[ 6225.837023]  <EOI>  [<ffffffff810c50ec>] ? __lock_acquire.isra.31+0x22c/0x9f0
[ 6225.837858]  [<ffffffff810c5fd4>] ? lock_acquire+0xb4/0x120
[ 6225.838688]  [<ffffffff81042418>] ? __do_page_fault+0x198/0x5c0
[ 6225.839517]  [<ffffffff810c225a>] down_read_trylock+0x5a/0x60
[ 6225.840345]  [<ffffffff81042418>] ? __do_page_fault+0x198/0x5c0
[ 6225.841175]  [<ffffffff81042418>] __do_page_fault+0x198/0x5c0
[ 6225.842004]  [<ffffffff8107c25d>] ? __do_softirq+0x1ed/0x310
[ 6225.842836]  [<ffffffff817d09e0>] ? retint_restore_args+0xe/0xe
[ 6225.843672]  [<ffffffff81042358>] ? __do_page_fault+0xd8/0x5c0
[ 6225.844506]  [<ffffffff8137511d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 6225.845340]  [<ffffffff8104284c>] do_page_fault+0xc/0x10
[ 6225.846174]  [<ffffffff817d1a32>] page_fault+0x22/0x30
[ 6225.847002]  [<ffffffff8100f408>] ? save_xstate_sig+0x98/0x220
[ 6225.847827]  [<ffffffff8100f3f1>] ? save_xstate_sig+0x81/0x220
[ 6225.848648]  [<ffffffff810029e7>] do_signal+0x5c7/0x740
[ 6225.849468]  [<ffffffff817cf210>] ? _raw_spin_unlock_irq+0x30/0x40
[ 6225.850287]  [<ffffffff81002bc5>] do_notify_resume+0x65/0x80
[ 6225.851104]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6225.851927]  [<ffffffff817d00ff>] int_signal+0x12/0x17
[ 6225.852746] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 6225.853609] 	3: (5991 ticks this GP) idle=f83/140000000000000/0 softirq=390686/390686 
[ 6225.854481] 	(detected by 1, t=6004 jiffies, g=166553, c=166552, q=0)
[ 6225.855354] Task dump for CPU 3:
[ 6225.856225] trinity-c46     R  running task    13568 14076  13551 0x1000000c
[ 6225.857127]  ffffffff810bcd38 ffff88008a6c4470 ffff8801cdb5b9c8 ffffffff810abab5
[ 6225.858045]  ffff88024e52e040 0000000000000046 ffff88008a6c4470 ffff88024e52e040
[ 6225.858951]  ffff8801cdb5ba28 0000000000000092 ffffffff810bcb37 ffffffff810abab5
[ 6225.859860] Call Trace:
[ 6225.860761]  [<ffffffff810c35df>] ? lock_release_holdtime.part.24+0xf/0x190
[ 6225.861690]  [<ffffffff810abab5>] ? local_clock+0x25/0x30
[ 6225.862612]  [<ffffffff810c35df>] lock_release_holdtime.part.24+0xf/0x190
[ 6225.863543]  [<ffffffff810abab5>] ? local_clock+0x25/0x30
[ 6225.864473]  [<ffffffff810c50ec>] ? __lock_acquire.isra.31+0x22c/0x9f0
[ 6225.865402]  [<ffffffff810bcd56>] ? finish_wait+0x56/0x70
[ 6225.866329]  [<ffffffff817c9f4e>] ? __wait_on_bit+0x7e/0x90
[ 6225.867236]  [<ffffffff811789d7>] ? wait_on_page_bit_killable+0xc7/0xf0
[ 6225.868122]  [<ffffffff810bd050>] ? autoremove_wake_function+0x40/0x40
[ 6225.868996]  [<ffffffff811b99da>] ? lookup_swap_cache+0x2a/0x70
[ 6225.869855]  [<ffffffff811a68f8>] ? handle_mm_fault+0x458/0xe90
[ 6225.870706]  [<ffffffff810c225a>] ? down_read_trylock+0x5a/0x60
[ 6225.871545]  [<ffffffff8104247c>] ? __do_page_fault+0x1fc/0x5c0
[ 6225.872385]  [<ffffffff8107c25d>] ? __do_softirq+0x1ed/0x310
[ 6225.873219]  [<ffffffff817d09e0>] ? retint_restore_args+0xe/0xe
[ 6225.874046]  [<ffffffff81042358>] ? __do_page_fault+0xd8/0x5c0
[ 6225.874873]  [<ffffffff8137511d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 6225.875692]  [<ffffffff8104284c>] ? do_page_fault+0xc/0x10
[ 6225.876503]  [<ffffffff817d1a32>] ? page_fault+0x22/0x30
[ 6225.877307]  [<ffffffff8100f408>] ? save_xstate_sig+0x98/0x220
[ 6225.878107]  [<ffffffff8100f3f1>] ? save_xstate_sig+0x81/0x220
[ 6225.878901]  [<ffffffff810029e7>] ? do_signal+0x5c7/0x740
[ 6225.879695]  [<ffffffff817cf210>] ? _raw_spin_unlock_irq+0x30/0x40
[ 6225.880496]  [<ffffffff81002bc5>] ? do_notify_resume+0x65/0x80
[ 6225.881292]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6225.882097]  [<ffffffff817d00ff>] ? int_signal+0x12/0x17
[ 6244.953181] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [trinity-c194:14224]
[ 6244.953995] CPU: 2 PID: 14224 Comm: trinity-c194 Tainted: G             L 3.18.0+ #103 [loadavg: 238.82 170.06 156.93 185/407 17316]
[ 6244.954854] task: ffff880224af5b40 ti: ffff880225aec000 task.ti: ffff880225aec000
[ 6244.955699] RIP: 0010:[<ffffffff810c5f60>]  [<ffffffff810c5f60>] lock_acquire+0x40/0x120
[ 6244.956560] RSP: 0018:ffff880225aefb78  EFLAGS: 00000246
[ 6244.957418] RAX: ffff880224af5b40 RBX: ffff8802453ce380 RCX: 0000000000000001
[ 6244.958281] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
[ 6244.959146] RBP: ffff880225aefbd8 R08: 0000000000000001 R09: 0000000000000000
[ 6244.960008] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000001ce380
[ 6244.960867] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880225aefb28
[ 6244.961716] FS:  00007f107fc69740(0000) GS:ffff880245200000(0000) knlGS:0000000000000000
[ 6244.962571] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6244.963429] CR2: 00007fff7457b07f CR3: 000000022789e000 CR4: 00000000001407e0
[ 6244.964296] DR0: 00007f322081b000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6244.965160] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 6244.966025] Stack:
[ 6244.966881]  0000000005080021 ffffffff00000000 0000000000000000 0000000000000246
[ 6244.967776]  0000000100000000 ffff880187efeb58 0000000000000000 0000000000000029
[ 6244.968678]  00007fff7457b07f ffff880225aefd28 0000000000000002 ffff880187efea40
[ 6244.969564] Call Trace:
[ 6244.970445]  [<ffffffff810c225a>] down_read_trylock+0x5a/0x60
[ 6244.971336]  [<ffffffff81042418>] ? __do_page_fault+0x198/0x5c0
[ 6244.972226]  [<ffffffff81042418>] __do_page_fault+0x198/0x5c0
[ 6244.973125]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6244.974021]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6244.974913]  [<ffffffff8107c25d>] ? __do_softirq+0x1ed/0x310
[ 6244.975800]  [<ffffffff817d09e0>] ? retint_restore_args+0xe/0xe
[ 6244.976685]  [<ffffffff8137511d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 6244.977573]  [<ffffffff8104284c>] do_page_fault+0xc/0x10
[ 6244.978455]  [<ffffffff817d1a32>] page_fault+0x22/0x30
[ 6244.979327]  [<ffffffff8100f408>] ? save_xstate_sig+0x98/0x220
[ 6244.980190]  [<ffffffff8100f3f1>] ? save_xstate_sig+0x81/0x220
[ 6244.981045]  [<ffffffff810029e7>] do_signal+0x5c7/0x740
[ 6244.981892]  [<ffffffff817cf210>] ? _raw_spin_unlock_irq+0x30/0x40
[ 6244.982743]  [<ffffffff81002bc5>] do_notify_resume+0x65/0x80
[ 6244.983582]  [<ffffffff813750de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6244.984425]  [<ffffffff817d00ff>] int_signal+0x12/0x17
[ 6244.985266] Code: 65 48 8b 04 25 00 aa 00 00 8b b8 6c 07 00 00 44 89 45 c4 85 ff 0f 85 84 00 00 00 41 89 f4 41 89 d5 41 89 ce 4d 89 cf 9c 8f 45 b8 <fa> c7 80 6c 07 00 00 01 00 00 00 0f 1f 44 00 00 65 ff 04 25 e0 
[ 6244.987120] sending NMI to other CPUs:
