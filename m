Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaKDFl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:41:56 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:40800 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaKDFlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:41:55 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 4 Nov 2014 14:43:07 +0900
From: Minchan Kim <minchan@kernel.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: alloc_contig_range: demote pages busy message from
 warn to info
Message-ID: <20141104054307.GA23102@bbox>
References: <2457604.k03RC2Mv4q@avalon>
 <1415033873-28569-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415033873-28569-1-git-send-email-mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 03, 2014 at 05:57:53PM +0100, Michal Nazarewicz wrote:
> Having test_pages_isolated failure message as a warning confuses
> users into thinking that it is more serious than it really is.  In
> reality, if called via CMA, allocation will be retried so a single
> test_pages_isolated failure does not prevent allocation from
> succeeding.
> 
> Demote the warning message to an info message and reformat it such
> that the text “failed” does not appear and instead a less worrying
> “PFNS busy” is used.

What do you expect from this message? Please describe it so that we can
review below message helps your goal.

> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  mm/page_alloc.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 372e3f3..e2731eb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6431,13 +6431,12 @@ int alloc_contig_range(unsigned long start, unsigned long end,
>  
>  	/* Make sure the range is really isolated. */
>  	if (test_pages_isolated(outer_start, end, false)) {
> -		pr_warn("alloc_contig_range test_pages_isolated(%lx, %lx) failed\n",
> -		       outer_start, end);
> +		pr_info("%s: [%lx, %lx) PFNs busy\n",
> +			__func__, outer_start, end);
>  		ret = -EBUSY;
>  		goto done;
>  	}
>  
> -
>  	/* Grab isolated pages from freelists. */
>  	outer_end = isolate_freepages_range(&cc, outer_start, end);
>  	if (!outer_end) {
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
