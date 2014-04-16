Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161472AbaDPOgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:36:06 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53491 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161439AbaDPOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:35:07 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-3d-534e951918b8
Message-id: <534E9517.2040409@samsung.com>
Date: Wed, 16 Apr 2014 16:35:03 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 6/8] ARM: EXYNOS: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
 <1397527192-21988-7-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1397527192-21988-7-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e/4NV3JqX7BBrevclv8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tLBb9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5Lf7e
	+cdmcer6Z6DQ5JdsFsdmLGG02LtzMqODoMeaeWsYPVqae9g8fv+axOjxd9ULZo871/aweWxe
	Uu9x5UQTq0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBl7Pj0n6mgnbuie8p/xgbGxxxdjJwc
	EgImEvd+/mSFsMUkLtxbz9bFyMUhJLCUUWLOyX9QzmdGiSMrrjODVPEKaEncapvA2MXIwcEi
	oCpxZkYYSJhNQE3ic8MjNhCbH6hkTdN1FhBbVCBC4l7jYVaIVkGJH5PvgcVFBNwkvn36wwwy
	n1mgiVniwqfXYPOFBZIl9u94BbW4kVHiRcMfsGWcQB3LGi1BapgFrCVWTtrGCGHLS2xe85Z5
	AqPgLCQ7ZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkCj8uoNx6TGrQ4wC
	HIxKPLwzcnyDhVgTy4orcw8xSnAwK4nwXmjzCxbiTUmsrEotyo8vKs1JLT7EyMTBKdXA6Ct4
	+Ju+8+MzKieOTLwUft1s/cyJHhNjf/tM5dPhv2zwulZKdGkZm65t5IufhuV7TJ/GvlM5a37l
	Ps8F1R6pY3fT1GK0Wi+GLueJvuKc2ZT5ZEaFfGW/zvaAjekmF1aKOz075yy2z/zv4cPH1kdv
	mvCsb8Xk84Wth3f0OS6Z0WCtF/VbWY11vxJLcUaioRZzUXEiAPLRVzegAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 15.04.2014 03:59, Chanwoo Choi wrote:
> This patch decide proper lowpower mode of either a15 or a9 according to own ID
> from Main ID register.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   arch/arm/mach-exynos/hotplug.c | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index 5eead53..99e54e0 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -135,16 +135,22 @@ void __ref exynos_cpu_die(unsigned int cpu)
>   	int primary_part = 0;
>
>   	/*
> -	 * we're ready for shutdown now, so do it.
> -	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
> +	 * we're ready for shutdown now, so do it. Exynos4 is A9 based
> +	 * while Exynos5 is A15/Exynos3 is A7; check the CPU part
>   	 * number by reading the Main ID register and then perform the
>   	 * appropriate sequence for entering low power.

If changing this comment anyway, I'd suggest removing particular SoC 
series from it and also correct writing style. My suggestion is:

/*
  * Prepare the CPU for shutting down. The required sequence of
  * operations depends on core type. CPUID part number can be used to
  * determine the right way.
  */

Best regards,
Tomasz
