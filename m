Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935624Ab3DJN3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:29:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab3DJN3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:29:13 -0400
Date: Wed, 10 Apr 2013 14:29:07 +0100
From: Mel Gorman <mgorman@suse.de>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] mm: vmscan: Flatten kswapd priority loop
Message-ID: <20130410132907.GA3710@suse.de>
References: <1365505625-9460-1-git-send-email-mgorman@suse.de>
 <1365505625-9460-4-git-send-email-mgorman@suse.de>
 <51651913.4040007@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <51651913.4040007@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:47:31PM +0900, Kamezawa Hiroyuki wrote:
> > @@ -2811,8 +2814,16 @@ loop_again:
> >   
> >   			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
> >   			    !zone_balanced(zone, testorder,
> > -					   balance_gap, end_zone))
> > -				kswapd_shrink_zone(zone, &sc, lru_pages);
> > +					   balance_gap, end_zone)) {
> > +				/*
> > +				 * There should be no need to raise the
> > +				 * scanning priority if enough pages are
> > +				 * already being scanned that high
> > +				 * watermark would be met at 100% efficiency.
> > +				 */
> > +				if (kswapd_shrink_zone(zone, &sc, lru_pages))
> > +					raise_priority = false;
> 
> priority will be raised up enough to scan the amount of "high" watermark
> and will not get larger than that if some pages are reclaimed ?
> 

Yes.

-- 
Mel Gorman
SUSE Labs
