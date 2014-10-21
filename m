Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbaJUVGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:06:00 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42553 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbaJUVF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:05:59 -0400
Date: Tue, 21 Oct 2014 17:05:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] mm: memcontrol: simplify per-memcg page statistics
 accounting
Message-ID: <20141021210554.GC29116@phnom.home.cmpxchg.org>
References: <1413922896-29042-1-git-send-email-hannes@cmpxchg.org>
 <1413922896-29042-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413922896-29042-4-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:21:36PM -0400, Johannes Weiner wrote:
> @@ -315,13 +290,13 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  {
>  }
>  
> -static inline void mem_cgroup_begin_update_page_stat(struct page *page,
> +static inline void mem_cgroup_begin_page_stat(struct page *page,
>  					bool *locked, unsigned long *flags)

I forgot to refresh after fixing the allnoconfig build.  Andrew could
you fold the following please if/when merging this patch?  Thanks!

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4dc4a2aec440..ea007615e8f9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -290,9 +290,10 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
 }
 
-static inline void mem_cgroup_begin_page_stat(struct page *page,
+static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
 					bool *locked, unsigned long *flags)
 {
+	return NULL;
 }
 
 static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg,
