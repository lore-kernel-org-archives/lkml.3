Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaBYUg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:36:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaBYUg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:36:56 -0500
Message-ID: <530CFEDF.3060801@redhat.com>
Date: Tue, 25 Feb 2014 15:36:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Jan Stancek <jstancek@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] mm: page_alloc: reset aging cycle with GFP_THISNODE
References: <1393360022-22566-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1393360022-22566-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 03:27 PM, Johannes Weiner wrote:
> Jan Stancek reports manual page migration encountering allocation
> failures after some pages when there is still plenty of memory free,
> and bisected the problem down to 81c0a2bb515f ("mm: page_alloc: fair
> zone allocator policy").
> 
> The problem is that page migration uses GFP_THISNODE and this makes
> the page allocator bail out before entering the slowpath entirely,
> without resetting the zone round-robin batches.  A string of such
> allocations will fail long before the node's free memory is exhausted.
> 
> GFP_THISNODE is a special flag for callsites that implement their own
> clever node fallback and so no direct reclaim should be invoked.  But
> if the allocations fail, the fair allocation batches should still be
> reset, and if the node is full, it should be aged in the background.
> 
> Make GFP_THISNODE wake up kswapd and reset the zone batches, but bail
> out before entering direct reclaim to not stall the allocating task.
> 
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@kernel.org> # 3.12+

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
