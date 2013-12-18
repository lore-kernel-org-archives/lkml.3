Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab3LRTkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:40:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab3LRTkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:40:01 -0500
Date: Wed, 18 Dec 2013 20:40:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 7/7] mm: thp: introduce compound_head_put_tail(),
	change get_futex_key() to use it
Message-ID: <20131218194025.GA8797@redhat.com>
References: <20131218191913.GA6464@redhat.com> <20131218192008.GA8343@redhat.com> <20131218192855.GE16438@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218192855.GE16438@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Peter Zijlstra wrote:
>
> On Wed, Dec 18, 2013 at 08:20:08PM +0100, Oleg Nesterov wrote:
> > +struct page *compound_head_put_tail(struct page *page)
> > +{
> > +	struct page *page_head;
> > +	unsigned long flags;
> > +
> > +	if (!PageTail(page))
> > +		return page;
> > +
> > +	page_head = compound_trans_head(page);
> > +
> > +	if (!__compound_tail_refcounted(page_head)) {
>
> This barrier is missing a comment describing the ordering and the
> pairing.

Yes, and this function lacks other comments it needs, they should be
copy-and-past'ed from the very similar __put_page_tail().

But I am going to unify them later if this series passes the review,
can't the comments wait till then?

OTOH, I won't mind to send v2 with the additional comment about this
rmb() at least. Or perhaps I should simply add /* See the comments in
__put_page_tail() */ into the new helper.

OK. But I'll wait for other reviews first.

Oleg.

