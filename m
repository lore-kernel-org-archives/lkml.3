Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3FELEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:04:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48769 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3FELEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:04:45 -0400
Date: Wed, 5 Jun 2013 13:04:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>, mingo@redhat.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 1/2] sched: Optimize build_sched_domains() for saving
 first SD node for a cpu
Message-ID: <20130605110434.GY8923@twins.programming.kicks-ass.net>
References: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
 <51AEC1C3.1040804@linux.vnet.ibm.com>
 <CAKohpokGrgFOtOT6Y3e4MOJBUQWT4FG4Mk-F6_M0V-pEEf3KYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokGrgFOtOT6Y3e4MOJBUQWT4FG4Mk-F6_M0V-pEEf3KYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:37:29AM +0530, Viresh Kumar wrote:
> On 5 June 2013 10:12, Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
> > Hi, Viresh
> >
> > On 06/04/2013 07:20 PM, Viresh Kumar wrote:
> > [snip]
> >> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> >> index 58453b8..638f6cb 100644
> >> --- a/kernel/sched/core.c
> >> +++ b/kernel/sched/core.c
> >> @@ -6533,16 +6533,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
> >>               sd = NULL;
> >>               for (tl = sched_domain_topology; tl->init; tl++) {
> >>                       sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
> >> +                     if (!*per_cpu_ptr(d.sd, i))
> >
> > What about:
> >                         if (tl == sched_domain_topology)
> >
> > It cost less than per_cpu_ptr(), isn't it?
> 
> How can I miss it.. Obviously its better :)
> 
> See if below one looks better (Attached too in case gmail screws up
> my mail)..
> 
> --------x-------------x------------------
> 
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Tue, 4 Jun 2013 15:41:15 +0530
> Subject: [PATCH] sched: Optimize build_sched_domains() for saving first SD
>  node for a cpu
> 
> We are saving first scheduling domain for a cpu in build_sched_domains() by
> iterating over the nested sd->child list. We don't actually need to do it this
> way.
> 
> tl will be equal to sched_domain_topology for the first iteration and so we can
> set *per_cpu_ptr(d.sd, i) based on that.  So, save pointer to first SD while
> running the iteration loop over tl's.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/sched/core.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..08a27be 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6533,16 +6533,13 @@ static int build_sched_domains(const struct
> cpumask *cpu_map,

Applying patch
patches/viresh_kumar-_patch__sched-optimize_build_sched_domains_for_saving_first_sd.patch
patching file kernel/sched/core.c
patch: **** malformed patch at line 56: cpumask *cpu_map,

