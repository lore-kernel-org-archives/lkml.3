Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaENAHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 20:07:33 -0400
Received: from [162.105.203.56] ([162.105.203.56]:53464 "EHLO
	mail.sei.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaENAHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 20:07:30 -0400
From: "Yuan Pengfei" <yuanpf12@sei.pku.edu.cn>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Peter Oberparleiter'" <oberpar@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] gcov: add support for GCC 4.9
Date: Wed, 14 May 2014 08:07:16 +0800
Message-ID: <000501cf6f08$7735a6a0$65a0f3e0$@sei.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: Ac9vCCKjbUIdLB2dSUabz9YrO0DW/A==
Content-Language: zh-cn
X-Spam_score: -102.9
X-Spam_score_int: -1028
X-Spam_bar: ---------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan Pengfei <coolypf@qq.com>

This patch handles the gcov-related changes in GCC 4.9:
  A new counter (time profile) is added. The total number is 9 now.
  A new profile merge function __gcov_merge_time_profile is added.
See gcc/gcov-io.h and libgcc/libgcov-merge.c
For the first change, the layout of struct gcov_info is affected.
For the second one, a dummy function is added to kernel/gcov/base.c
similarly.
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


