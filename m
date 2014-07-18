Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbaGRHMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:12:52 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35667 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaGRHMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:12:49 -0400
Date: Fri, 18 Jul 2014 09:12:46 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Message-ID: <20140718071246.GA21565@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715082545.GA9366@dhcp22.suse.cz>
 <20140715121935.GB9366@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715121935.GB9366@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-07-14 14:19:35, Michal Hocko wrote:
> [...]
> > +/**
> > + * mem_cgroup_migrate - migrate a charge to another page
> > + * @oldpage: currently charged page
> > + * @newpage: page to transfer the charge to
> > + * @lrucare: page might be on LRU already
> 
> which one? I guess the newpage?
> 
> > + *
> > + * Migrate the charge from @oldpage to @newpage.
> > + *
> > + * Both pages must be locked, @newpage->mapping must be set up.
> > + */
> > +void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
> > +			bool lrucare)
> > +{
> > +	unsigned int nr_pages = 1;
> > +	struct page_cgroup *pc;
> > +
> > +	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
> > +	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
> > +	VM_BUG_ON_PAGE(PageLRU(oldpage), oldpage);
> > +	VM_BUG_ON_PAGE(PageLRU(newpage), newpage);
> 
> 	VM_BUG_ON_PAGE(PageLRU(newpage) && !lruvec, newpage);

I guess everything except these two notes got addressed.

-- 
Michal Hocko
SUSE Labs
