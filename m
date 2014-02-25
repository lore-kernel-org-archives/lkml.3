Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaBYK4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:56:42 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33480 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBYK4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:56:41 -0500
Message-ID: <530C76E7.8090607@linaro.org>
Date: Tue, 25 Feb 2014 11:56:39 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>, linux-pm@vger.kernel.org,
        rjw@rjwysocki.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Cpuidle: poll state can measure residency
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org> <1393223377-5744-8-git-send-email-tuukka.tikkanen@linaro.org>
In-Reply-To: <1393223377-5744-8-git-send-email-tuukka.tikkanen@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 07:29 AM, Tuukka Tikkanen wrote:
> For some platforms, a poll state is inserted in the cpuidle driver states.
> The flags for the state do not indicate that timekeeping is not affected.
> As the state does not do anything apart from calling cpu_relax(), the
> times returned by ktime_get should remain valid. Add the missing flag.

Yes, but it is done with the interrupt enabled, so the interrupt handler 
+ softirq handler times will be accounted in the residency time.

I am not sure adding this flag is good.

> Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
> ---
>   drivers/cpuidle/driver.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 06dbe7c..136d6a2 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -209,7 +209,7 @@ static void poll_idle_init(struct cpuidle_driver *drv)
>   	state->exit_latency = 0;
>   	state->target_residency = 0;
>   	state->power_usage = -1;
> -	state->flags = 0;
> +	state->flags = CPUIDLE_FLAG_TIME_VALID;
>   	state->enter = poll_idle;
>   	state->disabled = false;
>   }
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

