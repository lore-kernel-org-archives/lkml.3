Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbaIENz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:55:29 -0400
Received: from mx2.parallels.com ([199.115.105.18]:52510 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbaIENz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:55:26 -0400
Date: Fri, 5 Sep 2014 17:55:07 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave@sr71.net>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: memcontrol: revert use of root_mem_cgroup res_counter
Message-ID: <20140905135507.GE25641@esperanza>
References: <1409921037-21405-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409921037-21405-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 08:43:57AM -0400, Johannes Weiner wrote:
> Dave Hansen reports a massive scalability regression in an uncontained
> page fault benchmark with more than 30 concurrent threads, which he
> bisected down to 05b843012335 ("mm: memcontrol: use root_mem_cgroup
> res_counter") and pin-pointed on res_counter spinlock contention.
> 
> That change relied on the per-cpu charge caches to mostly swallow the
> res_counter costs, but it's apparent that the caches don't scale yet.
> 
> Revert memcg back to bypassing res_counters on the root level in order
> to restore performance for uncontained workloads.
> 
> Reported-by: Dave Hansen <dave@sr71.net>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Tested-by: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

It's a pity we have to revert this nice cleanup, but seems we can't do
anything better right now. FWIW,

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
