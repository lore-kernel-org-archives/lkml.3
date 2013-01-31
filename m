Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3AaJ1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:27:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:29812 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3AaJ1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:27:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,575,1355126400"; 
   d="scan'208";a="278976812"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH 3/3] nsproxy: remove duplicate task_cred_xxx for user_ns
Date: Thu, 31 Jan 2013 17:28:32 +0800
Message-Id: <1359624512-23469-3-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359624512-23469-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1359624512-23469-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use user_ns, which is also assigned from task_cred_xxx(tsk,
user_ns), at the beginning of copy_namespaces().

Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/nsproxy.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 78e2ecb..b781e66 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -153,8 +153,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 		goto out;
 	}
 
-	new_ns = create_new_namespaces(flags, tsk,
-				       task_cred_xxx(tsk, user_ns), tsk->fs);
+	new_ns = create_new_namespaces(flags, tsk, user_ns, tsk->fs);
 	if (IS_ERR(new_ns)) {
 		err = PTR_ERR(new_ns);
 		goto out;
-- 
1.7.7.6

