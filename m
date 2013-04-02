Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692Ab3DBIEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:04:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:54567 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3DBIEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:04:23 -0400
Message-ID: <515A90ED.7010208@huawei.com>
Date: Tue, 2 Apr 2013 16:03:57 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: don't do cleanup manually if mem_cgroup_css_online()
 fails
References: <515A8A40.6020406@huawei.com>
In-Reply-To: <515A8A40.6020406@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/2 15:35, Li Zefan wrote:
> If memcg_init_kmem() returns -errno when a memcg is being created,
> mem_cgroup_css_online() will decrement memcg and its parent's refcnt,

> (but strangely there's no mem_cgroup_put() for mem_cgroup_get() called
> in memcg_propagate_kmem()).

The comment in memcg_propagate_kmem() suggests it knows mem_cgroup_css_free()
will be called in failure, while mem_cgroup_css_online() doesn't know.

> 
> But then cgroup core will call mem_cgroup_css_free() to do cleanup...
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  mm/memcontrol.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)

