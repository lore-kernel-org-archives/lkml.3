Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab3IZLQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:16:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47498 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3IZLQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:16:27 -0400
Date: Thu, 26 Sep 2013 13:16:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
Message-ID: <20130926111618.GU3081@twins.programming.kicks-ass.net>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
 <1380099377.8523.9.camel@marge.simpson.net>
 <20130926095812.GR3081@twins.programming.kicks-ass.net>
 <CAPM31RL9RGX=ohUVag=tD41MbXs47dDgpndGfjBt68QeL-De7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RL9RGX=ohUVag=tD41MbXs47dDgpndGfjBt68QeL-De7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 03:55:55AM -0700, Paul Turner wrote:
> > +               /*
> > +                * Don't bother with select_idle_sibling() in the case of a sync wakeup
> > +                * where we know the only running task will soon go-away. Going
> > +                * through select_idle_sibling will only lead to pointless ping-pong.
> > +                */
> > +               if (sync && prev_cpu == cpu && cpu_rq(cpu)->nr_running == 1 &&
> 
> I've long thought of trying something like this.
> 
> I like the intent but I'd go a step further in that I think we want to
> also implicitly extract WF_SYNC itself.

I have vague memories of actually trying something like that a good
number of years ago.. sadly that's all I remember about it.

> What we really then care about is predicting the overlap associated
> with userspace synchronization objects, typically built on top of
> futexes.  Unfortunately the existence/use of per-thread futexes
> reduces how much state you could usefully associate with the futex.
> One approach might be to hash (with some small saturating counter)
> against rip.  But this gets more complicated quite quickly.

Why would you need per object storage? To further granulate the
predicted overlap? instead of having one per task, you have one per
object?

