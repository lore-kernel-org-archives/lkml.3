Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaJWIOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:14:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45990 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaJWIOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:14:43 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 23 Oct 2014 17:15:44 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: cl@linux.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com,
        vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org
Subject: Re: +
 mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
 added to -mm tree
Message-ID: <20141023081543.GB7598@js1304-P5Q-DELUXE>
References: <543d8d58.g9K7YpzF5ZOXeQqj%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543d8d58.g9K7YpzF5ZOXeQqj%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 01:53:44PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/compaction.c: avoid premature range skip in isolate_migratepages_range
> has been added to the -mm tree.  Its filename is
>      mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Subject: mm/compaction.c: avoid premature range skip in isolate_migratepages_range
> 
> commit edc2ca612496 ("mm, compaction: move pageblock checks up from
> isolate_migratepages_range()") commonizes isolate_migratepages variants
> and make them use isolate_migratepages_block().
> 
> isolate_migratepages_block() could stop the execution when enough pages
> are isolated, but, there is no code in isolate_migratepages_range() to
> handle this case.  In the result, even if isolate_migratepages_block()
> returns prematurely without checking all pages in the range,
> 
> isolate_migratepages_block() is called repeately on the following
> pageblock and some pages in the previous range are skipped to check.
> Then, CMA is failed frequently due to this fact.
> 
> To fix this problem, this patch let isolate_migratepages_range() know the
> situation that enough pages are isolated and stop the isolation in that
> case.
> 
> Note that isolate_migratepages() has no such problem, because, it always
> stops the isolation after just one call of isolate_migratepages_block().
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hello, Andrew.

I forgot to mention that this should be merged for v3.18. :)

Thanks.
