Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3IMQLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:11:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54677 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3IMQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:11:16 -0400
Date: Fri, 13 Sep 2013 17:10:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 106/228] cpufreq: integrator: don't initialize part of
	policy that is set by core too
Message-ID: <20130913161059.GD12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org> <6d8d406ebca886e5147191cc8c333d926ef9eb30.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d8d406ebca886e5147191cc8c333d926ef9eb30.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 06:30:52PM +0530, Viresh Kumar wrote:
> Many common initializations of struct policy are moved to core now and hence
> this driver doesn't need to do it. This patch removes such code.
> 
> Most recent of those changes is to call ->get() in the core after calling
> ->init().
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/integrator-cpufreq.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cpufreq/integrator-cpufreq.c b/drivers/cpufreq/integrator-cpufreq.c
> index 8152a9b..babf3e4 100644
> --- a/drivers/cpufreq/integrator-cpufreq.c
> +++ b/drivers/cpufreq/integrator-cpufreq.c
> @@ -181,10 +181,9 @@ static int integrator_cpufreq_init(struct cpufreq_policy *policy)
>  {
>  
>  	/* set default policy and cpuinfo */
> -	policy->cpuinfo.max_freq = 160000;
> -	policy->cpuinfo.min_freq = 12000;
> +	policy->max = policy->cpuinfo.max_freq = 160000;
> +	policy->min = policy->cpuinfo.min_freq = 12000;
>  	policy->cpuinfo.transition_latency = 1000000; /* 1 ms, assumed */
> -	policy->cur = policy->min = policy->max = integrator_get(policy->cpu);

This patch actually changes things - the description is misleading.
Please explain why this change - which results in different values for
policy->min and policy->max doesn't cause any functional difference.

Thanks.
