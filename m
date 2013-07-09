Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3GIQQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:16:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47126 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3GIQQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:16:44 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Eric Biederman <ebiederm@xmission.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH REPOST] kexec: return error of machine_kexec() fails
Date: Tue,  9 Jul 2013 10:16:37 -0600
Message-Id: <1373386597-3884-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
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
---
 kernel/kexec.c | 2 ++
 1 file changed, 2 insertions(+)

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
1.8.1.5

