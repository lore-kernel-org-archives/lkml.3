Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab3EWLao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:30:44 -0400
Received: from mail.us.es ([193.147.175.20]:59139 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758628Ab3EWLal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:30:41 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus3 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.8/17262. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-100.4/7.5):. 
 Processed in 1.849341 secs); 23 May 2013 11:30:40 -0000
X-Envelope-From: pneira@us.es
Date: Thu, 23 May 2013 13:30:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@verge.net.au>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH ipvs-next v3 1/2] sched: add cond_resched_rcu() helper
Message-ID: <20130523113019.GE22553@localhost>
References: <1369201832-17163-1-git-send-email-horms@verge.net.au>
 <1369201832-17163-2-git-send-email-horms@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369201832-17163-2-git-send-email-horms@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:50:31PM +0900, Simon Horman wrote:
> This is intended for use in loops which read data protected by RCU and may
> have a large number of iterations.  Such an example is dumping the list of
> connections known to IPVS: ip_vs_conn_array() and ip_vs_conn_seq_next().
> 
> The benefits are for CONFIG_PREEMPT_RCU=y where we save CPU cycles
> by moving rcu_read_lock and rcu_read_unlock out of large loops
> but still allowing the current task to be preempted after every
> loop iteration for the CONFIG_PREEMPT_RCU=n case.
> 
> The call to cond_resched() is not needed when CONFIG_PREEMPT_RCU=y.
> Thanks to Paul E. McKenney for explaining this and for the
> final version that checks the context with CONFIG_DEBUG_ATOMIC_SLEEP=y
> for all possible configurations.
> 
> The function can be empty in the CONFIG_PREEMPT_RCU case,
> rcu_read_lock and rcu_read_unlock are not needed in this case
> because the task can be preempted on indication from scheduler.
> Thanks to Peter Zijlstra for catching this and for his help
> in trying a solution that changes __might_sleep.
> 
> Initial cond_resched_rcu_lock() function suggested by Eric Dumazet.

Applied, thanks.
