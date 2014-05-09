Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaEICOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:14:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63782 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbaEICOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:14:42 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-5f-536c3a106ce8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Leela Krishna Amudala'" <leela.krishna@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        daniel.lezcano@linaro.org, nicolas.pitre@linaro.org,
        amit.kucheria@linaro.org
References: <1398232351-16280-1-git-send-email-leela.krishna@linaro.org>
 <5360AE05.7020106@samsung.com>
In-reply-to: <5360AE05.7020106@samsung.com>
Subject: RE: [PATCH V2] ARM: EXYNOS: cpu hotplug: use v7_exit_coherency_flush
 macro for cache disabling
Date: Fri, 09 May 2014 11:14:40 +0900
Message-id: <034c01cf6b2c$6f3dd510$4db97f30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJuaV0WlQPfjXqMr06X3l23ZiS5cgNSumVfmd7dPcA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zI10Bq5xggxPPzS2aGxYzWVz/8pzV
	Yt5nWYsJ+z+wWGx6fI3V4vKuOWwWn3uPMFrMOL+PyeLTs3/sDpwed67tYfPYvKTeo2/LKkaP
	z5vkAliiuGxSUnMyy1KL9O0SuDKuL3jOVDBJqmL5au0Gxj3CXYwcHBICJhK37/l1MXICmWIS
	F+6tZwOxhQSWMUp8eJ8AETeReL/vGnsXIxdQfBGjRNeVj6wQzl9GifeLJzCBVLEJaEgcfv+M
	HcQWEUiQ+Lh4AVgRs8A1RomeT6eYIMZmSvyd3wa2glNAW+LM5pfMIFcIA8U/vpMCMVkEVCUO
	dWqCVPAKWEpsuv6MDcIWlPgx+R4LiM0soCWxeVsTK4QtL7F5zVtmiEMVJHacfc0IcYKVxOln
	BxkhakQk9r14xwhyjoTAR3aJq7MugN3JIiAg8W3yIRZIQMhKbDoANUdS4uCKGywTGCVmIVk9
	C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkPjt28F484D1IcZkoPUT
	maVEk/OB8Z9XEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZ
	ODilGhgdNnBkH59QNkNryqyV72KOfN3R8K9uVqa6Z+nUOVZSRr623Dt3KTEzP7rzMP/nVNmj
	809zeUxe4XJH4NrirY/cL6Xwh5WwcbxMmqtfo1BbxeJyJ1XtwDoR7qm27qrRS1WDPjR/efps
	5a6NbMfv/1KTCXDzW9d7rzQhtV/ERLr81ql+1fpJuw8psRRnJBpqMRcVJwIAFmMCyfUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAV0Bq5xgg65LRhbNDYuZLK5/ec5q
	Me+zrMWE/R9YLDY9vsZqcXnXHDaLz71HGC1mnN/HZPHp2T92B06PO9f2sHlsXlLv0bdlFaPH
	501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUCnKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzri94zlQwSapi+Wrt
	BsY9wl2MnBwSAiYS7/ddY4ewxSQu3FvP1sXIxSEksIhRouvKR1YI5y+jxPvFE5hAqtgENCQO
	v38G1iEikCDxcfECsCJmgWuMEj2fToEVCQlkSvyd38YGYnMKaEuc2fySuYuRg0MYKP7xnRSI
	ySKgKnGoUxOkglfAUmLT9WdsELagxI/J91hAbGYBLYnN25pYIWx5ic1r3jJDHKogsePsa0aI
	E6wkTj87yAhRIyKx78U7xgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4QTyT3sG4qsHiEKMAB6MSD++LKdnBQqyJZcWVuYcYJTiYlUR47+jnBAvxpiRW
	VqUW5ccXleakFh9iTAZ6dCKzlGhyPjB55ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2x
	JDU7NbUgtQhmCxMHp1QDI+t71is5Fx7vFp21dt6veZe2pMd6MF9JVZxxcUXUvtxTR0TMl+v/
	1uSY2avxN8Og/UHi5ha9xra33IcbO6KWOWRy5JXGbFqsktkfKHS0/rb7//81FyZVqfaVCTN8
	m+h5xkmNc17l53VF9v/uxaxxl1rwSKv+hJ2p1cLWvtZJsevPLsxgi+uJVmIpzkg01GIuKk4E
	AG0ep15UAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi wrote:
