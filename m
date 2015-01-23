Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbbAWNPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:15:39 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61456 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbAWNPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:15:34 -0500
Message-ID: <54C24973.5080801@linaro.org>
Date: Fri, 23 Jan 2015 14:15:31 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: arnd@arndb.de, olof@lixom.net, linux@arm.linux.org.uk
CC: thomas.petazzoni@free-electrons.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: Marvell: Remove init cpus function
References: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 05:52 PM, Daniel Lezcano wrote:
> With the next patches, the init cpus function will be changed to be factored
> out.
>
> The function 'armada_xp_smp_init_cpus' does nothing more than a sanity check
> after the DT has been parsed. Even if this code is valid, it does not give a
> real benefit as the DT should be correctly filled.
>
> Remove this callback.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Hi Arnd, Olof,

any comments on this patchset ?

Thanks
   -- Daniel

> ---
>   arch/arm/mach-mvebu/platsmp.c | 11 -----------
>   1 file changed, 11 deletions(-)
>
> diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
> index 58cc8c1..3e93422 100644
> --- a/arch/arm/mach-mvebu/platsmp.c
> +++ b/arch/arm/mach-mvebu/platsmp.c
> @@ -30,8 +30,6 @@
>   #include "pmsu.h"
>   #include "coherency.h"
>
> -#define ARMADA_XP_MAX_CPUS 4
> -
>   #define AXP_BOOTROM_BASE 0xfff00000
>   #define AXP_BOOTROM_SIZE 0x100000
>
> @@ -114,14 +112,6 @@ static void armada_xp_secondary_init(unsigned int cpu)
>   	mvebu_v7_pmsu_idle_exit();
>   }
>
> -static void __init armada_xp_smp_init_cpus(void)
> -{
> -	unsigned int ncores = num_possible_cpus();
> -
> -	if (ncores == 0 || ncores > ARMADA_XP_MAX_CPUS)
> -		panic("Invalid number of CPUs in DT\n");
> -}
> -
>   static void __init armada_xp_smp_prepare_cpus(unsigned int max_cpus)
>   {
>   	struct device_node *node;
> @@ -171,7 +161,6 @@ static int armada_xp_cpu_kill(unsigned int cpu)
>   #endif
>
>   struct smp_operations armada_xp_smp_ops __initdata = {
> -	.smp_init_cpus		= armada_xp_smp_init_cpus,
>   	.smp_prepare_cpus	= armada_xp_smp_prepare_cpus,
>   	.smp_boot_secondary	= armada_xp_boot_secondary,
>   	.smp_secondary_init     = armada_xp_secondary_init,
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

