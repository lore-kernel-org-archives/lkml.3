Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab3HHNmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:42:31 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17433 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3HHNm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:42:29 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-b8-5203a0430ce4
From: Tomasz Figa <t.figa@samsung.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 01/16] iommu/exynos: do not include removed header
Date: Thu, 08 Aug 2013 15:42:24 +0200
Message-id: <21505674.fdNgPGp76O@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <002501ce941a$e3d87f40$ab897dc0$@samsung.com>
References: <002501ce941a$e3d87f40$ab897dc0$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e/4VV3nBcxBBt/nClvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktTv7pZbRoud7L5MDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mro+djEXLCSp+LCZtMGxkauLkZODgkBE4lpLW1MELaY
	xIV769m6GLk4hASWMkosOvkAyulikvjRNpcZpIpNQE3ic8MjNhBbREBD4vOV9awgNrPADxaJ
	T9v4QGxhAU+Jh5MbWUBsFgFViSczb4DV8ApoSVycdBZsG7+AusS7bU+BbA4OUQE3iQkf80HC
	nAJWEifn7QRbJSRgKdH75xMTRKugxI/J91ggVslL7Ns/FWqtlsT6nceZJjAKzkJSNgtJ2Swk
	ZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihMTblx2Mi49ZHWIU4GBU4uHtCGAKEmJN
	LCuuzD3EKMHBrCTC+yKLOUiINyWxsiq1KD++qDQntfgQIxMHp1QDI1dBvoXDgr8RTiHX4hL0
	+i8YfJv5LVfv1lV9A8/MCZzLP1/lnaC2Xtm3Q/TkQemV+doPFlr7npuqzHPl0O7b+YvaO3T7
	lzcXvuk+adRkH/xt3jO5G4s25ZyomjfzpG8GQ/bKzW0rM6Zs2zY3lW1rdzS/eanSbN3Np9fy
	H13cNKW0MDRnx7e47UosxRmJhlrMRcWJAPSbcBmVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On Thursday 08 of August 2013 18:37:25 Cho KyongHo wrote:
> This commit remove <mach/sysmmu.h> which is removed.

I would prefer a more meaningful commit message, something among following 
lines:

8<---
Commit 25e9d28d92 (ARM: EXYNOS: remove system mmu initialization from 
exynos tree) removed arch/arm/mach-exynos/mach/sysmmu.h header without 
removing remaining use of it from exynos-iommu driver, thus causing a 
compilation error.

This patch fixes the error by removing respective include line from exynos-
iommu.c.
--->8

Also a sentence explaining why linux/kernel.h header must be included would 
be nice.

> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>

Please note that as far as I'm aware of, tags should be made using western 
name writing convention, i.e. starting with first name.

Best regards,
Tomasz

> ---
>  drivers/iommu/exynos-iommu.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 3f32d64..233f382 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -12,6 +12,7 @@
>  #define DEBUG
>  #endif
> 
> +#include <linux/kernel.h>
>  #include <linux/io.h>
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
> @@ -29,8 +30,6 @@
>  #include <asm/cacheflush.h>
>  #include <asm/pgtable.h>
> 
> -#include <mach/sysmmu.h>
> -
>  /* We does not consider super section mapping (16MB) */
>  #define SECT_ORDER 20
>  #define LPAGE_ORDER 16
