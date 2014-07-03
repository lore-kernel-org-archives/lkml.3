Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaGCAnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:43:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46115 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaGCAnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:43:07 -0400
Message-ID: <53B4A718.3050702@codeaurora.org>
Date: Wed, 02 Jul 2014 17:43:04 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, shawn.guo@linaro.org, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com
Subject: Re: [PATCH 09/14] cpufreq: cpu0: Move per-cluster initialization
 code to ->init()
References: <cover.1404231535.git.viresh.kumar@linaro.org> <b26946cc4573904cd1ef0212ad053a983b547c23.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <b26946cc4573904cd1ef0212ad053a983b547c23.1404231535.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/14 09:32, Viresh Kumar wrote:
> +static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
> +{
> +	struct cpufreq_frequency_table *freq_table;
> +	struct thermal_cooling_device *cdev;

This..

> +	struct device_node *np;
> +	struct private_data *priv;
> +	
[...]
> ing them.
> @@ -223,28 +242,92 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  				"running cpufreq without cooling device: %ld\n",
>  				PTR_ERR(cdev));
>  	}
> -
>  	of_node_put(np);
> +
> +	priv->cdev = cdev;

Causes a build warning:

drivers/cpufreq/cpufreq-generic.c:313:13: warning: 'cdev' may be used
uninitialized in this function [-Wmaybe-uninitialized]

So I guess we should initialize it to NULL?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

