Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab3CZIKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:10:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab3CZIKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:10:08 -0400
Date: Tue, 26 Mar 2013 09:10:04 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Message-ID: <20130326081004.GH2295@dhcp22.suse.cz>
References: <20130321090849.GF6094@dhcp22.suse.cz>
 <20130321102257.GH6094@dhcp22.suse.cz>
 <514BB23E.70908@huawei.com>
 <20130322080749.GB31457@dhcp22.suse.cz>
 <514C1388.6090909@huawei.com>
 <514C14BF.3050009@parallels.com>
 <20130322093141.GE31457@dhcp22.suse.cz>
 <514EAC41.5050700@huawei.com>
 <20130325090629.GN2154@dhcp22.suse.cz>
 <515153C0.5070908@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515153C0.5070908@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-03-13 15:52:32, Li Zefan wrote:
[...]
> ...
> >  static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
> >  					 struct kmem_cache *s)
> >  {
> > -	char *name;
> >  	struct kmem_cache *new;
> > +	static char *tmp_name = NULL;
> 
> (minor nitpick) why not preserve the name "name"

I wanted to make it clear that the name is just temporal

-- 
Michal Hocko
SUSE Labs
