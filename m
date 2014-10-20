Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaJTHnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:43:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20780 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaJTHm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:42:59 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-7a-5444bd00806a
Message-id: <5444BCFF.8030803@samsung.com>
Date: Mon, 20 Oct 2014 09:42:55 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Stefan Hengelein <stefan.hengelein@fau.de>, linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, akpm@linux-foundation.org, lauraa@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, andreas.herrmann@calxeda.com
Subject: Re: [PATCH] arm: dma-mapping: fix compilation error when CONFIG_MMU is
 not present
References: <1413734340-53108-1-git-send-email-stefan.hengelein@fau.de>
In-reply-to: <1413734340-53108-1-git-send-email-stefan.hengelein@fau.de>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7oMe11CDK73W1rMWb+GzWLxkRiL
	7Z0z2C02Pb7GanF51xw2i9uXeS26709ic2D3aGnuYfNY8PkKu8flvl4mj/Pts1k8Tsz4zeKx
	eUm9x+dNcgHsUVw2Kak5mWWpRfp2CVwZ/xd8ZSn4yVOxbUZiA+NRri5GTg4JAROJv/dnMEPY
	YhIX7q1n62Lk4hASWMoo8X32DSjnE6PE070TGEGqeAW0JBo7FrCC2CwCqhKn5s4Gs9kEDCW6
	3naxgdiiAjES93euZoOoF5T4MfkeC4gtIuAj0XngOyPIUGaBSYwSC7/sBCsSFoiVWNl3iAnE
	FhJwl3g7dTXYUE4BD4neOyfYQWxmATOJLy8Ps0LY8hKb17xlnsAoMAvJjllIymYhKVvAyLyK
	UTS1NLmgOCk910ivODG3uDQvXS85P3cTIyTov+5gXHrM6hCjAAejEg/vDjOXECHWxLLiytxD
	jBIczEoivP8ygEK8KYmVValF+fFFpTmpxYcYmTg4pRoYWz40agWzCbn+ceB17Sp67vPU+yJz
	/TlRPn6hn/lK2zhMzH9mCdhc+SVWYaDdrHp0M5vZbe4Lftvc+X/uZ3ob1nGs5G3/9dAzd3sc
	pX0mJnsvuXzi81FX6xgzoZhZdi/UCngfLm9eV5n/Y++3LxvLrkw8IC76ecWlHBPX7RmLvl5P
	e5/dfemNEktxRqKhFnNRcSIAOlCLRVgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-19 17:59, Stefan Hengelein wrote:
> When CONFIG_MMU is not present, the variable 'atomic_pool' and the
> function '__in_atomic_pool' are undeclared but used in part of the
> code. Therefore, the compilation breaks.
> Now, they are defined to dummy values when CONFIG_MMU is undefined.
>
> This error was found with vampyr.

Frankly, those variables are used only when CONFIG_MMU or
CONFIG_ARM_DMA_USE_IOMMU are set. The latter imho makes only sense
together with CONFIG_MMU, so the issue reported here doesn't really
happen in real world.

> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
> ---
>   arch/arm/mm/dma-mapping.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index c245d90..7d04cf7 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -573,12 +573,14 @@ static inline pgprot_t __get_dma_pgprot(struct dma_attrs *attrs, pgprot_t prot)
>   #else	/* !CONFIG_MMU */
>   
>   #define nommu() 1
> +#define atomic_pool 0
>   
>   #define __get_dma_pgprot(attrs, prot)	__pgprot(0)
>   #define __alloc_remap_buffer(dev, size, gfp, prot, ret, c)	NULL
>   #define __alloc_from_pool(size, ret_page)			NULL
>   #define __alloc_from_contiguous(dev, size, prot, ret, c)	NULL
>   #define __free_from_pool(cpu_addr, size)			0
> +#define __in_atomic_pool(start, size)				0
>   #define __free_from_contiguous(dev, page, cpu_addr, size)	do { } while (0)
>   #define __dma_free_remap(cpu_addr, size)			do { } while (0)
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

