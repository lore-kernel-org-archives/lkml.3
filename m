Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3KGJGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:06:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab3KGJGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:06:32 -0500
Date: Thu, 7 Nov 2013 09:06:29 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Don Morris <don.morris@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: soft lockup - CPU#8 stuck for 22s!
Message-ID: <20131107090629.GA5040@suse.de>
References: <5266B5F2.5070102@hp.com>
 <20131104170413.GA25764@suse.de>
 <alpine.DEB.2.02.1311061626210.22318@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311061626210.22318@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 04:30:05PM -0800, David Rientjes wrote:
> On Mon, 4 Nov 2013, Mel Gorman wrote:
> 
> > This maybe?
> > 
> > ---8<---
> > mm: memcontrol: Release css_set_lock when aborting an OOM scan
> > 
> > css_task_iter_start acquires the css_set_lock and it must be released with
> > a call to css_task_iter_end. Commmit 9cbb78bb (mm, memcg: introduce own
> > oom handler to iterate only over its own threads) introduced a loop that
> > was not guaranteed to call css_task_iter_end.
> > 
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 5ef8929..941f67d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1795,6 +1795,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  				mem_cgroup_iter_break(memcg, iter);
> >  				if (chosen)
> >  					put_task_struct(chosen);
> > +				css_task_iter_end(&it);
> >  				return;
> >  			case OOM_SCAN_OK:
> >  				break;
> 
> What tree is this?
> 
> I'm afraid I don't understand this at all, I thought css_task_iter_end() 
> was added to take over for cgroup_task_iter_end() and 
> mem_cgroup_out_of_memory() was modified with 72ec7029937f ("cgroup: make 
> task iterators deal with cgroup_subsys_state instead of cgroup") 
> correctly.  Why do we need to call css_task_iter_end() twice with your 
> patch?

I screwed up, patch is broken. I'll recheck for imbalances in the
handling of css_set_lock. Sorry for the noise.

-- 
Mel Gorman
SUSE Labs
