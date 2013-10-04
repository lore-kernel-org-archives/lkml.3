Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3JDQ0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:26:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50718 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3JDQ0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:26:11 -0400
Date: Fri, 4 Oct 2013 18:25:46 +0200
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
Message-ID: <20131004162546.GQ3081@twins.programming.kicks-ass.net>
References: <20131003200002.GA23768@redhat.com>
 <20131003211009.GA4127@redhat.com>
 <20131004071814.GS28601@twins.programming.kicks-ass.net>
 <20131004111513.GA5699@redhat.com>
 <20131004114442.GJ3081@twins.programming.kicks-ass.net>
 <20131004121300.GA7725@redhat.com>
 <20131004123806.GK3081@twins.programming.kicks-ass.net>
 <20131004133135.GA11097@redhat.com>
 <20131004144319.GM3081@twins.programming.kicks-ass.net>
 <20131004151323.GA16440@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004151323.GA16440@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 05:13:23PM +0200, Oleg Nesterov wrote:
> Not sure I understand...
> 
> percpu-rwsem will use exclusive mode, with or without the possible
> improvements we can copy from cpuhp. sb_writers can probably use it
> too (along with other helpers from percpu-rwsem we do not have yet).

Oh; I thought to have understood it would go away when you switched to
the reader scheme from the hotplug bits.

But thinking a little more; yes you'd still need something to serialize
writers.

> If you mean that the "raw" rcu_sync infrastructure will never have
> more users, will I am not sure, it looks "natural". But I can not
> know for sure.

Right, so this would be something I'd forgo if there were no immediate
users. We could always reconsider if there was one; but apparently
percpu-rwsem is one..

> I am not trying saying this feature is "must have", of course it
> is not. The only problem, I am a bit puzzled why you dislike it
> that much.

The reason I dislike it is because I feel we're now mixing two objects
into one; one object doing mutual exclusion and one object being
terribly smart with sync_rcu.

