Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaJOUFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:05:36 -0400
Received: from mta-out1.inet.fi ([62.71.2.234]:47400 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaJOUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:05:33 -0400
Date: Wed, 15 Oct 2014 23:05:01 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yu Zhao <yuzhao@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: free compound page with correct order
Message-ID: <20141015200501.GA17066@node.dhcp.inet.fi>
References: <1413400805-15547-1-git-send-email-yuzhao@google.com>
 <20141015123044.03f38a520b01c5d332e3d9a5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015123044.03f38a520b01c5d332e3d9a5@linux-foundation.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 12:30:44PM -0700, Andrew Morton wrote:
> > @@ -232,7 +232,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
> >  	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
> >  		struct page *zero_page = xchg(&huge_zero_page, NULL);
> >  		BUG_ON(zero_page == NULL);
> > -		__free_page(zero_page);
> > +		__free_pages(zero_page, compound_order(zero_page));
> 
> But I'm surprised that this is also rare.  It makes me wonder if this
> code is working correctly.

This should be rare too. To get here we need a situation when huge zero
page is allocated, but not mapped and we get memory presure to trigger
shrinker.

-- 
 Kirill A. Shutemov
