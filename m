Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaCWSsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:48:20 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40289 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaCWSsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:48:19 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: tj@kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: Use RCU_INIT_POINTER(x, NULL) in cgroup.c
Date: Mon, 24 Mar 2014 00:17:18 +0530
Message-Id: <1395600438-9838-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 105f273..3462f62 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4033,7 +4033,7 @@ static void css_release(struct percpu_ref *ref)
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	rcu_assign_pointer(css->cgroup->subsys[css->ss->subsys_id], NULL);
+	RCU_INIT_POINTER(css->cgroup->subsys[css->ss->subsys_id], NULL);
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
 
-- 
1.7.9.5

