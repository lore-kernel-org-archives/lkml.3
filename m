Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaFBKsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:48:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37775 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaFBKsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:48:00 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-33-538c5654bf95
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Joonsoo Kim <js1304@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Laura Abbott <lauraa@codeaurora.org>,
        Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nagachandra P <nagachandra@gmail.com>,
        Vinayak Menon <menon.vinayak@gmail.com>,
        Ritesh Harjani <ritesh.harjani@gmail.com>, t.stanislaws@samsung.com
Subject: Re: [PATCH v2 3/3] CMA: always treat free cma pages as non-free on
 watermark checking
Date: Mon, 02 Jun 2014 12:47:24 +0200
Message-id: <4424609.WQEPaWUrpH@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CALk7dXo6M1op0q2xiEW=9dEwOm1pK8C+gSTadJiAL071xJycCQ@mail.gmail.com>
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com>
 <CAAmzW4OKO0005+-MuTrENHnMZKkJjk9aOx2vBDNoXN8==TWTew@mail.gmail.com>
 <CALk7dXo6M1op0q2xiEW=9dEwOm1pK8C+gSTadJiAL071xJycCQ@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jAd2QsJ5gg55FEhZz1q9hs3j8eh6L
	xepNvhYHZy9hsljZ3cxmMXPvXFaL7Z0z2C0u75rDZnFvzX9Wi7VH7rJbXDw3m8li8rtnjBYL
	jrewWiz7+p7dYuOlrSwWf6+sZ7F4frGb3eLgqQ52i3ntL1kdhD0Ov3nP7HG5r5fJY+esu+we
	m1Z1snls+jSJ3aPr7RUmjxMzfrN4PDi0mcVj3Z9XTB7v911l8+jbsorRY/Ppao/Pm+QCeKO4
	bFJSczLLUov07RK4Mh7NP8RWcMq0YvqR4gbGWxpdjJwcEgImEjPe7WCBsMUkLtxbz9bFyMUh
	JLCIUWLzrAlMEE4Lk8Tj77PZQarYBKwkJravYgSxRQS0JC6dPAUWZxa4zCqx9qstiC0skCDR
	dq0VrIZFQFXizvS3YDavgKZE3+pmVhBbVMBTYsf2lWwgNqdAsETz1r3MEMuuMErcWHOUGaJB
	UOLH5HssEAvkJfbtn8oKYatLTJq3iHkCo8AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZwrD6T3sG4qsHiEKMAB6MSD+8P9Z5gIdbEsuLK3EOMEhzMSiK8Sy2AQrwp
	iZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhgLuZmE9P6zVdYq
	OpYw5M/WKTgY3Zf7bI2wcmqrbBfTtoP3HRk7OFudji/6PHNK30J1lphv5RfY51m37f64LL7h
	v7eyyDZ31oCdzy/MPNO2ud1M9JeJ00m/+oZli6de2nJU9uUO7cZT3Y/De8I++PxJDt1wq/Cz
	xM1dfgvnH4vMblBmD4o7F6HEUpyRaKjFXFScCADLzeUJ0QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, June 02, 2014 09:37:49 AM Ritesh Harjani wrote:
> Hi Joonsoo,
> 
> CC'ing the developer of the patch (Tomasz Stanislawski)
> 
> 
> On Fri, May 30, 2014 at 8:16 PM, Joonsoo Kim <js1304@gmail.com> wrote:
> > 2014-05-30 19:40 GMT+09:00 Ritesh Harjani <ritesh.list@gmail.com>:
> >> Hi Joonsoo,
> >>
> >> I think you will be loosing the benefit of below patch with your changes.
> >> I am no expert here so please bear with me. I tried explaining in the
> >> inline comments, let me know if I am wrong.
> >>
> >> commit 026b08147923142e925a7d0aaa39038055ae0156
> >> Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> Date:   Wed Jun 12 14:05:02 2013 -0700
> >
> > Hello, Ritesh.
> >
> > Thanks for notifying that.
> >
> >>
> >> On Wed, May 28, 2014 at 12:34 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> >>> commit d95ea5d1('cma: fix watermark checking') introduces ALLOC_CMA flag

It is a bit of shame that the author of commit d95ea5d1 (happens to be me :)
was not on cc:.

