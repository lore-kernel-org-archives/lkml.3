Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3IYV1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:27:48 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:61785 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3IYV1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:27:46 -0400
Message-ID: <5243554F.8000909@linaro.org>
Date: Wed, 25 Sep 2013 23:27:43 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/21] cpuidle: make __cpuidle_get_cpu_driver() inline
References: <cover.1379779777.git.viresh.kumar@linaro.org> <0868fef3eca7cc04dc879da73f06e29e322c695b.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <0868fef3eca7cc04dc879da73f06e29e322c695b.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:20 AM, Viresh Kumar wrote:
> __cpuidle_get_cpu_driver() is a single line function and so deserves to be
> marked inline.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>  drivers/cpuidle/driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index ced1df6..25455e8 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -29,7 +29,7 @@ static DEFINE_PER_CPU(struct cpuidle_driver *, cpuidle_drivers);
>   * Returns a pointer to struct cpuidle_driver or NULL if no driver has been
>   * registered for @cpu.
>   */
> -static struct cpuidle_driver *__cpuidle_get_cpu_driver(int cpu)
> +static inline struct cpuidle_driver *__cpuidle_get_cpu_driver(int cpu)
>  {
>  	return per_cpu(cpuidle_drivers, cpu);
>  }
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

