Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaDHL4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:56:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62690 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756350AbaDHL4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:56:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        egtvedt@samfundet.no, lxoliva@fsfla.org
Subject: Re: [PATCH] cpufreq: at32ap: don't declare local variable as static
Date: Tue, 08 Apr 2014 14:12:45 +0200
Message-ID: <43656665.UbWgIxWcka@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <e71944f195507806ad06d0fe60615486dd2c1757.1396536599.git.viresh.kumar@linaro.org>
References: <e71944f195507806ad06d0fe60615486dd2c1757.1396536599.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 03, 2014 08:20:36 PM Viresh Kumar wrote:
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

Queued up for the next pull request, thanks!

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
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
