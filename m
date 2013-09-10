Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3IJNUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:20:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab3IJNUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:20:38 -0400
Date: Tue, 10 Sep 2013 14:20:32 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, compaction: periodically schedule when freeing pages
Message-ID: <20130910132032.GO22421@suse.de>
References: <alpine.DEB.2.02.1309041625060.29607@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309041625060.29607@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 04:25:59PM -0700, David Rientjes wrote:
> We've been getting warnings about an excessive amount of time spent
> allocating pages for migration during memory compaction without
> scheduling.  isolate_freepages_block() already periodically checks for
> contended locks or the need to schedule, but isolate_freepages() never
> does.
> 
> When a zone is massively long and no suitable targets can be found, this
> iteration can be quite expensive without ever doing cond_resched().
> 
> Check periodically for the need to reschedule while the compaction free
> scanner iterates.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Ok, fair enough.

Acked-by: Mel Gorman <mgorman@suse.de>

However I'm curious. Do you know why the combined use of
compact_cached_free_pfn and pageblock skip bits is not enough for the scanner
to quickly find a pageblock that is suitable for isolate_freepages_block()?
Is the pageblock skip information getting cleared frequently by kswapd
or something?

-- 
Mel Gorman
SUSE Labs
