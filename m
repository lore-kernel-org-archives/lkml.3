Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3LMPqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:46:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab3LMPqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:46:00 -0500
Message-ID: <52AB2BAD.4080003@redhat.com>
Date: Fri, 13 Dec 2013 10:45:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm: page_alloc: exclude unreclaimable allocations
 from zone fairness policy
References: <1386943807-29601-1-git-send-email-mgorman@suse.de> <1386943807-29601-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1386943807-29601-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 09:10 AM, Mel Gorman wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
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
> Cc: <stable@kernel.org>
> Bisected-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
