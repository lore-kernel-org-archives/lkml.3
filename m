Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaCKJWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:22:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3025 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbaCKJWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:22:52 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677978"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 07/16] ioprio: Add a macro named NICE_TO_IOPRIO.
Date: Tue, 11 Mar 2014 17:20:28 +0800
Message-Id: <008cf8bba167646424d0fca68d96463feace2aee.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:20:07,
	Serialize complete at 2014/03/11 17:20:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the task nice value is in [-20, 19] and the io priority is in [0, 7],
and the convert method from niceval to ioprio is implemented with an
opened code in task_nice_ioprio().

This patch move the implementation to a macro NICE_TO_IOPRIO, making
it more readable and modular.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 include/linux/ioprio.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index beb9ce1..c0faa0b 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -18,6 +18,11 @@
 #define ioprio_valid(mask)	(IOPRIO_PRIO_CLASS((mask)) != IOPRIO_CLASS_NONE)
 
 /*
+ * Convert the nice value [19,-20] to io priority value [0,7].
+ */
+#define NICE_TO_IOPRIO(nice)	(nice_to_rlimit(nice) / 5)
+
+/*
  * These are the io priority groups as implemented by CFQ. RT is the realtime
  * class, it always gets premium service. BE is the best-effort scheduling
  * class, the default for any process. IDLE is the idle scheduling class, it
@@ -52,7 +57,7 @@ enum {
  */
 static inline int task_nice_ioprio(struct task_struct *task)
 {
-	return (task_nice(task) + 20) / 5;
+	return NICE_TO_IOPRIO(task_nice(task));
 }
 
 /*
-- 
1.8.2.1

