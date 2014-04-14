Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaDNXpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:45:46 -0400
Received: from www.meduna.org ([92.240.244.38]:41363 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaDNXpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:45:44 -0400
Message-ID: <534C731F.1050406@meduna.org>
Date: Tue, 15 Apr 2014 01:45:35 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
References: <534C3606.7010206@meduna.org>
In-Reply-To: <534C3606.7010206@meduna.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-04-15 01:45:40
X-Connected-IP: 95.105.163.217:13650
X-Message-Linecount: 58
X-Body-Linecount: 43
X-Message-Size: 3261
X-Body-Size: 2580
X-Received-Count: 1
X-Recipient-Count: 3
X-Local-Recipient-Count: 3
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.04.2014 21:24, Stanislav Meduna wrote:

> hunting another problem with AUART acting weirdly I got

okay, the AUART thing was some device tree snafu, but I have seen
the BUG a few times (but not readily reproducible). This thread
looks remotely similar https://lkml.org/lkml/2013/9/27/534 - looks
like the real bug happened somewhere else :( Any hints on how to
get more info?

Adding Cc: to linux-arm and linux-kernel

> BUG: spinlock trylock failure on UP on CPU#0, ksoftirqd/0/3
>  lock: boot_tvec_bases+0x0/0x10a0, .magic: dead4ead, .owner: ksoftirqd/0/3, .owner_cpu: 0
> CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.12.15-rt25-00371-gfec62f5-dirty #26
> [<c00149ec>] (unwind_backtrace+0x0/0xf4) from [<c0012ab0>] (show_stack+0x10/0x14)
> [<c0012ab0>] (show_stack+0x10/0x14) from [<c01a4b80>] (do_raw_spin_trylock+0x4c/0x58)
> [<c01a4b80>] (do_raw_spin_trylock+0x4c/0x58) from [<c02ca0b4>] (_raw_spin_trylock+0x20/0x98)
> [<c02ca0b4>] (_raw_spin_trylock+0x20/0x98) from [<c02c9654>] (rt_spin_trylock+0x14/0xd0)
> [<c02c9654>] (rt_spin_trylock+0x14/0xd0) from [<c00285cc>] (run_local_timers+0x24/0x78)
> [<c00285cc>] (run_local_timers+0x24/0x78) from [<c0028654>] (update_process_times+0x34/0x68)
> [<c0028654>] (update_process_times+0x34/0x68) from [<c005f0ac>] (tick_sched_timer+0x58/0x22c)
> [<c005f0ac>] (tick_sched_timer+0x58/0x22c) from [<c003f2f8>] (__run_hrtimer+0x7c/0x2a8)
> [<c003f2f8>] (__run_hrtimer+0x7c/0x2a8) from [<c003f684>] (hrtimer_interrupt+0x104/0x30c)
> [<c003f684>] (hrtimer_interrupt+0x104/0x30c) from [<c0230a84>] (mxs_timer_interrupt+0x20/0x2c)
> [<c0230a84>] (mxs_timer_interrupt+0x20/0x2c) from [<c0051d1c>] (handle_irq_event_percpu+0x80/0x2f8)
> [<c0051d1c>] (handle_irq_event_percpu+0x80/0x2f8) from [<c0051fd0>] (handle_irq_event+0x3c/0x5c)
> [<c0051fd0>] (handle_irq_event+0x3c/0x5c) from [<c0054778>] (handle_level_irq+0x8c/0x118)
> [<c0054778>] (handle_level_irq+0x8c/0x118) from [<c0051c8c>] (generic_handle_irq+0x28/0x30)
> [<c0051c8c>] (generic_handle_irq+0x28/0x30) from [<c001009c>] (handle_IRQ+0x30/0x84)
> [<c001009c>] (handle_IRQ+0x30/0x84) from [<c0013324>] (__irq_svc+0x44/0x88)
> [<c0013324>] (__irq_svc+0x44/0x88) from [<c006a664>] (__try_to_take_rt_mutex+0x4/0x144)
> [<c006a664>] (__try_to_take_rt_mutex+0x4/0x144) from [<00000000>] (  (null))
> 
> 
> Linux nxt 3.12.15-rt25-00371-gfec62f5-dirty #26 PREEMPT RT Mon Apr 14 20:40:56 CEST 2014 armv5tejl GNU/Linux
> 
> This is on a Freescale i.MX28, 3.12.15-rt25 with patches that do not touch
> anything related.

-- 
                                                 Stano

