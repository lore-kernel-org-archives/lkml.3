Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3DQTHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:07:24 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43277 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab3DQTHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:07:23 -0400
Date: Wed, 17 Apr 2013 12:07:04 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] thp: fix huge zero page logic for page with pfn == 0
Message-ID: <20130417190511.GA8753@cmpxchg.org>
References: <1366211253-14325-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366211253-14325-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 06:07:33PM +0300, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Current implementation of huge zero page uses pfn value 0 to indicate
> that the page hasn't allocated yet. It assumes that buddy page allocator
> can't return page with pfn == 0.
> 
> Let's rework the code to store 'struct page *' of huge zero page, not
> its pfn. This way we can avoid the weak assumption.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Minchan Kim <minchan@kernel.org>
> Acked-by: Minchan Kim <minchan@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
