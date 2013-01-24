Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3AXGon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:44:43 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:61202 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3AXGoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:44:38 -0500
Message-ID: <5100D827.20807@huawei.com>
Date: Thu, 24 Jan 2013 14:43:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] cgroup: remove a NULL check in cgroup_exit()
References: <5100D810.5020406@huawei.com>
In-Reply-To: <5100D810.5020406@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_task.cgroups is initialized at boot phase, and whenver a ask
is forked, it's cgroups pointer is inherited from its parent, and
it's never set to NULL afterwards.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 09c5869..5d4c92e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5011,8 +5011,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	}
 	task_unlock(tsk);
 
-	if (cg)
-		put_css_set_taskexit(cg);
+	put_css_set_taskexit(cg);
 }
 
 /**
-- 
1.8.0.2
