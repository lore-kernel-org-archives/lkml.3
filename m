Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3FEJQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:16:50 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:16550 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3FEJQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:16:36 -0400
Message-ID: <51AF019F.4050002@huawei.com>
Date: Wed, 5 Jun 2013 17:15:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH v2 01/10] cpuset: remove redundant check in cpuset_cpus_allowed_fallback()
References: <51AF0183.8070602@huawei.com>
In-Reply-To: <51AF0183.8070602@huawei.com>
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
index 64b3f79..f0c884a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2253,8 +2253,7 @@ void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 
 	rcu_read_lock();
 	cs = task_cs(tsk);
-	if (cs)
-		do_set_cpus_allowed(tsk, cs->cpus_allowed);
+	do_set_cpus_allowed(tsk, cs->cpus_allowed);
 	rcu_read_unlock();
 
 	/*
-- 
1.8.0.2
