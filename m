Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaBRBVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:21:45 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52959 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaBRBVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:21:44 -0500
Date: Mon, 17 Feb 2014 17:21:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 5/6] Documentation/memory-barriers.txt: Need
 barriers() for some control dependencies
Message-ID: <20140218012137.GA4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140217212625.GA4083@linux.vnet.ibm.com>
 <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392672413-5114-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140217214606.GC7941@thin>
 <20140217225816.GN4250@linux.vnet.ibm.com>
 <20140218000246.GA19929@thin>
 <20140218001740.GT4250@linux.vnet.ibm.com>
 <20140218004510.GK19929@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218004510.GK19929@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021801-7164-0000-0000-000006279211
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:45:11PM -0800, Josh Triplett wrote:
> On Mon, Feb 17, 2014 at 04:17:40PM -0800, Paul E. McKenney wrote:
> > On Mon, Feb 17, 2014 at 04:02:47PM -0800, Josh Triplett wrote:
> > > On Mon, Feb 17, 2014 at 02:58:16PM -0800, Paul E. McKenney wrote:
> > > > On Mon, Feb 17, 2014 at 01:46:06PM -0800, Josh Triplett wrote:
> > > > > On Mon, Feb 17, 2014 at 01:26:52PM -0800, Paul E. McKenney wrote:
> > > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > > 
> > > > > > Current compilers can "speculate" stores in the case where both legs
> > > > > > of the "if" statement start with identical stores.  Because the stores
> > > > > > are identical, the compiler knows that the store will unconditionally
> > > > > > execute regardless of the "if" condition, and so the compiler is within
> > > > > > its rights to hoist the store to precede the condition.  Such hoisting
> > > > > > destroys the control-dependency ordering.  This ordering can be restored
> > > > > > by placing a barrier() at the beginning of each leg of the "if" statement.
> > > > > > This commit adds this requirement to the control-dependencies section.
> > > > > > 
> > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > This is starting to become a rather unreasonable level of fighting the
> > > > > compiler.  ("Threads cannot be implemented as a library" indeed.)  This
> > > > > doesn't seem like a reasonable thing to require users to do.  Is there
> > > > > really no other way to cope with this particular bit of "help" from the
> > > > > compiler?
> > > > 
> > > > Well, we could use smp_mb() instead of barrier(), but that was the
> > > > sort of thing that Peter Zijlstra was trying to avoid.
> > > 
> > > Yeah, that's not an improvement.  The goal would be to make the code no
> > > more complex than it already needs to be with ACCESS_ONCE; changing
> > > "barrier()" to something else doesn't help (quite apart from smp_mb()
> > > being suboptimal).
> > > 
> > > > That said, I do sympathize completely with your position here -- it is
> > > > just that it is better to have our compiler-fights documented that
> > > > not, right?
> > > 
> > > Sure, better to document them, but better still to not have them.  Is
> > > there some other way we could avoid this one entirely?
> > 
> > We could try change the standard so as to outlaw pulling common code from
> > both legs of an "if" statement, but that will be a serious uphill battle.
> 
> And insufficient given widespread use of existing compilers.

Fair point...

> > Or perhaps do something to warn the developer about the possibility of
> > this happening.
> > 
> > Other thoughts?
> 
> Might be worth bringing this up with the GCC folks to find out if
> there's something obvious we're missing.  (For non-obvious values of
> "obvious".)

Non-obvious values of "obvious" -- I have no idea what that means, but
it does have a nice counter-intuitive sound to it, doesn't it?  ;-)

This conversation has started, albeit with much more noise and smoke
than signal or light.

							Thanx, Paul

