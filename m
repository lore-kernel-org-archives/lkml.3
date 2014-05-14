Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaENLjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:39:01 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47517 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbaENLjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:39:00 -0400
Date: Wed, 14 May 2014 13:38:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/3] nohz: Use IPI implicit full barrier against
 rq->nr_running r/w
Message-ID: <20140514113852.GB1278@localhost.localdomain>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-4-git-send-email-fweisbec@gmail.com>
 <20140514090903.GD30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514090903.GD30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:09:03AM +0200, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 12:25:56AM +0200, Frederic Weisbecker wrote:
> > @@ -670,10 +670,11 @@ bool sched_can_stop_tick(void)
> >  
> >         rq = this_rq();
> >  
> > -       /* Make sure rq->nr_running update is visible after the IPI */
> > -       smp_rmb();
> > -
> > -       /* More than one running task need preemption */
> > +       /*
> > +	* More than one running task need preemption.
> > +	* nr_running update is assumed to be visible
> > +	* after IPI is sent from wakers.
> > +	*/
> >         if (rq->nr_running > 1)
> >                 return false;
> 
> Looks like whitespace damage on that comment's indenting.

Oops!
