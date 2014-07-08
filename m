Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaGHO2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:28:44 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27413 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaGHO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:28:43 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-42-53bc0019f708
Message-id: <53BBFFF9.5020306@samsung.com>
Date: Tue, 08 Jul 2014 16:28:09 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v6 2/4] ARM: EXYNOS: Refactored code for using PMU address
 via DT
References: <1404710376-16448-1-git-send-email-pankaj.dubey@samsung.com>
 <1404710376-16448-3-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1404710376-16448-3-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xy7qSDHuCDZo2SFgsm3SXzeL7ri/s
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBaLtgJVdCxjtLj5bDuTA7dHS3MPm8fm
	JfUefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlfF21XuWgiWcFec/vGVuYNzK3sXIySEhYCKx
	600zG4QtJnHh3nogm4tDSGApo8T8B12MEM5nRondT98ygVTxCmhJdOx7AtTNwcEioCpx63wl
	SJhNQE3ic8MjsEH8QCVrmq6zgJSICkRIPL4gBNEpKPFj8j0WkJEiAtMYJS5eus0O4jALLGGU
	2DPjFCNIlbBAuMSK7gtQV7QzSnyecBwswSngKXHnyFGws5kFdCT2t05jg7DlJTavecs8gVFw
	FpIts5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSGR83cG49JjVIUYBDkYl
	Hl6D87uDhVgTy4orcw8xSnAwK4nwfjkFFOJNSaysSi3Kjy8qzUktPsTIxMEp1cDIuWHvMU7l
	l4/ttNInfO572NB+deMNZZklnD8V4tLnzTBNutCm+u/94Z8b5pgffjPj5aUuqQRf6xe+1xa9
	26fbUWDacHc1d+fvR6/9LBuOJnNta25IlMxjdXgwYeXcvYeTFTyLdkhft1/xg2NZidD8j6bf
	rf8sj1BZsP6KnLmYZdJFu4Qcl19TlFiKMxINtZiLihMBZEd25moCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

Except one minor comment inline, looks good.

On 07.07.2014 07:19, Pankaj Dubey wrote:

[snip]

> diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
> index 9315ba9..8f6a111 100644
> --- a/arch/arm/mach-exynos/mcpm-exynos.c
> +++ b/arch/arm/mach-exynos/mcpm-exynos.c
> @@ -55,7 +55,7 @@
>  	"dsb\n\t" \
>  	"ldmfd	sp!, {fp, ip}" \
>  	: \
> -	: "Ir" (S5P_INFORM0) \
> +	: "Ir" (pmu_base_addr + S5P_INFORM0) \
>  	: "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", \
>  	  "r9", "r10", "lr", "memory")
>  
> @@ -337,7 +337,8 @@ static int __init exynos_mcpm_init(void)
>  	 * To increase the stability of KFC reset we need to program
>  	 * the PMU SPARE3 register
>  	 */
> -	__raw_writel(EXYNOS5420_SWRESET_KFC_SEL, S5P_PMU_SPARE3);
> +	__raw_writel(EXYNOS5420_SWRESET_KFC_SEL,
> +			pmu_base_addr + S5P_PMU_SPARE3);

Here's yet another place where pmu_raw_writel() helper could be used.
Maybe move them to a header, even common.h and then use whenever PMU is
accessed in arch code.

With this minor thing fixed, feel free to add

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
