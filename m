Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab3JOLc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:32:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:9973 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab3JOLc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:32:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="307955615"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.LNX.2.00.1310150358170.11905@eggly.anvils>
References: <alpine.LNX.2.00.1310150358170.11905@eggly.anvils>
Subject: RE: mm: fix BUG in __split_huge_page_pmd
Content-Transfer-Encoding: 7bit
Message-Id: <20131015113254.14E88E0090@blue.fi.intel.com>
Date: Tue, 15 Oct 2013 14:32:54 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Occasionally we hit the BUG_ON(pmd_trans_huge(*pmd)) at the end of
> __split_huge_page_pmd(): seen when doing madvise(,,MADV_DONTNEED).
> 
> It's invalid: we don't always have down_write of mmap_sem there:
> a racing do_huge_pmd_wp_page() might have copied-on-write to another
> huge page before our split_huge_page() got the anon_vma lock.
> 
> Forget the BUG_ON, just go back and try again if this happens.
>     
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org

Looks reasonable to me.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

madvise(MADV_DONTNEED) was aproblematic with THP before. Is a big win having
mmap_sem taken on read rather than on write for it?

-- 
 Kirill A. Shutemov
