Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab3LIMs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:48:28 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16874 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab3LIMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:48:25 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-12-52a5bc17e3db
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH 2/4 v10] thermal: samsung: change base_common to more
 meaningful base_second
Date: Mon, 09 Dec 2013 13:48:13 +0100
Message-id: <2699941.H5LXh5yo1R@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1384866291-16034-1-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
 <1384866291-16034-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xa7rie5YGGVxcIWvRcDXEYuOM9awW
	d58fZrR4eUjTYv6Rc6wWa/b/ZLLoXXCVzeLyrjlsFp97jzBazDi/j8li0bb/zBZPHvaxOfB4
	7Jx1l91j8Z6XTB59W1Yxehy/sZ3J4/MmuQDWKC6blNSczLLUIn27BK6ME/9uMBdsFKj4sH4z
	ewNjF28XIyeHhICJxIwt59ggbDGJC/fWA9lcHEICSxklfj2cwQrhdDFJXLu3mxWkik1ATeJz
	wyOwDhGg7uOvzrCDFDELLGWSmL9sETNIQlggSaLl42GwIhYBVYmGz9/BmnkFNCVOPZrBBGLz
	C6hLvNv2FMwWFXCTeLFvCzuIzQlk90+dww6xuYFRYuW7Y0wQzYISPybfYwGxmQXkJfbtn8oK
	YWtJrN95nGkCo+AsJGWzkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIxHzd
	wbj0mNUhRgEORiUe3gDmpUFCrIllxZW5hxglOJiVRHjFdgGFeFMSK6tSi/Lji0pzUosPMTJx
	cEo1MG5O2JQiP198XfEuBs06v/sPXN/9OZV6SMnxjJb6ohOvIx4wVZk6aH88ayS9TvXcynlG
	vdldgVO2ijxo+n7+uyETp+hR40nys+/r9l0tXf+jPeX2n2j9nQ9mPz/tl2dqf1bEzjLoSnBn
	3De9jhUsUy5s8rv56XXLka9WWow8PY+37NVftfyNb7sSS3FGoqEWc1FxIgBUhnXMdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Tuesday 19 of November 2013 18:34:51 Naveen Krishna Chatradhi wrote:
> On Exynos5440 and Exynos5420 there are registers common
> across the TMU channels.
> 
> To support that, we introduced a ADDRESS_MULTIPLE flag in the
> driver and the 2nd set of register base and size are provided
> in the "reg" property of the node.
> 
> As per Amit's suggestion, this patch changes the base_common
> to base_second and SHARED_MEMORY to ADDRESS_MULTIPLE.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> Changes since v9:
> Just respinning
> 
> Changes since v8:
>  None
>  .../devicetree/bindings/thermal/exynos-thermal.txt       |    4 ++--
>  drivers/thermal/samsung/exynos_tmu.c                     |   14 +++++++-------
>  drivers/thermal/samsung/exynos_tmu.h                     |    4 ++--
>  drivers/thermal/samsung/exynos_tmu_data.c                |    2 +-
>  4 files changed, 12 insertions(+), 12 deletions(-)

Please see my comments inline.

> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 284f530..116cca0 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -11,8 +11,8 @@
>  - reg : Address range of the thermal registers. For soc's which has multiple
>  	instances of TMU and some registers are shared across all TMU's like
>  	interrupt related then 2 set of register has to supplied. First set
> -	belongs	to each instance of TMU and second set belongs to common TMU
> -	registers.
> +	belongs	to each instance of TMU and second set belongs to second set
> +	of common TMU registers.

Just a wording issue, I think: If this is "second set of common TMU
registers", then where is the first set of common TMU registers?

Otherwise the patch looks fine.

Best regards,
Tomasz

