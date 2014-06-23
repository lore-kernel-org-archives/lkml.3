Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaFWLQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:16:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbaFWLP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:15:59 -0400
Date: Mon, 23 Jun 2014 12:15:54 +0100
From: Mel Gorman <mgorman@suse.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm:vmscan:replace zone_watermark_ok with zone_balanced
 for determining if kswapd will call compaction
Message-ID: <20140623111554.GJ10819@suse.de>
References: <1403427060-16711-1-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1403427060-16711-1-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 04:51:00PM +0800, Chen Yucong wrote:
> According to the commit messages of "mm: vmscan: fix endless loop in kswapd balancing"
> and "mm: vmscan: decide whether to compact the pgdat based on reclaim progress", minor
> change is required to the following snippet.
> 
>         /*
>          * If any zone is currently balanced then kswapd will
>          * not call compaction as it is expected that the
>          * necessary pages are already available.
>          */
>         if (pgdat_needs_compaction &&
>                 zone_watermark_ok(zone, order,
>                                         low_wmark_pages(zone),
>                                         *classzone_idx, 0))
>                 pgdat_needs_compaction = false;
> 
> zone_watermark_ok() should be replaced by zone_balanced() in the above snippet. That's
> because zone_balanced() is more suitable for the context.
> 

What bug does this fix?

The intent here is to prevent kswapd compacting a node if an allocation
request within that node would succeed against the low watermark.
Your change alters that to check against hte high watermark + balance gap
without explaining why kswapd should compact until the high watermark is
reached.

-- 
Mel Gorman
SUSE Labs
