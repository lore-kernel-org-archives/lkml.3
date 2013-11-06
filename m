Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3KFXlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:41:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3KFXlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:41:21 -0500
Date: Wed, 6 Nov 2013 15:41:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, zhang.mingjun@linaro.org,
        m.szyprowski@samsung.com, haojian.zhuang@linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mingjun Zhang <troy.zhangmingjun@linaro.org>
Subject: Re: [PATCH] mm: cma: free cma page to buddy instead of being cpu
 hot page
Message-Id: <20131106154120.477a4cd83f8fb120d4d4f6cf@linux-foundation.org>
In-Reply-To: <20131106064302.GC30958@bbox>
References: <1382960569-6564-1-git-send-email-zhang.mingjun@linaro.org>
	<20131029093322.GA2400@suse.de>
	<20131105134448.7677d6febbfff4721373be4b@linux-foundation.org>
	<20131106064302.GC30958@bbox>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 15:43:02 +0900 Minchan Kim <minchan@kernel.org> wrote:

> > The added overhead is pretty small - just a comparison of a local with
> > a constant.  And that cost is not incurred for MIGRATE_UNMOVABLE,
> > MIGRATE_RECLAIMABLE and MIGRATE_MOVABLE, which are the common cases
> > (yes?).
> 
> True but bloat code might affect icache so we should be careful.
> And what Mel has a concern is about zone->lock, which would be more contended.
> I agree his opinion.
> 
> In addition, I think the gain is marginal because normally CMA is big range
> so free_contig_range in dma release path will fill per_cpu_pages with freed pages
> easily so it could drain per_cpu_pages frequently so race which steal page from
> per_cpu_pages is not big, I guess.
> 
> Morever, we could change free_contig_range with batch_free_page which would
> be useful for other cases if they want to free many number of pages
> all at once.
> 
> The bottom line is we need *number and real scenario* for that.

Well yes, quantitative results are always good to have with a patch like
this.

It doesn't actually compile (missing a "}"), which doesn't inspire
confidence.  I'll make the patch go away for now

