Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbaE2WUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:20:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40903 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaE2WUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:20:21 -0400
Message-ID: <5387B287.5050007@ti.com>
Date: Thu, 29 May 2014 17:19:51 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>
CC: <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arvind.chauhan@arm.com>,
        <inderpal.s@samsung.com>, <chander.kashyap@linaro.org>, <pavel@ucw.cz>,
        <len.brown@intel.com>, <sudeep.holla@arm.com>
Subject: Re: [PATCH V4 1/8] opp: of_init_opp_table(): return -ENOSYS when
 feature isn't implemented
References: <cover.1401191054.git.viresh.kumar@linaro.org> <231be85cd01bcdc00a0a7936cd9ba57ccba52749.1401191054.git.viresh.kumar@linaro.org>
In-Reply-To: <231be85cd01bcdc00a0a7936cd9ba57ccba52749.1401191054.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minor (Rafael usually fixes it up, but still):
$subject: PM / OPP:

On 05/27/2014 06:50 AM, Viresh Kumar wrote:
> When none of CONFIG_PM_OPP or CONFIG_OF is enabled we use the dummy
> implementation of of_init_opp_table() routine, which returns -EINVAL currently.
> -EINVAL can confuse the callers a bit as it can have other meanings for the
> actual implementation of this routine.
> 
> It is more appropriate to return -ENOSYS instead to avoid confusion at caller.
> 
> Suggested-and-reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

otherwise,

Acked-by: Nishanth Menon <nm@ti.com>

> ---
>  include/linux/pm_opp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
> index 0330217..6668150 100644
> --- a/include/linux/pm_opp.h
> +++ b/include/linux/pm_opp.h
> @@ -112,7 +112,7 @@ int of_init_opp_table(struct device *dev);
>  #else
>  static inline int of_init_opp_table(struct device *dev)
>  {
> -	return -EINVAL;
> +	return -ENOSYS;
>  }
>  #endif
>  
> 


-- 
Regards,
Nishanth Menon
