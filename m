Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3KZKXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:23:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab3KZKXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:23:09 -0500
Date: Tue, 26 Nov 2013 10:23:06 +0000
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/5] mm: compaction: reset cached scanner pfn's before
 reading them
Message-ID: <20131126102306.GF5285@suse.de>
References: <1385389570-11393-1-git-send-email-vbabka@suse.cz>
 <1385389570-11393-3-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1385389570-11393-3-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 03:26:07PM +0100, Vlastimil Babka wrote:
> Compaction caches pfn's for its migrate and free scanners to avoid scanning
> the whole zone each time. In compact_zone(), the cached values are read to
> set up initial values for the scanners. There are several situations when
> these cached pfn's are reset to the first and last pfn of the zone,
> respectively. One of these situations is when a compaction has been deferred
> for a zone and is now being restarted during a direct compaction, which is also
> done in compact_zone().
> 
> However, compact_zone() currently reads the cached pfn's *before* resetting
> them. This means the reset doesn't affect the compaction that performs it, and
> with good chance also subsequent compactions, as update_pageblock_skip() is
> likely to be called and update the cached pfn's to those being processed.
> Another chance for a successful reset is when a direct compaction detects that
> migration and free scanners meet (which has its own problems addressed by
> another patch) and sets update_pageblock_skip flag which kswapd uses to do the
> reset because it goes to sleep.
> 
> This is clearly a bug that results in non-deterministic behavior, so this patch
> moves the cached pfn reset to be performed *before* the values are read.
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
