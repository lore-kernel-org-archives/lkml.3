Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab3JDHA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 03:00:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39108 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3JDHAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 03:00:55 -0400
Date: Fri, 4 Oct 2013 09:00:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20131004070035.GQ28601@twins.programming.kicks-ass.net>
References: <20131002145655.361606532@infradead.org>
 <20131002150518.675931976@infradead.org>
 <20131003164117.GD5790@linux.vnet.ibm.com>
 <20131003184001.GM28601@twins.programming.kicks-ass.net>
 <20131003184719.GA11996@redhat.com>
 <20131003192135.GR5790@linux.vnet.ibm.com>
 <20131003193206.GA17796@redhat.com>
 <20131003193319.GB17796@redhat.com>
 <20131003195026.GT5790@linux.vnet.ibm.com>
 <20131003200002.GA23768@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003200002.GA23768@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 10:00:02PM +0200, Oleg Nesterov wrote:
> On 10/03, Paul E. McKenney wrote:
> >
> > On Thu, Oct 03, 2013 at 09:33:19PM +0200, Oleg Nesterov wrote:
> > > On 10/03, Oleg Nesterov wrote:
> > > >
> > > > Because I believe this needs another patch ;) see below, didn't test
> > > > it yet.
> > > > ...
> > > >  struct rcu_sync_ops {
> > > >  	void (*sync)(void);
> > > >  	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> > > > +#ifdef CONFIG_PROVE_RCU
> > > > +	bool (*held)(void);
> > >         ^^^^
> > > OK, it has to return "int".
> >
> > I missed this, but the rest looked good.  ;-)
> 
> OK thanks ;)
> 
> So unless Peter objects I'll write the changelogs (always nontrivial task),
> test, and send these 2 patches + "add ops->barr() / rcu_sync_wait_for_cb"
> tomorrow.

No I'm fine with that.. its sad that the ops thing requires a double
deref and an extra cachemiss but I don't suppose that's a real issue
since we're calling synchronize_*() things which take for ever anyway
:-)


