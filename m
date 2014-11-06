Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaKFRXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:23:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59943 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438AbaKFRXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:23:09 -0500
Date: Thu, 6 Nov 2014 17:22:23 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v5 36/48] arm64: psci: Register with kernel power-off
 handler
Message-ID: <20141106172222.GA15384@leverpostej>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
 <1415292213-28652-37-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415292213-28652-37-git-send-email-linux@roeck-us.net>
Thread-Topic: [PATCH v5 36/48] arm64: psci: Register with kernel power-off
 handler
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:43:20PM +0000, Guenter Roeck wrote:
> Register with kernel power-off handler instead of setting pm_power_off
> directly.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

I just fetched your current poweroff-handler branch and gave it a spin
on Juno. It looks like this hasn't broken since the last time I tried
it. :)

Tested-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> ---
> v5:
> - Rebase to v3.18-rc3
> v4:
> - No change
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> v2:
> - Use define to specify poweroff handler priority
> 
>  arch/arm64/kernel/psci.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
> index 866c1c8..5cab066 100644
> --- a/arch/arm64/kernel/psci.c
> +++ b/arch/arm64/kernel/psci.c
> @@ -359,7 +359,8 @@ static int __init psci_0_2_init(struct device_node *np)
>  
>  	arm_pm_restart = psci_sys_reset;
>  
> -	pm_power_off = psci_sys_poweroff;
> +	register_power_off_handler_simple(psci_sys_poweroff,
> +					  POWER_OFF_PRIORITY_DEFAULT);
>  
>  out_put_node:
>  	of_node_put(np);
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
