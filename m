Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaJOJOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:14:55 -0400
Received: from mta-out1.inet.fi ([62.71.2.197]:46741 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaJOJOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:14:54 -0400
Date: Wed, 15 Oct 2014 12:14:39 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: verify compound order when freeing a page
Message-ID: <20141015091439.GC12538@node.dhcp.inet.fi>
References: <1413317800-25450-1-git-send-email-yuzhao@google.com>
 <1413317800-25450-2-git-send-email-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413317800-25450-2-git-send-email-yuzhao@google.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 01:16:40PM -0700, Yu Zhao wrote:
> This allows us to easily catch the bug fixed in previous patch.
> 
> Here we also verify whether a page is tail page or not -- tail
> pages are supposed to be freed along with their head, not by
> themselves.
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  mm/page_alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 736d8e1..2bcc770 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -750,6 +750,9 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
>  	int i;
>  	int bad = 0;
>  
> +	VM_BUG_ON(PageTail(page));
> +	VM_BUG_ON(PageHead(page) && compound_order(page) != order);
> +

Use VM_BUG_ON_PAGE(), please.

>  	trace_mm_page_free(page, order);
>  	kmemcheck_free_shadow(page, order);
>  
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
