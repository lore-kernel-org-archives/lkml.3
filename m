Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3CJP4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:56:55 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47930 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3CJP4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:56:52 -0400
Message-ID: <513CAD9B.908@gmail.com>
Date: Sun, 10 Mar 2013 16:58:19 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, Steve.Bannister@arm.com, linux@arm.linux.org.uk,
        linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        devicetree-discuss@lists.ozlabs.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        robin.randhawa@arm.com, linux-arm-kernel@lists.infradead.org,
        mark.hambleton@broadcom.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH V2] cpufreq: ARM big LITTLE: Add generic cpufreq driver
 and its DT glue
References: <6cba8f153cfd4b0d3075a34a6dfe287bdec2eb06.1362676407.git.viresh.kumar@linaro.org>
In-Reply-To: <6cba8f153cfd4b0d3075a34a6dfe287bdec2eb06.1362676407.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 03/07/2013 06:14 PM, Viresh Kumar wrote:
> big LITTLE is ARM's new Architecture focussing power/performance needs of modern
> world. More information about big LITTLE can be found here:
> 
> http://www.arm.com/products/processors/technologies/biglittleprocessing.php
> http://lwn.net/Articles/481055/
> 
> In order to keep cpufreq support for all big LITTLE platforms simple/generic,
> this patch tries to add a generic cpufreq driver layer for all big LITTLE
> platforms.
> 
> The driver is divided into two parts:
> - Core driver: Generic and shared across all big LITTLE SoC's
> - Glue drivers: Per platform drivers providing ops to the core driver
> 
> This patch adds in a generic glue driver which would extract information from
> Device Tree.
> 
> Future SoC's can either reuse the DT glue or write their own depending on the
> need.
> 
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
[...]
> +void bL_cpufreq_unregister(struct cpufreq_arm_bL_ops *ops)
> +{
> +	if (arm_bL_ops != ops) {
> +		pr_info("%s: Registered with: %s, can't unregister, exiting\n",
> +				__func__, arm_bL_ops->name);
> +	}

The code is not doing what the info message says.

> +
> +	cpufreq_unregister_driver(&bL_cpufreq_driver);
> +	pr_info("%s: Un-registered platform driver: %s\n", __func__,
> +			arm_bL_ops->name);
> +	arm_bL_ops = NULL;
> +}
> +EXPORT_SYMBOL_GPL(bL_cpufreq_unregister);

--
Francesco
