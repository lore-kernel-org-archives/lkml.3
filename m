Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3HMBR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:17:59 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6181 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab3HMBR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:17:57 -0400
Message-ID: <52098941.4070600@huawei.com>
Date: Tue, 13 Aug 2013 09:17:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cpuset: remove redundant checks in file write functions
References: <5209892D.8070502@huawei.com>
In-Reply-To: <5209892D.8070502@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now cgroup core gets a reference to the css when a cgroup file is
opened(), and the reference is dropped at file release. so it's
guaranteed the cpuset is online during the write function.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9d8d637..8c4b3c4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1589,8 +1589,6 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	int retval = -ENODEV;
 
 	mutex_lock(&cpuset_mutex);
-	if (!is_cpuset_online(cs))
-		goto out_unlock;
 
 	switch (type) {
 	case FILE_CPU_EXCLUSIVE:
@@ -1624,7 +1622,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 		retval = -EINVAL;
 		break;
 	}
-out_unlock:
+
 	mutex_unlock(&cpuset_mutex);
 	return retval;
 }
@@ -1637,8 +1635,6 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	int retval = -ENODEV;
 
 	mutex_lock(&cpuset_mutex);
-	if (!is_cpuset_online(cs))
-		goto out_unlock;
 
 	switch (type) {
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
@@ -1648,7 +1644,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 		retval = -EINVAL;
 		break;
 	}
-out_unlock:
+
 	mutex_unlock(&cpuset_mutex);
 	return retval;
 }
@@ -1677,8 +1673,6 @@ static int cpuset_write_resmask(struct cgroup_subsys_state *css,
 	flush_work(&cpuset_hotplug_work);
 
 	mutex_lock(&cpuset_mutex);
-	if (!is_cpuset_online(cs))
-		goto out_unlock;
 
 	trialcs = alloc_trial_cpuset(cs);
 	if (!trialcs) {
-- 
1.8.0.2
