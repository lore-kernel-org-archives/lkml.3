Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaEVS35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:29:57 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:58875 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaEVS3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:29:55 -0400
Date: Thu, 22 May 2014 10:52:09 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, inderpal.s@samsung.com, nm@ti.com,
        chander.kashyap@linaro.org, pavel@ucw.cz, len.brown@intel.com,
        sudeep.holla@arm.com
Subject: Re: [PATCH V3 1/8] cpufreq: cpufreq-cpu0: remove dependency on
 thermal
Message-ID: <20140522145209.GA5246@developer>
References: <cover.1400736536.git.viresh.kumar@linaro.org>
 <c73c825beda0207867bd29e40fece217cbf15925.1400736536.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c73c825beda0207867bd29e40fece217cbf15925.1400736536.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Viresh,

On Thu, May 22, 2014 at 11:07:25AM +0530, Viresh Kumar wrote:
> cpufreq-cpu0 uses thermal framework to register a cooling device, but doesn't
> depend on it as there are dummy calls provided by thermal layer when
> CONFIG_THERMAL=n. So, we don't really need to mention thermal as a dependency
> for cpufreq-cpu0 in Kconfig.


I see your point.
> 
> Remove it.

However, on CPUs that needs thermal managment, it makes sense to have
such dependency, from functional perspective. Mainly because scaling
frequency and voltage up would be allowed only when thermal management
is enabled.

> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index 1fbe11f..4310997 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -185,7 +185,7 @@ config CPU_FREQ_GOV_CONSERVATIVE
>  
>  config GENERIC_CPUFREQ_CPU0
>  	tristate "Generic CPU0 cpufreq driver"
> -	depends on HAVE_CLK && REGULATOR && OF && THERMAL && CPU_THERMAL
> +	depends on HAVE_CLK && REGULATOR && OF
>  	select PM_OPP
>  	help
>  	  This adds a generic cpufreq driver for CPU0 frequency management.
> -- 
> 2.0.0.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
