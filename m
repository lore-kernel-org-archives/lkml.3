Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3IWSQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:16:34 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44902 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab3IWSQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:16:27 -0400
Date: Mon, 23 Sep 2013 10:04:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130923170400.GA1390@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130917143003.GA29354@twins.programming.kicks-ass.net>
 <20130917162050.GK22421@suse.de>
 <20130917164505.GG12926@twins.programming.kicks-ass.net>
 <20130918154939.GZ26785@twins.programming.kicks-ass.net>
 <20130919143241.GB26785@twins.programming.kicks-ass.net>
 <20130923105017.030e0aef@gandalf.local.home>
 <20130923145446.GX9326@twins.programming.kicks-ass.net>
 <20130923111303.04b99db8@gandalf.local.home>
 <20130923155059.GO9093@linux.vnet.ibm.com>
 <20130923160130.GC9326@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923160130.GC9326@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092318-9332-0000-0000-00000182DF48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 06:01:30PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 23, 2013 at 08:50:59AM -0700, Paul E. McKenney wrote:
> > Not a problem, just stuff the idx into some per-task thing.  Either
> > task_struct or taskinfo will work fine.
> 
> Still not seeing the point of using srcu though..
> 
> srcu_read_lock() vs synchronize_srcu() is the same but far more
> expensive than preempt_disable() vs synchronize_sched().

Heh!  You want the old-style SRCU.  ;-)

> > Or to put it another way, if the underlying slow-path mutex is
> > reader-preference, then the whole thing will be reader-preference.
> 
> Right, so 1) we have no such mutex so we're going to have to open-code
> that anyway, and 2) like I just explained in the other email, I want the
> pending writer case to be _fast_ as well.

At some point I suspect that we will want some form of fairness, but in
the meantime, good point.

							Thanx, Paul