> 
> Hi,
> 
> On 04/23/2014 02:52 PM, Leela Krishna Amudala wrote:
> > A common macro v7_exit_coherency_flush available which does the below
> tasks in
> > the seqeunce.
> > -clearing C bit
> > -clearing L1 cache
> > -exit SMP
> > -instruction and data synchronization
> >
> > So removing the local functions which does the same thing and use the
> macro instead.
> >
> > Signed-off-by: Leela Krishna Amudala <leela.krishna@linaro.org>
> > Acked-by: Nicolas Pitre <nico@linaro.org>
> > ---
> > Changes since V1:
> > 	- removed unwanted primary_part variable in exynos_cpu_die()
> > 	- given more description in commit message
> > 	  suggested by Daniel Lezcano <daniel.lezcano@linaro.org>
> >
> >  arch/arm/mach-exynos/hotplug.c |   63
+---------------------------------
> ------
> >  1 file changed, 1 insertion(+), 62 deletions(-)
> >
> > diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-
> exynos/hotplug.c
> > index 5eead53..9ca692d 100644
> > --- a/arch/arm/mach-exynos/hotplug.c
> > +++ b/arch/arm/mach-exynos/hotplug.c
> > @@ -24,56 +24,6 @@
> >  #include "common.h"
> >  #include "regs-pmu.h"
> >
> > -static inline void cpu_enter_lowpower_a9(void)
> > -{
> > -	unsigned int v;
> > -
> > -	asm volatile(
> > -	"	mcr	p15, 0, %1, c7, c5, 0\n"
> > -	"	mcr	p15, 0, %1, c7, c10, 4\n"
> > -	/*
> > -	 * Turn off coherency
> > -	 */
> > -	"	mrc	p15, 0, %0, c1, c0, 1\n"
> > -	"	bic	%0, %0, %3\n"
> > -	"	mcr	p15, 0, %0, c1, c0, 1\n"
> > -	"	mrc	p15, 0, %0, c1, c0, 0\n"
> > -	"	bic	%0, %0, %2\n"
> > -	"	mcr	p15, 0, %0, c1, c0, 0\n"
> > -	  : "=&r" (v)
> > -	  : "r" (0), "Ir" (CR_C), "Ir" (0x40)
> > -	  : "cc");
> > -}
> > -
> > -static inline void cpu_enter_lowpower_a15(void)
> > -{
> > -	unsigned int v;
> > -
> > -	asm volatile(
> > -	"	mrc	p15, 0, %0, c1, c0, 0\n"
> > -	"	bic	%0, %0, %1\n"
> > -	"	mcr	p15, 0, %0, c1, c0, 0\n"
> > -	  : "=&r" (v)
> > -	  : "Ir" (CR_C)
> > -	  : "cc");
> > -
> > -	flush_cache_louis();
> > -
> > -	asm volatile(
> > -	/*
> > -	* Turn off coherency
> > -	*/
> > -	"	mrc	p15, 0, %0, c1, c0, 1\n"
> > -	"	bic	%0, %0, %1\n"
> > -	"	mcr	p15, 0, %0, c1, c0, 1\n"
> > -	: "=&r" (v)
> > -	: "Ir" (0x40)
> > -	: "cc");
> > -
> > -	isb();
> > -	dsb();
> > -}
> > -
> >  static inline void cpu_leave_lowpower(void)
> >  {
> >  	unsigned int v;
> > @@ -132,19 +82,8 @@ static inline void platform_do_lowpower(unsigned int
> cpu, int *spurious)
> >  void __ref exynos_cpu_die(unsigned int cpu)
> >  {
> >  	int spurious = 0;
> > -	int primary_part = 0;
> >
> > -	/*
> > -	 * we're ready for shutdown now, so do it.
> > -	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
> > -	 * number by reading the Main ID register and then perform the
> > -	 * appropriate sequence for entering low power.
> > -	 */
> > -	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
> > -	if ((primary_part & 0xfff0) == 0xc0f0)
> > -		cpu_enter_lowpower_a15();
> > -	else
> > -		cpu_enter_lowpower_a9();
> > +	v7_exit_coherency_flush(louis);
> >
> >  	platform_do_lowpower(cpu, &spurious);
> >
> >
> 
> I tested this patch on Exynos3250 based on Cortex-A7 dual core.
> 
> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
OK, will apply, thanks.

- Kukjin

