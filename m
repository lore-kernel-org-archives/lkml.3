Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaCKJWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:22:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65276 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbaCKJWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:22:46 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677974"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 01/16] sched/prio: Add a inline function named nice_to_rlimit() in prio.h.
Date: Tue, 11 Mar 2014 17:20:22 +0800
Message-Id: <345bcc1d5b9184c26c1d96ad22dda926d32e2c81.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:19:58,
	Serialize complete at 2014/03/11 17:19:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an inline function named nice_to_rlimit() in prio.h to
convert nice value [19,-20] to rlimit style value [1,40].

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 include/linux/sched/prio.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index ac32258..c15cbda 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -41,4 +41,12 @@
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 
+/*
+ * Convert nice value [19,-20] to rlimit style value [1,40].
+ */
+static inline nice_to_rlimit(long nice)
+{
+	return (MAX_NICE - nice + 1);
+}
+
 #endif /* _SCHED_PRIO_H */
-- 
1.8.2.1

