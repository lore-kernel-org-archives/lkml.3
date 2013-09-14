Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab3INV6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 17:58:20 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:50186 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab3INV6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 17:58:19 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Sep 2013 17:58:19 EDT
Date: Sun, 15 Sep 2013 00:48:27 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH 136/228] cpufreq: loongson2: use cpufreq_generic_init()
 routine
Message-ID: <20130914214827.GA30568@blackmetal.musicnaut.iki.fi>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
 <63ebf29a1bcc7b3a26f8bfc76a5677d2880f8534.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63ebf29a1bcc7b3a26f8bfc76a5677d2880f8534.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 06:31:22PM +0530, Viresh Kumar wrote:
> Use generic cpufreq_generic_init() routine instead of replicating the same code
> here. This driver wasn't setting transition_latency and so is getting set to 0
> by default. Lets mark it explicitly by calling the generic routine with
> transition_latency as 0.
> 
> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: John Crispin <blogic@openwrt.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>

BTW, this is not ARM but MIPS board, so adding linux-mips to CC.

A.

> ---
>  drivers/cpufreq/loongson2_cpufreq.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
> index dd4f3e4..2c8ec8e 100644
> --- a/drivers/cpufreq/loongson2_cpufreq.c
> +++ b/drivers/cpufreq/loongson2_cpufreq.c
> @@ -131,8 +131,7 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  		return ret;
>  	}
>  
> -	return cpufreq_table_validate_and_show(policy,
> -					    &loongson2_clockmod_table[0]);
> +	return cpufreq_generic_init(policy, &loongson2_clockmod_table[0], 0);
>  }
>  
>  static int loongson2_cpufreq_exit(struct cpufreq_policy *policy)
> -- 
> 1.7.12.rc2.18.g61b472e
> 
