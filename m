Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaFJQSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:18:25 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54698 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaFJQSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:18:24 -0400
Date: Tue, 10 Jun 2014 18:18:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 0/6] nohz: Move nohz kick out of scheduler IPI, v8
Message-ID: <20140610161818.GA1951@localhost.localdomain>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
 <20140610154839.GF3213@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610154839.GF3213@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 05:48:39PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 10, 2014 at 05:15:03PM +0200, Frederic Weisbecker wrote:
> > So this set happens to have more changes than expected because I
> > found out that the timer list full nohz kick also relies on the scheduler
> > IPI. So I had to convert it as well, hence a few more change splitups.
> > 
> > Changes:
> > 
> > * Check also raised lists from irq_work_needs_cpu() (thanks Peterz)
> > 
> > * Comment on SMP functions priority in
> >   generic_smp_call_function_single_interrupt() because IPI callbacks there
> >   are often synchronous as opposed to irq works. (thanks Peterz)
> > 
> > * s/native_send_call_func_single_ipi/native_send_call_func_single_ipi
> >   (thanks Eric Dumazet)
> > 
> > * Only build irq_work_queue_on() on CONFIG_SMP, fixes some broken builds
> > 
> > * Convert full nohz timer list kick
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	timers/nohz-irq-work-v6
> > 
> 
> I think you finally nailed it ;-)
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>

Yesss! :)
