Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaAQIMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:12:23 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49193 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaAQIMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:12:22 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH] audit: Modify a set of system calls in audit class definitions
Date: Fri, 17 Jan 2014 17:12:07 +0900
Message-Id: <1389946327-4476-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each asm-generic/audit_xx.h defines a set of system calls for respective
audit permssion class (read, write, change attribute or exec).
This patch changes two entries:

1) fchown in audit_change_attr.h
  Make fchown included by its own because in asm-generic/unistd.h, for example,
  fchown always exists while chown is optional. This change is necessary at
  least for arm64.

2) truncate64 in audit_write.h
  Add missing truncate64/ftruncate64 as well as truncate/ftruncate

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 include/asm-generic/audit_change_attr.h |    4 +++-
 include/asm-generic/audit_write.h       |    6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/audit_change_attr.h b/include/asm-generic/audit_change_attr.h
index 89b73e5..a186553 100644
--- a/include/asm-generic/audit_change_attr.h
+++ b/include/asm-generic/audit_change_attr.h
@@ -4,9 +4,11 @@ __NR_chmod,
 __NR_fchmod,
 #ifdef __NR_chown
 __NR_chown,
-__NR_fchown,
 __NR_lchown,
 #endif
+#ifdef __NR_fchown
+__NR_fchown,
+#endif
 __NR_setxattr,
 __NR_lsetxattr,
 __NR_fsetxattr,
diff --git a/include/asm-generic/audit_write.h b/include/asm-generic/audit_write.h
index e7020c5..274575d 100644
--- a/include/asm-generic/audit_write.h
+++ b/include/asm-generic/audit_write.h
@@ -10,6 +10,12 @@ __NR_truncate,
 #ifdef __NR_truncate64
 __NR_truncate64,
 #endif
+#ifdef __NR_ftruncate
+__NR_ftruncate,
+#endif
+#ifdef __NR_ftruncate64
+__NR_ftruncate64,
+#endif
 #ifdef __NR_bind
 __NR_bind,		/* bind can affect fs object only in one way... */
 #endif
-- 
1.7.9.5

