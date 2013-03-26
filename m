Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab3CZIi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:38:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:23862 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933964Ab3CZIi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:38:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,911,1355126400"; 
   d="scan'208";a="311972671"
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
In-Reply-To: <514B4A9F.5090004@sr71.net>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-13-git-send-email-kirill.shutemov@linux.intel.com>
 <514B4A9F.5090004@sr71.net>
Subject: Re: [PATCHv2, RFC 12/30] thp, mm: add event counters for huge page
 alloc on write to a file
Content-Transfer-Encoding: 7bit
Message-Id: <20130326084012.CEF0AE0085@blue.fi.intel.com>
Date: Tue, 26 Mar 2013 10:40:12 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> > --- a/include/linux/vm_event_item.h
> > +++ b/include/linux/vm_event_item.h
> > @@ -71,6 +71,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
> >  		THP_FAULT_FALLBACK,
> >  		THP_COLLAPSE_ALLOC,
> >  		THP_COLLAPSE_ALLOC_FAILED,
> > +		THP_WRITE_ALLOC,
> > +		THP_WRITE_FAILED,
> >  		THP_SPLIT,
> >  		THP_ZERO_PAGE_ALLOC,
> >  		THP_ZERO_PAGE_ALLOC_FAILED,
> 
> I think these names are a bit terse.  It's certainly not _writes_ that
> are failing and "THP_WRITE_FAILED" makes it sound that way.

Right. s/THP_WRITE_FAILED/THP_WRITE_ALLOC_FAILED/

> Also, why do we need to differentiate these from the existing anon-hugepage
> vm stats?  The alloc_pages() call seems to be doing the exact same thing in
> the end.  Is one more likely to succeed than the other?

Existing stats specify source of thp page: fault or collapse. When we
allocate a new huge page with write(2) it's nither fault nor collapse. I
think it's reasonable to introduce new type of event for that.

-- 
 Kirill A. Shutemov
