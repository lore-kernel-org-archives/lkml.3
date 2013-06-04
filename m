Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3FDLTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:19:11 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:61407 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3FDLTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:19:07 -0400
Date: Tue, 4 Jun 2013 13:19:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched: fix clear NOHZ_BALANCE_KICK
Message-ID: <20130604111900.GB14973@somewhere>
References: <1369927385-7801-1-git-send-email-vincent.guittot@linaro.org>
 <20130603224836.GA9388@somewhere>
 <CAKfTPtCB_ftNWjgAM9s79dX_tuS4yevjdD0YxvKfKS4dxz=LLQ@mail.gmail.com>
 <20130604093611.GJ8923@twins.programming.kicks-ass.net>
 <20130604102620.GB14012@somewhere>
 <CAKfTPtCLYnhQH3Mcx5dhRi9+9_679fdrhm8iZBSpgyu8VmevYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtCLYnhQH3Mcx5dhRi9+9_679fdrhm8iZBSpgyu8VmevYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 01:11:47PM +0200, Vincent Guittot wrote:
> On 4 June 2013 12:26, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Tue, Jun 04, 2013 at 11:36:11AM +0200, Peter Zijlstra wrote:
> >>
> >> The best I can seem to come up with is something like the below; but I think
> >> its ghastly. Surely we can do something saner with that bit.
> >>
> >> Having to clear it at 3 different places is just wrong.
> >
> > We could clear the flag early in scheduler_ipi() and set some
> > specific value in rq->idle_balance that tells we want nohz idle
> > balancing from the softirq, something like this untested:
> 
> I'm not sure that we can have less than 2 places to clear it: cancel
> place or acknowledge place otherwise we can face a situation where
> idle load balance will be triggered 2 consecutive times because
> NOHZ_BALANCE_KICK will be cleared before the idle load balance has
> been done and had a chance to migrate tasks.

I guess it depends what is the minimum value of rq->next_balance, it seems
to be large enough to avoid this kind of incident. Although I don't
know well the whole logic with rq->next_balance and ilb trigger so I must
defer to you.
