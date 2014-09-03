Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbaICP3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:29:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaICP3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:29:42 -0400
Date: Wed, 3 Sep 2014 17:28:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com, <""@rjwysocki.net>,
        tianyu.lan@intel.com
Subject: Re: [PATCH RFC tip/core/rcu] Eliminate deadlock between CPU hotplug
 and expedited grace periods
Message-ID: <20140903152850.GQ4783@worktop.ger.corp.intel.com>
References: <20140828194745.GA3761@linux.vnet.ibm.com>
 <20140901112059.GG27892@worktop.ger.corp.intel.com>
 <20140901160550.GL5001@linux.vnet.ibm.com>
 <20140901161735.GA5806@worktop.ger.corp.intel.com>
 <20140902163656.GC5001@linux.vnet.ibm.com>
 <20140903113112.GM4783@worktop.ger.corp.intel.com>
 <20140903150306.GU5001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903150306.GU5001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 08:03:06AM -0700, Paul E. McKenney wrote:
> > > Normal RCU grace periods avoid this by synchronizing on a lock acquired by
> > > the RCU CPU-hotplug notifiers, but this does not work for the expedited
> > > grace periods because the outgoing CPU can be running random tasks for
> > > quite some time after RCU's notifier executes.  So the fix is just to
> > > drop back to a normal grace period when there is a CPU-hotplug operation
> > > in progress.
> > 
> > So why are we 'normally' doing an expedited call here anyhow? 
> 
> Presumably because they set either the boot parameter or
> the sysfs variable that causes synchronize_sched() to so
> synchronize_sched_expedited().

That's not a why but a how. Why does that option exist, why are we doing
this?

I cannot actually find a sysfs variable that controls this though; only
the rcu_pm_notifier. It seems to favour doing an expedited call when
suspending on 'small' machines.

> > But those are not within hotplug bits. Also weren't we removing them? I
> > thought we didn't appreciate spraying IPIs like they do?
> 
> I hadn't heard anything about removing them, but making the
> expedited primitives a bit less IPI-happy is on my list.

I had some recollections of removing a fair number of expedited calls,
but its was a long while ago so what do I know ;-)

Making them less IPI happy would be good indeed.
