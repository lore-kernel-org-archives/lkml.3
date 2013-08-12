Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab3HLNz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:55:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56290 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3HLNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:55:54 -0400
Date: Mon, 12 Aug 2013 15:55:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
Message-ID: <20130812135544.GG27162@twins.programming.kicks-ass.net>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>
 <20130808204020.GA31127@linux.vnet.ibm.com>
 <5204B6EF.6000905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5204B6EF.6000905@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 05:31:27PM +0800, Lai Jiangshan wrote:
> On 08/09/2013 04:40 AM, Paul E. McKenney wrote:
> > One problem here -- it may take quite some time for a set_need_resched()
> > to take effect.  This is especially a problem for RCU priority boosting,
> > but can also needlessly delay preemptible-RCU grace periods because
> > local_irq_restore() and friends don't check the TIF_NEED_RESCHED bit.
> 
> 
> The final effect of deboosting(rt_mutex_unlock()) is also accomplished
> via set_need_resched()/set_tsk_need_resched().
> set_need_resched() is enough for RCU priority boosting issue here.

But there's a huge difference between the boosting and deboosting side
of things. rcu_read_unlock_special() starts the boost, the deboosting
only matters if/when you reschedule. 
