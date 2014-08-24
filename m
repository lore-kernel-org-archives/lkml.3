Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaHXDXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 23:23:48 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50305 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaHXDXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 23:23:47 -0400
Date: Sat, 23 Aug 2014 20:23:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: Amit Shah <amit.shah@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Silas Boyd-Wickizer <sbw@mit.edu>
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140824032339.GK2663@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJhHMCC6XUo0erp6mPyjiz5614DQq_+gfVaLR5s9YZkP=jPVCw@mail.gmail.com>
 <20140823165121.GJ2663@linux.vnet.ibm.com>
 <CAJhHMCCntYQy624Kwb5bs7MAKKYrSRbG0SezxgbQfHwYA2C40w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCCntYQy624Kwb5bs7MAKKYrSRbG0SezxgbQfHwYA2C40w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082403-7164-0000-0000-0000040BFB55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 08:26:10PM -0400, Pranith Kumar wrote:
> On Sat, Aug 23, 2014 at 12:51 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> 
> > It might well!  Another possibility is that the early_initcall function
> > doing the synchronize_rcu() is happening before the early_initcall
> > creating the RCU grace-period kthreads.
> >
> > Seems like we need to close both holes.  Let's see how your patch works
> > for Amit, and I am testing a patch for the possible early_initcall
> > ordering issue.
> 
> I checked the init call which is calling synchronize_rcu():
> subsys_initcall(pm_sysrq_init); this is being called after
> early_initcall.
> 
> The order of initcalls is early, core, postcore, arch, subsys, fs,
> device, late. So I guess that is ok.
> 
> I wonder why it was not showing up in 12.04. I have a dual boot. Will
> test it out and see if I can find something.

Me, I am wondering about 7,000 callbacks being registered during early
boot time.  ;-)

							Thanx, Paul

