Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3JITxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:53:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50243 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3JITxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:53:07 -0400
Date: Wed, 9 Oct 2013 21:52:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] rcu: Create rcu_sync infrastructure
Message-ID: <20131009195250.GL13848@laptop.programming.kicks-ass.net>
References: <20131008102505.404025673@infradead.org>
 <20131008103830.180541879@infradead.org>
 <20131008144045.6f9f4401@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008144045.6f9f4401@lwn.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 02:40:45PM -0600, Jonathan Corbet wrote:
> OK, so this is a real nit, but...in the changelog:
> 
> >         static inline void rcu_sync_enter(struct rcu_sync_struct *xxx)
> >         {
> >                 atomic_inc(&xxx->counter);
> >                 synchronize_sched();
> >         }
> > 
> >         static inline void rcu_sync_enter(struct rcu_sync_struct *xxx)
> >         {
> >                 synchronize_sched();
> >                 atomic_dec(&xxx->counter);
> >         }
> 
> That second rcu_sync_enter should really be rcu_sync_exit.
> 
> Is the "xxx" there to test spamassassin configurations? :)

Uhh, no, its a search-n-replace fail, Oleg's original email on the
subject called the entire primitive xxx. I replaced (some) of them with
rcu_sync.

