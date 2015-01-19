Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbbASRyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:54:00 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49655 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbbASRx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:53:57 -0500
Message-ID: <54BD44AE.20006@free-electrons.com>
Date: Mon, 19 Jan 2015 18:53:50 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: arnd@arndb.de, olof@lixom.net, linux@arm.linux.org.uk,
        thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: Marvell: Remove init cpus function
References: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 19/01/2015 17:52, Daniel Lezcano wrote:
> With the next patches, the init cpus function will be changed to be factored
> out.
> 
> The function 'armada_xp_smp_init_cpus' does nothing more than a sanity check
> after the DT has been parsed. Even if this code is valid, it does not give a
> real benefit as the DT should be correctly filled.
> 
> Remove this callback.

In the course of the factorization of the smp functions, this function
has been more and more reduced. As stated, the remaining part is not so
useful now, it makes sens to remove it now.

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


Thanks,

Gregory


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
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
