Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbaJVMxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:53:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39603 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933049AbaJVMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:53:09 -0400
Date: Wed, 22 Oct 2014 13:52:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2 36/47] arm64: psci: Register with kernel poweroff
 handler
Message-ID: <20141022125230.GI22642@leverpostej>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-37-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413864783-3271-37-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 05:12:52AM +0100, Guenter Roeck wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

My Juno board powers down correctly with this applied, so:

Tested-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> ---
> - Use define to specify poweroff handler priority
> 
>  arch/arm64/kernel/psci.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
> index 866c1c8..150ac1c 100644
> --- a/arch/arm64/kernel/psci.c
> +++ b/arch/arm64/kernel/psci.c
> @@ -359,7 +359,8 @@ static int __init psci_0_2_init(struct device_node *np)
>  
>  	arm_pm_restart = psci_sys_reset;
>  
> -	pm_power_off = psci_sys_poweroff;
> +	register_power_off_handler_simple(psci_sys_poweroff,
> +					  POWEROFF_PRIORITY_DEFAULT);
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
