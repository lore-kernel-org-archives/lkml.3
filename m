Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3CONWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:22:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:13226 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab3CONWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:22:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="271309413"
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
In-Reply-To: <CAJd=RBDWGNUvjPBiOmYDOfwbf8ZvyoMDdZn8uhcN0xTNbgKYfA@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-10-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBDWGNUvjPBiOmYDOfwbf8ZvyoMDdZn8uhcN0xTNbgKYfA@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 09/30] thp, mm: rewrite delete_from_page_cache() to
 support huge pages
Content-Transfer-Encoding: 7bit
Message-Id: <20130315132359.19AB9E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:23:59 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > +       if (PageTransHuge(page)) {
> > +               int i;
> > +
> > +               for (i = 0; i < HPAGE_CACHE_NR; i++)
> > +                       radix_tree_delete(&mapping->page_tree, page->index + i);
> 
> Move the below page_cache_release for tail page here, please.

Okay. Thanks.

> > +               nr = HPAGE_CACHE_NR;
> [...]
> > +       if (PageTransHuge(page))
> > +               for (i = 1; i < HPAGE_CACHE_NR; i++)
> > +                       page_cache_release(page + i);
> >         page_cache_release(page);

-- 
 Kirill A. Shutemov
