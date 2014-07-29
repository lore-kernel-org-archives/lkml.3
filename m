Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaG2RXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:23:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44666 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaG2RXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:23:18 -0400
Date: Tue, 29 Jul 2014 10:23:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140729172304.GA16073@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140729081416.GR20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729081416.GR20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072917-1542-0000-0000-0000039FAF0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 10:14:16AM +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 03:56:12PM -0700, Paul E. McKenney wrote:
> > @@ -254,6 +254,8 @@ void rcu_check_callbacks(int cpu, int user)
> >  		rcu_sched_qs(cpu);
> >  	else if (!in_softirq())
> >  		rcu_bh_qs(cpu);
> > +	if (user)
> > +		rcu_note_voluntary_context_switch(current);
> >  }
> 
> There's nothing like sending email you can't find something... :-)

Well, this is unfortunately only a partial solution.  It does not handle
the NO_HZ_FULL scheduling-clock-free usermode execution.  I have ink on
paper indicating a couple of ways to do that, but figured I should get
feedback on this stuff before going too much farther.

							Thanx, Paul

