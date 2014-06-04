Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaFDK0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:26:07 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56670 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751364AbaFDK0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:26:04 -0400
Date: Wed, 4 Jun 2014 11:25:59 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140604102559.GK29593@e103034-lin>
References: <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <20140603155007.GZ30445@twins.programming.kicks-ass.net>
 <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
 <20140604080809.GK30445@twins.programming.kicks-ass.net>
 <20140604085542.GH29593@e103034-lin>
 <20140604092313.GB11096@twins.programming.kicks-ass.net>
 <CAKfTPtBVyMMzXoFoL=kT8oP97BZ8S6P_2ySNhXLC1gR80jw6vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtBVyMMzXoFoL=kT8oP97BZ8S6P_2ySNhXLC1gR80jw6vA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:35:15AM +0100, Vincent Guittot wrote:
> On 4 June 2014 11:23, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Jun 04, 2014 at 09:55:42AM +0100, Morten Rasmussen wrote:
> >> Both running_avg and runnable_avg are affected by other tasks on the
> >> same cpus, but in different ways. They are equal if you only have one
> >> task on a cpu. If you have more, running_avg will give you the true
> >> requirement of the tasks until the cpu is fully utilized. At which point
> >> the task running_avg will drop if you add more tasks (the unweighted sum
> >> of task running_avgs remains constant).
> >>
> >> runnable_avg on the other hand, might be affected as soon as you have
> >> two task running on the same cpu if they are runnable at the same time.
> >> That isn't necessarily a bad thing for load-balancing purposes, because
> >> tasks that are runnable at the same time are likely to be run more
> >> efficiently by placing them on different cpus. You might view as at sort
> >> of built in concurrency factor, somewhat similar to what Yuyang is
> >> proposing. runnable_avg increases rapidly when the cpu is over-utilized.
> >
> > Agreed.
> >
> >> > I'm not sure I see how 100% is possible, but yes I agree that runnable
> >> > can indeed be inflated due to this queueing effect.
> >>
> >> You should only be able to get to 75% worst case for runnable_avg for
> >> that example. The total running_avg is 50% no matter if the tasks
> >> overlaps or not.
> >
> > Yes, 75% is what I ended up with.
> 
> Can you explain how you reach 75% as it depends on the runtime and a
> runtime longer than 345ms will end to a 100% load whatever the
> idletime was previously ?

If the busy period of each task is long enough that the first one to run
runs to completetion before the other task is scheduled you get 25% and
50%. But as I said in my other reply, you can get higher task runnable
if the tasks busy period is long enough that you switch between them
before the first one completes.
