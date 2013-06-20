Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3FTNSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:18:06 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44670 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3FTNSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:18:03 -0400
Message-ID: <51C300FF.50208@gmail.com>
Date: Thu, 20 Jun 2013 21:17:51 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: bcrl@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] page_isolation: Fix a comment typo in test_pages_isolated()
References: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com> <1371723023-4060-2-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1371723023-4060-2-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 06:10 PM, Tang Chen wrote:
> pageblock_nr_page should be pageblock_nr_pages, and fist is
> a typo of first.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  mm/page_isolation.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 383bdbb..0cee10f 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -226,9 +226,9 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
>  	int ret;
>  
>  	/*
> -	 * Note: pageblock_nr_page != MAX_ORDER. Then, chunks of free page
> -	 * is not aligned to pageblock_nr_pages.
> -	 * Then we just check pagetype fist.
> +	 * Note: pageblock_nr_pages != MAX_ORDER. Then, chunks of free pages

pageblock_nr_pages is the count of pages while MAX_ORDER is a order. Here
may be pageblock_order != MAX_ORDER.

> +	 * are not aligned to pageblock_nr_pages.
> +	 * Then we just check migratetype first.
>  	 */
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
>  		page = __first_valid_page(pfn, pageblock_nr_pages);
> @@ -238,7 +238,7 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
>  	page = __first_valid_page(start_pfn, end_pfn - start_pfn);
>  	if ((pfn < end_pfn) || !page)
>  		return -EBUSY;
> -	/* Check all pages are free or Marked as ISOLATED */
> +	/* Check all pages are free or marked as ISOLATED */
>  	zone = page_zone(page);
>  	spin_lock_irqsave(&zone->lock, flags);
>  	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn,


-- 
Thanks.
Zhang Yanfei
