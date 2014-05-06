Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaEFT4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:56:52 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:52081 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaEFT4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:56:50 -0400
Date: Tue, 6 May 2014 21:56:45 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] memcg, doc: clarify global vs. limit reclaims
Message-ID: <20140506195645.GC30921@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <1398688005-26207-4-git-send-email-mhocko@suse.cz>
 <20140430230350.GF26041@cmpxchg.org>
 <20140502094351.GD3446@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502094351.GD3446@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, could you queue this one please?

On Fri 02-05-14 11:43:51, Michal Hocko wrote:
[...]
> From 30b9505169e574cdb553226e1a361cc527ed492b Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Fri, 2 May 2014 11:42:35 +0200
> Subject: [PATCH] mmotm: memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
> 
> update doc as per Johannes
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  Documentation/cgroups/memory.txt | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index add1be001416..2cde96787ceb 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -241,17 +241,9 @@ global VM. Cgroups can get reclaimed basically under two conditions
>     proportionally wrt. their LRU size in a round robin fashion
>   - when a cgroup or its hierarchical parent (see 6. Hierarchical support)
>     hits hard limit. If the reclaim is unsuccessful, an OOM routine is invoked
> -   to select and kill the bulkiest task in the cgroup. (See 10. OOM Control
> +   to select and kill the bulkiest task in the hiearchy. (See 10. OOM Control
>     below.)
>  
> -Global and hard-limit reclaims share the same code the only difference
> -is the objective of the reclaim. The global reclaim aims at balancing
> -zones' watermarks while the limit reclaim frees some memory to allow new
> -charges.
> -
> -NOTE: Hard limit reclaim does not work for the root cgroup, since we cannot set
> -any limits on the root cgroup.
> -
>  Note2: When panic_on_oom is set to "2", the whole system will panic.
>  
>  When oom event notifier is registered, event will be delivered to the root
> -- 
> 2.0.0.rc0
> 
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
