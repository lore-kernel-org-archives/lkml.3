Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbaEMAbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:31:52 -0400
Received: from [162.105.203.56] ([162.105.203.56]:38684 "EHLO
	mail.sei.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaEMAbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:31:49 -0400
From: "Yuan Pengfei" <yuanpf12@sei.pku.edu.cn>
To: "'Peter Oberparleiter'" <oberpar@linux.vnet.ibm.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] gcov: add support for GCC 4.9
Date: Tue, 13 May 2014 08:31:36 +0800
Message-ID: <000d01cf6e42$b2fac6f0$18f054d0$@sei.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: Ac9uQmeQcCd5NwO5Q9qwdPyaBXrgEw==
Content-Language: zh-cn
X-Spam_score: -102.9
X-Spam_score_int: -1028
X-Spam_bar: ---------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan Pengfei <coolypf@qq.com>

This patch handles the gcov-related changes in GCC 4.9:
  A new counter (time profile) is added.
See http://gcc.gnu.org/gcc-4.9/changes.html
Signed-off-by: Yuan Pengfei <coolypf@qq.com>
---
 kernel/gcov/base.c    | 6 ++++++
 kernel/gcov/gcc_4_7.c | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/kernel/gcov/base.c b/kernel/gcov/base.c
index f45b75b..b358a80 100644
--- a/kernel/gcov/base.c
+++ b/kernel/gcov/base.c
@@ -85,6 +85,12 @@ void __gcov_merge_ior(gcov_type *counters, unsigned int
n_counters)
 }
 EXPORT_SYMBOL(__gcov_merge_ior);
 
+void __gcov_merge_time_profile(gcov_type *counters, unsigned int
n_counters)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_time_profile);
+
 /**
  * gcov_enable_events - enable event reporting through gcov_event()
  *
diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index 7465944..7f74b59 100644
--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,12 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
+#if __GNUC__ == 4 && __GNUC_MINOR__ >= 9
+#define GCOV_COUNTERS			9
+#else
 #define GCOV_COUNTERS			8
+#endif
+
 #define GCOV_TAG_FUNCTION_LENGTH	3
 
 static struct gcov_info *gcov_info_head;
-- 
2.0.0.rc2


