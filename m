Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3JCRPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:15:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46884 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3JCRPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:15:33 -0400
Date: Thu, 3 Oct 2013 10:15:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131003171511.GK5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131002145655.361606532@infradead.org>
 <20131002150518.675931976@infradead.org>
 <20131003164117.GD5790@linux.vnet.ibm.com>
 <20131003170052.GA21009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003170052.GA21009@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100317-9332-0000-0000-000001A36546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 07:00:52PM +0200, Oleg Nesterov wrote:
> On 10/03, Paul E. McKenney wrote:
> >
> > How about the something like the following, where ->read_side_check()
> > gets rcu_read_lock_held(), rcu_read_lock_bh_held(), or
> > rcu_read_lock_sched_held(), as appropriate?
> >
> > #ifdef CONFIG_PROVE_RCU
> > #define rcu_sync_is_idle_check(rss) BUG_ON(!rss->read_side_check())
> > #else
> > #define rcu_sync_is_idle_check(rss) do { } while (0)
> > #endif
> >
> > 	rcu_sync_is_idle_check(rss);
> 
> Agreed!
> 
> but can't we do this in a separate patch? (I will be happy to do
> this trivial exercise ;)

I am good with that.

> This change is trivial, but perhaps it would be better to keep the
> initial patch as simple as possible. And discuss the potential
> "cosmetic" issues (like naming) separately. Say, rcu_lockdep_assert.
> We can't use it directly, we need the new helper.

OK, with s/xxx_/rcu_sync_/ in the comit log:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

But someone else needs to lock all the candidate names in a room
overnight and tend to the resulting wounds.  ;-)

							Thanx, Paul

