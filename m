Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3IWRjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:39:00 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55851 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab3IWRi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:38:59 -0400
Date: Mon, 23 Sep 2013 12:19:16 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Bob Liu <bob.liu@oracle.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 0/5] mm: migrate zbud pages
Message-ID: <20130923171916.GA23643@variantweb.net>
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
 <5237FDCC.5010109@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5237FDCC.5010109@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092317-0320-0000-0000-00000118E0EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 02:59:24PM +0800, Bob Liu wrote:
> Hi Krzysztof,
> 
> On 09/11/2013 04:58 PM, Krzysztof Kozlowski wrote:
> > Hi,
> > 
> > Currently zbud pages are not movable and they cannot be allocated from CMA
> > (Contiguous Memory Allocator) region. These patches add migration of zbud pages.
> > 
> 
> I agree that the migration of zbud pages is important so that system
> will not enter order-0 page fragmentation and can be helpful for page
> compaction/huge pages etc..
> 
> But after I looked at the [patch 4/5], I found it will make zbud very
> complicated.
> I'd prefer to add this migration feature later until current version
> zswap/zbud becomes better enough and more stable.

I agree with this.  We are also looking to add zsmalloc as an option too.  It
would be nice to come up with a solution that worked for both (any) allocator
that zswap used.

> 
> Mel mentioned several problems about zswap/zbud in thread "[PATCH v6
> 0/5] zram/zsmalloc promotion".
> 
> Like "it's clunky as hell and the layering between zswap and zbud is
> twisty" and "I think I brought up its stalling behaviour during review
> when it was being merged. It would have been preferable if writeback
> could be initiated in batches and then waited on at the very least..
>  It's worse that it uses _swap_writepage directly instead of going
> through a writepage ops.  It would have been better if zbud pages
> existed on the LRU and written back with an address space ops and
> properly handled asynchonous writeback."

Yes, the laying in zswap vs zbud is wonky and should be addressed before adding
new layers.

> 
> So I think it would be better if we can address those issues at first
> and it would be easier to address these issues before adding more new
> features. Welcome any ideas.

Agreed.

Seth

