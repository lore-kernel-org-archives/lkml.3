Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab3CIDBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:01:15 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:50272 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724Ab3CIDBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:01:11 -0500
Message-ID: <513AA5F2.1000909@linaro.org>
Date: Sat, 09 Mar 2013 04:01:06 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: lenb@kernel.org, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] intel_idle: changing the continue to break in intel_idle_cpu_init()
References: <1362674529.31506.17.camel@cliu38-desktop-build>  <1362754926.31506.42.camel@cliu38-desktop-build> <1362755024.31506.44.camel@cliu38-desktop-build>
In-Reply-To: <1362755024.31506.44.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 04:03 PM, Chuansheng Liu wrote:
> 
> According to commit e022e7eb9, the .enter == NULL is the last one in
> state_tables[].
> 
> So just like intel_idle_cpuidle_driver_init(), in case of .enter == NULL,
> breaking the for(;;) loop directly.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---

Sounds good.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

>  drivers/idle/intel_idle.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 5d66750..17c9cf9 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -610,7 +610,7 @@ static int intel_idle_cpu_init(int cpu)
>  		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
>  
>  		if (cpuidle_state_table[cstate].enter == NULL)
> -			continue;
> +			break;
>  
>  		if (cstate + 1 > max_cstate) {
>  			printk(PREFIX "max_cstate %d reached\n", max_cstate);
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

