Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaHDNwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:52:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52150 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaHDNwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:52:30 -0400
Date: Mon, 4 Aug 2014 06:52:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804135224.GA18824@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140802145616.GA18195@redhat.com>
 <20140802225757.GB8101@linux.vnet.ibm.com>
 <20140803133318.GB671@redhat.com>
 <20140803220535.GH8101@linux.vnet.ibm.com>
 <53DED5D1.6030504@cn.fujitsu.com>
 <20140804010938.GI8101@linux.vnet.ibm.com>
 <20140804132525.GA18722@redhat.com>
 <20140804135104.GN8101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804135104.GN8101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080413-1344-0000-0000-0000033C5419
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 06:51:04AM -0700, Paul E. McKenney wrote:
> On Mon, Aug 04, 2014 at 03:25:25PM +0200, Oleg Nesterov wrote:
> > On 08/03, Paul E. McKenney wrote:
> > >
> > > On Mon, Aug 04, 2014 at 08:37:37AM +0800, Lai Jiangshan wrote:
> > > > An alternative solution:
> > > > srcu_read_lock() before exit_notify(), srcu_read_unlock() after the last preempt_disable()
> > > > in the do_exit, and synchronize_srcu() in rcu_tasks_kthread().
> > >
> > > That is a good way to synchronize with the exiting tasks, and I will
> > > probably that that approach.
> > >
> > > I -thought- that Oleg was concerned about safely building the list to
> > > start with, though.
> > 
> > But for_each_process_thread() under rcu_read_lock() should work except
> > it can miss the exiting tasks.
> > 
> > So it seems that the clever Lai's trick should solve the problem.
> 
> Cool!  Lai's trick seems to be doing well in early testing, so keeping
> fingers firmly crossed.  ;-)

And the horrible thing is that my plan had been to use per-CPU reference
counts for this purpose, which would of course have been sort of like
re-implementing a special case of SRCU.

So we should all be thankful to Lai for his suggestion!  ;-)

							Thanx, Paul

