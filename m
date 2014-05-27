Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaE0Vjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:39:53 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51726 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaE0Vju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:39:50 -0400
Date: Tue, 27 May 2014 14:38:40 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH mmotm/next]
 vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o
 om-control-fix.patch
In-Reply-To: <alpine.LSU.2.11.1405271432400.4485@eggly.anvils>
Message-ID: <alpine.LSU.2.11.1405271436200.4485@eggly.anvils>
References: <alpine.LSU.2.11.1405271432400.4485@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_swappiness() oopses immediately when
booted with cgroup_disable=memory.  Fix that in the obvious inelegant
way for now - though I hope we are moving towards a world in which
almost all of the mem_cgroup_disabled() tests will vanish, with a
root_mem_cgroup which can handle the basics even when disabled.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm/mm/memcontrol.c	2014-05-21 18:12:18.072022438 -0700
+++ linux/mm/memcontrol.c	2014-05-21 19:34:30.608546905 -0700
@@ -1531,7 +1531,7 @@ static unsigned long mem_cgroup_margin(s
 int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	/* root ? */
-	if (!memcg->css.parent)
+	if (mem_cgroup_disabled() || !memcg->css.parent)
 		return vm_swappiness;
 
 	return memcg->swappiness;
