Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaCKKLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:11:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaCKKLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:23 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678271"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 01/17] sched/prio: Add a inline function named nice_to_rlimit() in prio.h.
Date: Tue, 11 Mar 2014 18:09:09 +0800
Message-Id: <5ea9bc191ef5f47bef0623e2e11db24e4ea281c2.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:35,
	Serialize complete at 2014/03/11 18:08:35
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
index ac32258..29756f8 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -41,4 +41,12 @@
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
 #endif /* _SCHED_PRIO_H */
-- 
1.8.2.1

