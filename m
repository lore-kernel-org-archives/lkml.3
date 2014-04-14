Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaDNQqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:46:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48271 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbaDNQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:46:49 -0400
Date: Mon, 14 Apr 2014 17:46:35 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chanho Min <chanho.min@lge.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64:init: Move of_clk_init to time_init
Message-ID: <20140414164635.GD12916@arm.com>
References: <1397461133-12143-1-git-send-email-chanho.min@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397461133-12143-1-git-send-email-chanho.min@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 08:38:53AM +0100, Chanho Min wrote:
> Clock providers should be initialized before clocksource_of_init.
> If not, Clock source initialization can be fail to get the clock.
> 
> Signed-off-by: Chanho Min <chanho.min@lge.com>

Acked-by: Will Deacon <will.deacon@arm.com>

Will

> ---
>  arch/arm64/kernel/setup.c |    1 -
>  arch/arm64/kernel/time.c  |    3 ++-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 720853f..93e7df89 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -393,7 +393,6 @@ void __init setup_arch(char **cmdline_p)
>  
>  static int __init arm64_device_init(void)
>  {
> -	of_clk_init(NULL);
>  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>  	return 0;
>  }
> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> index 29c39d5..8799242 100644
> --- a/arch/arm64/kernel/time.c
> +++ b/arch/arm64/kernel/time.c
> @@ -33,6 +33,7 @@
>  #include <linux/irq.h>
>  #include <linux/delay.h>
>  #include <linux/clocksource.h>
> +#include <linux/clk-provider.h>
>  
>  #include <clocksource/arm_arch_timer.h>
>  
> @@ -64,7 +65,7 @@ EXPORT_SYMBOL(profile_pc);
>  void __init time_init(void)
>  {
>  	u32 arch_timer_rate;
> -
> +	of_clk_init(NULL);
>  	clocksource_of_init();
>  
>  	arch_timer_rate = arch_timer_get_rate();
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
