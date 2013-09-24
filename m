Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3IXRNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:13:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab3IXRNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:13:43 -0400
Date: Tue, 24 Sep 2013 19:06:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130924170631.GB5059@redhat.com>
References: <1378805550-29949-38-git-send-email-mgorman@suse.de> <20130917143003.GA29354@twins.programming.kicks-ass.net> <20130917162050.GK22421@suse.de> <20130917164505.GG12926@twins.programming.kicks-ass.net> <20130918154939.GZ26785@twins.programming.kicks-ass.net> <20130919143241.GB26785@twins.programming.kicks-ass.net> <20130923175052.GA20991@redhat.com> <20130924123821.GT12926@twins.programming.kicks-ass.net> <20130924160359.GA2739@redhat.com> <20130924124341.64d57912@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924124341.64d57912@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Steven Rostedt wrote:
>
> On Tue, 24 Sep 2013 18:03:59 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 09/24, Peter Zijlstra wrote:
> > >
> > > +static inline void get_online_cpus(void)
> > > +{
> > > +	might_sleep();
> > > +
> > > +	if (current->cpuhp_ref++) {
> > > +		barrier();
> > > +		return;
> >
> > I don't undestand this barrier()... we are going to return if we already
> > hold the lock, do we really need it?
>
> I'm confused too. Unless gcc moves this after the release, but the
> release uses preempt_disable() which is its own barrier.
>
> If anything, it requires a comment.

And I am still confused even after emails from Paul and Peter...

If gcc can actually do something wrong, then I suspect this barrier()
should be unconditional.

Oleg.

