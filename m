Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3EXWBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:01:51 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49365 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3EXWBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:01:49 -0400
Message-ID: <519FE349.7050208@samsung.com>
Date: Sat, 25 May 2013 07:01:45 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: EXYNOS: add PM dependency to PM_GENERIC_DOMAINS
 for Exynos4210
References: <001a01ce5041$1b9ddd30$52d99790$@samsung.com>
In-Reply-To: <001a01ce5041$1b9ddd30$52d99790$@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/13 10:19, Jingoo Han wrote:
> PM_GENERIC_DOMAINS needs PM dependency.
>
> Fixed build warning as below:
>
> warning: (PLAT_S3C64XX&&  CPU_EXYNOS4210) selects PM_GENERIC_DOMAINS which has unmet direct dependencies (PM)

If so, PLAT_S3C64XX should be fixed together.

diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index 2057853..c04c4ee 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -8,7 +8,7 @@ config PLAT_S3C64XX
  	bool
  	depends on ARCH_S3C64XX
  	default y
-	select PM_GENERIC_DOMAINS
+	select PM_GENERIC_DOMAINS if PM
  	select SAMSUNG_WAKEMASK
  	help
  	  Base platform code for any Samsung S3C64XX device

> warning: (PLAT_S3C64XX&&  CPU_EXYNOS4210) selects PM_GENERIC_DOMAINS which has unmet direct dependencies (PM)
> arch/arm/kernel/return_address.c:63:2: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]
> drivers/base/power/domain.c: In function '__pm_genpd_add_device':
> drivers/base/power/domain.c:1422:2: error: implicit declaration of function 'genpd_acquire_lock'
> [-Werror=implicit-function-declaration]
> drivers/base/power/domain.c:1466:2: error: implicit declaration of function 'genpd_release_lock'
> [-Werror=implicit-function-declaration]
> drivers/base/power/domain.c: In function 'pm_genpd_add_subdomain':
> drivers/base/power/domain.c:1649:3: error: implicit declaration of function 'genpd_sd_counter_inc'
> [-Werror=implicit-function-declaration]
> drivers/base/power/domain.c: In function 'pm_genpd_remove_subdomain':
> drivers/base/power/domain.c:1721:4: error: implicit declaration of function 'genpd_sd_counter_dec'
> [-Werror=implicit-function-declaration]
> drivers/base/power/domain.c: In function 'pm_genpd_attach_cpuidle':
> drivers/base/power/domain.c:1887:2: error: implicit declaration of function 'genpd_recalc_cpu_exit_latency'
> [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
>
> Signed-off-by: Jingoo Han<jg1.han@samsung.com>
> ---
>   arch/arm/mach-exynos/Kconfig |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index d19edff..1f7ddb2 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -34,7 +34,7 @@ config CPU_EXYNOS4210
>   	default y
>   	depends on ARCH_EXYNOS4
>   	select ARM_CPU_SUSPEND if PM
> -	select PM_GENERIC_DOMAINS
> +	select PM_GENERIC_DOMAINS if PM
>   	select S5P_PM if PM
>   	select S5P_SLEEP if PM
>   	select SAMSUNG_DMADEV
