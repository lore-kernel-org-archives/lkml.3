Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3CQP0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 11:26:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab3CQP0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 11:26:03 -0400
Date: Sun, 17 Mar 2013 15:25:57 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] mm: vmscan: Move logic from balance_pgdat() to
 kswapd_shrink_zone()
Message-ID: <20130317152556.GE2026@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-11-git-send-email-mgorman@suse.de>
 <m2sj3uhy85.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <m2sj3uhy85.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 07:55:54AM -0700, Andi Kleen wrote:
> Mel Gorman <mgorman@suse.de> writes:
> 
> > +
> > +	/*
> > +	 * We put equal pressure on every zone, unless one zone has way too
> > +	 * many pages free already. The "too many pages" is defined as the
> > +	 * high wmark plus a "gap" where the gap is either the low
> > +	 * watermark or 1% of the zone, whichever is smaller.
> > +	 */
> > +	balance_gap = min(low_wmark_pages(zone),
> > +		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
> > +		KSWAPD_ZONE_BALANCE_GAP_RATIO);
> 
> Don't like those hard coded tunables. 1% of a 512GB node can be still
> quite a lot. Shouldn't the low watermark be enough?
> 

1% of 512G would be lot but in that case, it'll use the low watermark as
the balance gap.

-- 
Mel Gorman
SUSE Labs
