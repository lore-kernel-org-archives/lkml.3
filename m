Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab3G0D5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 23:57:14 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:31933 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3G0D5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 23:57:10 -0400
Message-ID: <51F34505.9010505@huawei.com>
Date: Sat, 27 Jul 2013 11:56:53 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: <tj@kernel.org>, <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] cpuset: correct the disoder comment of two functions
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

correct the disoder comment between cpuset_css_offline() and
cpuset_css_free() functions.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 kernel/cpuset.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 2ddd9b9..703bfd5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2020,6 +2020,12 @@ out_unlock:
 	return 0;
 }
 
+/*
+ * If the cpuset being removed has its flag 'sched_load_balance'
+ * enabled, then simulate turning sched_load_balance off, which
+ * will call rebuild_sched_domains_locked().
+ */
+
 static void cpuset_css_offline(struct cgroup *cgrp)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
@@ -2035,12 +2041,6 @@ static void cpuset_css_offline(struct cgroup *cgrp)
 	mutex_unlock(&cpuset_mutex);
 }
 
-/*
- * If the cpuset being removed has its flag 'sched_load_balance'
- * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains_locked().
- */
-
 static void cpuset_css_free(struct cgroup *cgrp)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
-- 
1.8.2.2

