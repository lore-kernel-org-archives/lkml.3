Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3GXKAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:00:51 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:24037 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3GXKAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:00:50 -0400
Message-ID: <51EFA59B.9070409@huawei.com>
Date: Wed, 24 Jul 2013 17:59:55 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v2 2/8] cgroup: document how cgroup IDs are assigned
References: <51EFA554.6080801@huawei.com>
In-Reply-To: <51EFA554.6080801@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As cgroup id has been used in netprio cgroup and will be used in memcg,
it's important to make it clear how a cgroup id is allocated.

For example, in netprio cgroup, the id is used as index of an array.

Signed-off-by: Li Zefan <lizefan@huwei.com>
---
 include/linux/cgroup.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2bd052d..8c107e9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -161,7 +161,13 @@ struct cgroup_name {
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
-	int id;				/* idr allocated in-hierarchy ID */
+	/*
+	 * idr allocated in-hierarchy ID.
+	 *
+	 * The ID of the root cgroup is always 0, and a new cgroup
+	 * will be assigned with a smallest available ID.
+	 */
+	int id;
 
 	/*
 	 * We link our 'sibling' struct into our parent's 'children'.
-- 
1.8.0.2

