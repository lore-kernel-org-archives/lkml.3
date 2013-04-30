Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab3D3Hvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:51:32 -0400
Received: from ja.ssi.bg ([178.16.129.10]:39252 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759032Ab3D3Hva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:51:30 -0400
Date: Tue, 30 Apr 2013 10:52:38 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Simon Horman <horms@verge.net.au>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH v2 1/2] sched: Add cond_resched_rcu_lock() helper
In-Reply-To: <20130430072944.GA13959@verge.net.au>
Message-ID: <alpine.LFD.2.00.1304301051260.1700@ja.ssi.bg>
References: <1367290378-29224-1-git-send-email-horms@verge.net.au> <1367290378-29224-2-git-send-email-horms@verge.net.au> <alpine.LFD.2.00.1304301011310.1700@ja.ssi.bg> <20130430072944.GA13959@verge.net.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Tue, 30 Apr 2013, Simon Horman wrote:

> > > +static void inline cond_resched_rcu_lock(void)
> > > +{
> > > +	if (need_resched()) {
> > 
> > 	Ops, it should be without above need_resched.
> 
> Thanks, to clarify, just this:
> 
> static void inline cond_resched_rcu_lock(void)
> {
> 	rcu_read_unlock();
> #ifndef CONFIG_PREEMPT_RCU
> 	cond_resched();
> #endif
> 	rcu_read_lock();
> }

	Yes, thanks!

--
Julian Anastasov <ja@ssi.bg>
