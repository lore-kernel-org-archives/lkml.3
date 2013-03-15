Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3CONXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:23:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:1119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab3CONXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:23:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="303416350"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAJd=RBCHLigJBWiBt==wjjm7HA3CYSSyS6odKy0BgoudVxN80g@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-14-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBCHLigJBWiBt==wjjm7HA3CYSSyS6odKy0BgoudVxN80g@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 13/30] thp, mm: implement
 grab_cache_huge_page_write_begin()
Content-Transfer-Encoding: 7bit
Message-Id: <20130315132440.C4DF8E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:24:40 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +struct page *grab_cache_huge_page_write_begin(struct address_space *mapping,
> > +                       pgoff_t index, unsigned flags);
> > +#else
> > +static inline struct page *grab_cache_huge_page_write_begin(
> > +               struct address_space *mapping, pgoff_t index, unsigned flags)
> > +{
> build bug?

Hm?. No. Why?

> > +       return NULL;
> > +}
> > +#endif
> >
> btw, how about grab_thp_write_begin?

Sounds better, thanks.

-- 
 Kirill A. Shutemov
