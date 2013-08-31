Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3HaU7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:59:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50518 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3HaU7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:59:14 -0400
Date: Sat, 31 Aug 2013 13:58:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 12/18 v2] ftrace: Disable RCU unsafe checker when
 function graph is enabled
Message-ID: <20130831205831.GC3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.436132384@goodmis.org>
 <20130831195550.GR3871@linux.vnet.ibm.com>
 <1377981737.26624.6.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377981737.26624.6.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083120-9332-0000-0000-000001449AC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 04:42:17PM -0400, Steven Rostedt wrote:
> On Sat, 2013-08-31 at 12:55 -0700, Paul E. McKenney wrote:
> > On Sat, Aug 31, 2013 at 01:11:29AM -0400, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> > > Having the RCU unsafe checker running when function graph is enabled
> > > can cause a live lock. That's because the RCU unsafe checker enables
> > > full lockdep debugging on RCU which does a lot of interal calls that
> > > may be traced by the function graph tacer. This adds quite a bit of
> > 
> > s/tacer/tracer/  (Yeah, yeah, picky, picky!)
> > 
> > > overhead and can possibly live lock the system.
> > > 
> > > Just do not do the RCU unsafe checks when function graph tracer is
> > > enabled.
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > One question: How does the user/tester/developer know that RCU-unsafe
> > checks have been disabled by function-graph tracing?  Would it make
> > sense to print something to dmesg calling this out?  Or do the transitions
> > happen too often?
> 
> Ideally, (for 3.13) I plan on having this be a sysctl switch. That will
> be 1 or 0, depending on if it is enabled or not. But yeah, I can add a
> printk to show that the kernel changed it. It doesn't happen often, and
> mainly by a user (or selftest).

It would be good.  Sooner or later someone is going to miss the fact
that they added an unsafe RCU read-side code sequence because they had
the checks suppressed during testing.  It would be good to have a way
to see that this happened.  ;-)

							Thanx, Paul

