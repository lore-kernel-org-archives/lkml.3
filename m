Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaLNUYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:24:01 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43873 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaLNUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:23:46 -0500
Date: Sun, 14 Dec 2014 12:23:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
Message-ID: <20141214202340.GH5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141214164104.307127356@goodmis.org>
 <20141214164803.991954802@goodmis.org>
 <20141214115332.76be1b8b@gandalf.local.home>
 <20141214180854.GC5310@linux.vnet.ibm.com>
 <20141214131538.7a6c1438@gandalf.local.home>
 <20141214181835.GG5310@linux.vnet.ibm.com>
 <20141214132556.6f8d6fb9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214132556.6f8d6fb9@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121420-0017-0000-0000-0000071B8180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 01:25:56PM -0500, Steven Rostedt wrote:
> On Sun, 14 Dec 2014 10:18:35 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > With your feed back, and because I would like this to go into 3.19, I
> > > would like to keep the current patch as is (with the read_mostly
> > > update, which I'm currently testing). We can always change it later
> > > after call_rcu() has been changed.
> > 
> > Completely agreed!  ;-)
> 
> For this late in the game, we need to play it safe.
> 
> I got rid of my tracepoint patch and moved trace_init() to after
> rcu_init(), which I think is good enough for Thomas. Thomas?
> 
> I'll start testing that now.

That should work as well.

> Later, if you could add a rcu_init() version that lets us call
> call_rcu_sched() just after mm_init() then we could move trace_init()
> up a bit more.

OK, will put something together for that.  Good to hear that this is
not needed indefinitely early -- that would be a bit harder.  ;-)

							Thanx, Paul

