Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3JJUJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:09:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:10589 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab3JJUJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1074,1371106800"; 
   d="scan'208";a="415077084"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
In-Reply-To: <00000141a3f48ada-37ee9c14-2f2b-40a2-93f4-70258363351b-000000@email.amazonses.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1381428359-14843-35-git-send-email-kirill.shutemov@linux.intel.com>
 <00000141a3f48ada-37ee9c14-2f2b-40a2-93f4-70258363351b-000000@email.amazonses.com>
Subject: Re: [PATCH 34/34] mm: dynamically allocate page->ptl if it cannot be
 embedded to struct page
Content-Transfer-Encoding: 7bit
Message-Id: <20131010200921.91D84E0090@blue.fi.intel.com>
Date: Thu, 10 Oct 2013 23:09:21 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 10 Oct 2013, Kirill A. Shutemov wrote:
> 
> > +static inline bool ptlock_alloc(struct page *page)
> > +{
> > +	if (sizeof(spinlock_t) > sizeof(page->ptl))
> > +		return __ptlock_alloc(page);
> > +	return true;
> > +}
> 
> Could you make the check a CONFIG option? CONFIG_PTLOCK_DOES_NOT_FIT_IN_PAGE_STRUCT or
> so?

No. We will have to track what affects sizeof(spinlock_t) manually.
Not a fun and error prune.

C sucks. ;)

-- 
 Kirill A. Shutemov
