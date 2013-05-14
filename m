Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab3ENPrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:47:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50113 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab3ENPrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:47:47 -0400
Date: Tue, 14 May 2013 08:47:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130514154728.GC4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514145119.GC19669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051415-3620-0000-0000-00000279213F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 04:51:20PM +0200, Peter Zijlstra wrote:
> > In theory, yes.  In practice, this requires lots of lock acquisitions
> > and releases on large systems, including some global locks.  The weight
> > could be reduced, but...
> > 
> > What I would like to do instead would be to specify expedited grace
> > periods during boot.
> 
> But why, surely going idle without any RCU callbacks isn't completely unheard
> of, even outside of the boot process?

Yep, and RCU has special-cased that for quite some time.

> Being able to quickly drop out of the RCU state machinery would be a good thing IMO.

And this is currently possible -- this is the job of rcu_idle_enter()
and friends.  And it works well, at least when I get my "if" statements
set up correctly (hence the earlier patch).

Or are you seeing a slowdown even with that earlier patch applied?  If so,
please let me know what you are seeing.

> >  The challenge here appears to be somehow telling
> > RCU when boot is done.  The APIs are there from an RCU viewpoint:  boot
> > with rcupdate.rcu_expedited=1, then, once boot is complete (whatever
> > that means on your platform) "echo 0 > /sys/kernel/rcu_expedited".
> 
> Ha, and here you assume userspace is sane and co-operative. Fail in my book ;-)

If they are insane or uncooperative, they pay the price.  ;-)

							Thanx, Paul

