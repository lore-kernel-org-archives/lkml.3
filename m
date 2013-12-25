Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3LYDYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 22:24:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52067 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3LYDYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 22:24:46 -0500
Message-ID: <1387941877.5373.10.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
From: Mike Galbraith <bitbucket@online.de>
To: pavel@pavlinux.ru
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Wed, 25 Dec 2013 04:24:37 +0100
In-Reply-To: <52B9B8C9.3090406@pavlinux.ru>
References: <20131223225017.GA8623@linutronix.de>
	 <1387900067.5490.33.camel@marge.simpson.net> <52B9B8C9.3090406@pavlinux.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:6+lLezMZFvjrowf++4g2OOUw2egp3uBvh9QJQ7ldUIr
 XbYcWr4dRLByZCLsXjXHtzrMe2dHRnQQu5Denu0Q5CJOY6OR5T
 lfMk8+DORapA3qANf2XLUCEbegakGjzgdEaxDjOvb8AjOxOlow
 0L997dTkUOgmzq7iWBAa5Ii6rp+a+fPfLTPt9pisHNBGHzVUWa
 +KZFRUrk4NlV6tEjA/X2g12VkIku3ujCUMHFrQSik0fvszy7ww
 yBFgzSIrGyb84o3EFjVfDhVcro1K1LRZUdcAUCkaMHRX5yuEF4
 t6iF1NiRP63iATw50bSo2pAqH3g5UGsikUfRkC6fl0ktudu/9B
 oA/8qM4qaPmCyNm33EeiYugd+iuDKnpeBsfCwj8L6b090F+qkI
 XG6xyYn5o63/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 20:39 +0400, Pavel Vasilyev wrote: 
> 24.12.2013 19:47, Mike Galbraith пишет:
> > On Mon, 2013-12-23 at 23:50 +0100, Sebastian Andrzej Siewior wrote: 
> 
> > crash> bt
> > PID: 508    TASK: ffff8802739ba340  CPU: 16  COMMAND: "ksoftirqd/16"
> 
> YES!!! And ARM code broke :)

And NO_HZ_TICK config survived for only 4.5 hours.

PID: 6948   TASK: ffff880272d1f1c0  CPU: 29  COMMAND: "tbench"
 #0 [ffff8802769a6a40] machine_kexec at ffffffff8103bc07
 #1 [ffff8802769a6aa0] crash_kexec at ffffffff810d3e93
 #2 [ffff8802769a6b70] panic at ffffffff815bce70
 #3 [ffff8802769a6bf0] watchdog_overflow_callback at ffffffff810fd51d
 #4 [ffff8802769a6c10] __perf_event_overflow at ffffffff8112f1f8
 #5 [ffff8802769a6ca0] perf_event_overflow at ffffffff8112fb14
 #6 [ffff8802769a6cb0] intel_pmu_handle_irq at ffffffff8102078f
 #7 [ffff8802769a6de0] perf_event_nmi_handler at ffffffff815c2de5
 #8 [ffff8802769a6e10] nmi_handle at ffffffff815c2493
 #9 [ffff8802769a6ea0] default_do_nmi at ffffffff815c2623
#10 [ffff8802769a6ed0] do_nmi at ffffffff815c2948
#11 [ffff8802769a6ef0] end_repeat_nmi at ffffffff815c1931
    [exception RIP: preempt_schedule+36]
    RIP: ffffffff815be944  RSP: ffff8802769a3d98  RFLAGS: 00000002
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000002
    RDX: ffff8802769a3d98  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff815be944   R8: ffffffff815be944   R9: 0000000000000018
    R10: ffff8802769a3d98  R11: 0000000000000002  R12: ffffffffffffffff
    R13: ffff880273f74000  R14: ffff880272d1f1c0  R15: ffff880269cedfd8
    ORIG_RAX: ffff880269cedfd8  CS: 0010  SS: 0018
