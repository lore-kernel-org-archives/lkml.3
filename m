Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063AbaGRSxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:53:13 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62193 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaGRSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:53:10 -0400
Message-ID: <53C96D0B.2080201@samsung.com>
Date: Sat, 19 Jul 2014 03:52:59 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [RESPIN PATCH v6] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
References: <1405310323-3195-1-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1405310323-3195-1-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/14 12:58, Pankaj Dubey wrote:
> As exynos_cpuidle_init and exynos_cpufreq_init function have just one lines
> of code for registering platform devices. We can move these lines to
> exynos_dt_machine_init and delete exynos_cpuidle_init and exynos_cpufreq_init
> function. This will help in reducing lines of code in exynos.c, making it
> more cleaner.
>
> Suggested-by: Tomasz Figa<t.figa@samsung.com>
> Signed-off-by: Pankaj Dubey<pankaj.dubey@samsung.com>
> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
> ---
>
> This patch is part of exynos-cleanup series v6 [1]. Just respinning after
> resolving merge conflicts on latest kgene/for-next.
>
> [1]: https://lkml.org/lkml/2014/7/10/338
>
>
>   arch/arm/mach-exynos/exynos.c |   18 ++++--------------
>   1 file changed, 4 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index 2a43a17..99dc5aa 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -175,17 +175,6 @@ static struct platform_device exynos_cpuidle = {
>   	.id                = -1,
>   };
>
> -void __init exynos_cpuidle_init(void)
> -{
> -	if (soc_is_exynos4210() || soc_is_exynos5250())
> -		platform_device_register(&exynos_cpuidle);
> -}
> -
> -void __init exynos_cpufreq_init(void)
> -{
> -	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
> -}
> -
>   void __iomem *sysram_base_addr;
>   void __iomem *sysram_ns_base_addr;
>
> @@ -335,10 +324,11 @@ static void __init exynos_dt_machine_init(void)
>   	if (!IS_ENABLED(CONFIG_SMP))
>   		exynos_sysram_init();
>
> -	if (!of_machine_is_compatible("samsung,exynos5420"))
> -		exynos_cpuidle_init();
> +	if (of_machine_is_compatible("samsung,exynos4210") ||
> +			of_machine_is_compatible("samsung,exynos5250"))
> +		platform_device_register(&exynos_cpuidle);
>
> -	exynos_cpufreq_init();
> +	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
>
>   	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>   }

I've applied.

Thanks,
Kukjin
