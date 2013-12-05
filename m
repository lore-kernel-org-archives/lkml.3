Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab3LECvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:51:55 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38857 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab3LECvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:51:52 -0500
Date: Wed, 4 Dec 2013 18:51:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@freedesktop.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: lots of brief rcu stalls.
Message-ID: <20131205025147.GN15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131204232838.GA25592@redhat.com>
 <20131205001614.GI15492@linux.vnet.ibm.com>
 <1386209910.30495.146.camel@edumazet-glaptop2.roam.corp.google.com>
 <1386210965.30493.84.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386210965.30493.84.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120502-1542-0000-0000-000003EA2227
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:36:05PM -0800, Joe Perches wrote:
> On Wed, 2013-12-04 at 18:18 -0800, Eric Dumazet wrote:
> > On Wed, 2013-12-04 at 16:16 -0800, Paul E. McKenney wrote:
> > > +	    ULONG_CMP_GE(ACCESS_ONCE(jiffies), rdp->rsp->jiffies_resched)) {
> 
> perhaps time_before_eq
> 
> > jiffies should not need ACCESS_ONCE(), right ?
> > 
> > It is one of the few variables marked with volatile keyword.
> 
> It does seem redundant
> 
> $ git grep -n "ACCESS_ONCE(jiffies)"
> kernel/rcu/torture.c:1354:      jiffies_snap = ACCESS_ONCE(jiffies);
> kernel/rcu/torture.c:1363:              jiffies_snap = ACCESS_ONCE(jiffies);
> kernel/rcu/tree.c:820:  unsigned long j = ACCESS_ONCE(jiffies);
> kernel/rcu/tree.c:975:  j = ACCESS_ONCE(jiffies);

I took care of the first four, plus one more that I have in my local tree.

							Thanx, Paul

> kernel/sched/core.c:2324:       unsigned long next, now = ACCESS_ONCE(jiffies);
> kernel/sched/proc.c:536:        unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> kernel/sched/proc.c:558:        unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> 
> 

