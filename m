Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaHKMMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:12:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbaHKMMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:12:46 -0400
Date: Mon, 11 Aug 2014 13:12:42 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/6] mm: page_alloc: Reduce cost of the fair zone
 allocation policy
Message-ID: <20140811121241.GD7970@suse.de>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
 <1404893588-21371-7-git-send-email-mgorman@suse.de>
 <53E4EC53.1050904@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <53E4EC53.1050904@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 05:27:15PM +0200, Vlastimil Babka wrote:
> On 07/09/2014 10:13 AM, Mel Gorman wrote:
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1604,6 +1604,9 @@ again:
> >  	}
> >  
> >  	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
> 
> This can underflow zero, right?
> 

Yes, because of per-cpu accounting drift.

> > +	if (zone_page_state(zone, NR_ALLOC_BATCH) == 0 &&
> 
> AFAICS, zone_page_state will correct negative values to zero only for
> CONFIG_SMP. Won't this check be broken on !CONFIG_SMP?
> 

On !CONFIG_SMP how can there be per-cpu accounting drift that would make
that counter negative?

-- 
Mel Gorman
SUSE Labs
