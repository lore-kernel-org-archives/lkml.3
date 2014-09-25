Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaIYF6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:58:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32778 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaIYF6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:58:37 -0400
X-AuditID: cbfee68f-f791c6d000004834-c3-5423af081ba0
From: Kukjin Kim <kgene@kernel.org>
To: "'Nicolas Pitre'" <nicolas.pitre@linaro.org>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'David A. Long'" <dave.long@linaro.org>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Vinayak Kale'" <vkale@apm.com>,
        "'Laura Abbott'" <lauraa@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Mark Brown'" <broonie@kernel.org>
References: <1411547222-677-1-git-send-email-k.kozlowski@samsung.com>
 <alpine.LFD.2.11.1409240954220.8647@knanqh.ubzr>
In-reply-to: <alpine.LFD.2.11.1409240954220.8647@knanqh.ubzr>
Subject: RE: [PATCH v2] ARM: cacheflush: Fix v7_exit_coherency_flush exynos
 build breakage on ARMv6
Date: Thu, 25 Sep 2014 14:58:31 +0900
Message-id: <018f01cfd885$bc677320$35365960$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH2EfuXvgFYm1dhkjotV9wIbvT5nAHmgOrBm7Wx25A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zI12O9cohBv1bRC02zljPajH14RM2
	i497FrBZvH5haHG26Q27xfbOGewWmx5fY7W4vGsOm8Xty7wWa4/cZbdYev0ik8WnZ//YLVbt
	+sNoMe/ZaTaLlx9PsDjwe3xc/4nRY828NYweLc09bB6X+3qZPHbOusvusWlVJ5vHnWt72Dw2
	L6n36NuyitHj8ya5AK4oLpuU1JzMstQifbsErowXq1oYCy4LVmy+NYOlgXEGXxcjJ4eEgInE
	9nObmCBsMYkL99azdTFycQgJLGOUaHx3kRmm6Fn/DSaIxHRGidN7D7NDOH8ZJVrXbgJyODjY
	BJQlGpv0QRqEBbQkFm5pYgGxRQQSJeaemQ1Wzywwk0XizcXt7CAJIYEKicvPjoP1cgrYSpzf
	EAfRmyqxctkCNhCbRUBV4s6vD2DX8QpYSLQtecoKYQtK/Jh8D2w+M9Cu9TuPM0HY8hKb17yF
	OlpBYsfZ14wQN1hJNHROgaoXkdj34h0jyD0SAmc4JKYe+sMOsUxA4tvkQywg90gIyEpsOgA1
	R1Li4IobLBMYJWchWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYyQ
	lNK/g/HuAetDjAIcjEo8vB7+yiFCrIllxZW5hxhNgS6ayCwlmpwPTFx5JfGGxmZGFqYmpsZG
	5pZmSuK8C6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgrObmTFK5O3nd52ffzXRW33ay
	NE4MC9bgDNwSGe9a4cCT8HBamdJ5n9Lfc/sj92pXzAg7nzfpW4nBK57CmbmGk5f5vDnHsUN0
	6rzQ0M/HZRIKpY580GGs7A156uH1+fsSB62LZTEP9nnu+fQ+/u+CF+/imlaHbTh3oF1NmjvN
	Neea6ab5RVxnlFiKMxINtZiLihMBD1gVtyQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jQV2O9cohBh0n+S02zljPajH14RM2
	i497FrBZvH5haHG26Q27xfbOGewWmx5fY7W4vGsOm8Xty7wWa4/cZbdYev0ik8WnZ//YLVbt
	+sNoMe/ZaTaLlx9PsDjwe3xc/4nRY828NYweLc09bB6X+3qZPHbOusvusWlVJ5vHnWt72Dw2
	L6n36NuyitHj8ya5AK6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTc
	VFslF58AXbfMHKAvlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZL1a1
	MBZcFqzYfGsGSwPjDL4uRk4OCQETiWf9N5ggbDGJC/fWs3UxcnEICUxnlDi99zA7hPOXUaJ1
	7SYgh4ODTUBZorFJH6RBWEBLYuGWJhYQW0QgUWLumdlg9cwCM1kk3lzczg6SEBKokLj87DhY
	L6eArcT5DXEQvakSK5ctYAOxWQRUJe78+gB2BK+AhUTbkqesELagxI/J98DmMwPtWr/zOBOE
	LS+xec1bZoijFSR2nH3NCHGDlURD5xSoehGJfS/eMU5gFJ6FZNQsJKNmIRk1C0nLAkaWVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjBCeuZ1A7GlQ0WhxgFOBiVeHg9/JVDhFgTy4orcw8x
	SnAwK4nw+qwBCvGmJFZWpRblxxeV5qQWH2I0Bfp0IrOUaHI+MJnmlcQbGpuYGVkamVkYmZib
	K4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpgNLinc6GK61zFM+eS88Ke0qZ6Ae9kL8i9iH3Y
	pB5uxPjX7uXSXWZvQ5yOT9/eK6RTvk+kW7dnXXPjMs3Pq+POLxFJqag4wGwnca0lZWfSXM81
	B09VbV5aOjl97t+zZhaz91z78W7XIdWbO/r3r+sviZllyj9tu5UBg5zo4mDRL1e3Cm1PnPFn
	oRJLcUaioRZzUXEiAMSDJZluAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> 
