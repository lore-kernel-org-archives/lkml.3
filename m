Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3IINtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:49:25 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:43326 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab3IINtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:49:24 -0400
Date: Mon, 9 Sep 2013 15:49:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20130909134919.GG16280@somewhere>
References: <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909131452.GA31370@twins.programming.kicks-ass.net>
 <20130909132900.GE16280@somewhere>
 <20130909094132.74f1dd57@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909094132.74f1dd57@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:41:32AM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 15:29:02 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
>  
> > No, putting that on the task_struct won't help much in this regard I think.
> > Regular schedule() calls don't change that per cpu state.
> 
> But is there a place that it would need to?

I don't have any in mind.

> 
> I mean, if RCU is not tracking a CPU, is it safe to call schedule().

Nope, a CPU is not allowed to call schedule() if RCU is not tracking it.

> And then how would the new task know that RCU is ignoring that CPU?

On return from schedule(), it's (supposed to be) guaranteed that the CPU
is always tracked by RCU.

> 
> -- Steve
> 
