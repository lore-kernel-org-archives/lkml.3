Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3JDTli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:41:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54588 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3JDTlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:41:37 -0400
Date: Fri, 4 Oct 2013 21:41:26 +0200
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
Message-ID: <20131004194126.GW15690@laptop.programming.kicks-ass.net>
References: <20131004071814.GS28601@twins.programming.kicks-ass.net>
 <20131004111513.GA5699@redhat.com>
 <20131004114442.GJ3081@twins.programming.kicks-ass.net>
 <20131004121300.GA7725@redhat.com>
 <20131004123806.GK3081@twins.programming.kicks-ass.net>
 <20131004133135.GA11097@redhat.com>
 <20131004144319.GM3081@twins.programming.kicks-ass.net>
 <20131004151323.GA16440@redhat.com>
 <20131004162546.GQ3081@twins.programming.kicks-ass.net>
 <20131004190653.GA17639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004190653.GA17639@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 09:06:53PM +0200, Oleg Nesterov wrote:
> However, yes-yes-yes, I do think that we need the non-exclusive mode
> too, at least for percpu_down_write_nonexclusive() which I think we
> need as well.

I just need to disagree with the write_nonexclusive() name; the
construct I quite understand and could even agree with.

How about something like:

State excluding 'writers', but not itself:
	percpu_read_lock()
	percpu_read_unlock()

State excluding readers, but not itself:
	percpu_non_read_lock();
	percpu_non_read_unlock();

Full exclusive state:
	percpu_write_lock();
	percpu_write_unlock();

At which point I start to have doubts about the percpu prefix.. ;-)
