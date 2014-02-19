Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaBSShs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:37:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38874 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaBSShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:37:47 -0500
Date: Wed, 19 Feb 2014 19:37:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
Message-ID: <20140219183741.GM27965@twins.programming.kicks-ass.net>
References: <52FFF7F8.2070801@oracle.com>
 <5301C41D.5000009@linux.vnet.ibm.com>
 <20140217092055.GP27965@twins.programming.kicks-ass.net>
 <5302C4F1.3020907@linux.vnet.ibm.com>
 <5304F38E.3090701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5304F38E.3090701@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:10:22PM -0500, Sasha Levin wrote:
> On 02/17/2014 09:26 PM, Michael wang wrote:
> >On 02/17/2014 05:20 PM, Peter Zijlstra wrote:
> >[snip]
> >>>>>  static void switched_to_fair(struct rq *rq, struct task_struct *p)
> >>>>>  {
> >>>>>-	if (!p->se.on_rq)
> >>>>>+	struct sched_entity *se = &p->se;
> >>>>>+#ifdef CONFIG_FAIR_GROUP_SCHED
> >>>>>+	se->depth = se->parent ? se->parent->depth + 1 : 0;
> >>>>>+#endif
> >>>>>+	if (!se->on_rq)
> >>>>>  		return;
> >>>>>
> >>>>>  	/*
> >>>
> >>>Yes indeed. My first idea yesterday was to put it in set_task_rq() to be
> >>>absolutely sure we catch all; but if this is sufficient its better.
> >Agree, let's wait for Sasha's testing result then:)
> 
> I took my time with testing it seems I'm hitting new issues with both sched
> and mm, and I've wanted to confirm I don't see this one any more.
> 
> It does seem like this patch fixes the problem for me, so:
> 
> 	Tested-by: Sasha Levin <sasha.levin@oracle.com>
> 

Thanks!
