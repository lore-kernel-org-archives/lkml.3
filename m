Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3BGBzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:55:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16598 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab3BGBzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:55:20 -0500
X-IronPort-AV: E=Sophos;i="4.84,619,1355068800"; 
   d="scan'208";a="6697922"
Message-ID: <51130927.7050805@cn.fujitsu.com>
Date: Thu, 07 Feb 2013 09:53:43 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: accurately document nr_free_*_pages functions with
 code comments
References: <5112138C.7040902@cn.fujitsu.com> <5112FB96.1040606@infradead.org>
In-Reply-To: <5112FB96.1040606@infradead.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/07 09:53:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/07 09:53:59
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月07日 08:55, Randy Dunlap 写道:
> On 02/06/13 00:25, Zhang Yanfei wrote:
>> Functions nr_free_zone_pages, nr_free_buffer_pages and nr_free_pagecache_pages
>> are horribly badly named, so accurately document them with code comments
>> in case of the misuse of them.
>>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> ---
>>  mm/page_alloc.c |   23 +++++++++++++++++++----
>>  1 files changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index df2022f..0790716 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -2785,6 +2785,15 @@ void free_pages_exact(void *virt, size_t size)
>>  }
>>  EXPORT_SYMBOL(free_pages_exact);
>>  
>> +/**
>> + * nr_free_zone_pages - get pages that is beyond high watermark
>> + * @offset - The zone index of the highest zone
> 
> Function parameter format uses a ':', not a '-'.  E.g.,
> 
>  * @offset: the zone index of the highest zone

Sorry for my mistake. Thanks for your review.

> 
> 
>> + *
>> + * The function counts pages which are beyond high watermark within
>> + * all zones at or below a given zone index. For each zone, the
>> + * amount of pages is calculated as:
>> + *     present_pages - high_pages
>> + */
>>  static unsigned int nr_free_zone_pages(int offset)
>>  {
>>  	struct zoneref *z;
>> @@ -2805,8 +2814,11 @@ static unsigned int nr_free_zone_pages(int offset)
>>  	return sum;
>>  }
>>  
>> -/*
>> - * Amount of free RAM allocatable within ZONE_DMA and ZONE_NORMAL
>> +/**
>> + * nr_free_buffer_pages - get pages that is beyond high watermark
>> + *
>> + * The function counts pages which are beyond high watermark within
>> + * ZONE_DMA and ZONE_NORMAL.
>>   */
>>  unsigned int nr_free_buffer_pages(void)
>>  {
>> @@ -2814,8 +2826,11 @@ unsigned int nr_free_buffer_pages(void)
>>  }
>>  EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
>>  
>> -/*
>> - * Amount of free RAM allocatable within all zones
>> +/**
>> + * nr_free_pagecache_pages - get pages that is beyond high watermark
>> + *
>> + * The function counts pages which are beyond high watermark within
>> + * all zones.
>>   */
>>  unsigned int nr_free_pagecache_pages(void)
>>  {
>>
> 
> 

