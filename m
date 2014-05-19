Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbaESNOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:14:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59462 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbaESNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:11:07 -0400
Date: Mon, 19 May 2014 06:10:14 -0700
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-b482e5f5c22ef95ffe7c4d86fc9719455fb24bca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <e1f9c9f2023719e0738e16cd6807c74c68b08fad.1399532322.git.yangds.fnst@cn.fujitsu.com>
References: <e1f9c9f2023719e0738e16cd6807c74c68b08fad.1399532322.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/prio:
  Add two inline function named nice_to_rlimit() and rlimit_to_nice()
  in prio.h.
Git-Commit-ID: b482e5f5c22ef95ffe7c4d86fc9719455fb24bca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b482e5f5c22ef95ffe7c4d86fc9719455fb24bca
Gitweb:     http://git.kernel.org/tip/b482e5f5c22ef95ffe7c4d86fc9719455fb24bca
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Thu, 8 May 2014 18:33:48 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:42 +0900

sched/prio: Add two inline function named nice_to_rlimit() and rlimit_to_nice() in prio.h.

This patch add two inline functions named nice_to_rlimit() and
rlimit_to_nice() in prio.h.  They are handle the convertion between
nice value [19,-20] and rlimit style value [1,40].

Cc: mingo@redhat.com
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/e1f9c9f2023719e0738e16cd6807c74c68b08fad.1399532322.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
