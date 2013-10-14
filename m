Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab3JNJMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:12:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:36165 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3JNJMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:12:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,491,1378882800"; 
   d="scan'208";a="416429455"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: David Howells <dhowells@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
In-Reply-To: <15762.1381509010@warthog.procyon.org.uk>
References: <1381428359-14843-16-git-send-email-kirill.shutemov@linux.intel.com>
 <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
 <15762.1381509010@warthog.procyon.org.uk>
Subject: Re: [PATCH 15/34] frv: handle pgtable_page_ctor() fail
Content-Transfer-Encoding: 7bit
Message-Id: <20131014091235.C06FBE0090@blue.fi.intel.com>
Date: Mon, 14 Oct 2013 12:12:35 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> 
> Acked-by: David Howells <dhowells@redhat.com>
> 
> for the FRV and MN10300 patches.
> 
> Can you move pte_alloc_one() to common code, at least for some arches?  I
> think that the FRV and MN10300 ones should end up the same after this - and I
> wouldn't be surprised if some of the other arches do too.

There's no true approach for generic. It depends on what pgtable_t is:
pointer to struct page or virtual address of the allocated page table.
Some arches also use some sort of cache for page table allocator. Others
don't.

I don't see a sensible way generalize it.

-- 
 Kirill A. Shutemov
