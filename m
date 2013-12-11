Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3LKSYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:24:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab3LKSYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:24:46 -0500
Message-ID: <52A8ADE4.8020609@redhat.com>
Date: Wed, 11 Dec 2013 13:24:36 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: page_alloc: exclude unreclaimable allocations from
 zone fairness policy
References: <1386785356-19911-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1386785356-19911-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 01:09 PM, Johannes Weiner wrote:
> Dave Hansen noted a regression in a microbenchmark that loops around
> open() and close() on an 8-node NUMA machine and bisected it down to
> 81c0a2bb515f ("mm: page_alloc: fair zone allocator policy").  That
> change forces the slab allocations of the file descriptor to spread
> out to all 8 nodes, causing remote references in the page allocator
> and slab.
> 
> The round-robin policy is only there to provide fairness among memory
> allocations that are reclaimed involuntarily based on pressure in each
> zone.  It does not make sense to apply it to unreclaimable kernel
> allocations that are freed manually, in this case instantly after the
> allocation, and incur the remote reference costs twice for no reason.
> 
> Only round-robin allocations that are usually freed through page
> reclaim or slab shrinking.
> 
> Bisected-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@kernel.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
