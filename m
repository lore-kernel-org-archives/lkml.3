Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3JCHg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:36:59 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41602 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3JCHg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:36:57 -0400
Message-ID: <524D1D9D.9080908@linux.vnet.ibm.com>
Date: Thu, 03 Oct 2013 13:02:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 09/11] cpufreq: rewrite cpufreq_driver->flags using
 shift operator
References: <cover.1380703248.git.viresh.kumar@linaro.org> <7b34bf61846bed19e4a7e8ee18a55e717c570fef.1380703248.git.viresh.kumar@linaro.org>
In-Reply-To: <7b34bf61846bed19e4a7e8ee18a55e717c570fef.1380703248.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100307-3864-0000-0000-00000A5C85B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 02:13 PM, Viresh Kumar wrote:
> Currently cpufreq_driver's flags are defined directly using 0x1, 0x2, 0x4, 0x8,
> etc.. As the list grows it doesn't stays much readable..
> 
> Lets use bitwise shift operator << to generate these numbers for respective
> positions.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  include/linux/cpufreq.h | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index a72bac2..9321059 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -225,13 +225,14 @@ struct cpufreq_driver {
>  };
> 
>  /* flags */
> -#define CPUFREQ_STICKY		0x01	/* the driver isn't removed even if
> -					 * all ->init() calls failed */
> -#define CPUFREQ_CONST_LOOPS	0x02	/* loops_per_jiffy or other kernel
> -					 * "constants" aren't affected by
> -					 * frequency transitions */
> -#define CPUFREQ_PM_NO_WARN	0x04	/* don't warn on suspend/resume speed
> -					 * mismatches */
> +#define CPUFREQ_STICKY		(1 << 0)	/* driver isn't removed even if
> +						   all ->init() calls failed */
> +#define CPUFREQ_CONST_LOOPS	(1 << 1)	/* loops_per_jiffy or other
> +						   kernel "constants" aren't
> +						   affected by frequency
> +						   transitions */
> +#define CPUFREQ_PM_NO_WARN	(1 << 2)	/* don't warn on suspend/resume
> +						   speed mismatches */
> 
>  int cpufreq_register_driver(struct cpufreq_driver *driver_data);
>  int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
> 


