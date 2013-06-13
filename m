Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab3FMTxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:53:09 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:58319 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab3FMTxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:53:07 -0400
Date: Thu, 13 Jun 2013 12:53:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v3 5/9] memcg: use css_get/put when charging/uncharging
 kmem
Message-ID: <20130613195300.GE13970@mtj.dyndns.org>
References: <51B98D17.2050902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B98D17.2050902@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 05:12:55PM +0800, Li Zefan wrote:
> Sorry for updating the patchset so late.
> 
> I've made some changes for the memory barrier thing, and I agree with
> Michal that there can be improvement but can be a separate patch.
> 
> If this version is ok for everyone, I'll send the whole patchset out
> to Andrew.

Can you please post an updated patch as reply to the original patch?
It's a bit difficult to follow things.

> =========================
> 
> Use css_get/put instead of mem_cgroup_get/put.
> 
> We can't do a simple replacement, because here mem_cgroup_put()
> is called during mem_cgroup_css_free(), while mem_cgroup_css_free()
> won't be called until css refcnt goes down to 0.
> 
> Instead we increment css refcnt in mem_cgroup_css_offline(), and
> then check if there's still kmem charges. If not, css refcnt will
> be decremented immediately, otherwise the refcnt won't be decremented
> when kmem charges goes down to 0.
> 
> v3:
> - changed wmb() to smp_smb(), and moved it to memcg_kmem_mark_dead(),
>   and added comment.
> 
> v2:
> - added wmb() in kmem_cgroup_css_offline(), pointed out by Michal
> - revised comments as suggested by Michal
> - fixed to check if kmem is activated in kmem_cgroup_css_offline()
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

But let's please remove the barrier dancing.

Thanks.

-- 
tejun
