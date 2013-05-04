Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3EDHWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 03:22:16 -0400
Received: from ja.ssi.bg ([178.16.129.10]:34329 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753576Ab3EDHWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 03:22:14 -0400
Date: Sat, 4 May 2013 10:23:31 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, Simon Horman <horms@verge.net.au>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH v2 1/2] sched: Add cond_resched_rcu_lock() helper
In-Reply-To: <20130503163045.GE3780@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1305041018520.1645@ja.ssi.bg>
References: <20130501155501.GB7521@dyad.programming.kicks-ass.net> <alpine.LFD.2.00.1305012004360.3397@ja.ssi.bg> <20130502072623.GE7521@dyad.programming.kicks-ass.net> <alpine.LFD.2.00.1305021848450.31548@ja.ssi.bg> <20130502173257.GX3780@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1305022140020.31548@ja.ssi.bg> <20130502193409.GA3780@linux.vnet.ibm.com> <alpine.LFD.2.00.1305022249010.25417@ja.ssi.bg> <20130502223107.GB3780@linux.vnet.ibm.com> <alpine.LFD.2.00.1305031024080.1657@ja.ssi.bg>
 <20130503163045.GE3780@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Fri, 3 May 2013, Paul E. McKenney wrote:

> static inline int cond_resched_rcu(void)
> {
> #if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
> 	rcu_read_unlock();
> 	cond_resched();
> 	rcu_read_lock();
> #endif
> }
> 
> This adds absolutely no overhead in non-debug builds of CONFIG_PREEMPT_RCU,
> does the checking in debug builds, and allows voluntary preemption in
> !CONFIG_PREEMPT_RCU builds.  CONFIG_PROVE_RCU builds will check for an
> (illegal) outer rcu_read_lock() in CONFIG_PREEMPT_RCU builds, and you
> will get "scheduling while atomic" in response to an outer rcu_read_lock()
> in !CONFIG_PREEMPT_RCU builds.
> 
> It also seems to me a lot simpler.
> 
> Does this work, or am I still missing something?

	Works perfectly. Thanks! Tested CONFIG_PREEMPT_RCU=y/n,
the errors messages with extra RCU lock.

Regards

--
Julian Anastasov <ja@ssi.bg>
