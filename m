Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab3CQPMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 11:12:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab3CQPL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 11:11:59 -0400
Date: Sun, 17 Mar 2013 15:11:55 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] mm: vmscan: Have kswapd writeback pages based on
 dirty pages encountered, not priority
Message-ID: <20130317151155.GC2026@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-7-git-send-email-mgorman@suse.de>
 <m2620qjdeo.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <m2620qjdeo.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 07:42:39AM -0700, Andi Kleen wrote:
> Mel Gorman <mgorman@suse.de> writes:
> 
> > @@ -495,6 +495,9 @@ typedef enum {
> >  	ZONE_CONGESTED,			/* zone has many dirty pages backed by
> >  					 * a congested BDI
> >  					 */
> > +	ZONE_DIRTY,			/* reclaim scanning has recently found
> > +					 * many dirty file pages
> > +					 */
> 
> Needs a better name. ZONE_DIRTY_CONGESTED ? 
> 

That might be confusing. The underlying BDI is not necessarily
congested. I accept your point though and will try thinking of a better
name.

> > +	 * currently being written then flag that kswapd should start
> > +	 * writing back pages.
> > +	 */
> > +	if (global_reclaim(sc) && nr_dirty &&
> > +			nr_dirty >= (nr_taken >> (DEF_PRIORITY - sc->priority)))
> > +		zone_set_flag(zone, ZONE_DIRTY);
> > +
> >  	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
> 
> I suppose you want to trace the dirty case here too.
> 

I guess it wouldn't hurt to have a new tracepoint for when the flag gets
set. A vmstat might be helpful as well.

-- 
Mel Gorman
SUSE Labs
