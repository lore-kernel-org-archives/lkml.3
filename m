Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3IIQkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:40:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26954 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3IIQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:40:46 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=mlFgsZHGq9pVYmy25QwA:9 a=CjuIK1q_8ugA:10 a=4bZfTmQAmYoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 12:40:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909124044.2e851d97@gandalf.local.home>
In-Reply-To: <20130909162215.GY3966@linux.vnet.ibm.com>
References: <20130906174117.GU3966@linux.vnet.ibm.com>
	<20130906185927.GE2706@somewhere>
	<20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909121329.GA16280@somewhere>
	<20130909083926.3eceebef@gandalf.local.home>
	<20130909124547.GB16280@somewhere>
	<20130909085504.2ddd7e69@gandalf.local.home>
	<20130909131452.GA31370@twins.programming.kicks-ass.net>
	<20130909134605.GP3966@linux.vnet.ibm.com>
	<20130909095511.735bcffc@gandalf.local.home>
	<20130909162215.GY3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 09:22:15 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> However, the API we are arguing about is deep within the implementation.
> It is not at the level of rcu_read_lock().  It is something that should
> not have that many invocations -- after all, the things using it are
> binding themselves unusually close to RCU.
> 

Is it? I guess the question is, is dynamic ticks an extension of RCU,
or is it just using the RCU implementation as a convenience?

Also the OP patch is for function tracing, something not coupled by RCU
at all. Just a way to know if it is safe to call functions that use RCU
or not.

That can have "this_cpu()" by the way as a way to tell us that we must
disable preemption before hand. Which is what caused this thread to
start with, as it was suggested to combine rcu_is_cpu_idle() which
brought up why that function disables preemption.

-- Steve
