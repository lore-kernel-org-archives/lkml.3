Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaAORLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:11:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43453 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaAORLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:11:33 -0500
Date: Wed, 15 Jan 2014 18:10:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 2/4] timers: Reduce __run_timers()
 latency for empty list
Message-ID: <20140115171037.GK31570@twins.programming.kicks-ass.net>
References: <20140115051939.GA31164@linux.vnet.ibm.com>
 <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140115170310.GB11499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115170310.GB11499@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:03:10PM +0100, Oleg Nesterov wrote:
> On 01/14, Paul E. McKenney wrote:
> >
> > The __run_timers() function currently steps through the list one jiffy at
> > a time
> 
> And this is very suboptimal if jiffies - timer_jiffies is huge. Looks
> like, we should rework base->tv* structures, or (perhaps) optimize
> the "cascade" logic so that __run_timers() can increment timer_jiffies
> and move all the expired timers into work_list at one step. And the
> ->next_timer logic is obviously very suboptimal.

Thomas is actually actively working on a replacement for the entire
cascade mess.
