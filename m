Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3LRTtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:49:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3LRTty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:49:54 -0500
Date: Wed, 18 Dec 2013 20:50:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/7] mm: thp: turn put_compound_page() into
	__put_page_tail()
Message-ID: <20131218195018.GA9290@redhat.com>
References: <20131218191913.GA6464@redhat.com> <20131218191958.GA8330@redhat.com> <20131218193612.GF16438@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218193612.GF16438@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Peter Zijlstra wrote:
>
> On Wed, Dec 18, 2013 at 08:19:58PM +0100, Oleg Nesterov wrote:
> > @@ -247,7 +242,7 @@ bool __get_page_tail(struct page *page)
> >  	bool got;
> >  	struct page *page_head = compound_trans_head(page);
> >
> > -	/* Ref to put_compound_page() comment. */
> > +	/* Ref to __put_page_tail() comment. */
> >  	if (!__compound_tail_refcounted(page_head)) {
> >  		smp_rmb();
> >  		if (likely(PageTail(page))) {
>
> What code is this against, my local tree doesn't have that smp_rmb().

This is against -mm code.

> This suggests its a recent patch; which is good since then we can still
> drop it and wait for people to send one with a proper comment in.

put_compound_page() explains this barrier, this is what "Ref" above means,
I guess.

To remind, I think we can do more cleanups here.

Oleg.

