Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3GYPK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:10:59 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50911 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab3GYPK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:10:58 -0400
Date: Thu, 25 Jul 2013 11:10:49 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Paul Bolle <paul.bollee@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Paul Bolle <pebolle@tiscali.nl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: page_alloc: fair zone allocator policy
Message-ID: <20130725151049.GM715@cmpxchg.org>
References: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org>
 <1374267325-22865-4-git-send-email-hannes@cmpxchg.org>
 <51ED9433.60707@redhat.com>
 <51F0CACE.7040609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F0CACE.7040609@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul Bolle^W^W Sam Ben^W^W Hush Bensen^W^W Mtrr Patt^W^W Ric
Mason^W^W Will Huck^W^W Simon Jeons^W^W Jaeguk Hanse^W^W Ni zhan
Chen^W^W^W Wanpeng Li

[ I Cc'd Paul Bolle at pebolle@tiscali.nl as well, his English was
  better from there ]

On Thu, Jul 25, 2013 at 02:50:54PM +0800, Paul Bolle wrote:
> On 07/23/2013 04:21 AM, Rik van Riel wrote:
> >On 07/19/2013 04:55 PM, Johannes Weiner wrote:
> >
> >>@@ -1984,7 +1992,8 @@ this_zone_full:
> >>          goto zonelist_scan;
> >>      }
> >>
> >>-    if (page)
> >>+    if (page) {
> >>+        atomic_sub(1U << order, &zone->alloc_batch);
> >>          /*
> >>           * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
> >>           * necessary to allocate the page. The expectation is
> >
> >Could this be moved into the slow path in buffered_rmqueue and
> >rmqueue_bulk, or would the effect of ignoring the pcp buffers be
> >too detrimental to keeping the balance between zones?
> >
> >It would be kind of nice to not have this atomic operation on every
> >page allocation...
> 
> atomic operation will lock cache line or memory bus? And cmpxchg
> will lock cache line or memory bus? ;-)

Sure, why not ;-)
