Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab3EWXkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 19:40:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759898Ab3EWXkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 19:40:20 -0400
Date: Thu, 23 May 2013 16:40:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, aarcange@redhat.com,
        dave.hansen@intel.com, dsterba@suse.cz, hannes@cmpxchg.org,
        kosaki.motohiro@gmail.com, kirill.shutemov@linux.intel.com,
        mpm@selenic.com, n-horiguchi@ah.jp.nec.com, rdunlap@infradead.org
Subject: Re: [PATCH v3] mm/pagewalk.c: walk_page_range should avoid
 VM_PFNMAP areas
Message-Id: <20130523164018.bed0409e29b46901bcc67960@linux-foundation.org>
In-Reply-To: <E1Ucb6K-00047X-9I@eag09.americas.sgi.com>
References: <E1Ucb6K-00047X-9I@eag09.americas.sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013 07:46:36 -0500 Cliff Wickman <cpw@sgi.com> wrote:

> Certain tests in walk_page_range() (specifically split_huge_page_pmd())
> assume that all the mapped PFN's are backed with page structures. And this is
> not usually true for VM_PFNMAP areas. This can result in panics on kernel
> page faults when attempting to address those page structures.
> 
> There are a half dozen callers of walk_page_range() that walk through
> a task's entire page table (as N. Horiguchi pointed out). So rather than
> change all of them, this patch changes just walk_page_range() to ignore 
> VM_PFNMAP areas.
> 
> The logic of hugetlb_vma() is moved back into walk_page_range(), as we
> want to test any vma in the range.
> 
> VM_PFNMAP areas are used by:
> - graphics memory manager   gpu/drm/drm_gem.c
> - global reference unit     sgi-gru/grufile.c
> - sgi special memory        char/mspec.c
> - and probably several out-of-tree modules

What are your thoughts on the urgency/scheduling of this fix?


(Just to be irritating: "When writing a changelog, please describe the
end-user-visible effects of the bug, so that others can more easily
decide which kernel version(s) should be fixed, and so that downstream
kernel maintainers can more easily work out whether this patch will fix
a problem which they or their customers are observing.")
