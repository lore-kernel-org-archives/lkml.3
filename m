Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbaGQXBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:01:51 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61683 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaGQXBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:01:50 -0400
Date: Thu, 17 Jul 2014 16:00:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: vmscan: clean up struct scan_control
In-Reply-To: <20140717135721.GC8011@dhcp22.suse.cz>
Message-ID: <alpine.LSU.2.11.1407171556460.2544@eggly.anvils>
References: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org> <1405344049-19868-4-git-send-email-hannes@cmpxchg.org> <alpine.LSU.2.11.1407141240200.17669@eggly.anvils> <20140717132604.GF29639@cmpxchg.org> <20140717135721.GC8011@dhcp22.suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Michal Hocko wrote:
> On Thu 17-07-14 09:26:04, Johannes Weiner wrote:
> > From bbe8c1645c77297a96ecd5d64d659ddcd6984d03 Mon Sep 17 00:00:00 2001
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > Date: Mon, 14 Jul 2014 08:51:54 -0400
> > Subject: [patch] mm: vmscan: clean up struct scan_control
> > 
> > Reorder the members by input and output, then turn the individual
> > integers for may_writepage, may_unmap, may_swap, compaction_ready,
> > hibernation_mode into bit fields to save stack space:
> > 
> > +72/-296 -224
> > kswapd                                       104     176     +72
> > try_to_free_pages                             80      56     -24
> > try_to_free_mem_cgroup_pages                  80      56     -24
> > shrink_all_memory                             88      64     -24
> > reclaim_clean_pages_from_list                168     144     -24
> > mem_cgroup_shrink_node_zone                  104      80     -24
> > __zone_reclaim                               176     152     -24
> > balance_pgdat                                152       -    -152
> > 
> > Suggested-by: Mel Gorman <mgorman@suse.de>
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Looks nice to me.
> Acked-by: Michal Hocko <mhocko@suse.cz>

Yes, looks nice to me too; and I agree that it was worthwhile to make
those initialization orders consistent, and drop the 0 initializations.

Acked-by: Hugh Dickins <hughd@google.com>
