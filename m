Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaAOOFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:05:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38228 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaAOOFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:05:43 -0500
Date: Wed, 15 Jan 2014 15:05:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, raistlin@linux.it,
        juri.lelli@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140115140514.GB3694@twins.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
 <20140115092245.GA15190@gmail.com>
 <20140115110018.GA31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115110018.GA31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 12:00:18PM +0100, Peter Zijlstra wrote:
> On Wed, Jan 15, 2014 at 10:22:45AM +0100, Ingo Molnar wrote:
> > 2)
> > 
> > It's not clear why this change to __setscheduler() was done:
> > 
> >         /*
> >          * Allow unprivileged RT tasks to decrease priority:
> >          */
> >         if (user && !capable(CAP_SYS_NICE)) {
> > +               if (fair_policy(policy)) {
> > +                       if (!can_nice(p, attr->sched_nice))
> > +                               return -EPERM;
> > +               }
> > +
> >                 if (rt_policy(policy)) {o
> 
> Bah, I'm pretty sure I wrote that :/ And I can't for the life of me
> remember why I did that. Complete fail there.

Ah, I remember, its because we can now set nice through this path as
well, so we have to do permission checks.

The existing 'nice' syscalls have their own permission checks and do not
user __sched_setscheduler() at all.