--- <RT exception stack> ---
#12 [ffff8802769a3d98] preempt_schedule at ffffffff815be944
#13 [ffff8802769a3db0] _raw_spin_trylock at ffffffff815c0d6e
#14 [ffff8802769a3dc0] rt_spin_lock_slowunlock_hirq at ffffffff815c0288
#15 [ffff8802769a3de0] rt_spin_unlock_after_trylock_in_irq at ffffffff815c09e5
#16 [ffff8802769a3df0] run_local_timers at ffffffff81068025
#17 [ffff8802769a3e10] update_process_times at ffffffff810680ac
#18 [ffff8802769a3e40] tick_sched_handle at ffffffff810c3a92
#19 [ffff8802769a3e60] tick_sched_timer at ffffffff810c3d2f
#20 [ffff8802769a3e90] __run_hrtimer at ffffffff8108471d
#21 [ffff8802769a3ed0] hrtimer_interrupt at ffffffff8108497a
#22 [ffff8802769a3f70] local_apic_timer_interrupt at ffffffff810349e6
#23 [ffff8802769a3f90] smp_apic_timer_interrupt at ffffffff810358ee
#24 [ffff8802769a3fb0] apic_timer_interrupt at ffffffff815c955d
--- <IRQ stack> ---
#25 [ffff880269ced848] apic_timer_interrupt at ffffffff815c955d
    [exception RIP: _raw_spin_lock+53]
    RIP: ffffffff815c0c05  RSP: ffff880269ced8f8  RFLAGS: 00000202
    RAX: 0000000000000b7b  RBX: 0000000000000282  RCX: ffff880272d1f1c0
    RDX: 0000000000000b7d  RSI: ffff880269ceda38  RDI: ffff880273f74000
    RBP: ffff880269ced8f8   R8: 0000000000000001   R9: 00000000b54d13a4
    R10: 0000000000000001  R11: 0000000000000001  R12: ffff880269ced910
    R13: ffff880276d32170  R14: ffffffff810c9030  R15: ffff880269ced8b8
    ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018
#26 [ffff880269ced900] rt_spin_lock_slowlock at ffffffff815bfb51
#27 [ffff880269ced9e0] rt_spin_lock at ffffffff815c0922
#28 [ffff880269ced9f0] lock_timer_base at ffffffff81067f92
#29 [ffff880269ceda20] mod_timer at ffffffff81069bcb
#30 [ffff880269ceda70] sk_reset_timer at ffffffff814d1e57
#31 [ffff880269ceda90] inet_csk_reset_xmit_timer at ffffffff8152d4a8
#32 [ffff880269cedac0] tcp_rearm_rto at ffffffff8152d583
#33 [ffff880269cedae0] tcp_ack at ffffffff81534085
#34 [ffff880269cedb60] tcp_rcv_established at ffffffff8153443d
#35 [ffff880269cedbb0] tcp_v4_do_rcv at ffffffff8153f56a
#36 [ffff880269cedbe0] __release_sock at ffffffff814d3891
#37 [ffff880269cedc10] release_sock at ffffffff814d3942
#38 [ffff880269cedc30] tcp_sendmsg at ffffffff8152b955
#39 [ffff880269cedd00] inet_sendmsg at ffffffff8155350e
#40 [ffff880269cedd30] sock_sendmsg at ffffffff814cea87
#41 [ffff880269cede40] sys_sendto at ffffffff814cebdf
#42 [ffff880269cedf80] tracesys at ffffffff815c8b09 (via system_call)
    RIP: 00007f0441a1fc35  RSP: 00007fffdea86130  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: ffffffff815c8b09  RCX: ffffffffffffffff
    RDX: 000000000000248d  RSI: 0000000000607260  RDI: 0000000000000004
    RBP: 000000000000248d   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007fffdea86a10
    R13: 00007fffdea86414  R14: 0000000000000004  R15: 0000000000607260
    ORIG_RAX: 000000000000002c  CS: 0033  SS: 002b


