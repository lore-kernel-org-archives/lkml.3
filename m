Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaGUXFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:05:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53924 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaGUXFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:05:32 -0400
Date: Tue, 22 Jul 2014 01:05:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/6] PM / Hibernate: Create a Radix-Tree to store
 memory bitmap
Message-ID: <20140721230530.GB7019@amd.pavel.ucw.cz>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <1405938422-21900-2-git-send-email-joro@8bytes.org>
 <20140721223637.GU30979@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721223637.GU30979@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-07-22 00:36:37, Joerg Roedel wrote:
> Pavel,
> 
> On Mon, Jul 21, 2014 at 12:26:57PM +0200, Joerg Roedel wrote:
> >  unsigned int snapshot_additional_pages(struct zone *zone)
> >  {
> > +	unsigned int rtree, nodes;
> >  	unsigned int res;
> >  
> >  	res = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
> >  	res += DIV_ROUND_UP(res * sizeof(struct bm_block),
> >  			    LINKED_PAGE_DATA_SIZE);
> > -	return 2 * res;
> > +	rtree = nodes = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
> > +	rtree += DIV_ROUND_UP(rtree * sizeof(struct rtree_node),
> > +			      LINKED_PAGE_DATA_SIZE);
> > +	while (nodes > 1) {
> > +		nodes = DIV_ROUND_UP(nodes, BM_ENTRIES_PER_LEVEL);
> > +		rtree += nodes;
> > +	}
> > +
> > +	return 2 * (res + rtree);
> >  }
> 
> Since you asked in another mail if I took the new data structure size
> requirements into account, here is the code I added for this
> computation.

Yep, thanks, I found it in the meantime.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
