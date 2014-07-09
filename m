Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaGIQEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:04:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:34625 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaGIQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:04:30 -0400
Date: Wed, 9 Jul 2014 09:04:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 08/17] rcu: Allow post-unlock reference for
 rt_mutex
Message-ID: <20140709160420.GM4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <53BC9FD1.90604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BC9FD1.90604@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070916-1344-0000-0000-000002B4C382
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:50:09AM +0800, Lai Jiangshan wrote:
> On 07/08/2014 06:38 AM, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The current approach to RCU priority boosting uses an rt_mutex strictly
> > for its priority-boosting side effects.  The rt_mutex_init_proxy_locked()
> > function is used by the booster to initialize the lock as held by the
> > boostee.  The booster then uses rt_mutex_lock() to acquire this rt_mutex,
> > which priority-boosts the boostee.  When the boostee reaches the end
> > of its outermost RCU read-side critical section, it checks a field in
> > its task structure to see whether it has been boosted, and, if so, uses
> > rt_mutex_unlock() to release the rt_mutex.  The booster can then go on
> > to boost the next task that is blocking the current RCU grace period.
> > 
> > But reasonable implementations of rt_mutex_unlock() might result in the
> > boostee referencing the rt_mutex's data after releasing it. 
> 
> XXXX_unlock(lock_ptr) should not reference to the lock_ptr after it has unlocked the lock. (*)
> So I think this patch is unneeded. Although its adding overhead is at slow-patch,
> but it adds REVIEW-burden.
> 
> And although the original rt_mutex_unlock() violates the rule(*) when the fast-cmpxchg-path,
> but it is fixed now.
> 
> It is the lock-subsystem's responsible to do this. I prefer to add the wait_for_complete()
> stuff until the future when the boostee needs to re-access the booster after rt_mutex_unlock()
> instead of now.

It is on my list to remove.  ;-)

							Thanx, Paul

