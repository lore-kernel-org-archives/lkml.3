Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3KGOr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:47:56 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55906 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3KGOrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:47:53 -0500
X-AuditID: cbfec7f5-b7ef66d00000795a-cc-527ba817faa8
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH 1/3 v8] thermal: samsung: add intclr_fall_shift bit in
 exynos_tmu_register struct
Date: Thu, 07 Nov 2013 15:47:45 +0100
Message-id: <1458475.5nSWLtVcXi@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <1383803562-31752-1-git-send-email-ch.naveen@samsung.com>
References: <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
 <1383803562-31752-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xK7riK6qDDL7e5rRouBpisXHGelaL
	u88PM1q8PKRpMf/IOVaLNft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYHHg8
	ds66y+6xeM9LJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGwY83mQu6xSo+rPvM
	1sD4R7CLkZNDQsBEon33AkYIW0ziwr31bF2MXBxCAksZJTo/9rFCOF1MEtOOXmUCqWITUJP4
	3PCIDcQWAeo+/uoMO0gRs8BSJon5yxYxgySEBdIlzvRfA7NZBFQl7r1cBraCV0BTYv7uJ2CD
	+AXUJd5tewpmiwq4SUz/cRConoODE8g++bMaYnEDo8SWdweZIXoFJX5MvscCYjMLyEvs2z+V
	FcLWkli/8zjTBEbBWUjKZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkHj5
	uoNx6TGrQ4wCHIxKPLwzaqqChFgTy4orcw8xSnAwK4nwHllYHSTEm5JYWZValB9fVJqTWnyI
	kYmDU6qBUSyufG/Pr7SyNcJ6a4/dnPD3EHOIEreL75V0BX+VDQYt8QK+d8skhcy7/uq9D9ig
	f3wHm98iXUuG18pO7a1PHLxlNyRyPGa1m9Z6NW42u9PSqZcepFgrLpJ/KGrjHK37IcorM9NK
	JvfXj38OxV/PVt5/P8d9qd7rKdlrkmZdC1ENW2zjtqpMiaU4I9FQi7moOBEAicwTR3UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Thursday 07 of November 2013 11:22:42 Naveen Krishna Chatradhi wrote:
> On Exynos5250, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT registers and at an offset of
> 12 in INTCLEAR register.
> 
> On Exynos5420, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT and INTCLEAR registers.
> 
> On Exynos5440,
> the FALL_IRQEN bits are at an offset of 4
> and the RISE_IRQEN bits are at an offset of 0
> 
> This patch introduces a new bit field intclr_fall_shift to handle the
> offset for exyns5250 and exynos5440
> Also removes the unused macros EXYNOS_TMU_FALL_INT_SHIFT and
> EXYNOS5440_TMU_FALL_INT_SHIFT, inten_fall_shift field

>From what I can see in this patch, the field intclr_fall_shift is not
really introduced, but rather inten_fall_shift is renamed to it. Please
match patch description with what the patch actually does.

I believe this patch is also touches code and data related to Exynos 4x12
SoCs, but the description only covers Exynos 5 SoCs.

In addition, if this patch does not introduce any functional changes,
but only refactors some code, the description should say so.

Also, please see my comment below.

> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v1:
> Changes since v2:
> Changes since v3:
>   None
> Changes since v4:
>  Correct the CLEAR_FALL_INT_SHIFT for Exynos5250/Exynos5440
> Changes since v5:
>  Modify the commit message
> Changes since v6:
>  - Use EXYNOS_TMU_CLEAR_FALL_INT_SHIFT instead of EXYNOS5250_TMU_CLEAR_FALL_INT_SHIFT
>  as the same is being used for Exynos4412
> Changes since v7:
>  - also removes the unused macros EXYNOS_TMU_FALL_INT_SHIFT and
>  EXYNOS5440_TMU_FALL_INT_SHIFT, inten_fall_shift field
> 
>  
>  drivers/thermal/samsung/exynos_tmu.c      |    2 +-
>  drivers/thermal/samsung/exynos_tmu.h      |    4 ++--
>  drivers/thermal/samsung/exynos_tmu_data.c |    4 ++--
>  drivers/thermal/samsung/exynos_tmu_data.h |    4 ++--
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 32f38b9..b2202fa 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -265,7 +265,7 @@ skip_calib_data:
>  				data->base + reg->threshold_th1);
>  
>  		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
> -			(reg->inten_fall_mask << reg->inten_fall_shift),
> +			(reg->inten_fall_mask << reg->intclr_fall_shift),

Shouldn't also the mask values be called intclr_*_mask? They seem to
be used only with tmu_intclear register. Same goes for inten_fall_shift,

Best regards,
Tomasz

