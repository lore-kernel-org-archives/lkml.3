Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3FRJ6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:58:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39697 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3FRJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:58:29 -0400
Date: Tue, 18 Jun 2013 11:58:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com,
        mingo@kernel.org
Subject: Re: Another RCU trace. (3.10-rc5)
Message-ID: <20130618095821.GJ3204@twins.programming.kicks-ass.net>
References: <20130610195145.GA26068@redhat.com>
 <20130610203355.GO5146@linux.vnet.ibm.com>
 <20130610210123.GA27154@redhat.com>
 <1370899008.9844.126.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370899008.9844.126.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 05:16:48PM -0400, Steven Rostedt wrote:
> On Mon, 2013-06-10 at 17:01 -0400, Dave Jones wrote:
> > On Mon, Jun 10, 2013 at 01:33:55PM -0700, Paul E. McKenney wrote:
> >  
> >  > > I saw some of Steven's patches get merged on Friday, is there anything else
> >  > > outstanding that didn't make it in yet that I could test ?
> >  > > Or is this another new bug ?
> >  > 
> >  > I have three fixes queued up at:
> >  > 
> >  > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent
> >  > 
> >  > Kind of hard to tell whether they are relevant given the interleaved
> >  > stack traces, but can't hurt to try them out.
> >  
> > Here's another. Looks different.
> > 
> > [ 2739.921649] ===============================
> > [ 2739.923894] [ INFO: suspicious RCU usage. ]
> > [ 2739.926144] 3.10.0-rc5+ #6 Not tainted
> > [ 2739.928397] -------------------------------
> > [ 2739.930670] include/linux/rcupdate.h:780 rcu_read_lock() used illegally while idle!
> > [ 2739.933826] 
> > other info that might help us debug this:
> > 
> > [ 2739.939663] 
> > RCU used illegally from idle CPU!
> > rcu_scheduler_active = 1, debug_locks = 0
> > [ 2739.946345] RCU used illegally from extended quiescent state!
> > [ 2739.949123] 2 locks held by trinity-child1/4385:
> > [ 2739.951537]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff816ea16f>] __schedule+0xef/0x9c0
> > [ 2739.955316]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff810a5625>] cpuacct_charge+0x5/0x1f0
> > [ 2739.959101] 
> > stack backtrace:
> > [ 2739.962529] CPU: 1 PID: 4385 Comm: trinity-child1 Not tainted 3.10.0-rc5+ #6
> > [ 2739.970870]  0000000000000000 ffff8802247e3cf8 ffffffff816e39db ffff8802247e3d28
> > [ 2739.974556]  ffffffff810b5987 ffff880200f02568 000000000032585b ffff880200f02520
> > [ 2739.978353]  0000000000000001 ffff8802247e3d60 ffffffff810a57a5 ffffffff810a5625
> > [ 2739.982052] Call Trace:
> > [ 2739.984098]  [<ffffffff816e39db>] dump_stack+0x19/0x1b
> > [ 2739.986996]  [<ffffffff810b5987>] lockdep_rcu_suspicious+0xe7/0x120
> > [ 2739.990080]  [<ffffffff810a57a5>] cpuacct_charge+0x185/0x1f0
> > [ 2739.992971]  [<ffffffff810a5625>] ? cpuacct_charge+0x5/0x1f0
> > [ 2739.994716]  [<ffffffff8109609c>] update_curr+0xec/0x250
> > [ 2739.995873]  [<ffffffff810975c8>] put_prev_task_fair+0x228/0x480
> > [ 2739.997036]  [<ffffffff816ea1e6>] __schedule+0x166/0x9c0
> > [ 2739.998192]  [<ffffffff816eaf60>] ? __cond_resched_softirq+0x60/0x60
> > [ 2739.999344]  [<ffffffff816eae94>] preempt_schedule+0x44/0x60
> 
> Yeah, this one is fixed by a patch I sent out earlier, and I believe
> Peter Zijlstra is going to push it. It wasn't part of my queue.
> 
> Peter, Are you going to take the preempt_schedule_context() patch?

I have it queued, I just seem to have some problems locating Ingo to
stuff patches into -tip :/

Will continue prodding.. Ingo if you're reading! :-)
