Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaJCQGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:06:10 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41059 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaJCQGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:06:06 -0400
Date: Fri, 3 Oct 2014 17:05:55 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Subject: Re: [PATCH v6 3/6] sched: add utilization_avg_contrib
Message-ID: <20141003160555.GH28662@e103034-lin>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-4-git-send-email-vincent.guittot@linaro.org>
 <20141003143634.GL2849@worktop.programming.kicks-ass.net>
 <CAKfTPtDvX=JFf6OBBzTVbo6C76p243za+9CkL-ofSOvHQS5-mQ@mail.gmail.com>
 <20141003151451.GJ10583@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003151451.GJ10583@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 04:14:51PM +0100, Peter Zijlstra wrote:
> On Fri, Oct 03, 2014 at 04:51:01PM +0200, Vincent Guittot wrote:
> > On 3 October 2014 16:36, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > >> +      * utilization_load_avg is the sum of the average running time of the
> > >> +      * sched_entities on the rq.
> > >>        */
> > >
> > > So I think there was some talk about a blocked_utilization thingy, which
> > > would track the avg running time of the tasks currently asleep, right?
> > >
> > 
> > yes. Do you mean that we should anticipate and rename
> > utilization_load_avg into utilization_runnable_avg to make space for a
> > utilization_blocked_avg that could be added in future ?
> 
> nah, just trying to put things straight in my brain, including what is
> 'missing'.

As Ben pointed out in the scale-invariance thread, we need blocked
utilization. I fully agree with that. It doesn't make any sense not to
include it. In fact I do have the patch already.

If you want to rename utlization_load_avg you should name it
utilization_running_avg, not utilization_runnable_avg :) Or even better,
something shorter.
