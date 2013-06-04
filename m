Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3FDMaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:30:21 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39334 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3FDMaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:30:17 -0400
Date: Tue, 4 Jun 2013 14:30:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
Message-ID: <20130604123011.GG14973@somewhere>
References: <1369785676.15552.55.camel@gandalf.local.home>
 <20130604110329.GA14973@somewhere>
 <1370347881.26799.114.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370347881.26799.114.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 08:11:21AM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-04 at 13:03 +0200, Frederic Weisbecker wrote:
> 
> > If ftrace were to use rcu_dereference_sched() instead of rcu_dereference_raw(), I guess
> > the issue would have been detected before. But I guess we want to avoid that for
> > tracing recursion?
> 
> It's been detected before, just ignored as most of ftrace function
> tracing has permanent objects and the synchronization doesn't really
> matter for them. But for perf and SystemTap that uses dynamically
> created ftrace_ops and needs to free them, it does make a difference.
> Something I knew needed to be fixed but never got around to it as the
> race is extremely tight (and requires root user trying to trigger it). I
> haven't been ably to trigger the race, but in theory it's there.
> 
> Note the checks that rcu_dereference_sched() has to test for these kinds
> of things would cause ftrace to live lock the system if it had used it.
> In fact, I had to make a rcu_dereference_raw_notrace() to prevent ftrace
> locking up the system when full rcu debugging is enabled.

I see.

Thanks!
