Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaLJODv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:03:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbaLJODt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:03:49 -0500
Date: Wed, 10 Dec 2014 14:03:44 +0000
From: Mel Gorman <mgorman@suse.de>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Weijie Yang <weijie.yang@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: page_alloc: place zone id check before
 VM_BUG_ON_PAGE check
Message-ID: <20141210140344.GF21903@suse.de>
References: <000001d01383$8e0f1120$aa2d3360$%yang@samsung.com>
 <20141209095922.GB21903@suse.de>
 <CAL1ERfOxEJGJjZk9O_NKV82mOT+udto0tL2eCagicLig6CaJ=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAL1ERfOxEJGJjZk9O_NKV82mOT+udto0tL2eCagicLig6CaJ=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 09:38:42PM +0800, Weijie Yang wrote:
> On Tue, Dec 9, 2014 at 5:59 PM, Mel Gorman <mgorman@suse.de> wrote:
> > On Tue, Dec 09, 2014 at 03:40:35PM +0800, Weijie Yang wrote:
> >> If the free page and its buddy has different zone id, the current
> >> zone->lock cann't prevent buddy page getting allocated, this could
> >> trigger VM_BUG_ON_PAGE in a very tiny chance:
> >>
> >
> > Under what circumstances can a buddy page be allocated without the
> > zone->lock? Any parallel allocation from that zone that takes place will
> > be from the per-cpu allocator and should not be affected by this. Have
> > you actually hit this race?
> 
> My description maybe not clear, if the free page and its buddy is not
> at the same zone, the holding zone->lock cann't prevent buddy page
> getting allocated.

You're right, the description is not clear but now I see your
point. Thanks.

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
