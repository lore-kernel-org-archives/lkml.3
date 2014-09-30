Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaI3T7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:59:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60518 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750996AbaI3T7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:59:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tianyu.lan@intel.com, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "3.15+" <stable@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: update 'cpufreq_suspended' after stopping governors
Date: Tue, 30 Sep 2014 22:19:14 +0200
Message-ID: <4306677.HsSlidkNXd@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <999a633cbd722157ab80611b98c26107ddc7bd9c.1412049692.git.viresh.kumar@linaro.org>
References: <999a633cbd722157ab80611b98c26107ddc7bd9c.1412049692.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 30, 2014 09:33:17 AM Viresh Kumar wrote:
> Commit 8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for intel_pstate")
> introduced a bug where the governors wouldn't be stopped anymore for
> ->target{_index}() drivers during suspend. This happens because
> 'cpufreq_suspended' is updated before stopping the governors during suspend and
> due to this __cpufreq_governor() would return early due to this check:
> 
> 	/* Don't start any governor operations if we are entering suspend */
> 	if (cpufreq_suspended)
> 		return 0;
> 
> This patch tries to fix this bug.
> 
> Fixes: 8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for intel_pstate")
> Cc: 3.15+ <stable@vger.kernel.org> # 3.15+
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up for 3.17, thanks!

> ---
>  drivers/cpufreq/cpufreq.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 6e93e7f..61190f6 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1658,10 +1658,8 @@ void cpufreq_suspend(void)
>  	if (!cpufreq_driver)
>  		return;
>  
> -	cpufreq_suspended = true;
> -
>  	if (!has_target())
> -		return;
> +		goto suspend;
>  
>  	pr_debug("%s: Suspending Governors\n", __func__);
>  
> @@ -1674,6 +1672,9 @@ void cpufreq_suspend(void)
>  			pr_err("%s: Failed to suspend driver: %p\n", __func__,
>  				policy);
>  	}
> +
> +suspend:
> +	cpufreq_suspended = true;
>  }
>  
>  /**
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
