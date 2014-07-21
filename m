Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaGUOjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:39:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42579 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbaGUOjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:39:08 -0400
Date: Mon, 21 Jul 2014 16:39:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721143905.GA16454@amd.pavel.ucw.cz>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
 <20140719134904.GA2852@amd.pavel.ucw.cz>
 <20140721083211.GK30979@8bytes.org>
 <20140721114507.GA13921@amd.pavel.ucw.cz>
 <20140721142951.GN30979@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721142951.GN30979@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-07-21 16:29:51, Joerg Roedel wrote:
> Hi,
> 
> On Mon, Jul 21, 2014 at 01:45:07PM +0200, Pavel Machek wrote:
> > Ok, so you have sped it up from O(n) to O(log(n)) speed, and increased
> > memory requirements from O(n) to O(n * log(n)), right?
> 
> No, new memory requirements are still ~O(n), because the additional pages
> needed for the index in the radix tree are outweighted by the memory
> saved by the smaller size of struct rtree_node compared to struct
> bm_block.

Are we in agreement how O() notation works?

So you reduced O(n) to O(n/2 log(n)) ... that's still O(n log(n)), right?

> You can also modify the above tool to give you some data to plot, then
> you will also SEE that there is still a linear relationship between RAM
> size and memory required by the old and new memory bitmap
> implementation.

I believe radix tree is O(log(N)) per operation, but its memory is
certainly not linear.

Yes, log(n) is looks quite constant even for huge n :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
