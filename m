Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbaD3ICy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:02:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53956 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781AbaD3ICO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:02:14 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-82-5360ae052bc9
Message-id: <5360AE05.7020106@samsung.com>
Date: Wed, 30 Apr 2014 17:02:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Leela Krishna Amudala <leela.krishna@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        daniel.lezcano@linaro.org, nicolas.pitre@linaro.org,
        kgene.kim@samsung.com, amit.kucheria@linaro.org
Subject: Re: [PATCH V2] ARM: EXYNOS: cpu hotplug: use v7_exit_coherency_flush
 macro for cache disabling
References: <1398232351-16280-1-git-send-email-leela.krishna@linaro.org>
In-reply-to: <1398232351-16280-1-git-send-email-leela.krishna@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkRJd1XUKwwbl/IhbNDYuZLOZ9lrXo
	XXCVzWLC/g8sFpseX2O1uLxrDpvF594jjBYzzu9jsvj07B+7A6fHnWt72Dw2L6n36NuyitHj
	8ya5AJYoLpuU1JzMstQifbsEroyF/26zFHRIVHQd+MfawLhWqIuRk0NCwESi5fxiVghbTOLC
	vfVsXYxcHEICSxklrrY1ssEUNb25xwyRmM4osWbbEkYI5zWjxPRXr8CqeAW0JH4dOckCYrMI
	qErceD2LCcRmA4rvf3EDrEZUIExi5fQrLBD1ghI/Jt8Ds0WANpzYuAtsKLPAe0aJKTPPgTUI
	C2RKvDn7Aew+IQEPiV1XjgLZHBycAp4SBy/IgISZBXQk9rdOY4Ow5SU2r3kLdqmEwDV2ie27
	Z7JBHCQg8W3yIRaQXgkBWYlNB5ghPpOUOLjiBssERrFZSE6ahWTsLCRjFzAyr2IUTS1ILihO
	Si8y0StOzC0uzUvXS87P3cQIjL/T/55N2MF474D1IcZkoJUTmaVEk/OB8ZtXEm9obGZkYWpi
	amxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyC6VV+La8XPHMVKcgt
	V7ly4dldlSWN83LZb092WZ50WEpBneOA/o2Fv/fd8T0f0bLaL9Buoeom7xN9ST9vHDSbWtoh
	cb/Otqcl/pvah99clV++Tez7rN0i++xAeM65uFXz4iaoGPSeFfVXllL4umy/sKCV5MeTtcX5
	RyVPbch6ZniNY8lxvT9KLMUZiYZazEXFiQC95Kw41QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQV3WdQnBBu3TeSyaGxYzWcz7LGvR
	u+Aqm8WE/R9YLDY9vsZqcXnXHDaLz71HGC1mnN/HZPHp2T92B06PO9f2sHlsXlLv0bdlFaPH
	501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUCnKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzFv67zVLQIVHRdeAf
	awPjWqEuRk4OCQETiaY395ghbDGJC/fWs3UxcnEICUxnlFizbQkjhPOaUWL6q1dsIFW8AloS
	v46cZAGxWQRUJW68nsUEYrMBxfe/uAFWIyoQJrFy+hUWiHpBiR+T74HZIkDbTmzcBTaUWeA9
	o8SUmefAGoQFMiXenP3ACmILCXhI7LpyFMjm4OAU8JQ4eEEGJMwsoCOxv3UaG4QtL7F5zVvm
	CYwCs5CsmIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqP7mfQOxlUNFocY
	BTgYlXh4BbbGBwuxJpYVV+YeYpTgYFYS4c3oSAgW4k1JrKxKLcqPLyrNSS0+xJgMDIGJzFKi
	yfnAxJNXEm9obGJmZGlkbmhhZGxOmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyre+Rm
	OSfeDzT6cz7pQ0LjtpUVwa7/PkUtW6HiE6fqxLpl+vf3agoP13arpL/nXH7owI+ubnP+lzlq
	8640ynK4zGv6NluNvWD5A875Yp4H9izaqtj7/sr6BTM9nzzwN/BqmKzh4a3UclNz52ehJO73
	126c2m4dofGXq1JwNVedT3b0nUbRHmYlluKMREMt5qLiRAC2UmuCMgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/23/2014 02:52 PM, Leela Krishna Amudala wrote:
