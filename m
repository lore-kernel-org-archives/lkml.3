Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3IFRAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:00:13 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:38261 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3IFRAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:00:11 -0400
Date: Fri, 6 Sep 2013 19:00:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130906170006.GC2706@somewhere>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <20130906113320.46b2ea3e@gandalf.local.home>
 <20130906164016.GB2706@somewhere>
 <20130906125238.3c5ef919@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906125238.3c5ef919@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 12:52:38PM -0400, Steven Rostedt wrote:
> On Fri, 6 Sep 2013 18:40:18 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>  
> > > I can't use plain preempt_disable() in function tracing.
> > > 
> > > Also, since it's a misnomer to say the cpu is idle in NO_HZ_FULL when
> > > we are coming from userspace, can we rename that?
> > > 
> > > Perhaps we can also have a __rcu_is_cpu_tracking() (or whatever), with
> > > the "__" appended that does not do the preempt disable.
> > 
> > rcu_is_cpu_eqs() is probably better. It refers to other related "eqs" naming
> > in RCU APIs.
> 
> But that will just confuse the heck out of people. When I see "eqs" I
> equate that with "equals". What does the rcu cpu equal?

It's "extended quiescent state". There is already rcu_eqs_enter() and rcu_eqs_exit().
You're right, may be we can rename that to avoid confusion with "equals". I don't mind much.
I'm happy as long as the reader rcu_is_cpu_foo() and the writers rcu_foo_enter() and
rcu_foo_exit() have consistant naming.

> 
> -- Steve
