Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaGNJww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:52:52 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:41316 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaGNJwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:52:43 -0400
Message-ID: <53C3A855.5040002@gmail.com>
Date: Mon, 14 Jul 2014 11:52:21 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Daniel Drake <drake@endlessm.com>
Subject: Re: [PATCH v2 4/6] ARM: SAMSUNG: Restore Samsung PM Debug functionality
References: <1403618235-19353-5-git-send-email-t.figa@samsung.com> <1403696634-12779-1-git-send-email-t.figa@samsung.com>
In-Reply-To: <1403696634-12779-1-git-send-email-t.figa@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 25.06.2014 13:43, Tomasz Figa wrote:
> Due to recently merged patches and previous merge conflicts, the Samsung
> PM Debug functionality no longer can be enabled. This patch fixes
> incorrect dependency of SAMSUNG_PM_DEBUG on an integer symbol and adds
> missing header inclusion.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/plat-samsung/Kconfig    | 5 +++--
>  arch/arm/plat-samsung/pm-debug.c | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index 301b892..ad9515f 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -413,8 +413,9 @@ config S5P_DEV_MFC
>  comment "Power management"
>  
>  config SAMSUNG_PM_DEBUG
> -	bool "S3C2410 PM Suspend debug"
> -	depends on PM && DEBUG_KERNEL && DEBUG_S3C_UART
> +	bool "Samsung PM Suspend debug"
> +	depends on PM && DEBUG_KERNEL
> +	depends on DEBUG_EXYNOS_UART || DEBUG_S3C24XX_UART || DEBUG_S3C2410_UART
>  	help
>  	  Say Y here if you want verbose debugging from the PM Suspend and
>  	  Resume code. See <file:Documentation/arm/Samsung-S3C24XX/Suspend.txt>
> diff --git a/arch/arm/plat-samsung/pm-debug.c b/arch/arm/plat-samsung/pm-debug.c
> index 8f19f66..3960960 100644
> --- a/arch/arm/plat-samsung/pm-debug.c
> +++ b/arch/arm/plat-samsung/pm-debug.c
> @@ -14,6 +14,7 @@
>   */
>  
>  #include <linux/serial_core.h>
> +#include <linux/serial_s3c.h>
>  #include <linux/io.h>
>  
>  #include <asm/mach/map.h>
> 

Please consider this patch for next fixes pull request.

Best regards,
Tomasz
