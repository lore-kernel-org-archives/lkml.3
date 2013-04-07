Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071Ab3DGUVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 16:21:38 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:49290 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552Ab3DGUVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 16:21:36 -0400
Date: Sun, 7 Apr 2013 22:21:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 0/7] memcg: make memcg's life cycle the same as
 cgroup
Message-ID: <20130407202130.GB12678@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
 <20130404120049.GI29911@dhcp22.suse.cz>
 <51610B78.7080001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51610B78.7080001@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 07-04-13 14:00:24, Li Zefan wrote:
> On 2013/4/4 20:00, Michal Hocko wrote:
> > On Wed 03-04-13 17:11:15, Li Zefan wrote:
> >> (I'll be off from my office soon, and I won't be responsive in the following
> >> 3 days.)
> >>
> >> I'm working on converting memcg to use cgroup->id, and then we can kill css_id.
> >>
> >> Now memcg has its own refcnt, so when a cgroup is destroyed, the memcg can
> >> still be alive. This patchset converts memcg to always use css_get/put, so
> >> memcg will have the same life cycle as its corresponding cgroup, and then
> >> it's always safe for memcg to use cgroup->id.
> >>
> >> The historical reason that memcg didn't use css_get in some cases, is that
> >> cgroup couldn't be removed if there're still css refs. The situation has
> >> changed so that rmdir a cgroup will succeed regardless css refs, but won't
> >> be freed until css refs goes down to 0.
> >>
> >> This is an early post, and it's NOT TESTED. I just want to see if the changes
> >> are fine in general.
> > 
> > yes, I like the approach and it looks correct as well (some minor things
> > mentioned in the patches). Thanks a lot Li! This will make our lifes much
> > easier. The separate ref counting was PITA especially after
> > introduction of kmem accounting which made its usage even more trickier.
> > 
> >> btw, after this patchset I think we don't need to free memcg via RCU, because
> >> cgroup is already freed in RCU callback.
> > 
> > But this depends on changes waiting in for-3.10 branch, right?
> 
> What changes? memcg changes or cgroup core changes? I don't think this depends
> on anything in cgroup 3.10 branch.

cgroup (be445626 e.g.) but now I've noticed that those are already
merged in Linus tree.

FYI: I've cherry-picked themo my -mm git tree.
-- 
Michal Hocko
SUSE Labs
