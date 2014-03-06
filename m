Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbaCFCx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:53:29 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59968 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbaCFCx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:53:27 -0500
Date: Wed, 5 Mar 2014 18:53:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch 04/11] mm, memcg: add tunable for oom reserves
In-Reply-To: <20140305131757.ad538637c096266664c45f04@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1403051853010.30075@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com> <alpine.DEB.2.02.1403041955050.8067@chino.kir.corp.google.com> <20140305131757.ad538637c096266664c45f04@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Andrew Morton wrote:

> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -315,6 +315,9 @@ struct mem_cgroup {
> >  	/* OOM-Killer disable */
> >  	int		oom_kill_disable;
> >  
> > +	/* reserves for handling oom conditions, protected by res.lock */
> > +	unsigned long long	oom_reserve;
> 
> Units?  bytes, I assume.
> 

Yes, fixed.

> >  	/* set when res.limit == memsw.limit */
> >  	bool		memsw_is_minimum;
> >  
> > @@ -5936,6 +5939,51 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
> >  	return 0;
> >  }
> >  
> > +static int mem_cgroup_resize_oom_reserve(struct mem_cgroup *memcg,
> > +					 unsigned long long new_limit)
> > +{
> > +	struct res_counter *res = &memcg->res;
> > +	u64 limit, usage;
> > +	int ret = 0;
> 
> The code mixes u64's and unsigned long longs in inexplicable ways. 
> Suggest using u64 throughout.
> 

Ok!
