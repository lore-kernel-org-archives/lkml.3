Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030345Ab3DSMZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:25:41 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45601 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030195Ab3DSMZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:25:39 -0400
Message-ID: <517137BD.4060203@huawei.com>
Date: Fri, 19 Apr 2013 20:25:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 01/10] cpuset: remove redundant check in cpuset_cpus_allowed_fallback()
References: <517137A7.4020605@huawei.com>
In-Reply-To: <517137A7.4020605@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_cs() will never return NULL.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 866d78e..4a62dcc 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2259,8 +2259,7 @@ void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 
 	rcu_read_lock();
 	cs = task_cs(tsk);
-	if (cs)
-		do_set_cpus_allowed(tsk, cs->cpus_allowed);
+	do_set_cpus_allowed(tsk, cs->cpus_allowed);
 	rcu_read_unlock();
 
 	/*
-- 
1.8.0.2

