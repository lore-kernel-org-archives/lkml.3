Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194AbaGRMx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:53:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760575AbaGRMxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:53:55 -0400
Date: Fri, 18 Jul 2014 13:53:49 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Minchan Kim <minchan.kim@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: vmscan: clean up struct scan_control
Message-ID: <20140718125349.GQ10819@suse.de>
References: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org>
 <1405344049-19868-4-git-send-email-hannes@cmpxchg.org>
 <alpine.LSU.2.11.1407141240200.17669@eggly.anvils>
 <20140717132604.GF29639@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140717132604.GF29639@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 09:26:04AM -0400, Johannes Weiner wrote:
> <SNIP>
> 
> Andrew, could you please replace this patch with the following?
> 
> ---
> From bbe8c1645c77297a96ecd5d64d659ddcd6984d03 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Mon, 14 Jul 2014 08:51:54 -0400
> Subject: [patch] mm: vmscan: clean up struct scan_control
> 
> Reorder the members by input and output, then turn the individual
> integers for may_writepage, may_unmap, may_swap, compaction_ready,
> hibernation_mode into bit fields to save stack space:
> 
> +72/-296 -224
> kswapd                                       104     176     +72
> try_to_free_pages                             80      56     -24
> try_to_free_mem_cgroup_pages                  80      56     -24
> shrink_all_memory                             88      64     -24
> reclaim_clean_pages_from_list                168     144     -24
> mem_cgroup_shrink_node_zone                  104      80     -24
> __zone_reclaim                               176     152     -24
> balance_pgdat                                152       -    -152
> 
> Suggested-by: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
