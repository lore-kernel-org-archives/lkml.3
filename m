Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3KZFDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 00:03:13 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42669 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3KZFDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 00:03:09 -0500
Message-ID: <52942B87.1040203@linaro.org>
Date: Tue, 26 Nov 2013 10:33:03 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paul Walmsley <pwalmsley@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: Mike Turquette <mturquette@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: clk_round_rate() can return a
 zero upon error
References: <alpine.DEB.2.02.1311251559460.23090@tamien>
In-Reply-To: <alpine.DEB.2.02.1311251559460.23090@tamien>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 November 2013 07:31 AM, Paul Walmsley wrote:
> 
> Treat both negative and zero return values from clk_round_rate()
> as errors.  This is needed since subsequent patches will convert
> clk_round_rate()'s return value to be an unsigned type, rather
> than a signed type, since some clock sources can generate rates
> higher than (2^31)-1 Hz.
> 
> Eventually, when calling clk_round_rate(), only a return value of
> zero will be considered a error.  All other values will be
> considered valid rates.  The comparison against values less than
> 0 is kept to preserve the correct behavior in the meantime.
> 
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Mike Turquette <mturquette@linaro.org>
> ---
> Applies on v3.13-rc1.  See also:
> 
> http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2
> 
>  drivers/cpufreq/cpufreq-cpu0.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index d4585ce2346c..0faf756f6197 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -44,7 +44,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
> unsigned int index)
>      int ret;
> 
>      freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
> -    if (freq_Hz < 0)
> +    if (freq_Hz <= 0)
>          freq_Hz = freq_table[index].frequency * 1000;
> 
>      freq_exact = freq_Hz;

So, we will see another patch where you will do: s/<=/== ??
I am wondering if there is any other way we can get this solved, i.e. in a
single patchset.

Otherwise, for both SPEAr and cpu0 patches:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
