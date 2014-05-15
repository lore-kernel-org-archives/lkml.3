Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaEOJr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:47:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaEOJr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:47:27 -0400
Date: Thu, 15 May 2014 10:47:18 +0100
From: Mel Gorman <mgorman@suse.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "'Tomasz Stanislawski'" <t.stanislaws@samsung.com>
Subject: Re: [RFC PATCH 0/3] Aggressively allocate the pages on cma reserved
 memory
Message-ID: <20140515094718.GE23991@suse.de>
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com>
 <536CCC78.6050806@samsung.com>
 <20140513022603.GF23803@js1304-P5Q-DELUXE>
 <8738gcae4h.fsf@linux.vnet.ibm.com>
 <20140515021055.GC10116@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140515021055.GC10116@js1304-P5Q-DELUXE>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:10:55AM +0900, Joonsoo Kim wrote:
> > That doesn't always prefer CMA region. It would be nice to
> > understand why grouping in pageblock_nr_pages is beneficial. Also in
> > your patch you decrement nr_try_cma for every 'order' allocation. Why ?
> 
> pageblock_nr_pages is just magic value with no rationale. :)

I'm not following this discussions closely but there is rational to that
value -- it's the size of a huge page for that architecture.  At the time
the fragmentation avoidance was implemented this was the largest allocation
size of interest.

-- 
Mel Gorman
SUSE Labs
