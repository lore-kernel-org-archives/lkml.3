Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553Ab3GSNvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:51:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42725 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759866Ab3GSNv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:51:29 -0400
Date: Fri, 19 Jul 2013 09:50:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Julien Grall <julien.grall@linaro.org>
Cc: stefano.stabellini@eu.citrix.com, ian.campbell@citrix.com,
        patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH v2] xen/arm: disable cpuidle and cpufreq when linux is
 running as dom0
Message-ID: <20130719135050.GA12144@localhost.localdomain>
References: <1374233220-13770-1-git-send-email-julien.grall@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374233220-13770-1-git-send-email-julien.grall@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 12:27:00PM +0100, Julien Grall wrote:
> When linux is running as dom0, Xen doesn't show the physical cpu but a
> virtual CPU.
> On some ARM SOC (for instance the exynos 5250), linux registers callbacks
> for cpuidle and cpufreq. When these callbacks are called, they will modify
> directly the physical cpu not the virtual one. It can impact the whole board
> instead of only dom0.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> ---
>     Changes in v2:
>         - Disable cpufreq
> ---
>  arch/arm/xen/enlighten.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 49839d8..af82792 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -24,6 +24,8 @@
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_address.h>
> +#include <linux/cpuidle.h>
> +#include <linux/cpufreq.h>
>  
>  #include <linux/mm.h>
>  
> @@ -292,6 +294,12 @@ static int __init xen_pm_init(void)
>  {
>  	pm_power_off = xen_power_off;
>  	arm_pm_restart = xen_restart;
> +	/*
> +	 * Making sure board specific code will not set up ops for
> +	 * cpu idle and cpu freq.
> +	 */
> +	disable_cpuidle();
> +	disable_cpufreq();
>  
>  	return 0;
>  }
> -- 
> 1.7.10.4
> 
