Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbaJIPSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:18:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:40738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217AbaJIPSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:18:21 -0400
Date: Thu, 9 Oct 2014 17:18:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Subject: Re: [PATCH v7 6/7] sched: replace capacity_factor by usage
Message-ID: <20141009151820.GX10832@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org>
 <20141009121643.GQ4750@worktop.programming.kicks-ass.net>
 <CAKfTPtCX687FkGgxLO7spfGvDxhDWeFDERLRZ-NakO2Jrpmnhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtCX687FkGgxLO7spfGvDxhDWeFDERLRZ-NakO2Jrpmnhw@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 04:18:02PM +0200, Vincent Guittot wrote:
> On 9 October 2014 14:16, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Oct 07, 2014 at 02:13:36PM +0200, Vincent Guittot wrote:
> >> +static inline bool
> >> +group_has_capacity(struct lb_env *env, struct sg_lb_stats *sgs)
> >>  {
> >> +     if ((sgs->group_capacity * 100) >
> >> +                     (sgs->group_usage * env->sd->imbalance_pct))
> >> +             return true;
> >
> > Why the imb_pct there? We're looking for 100% utilization, not 130 or
> > whatnot, right?
> 
> Having exactly 100% is quite difficult because of various rounding.
> So i have added a margin/threshold to prevent any excessive change of the state.
> I have just to use the same margin/threshold than in other place in
> load balance.
> 

Yet you failed to mention this anywhere. Also does it really matter?
