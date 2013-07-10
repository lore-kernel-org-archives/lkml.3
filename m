Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3GJBzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 21:55:24 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:49593 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3GJBzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 21:55:23 -0400
From: Simon Horman <horms@verge.net.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, kexec@lists.infradead.org,
        Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kexec: return error of machine_kexec() fails
Date: Wed, 10 Jul 2013 10:54:56 +0900
Message-Id: <1373421296-6112-1-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Prior to commit 3ab8352 "kexec jump", if machine_kexec() returned,
sys_reboot() would return -EINVAL. This patch restores this behaviour
for the non-KEXEC_JUMP case, where machine_kexec() is not expected to
return.

This situation can occur on ARM, where kexec requires disabling all but
one CPU using CPU hotplug. However, if hotplug isn't supported by the
particular HW the kernel is running on, then kexec cannot succeed.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Simon Horman <horms@verge.net.au>
---
 kernel/kexec.c | 2 ++
 1 file changed, 2 insertions(+)

Andrew, could you consider picking up this patch?

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f7b55..bde1190 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1702,6 +1702,8 @@ int kernel_kexec(void)
 		pm_restore_console();
 		unlock_system_sleep();
 	}
+#else
+	error = -EINVAL;
 #endif
 
  Unlock:
-- 
1.8.2.1

