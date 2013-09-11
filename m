Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3IKO0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:26:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3IKO0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:26:09 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=7d_E57ReAAAA:8 a=zcXDKOO1AXvWESF5raAA:9 a=CjuIK1q_8ugA:10 a=D6-X0JM3zdQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 10:26:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130911102607.16a3da91@gandalf.local.home>
In-Reply-To: <20130911141302.GA11342@linux.vnet.ibm.com>
References: <20130909135656.GT3966@linux.vnet.ibm.com>
	<20130909101629.32df27a2@gandalf.local.home>
	<20130909161708.GX3966@linux.vnet.ibm.com>
	<20130909123422.7936e868@gandalf.local.home>
	<20130909165836.GB3966@linux.vnet.ibm.com>
	<20130909172908.GA31239@Krystal>
	<20130909175656.GF3966@linux.vnet.ibm.com>
	<20130909214026.GA8830@Krystal>
	<20130909175917.794b19bd@gandalf.local.home>
	<20130909223426.GM3966@linux.vnet.ibm.com>
	<20130911141302.GA11342@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 07:13:02 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Mon, Sep 09, 2013 at 03:34:26PM -0700, Paul E. McKenney wrote:
> > On Mon, Sep 09, 2013 at 05:59:17PM -0400, Steven Rostedt wrote:
> > > On Mon, 9 Sep 2013 17:40:26 -0400
> > > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > 
> > > > Agreed. So how about rcu_is_online() ?
> > > 
> > > Nope, what about all_your_base_are_belong_to_rcu()?
> > 
> > Let's see if I can remember the candidates...
> > 
> > 	rcu_is_cpu_idle() # reversed sense from the others
> > 	rcu_is_ignored() # reversed sense from the others
> > 	rcu_is_not_active() # reversed sense from the others
> > 	rcu_is_watching_cpu()
> > 	rcu_read_check()
> > 	rcu_is_active()
> > 	rcu_is_active_local()
> > 	rcu_is_online()
> > 	rcu_is_watching_task()
> > 	rcu_is_watching_thread()
> > 	rcu_is_watching_you()
> > 	all_your_base_are_belong_to_rcu()
> > 	rcu_is_active_loco()
> > 	rcu_kilroy_was_here()
> > 
> > Maybe I should just lock them all in a room overnight and see which
> > are still alive in the morning.
> 
> And after treating injuries, the survivor is rcu_is_watching().
> 

But, but, but...

That wasn't one of the contenders!

What happened? Did rcu_is_watching_cpu(), rcu_is_watching_task(),
rcu_is_watching_thread() and rcu_is_watching_you() all get together to
gang up on the others, and then combined to be one?

It's another Iraq! Several segments joined together by an outside
force and they don't play well together. And like Iraq (and the US),
hidden inside of this "community" is "rcu_is_watching_you"!

-- Steve
