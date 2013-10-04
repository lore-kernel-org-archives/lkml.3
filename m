Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3JDPU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:20:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab3JDPU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:20:56 -0400
Date: Fri, 4 Oct 2013 17:13:23 +0200
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
Message-ID: <20131004151323.GA16440@redhat.com>
References: <20131003195026.GT5790@linux.vnet.ibm.com> <20131003200002.GA23768@redhat.com> <20131003211009.GA4127@redhat.com> <20131004071814.GS28601@twins.programming.kicks-ass.net> <20131004111513.GA5699@redhat.com> <20131004114442.GJ3081@twins.programming.kicks-ass.net> <20131004121300.GA7725@redhat.com> <20131004123806.GK3081@twins.programming.kicks-ass.net> <20131004133135.GA11097@redhat.com> <20131004144319.GM3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004144319.GM3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Peter Zijlstra wrote:
>
> On Fri, Oct 04, 2013 at 03:31:35PM +0200, Oleg Nesterov wrote:
> > > I'm really starting to think we shouldn't do this in rcu_sync at all.
> >
> > I do not really understand why you insist that rcu_sync() should not
> > try to help to the users which need the exclusive mode.
>
> But what other users; you yourself said that percpu-rwsem isn't one for
> long if ever.

Not sure I understand...

percpu-rwsem will use exclusive mode, with or without the possible
improvements we can copy from cpuhp. sb_writers can probably use it
too (along with other helpers from percpu-rwsem we do not have yet).

If you mean that the "raw" rcu_sync infrastructure will never have
more users, will I am not sure, it looks "natural". But I can not
know for sure.

OK, I am not going to argue too much, let me send other patches
you seem to agree with. I am also going to send this one for the
record/review (without __complete_locked), please ack-or-nack it
explicitly.

I am not trying saying this feature is "must have", of course it
is not. The only problem, I am a bit puzzled why you dislike it
that much.

Oleg.

