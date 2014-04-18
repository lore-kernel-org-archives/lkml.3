Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaDRPtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:49:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaDRPtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:49:21 -0400
Date: Fri, 18 Apr 2014 17:49:18 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
Message-ID: <20140418154918.GD4523@dhcp22.suse.cz>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396910068-11637-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 07-04-14 23:34:26, Mel Gorman wrote:
> When it was introduced, zone_reclaim_mode made sense as NUMA distances
> punished and workloads were generally partitioned to fit into a NUMA
> node. NUMA machines are now common but few of the workloads are NUMA-aware
> and it's routine to see major performance due to zone_reclaim_mode being
> disabled but relatively few can identify the problem.
> 
> Those that require zone_reclaim_mode are likely to be able to detect when
> it needs to be enabled and tune appropriately so lets have a sensible
> default for the bulk of users.
> 
>  Documentation/sysctl/vm.txt | 17 +++++++++--------
>  include/linux/mmzone.h      |  1 -
>  mm/page_alloc.c             | 17 +----------------
>  3 files changed, 10 insertions(+), 25 deletions(-)

Auto-enabling caused so many reports in the past that it is definitely
much better to not be clever and let admins enable zone_reclaim where it
is appropriate instead.

For both patches.
Acked-by: Michal Hocko <mhocko@suse.cz>
-- 
Michal Hocko
SUSE Labs
