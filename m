Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab3DYSOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 14:14:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:56152 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201Ab3DYSOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 14:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,552,1363158000"; 
   d="scan'208";a="232494479"
Message-ID: <5179726E.9020003@intel.com>
Date: Thu, 25 Apr 2013 20:14:06 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 14/21] cpufreq: pxa2xx: initialize variables
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-15-git-send-email-arnd@arndb.de>
In-Reply-To: <1366910944-3033663-15-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/2013 7:28 PM, Arnd Bergmann wrote:
> gcc-3.8 correctly found that the variables set by find_freq_tables()
> are not initialized if this function is called on something other
> than a pxa2xx or pxa3xx:
>
> pxa2xx-cpufreq.c: In function 'pxa_verify_policy':
> pxa2xx-cpufreq.c:272:6: warning: 'pxa_freqs_table' may be used uninitialized in this function [-Wmaybe-uninitialized]
> pxa2xx-cpufreq.c: In function 'pxa_set_target':
> pxa2xx-cpufreq.c:345:23: warning: 'pxa_freq_settings' may be used uninitialized in this function [-Wmaybe-uninitialized]
>
> Rather than adding a bogus initialization that would let us
> get a little further before crashing, add an explicit BUG().
> We know that this code is designed to run on only these cpus,
> so this will fix the build warning and give a more helpful
> diagnostic if the code ever changes to run on other machines.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

OK, applied.

Can you please CC future cpufreq changes to linux-pm@vger.kernel.org?  
That'd make the handling of them much easier.

Thanks,
Rafael


> ---
>   drivers/cpufreq/pxa2xx-cpufreq.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
> index fe4c55b..9e5bc8e 100644
> --- a/drivers/cpufreq/pxa2xx-cpufreq.c
> +++ b/drivers/cpufreq/pxa2xx-cpufreq.c
> @@ -221,10 +221,11 @@ static void find_freq_tables(struct cpufreq_frequency_table **freq_table,
>   			*pxa_freqs = pxa255_turbo_freqs;
>   			*freq_table = pxa255_turbo_freq_table;
>   		}
> -	}
> -	if (cpu_is_pxa27x()) {
> +	} else if (cpu_is_pxa27x()) {
>   		*pxa_freqs = pxa27x_freqs;
>   		*freq_table = pxa27x_freq_table;
> +	} else {
> +		BUG();
>   	}
>   }
>   

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

