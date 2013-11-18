Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3KRV4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:56:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab3KRV4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:56:32 -0500
Date: Mon, 18 Nov 2013 16:56:18 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Mel Gorman <mgorman@suse.de>
Message-ID: <1384811778-7euptzgp-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <528A7D36.5020500@sr71.net>
References: <20131115225550.737E5C33@viggo.jf.intel.com>
 <20131115225553.B0E9DFFB@viggo.jf.intel.com>
 <1384800714-y653r3ch-mutt-n-horiguchi@ah.jp.nec.com>
 <1384800841-314l1f3e-mutt-n-horiguchi@ah.jp.nec.com>
 <528A6448.3080907@sr71.net>
 <1384806022-4718p9lh-mutt-n-horiguchi@ah.jp.nec.com>
 <528A7D36.5020500@sr71.net>
Subject: Re: [PATCH] mm: call cond_resched() per MAX_ORDER_NR_PAGES pages copy
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <528A7D36.5020500@sr71.net>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 12:48:54PM -0800, Dave Hansen wrote:
> On 11/18/2013 12:20 PM, Naoya Horiguchi wrote:
> >> > Really, though, a lot of things seem to have MAX_ORDER set up so that
> >> > it's at 256MB or 512MB.  That's an awful lot to do between rescheds.
> > Yes.
> > 
> > BTW, I found that we have the same problem for other functions like
> > copy_user_gigantic_page, copy_user_huge_page, and maybe clear_gigantic_page.
> > So we had better handle them too.
> 
> Is there a problem you're trying to solve here?  The common case of the
> cond_resched() call boils down to a read of a percpu variable which will
> surely be in the L1 cache after the first run around the loop.  In other
> words, it's about as cheap of an operation as we're going to get.

Yes, cond_resched() is cheap if should_resched() is false (and it is in
common case).

> Why bother trying to "optimize" it?

I thought that if we call cond_resched() too often, the copying thread can
take too long in a heavy load system, because the copying thread always
yields the CPU in every loop.

But it seems to be an extreme case, so I can't push it strongly.

Thanks,
Naoya
