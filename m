Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbbASVcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:32:39 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:58126 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbbASVch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:32:37 -0500
Date: Mon, 19 Jan 2015 22:30:28 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: arnd@arndb.de, olof@lixom.net, linux@arm.linux.org.uk,
        thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: Marvell: Remove init cpus function
Message-ID: <20150119213028.GB2938@lunn.ch>
References: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 05:52:59PM +0100, Daniel Lezcano wrote:
> With the next patches, the init cpus function will be changed to be factored
> out.
> 
> The function 'armada_xp_smp_init_cpus' does nothing more than a sanity check
> after the DT has been parsed. Even if this code is valid, it does not give a
> real benefit as the DT should be correctly filled.
> 
> Remove this callback.

Hi Daniel

What is your plan for getting these merged? Do you want me to take the
mvebu patch? Or are you thinking of sending the complete series to the
arm-soc maintainers?

Thanks
	Andrew

> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  arch/arm/mach-mvebu/platsmp.c | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
> index 58cc8c1..3e93422 100644
> --- a/arch/arm/mach-mvebu/platsmp.c
> +++ b/arch/arm/mach-mvebu/platsmp.c
> @@ -30,8 +30,6 @@
>  #include "pmsu.h"
>  #include "coherency.h"
>  
> -#define ARMADA_XP_MAX_CPUS 4
> -
>  #define AXP_BOOTROM_BASE 0xfff00000
>  #define AXP_BOOTROM_SIZE 0x100000
>  
> @@ -114,14 +112,6 @@ static void armada_xp_secondary_init(unsigned int cpu)
>  	mvebu_v7_pmsu_idle_exit();
>  }
>  
> -static void __init armada_xp_smp_init_cpus(void)
> -{
> -	unsigned int ncores = num_possible_cpus();
> -
> -	if (ncores == 0 || ncores > ARMADA_XP_MAX_CPUS)
> -		panic("Invalid number of CPUs in DT\n");
> -}
> -
>  static void __init armada_xp_smp_prepare_cpus(unsigned int max_cpus)
>  {
>  	struct device_node *node;
> @@ -171,7 +161,6 @@ static int armada_xp_cpu_kill(unsigned int cpu)
>  #endif
>  
>  struct smp_operations armada_xp_smp_ops __initdata = {
> -	.smp_init_cpus		= armada_xp_smp_init_cpus,
>  	.smp_prepare_cpus	= armada_xp_smp_prepare_cpus,
>  	.smp_boot_secondary	= armada_xp_boot_secondary,
>  	.smp_secondary_init     = armada_xp_secondary_init,
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
