Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab3BQW4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:56:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3BQW4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:56:08 -0500
Date: Sun, 17 Feb 2013 14:54:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>,
        Stewart Smith <stewart@flamingspork.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [patch 1/2] mm: fincore()
Message-Id: <20130217145456.375dab11.akpm@linux-foundation.org>
In-Reply-To: <87621skhtc.fsf@rustcorp.com.au>
References: <87a9rbh7b4.fsf@rustcorp.com.au>
	<20130211162701.GB13218@cmpxchg.org>
	<20130211141239.f4decf03.akpm@linux-foundation.org>
	<20130215063450.GA24047@cmpxchg.org>
	<20130215132738.c85c9eda.akpm@linux-foundation.org>
	<20130215231304.GB23930@cmpxchg.org>
	<20130215154235.0fb36f53.akpm@linux-foundation.org>
	<87621skhtc.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2013 14:53:43 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

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

That's good news ;)

We shouldn't add it unless there's damn good reason.

> I'd really like to use it for backup programs, so they stop pulling
> random crap into memory (but leave things already resident).  But that
> needs to madvise(MADV_DONTNEED) on the page, so need mmap.
>
> So why not just use mincore?

One can use fadvise(POSIX_FADV_DONTNEED) to drop the pages.

Or toss your backup app into a small memcg so it reclaims its own
stuff.  See recent thread "mm: fadvise: Drain all pagevecs if
POSIX_FADV_DONTNEED fails to discard all pages"
