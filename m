Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab3BSN2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:28:04 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40620 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624Ab3BSN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:28:03 -0500
Message-ID: <51237DDB.2050305@gmail.com>
Date: Tue, 19 Feb 2013 21:27:55 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mgorman@suse.de, kyungmin.park@samsung.com
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high memory
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com> <20130204233430.GA2610@blaptop> <5110B05B.5070109@samsung.com>
In-Reply-To: <5110B05B.5070109@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 03:10 PM, Marek Szyprowski wrote:
> Hello,
>
> On 2/5/2013 12:34 AM, Minchan Kim wrote:
>> On Mon, Feb 04, 2013 at 11:27:05AM +0100, Marek Szyprowski wrote:
>> > The total number of low memory pages is determined as
>> > totalram_pages - totalhigh_pages, so without this patch all CMA
>> > pageblocks placed in highmem were accounted to low memory.
>>
>> So what's the end user effect? With the effect, we have to decide
>> routing it on stable.
>>
>> >
>> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> > ---
>> >  mm/page_alloc.c |    4 ++++
>> >  1 file changed, 4 insertions(+)
>> >
>> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> > index f5bab0a..6415d93 100644
>> > --- a/mm/page_alloc.c
>> > +++ b/mm/page_alloc.c
>> > @@ -773,6 +773,10 @@ void __init init_cma_reserved_pageblock(struct 
>> page *page)
>> >      set_pageblock_migratetype(page, MIGRATE_CMA);
>> >      __free_pages(page, pageblock_order);
>> >      totalram_pages += pageblock_nr_pages;
>> > +#ifdef CONFIG_HIGHMEM
>>
>> We don't need #ifdef/#endif.
>
> #ifdef is required to let this code compile when highmem is not enabled,
> becuase totalhigh_pages is defined as 0, see include/linux/highmem.h
>

Hi Marek,

1) Why can support CMA regions placed in highmem? CMA is for dma buffer, 
correct? Then how can old dma device access highmem?
2) Why there is no totalhigh_pages variable define in the case of config 
highmem?

>> > +    if (PageHighMem(page))
>> > +        totalhigh_pages += pageblock_nr_pages;
>> > +#endif
>> >  }
>> >  #endif
>> >
>
> Best regards

