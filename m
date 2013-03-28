Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab3C1Oak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:30:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:48889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab3C1Oaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:30:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,925,1355126400"; 
   d="scan'208";a="313191082"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave <dave@sr71.net>
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
In-Reply-To: <514CA05D.6030302@sr71.net>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-17-git-send-email-kirill.shutemov@linux.intel.com>
 <514CA05D.6030302@sr71.net>
Subject: Re: [PATCHv2, RFC 16/30] thp: handle file pages in split_huge_page()
Content-Transfer-Encoding: 7bit
Message-Id: <20130328143227.61B0CE0085@blue.fi.intel.com>
Date: Thu, 28 Mar 2013 16:32:27 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave wrote:
> On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> > +static int split_anon_huge_page(struct page *page)
> >  {
> >  	struct anon_vma *anon_vma;
> >  	int ret = 1;
> >  
> > -	BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
> > -	BUG_ON(!PageAnon(page));
> 
> Did you really mean to kill these BUG_ON()s?  They still look relevant
> to me.

The zero page BUG_ON() is moved to new split_huge_page().
!PageAnon(page) we now can handle.

Note: nobody should call split_anon_huge_page() directly, only
split_huge_page().

-- 
 Kirill A. Shutemov
