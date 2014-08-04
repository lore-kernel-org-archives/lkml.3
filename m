Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaHDMhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:37:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44226 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaHDMhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:37:34 -0400
Date: Mon, 4 Aug 2014 05:37:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804123727.GJ8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53DEE1CD.4000705@cn.fujitsu.com>
 <20140804074620.GH9918@twins.programming.kicks-ass.net>
 <53DF41ED.2020508@cn.fujitsu.com>
 <20140804115043.GA31903@linux.vnet.ibm.com>
 <20140804122515.GR19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804122515.GR19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080412-0928-0000-0000-000003DD0AB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 02:25:15PM +0200, Peter Zijlstra wrote:
> On Mon, Aug 04, 2014 at 04:50:44AM -0700, Paul E. McKenney wrote:
> > OK, I will bite...
> > 
> > What kinds of tasks are on a runqueue, but neither ->on_cpu nor
> > PREEMPT_ACTIVE?
> 
> Userspace tasks, they don't necessarily get PREEMPT_ACTIVE when
> preempted. Now obviously you're not _that_ interested in userspace tasks
> for this, so that might be ok.

Right, I detect userspace tasks using RCU's scheduling-clock handler.
(And code to handle the NO_HZ_FULL case is under construction.)

> But the main point was, you cannot use ->on_cpu or PREEMPT_ACTIVE
> without holding rq->lock.

OK, got it.

							Thanx, Paul

