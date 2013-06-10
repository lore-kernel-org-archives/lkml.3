Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3FJRjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:39:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:49658 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab3FJRjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:39:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,839,1363158000"; 
   d="scan'208";a="347678502"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <51B2029A.8050504@sr71.net>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1368321816-17719-15-git-send-email-kirill.shutemov@linux.intel.com>
 <519BD595.5040405@sr71.net>
 <20130528122812.0D624E0090@blue.fi.intel.com>
 <20130607151025.241EFE0090@blue.fi.intel.com>
 <51B2029A.8050504@sr71.net>
Subject: Re: [PATCHv4 14/39] thp, mm: rewrite delete_from_page_cache() to
 support huge pages
Content-Transfer-Encoding: 7bit
Message-Id: <20130610174146.8C1CFE0090@blue.fi.intel.com>
Date: Mon, 10 Jun 2013 20:41:46 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On 06/07/2013 08:10 AM, Kirill A. Shutemov wrote:
> > +	/*
> > +	 * When we add a huge page to page cache we take only reference to head
> > +	 * page, but on split we need to take addition reference to all tail
> > +	 * pages since they are still in page cache after splitting.
> > +	 */
> > +	init_tail_refcount = PageAnon(page) ? 0 : 1;
> 
> What's the "init" for in the name?

initial_tail_refcount?

> In add_to_page_cache_locked() in patch 12/39, you do
> > +       spin_lock_irq(&mapping->tree_lock);
> > +       for (i = 0; i < nr; i++) {
> > +               page_cache_get(page + i);
> 
> That looks to me to be taking references to the tail pages.  What gives? :)

The point is to drop this from add_to_page_cache_locked() and make distribution
on split.

-- 
 Kirill A. Shutemov
