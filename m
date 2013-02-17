Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3BQWvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:51:23 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40018 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab3BQWvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:51:21 -0500
Date: Sun, 17 Feb 2013 17:51:12 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
        Stewart Smith <stewart@flamingspork.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [patch 1/2] mm: fincore()
Message-ID: <20130217225112.GB24384@cmpxchg.org>
References: <87a9rbh7b4.fsf@rustcorp.com.au>
 <20130211162701.GB13218@cmpxchg.org>
 <20130211141239.f4decf03.akpm@linux-foundation.org>
 <20130215063450.GA24047@cmpxchg.org>
 <20130215132738.c85c9eda.akpm@linux-foundation.org>
 <20130215231304.GB23930@cmpxchg.org>
 <20130215154235.0fb36f53.akpm@linux-foundation.org>
 <87621skhtc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87621skhtc.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 02:53:43PM +1030, Rusty Russell wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> > On Fri, 15 Feb 2013 18:13:04 -0500
> > Johannes Weiner <hannes@cmpxchg.org> wrote:
> >> I dunno.  The byte vector might not be optimal but its worst cases
> >> seem more attractive, is just as extensible, and dead simple to use.
> >
> > But I think "which pages from this 4TB file are in core" will not be an
> > uncommon usage, and writing a gig of memory to find three pages is just
> > awful.
> 
> Actually, I don't know of any usage for this call.
> 
> I'd really like to use it for backup programs, so they stop pulling
> random crap into memory (but leave things already resident).  But that
> needs to madvise(MADV_DONTNEED) on the page, so need mmap.

We do actually have fadvise() (posix_fadvise()).

Btw, why are we not invalidating page cache from MADV_DONTNEED?  I
just see a page table teardown in there, so mmap for madvise alone
won't do any good.  fadvise() OTOTH /does/ invalidate page cache.
