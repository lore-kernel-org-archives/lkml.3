Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3IYWFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:05:19 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:63277 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3IYWFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:05:17 -0400
Message-ID: <52435E1A.9010108@linaro.org>
Date: Thu, 26 Sep 2013 00:05:14 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] cpuidle: use drv instead of cpuidle_driver in show_current_driver()
References: <cover.1379779777.git.viresh.kumar@linaro.org> <dee4978199c13f45547f50a5f709c9b0d57f669b.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <dee4978199c13f45547f50a5f709c9b0d57f669b.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> Instances of "struct cpuidle_driver *" are consistently named as "drv" in
> cpuidle core. Its broken only at one place: show_current_driver().
> 
> Fix it for consistency.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>  drivers/cpuidle/sysfs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index a022393..e918b6d 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -52,12 +52,12 @@ static ssize_t show_current_driver(struct device *dev,
>  				   char *buf)
>  {
>  	ssize_t ret;
> -	struct cpuidle_driver *cpuidle_driver;
> +	struct cpuidle_driver *drv;
>  
>  	spin_lock(&cpuidle_driver_lock);
> -	cpuidle_driver = cpuidle_get_driver();
> -	if (cpuidle_driver)
> -		ret = sprintf(buf, "%s\n", cpuidle_driver->name);
> +	drv = cpuidle_get_driver();
> +	if (drv)
> +		ret = sprintf(buf, "%s\n", drv->name);
>  	else
>  		ret = sprintf(buf, "none\n");
>  	spin_unlock(&cpuidle_driver_lock);
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

