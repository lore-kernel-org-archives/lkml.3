Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3HBUrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:47:22 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51645 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3HBUrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:47:21 -0400
Date: Fri, 2 Aug 2013 16:47:10 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm, page_alloc: add likely macro to help compiler
 optimization
Message-ID: <20130802204710.GX715@cmpxchg.org>
References: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130802162722.GA29220@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802162722.GA29220@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 06:27:22PM +0200, Michal Hocko wrote:
> On Fri 02-08-13 11:07:56, Joonsoo Kim wrote:
> > We rarely allocate a page with ALLOC_NO_WATERMARKS and it is used
> > in slow path. For making fast path more faster, add likely macro to
> > help compiler optimization.
> 
> The code is different in mmotm tree (see mm: page_alloc: rearrange
> watermark checking in get_page_from_freelist)

Yes, please rebase this on top.

> Besides that, make sure you provide numbers which prove your claims
> about performance optimizations.

Isn't that a bit overkill?  We know it's a likely path (we would
deadlock constantly if a sizable portion of allocations were to ignore
the watermarks).  Does he have to justify that likely in general makes
sense?
