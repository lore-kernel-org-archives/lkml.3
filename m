Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3A2NA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:00:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:1154 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab3A2NAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:00:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,559,1355126400"; 
   d="scan'208";a="279764473"
Date: Tue, 29 Jan 2013 15:01:27 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hillf Danton <dhillf@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <5107c827d855d_f167d78c842627@blue.mail>
In-Reply-To: <CAJd=RBAAdYef6+sHnD9kS=7mygSrgAD3cDW1wk8YsT2OK0sfZQ@mail.gmail.com>
References: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com> <1359365068-10147-7-git-send-email-kirill.shutemov@linux.intel.com> <CAJd=RBAAdYef6+sHnD9kS=7mygSrgAD3cDW1wk8YsT2OK0sfZQ@mail.gmail.com>
Subject: Re: [PATCH, RFC 06/16] thp, mm: rewrite add_to_page_cache_locked() to
 support huge pages
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Mon, Jan 28, 2013 at 5:24 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > @@ -443,6 +443,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
> >                 pgoff_t offset, gfp_t gfp_mask)
> >  {
> >         int error;
> > +       int nr = 1;
> >
> >         VM_BUG_ON(!PageLocked(page));
> >         VM_BUG_ON(PageSwapBacked(page));
> > @@ -450,31 +451,61 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
> >         error = mem_cgroup_cache_charge(page, current->mm,
> >                                         gfp_mask & GFP_RECLAIM_MASK);
> >         if (error)
> > -               goto out;
> > +               return error;
> 
> Due to PageCompound check, thp could not be charged effectively.
> Any change added for charging it?

I've missed this. Will fix.

-- 
 Kirill A. Shutemov
