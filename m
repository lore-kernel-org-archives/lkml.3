Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaGKOwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:52:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaGKOwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:52:00 -0400
Date: Fri, 11 Jul 2014 16:51:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v3 08/12] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140711145138.GC3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org>
 <20140710111833.GY3935@laptop>
 <CAKfTPtD=TiURcppZ+oVUmhMf6Ofxbp4BPA0SCFViu0SDb05oRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtD=TiURcppZ+oVUmhMf6Ofxbp4BPA0SCFViu0SDb05oRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 04:03:51PM +0200, Vincent Guittot wrote:
> On 10 July 2014 13:18, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, Jun 30, 2014 at 06:05:39PM +0200, Vincent Guittot wrote:
> >> +             /*
> >> +              * If the CPUs share their cache and the src_cpu's capacity is
> >> +              * reduced because of other sched_class or IRQs, we trig an
> >> +              * active balance to move the task
> >> +              */
> >> +             if ((sd->flags & SD_SHARE_PKG_RESOURCES)
> >> +              && ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
> >> +                                                     sd->imbalance_pct)))
> >>                       return 1;
> >
> > Why is this tied to shared caches?
> 
> It's just to limit the change of the policy to a level that can have
> benefit without performance regression. I'm not sure that we can do
> that at any level without risk

Similar to the other change; so both details _should_ have been in the
changelogs etc..

In any case, its feels rather arbitrary to me. What about machines where
there's no cache sharing at all (the traditional SMP systems). This
thing you're trying to do still seems to make sense there.

