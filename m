Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935777Ab3DID6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:58:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45318 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab3DID6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:58:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <516391D1.2060508@jp.fujitsu.com>
Date: Tue, 09 Apr 2013 12:58:09 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/8] memcg: convert to use cgroup_is_ancestor()
References: <51627DA9.7020507@huawei.com> <51627DFA.9050007@huawei.com>
In-Reply-To: <51627DFA.9050007@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/08 17:21), Li Zefan wrote:
> This is a preparation to kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>   mm/memcontrol.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5aa6e91..14f1375 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1383,7 +1383,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
>   		return true;
>   	if (!root_memcg->use_hierarchy || !memcg)
>   		return false;
> -	return css_is_ancestor(&memcg->css, &root_memcg->css);
> +	return cgroup_is_ancestor(memcg->css.cgroup, root_memcg->css.cgroup);
>   }
>   
>   static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
> 

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

