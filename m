Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaG2WEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:04:50 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:40205 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaG2WEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:04:49 -0400
Date: Wed, 30 Jul 2014 00:04:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 09/10] nohz: Switch nohz full timekeeper to dynticks idle
 on top of sysidle detection
Message-ID: <20140729220443.GD14520@localhost.localdomain>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
 <1406569056-30217-10-git-send-email-fweisbec@gmail.com>
 <20140729121753.GZ3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729121753.GZ3935@laptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 02:17:53PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 07:37:35PM +0200, Frederic Weisbecker wrote:
> 
> > @@ -745,7 +747,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
> >  		 * if there are full dynticks CPUs around
> >  		 */
> >  		if (tick_do_timer_cpu == cpu)
> > -			return false;
> > +			return rcu_sys_is_idle();
> >  	}
> 
> I still feel its entirely upside down to rely on RCU for this...

RCU had this feature internally for a while. Then comes nohz. I guess in
a perfect world we would make it a library that RCU and nohz could use.
It's probably possible to do but right now it is too tied to RCU internals.
