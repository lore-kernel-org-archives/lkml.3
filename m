Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab3LECgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:36:13 -0500
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:54957 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752401Ab3LECgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:36:10 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3653:3865:3866:3871:3872:4321:4605:5007:7652:7904:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: scent92_8ccba6daf960a
X-Filterd-Recvd-Size: 1966
Message-ID: <1386210965.30493.84.camel@joe-AO722>
Subject: Re: lots of brief rcu stalls.
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@freedesktop.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Wed, 04 Dec 2013 18:36:05 -0800
In-Reply-To: <1386209910.30495.146.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20131204232838.GA25592@redhat.com>
	 <20131205001614.GI15492@linux.vnet.ibm.com>
	 <1386209910.30495.146.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 18:18 -0800, Eric Dumazet wrote:
> On Wed, 2013-12-04 at 16:16 -0800, Paul E. McKenney wrote:
> > +	    ULONG_CMP_GE(ACCESS_ONCE(jiffies), rdp->rsp->jiffies_resched)) {

perhaps time_before_eq

> jiffies should not need ACCESS_ONCE(), right ?
> 
> It is one of the few variables marked with volatile keyword.

It does seem redundant

$ git grep -n "ACCESS_ONCE(jiffies)"
kernel/rcu/torture.c:1354:      jiffies_snap = ACCESS_ONCE(jiffies);
kernel/rcu/torture.c:1363:              jiffies_snap = ACCESS_ONCE(jiffies);
kernel/rcu/tree.c:820:  unsigned long j = ACCESS_ONCE(jiffies);
kernel/rcu/tree.c:975:  j = ACCESS_ONCE(jiffies);
kernel/sched/core.c:2324:       unsigned long next, now = ACCESS_ONCE(jiffies);
kernel/sched/proc.c:536:        unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
kernel/sched/proc.c:558:        unsigned long curr_jiffies = ACCESS_ONCE(jiffies);


