Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab3BEHK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:10:28 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39539 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3BEHK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:10:26 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-68-5110b06069f6
Message-id: <5110B05B.5070109@samsung.com>
Date: Tue, 05 Feb 2013 08:10:19 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
MIME-version: 1.0
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, kyungmin.park@samsung.com
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high memory
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
 <20130204233430.GA2610@blaptop>
In-reply-to: <20130204233430.GA2610@blaptop>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Vd2EDQKBBivuK1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MXWf4C7ZyVay+dp+tgXEpRxcjJ4eEgInEu/a/LBC2mMSFe+vZ
	uhi5OIQEljJKnD33jBnCWcIk8W37KmaQKl4BLYlXnZfAbBYBVYntr9aC2WwChhJdb7vYQGxR
	gVCJtfvWQNULSvyYfA9sg4iAisSfp/8YQWxmgVqJjosHweqFBfwljjxsZwKxhQQyJVo3Pwer
	5xTQkbixuoUVot5M4lHLOmYIW15i85q3zBMYBWYhWTELSdksJGULGJlXMYqmliYXFCel5xrq
	FSfmFpfmpesl5+duYoQE4JcdjIuPWR1iFOBgVOLhDbzGHyjEmlhWXJl7iFGCg1lJhPfjDaAQ
	b0piZVVqUX58UWlOavEhRiYOTqkGRqbMHt1Zao5Tyz5+kDh/Vfp9+frVwj4tfKvn/Jggf8LW
	yTJA+sOf6IJn0+2XaHuoa/K2xqgdmhomUDNJZBXXP+X3U68u/Gp8/Tf3y0v2t7Vl583euaR/
	QdaFlK+T1GbseMc/k3lnLZe591nbvwy/kxT/bKtw+WBv7rHBz/y2wI2M0g+MTpcen1BiKc5I
	NNRiLipOBACcldynHgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2/5/2013 12:34 AM, Minchan Kim wrote:
> On Mon, Feb 04, 2013 at 11:27:05AM +0100, Marek Szyprowski wrote:
> > The total number of low memory pages is determined as
> > totalram_pages - totalhigh_pages, so without this patch all CMA
> > pageblocks placed in highmem were accounted to low memory.
>
> So what's the end user effect? With the effect, we have to decide
> routing it on stable.
>
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  mm/page_alloc.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index f5bab0a..6415d93 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -773,6 +773,10 @@ void __init init_cma_reserved_pageblock(struct page *page)
> >  	set_pageblock_migratetype(page, MIGRATE_CMA);
> >  	__free_pages(page, pageblock_order);
> >  	totalram_pages += pageblock_nr_pages;
> > +#ifdef CONFIG_HIGHMEM
>
> We don't need #ifdef/#endif.

#ifdef is required to let this code compile when highmem is not enabled,
becuase totalhigh_pages is defined as 0, see include/linux/highmem.h

> > +	if (PageHighMem(page))
> > +		totalhigh_pages += pageblock_nr_pages;
> > +#endif
> >  }
> >  #endif
> >

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


