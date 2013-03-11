Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3CKPdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:33:49 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:35404 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3CKPdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:33:47 -0400
Message-ID: <513DF954.8020807@linaro.org>
Date: Mon, 11 Mar 2013 16:33:40 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: cpufreq@vger.kernel.org, rjw@sisk.pl, jason@lakedaemon.net, andrew@lunn.ch,
        len.brown@intel.com, rob.lee@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kirkwood: fix coccicheck warnings
References: <1363014842-11659-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1363014842-11659-1-git-send-email-silviupopescu1990@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 04:14 PM, Silviu-Mihai Popescu wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---

Sounds good.

Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>


>  drivers/cpufreq/kirkwood-cpufreq.c |    8 +++-----
>  drivers/cpuidle/cpuidle-kirkwood.c |    6 +++---
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
> index 0e83e3c..6052476 100644
> --- a/drivers/cpufreq/kirkwood-cpufreq.c
> +++ b/drivers/cpufreq/kirkwood-cpufreq.c
> @@ -175,11 +175,9 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "Cannot get memory resource\n");
>  		return -ENODEV;
>  	}
> -	priv.base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!priv.base) {
> -		dev_err(&pdev->dev, "Cannot ioremap\n");
> -		return -EADDRNOTAVAIL;
> -	}
> +	priv.base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv.base))
> +		return PTR_ERR(priv.base);
>  
>  	np = of_find_node_by_path("/cpus/cpu@0");
>  	if (!np)
> diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
> index 670aa1e..53aad73 100644
> --- a/drivers/cpuidle/cpuidle-kirkwood.c
> +++ b/drivers/cpuidle/cpuidle-kirkwood.c
> @@ -66,9 +66,9 @@ static int kirkwood_cpuidle_probe(struct platform_device *pdev)
>  	if (res == NULL)
>  		return -EINVAL;
>  
> -	ddr_operation_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!ddr_operation_base)
> -		return -EADDRNOTAVAIL;
> +	ddr_operation_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(ddr_operation_base))
> +		return PTR_ERR(ddr_operation_base);
>  
>  	device = &per_cpu(kirkwood_cpuidle_device, smp_processor_id());
>  	device->state_count = KIRKWOOD_MAX_STATES;
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

