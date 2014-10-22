Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbaJVBw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:52:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40177 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaJVBw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:52:27 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <54470DC5.4050709@jp.fujitsu.com>
Date: Wed, 22 Oct 2014 10:52:05 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/4] mm: memcontrol: remove unnecessary PCG_MEM memory
 charge flag
References: <1413818532-11042-1-git-send-email-hannes@cmpxchg.org> <1413818532-11042-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1413818532-11042-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/21 0:22), Johannes Weiner wrote:
> PCG_MEM is a remnant from an earlier version of 0a31bc97c80c ("mm:
> memcontrol: rewrite uncharge API"), used to tell whether migration
> cleared a charge while leaving pc->mem_cgroup valid and PCG_USED set.
> But in the final version, mem_cgroup_migrate() directly uncharges the
> source page, rendering this distinction unnecessary.  Remove it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>   include/linux/page_cgroup.h | 1 -
>   mm/memcontrol.c             | 4 +---
>   2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index da62ee2be28b..97536e685843 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -4,7 +4,6 @@
>   enum {
>   	/* flags for mem_cgroup */
>   	PCG_USED = 0x01,	/* This page is charged to a memcg */
> -	PCG_MEM = 0x02,		/* This page holds a memory charge */
>   };
>   
>   struct pglist_data;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9bab35fc3e9e..1d66ac49e702 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2606,7 +2606,7 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
>   	 *   have the page locked
>   	 */
>   	pc->mem_cgroup = memcg;
> -	pc->flags = PCG_USED | PCG_MEM;
> +	pc->flags = PCG_USED;
>   
>   	if (lrucare)
>   		unlock_page_lru(page, isolated);
> @@ -6177,8 +6177,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>   	if (!PageCgroupUsed(pc))
>   		return;
>   
> -	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
> -
>   	if (lrucare)
>   		lock_page_lru(oldpage, &isolated);
>   
> 


