Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3B0HJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 02:09:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65098 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3B0HJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 02:09:29 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-60-512db127e5f7
Message-id: <512DB11F.7080909@samsung.com>
Date: Wed, 27 Feb 2013 08:09:19 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215
 Thunderbird/17.0.3
MIME-version: 1.0
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/5] metag: Provide dma_get_sgtable()
References: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
 <1361876642-10247-2-git-send-email-james.hogan@imgtec.com>
In-reply-to: <1361876642-10247-2-git-send-email-james.hogan@imgtec.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4FV31jbqBBqd2K1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M6/d2sxa84664eHsHewPjV84uRg4OCQETib0zw7oYOYFMMYkL
	99azdTFycQgJLGWU6F70lwXCWcIk0fH3KiNIFa+AlsSC6T/ZQGwWAVWJbbOWgtlsAoYSXW+7
	wGxRgVCJR6+3Q9ULSvyYfI8FxBYR0JBYc6mXCcRmFvCWOP38GTOILSxgKTFn71Kozc2MEg+e
	LQBLcAq4S7St+sUK0WAm8ahlHTOELS+xec1b5gmMArOQ7JiFpGwWkrIFjMyrGEVTS5MLipPS
	c430ihNzi0vz0vWS83M3MUJC8OsOxqXHrA4xCnAwKvHwrripEyjEmlhWXJl7iFGCg1lJhPfj
	AaAQb0piZVVqUX58UWlOavEhRiYOTqkGxoMFlsLPm5bNEGvgizqf/KpisZ4nw9VtLTJ2rqbX
	ns3bXXbh/FZjo06/kBxGo1iRLWUTHiT8mOfPZnp9/UumsxUGraqxKokCNhnWOxPez1G+Jh3t
	c+erhO30vOcbJmw5dYTta3ago0HRzqvOD2VXvXvmsqvb+6pU2kaGu48j31dwd+xbWD1VW4ml
	OCPRUIu5qDgRANkJ+CAfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2/26/2013 12:03 PM, James Hogan wrote:
> metag/allmodconfig:
>
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function 'vb2_dc_get_base_sgt':
> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function 'dma_get_sgtable'
>
> For architectures using dma_map_ops, dma_get_sgtable() is provided in
> <asm-generic/dma-mapping-common.h>.
>
> Metag does not use dma_map_ops yet, hence it should implement it as an
> inline stub using dma_common_get_sgtable().
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   arch/metag/include/asm/dma-mapping.h | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/arch/metag/include/asm/dma-mapping.h b/arch/metag/include/asm/dma-mapping.h
> index b5f80a6..14b23ef 100644
> --- a/arch/metag/include/asm/dma-mapping.h
> +++ b/arch/metag/include/asm/dma-mapping.h
> @@ -180,4 +180,11 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
>   {
>   }
>   
> +/* drivers/base/dma-mapping.c */
> +extern int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
> +				  void *cpu_addr, dma_addr_t dma_addr,
> +				  size_t size);
> +
> +#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v, h, s)
> +
>   #endif

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


