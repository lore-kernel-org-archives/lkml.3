Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab3FEEm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 00:42:56 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34331 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3FEEmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 00:42:54 -0400
Message-ID: <51AEC1C3.1040804@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 12:42:43 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: mingo@redhat.com, peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 1/2] sched: Optimize build_sched_domains() for saving
 first SD node for a cpu
References: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
In-Reply-To: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060504-3864-0000-0000-00000875C817
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Viresh

On 06/04/2013 07:20 PM, Viresh Kumar wrote:
[snip]
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..638f6cb 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6533,16 +6533,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
>  		sd = NULL;
>  		for (tl = sched_domain_topology; tl->init; tl++) {
>  			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
> +			if (!*per_cpu_ptr(d.sd, i))

What about:
			if (tl == sched_domain_topology)

It cost less than per_cpu_ptr(), isn't it?

Regards,
Michael Wang

> +				*per_cpu_ptr(d.sd, i) = sd;
>  			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
>  				sd->flags |= SD_OVERLAP;
>  			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
>  				break;
>  		}
> -
> -		while (sd->child)
> -			sd = sd->child;
> -
> -		*per_cpu_ptr(d.sd, i) = sd;
>  	}
> 
>  	/* Build the groups for the domains */
> 

