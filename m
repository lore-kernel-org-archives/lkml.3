Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250AbaE2Odt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:33:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:48775 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121AbaE2Ods (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:33:48 -0400
Date: Thu, 29 May 2014 10:33:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Fabian Frederick <fabf@skynet.be>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 2/3] init/calibrate.c: use __func__ in logging
Message-ID: <20140529143346.GA32669@windriver.com>
References: <20140529101351.db8973890c873f2878efe4e3@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140529101351.db8973890c873f2878efe4e3@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH V2 2/3] init/calibrate.c: use __func__ in logging] On 29/05/2014 (Thu 10:13) Fabian Frederick wrote:

> -coalesce formats in all pr_info
> -use __func__ in pr_notice and pr_info (Calibrating delay -> calibrate_delay()).

What is the point here?  Does it shrink the object file some?

A commit log, even for trivial commits, should convey why we'd want to
make the change.  And personally, I'm on the fence on whether the
printk(KERN_FOO... ---> pr_foo(...  are worthwhile or are just a source
of commit churn/noise when executed on a per file level like this.

P.
--

> 
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  init/calibrate.c | 35 ++++++++++++++++++-----------------
>  1 file changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/init/calibrate.c b/init/calibrate.c
> index 0d747bb..fb9be44 100644
> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -95,8 +95,8 @@ static unsigned long calibrate_delay_direct(void)
>  		 * >= 12.5% apart, redo calibration.
>  		 */
>  		if (start >= post_end)
> -			pr_notice("calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
> -				  start, post_end);
> +			pr_notice("%s() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
> +				  __func__, start, post_end);
>  		if (start < post_end && pre_start != 0 && pre_end != 0 &&
>  		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
>  			good_timer_count++;
> @@ -132,13 +132,13 @@ static unsigned long calibrate_delay_direct(void)
>  		good_timer_count = 0;
>  		if ((measured_times[max] - estimate) <
>  				(estimate - measured_times[min])) {
> -			pr_notice("calibrate_delay_direct() dropping min bogoMips estimate %d = %lu\n",
> -				  min, measured_times[min]);
> +			pr_notice("%s() dropping min bogoMips estimate %d = %lu\n",
> +				  __func__, min, measured_times[min]);
>  			measured_times[min] = 0;
>  			min = max;
>  		} else {
> -			pr_notice("calibrate_delay_direct() dropping max bogoMips estimate %d = %lu\n",
> -				  max, measured_times[max]);
> +			pr_notice("%s() dropping max bogoMips estimate %d = %lu\n",
> +				  __func__, max, measured_times[max]);
>  			measured_times[max] = 0;
>  			max = min;
>  		}
> @@ -156,8 +156,9 @@ static unsigned long calibrate_delay_direct(void)
>  
>  	}
>  
> -	pr_notice("calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.\nProbably due to long platform "
> -		  "interrupts. Consider using \"lpj=\" boot option.\n");
> +	pr_notice("%s() failed to get a good estimate for loops_per_jiffy.\n"
> +		  "Probably due to long platform interrupts. Consider using \"lpj=\" boot option.\n",
> +		  __func__);
>  	return 0;
>  }
>  #else
> @@ -266,26 +267,26 @@ void calibrate_delay(void)
>  	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
>  		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
>  		if (!printed)
> -			pr_info("Calibrating delay loop (skipped) "
> -				"already calibrated this CPU");
> +			pr_info("%s() loop (skipped) already calibrated this CPU",
> +				__func__);
>  	} else if (preset_lpj) {
>  		lpj = preset_lpj;
>  		if (!printed)
> -			pr_info("Calibrating delay loop (skipped) "
> -				"preset value.. ");
> +			pr_info("%s() loop (skipped) preset value.. ",
> +				__func__);
>  	} else if ((!printed) && lpj_fine) {
>  		lpj = lpj_fine;
> -		pr_info("Calibrating delay loop (skipped), "
> -			"value calculated using timer frequency.. ");
> +		pr_info("%s() loop (skipped), value calculated using timer frequency.. ",
> +			__func__);
>  	} else if ((lpj = calibrate_delay_is_known())) {
>  		;
>  	} else if ((lpj = calibrate_delay_direct()) != 0) {
>  		if (!printed)
> -			pr_info("Calibrating delay using timer "
> -				"specific routine.. ");
> +			pr_info("%s() using timer specific routine.. ",
> +				__func__);
>  	} else {
>  		if (!printed)
> -			pr_info("Calibrating delay loop... ");
> +			pr_info("%s() loop... ", __func__);
>  		lpj = calibrate_delay_converge();
>  	}
>  	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
> -- 
> 1.9.1
> 
