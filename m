Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaCRIv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:51:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53964 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaCRIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:51:53 -0400
Date: Tue, 18 Mar 2014 09:51:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, josh@joshtriplett.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: cond_resched() and RCU CPU stall warnings
Message-ID: <20140318085118.GO25546@laptop.programming.kicks-ass.net>
References: <20140316015914.GA22102@linux.vnet.ibm.com>
 <20140317101300.GA27965@twins.programming.kicks-ass.net>
 <20140317165806.GG21124@linux.vnet.ibm.com>
 <20140317171434.GJ25546@laptop.programming.kicks-ass.net>
 <20140318021706.GE4420@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318021706.GE4420@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 07:17:06PM -0700, Paul E. McKenney wrote:
> On Mon, Mar 17, 2014 at 06:14:34PM +0100, Peter Zijlstra wrote:
> > On Mon, Mar 17, 2014 at 09:58:07AM -0700, Paul E. McKenney wrote:
> > > @@ -4111,6 +4115,7 @@ int __sched __cond_resched_softirq(void)
> > >  {
> > >  	BUG_ON(!in_softirq());
> > >  
> > > +	rcu_cond_resched();
> > 
> > Don't you have to enable BHs before doing that? And if not; that needs a
> > comment for sure! :-)
> 
> No need to enable BHs, just RCU marking quiescent states.  But yes,
> the name does look a bit scary in that context, doesn't it?  Added
> a comment, please see below for updated patch.

The below seemed like an unrelated patch entirely :-)

> ------------------------------------------------------------------------
> 
> torture: Better summary diagnostics for build failures
> 
> The reaction of kvm-recheck.sh is obscure at best, and easy to miss
> completely.  This commit therefore prints "BUG: Build failed" in the
> summary at the end of a run.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