> On Wed, 24 Sep 2014, Krzysztof Kozlowski wrote:
> 
> > This fixes build breakage of platsmp.c if ARMv6 was chosen for compile
> > time options (e.g. by building allmodconfig):
> >
> > $ make allmodconfig
> > $ make
> >   CC      arch/arm/mach-exynos/platsmp.o
> > /tmp/ccdQM0Eg.s: Assembler messages:
> > /tmp/ccdQM0Eg.s:432: Error: selected processor does not support ARM mode `isb '
> > /tmp/ccdQM0Eg.s:437: Error: selected processor does not support ARM mode `isb '
> > /tmp/ccdQM0Eg.s:438: Error: selected processor does not support ARM mode `dsb '
> > make[1]: *** [arch/arm/mach-exynos/platsmp.o] Error 1
> >
> > The error was introduced in commit "ARM: EXYNOS: Move code from
> > hotplug.c to platsmp.c".  Previously code using
> > v7_exit_coherency_flush() macro was built with '-march=armv7-a' flag but
> > this flag dissapeared during the movement.
> >
> > Fix this by annotating the v7_exit_coherency_flush() asm code with
> > armv7-a architecture.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reported-by: Mark Brown <broonie@kernel.org>
> > Link: http://www.spinics.net/lists/linux-samsung-soc/msg36790.html
> 
> Acked-by: Nicolas Pitre <nico@linaro.org>
> 
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

For building allmodconfig, this patch fixes the problem.

Hi Russell,
Can you please take this?

- Kukjin

> 
> >
> > ---
> >
> > Changes since v1:
> > 1. Use armv7-a arch annotation instead replacing isb/dsb with macros.
> >    Suggsted by Nicolas Pitre.
> > ---
> >  arch/arm/include/asm/cacheflush.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
> > index 79ecb4f34ffb..10e78d00a0bb 100644
> > --- a/arch/arm/include/asm/cacheflush.h
> > +++ b/arch/arm/include/asm/cacheflush.h
> > @@ -466,6 +466,7 @@ static inline void __sync_cache_range_r(volatile void *p, size_t size)
> >   */
> >  #define v7_exit_coherency_flush(level) \
> >  	asm volatile( \
> > +	".arch	armv7-a \n\t" \
> >  	"stmfd	sp!, {fp, ip} \n\t" \
> >  	"mrc	p15, 0, r0, c1, c0, 0	@ get SCTLR \n\t" \
> >  	"bic	r0, r0, #"__stringify(CR_C)" \n\t" \
> > --
> > 1.9.1

