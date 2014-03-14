Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaCNQGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:06:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbaCNQGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:06:36 -0400
Message-ID: <53232901.5030307@redhat.com>
Date: Fri, 14 Mar 2014 12:06:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: vmscan: do not swap anon pages just because free+file
 is low
References: <1394811302-30468-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1394811302-30468-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 11:35 AM, Johannes Weiner wrote:
> Page reclaim force-scans / swaps anonymous pages when file cache drops
> below the high watermark of a zone in order to prevent what little
> cache remains from thrashing.
> 
> However, on bigger machines the high watermark value can be quite
> large and when the workload is dominated by a static anonymous/shmem
> set, the file set might just be a small window of used-once cache.  In
> such situations, the VM starts swapping heavily when instead it should
> be recycling the no longer used cache.
> 
> This is a longer-standing problem, but it's more likely to trigger
> after 81c0a2bb515f ("mm: page_alloc: fair zone allocator policy")
> because file pages can no longer accumulate in a single zone and are
> dispersed into smaller fractions among the available zones.
> 
> To resolve this, do not force scan anon when file pages are low but
> instead rely on the scan/rotation ratios to make the right prediction.

I am not entirely sure that the scan/rotation ratio will be
meaningful when the page cache has been essentially depleted,
but on larger systems the distance between the low and high
watermark is gigantic, and I have no better idea on how to
fix the bug you encountered, so ...

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@kernel.org> [3.12+]

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
