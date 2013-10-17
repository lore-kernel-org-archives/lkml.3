Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3JQKgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:36:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34165 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3JQKgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:36:14 -0400
Date: Thu, 17 Oct 2013 16:06:04 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] rcu: Create rcu_sync infrastructure
Message-ID: <20131017103604.GJ19729@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131008102505.404025673@infradead.org>
 <20131008103830.180541879@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131008103830.180541879@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101710-6688-0000-0000-0000029E45FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2013-10-08 12:25:07]:

> From: Oleg Nesterov <oleg@redhat.com>
> 
> It is functionally equivalent to
> 
>         struct rcu_sync_struct {
>                 atomic_t counter;
>         };
> 
>         static inline bool rcu_sync_is_idle(struct rcu_sync_struct *xxx)
>         {
>                 return atomic_read(&xxx->counter) == 0;
>         }
> 
>         static inline void rcu_sync_enter(struct rcu_sync_struct *xxx)
>         {
>                 atomic_inc(&xxx->counter);
>                 synchronize_sched();
>         }
> 
>         static inline void rcu_sync_enter(struct rcu_sync_struct *xxx)

Guess you meant rcu_sync_exit

>         {
>                 synchronize_sched();
>                 atomic_dec(&xxx->counter);
>         }
> 
> except: it records the state and synchronize_sched() is only called by
> rcu_sync_enter() and only if necessary.
> 

-- 
Thanks and Regards
Srikar Dronamraju

