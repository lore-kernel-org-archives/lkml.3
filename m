Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaGENEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 09:04:42 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36139 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaGENEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 09:04:41 -0400
Date: Sat, 5 Jul 2014 15:04:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140705130434.GD19254@localhost.localdomain>
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
 <1404358279.5137.63.camel@marge.simpson.net>
 <20140703052124.GB4603@linux.vnet.ibm.com>
 <1404366520.5137.90.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404366520.5137.90.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 07:48:40AM +0200, Mike Galbraith wrote:
> On Wed, 2014-07-02 at 22:21 -0700, Paul E. McKenney wrote: 
> > On Thu, Jul 03, 2014 at 05:31:19AM +0200, Mike Galbraith wrote:
> 
> > > NO_HZ_FULL is a property of a set of CPUs.  isolcpus is supposed to go
> > > away as being a redundant interface to manage a single property of a set
> > > of CPUs, but it's perfectly fine for NO_HZ_FULL to add an interface to
> > > manage a single property of a set of CPUs.  What am I missing? 
> > 
> > Well, for now, it can only be specified at build time or at boot time.
> > In theory, it is possible to change a CPU from being callback-offloaded
> > to not at runtime, but there would need to be an extremely good reason
> > for adding that level of complexity.  Lots of "fun" races in there...
> 
> Yeah, understood.
> 
> (still it's a NO_HZ_FULL wart though IMHO, would be prettier and more
> usable if it eventually became unified with cpuset and learned how to
> tap-dance properly;)

Well, the exact same goes for NO_HZ_FULL, quoting Paul (just replacing RCU things
with dynticks) it becomes:

 "it can only be specified at build time or at boot time.
  In theory, it is possible to change a CPU from being idle-dynticks
  to full-dynticks at runtime, but there would need to be an extremely good reason
  for adding that level of complexity.  Lots of "fun" races in there..."

And I'm not even sure that somebody actually uses full dynticks today. I only know
that some financial institutions are considering it, which is not cheering me up
much...

So we are very far from that day when we'll migrate to a runtime interface.
