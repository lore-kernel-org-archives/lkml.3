Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaHKUKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:10:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbaHKUKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:10:06 -0400
Date: Mon, 11 Aug 2014 16:09:31 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nohz fail (was: perf related boot hang.)
Message-ID: <20140811200931.GA18865@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140806143621.GA13832@redhat.com>
 <20140806161934.GF19379@twins.programming.kicks-ass.net>
 <20140806194656.GA11570@redhat.com>
 <20140807090333.GL19379@twins.programming.kicks-ass.net>
 <20140807131646.GB19662@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807131646.GB19662@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 03:16:49PM +0200, Frederic Weisbecker wrote:
 
 > > >   <<EOE>>  <IRQ>  [<ffffffff8a0ccd2f>] lock_acquired+0xaf/0x450
 > > >   [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
 > > >   [<ffffffff8a7fc678>] _raw_spin_lock_irqsave+0x78/0x90
 > > >   [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
 > > >   [<ffffffff8a0f74c5>] lock_hrtimer_base.isra.20+0x25/0x50
 > > >   [<ffffffff8a0f7723>] hrtimer_try_to_cancel+0x33/0x1e0
 > > >   [<ffffffff8a0f78ea>] hrtimer_cancel+0x1a/0x30
 > > >   [<ffffffff8a109237>] tick_nohz_restart+0x17/0x90
 > > >   [<ffffffff8a10a213>] __tick_nohz_full_check+0xc3/0x100
 > > >   [<ffffffff8a10a25e>] nohz_full_kick_work_func+0xe/0x10
 > > >   [<ffffffff8a17c884>] irq_work_run_list+0x44/0x70
 > > >   [<ffffffff8a17c8da>] irq_work_run+0x2a/0x50
 > > >   [<ffffffff8a0f700b>] update_process_times+0x5b/0x70
 > > >   [<ffffffff8a109005>] tick_sched_handle.isra.21+0x25/0x60
 > > >   [<ffffffff8a109b81>] tick_sched_timer+0x41/0x60
 > > >   [<ffffffff8a0f7aa2>] __run_hrtimer+0x72/0x470
 > > >   [<ffffffff8a109b40>] ? tick_sched_do_timer+0xb0/0xb0
 > > >   [<ffffffff8a0f8707>] hrtimer_interrupt+0x117/0x270
 > > >   [<ffffffff8a034357>] local_apic_timer_interrupt+0x37/0x60
 > > >   [<ffffffff8a80010f>] smp_apic_timer_interrupt+0x3f/0x50
 > > >   [<ffffffff8a7fe52f>] apic_timer_interrupt+0x6f/0x80
 > > 
 > > And that looks like someone trying to cancel a timer from a timer, I
 > > guess that won't work, seeing how cancel will wait for the timer handler
 > > completion etc.
 > > 
 > > This is because of the fallback irq_work_run() in the tick
 > > (update_process_times).
 > > 
 > 
 > Indeed, I saw that too but very rarely.

FWIW, I'm now seeing this quite often (several times a day) when I run
trinity on current git master.

	Dave

