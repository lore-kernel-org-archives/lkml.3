Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbbAIP6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:58:48 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:48913 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbbAIP6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:58:45 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: "George G. Davis" <ggdavisiv@gmail.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "George G. Davis" <george_davis@mentor.com>
Subject: Re: [PATCH] mm: cma: Fix totalcma_pages to include DT defined CMA regions
In-Reply-To: <1420812065-129868-1-git-send-email-george_davis@mentor.com>
Organization: http://mina86.com/
References: <1420812065-129868-1-git-send-email-george_davis@mentor.com>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:150109:iamjoonsoo.kim@lge.com::BIDfzj3SVwjosOsm:0000000000000000000000000000000000000000HpW
X-Hashcash: 1:20:150109:laurent.pinchart+renesas@ideasonboard.com::7es3X1OZPMgJyrvj:000000000000000000000w0H
X-Hashcash: 1:20:150109:linux-kernel@vger.kernel.org::tn0PRLIn+D58fQyY:0000000000000000000000000000000000i2g
X-Hashcash: 1:20:150109:ggdavisiv@gmail.com::SXk+zWK6NGWqm112:0000000000000000000000000000000000000000001jzP
X-Hashcash: 1:20:150109:akpm@linux-foundation.org::bS6l3jF2O23v3JUM:0000000000000000000000000000000000001klZ
X-Hashcash: 1:20:150109:george_davis@mentor.com::XS+gasmMxvWkwGPc:0000000000000000000000000000000000000024Ms
X-Hashcash: 1:20:150109:m.szyprowski@samsung.com::kyyYlkUhCCWDBMak:00000000000000000000000000000000000002lX6
X-Hashcash: 1:20:150109:aneesh.kumar@linux.vnet.ibm.com::9ZV4H+TxmtmMQAvi:0000000000000000000000000000007B60
Date: Fri, 09 Jan 2015 16:58:41 +0100
Message-ID: <xa1t4ms0kksu.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09 2015, "George G. Davis" <ggdavisiv@gmail.com> wrote:
> The totalcma_pages variable is not updated to account for CMA regions
> defined via device tree reserved-memory sub-nodes.  Fix this omission by
> moving the calculation of totalcma_pages into cma_init_reserved_mem()
> instead of cma_declare_contiguous() such that it will include reserved
> memory used by all CMA regions.
>
> Signed-off-by: George G. Davis <george_davis@mentor.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  mm/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index a85ae28..75016fd 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -199,6 +199,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>  	cma->order_per_bit = order_per_bit;
>  	*res_cma = cma;
>  	cma_area_count++;
> +	totalcma_pages += (size / PAGE_SIZE);
>  
>  	return 0;
>  }
> @@ -337,7 +338,6 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  	if (ret)
>  		goto err;
>  
> -	totalcma_pages += (size / PAGE_SIZE);
>  	pr_info("Reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
>  		&base);
>  	return 0;
> -- 
> 1.9.3
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
