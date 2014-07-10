Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaGJMoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:44:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaGJMoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:44:12 -0400
Date: Thu, 10 Jul 2014 13:44:07 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/6] mm: page_alloc: Abort fair zone allocation policy
 when remotes nodes are encountered
Message-ID: <20140710124407.GH10819@suse.de>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
 <1404893588-21371-6-git-send-email-mgorman@suse.de>
 <20140710121419.GM29639@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140710121419.GM29639@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 08:14:19AM -0400, Johannes Weiner wrote:
> On Wed, Jul 09, 2014 at 09:13:07AM +0100, Mel Gorman wrote:
> > The purpose of numa_zonelist_order=zone is to preserve lower zones
> > for use with 32-bit devices. If locality is preferred then the
> > numa_zonelist_order=node policy should be used. Unfortunately, the fair
> > zone allocation policy overrides this by skipping zones on remote nodes
> > until the lower one is found. While this makes sense from a page aging
> > and performance perspective, it breaks the expected zonelist policy. This
> > patch restores the expected behaviour for zone-list ordering.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> 32-bit NUMA? :-)

I'm tempted to just say "it can go on fire" but realistically speaking
they should be configured to use node ordering. I was very tempted to
always force node ordering but I didn't have good data on how often lowmem
allocations are required on NUMA machines.

> Anyway, this change also cuts down the fair pass
> overhead on bigger NUMA machines, so I'm all for it.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks for the reviews!

-- 
Mel Gorman
SUSE Labs
