Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaBJAqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:46:23 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40768 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaBJAqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:46:22 -0500
X-Original-SENDERIP: 10.177.222.179
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 10 Feb 2014 09:46:26 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mm/compaction: check pageblock suitability once per
 pageblock
Message-ID: <20140210004626.GC12049@lge.com>
References: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1391749726-28910-5-git-send-email-iamjoonsoo.kim@lge.com>
 <52F4B5AA.2040006@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F4B5AA.2040006@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 11:30:02AM +0100, Vlastimil Babka wrote:
> On 02/07/2014 06:08 AM, Joonsoo Kim wrote:
> > isolation_suitable() and migrate_async_suitable() is used to be sure
> > that this pageblock range is fine to be migragted. It isn't needed to
> > call it on every page. Current code do well if not suitable, but, don't
> > do well when suitable. It re-check it on every valid pageblock.
> > This patch fix this situation by updating last_pageblock_nr.
> 
> It took me a while to understand that the problem with migrate_async_suitable() was the
> lack of last_pageblock_nr updates (when the code doesn't go through next_pageblock:
> label), while the problem with isolation_suitable() was the lack of doing the test only
> when last_pageblock_nr != pageblock_nr (so two different things). How bout making it
> clearer in the changelog by replacing the paragraph above with something like:

Really nice!!
Sorry for bad description and thanks for taking time to understand it.

> 
> <snip>
> isolation_suitable() and migrate_async_suitable() is used to be sure
> that this pageblock range is fine to be migragted. It isn't needed to
> call it on every page. Current code do well if not suitable, but, don't
> do well when suitable.
> 
> 1) It re-checks isolation_suitable() on each page of a pageblock that was already
> estabilished as suitable.
> 2) It re-checks migrate_async_suitable() on each page of a pageblock that was not entered
> through the next_pageblock: label, because last_pageblock_nr is not otherwise updated.
> 
> This patch fixes situation by 1) calling isolation_suitable() only once per pageblock and
> 2) always updating last_pageblock_nr to the pageblock that was just checked.
> </snip>
> 
> > Additionally, move PageBuddy() check after pageblock unit check,
> > since pageblock check is the first thing we should do and makes things
> > more simple.
> 
> You should also do this, since it becomes redundant and might only confuse people:
> 
>  next_pageblock:
>                  low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
> -                last_pageblock_nr = pageblock_nr;
> 

Okay.

> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> With the above resolved, consider the patch to be
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

I will do it.
Thanks!
