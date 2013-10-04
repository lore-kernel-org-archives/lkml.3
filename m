Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3JDTOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:14:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3JDTOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:14:03 -0400
Date: Fri, 4 Oct 2013 21:06:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131004190653.GA17639@redhat.com>
References: <20131003211009.GA4127@redhat.com> <20131004071814.GS28601@twins.programming.kicks-ass.net> <20131004111513.GA5699@redhat.com> <20131004114442.GJ3081@twins.programming.kicks-ass.net> <20131004121300.GA7725@redhat.com> <20131004123806.GK3081@twins.programming.kicks-ass.net> <20131004133135.GA11097@redhat.com> <20131004144319.GM3081@twins.programming.kicks-ass.net> <20131004151323.GA16440@redhat.com> <20131004162546.GQ3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004162546.GQ3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Peter Zijlstra wrote:
>
> On Fri, Oct 04, 2013 at 05:13:23PM +0200, Oleg Nesterov wrote:
>
> > I am not trying saying this feature is "must have", of course it
> > is not. The only problem, I am a bit puzzled why you dislike it
> > that much.
>
> The reason I dislike it is because I feel we're now mixing two objects
> into one; one object doing mutual exclusion and one object being
> terribly smart with sync_rcu.

OK, I see your point.

But rcu_sync_struct has to serialize the writers anyway. The only
question is how many other writers the thread doing ->sync() should
wakeup and when.

And otoh. Currently nobody needs the non-exclusive mode (cpu-hotplug
doesn't care because it is always exclusive itself). And in fact you
initially argued with wake_up_all ;) "exclusive" is more natural, it
is like rw_semaphore.

However, yes-yes-yes, I do think that we need the non-exclusive mode
too, at least for percpu_down_write_nonexclusive() which I think we
need as well.

Oleg.

