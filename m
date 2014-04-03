Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaDCOwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:52:21 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:60808 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaDCOwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:52:17 -0400
Date: Thu, 3 Apr 2014 16:52:13 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lxoliva@fsfla.org
Subject: Re: [PATCH] cpufreq: at32ap: don't declare local variable as static
Message-ID: <20140403145212.GA3581@samfundet.no>
References: <e71944f195507806ad06d0fe60615486dd2c1757.1396536599.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e71944f195507806ad06d0fe60615486dd2c1757.1396536599.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Thu 03 Apr 2014 20:20:36 +0530 or thereabout, Viresh Kumar wrote:
> Earlier commit:
> 	commit 652ed95d5fa6074b3c4ea245deb0691f1acb6656
> 	Author: Viresh Kumar <viresh.kumar@linaro.org>
> 	Date:   Thu Jan 9 20:38:43 2014 +0530
> 
> 	    cpufreq: introduce cpufreq_generic_get() routine
> 
> did some changes to driver and by mistake made cpuclk as a 'static' local
> variable, which wasn't actually required. Fix it.
> 
> Reported-by: Alexandre Oliva <lxoliva@fsfla.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  drivers/cpufreq/at32ap-cpufreq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
> index a1c79f5..7b612c8 100644
> --- a/drivers/cpufreq/at32ap-cpufreq.c
> +++ b/drivers/cpufreq/at32ap-cpufreq.c
> @@ -52,7 +52,7 @@ static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
>  static int at32_cpufreq_driver_init(struct cpufreq_policy *policy)
>  {
>  	unsigned int frequency, rate, min_freq;
> -	static struct clk *cpuclk;
> +	struct clk *cpuclk;
>  	int retval, steps, i;
>  
>  	if (policy->cpu != 0)
-- 
Hans-Christian Egtvedt
