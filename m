Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3LPT0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:26:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab3LPT0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:26:14 -0500
Message-ID: <52AF53BD.7060509@redhat.com>
Date: Mon, 16 Dec 2013 14:25:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] mm: page_alloc: Make zone distribution page aging
 policy configurable
References: <1386943807-29601-1-git-send-email-mgorman@suse.de> <1386943807-29601-6-git-send-email-mgorman@suse.de>
In-Reply-To: <1386943807-29601-6-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 09:10 AM, Mel Gorman wrote:
> Commit 81c0a2bb ("mm: page_alloc: fair zone allocator policy") solved a
> bug whereby new pages could be reclaimed before old pages because of
> how the page allocator and kswapd interacted on the per-zone LRU lists.
> Unfortunately it was missed during review that a consequence is that
> we also round-robin between NUMA nodes. This is bad for two reasons
> 
> 1. It alters the semantics of MPOL_LOCAL without telling anyone
> 2. It incurs an immediate remote memory performance hit in exchange
>    for a potential performance gain when memory needs to be reclaimed
>    later
> 
> No cookies for the reviewers on this one.
> 
> This patch makes the behaviour of the fair zone allocator policy
> configurable.  By default it will only distribute pages that are going
> to exist on the LRU between zones local to the allocating process. This
> preserves the historical semantics of MPOL_LOCAL.
> 
> By default, slab pages are not distributed between zones after this patch is
> applied. It can be argued that they should get similar treatment but they
> have different lifecycles to LRU pages, the shrinkers are not zone-aware
> and the interaction between the page allocator and kswapd is different
> for slabs. If it turns out to be an almost universal win, we can change
> the default.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
