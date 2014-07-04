Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaGDDYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:24:02 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:49135 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaGDDYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:24:00 -0400
Message-ID: <1404444236.5756.36.camel@marge.simpson.net>
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        riel@redhat.com, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Date: Fri, 04 Jul 2014 05:23:56 +0200
In-Reply-To: <20140703162944.GG4603@linux.vnet.ibm.com>
References: <20140627142038.GA22942@linux.vnet.ibm.com>
	 <20140702123412.GD19379@twins.programming.kicks-ass.net>
	 <20140702153915.GQ4603@linux.vnet.ibm.com>
	 <20140702160412.GO19379@twins.programming.kicks-ass.net>
	 <20140702170838.GS4603@linux.vnet.ibm.com>
	 <1404358279.5137.63.camel@marge.simpson.net>
	 <20140703052124.GB4603@linux.vnet.ibm.com>
	 <1404366520.5137.90.camel@marge.simpson.net>
	 <20140703162944.GG4603@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 09:29 -0700, Paul E. McKenney wrote: 
> On Thu, Jul 03, 2014 at 07:48:40AM +0200, Mike Galbraith wrote:
> > On Wed, 2014-07-02 at 22:21 -0700, Paul E. McKenney wrote: 
> > > On Thu, Jul 03, 2014 at 05:31:19AM +0200, Mike Galbraith wrote:
> > 
> > > > NO_HZ_FULL is a property of a set of CPUs.  isolcpus is supposed to go
> > > > away as being a redundant interface to manage a single property of a set
> > > > of CPUs, but it's perfectly fine for NO_HZ_FULL to add an interface to
> > > > manage a single property of a set of CPUs.  What am I missing? 
> > > 
> > > Well, for now, it can only be specified at build time or at boot time.
> > > In theory, it is possible to change a CPU from being callback-offloaded
> > > to not at runtime, but there would need to be an extremely good reason
> > > for adding that level of complexity.  Lots of "fun" races in there...
> > 
> > Yeah, understood.
> > 
> > (still it's a NO_HZ_FULL wart though IMHO, would be prettier and more
> > usable if it eventually became unified with cpuset and learned how to
> > tap-dance properly;)
> 
> Agreed, it would in some sense be nice.  What specifically do you need
> it for?

I personally have zero use for the thing (git/vi aren't particularly
perturbation sensitive;). I'm just doing occasional drive-by testing
from a distro perspective, how well does it work, what does it cost etc.

>   Are you really running workloads that generate large numbers of
> callbacks spread across most of the CPUs?  It was this sort of workload
> that caused Rik's system to show scary CPU-time accumulation, due to
> the high overhead of frequent one-to-many wakeups.
> 
> If your systems aren't running that kind of high-callback-rate workload,
> just set CONFIG_RCU_NOCB_CPU_ALL=y and don't worry about it.
> 
> If your systems -are- running that kind of high-callback-rate workload,
> but your system has fewer than 200 CPUs, ensure that you have enough
> housekeeping CPUs to allow the grace-period kthread sufficient CPU time,
> set CONFIG_RCU_NOCB_CPU_ALL=y and don't worry about it.
> 
> If your systems -are- running that kind of high-callback-rate workload,
> and your system has more than 200 CPUs, apply the following patch,
> set CONFIG_RCU_NOCB_CPU_ALL=y and once again don't worry about it.  ;-)

Turn it on and don't worry about it is exactly what distros want the
obscure feature with very few users to be.  Last time I did a drive-by,
my boxen said I should continue to worry about it ;-)

-Mike

