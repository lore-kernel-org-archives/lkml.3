Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab3BMKfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:35:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab3BMKfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:35:02 -0500
Date: Wed, 13 Feb 2013 11:34:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v3 4/7] memcg: remove memcg from the reclaim iterators
Message-ID: <20130213103459.GB23562@dhcp22.suse.cz>
References: <20130211212756.GC29000@dhcp22.suse.cz>
 <20130211223943.GC15951@cmpxchg.org>
 <20130212095419.GB4863@dhcp22.suse.cz>
 <20130212151002.GD15951@cmpxchg.org>
 <20130212154330.GG4863@dhcp22.suse.cz>
 <20130212161332.GI4863@dhcp22.suse.cz>
 <20130212162442.GJ4863@dhcp22.suse.cz>
 <63d3b5fa-dbc6-4bc9-8867-f9961e644305@email.android.com>
 <20130212171216.GA17663@dhcp22.suse.cz>
 <20130212173741.GD25235@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212173741.GD25235@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-02-13 12:37:41, Johannes Weiner wrote:
> On Tue, Feb 12, 2013 at 06:12:16PM +0100, Michal Hocko wrote:
[...]
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 727ec39..31bb9b0 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -144,8 +144,13 @@ struct mem_cgroup_stat_cpu {
> >  };
> >  
> >  struct mem_cgroup_reclaim_iter {
> > -	/* last scanned hierarchy member with elevated css ref count */
> > +	/*
> > +	 * last scanned hierarchy member. Valid only if last_dead_count
> > +	 * matches memcg->dead_count of the hierarchy root group.
> > +	 */
> >  	struct mem_cgroup *last_visited;
> > +	unsigned int last_dead_count;
> 
> Since we read and write this without a lock, I would feel more
> comfortable if this were a full word, i.e. unsigned long.  That
> guarantees we don't see any partial states.

OK. Changed. Although I though that int is read/modified atomically as
well if it is aligned to its size.
-- 
Michal Hocko
SUSE Labs
