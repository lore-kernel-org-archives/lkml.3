Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaGXJDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:03:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaGXJDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:03:00 -0400
Date: Thu, 24 Jul 2014 11:02:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Message-ID: <20140724090257.GB14578@dhcp22.suse.cz>
References: <20140718144554.GG29639@cmpxchg.org>
 <CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
 <20140719173911.GA1725@cmpxchg.org>
 <20140722150825.GA4517@dhcp22.suse.cz>
 <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
 <20140723143847.GB16721@dhcp22.suse.cz>
 <20140723150608.GF1725@cmpxchg.org>
 <CAJfpegs-k5QC+42SzLKUSaHrdPxWBaT_dF+SOPqoDvg8h5p_Tw@mail.gmail.com>
 <20140723210241.GH1725@cmpxchg.org>
 <20140724084644.GA14578@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724084644.GA14578@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-07-14 10:46:44, Michal Hocko wrote:
> On Wed 23-07-14 17:02:41, Johannes Weiner wrote:
[...]
> We can reduce the lookup only to lruvec==true case, no?

Dohh
s@can@should@

newpage shouldn't charged in all other cases and it would be bug.
Or am I missing something?

> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> > ---
> >  mm/memcontrol.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index b7c9a202dee9..3eaa6e83c168 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6660,6 +6660,12 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
> >  	if (mem_cgroup_disabled())
> >  		return;
> >  
> > +	/* Page cache replacement: new page already charged? */
> > +	pc = lookup_page_cgroup(newpage);
> > +	if (PageCgroupUsed(pc))
> > +		return;
> > +
> > +	/* Re-entrant migration: old page already uncharged? */
> >  	pc = lookup_page_cgroup(oldpage);
> >  	if (!PageCgroupUsed(pc))
> >  		return;
> > -- 
> > 2.0.0
> > 
> 
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
