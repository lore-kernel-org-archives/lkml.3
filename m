Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaG3HHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:07:22 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:21095 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaG3HHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:07:20 -0400
Message-ID: <53D899A1.3080003@huawei.com>
Date: Wed, 30 Jul 2014 15:07:13 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mike Qiu <qiudayu@linux.vnet.ibm.com>, cgroups <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: fix the WARN_ON() in update_nodemasks_hier()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.53D899A6.00BE,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 249cb3b18c434db4fd0e636e65390a45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WARN_ON() is used to check if we break the legal hierarchy, on
which the effective mems should be equal to configured mems.

Reported-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Tested-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 53a9bbf..baa155c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1136,7 +1136,7 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 		mutex_unlock(&callback_mutex);
 
 		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
-			nodes_equal(cp->mems_allowed, cp->effective_mems));
+			!nodes_equal(cp->mems_allowed, cp->effective_mems));
 
 		update_tasks_nodemask(cp);
 
-- 
1.8.0.2

