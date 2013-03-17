Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3CQPIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 11:08:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab3CQPIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 11:08:11 -0400
Date: Sun, 17 Mar 2013 15:08:07 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] mm: vmscan: Obey proportional scanning
 requirements for kswapd
Message-ID: <20130317150807.GA2026@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-3-git-send-email-mgorman@suse.de>
 <m2a9q2jdjq.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <m2a9q2jdjq.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 07:39:37AM -0700, Andi Kleen wrote:
> Mel Gorman <mgorman@suse.de> writes:
> > +
> > +	/*
> > +	 * For direct reclaim, reclaim the number of pages requested. Less
> > +	 * care is taken to ensure that scanning for each LRU is properly
> > +	 * proportional. This is unfortunate and is improper aging but
> > +	 * minimises the amount of time a process is stalled.
> > +	 */
> > +	if (!current_is_kswapd()) {
> > +		if (nr_reclaimed >= nr_to_reclaim) {
> > +			for_each_evictable_lru(l)
> 
> Don't we need some NUMA awareness here?
> Similar below.
> 

Of what sort? In this context we are usually dealing with a zone and in
the case of kswapd it is only ever dealing with a single node.

-- 
Mel Gorman
SUSE Labs
