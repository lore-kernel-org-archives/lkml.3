Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaEANjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:39:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaEANjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:39:43 -0400
Date: Thu, 1 May 2014 14:39:38 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/17] mm: Do not use atomic operations when releasing
 pages
Message-ID: <20140501133938.GK23991@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-15-git-send-email-mgorman@suse.de>
 <20140501132922.GD23420@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140501132922.GD23420@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 09:29:22AM -0400, Johannes Weiner wrote:
> On Thu, May 01, 2014 at 09:44:45AM +0100, Mel Gorman wrote:
> > There should be no references to it any more and a parallel mark should
> > not be reordered against us. Use non-locked varient to clear page active.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> >  mm/swap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/swap.c b/mm/swap.c
> > index f2228b7..7a5bdd7 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -854,7 +854,7 @@ void release_pages(struct page **pages, int nr, bool cold)
> >  		}
> >  
> >  		/* Clear Active bit in case of parallel mark_page_accessed */
> > -		ClearPageActive(page);
> > +		__ClearPageActive(page);
> 
> Shouldn't this comment be removed also?

Why? We're still clearing the active bit.

-- 
Mel Gorman
SUSE Labs
