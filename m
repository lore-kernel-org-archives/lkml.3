Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaLHU4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:56:30 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37393 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaLHU42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:56:28 -0500
Message-ID: <54861078.3090606@gmail.com>
Date: Mon, 08 Dec 2014 21:56:24 +0100
From: Rasmus Wriedt Larsen <rasmuswriedtlarsen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: rmk+kernel@arm.linux.org.uk
CC: pdeschrijver@nvidia.com, joe@perches.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] init: calibrate: fix style issues
References: <1413048976.16385.37.camel@joe-AO725> <1413195155-8111-1-git-send-email-rasmuswriedtlarsen@gmail.com>
In-Reply-To: <1413195155-8111-1-git-send-email-rasmuswriedtlarsen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanted to bump this patch, as nothing has happened in a long time.

As this is my first linux patch, I was quite hoping to get it accepted :)

On 13/10/14 12:12, Rasmus Wriedt Larsen wrote:
> * fix multiple quoted string split across lines style issues
> * change printk(KERN_NOTICE to pr_notice
> * insert spaces after , in function call
> * change two line pr_notice msg to one line (credit: Joe Perches)
> 
> Signed-off-by: Rasmus Wriedt Larsen <rasmuswriedtlarsen@gmail.com>
> ---
>  init/calibrate.c | 35 ++++++++++++++---------------------
>  1 file changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/init/calibrate.c b/init/calibrate.c
> index ce635dc..d9c8810 100644
> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -15,7 +15,7 @@ unsigned long lpj_fine;
>  unsigned long preset_lpj;
>  static int __init lpj_setup(char *str)
>  {
> -	preset_lpj = simple_strtoul(str,NULL,0);
> +	preset_lpj = simple_strtoul(str, NULL, 0);
>  	return 1;
>  }
> 
> @@ -40,11 +40,13 @@ static unsigned long calibrate_delay_direct(void)
>  	unsigned long good_timer_sum = 0;
>  	unsigned long good_timer_count = 0;
>  	unsigned long measured_times[MAX_DIRECT_CALIBRATION_RETRIES];
> -	int max = -1; /* index of measured_times with max/min values or not set */
> +
> +	/* index of measured_times with max/min values or not set */
> +	int max = -1;
>  	int min = -1;
>  	int i;
> 
> -	if (read_current_timer(&pre_start) < 0 )
> +	if (read_current_timer(&pre_start) < 0)
>  		return 0;
> 
>  	/*
> @@ -95,9 +97,7 @@ static unsigned long calibrate_delay_direct(void)
>  		 * >= 12.5% apart, redo calibration.
>  		 */
>  		if (start >= post_end)
> -			printk(KERN_NOTICE "calibrate_delay_direct() ignoring "
> -					"timer_rate as we had a TSC wrap around"
> -					" start=%lu >=post_end=%lu\n",
> +			pr_notice("calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
>  				start, post_end);
>  		if (start < post_end && pre_start != 0 && pre_end != 0 &&
>  		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
> @@ -134,14 +134,12 @@ static unsigned long calibrate_delay_direct(void)
>  		good_timer_count = 0;
>  		if ((measured_times[max] - estimate) <
>  				(estimate - measured_times[min])) {
> -			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
> -					"min bogoMips estimate %d = %lu\n",
> +			pr_notice("calibrate_delay_direct() dropping min bogoMips estimate %d = %lu\n",
>  				min, measured_times[min]);
>  			measured_times[min] = 0;
>  			min = max;
>  		} else {
> -			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
> -					"max bogoMips estimate %d = %lu\n",
> +			pr_notice("calibrate_delay_direct() dropping max bogoMips estimate %d = %lu\n",
>  				max, measured_times[max]);
>  			measured_times[max] = 0;
>  			max = min;
> @@ -160,9 +158,8 @@ static unsigned long calibrate_delay_direct(void)
> 
>  	}
> 
> -	printk(KERN_NOTICE "calibrate_delay_direct() failed to get a good "
> -	       "estimate for loops_per_jiffy.\nProbably due to long platform "
> -		"interrupts. Consider using \"lpj=\" boot option.\n");
> +	pr_notice("%s: failed to reasonably estimate loops_per_jiffy (long platform interrupts?) - perhaps use boot option 'lpj='\n",
> +		  __func__);
>  	return 0;
>  }
>  #else
> @@ -280,23 +277,19 @@ void calibrate_delay(void)
>  	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
>  		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
>  		if (!printed)
> -			pr_info("Calibrating delay loop (skipped) "
> -				"already calibrated this CPU");
> +			pr_info("Calibrating delay loop (skipped) already calibrated this CPU");
>  	} else if (preset_lpj) {
>  		lpj = preset_lpj;
>  		if (!printed)
> -			pr_info("Calibrating delay loop (skipped) "
> -				"preset value.. ");
> +			pr_info("Calibrating delay loop (skipped) preset value.. ");
>  	} else if ((!printed) && lpj_fine) {
>  		lpj = lpj_fine;
> -		pr_info("Calibrating delay loop (skipped), "
> -			"value calculated using timer frequency.. ");
> +		pr_info("Calibrating delay loop (skipped), value calculated using timer frequency.. ");
>  	} else if ((lpj = calibrate_delay_is_known())) {
>  		;
>  	} else if ((lpj = calibrate_delay_direct()) != 0) {
>  		if (!printed)
> -			pr_info("Calibrating delay using timer "
> -				"specific routine.. ");
> +			pr_info("Calibrating delay using timer specific routine.. ");
>  	} else {
>  		if (!printed)
>  			pr_info("Calibrating delay loop... ");
> --
> 1.9.1
> 
