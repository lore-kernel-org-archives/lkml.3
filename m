Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3IYVwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:52:10 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55481 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3IYVwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:52:09 -0400
Message-ID: <52435B05.9030201@linaro.org>
Date: Wed, 25 Sep 2013 23:52:05 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/21] cpuidle: use cpuidle_disabled() instead of "off"
References: <cover.1379779777.git.viresh.kumar@linaro.org> <19979ce88726285c72dd6fe3d7b370d53669443c.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <19979ce88726285c72dd6fe3d7b370d53669443c.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> We have a routine for getting value of "off", better call that instead of using
> "off" directly.

We are in the fast path, I am not sure invoking a function here is
better than using directly the static variable.

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpuidle/cpuidle.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 8c91bad..aec9029 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -119,7 +119,7 @@ int cpuidle_idle_call(void)
>  	struct cpuidle_driver *drv;
>  	int next_state, entered_state;
>  
> -	if (off)
> +	if (cpuidle_disabled())
>  		return -ENODEV;
>  
>  	if (!initialized)
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

