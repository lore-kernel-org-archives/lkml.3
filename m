Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934744AbaGYPjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:39:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934552AbaGYPjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:39:03 -0400
Date: Fri, 25 Jul 2014 16:38:59 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, thp: restructure thp avoidance of light synchronous
 migration
Message-ID: <20140725153859.GK10819@suse.de>
References: <alpine.DEB.2.02.1407241540190.22557@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407241540190.22557@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 03:41:06PM -0700, David Rientjes wrote:
> __GFP_NO_KSWAPD, once the way to determine if an allocation was for thp or not, 
> has gained more users.  Their use is not necessarily wrong, they are trying to 
> do a memory allocation that can easily fail without disturbing kswapd, so the 
> bit has gained additional usecases.
> 
> This restructures the check to determine whether MIGRATE_SYNC_LIGHT should be 
> used for memory compaction in the page allocator.  Rather than testing solely 
> for __GFP_NO_KSWAPD, test for all bits that must be set for thp allocations.
> 
> This also moves the check to be done only after the page allocator is aborted 
> for deferred or contended memory compaction since setting migration_mode for 
> this case is pointless.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