> A common macro v7_exit_coherency_flush available which does the below tasks in
> the seqeunce.
> -clearing C bit
> -clearing L1 cache
> -exit SMP
> -instruction and data synchronization
> 
> So removing the local functions which does the same thing and use the macro instead.
> 
> Signed-off-by: Leela Krishna Amudala <leela.krishna@linaro.org>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> ---
> Changes since V1:
> 	- removed unwanted primary_part variable in exynos_cpu_die()
> 	- given more description in commit message
> 	  suggested by Daniel Lezcano <daniel.lezcano@linaro.org>
> 
>  arch/arm/mach-exynos/hotplug.c |   63 +---------------------------------------
>  1 file changed, 1 insertion(+), 62 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index 5eead53..9ca692d 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -24,56 +24,6 @@
>  #include "common.h"
>  #include "regs-pmu.h"
>  
> -static inline void cpu_enter_lowpower_a9(void)
> -{
> -	unsigned int v;
> -
> -	asm volatile(
> -	"	mcr	p15, 0, %1, c7, c5, 0\n"
> -	"	mcr	p15, 0, %1, c7, c10, 4\n"
> -	/*
> -	 * Turn off coherency
> -	 */
> -	"	mrc	p15, 0, %0, c1, c0, 1\n"
> -	"	bic	%0, %0, %3\n"
> -	"	mcr	p15, 0, %0, c1, c0, 1\n"
> -	"	mrc	p15, 0, %0, c1, c0, 0\n"
> -	"	bic	%0, %0, %2\n"
> -	"	mcr	p15, 0, %0, c1, c0, 0\n"
> -	  : "=&r" (v)
> -	  : "r" (0), "Ir" (CR_C), "Ir" (0x40)
> -	  : "cc");
> -}
> -
> -static inline void cpu_enter_lowpower_a15(void)
> -{
> -	unsigned int v;
> -
> -	asm volatile(
> -	"	mrc	p15, 0, %0, c1, c0, 0\n"
> -	"	bic	%0, %0, %1\n"
> -	"	mcr	p15, 0, %0, c1, c0, 0\n"
> -	  : "=&r" (v)
> -	  : "Ir" (CR_C)
> -	  : "cc");
> -
> -	flush_cache_louis();
> -
> -	asm volatile(
> -	/*
> -	* Turn off coherency
> -	*/
> -	"	mrc	p15, 0, %0, c1, c0, 1\n"
> -	"	bic	%0, %0, %1\n"
> -	"	mcr	p15, 0, %0, c1, c0, 1\n"
> -	: "=&r" (v)
> -	: "Ir" (0x40)
> -	: "cc");
> -
> -	isb();
> -	dsb();
> -}
> -
>  static inline void cpu_leave_lowpower(void)
>  {
>  	unsigned int v;
> @@ -132,19 +82,8 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>  void __ref exynos_cpu_die(unsigned int cpu)
>  {
>  	int spurious = 0;
> -	int primary_part = 0;
>  
> -	/*
> -	 * we're ready for shutdown now, so do it.
> -	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
> -	 * number by reading the Main ID register and then perform the
> -	 * appropriate sequence for entering low power.
> -	 */
> -	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
> -	if ((primary_part & 0xfff0) == 0xc0f0)
> -		cpu_enter_lowpower_a15();
> -	else
> -		cpu_enter_lowpower_a9();
> +	v7_exit_coherency_flush(louis);
>  
>  	platform_do_lowpower(cpu, &spurious);
>  
> 

I tested this patch on Exynos3250 based on Cortex-A7 dual core.

Tested-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

