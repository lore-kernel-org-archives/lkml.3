Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab3LROvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:51:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab3LROvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:51:13 -0500
Date: Wed, 18 Dec 2013 15:51:11 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/6] Configurable fair allocation zone policy v3
Message-ID: <20131218145111.GA27510@dhcp22.suse.cz>
References: <1387298904-8824-1-git-send-email-mgorman@suse.de>
 <20131217200210.GG21724@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217200210.GG21724@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17-12-13 15:02:10, Johannes Weiner wrote:
[...]
> +pagecache_mempolicy_mode:
> +
> +This is available only on NUMA kernels.
> +
> +Per default, the configured memory policy is applicable to anonymous
> +memory, shmem, tmpfs, etc., whereas pagecache is allocated in an
> +interleaving fashion over all allowed nodes (hardbindings and
> +zone_reclaim_mode excluded).
> +
> +The assumption is that, when it comes to pagecache, users generally
> +prefer predictable replacement behavior regardless of NUMA topology
> +and maximizing the cache's effectiveness in reducing IO over memory
> +locality.

Isn't page spreading (PF_SPREAD_PAGE) intended to do the same thing
semantically? The setting is per-cpuset rather than global which makes
it harder to use but essentially it tries to distribute page cache pages
across all the nodes.

This is really getting confusing. We have zone_reclaim_mode to keep
memory local in general, pagecache_mempolicy_mode to keep page cache
local and PF_SPREAD_PAGE to spread the page cache around nodes.

> +
> +This behavior can be changed by enabling pagecache_mempolicy_mode, in
> +which case page cache allocations will be placed according to the
> +configured memory policy (Documentation/vm/numa_memory_policy.txt).
-- 
Michal Hocko
SUSE Labs
