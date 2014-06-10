Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaFJNxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:53:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56381 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaFJNw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:52:58 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-03-53970db7793d
Message-id: <53970DA9.1060904@samsung.com>
Date: Tue, 10 Jun 2014 15:52:41 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, arnd@arndb.de,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 2/6] ARM: EXYNOS: Remove i2c sys configuration related
 code
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
 <1399706419-13976-3-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399706419-13976-3-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7rbeacHG0z5r27xd9IxdoveBVfZ
	LDY9vsZqcXnXHDaLGef3MVncvsxrsWjrF3YHdo+W5h42j9+/JjF6bF5S79G3ZRWjx+dNcgGs
	UVw2Kak5mWWpRfp2CVwZL9YJFtznqTi/op+pgXEmVxcjJ4eEgInEvT2HmCFsMYkL99azdTFy
	cQgJLGWU2H9+AZTzmVFiwaslTCBVvAJaEm3XLgElODhYBFQlWvt9QcJsAmoSnxsesYHY/EAl
	a5qus4CUiApESDy+IATRKSjxY/I9FpCRIgJTGCUu9ixjBEkwC/hLnLmyA+wIYYEQiVtb3rGD
	2EICuxklzm9UBZnDKeApsXdeDkS5jsT+1mlsELa8xOY1b5knMArOQrJiFpKyWUjKFjAyr2IU
	TS1NLihOSs810itOzC0uzUvXS87P3cQICfqvOxiXHrM6xCjAwajEw2vgPy1YiDWxrLgy9xCj
	BAezkghv21+gEG9KYmVValF+fFFpTmrxIUYmDk6pBsZrHNfnRH5/ZmBdxpXA6yzpdvPsfjMZ
	xedrXd8ITn4Yd2itYG78nA93pLee377tovvzZP4LYeX32Vw3fJD5elWg9Gv9m3P5cg33Od69
	b/+zTyD0VOm6d38mOHPr6yxgkqxS+LnyjufcrJ43vIwXjBj++Vxl+jQt4Zuy1IR2Z4Nax88y
	8fvWpD1WYinOSDTUYi4qTgQAqoX7eVgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 10.05.2014 09:20, Pankaj Dubey wrote:
> Since all these code has been moved into i2c driver, now we can
> safely remove them from machine files.
> 
> CC: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/exynos.c           |   38 +------------------------------
>  arch/arm/mach-exynos/include/mach/map.h |    3 ---
>  arch/arm/mach-exynos/pm.c               |   10 --------
>  arch/arm/mach-exynos/regs-sys.h         |   22 ------------------
>  4 files changed, 1 insertion(+), 72 deletions(-)
>  delete mode 100644 arch/arm/mach-exynos/regs-sys.h
> 
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index 59eb1f1..09063ee 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -29,11 +29,11 @@
>  #include <asm/memory.h>
>  
>  #include <plat/cpu.h>
> +#include <mach/map.h>
>  
>  #include "common.h"
>  #include "mfc.h"
>  #include "regs-pmu.h"
> -#include "regs-sys.h"
>  
>  #define L2_AUX_VAL 0x7C470001
>  #define L2_AUX_MASK 0xC200ffff
> @@ -42,11 +42,6 @@ static struct regmap *exynos_pmu_regmap;
>  
>  static struct map_desc exynos4_iodesc[] __initdata = {
>  	{
> -		.virtual	= (unsigned long)S3C_VA_SYS,
> -		.pfn		= __phys_to_pfn(EXYNOS4_PA_SYSCON),
> -		.length		= SZ_64K,
> -		.type		= MT_DEVICE,

Rest of this patch doesn't touch anything related to Exynos4, but I
boot-tested removing this on Exynos4412-based Trats2 board and it works, so

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
