Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbaEMIcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:32:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43389 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaEMIcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:32:46 -0400
Message-ID: <5371D8B5.3070701@arm.com>
Date: Tue, 13 May 2014 09:32:53 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Do not zero sg->cpumask and sg->sgp->power in
 build_sched_groups
References: <1398865178-12577-1-git-send-email-dietmar.eggemann@arm.com>
In-Reply-To: <1398865178-12577-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 13 May 2014 08:32:52.0952 (UTC) FILETIME=[EE959580:01CF6E85]
X-MC-Unique: 114051309324409101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 30/04/14 14:39, Dietmar Eggemann wrote:
> From: Dietmar Eggemann <Dietmar.Eggemann@arm.com>
> 
> There is no need to zero struct sched_group member cpumask and struct
> sched_group_power member power since both structures are already allocated
> as zeroed memory in __sdt_alloc().
> 
> This patch has been tested with
> BUG_ON(!cpumask_empty(sched_group_cpus(sg))); and BUG_ON(sg->sgp->power);
> in build_sched_groups() on ARM TC2 and INTEL i5 M520 platform including
> CPU hotplug scenarios.
> 
> Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> ---
>  kernel/sched/core.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9cae286824bb..6bc51aebbf1b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5807,8 +5807,6 @@ build_sched_groups(struct sched_domain *sd, int cpu)
>  			continue;
>  
>  		group = get_group(i, sdd, &sg);
> -		cpumask_clear(sched_group_cpus(sg));
> -		sg->sgp->power = 0;
>  		cpumask_setall(sched_group_mask(sg));
>  
>  		for_each_cpu(j, span) {
> 

I think this one slipped through the cracks. Could you have a look?

Thanks,

-- Dietmar

