Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3KYKrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:47:39 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27682 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KYKrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:47:36 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-22-52932ac7b800
Message-id: <52932AC6.4090203@samsung.com>
Date: Mon, 25 Nov 2013 11:47:34 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] CMA: Fix the phys_addr_t print types
References: <1385265384-30510-1-git-send-email-santosh.shilimkar@ti.com>
In-reply-to: <1385265384-30510-1-git-send-email-santosh.shilimkar@ti.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xq7rHtSYHGZyeJW3RvHg9m8Wmx9dY
	LS7vmsNm8bpvDbMDi8f+uWvYPTYvqfc4fmM7k8fnTXIBLFFcNimpOZllqUX6dglcGQ+n7GMt
	OMZbsf5KP3MDYyt3FyMnh4SAicSlZX9ZIGwxiQv31rN1MXJxCAksZZRY2HGNDSQhJPCJUeLY
	XHYQm1dAS+LI5UNgNouAqsTPvb3MIDabgKFE19suoHoODlGBUInvd0IgygUlfky+BzZfRMBP
	ouXOVlYQm1kgWmJB33smEFtYwEZi3Yy9UKs8JF4/vQRWwyngKfH57nR2iHoziUct65ghbHmJ
	zWveMk9gFJiFZMUsJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESuF93MC49
	ZnWIUYCDUYmH16JyUpAQa2JZcWXuIUYJDmYlEd58lclBQrwpiZVVqUX58UWlOanFhxiZODil
	GhhDfnDaqqhuiHXcl+M0RdpI5AhbxpbfMeIZsntP3J26b9r8+vVPW/6V66a+uHtd9Lb+jO+l
	TzOvy08/N/2snIXTtDmNX/Xqn6puj2yNchTd0/+bRbL6Vm0P95O1trXNbp+ywmu9K+c+XuAc
	VcSYfCPDLZaPkyfy0YlIb1mp5Z9WW4YFfrpeeVGJpTgj0VCLuag4EQA6rjvjOgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2013-11-24 04:56, Santosh Shilimkar wrote:
> Otherwise prints would truncate the variables on LPAE machines.
>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
> Dropped accidental change pr_debug to pr_info from last version.
>
>   drivers/base/dma-contiguous.c |    9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 165c2c2..b303a98 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -201,9 +201,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>   	phys_addr_t alignment;
>   	int ret = 0;
>   
> -	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
> -		 (unsigned long)size, (unsigned long)base,
> -		 (unsigned long)limit);
> +	pr_debug("%s(size %pa, base %pa, limit %pa)\n", __func__,
> +		 &size, &base, &limit);
>   
>   	/* Sanity checks */
>   	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
> @@ -250,8 +249,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>   	*res_cma = cma;
>   	cma_area_count++;
>   
> -	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
> -		(unsigned long)base);
> +	pr_info("CMA: reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
> +		&base);
>   
>   	/* Architecture specific contiguous memory fixup. */
>   	dma_contiguous_early_fixup(base, size);

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland

