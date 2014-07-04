Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbaGDVU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:20:56 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44508 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759909AbaGDVUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:20:54 -0400
Date: Fri, 4 Jul 2014 14:20:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        riel@redhat.com, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140704212045.GM4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
 <1404358279.5137.63.camel@marge.simpson.net>
 <20140703052124.GB4603@linux.vnet.ibm.com>
 <1404366520.5137.90.camel@marge.simpson.net>
 <20140703162944.GG4603@linux.vnet.ibm.com>
 <1404444236.5756.36.camel@marge.simpson.net>
 <20140704050541.GL4603@linux.vnet.ibm.com>
 <1404453694.5756.111.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404453694.5756.111.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070421-1344-0000-0000-0000029DBCA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 08:01:34AM +0200, Mike Galbraith wrote:
> On Thu, 2014-07-03 at 22:05 -0700, Paul E. McKenney wrote: 
> > On Fri, Jul 04, 2014 at 05:23:56AM +0200, Mike Galbraith wrote:
> 
> > > Turn it on and don't worry about it is exactly what distros want the
> > > obscure feature with very few users to be.  Last time I did a drive-by,
> > > my boxen said I should continue to worry about it ;-)
> > 
> > Yep, which is the reason for the patch on the last email.
> > 
> > Then again, exactly which feature and which reason for worry?
> 
> NO_HZ_FULL.  I tried ALL a while back, box instantly called me an idiot.
> Maybe that has improved since, dunno.

Ah, I was thinking in terms of RCU_CPU_NOCB.

> Last drive-by I didn't do much overhead measurement, stuck mostly
> functionality, and it still had rough edges that enterprise users may
> not fully appreciate.  Trying to let 60 of 64 cores do 100% compute
> showed some cores having a hard time entering tickless at all, and
> ~200us spikes that I think are due to tick losing skew.. told Frederic
> I'd take a peek at that, but haven't had time yet.  There were other
> known things as well, like timers and workqueues for which there are
> patches floating around.  All in all, it was waving the men at work
> sign, pointing at the "Say N" by the config option, and suggesting that
> ignoring that would not be the cleverest of moves.

Well, I am not going to join a debate on Kconfig default selection.  ;-)
I will say that two years ago, setting NO_HZ_FULL=y by default would
have been insane.  Perhaps soon it will be a no-brainer, and I am of
course trying to bring that day closer.  Right now it is of course a
judgment call.

							Thanx, Paul

