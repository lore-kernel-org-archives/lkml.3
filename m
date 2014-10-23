Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbaJWCNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:13:30 -0400
Received: from mout.gmx.net ([212.227.17.21]:57776 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbaJWCN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:13:26 -0400
Message-ID: <1414030360.5228.12.camel@marge.simpson.net>
Subject: Re: [PATCH RFC 5/7] sched: cfs: cpu frequency scaling arch functions
From: Mike Galbraith <efault@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        kamalesh@linux.vnet.ibm.com, Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>
Date: Thu, 23 Oct 2014 04:12:40 +0200
In-Reply-To: <54485D03.9070107@redhat.com>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
	 <1413958051-7103-6-git-send-email-mturquette@linaro.org>
	 <54480E58.5060600@redhat.com>
	 <CAPtuhThe9dQkbwbXoCV0VpHohrC8UacPoL5vCn2uDqHcjbtKGA@mail.gmail.com>
	 <54485D03.9070107@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:Hpcwr1Dd2gMvvy7e3vHXdC5y6Eew6PIZtKtIwFmX4XRL23hrbX9
 tYYFnm+97d2tBCvab3/eSjL9lVlZolBuGWcSv/eboiuWcHqxY15orAa23ANMfjfBsw6Xhrd
 /z+1i5kYS138PjEtGIDEBTrQcVsr8/ZMzYrh5KdtKQzzW/+8k+S9Z6ZIRwE4NIsSoA0m0rS
 e2vez81MZT6//o5ntaU0A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 21:42 -0400, Rik van Riel wrote: 
> On 10/22/2014 07:20 PM, Mike Turquette wrote:
> > On Wed, Oct 22, 2014 at 1:06 PM, Rik van Riel <riel@redhat.com>
> > wrote: On 10/22/2014 02:07 AM, Mike Turquette wrote:
> >>>> arch_eval_cpu_freq and arch_scale_cpu_freq are added to allow
> >>>> the scheduler to evaluate if cpu frequency should change and
> >>>> to invoke that change from a safe context.
> >>>> 
> >>>> They are weakly defined arch functions that do nothing by
> >>>> default. A CPUfreq governor could use these functions to
> >>>> implement a frequency scaling policy based on updates to
> >>>> per-task statistics or updates to per-cpu utilization.
> >>>> 
> >>>> As discussed at Linux Plumbers Conference 2014, the goal will
> >>>> be to focus on a single cpu frequency scaling policy that
> >>>> works for everyone. That may mean that the weak arch
> >>>> functions definitions can be removed entirely and a single
> >>>> policy implements that logic for all architectures.
> > 
> > On virtual machines, we probably want to use both frequency and 
> > steal time to calculate the factor.
> > 
> >> You mean for calculating desired cpu frequency on a virtual
> >> guest? Is that something we want to do?
> 
> A guest will be unable to set the cpu frequency, but it should
> know what the frequency is, so it can take the capacity of each
> CPU into account when doing things like load balancing.

Hm.  Why does using vaporite freq/capacity/whatever make any sense, the
silicon under the V(aporite)PU can/does change at the drop of a hat, no?

-Mike

