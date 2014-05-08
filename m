Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaEHKdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:33:45 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60458 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753270AbaEHKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:33:42 -0400
X-IronPort-AV: E=Sophos;i="4.97,1010,1389715200"; 
   d="scan'208";a="30251494"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] sched/prio: Add two inline function named nice_to_rlimit() and rlimit_to_nice() in prio.h.
Date: Thu, 8 May 2014 18:33:48 +0900
Message-ID: <e1f9c9f2023719e0738e16cd6807c74c68b08fad.1399532322.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add two inline functions named nice_to_rlimit() and rlimit_to_nice() in prio.h.
They are handle the convertion between nice value [19,-20] and rlimit style value [1,40].

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 include/linux/sched/prio.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index ac32258..d9cf5a5 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -41,4 +41,20 @@
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 
+/*
+ * Convert nice value [19,-20] to rlimit style value [1,40].
+ */
+static inline long nice_to_rlimit(long nice)
+{
+	return (MAX_NICE - nice + 1);
+}
+
+/*
+ * Convert rlimit style value [1,40] to nice value [-20, 19].
+ */
+static inline long rlimit_to_nice(long prio)
+{
+	return (MAX_NICE - prio + 1);
+}
+
 #endif /* _SCHED_PRIO_H */
-- 
1.8.2.1

