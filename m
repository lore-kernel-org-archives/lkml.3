Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaIAIkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:40:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27217 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaIAIkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:40:11 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-3c-540430e8cf1e
Content-transfer-encoding: 8BIT
Message-id: <1409560754.26751.2.camel@AMDC1943>
Subject: Re: [PATCH RESEND] ARM: EXYNOS: Do not calculate boot address twice
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>
Date: Mon, 01 Sep 2014 10:39:14 +0200
In-reply-to: <032901cf9763$b7733150$265993f0$@samsung.com>
References: <1403783163-28638-1-git-send-email-k.kozlowski@samsung.com>
 <032901cf9763$b7733150$265993f0$@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xq7ovDFhCDJZ8k7PYOGM9q0Xvgqts
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77BYn//QyWqyf8ZrFgcujpbmHzePOtT1s
	HpuX1Hv0bVnF6PF5k1wAaxSXTUpqTmZZapG+XQJXxt5d/1gK/nBX3G64xdrAuImzi5GTQ0LA
	ROLW4zVsELaYxIV764FsLg4hgaWMEmt3PmYHSfAKCEr8mHyPpYuRg4NZQF7iyKVskDCzgLrE
	pHmLmCHqPzNKHJ83kRmiXl/i64UbYLawgI/EmwurwGw2AWOJzcuXgC0TEVCT6Fm8lRGkmVng
	H5PE30crwYpYBFQlti7fwgJicwpYSfyadxIsLiRQLvHy+3NmkCMkBJQlGvvdJjAKzEJy3iyE
	82YhOW8BI/MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJDg/7KDcfExq0OMAhyMSjy8LxYy
	hwixJpYVV+YeYpTgYFYS4RUExo4Qb0piZVVqUX58UWlOavEhRiYOTqkGxvzzW6P/zbgXt/n9
	P/OJj1Qbb3NPaeO73PXeVGbFiwvHdxwSe/wiStT4+LR9Lf4lLiFLw9heuTRcj7keU6w3TzK6
	8eychzX+q552cxqV2slNm8b28VDb/LzvvzRdg3Ru/Tmn/HB1Rfxykdk+t7cy+X2YlbsoJb3S
	XoOP+53ITLkkkRwRvgd6LEosxRmJhlrMRcWJAN8G4rtcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-07-04 at 17:41 +0900, Kukjin Kim wrote:
> Krzysztof Kozlowski wrote:
> > 
> > Commit b3205dea8fbf ("ARM: EXYNOS: Map SYSRAM through generic DT
> > bindings") introduced local variable boot_reg where boot address from
> > cpu_boot_reg() call is stored. Re-use it instead calling cpu_boot_reg()
> > again.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  arch/arm/mach-exynos/platsmp.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
> > index 1c8d31e39520..55ed2e6729c5 100644
> > --- a/arch/arm/mach-exynos/platsmp.c
> > +++ b/arch/arm/mach-exynos/platsmp.c
> > @@ -155,7 +155,7 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
> >  				ret = PTR_ERR(boot_reg);
> >  				goto fail;
> >  			}
> > -			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
> > +			__raw_writel(boot_addr, boot_reg);
> >  		}
> > 
> >  		call_firmware_op(cpu_boot, phys_cpu);
> > @@ -242,7 +242,7 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
> > 
> >  			if (IS_ERR(boot_reg))
> >  				break;
> > -			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
> > +			__raw_writel(boot_addr, boot_reg);
> >  		}
> >  	}
> >  }
> > --
> > 1.9.1
> 
> Oh, good catch. will apply :-)

Hi Kukjin,

I cannot find this patch in your tree or in next. Did you applied this? 

Best regards,
Krzysztof


> Thanks,
> Kukjin

