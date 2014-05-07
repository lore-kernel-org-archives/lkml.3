Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaEGJjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:39:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaEGJjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:39:39 -0400
Date: Wed, 7 May 2014 10:39:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3 5/6] mm, thp: avoid excessive compaction latency
 during fault
Message-ID: <20140507093935.GE23991@suse.de>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1405061922010.18635@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405061922010.18635@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 07:22:50PM -0700, David Rientjes wrote:
> Synchronous memory compaction can be very expensive: it can iterate an enormous 
> amount of memory without aborting, constantly rescheduling, waiting on page
> locks and lru_lock, etc, if a pageblock cannot be defragmented.
> 
> Unfortunately, it's too expensive for transparent hugepage page faults and 
> it's much better to simply fallback to pages.  On 128GB machines, we find that 
> synchronous memory compaction can take O(seconds) for a single thp fault.
> 
> Now that async compaction remembers where it left off without strictly relying
> on sync compaction, this makes thp allocations best-effort without causing
> egregious latency during fault.  We still need to retry async compaction after
> reclaim, but this won't stall for seconds.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
