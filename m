Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3D2VMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:12:32 -0400
Received: from ja.ssi.bg ([178.16.129.10]:53695 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758227Ab3D2VMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:12:30 -0400
Date: Tue, 30 Apr 2013 00:08:18 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Simon Horman <horms@verge.net.au>, Ingo Molnar <mingo@redhat.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, dhaval.giani@gmail.com
Subject: Re: [PATCH 2/2] ipvs: Use cond_resched_rcu_lock() helper when dumping
 connections
In-Reply-To: <20130427162049.GB3780@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1304292356220.1822@ja.ssi.bg>
References: <1366940708-10180-1-git-send-email-horms@verge.net.au> <1366940708-10180-3-git-send-email-horms@verge.net.au> <20130426080313.GC8669@dyad.programming.kicks-ass.net> <20130426154547.GC3860@linux.vnet.ibm.com> <20130426171948.GA31467@dyad.programming.kicks-ass.net>
 <20130426174815.GI3860@linux.vnet.ibm.com> <1367000815.8964.243.camel@edumazet-glaptop> <alpine.LFD.2.00.1304271342260.1633@ja.ssi.bg> <20130427162049.GB3780@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Sat, 27 Apr 2013, Paul E. McKenney wrote:

> On Sat, Apr 27, 2013 at 02:32:48PM +0300, Julian Anastasov wrote:
> > 
> > 	So, I assume, to help realtime kernels and rcu_barrier
> > it is not a good idea to guard rcu_read_unlock with checks.
> > I see that rcu_read_unlock will try to reschedule in the 
> > !CONFIG_PREEMPT_RCU case (via preempt_enable), can we
> > use ifdefs to avoid double TIF_NEED_RESCHED check?:
> > 
> > 	rcu_read_unlock();
> > #if !defined(CONFIG_PREEMPT) || defined(CONFIG_PREEMPT_RCU)
> 
> I would instead suggest something like:
> 
> #ifndef CONFIG_PREEMPT_RCU
> 
> But yes, in the CONFIG_PREEMPT_RCU case, the cond_resched() is not
> needed.

	Hm, is this correct? If I follow the ifdefs
preempt_schedule is called when CONFIG_PREEMPT is
defined _and_ CONFIG_PREEMPT_RCU is not defined.
Your example for CONFIG_PREEMPT_RCU is the opposite to this?

> 							Thanx, Paul
> 
> > 	cond_resched();
> > #endif
> > 	rcu_read_lock();

Regards

--
Julian Anastasov <ja@ssi.bg>
