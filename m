Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab3JKJwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:52:08 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:42994 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab3JKJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:52:04 -0400
Message-ID: <5257CA3A.2040705@huawei.com>
Date: Fri, 11 Oct 2013 17:51:54 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 11/12] cpuset: allow writing offlined masks to cpuset.cpus/mems
References: <5257C9A1.1030404@huawei.com>
In-Reply-To: <5257C9A1.1030404@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the configured masks won't be limited by its parent, and the top
cpuset's masks won't change when hotplug happens, it's natural to
allow writing offlined masks to the configured masks.

Signed-off-by; Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e71c04f..a98723d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -960,7 +960,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (retval < 0)
 			return retval;
 
-		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
+		if (!cpumask_subset(trialcs->cpus_allowed,
+				    top_cpuset.cpus_allowed))
 			return -EINVAL;
 	}
 
@@ -1238,8 +1239,8 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			goto done;
 
 		if (!nodes_subset(trialcs->mems_allowed,
-				node_states[N_MEMORY])) {
-			retval =  -EINVAL;
+				  top_cpuset.mems_allowed)) {
+			retval = -EINVAL;
 			goto done;
 		}
 	}
-- 
1.8.0.2

