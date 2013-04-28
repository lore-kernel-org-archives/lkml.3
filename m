Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3D1BrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 21:47:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27271 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3D1BrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 21:47:08 -0400
Message-ID: <517C7F91.2030705@huawei.com>
Date: Sun, 28 Apr 2013 09:46:57 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] cpuset: fix compile warning when CONFIG_SMP=n
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by Fengguang's kbuild test robot:

kernel/cpuset.c:787: warning: 'generate_sched_domains' defined but not used

Introduced by commit e0e80a02e5701c8790bd348ab59edb154fbda60b
("cpuset: use rebuild_sched_domains() in cpuset_hotplug_workfn()),
which removed generate_sched_domains() from cpuset_hotplug_workfn().

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ef05901..2422c5b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -789,13 +789,6 @@ out:
 static void rebuild_sched_domains_locked(void)
 {
 }
-
-static int generate_sched_domains(cpumask_var_t **domains,
-			struct sched_domain_attr **attributes)
-{
-	*domains = NULL;
-	return 1;
-}
 #endif /* CONFIG_SMP */
 
 void rebuild_sched_domains(void)
-- 
1.8.0.2
