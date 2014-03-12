Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaCLOxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:53:08 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33992 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbaCLOxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:53:05 -0400
Date: Wed, 12 Mar 2014 10:53:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] mm: memcg: inline mem_cgroup_charge_common()
Message-ID: <20140312145300.GC14688@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
 <1394587714-6966-4-git-send-email-hannes@cmpxchg.org>
 <20140312125213.GB11831@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312125213.GB11831@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:52:13PM +0100, Michal Hocko wrote:
> On Tue 11-03-14 21:28:29, Johannes Weiner wrote:
> [...]
> > @@ -3919,20 +3919,21 @@ out:
> >  	return ret;
> >  }
> >  
> > -/*
> > - * Charge the memory controller for page usage.
> > - * Return
> > - * 0 if the charge was successful
> > - * < 0 if the cgroup is over its limit
> > - */
> > -static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
> > -				gfp_t gfp_mask, enum charge_type ctype)
> > +int mem_cgroup_newpage_charge(struct page *page,
> > +			      struct mm_struct *mm, gfp_t gfp_mask)
> 
> s/mem_cgroup_newpage_charge/mem_cgroup_anon_charge/ ?
> 
> Would be a better name? The patch would be bigger but the name more
> apparent...

I wouldn't be opposed to fixing those names at all, but I think that
is out of the scope of this patch.  Want to send one?

mem_cgroup_charge_anon() would be a good name, but then we should also
rename mem_cgroup_cache_charge() to mem_cgroup_charge_file() to match.

Or charge_private() vs. charge_shared()...

> Other than that I am good with this. Without (preferably) or without
> rename:
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!
