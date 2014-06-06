Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaFFLQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:16:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbaFFLQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:16:27 -0400
Message-ID: <1402053383.5859.8.camel@marge.simpson.net>
Subject: Re: sched: how to pick runqueue when checking task hot?
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: zhdxzx@sina.com, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, dhillf <dhillf@gmail.com>,
        "hillf.zj" <hillf.zj@alibaba-inc.com>
Date: Fri, 06 Jun 2014 13:16:23 +0200
In-Reply-To: <20140606101508.GP3213@twins.programming.kicks-ass.net>
References: <20140606065956.854A6718001@webmail.sinamail.sina.com.cn>
	 <20140606101508.GP3213@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 12:15 +0200, Peter Zijlstra wrote:

> > --- a/kernel/sched/fair.c	Fri Jun  6 12:37:37 2014
> > +++ b/kernel/sched/fair.c	Fri Jun  6 14:32:34 2014
> > @@ -5051,7 +5051,7 @@ task_hot(struct task_struct *p, u64 now)
> >  	/*
> >  	 * Buddy candidates are cache hot:
> >  	 */
> > -	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
> > +	if (sched_feat(CACHE_HOT_BUDDY) && task_rq(p)->nr_running &&
> >  			(&p->se == cfs_rq_of(&p->se)->next ||
> >  			 &p->se == cfs_rq_of(&p->se)->last))
> >  		return 1;
> 
> That does appear to make more sense indeed, seeing how buddies are pairs
> of tasks, so protecting a lone task doesn't make sense.
> 
> 
> Mike, how did you intend this code to work?

IIRC, this_rq()->nr_running was to say if we're idle, we don't care that
it's last/next, pull it.  Not sure I'm the one who did that, but could
be, I didn't look.

-Mike

