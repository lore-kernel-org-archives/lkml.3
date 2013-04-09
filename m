Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936742Ab3DICwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:52:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60554 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934470Ab3DICv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:51:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <5163823B.4020109@jp.fujitsu.com>
Date: Tue, 09 Apr 2013 11:51:39 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 04/12] memcg, kmem: fix reference count handling on the
 error path
References: <5162648B.9070802@huawei.com> <516264D6.3090100@huawei.com>
In-Reply-To: <516264D6.3090100@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/08 15:33), Li Zefan wrote:
> From: Michal Hocko <mhocko@suse.cz>
> 
> mem_cgroup_css_online calls mem_cgroup_put if memcg_init_kmem
> fails. This is not correct because only memcg_propagate_kmem takes an
> additional reference while mem_cgroup_sockets_init is allowed to fail as
> well (although no current implementation fails) but it doesn't take any
> reference. This all suggests that it should be memcg_propagate_kmem that
> should clean up after itself so this patch moves mem_cgroup_put over
> there.
> 
> Unfortunately this is not that easy (as pointed out by Li Zefan) because
> memcg_kmem_mark_dead marks the group dead (KMEM_ACCOUNTED_DEAD) if it
> is marked active (KMEM_ACCOUNTED_ACTIVE) which is the case even if
> memcg_propagate_kmem fails so the additional reference is dropped in
> that case in kmem_cgroup_destroy which means that the reference would be
> dropped two times.
> 
> The easiest way then would be to simply remove mem_cgrroup_put from
> mem_cgroup_css_online and rely on kmem_cgroup_destroy doing the right
> thing.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Cc: <stable@vger.kernel.org> # 3.8.x

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


