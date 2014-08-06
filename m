Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaHFORk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:17:40 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33736 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaHFORj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:17:39 -0400
Message-ID: <53E23900.3040007@linaro.org>
Date: Wed, 06 Aug 2014 16:17:36 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Nicolas Pitre <nico@linaro.org>
CC: Mike Galbraith <mgalbraith@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] cpuidle: menu: Use ktime_to_us instead of reinventing
 the wheel
References: <1407331161-4642-1-git-send-email-mgorman@suse.de> <1407331161-4642-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1407331161-4642-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 03:19 PM, Mel Gorman wrote:
> The ktime_to_us implementation is slightly better than the one implemented
> in menu.c. Use it
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/cpuidle/governors/menu.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 801b2ee..373278a 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -297,7 +297,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>   	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
>   	int i;
>   	unsigned int interactivity_req;
> -	struct timespec t;
>
>   	if (data->needs_update) {
>   		menu_update(drv, dev);
> @@ -311,9 +310,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>   		return 0;
>
>   	/* determine the expected residency time, round up */
> -	t = ktime_to_timespec(tick_nohz_get_sleep_length());
> -	data->next_timer_us =
> -		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
> +	data->next_timer_us = ktime_to_us(tick_nohz_get_sleep_length());
>
>
>   	data->bucket = which_bucket(data->next_timer_us);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

