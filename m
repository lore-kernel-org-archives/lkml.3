Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3CONZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:25:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:6885 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab3CONZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:25:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="307140945"
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
In-Reply-To: <CAJd=RBA-CRVu2is9=9E1Y0=HFRHs1TXvFvm2wF7gT+=ujQ+8tg@mail.gmail.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-15-git-send-email-kirill.shutemov@linux.intel.com>
 <CAJd=RBA-CRVu2is9=9E1Y0=HFRHs1TXvFvm2wF7gT+=ujQ+8tg@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 14/30] thp, mm: naive support of thp in generic
 read/write routines
Content-Transfer-Encoding: 7bit
Message-Id: <20130315132716.AF225E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 15:27:16 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > +               if (PageTransTail(page)) {
> > +                       page_cache_release(page);
> > +                       page = find_get_page(mapping,
> > +                                       index & ~HPAGE_CACHE_INDEX_MASK);
> check page is valid, please.

Good catch. Fixed.

> > +                       if (!PageTransHuge(page)) {
> > +                               page_cache_release(page);
> > +                               goto find_page;
> > +                       }
> > +               }

-- 
 Kirill A. Shutemov
