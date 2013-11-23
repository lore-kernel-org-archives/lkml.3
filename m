Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3KWSxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 13:53:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40800 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3KWSxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 13:53:11 -0500
Date: Sat, 23 Nov 2013 19:53:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
Message-ID: <20131123185301.GN4971@laptop.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
 <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
 <CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
 <20131121150344.GG10022@twins.programming.kicks-ass.net>
 <CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
 <20131122120733.GP3866@twins.programming.kicks-ass.net>
 <CAE9FiQX4++Y_eK8qP0vsJMmE9xXHECjpAZwqD4iv569HGJAziQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQX4++Y_eK8qP0vsJMmE9xXHECjpAZwqD4iv569HGJAziQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:00:54PM -0800, Yinghai Lu wrote:
> On Fri, Nov 22, 2013 at 4:07 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > And I suppose a kernel before
> >
> >   863bffc80898 ("sched/fair: Fix group power_orig computation")
> >
> > work fine, eh?
> >
> > I'll further assume that your RIP points to:
> >
> >         sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
> >
> > indicating that sds.total_pwr := 0.
> >
> > update_sd_lb_stats() computes it like:
> >
> >                 sds->total_pwr += sgs->group_power;
> >
> > which comes out of update_sg_lb_stats() like:
> >
> >         sgs->group_power = group->sgp->power;
> >
> > Which we compute in update_group_power() similarly to how we did before
> > 863bffc80898.
> >
> > Which leaves me a bit puzzled.
> 
> Hi,
> for linus tree i need to revert commit-863bffc.
>    commit-863bffc
> 
> for linus tree + sched/urgent, I need to revert
>    commit-42eb088
>    commit-9abf24d
>    commit-863bffc
> .
> If only revert commit-42eb088, still have problem.
> if only revert  commit-9abf24d, commit-863bffc, still have problem.
> 
> Assume you need to dump sched/urgent,
> and revert commit-863bffc directly from Linus's tree.

That doesn't answer any of the questions above and only raises more
questions.

I also will not revert until a little later, I really need to understand
this. My wsm-ep system boots just fine, so there's something funny
somewhere.

I also cannot see the difference between 863bffc^1 and 9abf24d.

Also, you mentioning 42eb088 is new; what does that have to do with
anything? You cannot revert that without also reverting 37dc6b50cee9,
but you don't mention that commit at all.



