Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaDHH0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:26:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaDHH0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:26:15 -0400
Message-ID: <5343A494.9070707@suse.cz>
Date: Tue, 08 Apr 2014 09:26:12 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1396910068-11637-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 12:34 AM, Mel Gorman wrote:
> When it was introduced, zone_reclaim_mode made sense as NUMA distances
> punished and workloads were generally partitioned to fit into a NUMA
> node. NUMA machines are now common but few of the workloads are NUMA-aware
> and it's routine to see major performance due to zone_reclaim_mode being
> disabled but relatively few can identify the problem.
     ^ I think you meant "enabled" here?

Just in case the cover letter goes to the changelog...

Vlastimil

> Those that require zone_reclaim_mode are likely to be able to detect when
> it needs to be enabled and tune appropriately so lets have a sensible
> default for the bulk of users.
>
>   Documentation/sysctl/vm.txt | 17 +++++++++--------
>   include/linux/mmzone.h      |  1 -
>   mm/page_alloc.c             | 17 +----------------
>   3 files changed, 10 insertions(+), 25 deletions(-)
>

