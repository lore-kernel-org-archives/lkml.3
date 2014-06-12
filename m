Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaFLJrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:47:24 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63161 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbaFLJrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:47:21 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 02/10] DMA, CMA: fix possible memory leak
In-Reply-To: <1402543307-29800-3-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140612:minchan@kernel.org::0JZ/9+M/gBjuu7W/:00000000000000000000000000000000000000000000aEO
X-Hashcash: 1:20:140612:agraf@suse.de::zP1xxpbpZ5CyvS4Z:00000w04
X-Hashcash: 1:20:140612:paulus@samba.org::JXjHk/c2aLReyp/E:01XvZ
X-Hashcash: 1:20:140612:linuxppc-dev@lists.ozlabs.org::8jgZz7sR9R9yjWMd:000000000000000000000000000000001wz5
X-Hashcash: 1:20:140612:gleb@kernel.org::aGrWuRKlYyX93Ao7:002GmC
X-Hashcash: 1:20:140612:m.szyprowski@samsung.com::cFcg6Z3TrVf+XAx5:00000000000000000000000000000000000002cZx
X-Hashcash: 1:20:140612:kvm-ppc@vger.kernel.org::eQ/sl1ezl0zJy7/J:000000000000000000000000000000000000003vJz
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::H8QVtN0kFhaobgzg:0000000000000000000000000000000000000004JO2
X-Hashcash: 1:20:140612:aneesh.kumar@linux.vnet.ibm.com::yS3TW5RsGrUA+O7p:0000000000000000000000000000004AND
X-Hashcash: 1:20:140612:gregkh@linuxfoundation.org::3pn7k25RAp/O11IE:000000000000000000000000000000000004oxA
X-Hashcash: 1:20:140612:kvm@vger.kernel.org::6o505WAacegLSigG:0000000000000000000000000000000000000000004fzf
X-Hashcash: 1:20:140612:linux-arm-kernel@lists.infradead.org::A5trvzh7wBTZmpYp:00000000000000000000000004xf1
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::yIZHhkrb1EivzYlX:00000000000000000000000000000000000055TX
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::OkIaC9e87GGIQMuG:0000000000000000000000000000000000000006QDy
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::z0Btsqp0AOmqrZP4:0000000000000000000000000000000006CcJ
X-Hashcash: 1:20:140612:pbonzini@redhat.com::yMD/OnBtbKG9eaNM:0000000000000000000000000000000000000000007GGg
X-Hashcash: 1:20:140612:benh@kernel.crashing.org::11WTEYe6e7dqvxUg:00000000000000000000000000000000000007Rd+
X-Hashcash: 1:20:140612:linux@arm.linux.org.uk::7sSkdVHjBtSQsvqi:0000000000000000000000000000000000000008mbT
X-Hashcash: 1:20:140612:linux-mm@kvack.org::YUCUueLr6HIOQCSi:0000000000000000000000000000000000000000000CLgq
Date: Thu, 12 Jun 2014 11:47:16 +0200
Message-ID: <xa1tha3qjw7v.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> We should free memory for bitmap when we find zone mis-match,
> otherwise this memory will leak.
>
> Additionally, I copy code comment from ppc kvm's cma code to notify
> why we need to check zone mis-match.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index bd0bb81..fb0cdce 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -177,14 +177,24 @@ static int __init cma_activate_area(struct cma *cma)
>  		base_pfn = pfn;
>  		for (j = pageblock_nr_pages; j; --j, pfn++) {
>  			WARN_ON_ONCE(!pfn_valid(pfn));
> +			/*
> +			 * alloc_contig_range requires the pfn range
> +			 * specified to be in the same zone. Make this
> +			 * simple by forcing the entire CMA resv range
> +			 * to be in the same zone.
> +			 */
>  			if (page_zone(pfn_to_page(pfn)) != zone)
> -				return -EINVAL;
> +				goto err;
>  		}
>  		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
>  	} while (--i);
>  
>  	mutex_init(&cma->lock);
>  	return 0;
> +
> +err:
> +	kfree(cma->bitmap);
> +	return -EINVAL;
>  }

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
