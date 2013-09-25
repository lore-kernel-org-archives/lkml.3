Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3IYVto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:49:44 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:34423 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3IYVtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:49:43 -0400
Message-ID: <52435A74.3060808@linaro.org>
Date: Wed, 25 Sep 2013 23:49:40 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/21] cpuidle: rearrange __cpuidle_register_device()
 to keep minimal exit points
References: <cover.1379779777.git.viresh.kumar@linaro.org> <2dd257d9843954aaaf0cf30c7fb475daded018a5.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <2dd257d9843954aaaf0cf30c7fb475daded018a5.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:20 AM, Viresh Kumar wrote:
> This patch rearranges __cpuidle_register_device() a bit in order to reduce the
> number of exit points of this function.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpuidle/cpuidle.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 211e504..8c91bad 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -383,13 +383,12 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
>  	list_add(&dev->device_list, &cpuidle_detected_devices);
>  
>  	ret = cpuidle_coupled_register_device(dev);
> -	if (ret) {
> +	if (ret)
>  		__cpuidle_unregister_device(dev);
> -		return ret;
> -	}
> +	else
> +		dev->registered = 1;
>  
> -	dev->registered = 1;
> -	return 0;
> +	return ret;
>  }

There is no accounting for taste :)

I agree the patch concentrates more the return statement into a single
place which conforms better to the kernel coding style.

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

