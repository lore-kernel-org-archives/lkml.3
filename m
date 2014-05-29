Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaE2Xs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:48:58 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:64003 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaE2Xsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:48:55 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH] CMA: correct unlock target
In-Reply-To: <1401344958-3790-1-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1401344958-3790-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140529:linux-kernel@vger.kernel.org::s64zZrzn5ZCSH4kQ:0000000000000000000000000000000000oLC
X-Hashcash: 1:20:140529:linux-arm-kernel@lists.infradead.org::oaH0eC67+d+3NeMY:00000000000000000000000001RM7
X-Hashcash: 1:20:140529:m.szyprowski@samsung.com::/3OIPK5+ZuE9zvuH:00000000000000000000000000000000000001/br
X-Hashcash: 1:20:140529:iamjoonsoo.kim@lge.com::paKswakM1yGuPGOf:0000000000000000000000000000000000000003wYI
X-Hashcash: 1:20:140529:linux@arm.linux.org.uk::UrnxFZkvc7ERtDYv:0000000000000000000000000000000000000005TPR
X-Hashcash: 1:20:140529:iamjoonsoo.kim@lge.com::MSF6JYDczeKT9L0d:000000000000000000000000000000000000000Cg16
X-Hashcash: 1:20:140529:lauraa@codeaurora.org::gV3cRV/hg+r3Tf6U:0000000000000000000000000000000000000000E6Vo
Date: Fri, 30 May 2014 08:48:49 +0900
Message-ID: <xa1tfvjsno2m.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 'cma: Remove potential deadlock situation' introduces per cma area mutex
> for bitmap management. It is good, but there is one mistake. When we
> can't find appropriate area in bitmap, we release cma_mutex global lock
> rather than cma->lock and this is a bug. So fix it.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 6f6bffc..83969f8 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -331,7 +331,7 @@ struct page *dma_alloc_from_contiguous(struct device *dev, int count,
>  		pageno = bitmap_find_next_zero_area(cma->bitmap, cma->count,
>  						    start, count, mask);
>  		if (pageno >= cma->count) {
> -			mutex_unlock(&cma_mutex);
> +			mutex_unlock(&cma->lock);
>  			break;
>  		}
>  		bitmap_set(cma->bitmap, pageno, count);
> -- 
> 1.7.9.5

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
