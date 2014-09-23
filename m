Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbaIWOUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:20:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:33339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaIWOUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:20:40 -0400
Date: Tue, 23 Sep 2014 16:20:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signal: simplify deadlock-avoidance in
 lock_task_sighand()
Message-ID: <20140923142037.GG3312@worktop.programming.kicks-ass.net>
References: <20140922164404.GA28910@redhat.com>
 <20140922164437.GA28939@redhat.com>
 <20140922145828.4d06108a@gandalf.local.home>
 <20140922191130.GA4527@redhat.com>
 <20140922172405.71c4a110@gandalf.local.home>
 <54215D52.8030201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54215D52.8030201@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:45:22AM -0400, Rik van Riel wrote:

> > I really thing the preempt_disable/enable is not needed.
> > 
> > Paul, Thomas, care to comment?
> 
> I suspect you are right.  On normal kernels, rcu_read_lock() will
> ensure preemption is disabled.
> 
> On -rt, the locks within are all sleepable mutexes.
> 
> Either way, things should be ok.

But with CONFIG_PREEMPT we get preemptible RCU but not the
spinlock->rt_mutex conversion.
