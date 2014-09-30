Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaI3H12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:27:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaI3H11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:27:27 -0400
Message-ID: <542A5B5B.7060207@suse.cz>
Date: Tue, 30 Sep 2014 09:27:23 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, mgorman@suse.de, rientjes@google.com,
        minchan@kernel.org
Subject: Re: [PATCH] mm, compaction: using uninitialized_var insteads setting
 'flags' to 0 directly.
References: <1411961425-8045-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1411961425-8045-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 05:30 AM, Xiubo Li wrote:
> Setting 'flags' to zero will be certainly a misleading way to avoid
> warning of 'flags' may be used uninitialized. uninitialized_var is
> a correct way because the warning is a false possitive.

Agree.

> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/compaction.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 92075d5..59a116d 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -344,7 +344,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  {
>  	int nr_scanned = 0, total_isolated = 0;
>  	struct page *cursor, *valid_page = NULL;
> -	unsigned long flags = 0;
> +	unsigned long uninitialized_var(flags);
>  	bool locked = false;
>  	unsigned long blockpfn = *start_pfn;
>  
> @@ -573,7 +573,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  	unsigned long nr_scanned = 0, nr_isolated = 0;
>  	struct list_head *migratelist = &cc->migratepages;
>  	struct lruvec *lruvec;
> -	unsigned long flags = 0;
> +	unsigned long uninitialized_var(flags);
>  	bool locked = false;
>  	struct page *page = NULL, *valid_page = NULL;
>  
> 

