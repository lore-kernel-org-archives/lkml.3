Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab3GXOcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:32:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab3GXOcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:32:15 -0400
Date: Wed, 24 Jul 2013 16:32:14 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 0/8] memcg, cgroup: kill css_id
Message-ID: <20130724143214.GL2540@dhcp22.suse.cz>
References: <51EFA554.6080801@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFA554.6080801@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-07-13 17:58:44, Li Zefan wrote:
> This patchset converts memcg to use cgroup->id, and then we can remove
> cgroup css_id.
> 
> As we've removed memcg's own refcnt, converting memcg to use cgroup->id
> is very straight-forward.
> 
> The patchset is based on Tejun's cgroup tree.

Does it depend on any particular patches? I am asking because I would
need to cherry pick those and apply them into my -mm git tree before
these.

> Li Zefan (8):
>       cgroup: convert cgroup_ida to cgroup_idr
>       cgroup: document how cgroup IDs are assigned
>       cgroup: implement cgroup_from_id()
>       memcg: convert to use cgroup_is_descendant()
>       memcg: convert to use cgroup id
>       memcg: fail to create cgroup if the cgroup id is too big
>       memcg: stop using css id
>       cgroup: kill css_id
> --
>  include/linux/cgroup.h |  49 ++-------
>  kernel/cgroup.c        | 308 ++++++++-----------------------------------------------
>  mm/memcontrol.c        |  59 ++++++-----
>  3 files changed, 90 insertions(+), 326 deletions(-)

-- 
Michal Hocko
SUSE Labs
