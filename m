Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3IIQWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:22:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55797 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3IIQWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:22:47 -0400
Date: Mon, 9 Sep 2013 18:21:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909162156.GG26785@twins.programming.kicks-ass.net>
References: <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909130851.GC16280@somewhere>
 <20130909092142.05780991@gandalf.local.home>
 <20130909092917.0c99b71a@gandalf.local.home>
 <20130909144037.GH16280@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909144037.GH16280@somewhere>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 04:40:38PM +0200, Frederic Weisbecker wrote:
> > If the state migrates with a task from one CPU to another, it's a task
> > state.
> 
> This applies to preempt_count as well.

This is in fact true. Its something I'd like to cure, but currently the
PREEMPT_ACTIVE state makes this so.

Hence the need to save/restore the per-cpu preempt state in the per-cpu
preempt_count patches.
