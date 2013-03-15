Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3CONZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:25:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:25709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab3CONZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:25:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="279997579"
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
In-Reply-To: <CAJd=RBCxNgjUUSbbTnVymC7+O51LKDuKTyTkEGYwuWYB9_oUmw@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-17-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBCxNgjUUSbbTnVymC7+O51LKDuKTyTkEGYwuWYB9_oUmw@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 16/30] thp: handle file pages in split_huge_page()
Content-Transfer-Encoding: 7bit
Message-Id: <20130315132656.BC518E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:26:56 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > -int split_huge_page(struct page *page)
> > +static int split_anon_huge_page(struct page *page)
> >  {
> >         struct anon_vma *anon_vma;
> >         int ret = 1;
> >
> > -       BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
> > -       BUG_ON(!PageAnon(page));
> > -
> deleted, why?

split_anon_huge_page() should only be called from split_huge_page().
Probably I could bring it back, but it's kinda redundant.

-- 
 Kirill A. Shutemov
