Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbaDHJNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:13:02 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50508 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaDHJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:13:00 -0400
Message-ID: <5343BDAC.70603@linaro.org>
Date: Tue, 08 Apr 2014 11:13:16 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: rjw@rjwysocki.net, lenb@kernel.org
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpuidle: sysfs: Export target residency information
References: <1395055050-27729-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1395055050-27729-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 12:17 PM, Daniel Lezcano wrote:
>  From userspace, there is no way to know the target residency for each idle
> state. If we want to write tools to measure the accuracy of the idle state
> selection from the governor, we need this info.
>
> As the exit latency is exported through sysfs, exporting the target residency
> in the same place makes sense.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---

Hi Rafael,

are you willing to take this patch ?

Thanks
   -- Daniel

>   drivers/cpuidle/sysfs.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index e918b6d..efe2f17 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -293,6 +293,7 @@ static ssize_t show_state_##_name(struct cpuidle_state *state, \
>   }
>
>   define_show_state_function(exit_latency)
> +define_show_state_function(target_residency)
>   define_show_state_function(power_usage)
>   define_show_state_ull_function(usage)
>   define_show_state_ull_function(time)
> @@ -304,6 +305,7 @@ define_store_state_ull_function(disable)
>   define_one_state_ro(name, show_state_name);
>   define_one_state_ro(desc, show_state_desc);
>   define_one_state_ro(latency, show_state_exit_latency);
> +define_one_state_ro(residency, show_state_target_residency);
>   define_one_state_ro(power, show_state_power_usage);
>   define_one_state_ro(usage, show_state_usage);
>   define_one_state_ro(time, show_state_time);
> @@ -313,6 +315,7 @@ static struct attribute *cpuidle_state_default_attrs[] = {
>   	&attr_name.attr,
>   	&attr_desc.attr,
>   	&attr_latency.attr,
> +	&attr_residency.attr,
>   	&attr_power.attr,
>   	&attr_usage.attr,
>   	&attr_time.attr,
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

