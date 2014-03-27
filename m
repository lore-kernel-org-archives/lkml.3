Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaC0KT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:19:56 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35454 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbaC0KTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:19:53 -0400
Message-ID: <5333FB31.7080602@linux.vnet.ibm.com>
Date: Thu, 27 Mar 2014 15:49:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
        preeti@linux.vnet.ibm.com
Subject: Re: [PATCH] cpufreq: don't print value of .driver_data from core
References: <2490cd0aaeaaeb88131c8089d491c485f08da5da.1395914766.git.viresh.kumar@linaro.org>
In-Reply-To: <2490cd0aaeaaeb88131c8089d491c485f08da5da.1395914766.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032710-3864-0000-0000-00000D303F2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 03:37 PM, Viresh Kumar wrote:
> CPUFreq core doesn't control value of .driver_data and this field is completely
> driver specific. This can contain any value and not only indexes. For most of
> the drivers, which aren't using this field, its value is zero. So, printing this
> from core doesn't make any sense. Don't print it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/freq_table.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
> index 8e54f97..f002272 100644
> --- a/drivers/cpufreq/freq_table.c
> +++ b/drivers/cpufreq/freq_table.c
> @@ -36,8 +36,7 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
>  		    && table[i].driver_data == CPUFREQ_BOOST_FREQ)
>  			continue;
> 
> -		pr_debug("table entry %u: %u kHz, %u driver_data\n",
> -					i, freq, table[i].driver_data);
> +		pr_debug("table entry %u: %u kHz\n", i, freq);
>  		if (freq < min_freq)
>  			min_freq = freq;
>  		if (freq > max_freq)
> @@ -175,8 +174,8 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
>  	} else
>  		*index = optimal.driver_data;
> 
> -	pr_debug("target is %u (%u kHz, %u)\n", *index, table[*index].frequency,
> -		table[*index].driver_data);
> +	pr_debug("target index is %u, freq is:%u kHz\n", *index,
> +		 table[*index].frequency);
> 
>  	return 0;
>  }
> 

