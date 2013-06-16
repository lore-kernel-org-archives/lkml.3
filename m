Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3FPSEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 14:04:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62157 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3FPSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 14:04:53 -0400
Date: Sun, 16 Jun 2013 11:04:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: Add unlikely for current_order test
In-Reply-To: <51BC4A83.50302@gmail.com>
Message-ID: <alpine.DEB.2.02.1306161103020.22688@chino.kir.corp.google.com>
References: <51BC4A83.50302@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Jun 2013, Zhang Yanfei wrote:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> Since we have an unlikely for the "current_order >= pageblock_order / 2"
> test above, adding an unlikely for this "current_order >= pageblock_order"
> test seems more appropriate.
> 

I don't understand the justification at all, current_order being unlikely 
greater than or equal to pageblock_order / 2 doesn't imply at all that 
it's unlikely that current_order is greater than or equal to 
pageblock_order.

> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c3edb62..1b6d7de 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1071,7 +1071,7 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>  			rmv_page_order(page);
>  
>  			/* Take ownership for orders >= pageblock_order */
> -			if (current_order >= pageblock_order &&
> +			if (unlikely(current_order >= pageblock_order) &&
>  			    !is_migrate_cma(migratetype))
>  				change_pageblock_range(page, current_order,
>  							start_migratetype);
