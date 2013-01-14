Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3ANJYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:24:31 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:27821 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3ANJY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:24:29 -0500
Message-ID: <50F3CEC2.1020909@huawei.com>
Date: Mon, 14 Jan 2013 17:24:18 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Colin Cross <ccross@google.com>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cgroup: remove synchronize_rcu() from rebind_subsystems()
References: <50F3CE8E.5000402@huawei.com>
In-Reply-To: <50F3CE8E.5000402@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing's protected by RCU in rebind_subsystems(), and I can't think
of a reason why it is needed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 67b0fa0..f43c929 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1079,7 +1079,6 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 		}
 	}
 	root->subsys_mask = root->actual_subsys_mask = final_subsys_mask;
-	synchronize_rcu();
 
 	return 0;
 }
-- 
1.8.0.2

