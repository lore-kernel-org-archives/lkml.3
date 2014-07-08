Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaGHEpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:45:19 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:35036 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaGHEpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:45:17 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 8 Jul 2014 13:45:18 +0900
From: Minchan Kim <minchan@kernel.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v10 1/7] mm: support madvise(MADV_FREE)
Message-ID: <20140708044518.GA9824@bbox>
References: <1404694438-10272-1-git-send-email-minchan@kernel.org>
 <1404694438-10272-2-git-send-email-minchan@kernel.org>
 <53BB6B64.1080807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53BB6B64.1080807@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Zhang,

On Tue, Jul 08, 2014 at 11:54:12AM +0800, Zhang Yanfei wrote:
> Hi Minchan,
> 
> On 07/07/2014 08:53 AM, Minchan Kim wrote:
> > Linux doesn't have an ability to free pages lazy while other OS
> > already have been supported that named by madvise(MADV_FREE).
> > 
> > The gain is clear that kernel can discard freed pages rather than
> > swapping out or OOM if memory pressure happens.
> > 
> > Without memory pressure, freed pages would be reused by userspace
> > without another additional overhead(ex, page fault + allocation
> > + zeroing).
> > 
> > How to work is following as.
> > 
> > When madvise syscall is called, VM clears dirty bit of ptes of
> > the range. 
> 
> This should be updated because the implementation has been changed.
> It also remove the page from the swapcache if it is.

You're right in current implementation but it's rather one of
implementation technique(ie, it could be changed later) but still
main main logic from MADV_FREE is tightly coupled with pte dirty bit
so I don't feel I added it in description but it would be better to
add it as comment.

Thanks for the review!

> 
> Thank you for your effort!
> 
> -- 
> Thanks.
> Zhang Yanfei
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
