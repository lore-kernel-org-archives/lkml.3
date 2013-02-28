Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab3B1Os6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:48:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42240 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab3B1Osu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, davej@redhat.com, keescook@chromium.org,
        ebiederm@xmission.com, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 065/139] futex: Revert "futex: Mark get_robust_list as deprecated"
Date: Thu, 28 Feb 2013 14:43:35 +0000
Message-Id: <1362062689-2567-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit fe2b05f7ca9f906be61dced5489f63b8b4d7c770 upstream.

This reverts commit ec0c4274e33c0373e476b73e01995c53128f1257.

get_robust_list() is in use and a removal would break existing user
space. With the permission checks in place it's not longer a security
hole. Remove the deprecation warnings.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org
Cc: paul.gortmaker@windriver.com
Cc: davej@redhat.com
Cc: keescook@chromium.org
Cc: ebiederm@xmission.com
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/futex.c        | 2 --
 kernel/futex_compat.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 19eb089..8879430 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2471,8 +2471,6 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
-
 	rcu_read_lock();
 
 	ret = -ESRCH;
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 83e368b..a9642d5 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -142,8 +142,6 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
-
 	rcu_read_lock();
 
 	ret = -ESRCH;
-- 
1.8.1.2

