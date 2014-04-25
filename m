Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaDYGDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 02:03:13 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55722 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaDYGDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 02:03:11 -0400
Message-ID: <5359F966.8040205@linux.vnet.ibm.com>
Date: Fri, 25 Apr 2014 11:27:58 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, alex.shi@linaro.org, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/3] sched: Initialize newidle balance stats in sd_numa_init()
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com> <1398303035-18255-3-git-send-email-jason.low2@hp.com>
In-Reply-To: <1398303035-18255-3-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042506-9332-0000-0000-0000009B463B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 07:00 AM, Jason Low wrote:
> Also initialize the per-sd variables for newidle load balancing
> in sd_numa_init().
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>  kernel/sched/core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 3f12533..b1c6cb9 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6030,6 +6030,8 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
>  					,
>  		.last_balance		= jiffies,
>  		.balance_interval	= sd_weight,
> +		.max_newidle_lb_cost	= 0,
> +		.next_decay_max_lb_cost	= jiffies,
>  	};
>  	SD_INIT_NAME(sd, NUMA);
>  	sd->private = &tl->data;
> 
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

