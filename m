Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3KZNQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:16:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab3KZNQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:16:19 -0500
Message-ID: <52949F1C.2060607@redhat.com>
Date: Tue, 26 Nov 2013 08:16:12 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 2/5] mm: compaction: reset cached scanner pfn's before
 reading them
References: <1385389570-11393-1-git-send-email-vbabka@suse.cz> <1385389570-11393-3-git-send-email-vbabka@suse.cz>
In-Reply-To: <1385389570-11393-3-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 09:26 AM, Vlastimil Babka wrote:
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

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
