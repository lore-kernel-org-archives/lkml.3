Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3IFQwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:52:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3IFQwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:52:40 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=pGLkceISAAAA:8 a=K_mtuNd0P_xhTnXu3AIA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 12:52:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130906125238.3c5ef919@gandalf.local.home>
In-Reply-To: <20130906164016.GB2706@somewhere>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
	<20130906105934.GF20519@somewhere>
	<20130906151851.GQ3966@linux.vnet.ibm.com>
	<20130906113320.46b2ea3e@gandalf.local.home>
	<20130906164016.GB2706@somewhere>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013 18:40:18 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:
 
> > I can't use plain preempt_disable() in function tracing.
> > 
> > Also, since it's a misnomer to say the cpu is idle in NO_HZ_FULL when
> > we are coming from userspace, can we rename that?
> > 
> > Perhaps we can also have a __rcu_is_cpu_tracking() (or whatever), with
> > the "__" appended that does not do the preempt disable.
> 
> rcu_is_cpu_eqs() is probably better. It refers to other related "eqs" naming
> in RCU APIs.

But that will just confuse the heck out of people. When I see "eqs" I
equate that with "equals". What does the rcu cpu equal?

-- Steve
