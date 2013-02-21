Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3BUOx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 09:53:27 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40207 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab3BUOx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 09:53:26 -0500
Date: Thu, 21 Feb 2013 09:53:16 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] mm,ksm: swapoff might need to copy
Message-ID: <20130221145316.GA23767@cmpxchg.org>
References: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils>
 <alpine.LNX.2.00.1302210023350.17843@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302210023350.17843@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 12:25:40AM -0800, Hugh Dickins wrote:
> Before establishing that KSM page migration was the cause of my
> WARN_ON_ONCE(page_mapped(page))s, I suspected that they came from the
> lack of a ksm_might_need_to_copy() in swapoff's unuse_pte() - which
> in many respects is equivalent to faulting in a page.
> 
> In fact I've never caught that as the cause: but in theory it does
> at least need the KSM_RUN_UNMERGE check in ksm_might_need_to_copy(),
> to avoid bringing a KSM page back in when it's not supposed to be.

Maybe I am mistaken, maybe it was just too obvious to you to mention,
but the main reason for me would be that this can break eviction,
migration, etc. of that page when there is no rmap_item representing
the vma->anon_vma (the cross-anon_vma merge case), no?

> I intended to copy how it's done in do_swap_page(), but have a strong
> aversion to how "swapcache" ends up being used there: rework it with
> "page != swapcache".
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
