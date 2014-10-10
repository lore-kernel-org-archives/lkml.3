Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaJJOTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:19:05 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57003 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaJJOTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:19:01 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Weijie Yang <weijie.yang@samsung.com>, iamjoonsoo.kim@lge.com
Cc: aneesh.kumar@linux.vnet.ibm.com, m.szyprowski@samsung.com,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/cma: fix cma bitmap aligned mask computing
In-Reply-To: <000301cfe430$504b0290$f0e107b0$%yang@samsung.com>
Organization: http://mina86.com/
References: <000301cfe430$504b0290$f0e107b0$%yang@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141010:akpm@linux-foundation.org::tPEQvLO9gQuCfnUS:0000000000000000000000000000000000000S6p
X-Hashcash: 1:20:141010:weijie.yang@samsung.com::axBHi7iFHfUjHtJ2:000000000000000000000000000000000000002Li/
X-Hashcash: 1:20:141010:m.szyprowski@samsung.com::jviWRQdZDNBKkRtX:00000000000000000000000000000000000002+Ax
X-Hashcash: 1:20:141010:aneesh.kumar@linux.vnet.ibm.com::MYca18VQCPqrKSWp:0000000000000000000000000000003sYw
X-Hashcash: 1:20:141010:linux-kernel@vger.kernel.org::RERzZKTj+o4NSFQh:0000000000000000000000000000000003zno
X-Hashcash: 1:20:141010:iamjoonsoo.kim@lge.com::EIXURTuN0ZPZpHNo:00000000000000000000000000000000000000052Dk
X-Hashcash: 1:20:141010:linux-mm@kvack.org::x65LGXdP9XCA/SJO:00000000000000000000000000000000000000000006sWX
Date: Fri, 10 Oct 2014 16:18:54 +0200
Message-ID: <xa1tvbns2ek1.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2014, Weijie Yang wrote:
> The current cma bitmap aligned mask compute way is incorrect, it could
> cause an unexpected align when using cma_alloc() if wanted align order
> is bigger than cma->order_per_bit.
>
> Take kvm for example (PAGE_SHIFT = 12), kvm_cma->order_per_bit is set to 6,
> when kvm_alloc_rma() tries to alloc kvm_rma_pages, it will input 15 as
> expected align value, after using current computing, however, we get 0 as
> cma bitmap aligned mask other than 511.
>
> This patch fixes the cma bitmap aligned mask compute way.
>
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

Should that also get:

Cc: <stable@vger.kernel.org> # v3.17

> ---
>  mm/cma.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index c17751c..f6207ef 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -57,7 +57,10 @@ unsigned long cma_get_size(struct cma *cma)
>  
>  static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
>  {
> -	return (1UL << (align_order >> cma->order_per_bit)) - 1;
> +	if (align_order <= cma->order_per_bit)
> +		return 0;
> +	else
> +		return (1UL << (align_order - cma->order_per_bit)) - 1;
>  }
>  
>  static unsigned long cma_bitmap_maxno(struct cma *cma)
> -- 
> 1.7.10.4
>
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
