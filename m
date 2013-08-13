Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab3HMNLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:11:46 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41057 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529Ab3HMNLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:11:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/16] drivers/cpufreq/pxa3xx-cpufreq.c: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Tue, 13 Aug 2013 15:22:09 +0200
Message-ID: <2461013.EC2pHmIZ5g@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376239917-15594-13-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr> <1376239917-15594-13-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 11, 2013 06:51:53 PM Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
> arity of the called function.
> 
> The semantic match that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e,f;
> @@
> 
> f(...,
> - ARRAY_AND_SIZE(e)
> + e,ARRAY_SIZE(e)
>   ,...)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Queued up for 3.12.

Thanks,
Rafael


> ---
> Not compiled.
> 
>  drivers/cpufreq/pxa3xx-cpufreq.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
> index 9c92ef0..d26306f 100644
> --- a/drivers/cpufreq/pxa3xx-cpufreq.c
> +++ b/drivers/cpufreq/pxa3xx-cpufreq.c
> @@ -213,10 +213,12 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
>  	policy->cur = policy->min = policy->max;
>  
>  	if (cpu_is_pxa300() || cpu_is_pxa310())
> -		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa300_freqs));
> +		ret = setup_freqs_table(policy, pxa300_freqs,
> +					ARRAY_SIZE(pxa300_freqs));
>  
>  	if (cpu_is_pxa320())
> -		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa320_freqs));
> +		ret = setup_freqs_table(policy, pxa320_freqs,
> +					ARRAY_SIZE(pxa320_freqs));
>  
>  	if (ret) {
>  		pr_err("failed to setup frequency table\n");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
