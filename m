Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3EHR0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:26:04 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:58463 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab3EHR0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:26:02 -0400
Date: Wed, 8 May 2013 13:25:58 -0400 (EDT)
From: Zhouping Liu <zliu@redhat.com>
To: CAI Qian <caiqian@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <915207234.8181012.1368033958312.JavaMail.root@redhat.com>
In-Reply-To: <CAOc6HJ6wx=0zbK7X3bh9djGOvZe0M9NMbJs3JTFAJcpg8XNbpA@mail.gmail.com>
References: <1105830748.7586320.1367827006237.JavaMail.root@redhat.com> <1041117939.7586618.1367827116620.JavaMail.root@redhat.com> <CAOc6HJ6wx=0zbK7X3bh9djGOvZe0M9NMbJs3JTFAJcpg8XNbpA@mail.gmail.com>
Subject: Re: 3.9.0: panic during boot at tick_do_broadcast
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.0: panic during boot at tick_do_broadcast
Thread-Index: SW8ZxW79FCIjhXuJ1MK6pFThXNTy5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: CAI Qian <caiqian@redhat.com>
> Date: 2013/5/6
> Subject: 3.9.0: panic during boot at tick_do_broadcast
> To: LKML vger.kernel.org>

I bisected it, and found the murderer was this commit:
b352bc1cbc29 tick: Convert broadcast cpu bitmaps to cpumask_var_t

(CC'ed the patches' author Thomas.)

Hello Thomas, could you have a look at this issue?

Thanks,
Zhouping

> 
> 
> Never saw any of those during testing of all 3.9 rc releases.
> 
> [    1.023422] Intel PMU driver.
> [    1.025859] perf_event_intel: PEBS disabled due to CPU errata, please
> upgrade microcode
> [    1.032534] ... version:                3
> [    1.036078] ... bit width:              48
> [    1.039506] ... generic registers:      8
> [    1.042856] ... value mask:             0000ffffffffffff
> [    1.047382] ... max period:             000000007fffffff
> [    1.052229] ... fixed-purpose events:   3
> [    1.055641] ... event mask:             00000007000000ff
> [    1.065070] smpboot: Booting Node   0, Processors  #1
> [    1.082422] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000048
> [    1.089361] IP: [] tick_do_broadcast+0x6f/0xb0
> [    1.094455] PGD 0
> [    1.096126] Oops: 0000 [#1] SMP
> [    1.098793] Modules linked in:
> [    1.101464] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0+ #1
> [    1.106487] Hardware nt DL120 G7, BIOS J01 02/01/2012
> [    1.510871] task: ffff8802041c8000 ti: ffff8802041c2000 task.ti:
> ffff8802041c2000
> [    1.517310] RIP: 0010:[]  []
> tick_do_broadcast+0x6f/0xb0
> [    1.524408] RSP: 0000:ffff88020f403d10  EFLAGS: 00010002
> [    1.528867] RAX: 0000000000000000 RBX: ffff88020705a0d0 RCX:
> 0000000000000001
> [    1.535019] RDX: 0000000000000001 RSI: 0000000000000040 RDI:
> ffff88020705a0d0
> [    1.540963] RBP: ffff88020f403d20 R08: 0000000000000002 R09:
> 0000000000000001
> [    1.546980] R10: 0000000000000002 R11: 000000000000b37c R12:
> 000000000000d9a0
> [    1.553124] R13: 0000000000000000 R14: 0000000000000000 R15:
> 0000000000000001
> [    1.559060] FS:  0000000000000000(0000) GS:ffff88020f400000(0000)
> knlGS:0000000000000000
> [    1.566007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.570771] CR2: 0000000000000048 CR3: 00000000018d5000 CR4:
> 00000000000407f0
> [    1.576792] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [    1.582933] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [    1.588880] Stack:
> [    1.590563]  ffffffff818dca80 ffffffff818e8400 ffff88020f403d30
> ffffffff810a75b1
> [    1.596932]  ffff88020f403d50 ffffffff810a75d4 0 0000000000000000
> [    2.002208]  ffff88020f403d60 ffffffff81004935 ffff88020f403db0
> ffffffff810df624
> [    2.008450] Call Trace:
> [    2.010471]  
> [    2.012057]  [] tick_do_periodic_broadcast+0x41/0x50
> [    2.017847]  []
> tick_handle_periodic_broadcast+0x14/0x50
> [    2.023640]  [] timer_interrupt+0x15/0x20
> [    2.028291]  [] handle_irq_event_percpu+0x54/0x1e0
> [    2.033810]  [] ? task_tick_fair+0x16e/0x550
> [    2.038626]  [] handle_irq_event+0x42/0x70
> [    2.043418]  [] handle_edge_irq+0x6f/0x110
> [    2.048508]  [] handle_irq+0xbf/0x150
> [    2.052945]  [] ? irq_enter+0x51/0x90
> [    2.057362]  [] ? update_curr+0xec/0x170
> [    2.062044]  [] do_IRQ+0x5a/0xe0
> [    2.066110]  [] common_interrupt+0x6a/0x6a
> [    2.070846]  [] ? __do_softirq+0x94/0x220
> [    2.075555]  [] ? __do_softirq+0x51/0x220
> [    2.080335]  [] irq_exit+0xa5/0xb0
> [    2.084518]  [] smp_apic_timer_interrupt+0x6e/0x99
> [    2.089842]  [] apic_timer_interrupt+0x6a/0x70
> [    2.095022]  
> [    2.096597]  [] ? native_cpu_up+0x157.309461]
>  [] _cpu_up+0xc0/0x133
> [    2.505201]  [] cpu_up+0xd7/0xea
> [    2.509184]  [] smp_init+0x76/0xa6
> [    2.513717]  [] kernel_init_freeable+0xdb/0x1ec
> [    2.518789]  [] ? rest_init+0x80/0x80
> [    2.523207]  [] kernel_init+0xe/0xf0
> [    2.527647]  [] ret_from_fork+0x7c/0xb0
> [    2.532127]  [] ? rest_init+0x80/0x80
> [    2.536569] Code: c3 0f 1f 00 48 63 35 15 8e 92 00 48 89 df 49 c7 c4 a0
> d9 00 00 e8 52 e0 24 00 89 c0 48 89 df 48 8b 04 c5 e0 43 9c 81 4a 8b 04 20
>  50 48 48 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 40 00 f0 0f b3 07
> [    2.552724] RIP  [] tick_do_broadcast+0x6f/0xb0
> [    2.558161]  RSP 
> [    2.561059] CR2: 0000000000000048
> [    2.563901] ---[ end trace e29222d88d06c928 ]---
> [    2.567755] Kernel panic - not syncing: Fatal exception in interrupt
> [    3.600013] Shutting down cpus with NMI
> 
> CAI Qian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Thanks,
Zhouping
