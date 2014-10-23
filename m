Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaJWQxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:53:45 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:53651 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJWQxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:53:42 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 1/4] mm: cma: Don't crash on allocation if CMA area can't be activated
In-Reply-To: <1414074828-4488-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Organization: http://mina86.com/
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1414074828-4488-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141023:m.szyprowski@samsung.com::VxN14qdvI22kM1b3:00000000000000000000000000000000000001YPi
X-Hashcash: 1:20:141023:linux-kernel@vger.kernel.org::IOL/h34dDeJEr+VZ:0000000000000000000000000000000002Paf
X-Hashcash: 1:20:141023:iamjoonsoo.kim@lge.com::9tUixLV8g7BNNMrQ:0000000000000000000000000000000000000002b5E
X-Hashcash: 1:20:141023:linux-sh@vger.kernel.org::W5EHp/ntGo2YG43e:00000000000000000000000000000000000002gEY
X-Hashcash: 1:20:141023:linux@arm.linux.org.uk::cqt2C+PmnrBbX+Rw:0000000000000000000000000000000000000003kO9
X-Hashcash: 1:20:141023:linux-arm-kernel@lists.infradead.org::4S2ie0OXJJ9ZXZ0I:00000000000000000000000007jPJ
X-Hashcash: 1:20:141023:linux-mm@kvack.org::BRkowSpJe2tlxwuP:00000000000000000000000000000000000000000008hJW
X-Hashcash: 1:20:141023:laurent.pinchart@ideasonboard.com::n+OOik+dGE5IeXlo:0000000000000000000000000000FZyK
Date: Thu, 23 Oct 2014 18:53:36 +0200
Message-ID: <xa1tmw8mlobz.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2014, Laurent Pinchart wrote:
> If activation of the CMA area fails its mutex won't be initialized,
> leading to an oops at allocation time when trying to lock the mutex. Fix
> this by failing allocation if the area hasn't been successfully actived,
> and detect that condition by moving the CMA bitmap allocation after page
> block reservation completion.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Cc: <stable@vger.kernel.org>  # v3.17
Acked-by: Michal Nazarewicz <mina86@mina86.com>

As a matter of fact, this is present in kernels earlier than 3.17 but in
the 3.17 the code has been moved from drivers/base/dma-contiguous.c to
mm/cma.c so this might require separate stable patch.  I can track this
and prepare a patch if you want.

> ---
>  mm/cma.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index 963bc4a..16c6650 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -93,11 +93,6 @@ static int __init cma_activate_area(struct cma *cma)
>  	unsigned i = cma->count >> pageblock_order;
>  	struct zone *zone;
>  
> -	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> -
> -	if (!cma->bitmap)
> -		return -ENOMEM;
> -
>  	WARN_ON_ONCE(!pfn_valid(pfn));
>  	zone = page_zone(pfn_to_page(pfn));
>  
> @@ -114,17 +109,17 @@ static int __init cma_activate_area(struct cma *cma)
>  			 * to be in the same zone.
>  			 */
>  			if (page_zone(pfn_to_page(pfn)) != zone)
> -				goto err;
> +				return -EINVAL;
>  		}
>  		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
>  	} while (--i);
>  
> +	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> +	if (!cma->bitmap)
> +		return -ENOMEM;
> +
>  	mutex_init(&cma->lock);
>  	return 0;
> -
> -err:
> -	kfree(cma->bitmap);
> -	return -EINVAL;
>  }
>  
>  static int __init cma_init_reserved_areas(void)
> @@ -313,7 +308,7 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
>  	struct page *page = NULL;
>  	int ret;
>  
> -	if (!cma || !cma->count)
> +	if (!cma || !cma->count || !cma->bitmap)
>  		return NULL;
>  
>  	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
> -- 
> 2.0.4
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
