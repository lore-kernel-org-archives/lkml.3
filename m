Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaBZBzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:55:04 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:34731 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaBZBzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:55:01 -0500
Message-ID: <530D4964.7060301@linaro.org>
Date: Wed, 26 Feb 2014 09:54:44 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, james.hogan@imgtec.com, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: Re: [PATCH 02/11] sched: remove rq->cpu_load[load_idx] array
References: <1393293054-11378-1-git-send-email-alex.shi@linaro.org> <1393293054-11378-3-git-send-email-alex.shi@linaro.org> <20140225162252.GA13532@linux.vnet.ibm.com>
In-Reply-To: <20140225162252.GA13532@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 12:22 AM, Srikar Dronamraju wrote:
>>  
>> -/**
>> - * get_sd_load_idx - Obtain the load index for a given sched domain.
>> - * @sd: The sched_domain whose load_idx is to be obtained.
>> - * @idle: The idle status of the CPU for whose sd load_idx is obtained.
>> - *
>> - * Return: The load index.
>> - */
>> -static inline int get_sd_load_idx(struct sched_domain *sd,
>> -					enum cpu_idle_type idle)
>> -{
>> -	int load_idx;
>> -
>> -	switch (idle) {
>> -	case CPU_NOT_IDLE:
>> -		load_idx = sd->busy_idx;
>> -		break;
>> -
>> -	case CPU_NEWLY_IDLE:
>> -		load_idx = sd->newidle_idx;
>> -		break;
>> -	default:
>> -		load_idx = sd->idle_idx;
>> -		break;
>> -	}
>> -
>> -	return load_idx;
>> -}
>> -
> 
> Since the last caller to get_sd_load_idx(), does it make sense to remove
> the function definition for get_sd_load_idx() in the previous patch itself?

yes. it's reasonable.
> 
> Or
> 
>> @@ -5903,13 +5868,11 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>>  	struct sched_domain *child = env->sd->child;
>>  	struct sched_group *sg = env->sd->groups;
>>  	struct sg_lb_stats tmp_sgs;
>> -	int load_idx, prefer_sibling = 0;
>> +	int prefer_sibling = 0;
>>  
>>  	if (child && child->flags & SD_PREFER_SIBLING)
>>  		prefer_sibling = 1;
>>  
>> -	load_idx = 0;
>> -
>>  	do {
>>  		struct sg_lb_stats *sgs = &tmp_sgs;
>>  		int local_group;
> 
> 
> The single line change in the previous patch gets removed here so why
> not club them.

Uh, the first patch want to just show the load_idx connection in current
logical.

Yes, we can club them, but this connection will be flooded in code.



-- 
Thanks
    Alex
