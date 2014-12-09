Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbaLIJ73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:59:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbaLIJ71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:59:27 -0500
Date: Tue, 9 Dec 2014 09:59:22 +0000
From: Mel Gorman <mgorman@suse.de>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Rik van Riel'" <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH] mm: page_alloc: place zone id check before
 VM_BUG_ON_PAGE check
Message-ID: <20141209095922.GB21903@suse.de>
References: <000001d01383$8e0f1120$aa2d3360$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <000001d01383$8e0f1120$aa2d3360$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 03:40:35PM +0800, Weijie Yang wrote:
> If the free page and its buddy has different zone id, the current
> zone->lock cann't prevent buddy page getting allocated, this could
> trigger VM_BUG_ON_PAGE in a very tiny chance:
> 

Under what circumstances can a buddy page be allocated without the
zone->lock? Any parallel allocation from that zone that takes place will
be from the per-cpu allocator and should not be affected by this. Have
you actually hit this race?

-- 
Mel Gorman
SUSE Labs