> >>> for alloc flag and treats free cma pages as free pages if this flag is
> >>> passed to watermark checking. Intention of that patch is that movable page
> >>> allocation can be be handled from cma reserved region without starting
> >>> kswapd. Now, previous patch changes the behaviour of allocator that
> >>> movable allocation uses the page on cma reserved region aggressively,
> >>> so this watermark hack isn't needed anymore. Therefore remove it.
> >>>
> >>> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> >>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >>>
> >>> diff --git a/mm/compaction.c b/mm/compaction.c
> >>> index 627dc2e..36e2fcd 100644
> >>> --- a/mm/compaction.c
> >>> +++ b/mm/compaction.c
> >>> @@ -1117,10 +1117,6 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
> >>>
> >>>         count_compact_event(COMPACTSTALL);
> >>>
> >>> -#ifdef CONFIG_CMA
> >>> -       if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> >>> -               alloc_flags |= ALLOC_CMA;
> >>> -#endif
> >>>         /* Compact each zone in the list */
> >>>         for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
> >>>                                                                 nodemask) {
> >>> diff --git a/mm/internal.h b/mm/internal.h
> >>> index 07b6736..a121762 100644
> >>> --- a/mm/internal.h
> >>> +++ b/mm/internal.h
> >>> @@ -384,7 +384,6 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
> >>>  #define ALLOC_HARDER           0x10 /* try to alloc harder */
> >>>  #define ALLOC_HIGH             0x20 /* __GFP_HIGH set */
> >>>  #define ALLOC_CPUSET           0x40 /* check for correct cpuset */
> >>> -#define ALLOC_CMA              0x80 /* allow allocations from CMA areas */
> >>> -#define ALLOC_FAIR             0x100 /* fair zone allocation */
> >>> +#define ALLOC_FAIR             0x80 /* fair zone allocation */
> >>>
> >>>  #endif /* __MM_INTERNAL_H */
> >>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>> index ca678b6..83a8021 100644
> >>> --- a/mm/page_alloc.c
> >>> +++ b/mm/page_alloc.c
> >>> @@ -1764,20 +1764,22 @@ static bool __zone_watermark_ok(struct zone *z, int order, unsigned long mark,
> >>>         long min = mark;
> >>>         long lowmem_reserve = z->lowmem_reserve[classzone_idx];
> >>>         int o;
> >>> -       long free_cma = 0;
> >>>
> >>>         free_pages -= (1 << order) - 1;
> >>>         if (alloc_flags & ALLOC_HIGH)
> >>>                 min -= min / 2;
> >>>         if (alloc_flags & ALLOC_HARDER)
> >>>                 min -= min / 4;
> >>> -#ifdef CONFIG_CMA
> >>> -       /* If allocation can't use CMA areas don't use free CMA pages */
> >>> -       if (!(alloc_flags & ALLOC_CMA))
> >>> -               free_cma = zone_page_state(z, NR_FREE_CMA_PAGES);
> >>> -#endif
> >>> +       /*
> >>> +        * We don't want to regard the pages on CMA region as free
> >>> +        * on watermark checking, since they cannot be used for
> >>> +        * unmovable/reclaimable allocation and they can suddenly
> >>> +        * vanish through CMA allocation
> >>> +        */
> >>> +       if (IS_ENABLED(CONFIG_CMA) && z->managed_cma_pages)
> >>> +               free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
> >>
> >> make this free_cma instead of free_pages.
> >>
> >>>
> >>> -       if (free_pages - free_cma <= min + lowmem_reserve)
> >>> +       if (free_pages <= min + lowmem_reserve)
> >> free_pages - free_cma <= min + lowmem_reserve
> >>
> >> Because in for loop you subtract nr_free which includes the CMA pages.
> >> So if you have subtracted NR_FREE_CMA_PAGES
> >> from free_pages above then you will be subtracting cma pages again in
> >> nr_free (below in for loop).
> >
> > Yes, I understand the problem you mentioned.
> >
> > I think that this is complicated issue.
> >
> > Comit '026b081' you mentioned makes watermark_ok() loose for high order
> > allocation compared to kernel that CMA isn't enabled, since free_pages includes
> > free_cma pages and most of high order allocation except THP would be
> > non-movable allocation. This non-movable allocation can't use cma pages,
> > so we shouldn't include free_cma pages.
> >
> > If most of free cma pages are 0 order, that commit works correctly. We subtract
> > nr of free cma pages at the first loop, so there is no problem. But,
> > if the system
> > have some free high-order cma pages, watermark checking allow high-order
> > allocation more easily.
> > 
> > I think that loosing the watermark check is right solution so will takes your
> > comment on v2. But I want to know other developer's opinion.
> 
> Thanks for giving this a thought for your v2 patch.
> 
> 
> > If needed, I can implement to track free_area[o].nr_cma_free and use it for
> > precise freepage calculation in watermark check.
> >
> I guess implementing nr_cma_free would be the correct solution.
> Because currently for other than 0 order allocation
> we still consider high order free_cma pages as free pages in the for
> loop which from the code looks incorrect.
> 
> This can lead to situation when we have more high order free CMA pages
> but very less unmovable pages, but zone_watermark returns
> ok for unmovable page, thus leading to allocation failure every time
> instead of recovering from this situation.
> 
> But its better if experts comment on this.

I think that implementing free_area[].nr_cma_free is a correct long-term
solution and it should be done before the current patch gets applied.

[ Tomasz is on holiday currently but he should be back tomorrow so he can
  also take a look at the issue. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

