Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbaFLKUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:20:03 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45740 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906AbaFLKT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:19:59 -0400
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
Subject: Re: [PATCH v2 05/10] DMA, CMA: support arbitrary bitmap granularity
In-Reply-To: <1402543307-29800-6-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-6-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140612:linux-mm@kvack.org::e6QJM/pU06hGR2Y7:00000000000000000000000000000000000000000000Itz
X-Hashcash: 1:20:140612:linux@arm.linux.org.uk::nlOZUu8zW8sAZQRo:0000000000000000000000000000000000000000qn5
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::YmtvqBaPA2jYy+n7:0000000000000000000000000000000000000qII
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::TbClhNnCJ9Exo/IX:0000000000000000000000000000000000000001fqG
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::7PfF7G2u/jkwqUnN:0000000000000000000000000000000000000002IM/
X-Hashcash: 1:20:140612:linux-arm-kernel@lists.infradead.org::tuVrgwKj0NNyn528:00000000000000000000000001jin
X-Hashcash: 1:20:140612:pbonzini@redhat.com::O/myx62sSdvV3f/x:00000000000000000000000000000000000000000020Sq
X-Hashcash: 1:20:140612:aneesh.kumar@linux.vnet.ibm.com::mvNg3ffgUnskGPge:000000000000000000000000000000248V
X-Hashcash: 1:20:140612:gregkh@linuxfoundation.org::Sxbx+98G4Kobk3w5:000000000000000000000000000000000002uPA
X-Hashcash: 1:20:140612:gleb@kernel.org::XDXgT4WhaVj02+5P:003ZA7
X-Hashcash: 1:20:140612:agraf@suse.de::it30KRE+9sI7QIUx:00003Ysv
X-Hashcash: 1:20:140612:minchan@kernel.org::L5/yI05+CksiJD+o:000000000000000000000000000000000000000000039Bv
X-Hashcash: 1:20:140612:m.szyprowski@samsung.com::6Eusa0H/U8b44wOd:00000000000000000000000000000000000003G71
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::M2DqJjUyKxrEzG5k:0000000000000000000000000000000003u+S
X-Hashcash: 1:20:140612:benh@kernel.crashing.org::iaDWXGxUBl3l0Fx0:0000000000000000000000000000000000000447T
X-Hashcash: 1:20:140612:linuxppc-dev@lists.ozlabs.org::M9SavQl8jPcko7nd:000000000000000000000000000000005tR7
X-Hashcash: 1:20:140612:kvm@vger.kernel.org::I0A8heowtUeRU7rE:0000000000000000000000000000000000000000005IXx
X-Hashcash: 1:20:140612:paulus@samba.org::eyRukmjzDaiZPTpc:0956Z
X-Hashcash: 1:20:140612:kvm-ppc@vger.kernel.org::JyppBseu76Pf+tKm:00000000000000000000000000000000000000D4qi
Date: Thu, 12 Jun 2014 12:19:54 +0200
Message-ID: <xa1t61k6juph.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> ppc kvm's cma region management requires arbitrary bitmap granularity,
> since they want to reserve very large memory and manage this region
> with bitmap that one bit for several pages to reduce management overheads.
> So support arbitrary bitmap granularity for following generalization.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index bc4c171..9bc9340 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -38,6 +38,7 @@ struct cma {
>  	unsigned long	base_pfn;
>  	unsigned long	count;

Have you considered replacing count with maxno?

>  	unsigned long	*bitmap;
> +	int order_per_bit; /* Order of pages represented by one bit */

I'd make it unsigned.

>  	struct mutex	lock;
>  };
>  
> +static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int
> count)

For consistency cma_clear_bitmap would make more sense I think.  On the
other hand, you're just moving stuff around so perhaps renaming the
function at this point is not worth it any more.

> +{
> +	unsigned long bitmapno, nr_bits;
> +
> +	bitmapno = (pfn - cma->base_pfn) >> cma->order_per_bit;
> +	nr_bits = cma_bitmap_pages_to_bits(cma, count);
> +
> +	mutex_lock(&cma->lock);
> +	bitmap_clear(cma->bitmap, bitmapno, nr_bits);
> +	mutex_unlock(&cma->lock);
> +}
> +
>  static int __init cma_activate_area(struct cma *cma)
>  {
> -	int bitmap_size = BITS_TO_LONGS(cma->count) * sizeof(long);
> +	int bitmap_maxno = cma_bitmap_maxno(cma);
> +	int bitmap_size = BITS_TO_LONGS(bitmap_maxno) * sizeof(long);
>  	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
>  	unsigned i = cma->count >> pageblock_order;
>  	struct zone *zone;

bitmap_maxno is never used again, perhaps:

+	int bitmap_size = BITS_TO_LONGS(cma_bitmap_maxno(cma)) * sizeof(long);

instead? Up to you.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
