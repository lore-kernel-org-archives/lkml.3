Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3IYVxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:53:00 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34217 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3IYVw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:52:58 -0400
Message-ID: <52435B37.1040304@linaro.org>
Date: Wed, 25 Sep 2013 23:52:55 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/21] cpuidle: merge two if() statements for checking
 error cases
References: <cover.1379779777.git.viresh.kumar@linaro.org> <63116bb9adaf7336a019ce087fbe17c4ace81cea.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <63116bb9adaf7336a019ce087fbe17c4ace81cea.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> Both return same error message and so better write them in a single line.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

modulo the comment on patch 08/21:

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>  drivers/cpuidle/cpuidle.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index aec9029..b8c63cb 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -119,10 +119,7 @@ int cpuidle_idle_call(void)
>  	struct cpuidle_driver *drv;
>  	int next_state, entered_state;
>  
> -	if (cpuidle_disabled())
> -		return -ENODEV;
> -
> -	if (!initialized)
> +	if (cpuidle_disabled() || !initialized)
>  		return -ENODEV;
>  
>  	/* check if the device is ready */
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

