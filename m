Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaBYNGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:06:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaBYNGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:06:36 -0500
Date: Tue, 25 Feb 2014 13:06:32 +0000
From: Mel Gorman <mgorman@suse.de>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: exclude memory less nodes from zone_reclaim
Message-ID: <20140225130632.GR6732@suse.de>
References: <1392889904-18019-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1392889904-18019-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:51:44AM +0100, Michal Hocko wrote:
> We had a report about strange OOM killer strikes on a PPC machine
> although there was a lot of swap free and a tons of anonymous memory
> which could be swapped out. In the end it turned out that the OOM was
> a side effect of zone reclaim which wasn't doesn't unmap and swapp out
> and so the system was pushed to the OOM. Although this sounds like a bug
> somewhere in the kswapd vs. zone reclaim vs. direct reclaim interaction
> numactl on the said hardware suggests that the zone reclaim should
> have been set in the first place:
> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
> node 0 size: 0 MB
> node 0 free: 0 MB
> node 2 cpus:
> node 2 size: 7168 MB
> node 2 free: 6019 MB
> node distances:
> node   0   2
> 0:  10  40
> 2:  40  10
> 
> So all the CPUs are associated with Node0 which doesn't have any memory
> while Node2 contains all the available memory. Node distances cause an
> automatic zone_reclaim_mode enabling.
> 
> Zone reclaim is intended to keep the allocations local but this doesn't
> make any sense on the memory less nodes. So let's exclude such nodes
> for init_zone_allows_reclaim which evaluates zone reclaim behavior and
> suitable reclaim_nodes.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> Tested-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

Acked-by: Mel Gorman <mgorman@suse.de>

FWIW, I do expect that memory hot-adding memory later will cause problems
because the node is only initialised if it was previously considered offline
but Nishanth is making changes in that area and it would be easier to fix
it up in that context.

-- 
Mel Gorman
SUSE Labs
