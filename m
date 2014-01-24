Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaAXX0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 18:26:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaAXX0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 18:26:07 -0500
Message-ID: <52E2F680.10409@redhat.com>
Date: Fri, 24 Jan 2014 18:25:52 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: page-writeback: do not count anon pages as dirtyable
 memory
References: <1390600984-13925-1-git-send-email-hannes@cmpxchg.org> <1390600984-13925-3-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1390600984-13925-3-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 05:03 PM, Johannes Weiner wrote:
> The VM is currently heavily tuned to avoid swapping.  Whether that is
> good or bad is a separate discussion, but as long as the VM won't swap
> to make room for dirty cache, we can not consider anonymous pages when
> calculating the amount of dirtyable memory, the baseline to which
> dirty_background_ratio and dirty_ratio are applied.
> 
> A simple workload that occupies a significant size (40+%, depending on
> memory layout, storage speeds etc.) of memory with anon/tmpfs pages
> and uses the remainder for a streaming writer demonstrates this
> problem.  In that case, the actual cache pages are a small fraction of
> what is considered dirtyable overall, which results in an relatively
> large portion of the cache pages to be dirtied.  As kswapd starts
> rotating these, random tasks enter direct reclaim and stall on IO.
> 
> Only consider free pages and file pages dirtyable.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
