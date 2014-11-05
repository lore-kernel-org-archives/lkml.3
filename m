Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaKEV6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:58:47 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55168 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaKEV6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:58:42 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Gregory Fong <gregory.0xf0@gmail.com>, linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org, f.fainelli@gmail.com,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: cma: Align to physical address, not CMA region position
In-Reply-To: <1415218078-10078-2-git-send-email-gregory.0xf0@gmail.com>
Organization: http://mina86.com/
References: <1415218078-10078-1-git-send-email-gregory.0xf0@gmail.com> <1415218078-10078-2-git-send-email-gregory.0xf0@gmail.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141105:akpm@linux-foundation.org::RxaEOKuBUEPTmCm0:00000000000000000000000000000000000002Li
X-Hashcash: 1:20:141105:aneesh.kumar@linux.vnet.ibm.com::RvGooNj1yQi9g/iP:0000000000000000000000000000000NDD
X-Hashcash: 1:20:141105:iamjoonsoo.kim@lge.com::pPjqrUYBHNmOrTPl:0000000000000000000000000000000000000000JwM
X-Hashcash: 1:20:141105:gregory.0xf0@gmail.com::Qlr6S4+j7TJFzSIV:0000000000000000000000000000000000000000UXY
X-Hashcash: 1:20:141105:f.fainelli@gmail.com::ja2hxAO6OC5nyt+N:000000000000000000000000000000000000000002tEZ
X-Hashcash: 1:20:141105:linux-kernel@vger.kernel.org::oIIjfDceOAhbV1tG:0000000000000000000000000000000003CYX
X-Hashcash: 1:20:141105:linux-arm-kernel@lists.infradead.org::Nk7+GNU9VluUlHUG:00000000000000000000000005wco
X-Hashcash: 1:20:141105:gregory.0xf0@gmail.com::vAVbwo8DTPpzHF8n:0000000000000000000000000000000000000007bm4
X-Hashcash: 1:20:141105:m.szyprowski@samsung.com::MMAj5jwR39ovREpa:00000000000000000000000000000000000006UIn
X-Hashcash: 1:20:141105:laurent.pinchart+renesas@ideasonboard.com::f1ADtd47ii2mU9pS:000000000000000000009KIQ
X-Hashcash: 1:20:141105:linux-mm@kvack.org::j4pVE8OWNW6hIT3J:00000000000000000000000000000000000000000009Edj
X-Hashcash: 1:20:141105:lauraa@codeaurora.org::8Dr69S4HkZQcCSJ9:00000000000000000000000000000000000000009X7D
Date: Wed, 05 Nov 2014 22:58:37 +0100
Message-ID: <xa1tvbmtwbqq.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05 2014, Gregory Fong wrote:
> The alignment in cma_alloc() was done w.r.t. the bitmap.  This is a
> problem when, for example:
>
> - a device requires 16M (order 12) alignment
> - the CMA region is not 16 M aligned
>
> In such a case, can result with the CMA region starting at, say,
> 0x2f800000 but any allocation you make from there will be aligned from
> there.  Requesting an allocation of 32 M with 16 M alignment will
> result in an allocation from 0x2f800000 to 0x31800000, which doesn't
> work very well if your strange device requires 16M alignment.
>
> Change to use bitmap_find_next_zero_area_off() to account for the
> difference in alignment at reserve-time and alloc-time.
>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
> ---
>  mm/cma.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index fde706e..0813599 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -63,6 +63,17 @@ static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
>  	return (1UL << (align_order - cma->order_per_bit)) - 1;
>  }
>  
> +static unsigned long cma_bitmap_aligned_offset(struct cma *cma, int align_order)
> +{
> +	unsigned int alignment;
> +
> +	if (align_order <= cma->order_per_bit)
> +		return 0;
> +	alignment = 1UL << (align_order - cma->order_per_bit);
> +	return ALIGN(cma->base_pfn, alignment) -
> +		(cma->base_pfn >> cma->order_per_bit);
> +}
> +
>  static unsigned long cma_bitmap_maxno(struct cma *cma)
>  {
>  	return cma->count >> cma->order_per_bit;
> @@ -328,7 +339,7 @@ err:
>   */
>  struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
>  {
> -	unsigned long mask, pfn, start = 0;
> +	unsigned long mask, offset, pfn, start = 0;
>  	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
>  	struct page *page = NULL;
>  	int ret;
> @@ -343,13 +354,15 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
>  		return NULL;
>  
>  	mask = cma_bitmap_aligned_mask(cma, align);
> +	offset = cma_bitmap_aligned_offset(cma, align);
>  	bitmap_maxno = cma_bitmap_maxno(cma);
>  	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
>  
>  	for (;;) {
>  		mutex_lock(&cma->lock);
> -		bitmap_no = bitmap_find_next_zero_area(cma->bitmap,
> -				bitmap_maxno, start, bitmap_count, mask);
> +		bitmap_no = bitmap_find_next_zero_area_off(cma->bitmap,
> +				bitmap_maxno, start, bitmap_count, mask,
> +				offset);
>  		if (bitmap_no >= bitmap_maxno) {
>  			mutex_unlock(&cma->lock);
>  			break;
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
