Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaAXXF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 18:05:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbaAXXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 18:05:26 -0500
Message-ID: <52E2F1A5.7010907@redhat.com>
Date: Fri, 24 Jan 2014 18:05:09 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] mm: page-writeback: fix dirty_balance_reserve subtraction
 from dirtyable memory
References: <1390600984-13925-1-git-send-email-hannes@cmpxchg.org> <1390600984-13925-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1390600984-13925-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 05:03 PM, Johannes Weiner wrote:
> The dirty_balance_reserve is an approximation of the fraction of free
> pages that the page allocator does not make available for page cache
> allocations.  As a result, it has to be taken into account when
> calculating the amount of "dirtyable memory", the baseline to which
> dirty_background_ratio and dirty_ratio are applied.
> 
> However, currently the reserve is subtracted from the sum of free and
> reclaimable pages, which is non-sensical and leads to erroneous
> results when the system is dominated by unreclaimable pages and the
> dirty_balance_reserve is bigger than free+reclaimable.  In that case,
> at least the already allocated cache should be considered dirtyable.
> 
> Fix the calculation by subtracting the reserve from the amount of free
> pages, then adding the reclaimable pages on top.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
