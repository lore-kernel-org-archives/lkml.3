Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3DZP3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:29:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:48987 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab3DZP3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:29:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,559,1363158000"; 
   d="scan'208";a="293646067"
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
In-Reply-To: <5163155D.7030401@sr71.net>
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1365163198-29726-33-git-send-email-kirill.shutemov@linux.intel.com>
 <5163155D.7030401@sr71.net>
Subject: Re: [PATCHv3, RFC 32/34] thp: handle write-protect exception to
 file-backed huge pages
Content-Transfer-Encoding: 7bit
Message-Id: <20130426153104.92450E0085@blue.fi.intel.com>
Date: Fri, 26 Apr 2013 18:31:04 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> > +			if (!PageAnon(page)) {
> > +				add_mm_counter(mm, MM_FILEPAGES, -HPAGE_PMD_NR);
> > +				add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
> > +			}
> 
> This seems like a bit of a hack.  Shouldn't we have just been accounting
> to MM_FILEPAGES in the first place?

No, it's not.

It handles MAP_PRIVATE file mappings. The page was read first and
accounted to MM_FILEPAGES and then COW'ed by anon page here, so we have to
adjust counters. do_wp_page() has similar code.

-- 
 Kirill A. Shutemov
