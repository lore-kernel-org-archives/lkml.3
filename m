Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3GKWDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:03:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3GKWBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:01:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 19/19] Revert "memcg: avoid dangling reference count in creation failure"
Date: Thu, 11 Jul 2013 15:01:36 -0700
Message-Id: <20130711214832.785223221@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711214830.611455274@linuxfoundation.org>
References: <20130711214830.611455274@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit fa460c2d37870e0a6f94c70e8b76d05ca11b6db0 upstream.

This reverts commit e4715f01be697a.

mem_cgroup_put is hierarchy aware so mem_cgroup_put(memcg) already drops
an additional reference from all parents so the additional
mem_cgrroup_put(parent) potentially causes use-after-free.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6303,8 +6303,6 @@ mem_cgroup_css_online(struct cgroup *con
 		 * call __mem_cgroup_free, so return directly
 		 */
 		mem_cgroup_put(memcg);
-		if (parent->use_hierarchy)
-			mem_cgroup_put(parent);
 	}
 	return error;
 }


