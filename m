Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab3LRTgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:36:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3LRTgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:36:20 -0500
Date: Wed, 18 Dec 2013 20:36:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/7] mm: thp: turn put_compound_page() into
 __put_page_tail()
Message-ID: <20131218193612.GF16438@laptop.programming.kicks-ass.net>
References: <20131218191913.GA6464@redhat.com>
 <20131218191958.GA8330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218191958.GA8330@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 08:19:58PM +0100, Oleg Nesterov wrote:
> @@ -247,7 +242,7 @@ bool __get_page_tail(struct page *page)
>  	bool got;
>  	struct page *page_head = compound_trans_head(page);
>  
> -	/* Ref to put_compound_page() comment. */
> +	/* Ref to __put_page_tail() comment. */
>  	if (!__compound_tail_refcounted(page_head)) {
>  		smp_rmb();
>  		if (likely(PageTail(page))) {

What code is this against, my local tree doesn't have that smp_rmb().

This suggests its a recent patch; which is good since then we can still
drop it and wait for people to send one with a proper comment in.
