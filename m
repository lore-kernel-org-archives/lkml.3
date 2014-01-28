Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaA1Jbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:31:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50539 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaA1Jbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:31:41 -0500
Date: Tue, 28 Jan 2014 10:31:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Luca Abeni <luca.abeni@unitn.it>, Henrik Austad <henrik@austad.us>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140128093101.GE11314@laptop.programming.kicks-ass.net>
References: <20140120131616.GB8907@austad.us>
 <52DD2711.9080504@unitn.it>
 <20140121102016.GA12002@austad.us>
 <52DE5B7F.8020900@unitn.it>
 <20140121123334.GJ30183@twins.programming.kicks-ass.net>
 <52DE6D21.1080602@unitn.it>
 <20140121135559.GK30183@twins.programming.kicks-ass.net>
 <52DFC196.7020301@unitn.it>
 <20140122135159.GQ31570@twins.programming.kicks-ass.net>
 <52E23BA3.7090206@sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E23BA3.7090206@sssup.it>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 10:08:35AM +0000, Tommaso Cucinotta wrote:
> > We should also again talk about what it would take to allow
> > unprivileged access to SCHED_DEADLINE. The things I can remember are the
> > obvious cap on utilization and a minimum period -- the latter so that we
> > don't DoS the system with a metric ton of tiny tasks.
> > 
> > But I seem to remember there were a few other issues.
> 
> Exactly. I can remember also a huge period might be harmful, because with it
> even a tiny utilization may lead to a big runtime that starves the whole non
> RT tasks for a significant time. 

Another way to solve that is with explicit slack time scheduling, where
slack here means the time/utilization not allocated to dl tasks (a quick
google shows various different usages of slack, including laxity).

So suppose we have 50% utilization but with a huge period, we could
schedule the other 50% at a fixed but smaller period and have that run
the rt/fair/etc tasks.

So effectively we'll always fill up the utilization to 100% and use the
'slack' time as a server for the other classes.

> Just in case, I had this paper
> 
>   http://retis.sssup.it/~tommaso/papers/rtas08.php
> 
> discussing the issues I had found, and how they were tackled in the AQuoSA
> supervisor. See Section 3.1.

/me *click*
