Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936722Ab3DICxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:53:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59915 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934461Ab3DICxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:53:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <5163829C.3030809@jp.fujitsu.com>
Date: Tue, 09 Apr 2013 11:53:16 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 06/12] memcg: don't use mem_cgroup_get() when creating
 a kmemcg cache
References: <5162648B.9070802@huawei.com> <516264F1.8020904@huawei.com>
In-Reply-To: <516264F1.8020904@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/08 15:34), Li Zefan wrote:
> Use css_get()/css_put() instead of mem_cgroup_get()/mem_cgroup_put().
> 
> There are two things being done in the current code:
> 
> First, we acquired a css_ref to make sure that the underlying cgroup
> would not go away. That is a short lived reference, and it is put as
> soon as the cache is created.
> 
> At this point, we acquire a long-lived per-cache memcg reference count
> to guarantee that the memcg will still be alive.
> 
> so it is:
> 
> enqueue: css_get
> create : memcg_get, css_put
> destroy: memcg_put
> 
> So we only need to get rid of the memcg_get, change the memcg_put to
> css_put, and get rid of the now extra css_put.
> 
> (This changelog is basically written by Glauber)
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


