Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3C0Wqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:46:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3C0Wqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:46:46 -0400
Date: Wed, 27 Mar 2013 23:46:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: use the exact frequency for
 clk_set_rate()
In-Reply-To: <Pine.LNX.4.64.1302251820431.3030@axis700.grange>
Message-ID: <Pine.LNX.4.64.1303272345260.9558@axis700.grange>
References: <Pine.LNX.4.64.1302251820431.3030@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:wy4fuG6wuzCTQNobPHkhpQ9B0E8bosh2HWLNrK2jABB
 NMkl4j+P15qERVhOV0bQ6iztbkIvKf3dLW6+7fGO4WXtxUjxfE
 ww//Gj3c9r+HAYuO5is73KKNVbdKW5fHGFvnWTnB1SjKyXRRHX
 07WHaUsskhiDz9pZ69WFGSzqE3RVIXlWiTkN2K8GO8bfkM6+a6
 tADlwyEmQy0IaQV/GmidSib6meklszuyrcPjxs46lXTE7wODaO
 G9CCBV5tdrmVYYiZpPsliznKqMgDX8JWVkqXgXyomlYK7hIXUK
 8Fg0IOgxeTmwtk3y42MXws3r0cKaoqsqByjiur45b78HpkwefW
 qZBmCP//rwtDK58T9TwDsPkY7vRdgdMZixbMATjoI+64FpoNh5
 QHfZI2yx4jQoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn

On Mon, 25 Feb 2013, Guennadi Liakhovetski wrote:

> clk_set_rate() isn't supposed to accept approximate frequencies, instead
> a supported frequency should be obtained from clk_round_rate() and then
> used to set the clock.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Can I have your ack for this one, please?

Thanks
Guennadi

> ---
> 
> Applies on top of my previous patch to fix unsigned freq_Hz "cpufreq: fix 
> sign check of an unsigned variable in cpufreq-cpu0"
> 
>  drivers/cpufreq/cpufreq-cpu0.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index e7bad3c..6ce9b51 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -45,7 +45,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>  	struct cpufreq_freqs freqs;
>  	struct opp *opp;
>  	unsigned long volt = 0, volt_old = 0, tol = 0;
> -	long freq_Hz;
> +	long freq_Hz, freq_exact;
>  	unsigned int index, cpu;
>  	int ret;
>  
> @@ -60,6 +60,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>  	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
>  	if (freq_Hz < 0)
>  		freq_Hz = freq_table[index].frequency * 1000;
> +	freq_exact = freq_Hz;
>  	freqs.new = freq_Hz / 1000;
>  	freqs.old = clk_get_rate(cpu_clk) / 1000;
>  
> @@ -96,7 +97,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>  		}
>  	}
>  
> -	ret = clk_set_rate(cpu_clk, freqs.new * 1000);
> +	ret = clk_set_rate(cpu_clk, freq_exact);
>  	if (ret) {
>  		pr_err("failed to set clock rate: %d\n", ret);
>  		if (cpu_reg)
> -- 
> 1.7.2.5
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
