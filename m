Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaFDNYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:24:01 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14455 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752811AbaFDNYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:24:00 -0400
Date: Wed, 4 Jun 2014 14:23:50 +0100
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
Message-ID: <20140604132350.GP29593@e103034-lin>
References: <20140603155007.GZ30445@twins.programming.kicks-ass.net>
 <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
 <20140604080809.GK30445@twins.programming.kicks-ass.net>
 <CAKfTPtBCG1Jq2b+fyoGuA=7yG_yUbsmaD+j-ZXXsPNGp5giKpg@mail.gmail.com>
 <20140604101724.GD11096@twins.programming.kicks-ass.net>
 <20140604103619.GL29593@e103034-lin>
 <CAKfTPtCVyLRG-fSge1shdw5aSDB3y=_qzU1DOVgCx0VBnn6mnA@mail.gmail.com>
 <20140604112342.GN29593@e103034-lin>
 <CAKfTPtCsxkypo_4e9zTHV_XPUt7-Bybot2uNOHUZVfbd=7vXHw@mail.gmail.com>
 <20140604130918.GO29593@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604130918.GO29593@e103034-lin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 02:09:18PM +0100, Morten Rasmussen wrote:
> On Wed, Jun 04, 2014 at 12:52:46PM +0100, Vincent Guittot wrote:
> > On 4 June 2014 13:23, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > > I get:
> > >
> > > A: 15/40 ms = 37.5%
> > > B: 20/40 ms = 50%
> > >
> > > Schedule:
> > >
> > >    | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms |
> > > A:   run     rq     run  ----------- sleeping -------------  run
> > > B:   rq      run    rq    run   ---- sleeping -------------  rq
> > >
> > >> and CPU runnable will be 60% too
> > >
> > > rq->avg.runnable_avg_sum should be 50%. You have two tasks running for
> > > 20 ms every 40 ms.
> > >
> > > Right?
> > 
> > ok, i see the misunderstood.
> > it's depends of what we mean by runnable. You take the % of time
> > whereas i take the runnable_avg_sum/period
> 
> Right. There is a difference.
> 
> > 
> > so A is on_rq 15/40 ms = 37.5% of the time which gives a
> > runnable_avg_sum/runnable_avg_period of 47%
> > B is on_rq  20/40 ms = 50% of the time which gives a
> > runnable_avg_sum/runnable_avg_period of 60%
> > and CPU has a task on its rq 20/40ms = 50% of the time which gives a
> > runnable_avg_sum/runnable_avg_period of 60%
> 
> Yes, that seems about right.

If my calculations are right, cfs.runnable_load_avg would peak 15 ms
into the period at about 104%. After 20 ms A has decayed more than B has
gained so the sum is slightly lower.
