Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbaGDIlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:41:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39213 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaGDIlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:41:17 -0400
X-AuditID: cbfee690-b7fb56d000003439-e4-53b668ab0ba9
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>
References: <1403783163-28638-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1403783163-28638-1-git-send-email-k.kozlowski@samsung.com>
Subject: RE: [PATCH RESEND] ARM: EXYNOS: Do not calculate boot address twice
Date: Fri, 04 Jul 2014 17:41:15 +0900
Message-id: <032901cf9763$b7733150$265993f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQITnyXVBaau3GWu2o69hEk1jowg/psHiPMA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zfd3VGduCDS5/F7XYOGM9q8XrF4YW
	Z5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12LtkbvsFif/9DJarJ/xmsWBy6OluYfN4861PWwe
	m5fUe/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfG/Z3H2Av+clZs2vqTuYGxjaOLkZNDQsBE
	4tuil2wQtpjEhXvrgWwuDiGBZYwSD3/vYoUpaui9zQiRWMQoMfnDXRYI5y+jxLk1kxlBqtgE
	NCQOv3/GDmKLCBxnlDjbEQxSxCzwilFiyb23YEVCAu4S11b8YgaxOQU8JL483gfWICzgI7H9
	0lqwOIuAqsTPDe/BVvMKWEr8O7uSEcIWlPgx+R4LiM0soCWxeVsTK4QtL7F5zVtmiFMVJHac
	fc0IcYSRxI8HO5kgakQk9r14B/aChMBfdonNPw+yQCwTkPg2+RCQzQGUkJXYdABqjqTEwRU3
	WCYwSsxCsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxghsT1hB+O9
	A9aHGJOB1k9klhJNzgemhrySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRmp6YWpBbF
	F5XmpBYfYmTi4JRqYPRwv7A82MdJ7e35l0tmL+d6LZRftqwx0LzxrZN68LM6lk0714eFPDt5
	+fCsqTnXFEL2zd2/K/VTeB572iSGYxcyVlyROSa211XFdNnhx9OXznCQz384y4O56+Zj1oft
	y0wWJSzfIGRqd+hx9kW12gXPZTflSX05H/ppZmOwc2/+7l/pGwXCGycosRRnJBpqMRcVJwIA
	1S7ydAMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jAd3VGduCDS5dE7TYOGM9q8XrF4YW
	Z5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12LtkbvsFif/9DJarJ/xmsWBy6OluYfN4861PWwe
	m5fUe/RtWcXo8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjPs7
	j7EX/OWs2LT1J3MDYxtHFyMnh4SAiURD721GCFtM4sK99WxdjFwcQgKLGCUmf7jLAuH8ZZQ4
	t2YyWBWbgIbE4ffP2EFsEYHjjBJnO4JBipgFXjFKLLn3FqxISMBd4tqKX8wgNqeAh8SXx/vA
	GoQFfCS2X1oLFmcRUJX4ueE9K4jNK2Ap8e/sSkYIW1Dix+R7LCA2s4CWxOZtTawQtrzE5jVv
	mSFOVZDYcfY1I8QRRhI/HuxkgqgRkdj34h3jBEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQ
	nJSea6hXnJhbXJqXrpecn7uJEZw4nkntYFzZYHGIUYCDUYmH16Noa7AQa2JZcWXuIUYJDmYl
	Ed7klG3BQrwpiZVVqUX58UWlOanFhxhNgT6dyCwlmpwPTGp5JfGGxiZmRpZGZhZGJubmSuK8
	B1qtA4UE0hNLUrNTUwtSi2D6mDg4pRoY5//lu7bphp/zi+TXX3SbJtz4rjTbZKqT6MI8YUUD
	z2McYd1lV4Vft/FuYjkquTZZY6mlTEvr1A8KBlbemhsTK9lnCYZM5jht5rfqnkW13Ox1bJlJ
	3xsMCj+8bFnHKfnMinGdm3PVw9TZZ9Yrf1SyXFgm/nJ6c1fQu0bl2O1Gy7teTMk34n+gxFKc
	kWioxVxUnAgAGL8LzjIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Kozlowski wrote:
> 
> Commit b3205dea8fbf ("ARM: EXYNOS: Map SYSRAM through generic DT
> bindings") introduced local variable boot_reg where boot address from
> cpu_boot_reg() call is stored. Re-use it instead calling cpu_boot_reg()
> again.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/mach-exynos/platsmp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
> index 1c8d31e39520..55ed2e6729c5 100644
> --- a/arch/arm/mach-exynos/platsmp.c
> +++ b/arch/arm/mach-exynos/platsmp.c
> @@ -155,7 +155,7 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  				ret = PTR_ERR(boot_reg);
>  				goto fail;
>  			}
> -			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
> +			__raw_writel(boot_addr, boot_reg);
>  		}
> 
>  		call_firmware_op(cpu_boot, phys_cpu);
> @@ -242,7 +242,7 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
> 
>  			if (IS_ERR(boot_reg))
>  				break;
> -			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
> +			__raw_writel(boot_addr, boot_reg);
>  		}
>  	}
>  }
> --
> 1.9.1

Oh, good catch. will apply :-)

Thanks,
Kukjin

