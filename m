Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaF2KzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:55:03 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:46538 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaF2KzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:55:01 -0400
Date: Sun, 29 Jun 2014 12:54:57 +0200
From: Andreas Mohr <andi@lisas.de>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] sched: Transform resched_task() into resched_curr()
Message-ID: <20140629105457.GA5413@rhlx01.hs-esslingen.de>
References: <20140629072059.GA18636@rhlx01.hs-esslingen.de>
 <53AFC6FD.5070508@yandex.ru>
 <20140629083617.GA27653@rhlx01.hs-esslingen.de>
 <53AFD57D.4090008@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AFD57D.4090008@yandex.ru>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 12:59:41PM +0400, Kirill Tkhai wrote:
> On 29.06.2014 12:36, Andreas Mohr wrote:
> > I just noticed that there is a part touching rq->idle,
> > and ISTR that idle task handling is "special"
> > (after all that's the power management side of things).
> > Specifically, rq->curr and rq->idle are distinct rq members
> > (since they are distinct tasks AFAIK!),
> > so there might now be some issues with task state tracking here
> > (unless this cleanup happens to unify handling here anyway).
> 
> Are you worrying about check_preempt_curr_idle()? I've looked
> at check_preempt_curr() and found, we never call this function
> in current scheduler logic.

Yeah - I should have included that hunk verbatim, sorry.


> It's called only if just enqueued task is of the same class as
> rq's current, but we can't have two idle class tasks enqueued
> on the same rq. So, it's just a stub. We can do not worry
> about this.

That seems to be the case indeed in current implementation.

Removing specific references from these sched_class parts
(here: idle_task.c, rq->idle) where possible seems to be a good direction,
since AFAIUI sched_class things are supposed to encode *behaviour*,
where containing too many specific-member references is best avoided.



I'd fathom that for the sched_curr() handler
I'm still somewhat in favour of an extra non-inline wrapper though;
it's just good minimal-dependency implementation.
But more frequent topic partners might have more valuable input
on this patch :)

Thanks,

Andreas
