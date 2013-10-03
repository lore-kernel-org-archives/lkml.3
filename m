Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3JCRIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:08:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab3JCRID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:08:03 -0400
Date: Thu, 3 Oct 2013 19:00:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20131003170052.GA21009@redhat.com>
References: <20131002145655.361606532@infradead.org> <20131002150518.675931976@infradead.org> <20131003164117.GD5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003164117.GD5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Paul E. McKenney wrote:
>
> How about the something like the following, where ->read_side_check()
> gets rcu_read_lock_held(), rcu_read_lock_bh_held(), or
> rcu_read_lock_sched_held(), as appropriate?
>
> #ifdef CONFIG_PROVE_RCU
> #define rcu_sync_is_idle_check(rss) BUG_ON(!rss->read_side_check())
> #else
> #define rcu_sync_is_idle_check(rss) do { } while (0)
> #endif
>
> 	rcu_sync_is_idle_check(rss);

Agreed!

but can't we do this in a separate patch? (I will be happy to do
this trivial exercise ;)

This change is trivial, but perhaps it would be better to keep the
initial patch as simple as possible. And discuss the potential
"cosmetic" issues (like naming) separately. Say, rcu_lockdep_assert.
We can't use it directly, we need the new helper.

Oleg.

