Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab3IYVlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:41:04 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57787 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3IYVlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:41:01 -0400
Message-ID: <5243586A.1090605@linaro.org>
Date: Wed, 25 Sep 2013 23:40:58 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/21] cpuidle: rearrange code in __cpuidle_driver_init()
References: <cover.1379779777.git.viresh.kumar@linaro.org> <72ec40529db737fe0eea6d14fc43fa332f9c5d59.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <72ec40529db737fe0eea6d14fc43fa332f9c5d59.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:20 AM, Viresh Kumar wrote:
> This is trivial patch that just reorders few statements in
> __cpuidle_driver_init() routine, so that we don't need both 'continue' and
> 'break' in the for loop. Functionally it shouldn't change anything.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpuidle/driver.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 8df66c8..6279e1c 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -172,12 +172,10 @@ static void __cpuidle_driver_init(struct cpuidle_driver *drv)
>  	 * order, because usually one of the deeper states have this flag set.
>  	 */
>  	for (i = drv->state_count - 1; i >= 0 ; i--) {
> -
> -		if (!(drv->states[i].flags & CPUIDLE_FLAG_TIMER_STOP))
> -			continue;
> -
> -		drv->bctimer = 1;
> -		break;
> +		if (drv->states[i].flags & CPUIDLE_FLAG_TIMER_STOP) {
> +			drv->bctimer = 1;
> +			break;
> +		}
>  	}
>  }

Well, I don't have a strong opinion on that, it is "Schtroumpf Vert et
Vert Schtroumpf" :)  [1]

  -- Daniel

[1] http://en.wikipedia.org/wiki/Schtroumpf_Vert_et_Vert_Schtroumpf


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

