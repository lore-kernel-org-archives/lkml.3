Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaECC6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 22:58:49 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:38207 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaECC6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 22:58:47 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 2 May 2014 23:02:25 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405022253530.25174@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
 <20140502154217.GW11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu> <20140502162234.GX11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu>
 <20140502172731.GK30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Vince Weaver wrote:

> I've been fuzzing without your additional patch for 6 hours and all looks
> (almost) good.  I can add in your patch and let it fuzz overnight.

and I applied the additional patch, installed the kernel, hit reboot, and 
the following happened (this was caused by rebooting while fuzzing
was ongoing) :(

I'm remote from the system too so the poor machine is going to be sitting 
there oopsing away until Monday.

The system is going down for reboot NOW!
INIT: Switching to runlevel: 6
INIT: Sending p
[24444.795403] ------------[ cut here ]------------
[24444.802143] WARNING: CPU: 1 PID: 23062 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
[24444.812613] list_del corruption. prev->next should be ffff8800c9028010, but was 6b6b6b6b6b6b6b6b
[24444.908976] CPU: 1 PID: 23062 Comm: perf_fuzzer Tainted: G        W     3.15.0-rc1+ #102
[24444.919934] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[24444.930206]  0000000000000009 ffff8800c8991ad8 ffffffff81649c80 ffff8800c8991b20
[24444.940667]  ffff8800c8991b10 ffffffff810646ad ffff8800c9028000 ffff8801181bf000
[24444.951155]  ffff8800c9028010 ffff8800c9028000 0000000000000001 ffff8800c8991b70
[24444.961677] Call Trace:
[24444.967131]  [<ffffffff81649c80>] dump_stack+0x45/0x56
[24444.975333]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
[24444.984433]  [<ffffffff8106471c>] warn_slowpath_fmt+0x4c/0x50
[24444.993286]  [<ffffffff813c9fc1>] __list_del_entry+0xa1/0xd0
[24445.002082]  [<ffffffff81131ec4>] list_del_event+0xe4/0xf0
[24445.010729]  [<ffffffff811326c0>] perf_remove_from_context+0xb0/0x120
[24445.020315]  [<ffffffff81133d8f>] perf_event_release_kernel+0x3f/0x80
[24445.029918]  [<ffffffff81133ea3>] put_event+0xd3/0x100
[24445.038205]  [<ffffffff81133e00>] ? put_event+0x30/0x100
[24445.046638]  [<ffffffff81133ee5>] perf_release+0x15/0x20
[24445.055082]  [<ffffffff811b69dc>] __fput+0xdc/0x1e0
[24445.063108]  [<ffffffff811b6b2e>] ____fput+0xe/0x10
[24445.071114]  [<ffffffff81085154>] task_work_run+0xc4/0xe0
[24445.079679]  [<ffffffff81066d5c>] do_exit+0x2cc/0xa50
[24445.087922]  [<ffffffff81076949>] ? get_signal_to_deliver+0x249/0x650
[24445.097582]  [<ffffffff8106756c>] do_group_exit+0x4c/0xc0
[24445.106200]  [<ffffffff81076991>] get_signal_to_deliver+0x291/0x650
[24445.115733]  [<ffffffff81012438>] do_signal+0x48/0x990
[24445.124132]  [<ffffffff81090c4d>] ? finish_task_switch+0x7d/0x120
[24445.133520]  [<ffffffff81651417>] ? _raw_spin_unlock_irq+0x27/0x40
[24445.143007]  [<ffffffff81090c4d>] ? finish_task_switch+0x7d/0x120
[24445.152398]  [<ffffffff81090c0f>] ? finish_task_switch+0x3f/0x120
[24445.161807]  [<ffffffff81012df0>] do_notify_resume+0x70/0xa0
[24445.170791]  [<ffffffff81651fbc>] retint_signal+0x48/0x8c
[24445.179516] ---[ end trace d44f7960e96a18db ]---
[24445.627788] ------------[ cut here ]------------
[24445.635804] WARNING: CPU: 2 PID: 23062 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
[24445.646825] list_del corruption. prev->next should be ffff8800ce89a810, but was 6b6b6b6b6b6b6b6b
[info] Will now restart.
[24454.007929] general protection fault: 0000 [#1] SMP 
[24454.016867] Dumping ftrace buffer:
[24454.023308]    (ftrace buffer empty)
[24454.117735] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W     3.15.0-rc1+ #102
[24454.127563] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[24454.137169] task: ffffffff81c184c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[24454.146980] RIP: 0010:[<ffffffff811356d2>]  [<ffffffff811356d2>] __perf_remove_from_context+0x22/0xd0
[24454.158482] RSP: 0018:ffff88011ea03f18  EFLAGS: 00010087
[24454.165746] RAX: 01b8550000441f0f RBX: ffffffff81019590 RCX: 000000000000000a
[24454.174917] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff880118f0b800
[24454.184018] RBP: ffff88011ea03f40 R08: 0000000000000000 R09: 0000000000000001
[24454.193001] R10: 0000000000000000 R11: 0000000225c17d03 R12: ffff88011ea18310
[24454.202013] R13: ffff88011ea18310 R14: 0000000000000005 R15: ffff880118f0b800
[24454.211207] FS:  0000000000000000(0000) GS:ffff88011ea00000(0000) knlGS:0000000000000000
[24454.221242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[24454.228734] CR2: 00007f449fcb0d20 CR3: 0000000001c11000 CR4: 00000000001407f0
[24454.237680] DR0: 0000000000000000 DR1: 0000000002106000 DR2: 0000000000000000
[24454.246599] DR3: 0000000002106000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[24454.255588] Stack:
[24454.258976]  ffff880118f0b800 ffff88011ea18310 ffff88011ea18408 0000000000000005
[24454.268286]  ffffffff81c99ab0 ffff88011ea03f78 ffffffff81135818 ffffffff811357b5
[24454.277423]  ffff880118f0b800 ffff880036de1c98 0000000000000000 0000163b0f931a27
[24454.286642] Call Trace:
[24454.290378]  <IRQ> 
[24454.292457]  [<ffffffff81135818>] __perf_event_exit_context+0x98/0xf0
[24454.301858]  [<ffffffff811357b5>] ? __perf_event_exit_context+0x35/0xf0
[24454.310098]  [<ffffffff810de20d>] generic_smp_call_function_single_interrupt+0x5d/0x100
[24454.319785]  [<ffffffff81042197>] smp_call_function_single_interrupt+0x27/0x40
[24454.328627]  [<ffffffff8165bb9d>] call_function_single_interrupt+0x6d/0x80
[24454.337078]  <EOI> 
[24454.339156]  [<ffffffff814e1b52>] ? cpuidle_enter_state+0x52/0xc0
[24454.347970]  [<ffffffff814e1b48>] ? cpuidle_enter_state+0x48/0xc0
[24454.355492]  [<ffffffff814e1bf7>] cpuidle_enter+0x17/0x20
[24454.362218]  [<ffffffff810aa270>] cpu_startup_entry+0x2c0/0x3d0
[24454.369450]  [<ffffffff81639ba6>] rest_init+0xb6/0xc0
[24454.375753]  [<ffffffff81639af5>] ? rest_init+0x5/0xc0
[24454.382110]  [<ffffffff81d05f75>] start_kernel+0x43d/0x448
[24454.388873]  [<ffffffff81d05941>] ? repair_env_string+0x5c/0x5c
[24454.396094]  [<ffffffff81d05120>] ? early_idt_handlers+0x120/0x120
[24454.403605]  [<ffffffff81d055ee>] x86_64_start_reservations+0x2a/0x2c
[24454.411393]  [<ffffffff81d05733>] x86_64_start_kernel+0x143/0x152
[24454.418825] Code: 70 ff ff ff 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 49 89 ff 41 56 41 55 41 54 53 4c 8b 2f 49 8b 9d d8 01 00 00 48 8b 03 <4c> 8b 60 38 65 4c 03 24 25 e8 de 00 00 4c 8d 73 10 4c 89 f7 e8 
[24454.441219] RIP  [<ffffffff811356d2>] __perf_remove_from_context+0x22/0xd0
[24454.449564]  RSP <ffff88011ea03f18>
[24454.454447] bad: scheduling from the idle thread!
...
etc, forever
