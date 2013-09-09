Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3IIMzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:55:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5811 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3IIMzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:55:06 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=pGLkceISAAAA:8 a=Uf78agF8koMlbh_WU-0A:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 08:55:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909085504.2ddd7e69@gandalf.local.home>
In-Reply-To: <20130909124547.GB16280@somewhere>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
	<20130906105934.GF20519@somewhere>
	<20130906151851.GQ3966@linux.vnet.ibm.com>
	<1378488088.31445.39.camel@edumazet-glaptop>
	<20130906174117.GU3966@linux.vnet.ibm.com>
	<20130906185927.GE2706@somewhere>
	<20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909121329.GA16280@somewhere>
	<20130909083926.3eceebef@gandalf.local.home>
	<20130909124547.GB16280@somewhere>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 14:45:49 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

 
> > This just proves that the caller of rcu_is_cpu_idle() must disable
> > preemption itself for the entire time that it needs to use the result
> > of rcu_is_cpu_idle().
> 
> Sorry, I don't understand your point here. What's wrong with checking the
> ret from another CPU?

Hmm, OK, this is why that code is in desperate need of a comment.

>From reading the context a bit more, it seems that the per cpu value is
more a "per task" value that happens to be using per cpu variables, and
changes on context switches. Is that correct?

Anyway, it requires a comment to explain that we are not checking the
CPU state, but really the current task state, otherwise that 'ret'
value wouldn't travel with the task, but would stick with the CPU.

-- Steve

