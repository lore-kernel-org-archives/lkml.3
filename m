Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654AbaGXU2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:28:00 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45703 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:27:59 -0400
Date: Thu, 24 Jul 2014 13:27:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 11/16] rcu: Check for spurious wakeup using return value
Message-ID: <20140724202755.GU11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-12-git-send-email-bobby.prani@gmail.com>
 <20140723122608.GL11241@linux.vnet.ibm.com>
 <CAJhHMCC7_GLmBroGhKWMJJKuWqhojQGf=9So1_x4nb2adQvqFg@mail.gmail.com>
 <20140724034315.GJ11241@linux.vnet.ibm.com>
 <CAJhHMCDhwnKF5tiWvHyGrz3KhCab+QUnAfEmkzjsBrNn5O3gyQ@mail.gmail.com>
 <20140724181223.GO11241@linux.vnet.ibm.com>
 <53D165A5.6010206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D165A5.6010206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072420-8236-0000-0000-0000041D0676
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 03:59:33PM -0400, Pranith Kumar wrote:
> Adding peterz to CC as git blames him for wait_event code. :)
> 
> (original LKML link: https://lkml.org/lkml/2014/7/23/45)
> 
> On Thu, Jul 24, 2014 at 2:12 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

[ . . . ]

> >> If we care about what wait_event_interruptible() returns, we can go
> >> back and wait for an actual wakeup much earlier without the additional
> >> overhead of calling rcu_gp_init().
> >
> > The key phrase here is "If we care".  Should we care?  If so, why?
> >
> > I suggest running some random benchmark and counting how many times
> > rcu_gp_init() is called and how many times rcu_gp_init() returns
> > because ->gp_flags is not set.  If rcu_gp_init() returns because
> > ->gp_flags is not set a significant fraction of the time, then this
> > -might- be worth worrying about.  (Extra credit: Under what conditions
> 
> In the grand scheme of things, I agree that minor optimizations may not seem
> to be worth much. But when the optimizationss are straight forward and 
> are _actually_ improving things, even by a small margin, I think they are
> worth considering.
> 
> Think of the billions of cycles we will save ;-)

If there are significant savings.  You have yet to demonstrate this.
In fact, you have yet to demonstrate that your change doesn't make
things worse.

							Thanx, Paul

> > -might- be worth worrying about.  (Extra credit: Under what conditions
> > would it be worth worrying about, and how would you go about checking
> > to see whether those conditions hold?)
> >
> 
> 
> -- 
> Pranith
> 

