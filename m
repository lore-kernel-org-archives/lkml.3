Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJBJYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:24:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaJBJYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:24:36 -0400
Date: Thu, 2 Oct 2014 11:24:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Use RCU read lock on all calls to dl_bw_of()
Message-ID: <20141002092428.GA2849@worktop.programming.kicks-ass.net>
References: <1412003970-25277-1-git-send-email-sasha.levin@oracle.com>
 <1412009027.20287.17.camel@tkhai>
 <20140929165418.GQ5430@worktop>
 <20140929170022.GA18926@worktop.programming.kicks-ass.net>
 <1412065417.20287.24.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412065417.20287.24.camel@tkhai>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:23:37PM +0400, Kirill Tkhai wrote:
> [PATCH]sched: Use dl_bw_of() under preempt_disable()
> 
> rq->rd is freed using call_rcu_sched(), so rcu_read_lock() to access it
> is not enough. We should use either rcu_read_lock_sched() or preempt_disable().
> 
> We choose preempt_disable()/preempt_enable() like in other places
> where rq->rd is used.

I changed it to rcu_read_lock_sched(), but no biggie, thanks!
