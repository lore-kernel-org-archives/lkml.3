Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3BGAzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:55:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:56784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BGAzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:55:16 -0500
Message-ID: <5112FB96.1040606@infradead.org>
Date: Wed, 06 Feb 2013 16:55:50 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: accurately document nr_free_*_pages functions with
 code comments
References: <5112138C.7040902@cn.fujitsu.com>
In-Reply-To: <5112138C.7040902@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/13 00:25, Zhang Yanfei wrote:
> Functions nr_free_zone_pages, nr_free_buffer_pages and nr_free_pagecache_pages
> are horribly badly named, so accurately document them with code comments
> in case of the misuse of them.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  mm/page_alloc.c |   23 +++++++++++++++++++----
>  1 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index df2022f..0790716 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2785,6 +2785,15 @@ void free_pages_exact(void *virt, size_t size)
>  }
>  EXPORT_SYMBOL(free_pages_exact);
>  
> +/**
> + * nr_free_zone_pages - get pages that is beyond high watermark
> + * @offset - The zone index of the highest zone

Function parameter format uses a ':', not a '-'.  E.g.,

 * @offset: the zone index of the highest zone


> + *
> + * The function counts pages which are beyond high watermark within
> + * all zones at or below a given zone index. For each zone, the
> + * amount of pages is calculated as:
> + *     present_pages - high_pages
> + */
>  static unsigned int nr_free_zone_pages(int offset)
>  {
>  	struct zoneref *z;
> @@ -2805,8 +2814,11 @@ static unsigned int nr_free_zone_pages(int offset)
>  	return sum;
>  }
>  
> -/*
> - * Amount of free RAM allocatable within ZONE_DMA and ZONE_NORMAL
> +/**
> + * nr_free_buffer_pages - get pages that is beyond high watermark
> + *
> + * The function counts pages which are beyond high watermark within
> + * ZONE_DMA and ZONE_NORMAL.
>   */
>  unsigned int nr_free_buffer_pages(void)
>  {
> @@ -2814,8 +2826,11 @@ unsigned int nr_free_buffer_pages(void)
>  }
>  EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
>  
> -/*
> - * Amount of free RAM allocatable within all zones
> +/**
> + * nr_free_pagecache_pages - get pages that is beyond high watermark
> + *
> + * The function counts pages which are beyond high watermark within
> + * all zones.
>   */
>  unsigned int nr_free_pagecache_pages(void)
>  {
> 


-- 
~Randy
