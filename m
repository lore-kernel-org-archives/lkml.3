Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbaEMOJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:09:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964834AbaEMOJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:09:14 -0400
Date: Tue, 13 May 2014 15:09:08 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 10/19] mm: page_alloc: Reduce number of times page_to_pfn
 is called
Message-ID: <20140513140908.GS23991@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-11-git-send-email-mgorman@suse.de>
 <53721DC1.1040006@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <53721DC1.1040006@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:27:29PM +0200, Vlastimil Babka wrote:
> On 05/13/2014 11:45 AM, Mel Gorman wrote:
> >In the free path we calculate page_to_pfn multiple times. Reduce that.
> >
> >Signed-off-by: Mel Gorman <mgorman@suse.de>
> >Acked-by: Rik van Riel <riel@redhat.com>
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Just two comments.
> I just don't like #define but I can live with that.

page_to_pfn is not available in that context due to header dependency
problems. It can be avoided by moving the two functions into mm/internal.h
so I'll do that. I cannot see why code outside of mm/ would be missing
with those bits anyway.

Thanks

-- 
Mel Gorman
SUSE Labs
