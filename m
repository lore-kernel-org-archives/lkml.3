Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab3LFOVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:21:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3LFOVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:21:06 -0500
Message-ID: <52A1DD4B.7020003@suse.cz>
Date: Fri, 06 Dec 2013 15:20:59 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm/compaction: respect ignore_skip_hint in update_pageblock_skip
References: <1386319310-28016-1-git-send-email-iamjoonsoo.kim@lge.com> <1386319310-28016-4-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1386319310-28016-4-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 09:41 AM, Joonsoo Kim wrote:
> update_pageblock_skip() only fits to compaction which tries to isolate by
> pageblock unit. If isolate_migratepages_range() is called by CMA, it try to
> isolate regardless of pageblock unit and it don't reference
> get_pageblock_skip() by ignore_skip_hint. We should also respect it on
> update_pageblock_skip() to prevent from setting the wrong information.

Yeah, this will also prevent updating cached migrate scanner pfn, which 
makes perfect sense, as cma doesn't read them.

> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> diff --git a/mm/compaction.c b/mm/compaction.c
> index 805165b..f58bcd0 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -134,6 +134,10 @@ static void update_pageblock_skip(struct compact_control *cc,
>   			bool migrate_scanner)
>   {
>   	struct zone *zone = cc->zone;
> +
> +	if (cc->ignore_skip_hint)
> +		return;
> +
>   	if (!page)
>   		return;
>
>

